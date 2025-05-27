import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.apollo.config import *
dir_path = dirname(abspath(__file__))

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

insertion_error_dir_aircontrol = os.path.join(dir_path,'Insertion_Error')
procedure_error_dir_aircontrol = os.path.join(dir_path,'Procedure_Error_Aircontrol')
insertion_error_dir_router = os.path.join(dir_path,'Insertion_Error')
procedure_error_dir_router = os.path.join(dir_path,'Procedure_Error_Router')



logs = {
    "migration_info_logger":f"stc_ingestion_product_catalogue_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_ingestion_product_catalogue_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()



def read_csv(file_path, encoding='utf-8'):
    try:
        return pd.read_csv(file_path, encoding=encoding)
    except FileNotFoundError:
        print(f"CSV file '{file_path}' not found.")
        raise

def validate_columns(df, expected_columns):
    if not all(col in df.columns for col in expected_columns):
        print("CSV columns do not match the expected format.")
        raise ValueError("CSV columns do not match the expected format.")

# Main function
def main(db_config,zone_group_data,zone_product_data,entitlement_data,discount_data):
    try:
       
        # Connect to MySQL database
        conn = mysql_connection(db_config["DATABASE"], db_config["HOST"], db_config["USER"], db_config['PASSWORD'],
                         db_config["PORT"])
        cursor = conn.cursor()
        try:
            # Read and process zone group data
            df_zone_group = read_csv(zone_group_data, encoding='latin1')
            if 'ZONE_TYPE' in df_zone_group.columns:
                df_zone_group['ZONE_TYPE'] = df_zone_group['ZONE_TYPE'].str.upper()
            else:
                logger_error.error("Error: 'ZONE_TYPE' column not found in CSV file.")
                return

            df_zone_group.rename(columns={'Countries': 'COUNTRY_NAME'}, inplace=True)
            # for col in ['ZONE_GROUP_NAME', 'ZONE_NAME']:
            #     if (df_zone_group[col].str.len() > 100).any():
            #         logger_error.error(f"Error: Some {col} values exceed 100 characters.")
            #         return

            for _, row in df_zone_group.iterrows():
                cursor.execute("SELECT OPCO_ID FROM opco WHERE OPCO_NAME = %s", (row['OPCO_NAME'],))
                opco_id_result = cursor.fetchone()
                if not opco_id_result:
                    logger_error.error(f"OPCO_ID for OPCO_NAME '{row['OPCO_NAME']}' does not exist.")
                    return
            opco_id=opco_id_result[0]
            

                
            df_zone_group['opco_id']=opco_id
            insert_batches_df_into_mysql(df_zone_group, db_config, 'temp_zonegroup_zone_country',logger_info, logger_error)
            

            for procedure in ['InsertDistinctZoneGroups', 'InsertDistinctZones', 'ProcessZoneGroupZoneCountry']:
                call_procedure(procedure, db_config, logger_error, logger_info)
        except Exception as e:
            logger_error.error(f"Unexpected error in zone_group_data: {e}")   
        try:
            df_zone_product = read_csv(zone_product_data, encoding='latin1')
            df_zone_product.replace({np.nan: ''}, inplace=True)
            # expected_columns = [
            #     'ZoneName', 'ProductName', 'ProductType', 'ProductService', 'ProductSubservice',
            #     'GLCODE', 'Status', 'RoundFactorValue', 'PricingSpecName', 'UOM',
            #     'Amount', 'price_type', 'CURRENCY_CODE'
            # ]
            # validate_columns(df_zone_product, expected_columns)
            # df_zone_product.replace({np.nan: ''}, inplace=True)

            # for col in ['ZoneName', 'ProductName', 'PricingSpecName']:
            #     if (df_zone_product[col].str.len() > 100).any():
            #         logger_error.error(f"Error: Some {col} values exceed 100 characters.")
            #         return
            df_zone_product['opco_id']=opco_id
            

            insert_batches_df_into_mysql(df_zone_product, db_config, 'temp_zone_product_pricing',logger_info, logger_error)
            
            for _, row in df_zone_product.iterrows():
                cursor.execute("SELECT COUNT(*) FROM pricing_spec WHERE PRICE_SPEC_NAME = %s AND OPCO_ID = %s", (row['PricingSpecName'], opco_id))
                if cursor.fetchone()[0] == 0:
                    call_procedure('InsertDistinctPricingSpec', db_config, logger_error, logger_info)
                    
                else:
                    call_procedure('ProcessTempZoneProductPricing', db_config, logger_error, logger_info)
                conn.commit()
        except Exception as e:
            logger_error.error(f"Unexpected error in zone_product_data: {e}" )  
        try:
            #######################entitlement_data_load#############
            df_entitlement = pd.read_csv(entitlement_data, encoding='latin1')
            df_entitlement['opco_id']=opco_id
            insert_batches_df_into_mysql(df_entitlement, db_config, 'temp_entitlement_data',logger_info, logger_error)
            call_procedure('ValidateAndInsertEntitlement',db_config, logger_error, logger_info)
        except Exception as e:
            logger_error.error(f"Unexpected error in entitlement_data: {e}"  )

        #########################################Dicount_type     
        try:
            df_discount = pd.read_csv(discount_data, encoding='latin1')
            # Clean and validate columns
            df_discount.columns = df_discount.columns.str.strip()  # Strip any leading/trailing whitespace
            df_discount.columns = df_discount.columns.str.replace('ï»¿', '')  # Remove any BOM characters
            df_discount.columns = df_discount.columns.str.replace('Â\xa0', '')  # Remove any extra characters
            df_discount.columns = df_discount.columns.str.replace('Â', '')  # Remove any extra characters
            df_discount.columns = df_discount.columns.str.replace(r'[^a-zA-Z0-9_]', '', regex=True)  # Remove non-alphanumeric characters except underscores
            df_discount['opco_id']=opco_id
            df_discount['REMARK']=''
            insert_batches_df_into_mysql(df_discount, db_config, 'temp_discount_data',logger_info, logger_error)
            call_procedure('ValidateAndInsertDiscount',db_config, logger_error, logger_info)
        except Exception as e:
            logger_error.error(f"Unexpected error in entitlement_data: {e}"  )

        
    except mysql.connector.Error as err:
        logger_error.error(f"MySQL error: {err}")
    except Exception as e:
        logger_error.error(f"Unexpected error: {e}")
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    table_temp_zonegroup_zone_country='temp_zonegroup_zone_country'
    create_table_temp_zonegroup_zone_country =f"""
        CREATE TABLE {table_temp_zonegroup_zone_country} (
            ID INT AUTO_INCREMENT PRIMARY KEY,
            ZONE_GROUP_NAME VARCHAR(100) NOT NULL,
            ZONE_NAME VARCHAR(100) NOT NULL,
            ZONE_TYPE VARCHAR(20) NOT NULL,
            COUNTRY_NAME VARCHAR(255) NOT NULL,
            OPCO_NAME VARCHAR(50) NOT NULL,
            remark VARCHAR(255),
            OPCO_ID INT,
            IS_ENABLED TINYINT(1) NOT NULL DEFAULT 1
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        """
    table_temp_zone_product_pricing='temp_zone_product_pricing'
    create_table_temp_zone_product_pricing =f"""
        CREATE TABLE {table_temp_zone_product_pricing} (
            ZoneName VARCHAR(255),
            ProductName VARCHAR(255),
            ProductType VARCHAR(255),
            ProductService VARCHAR(255),
            ProductSubservice VARCHAR(255),
            GLCODE VARCHAR(255),
            Status VARCHAR(50),
            RoundFactorValue VARCHAR(50),
            Start_date DATE DEFAULT (CURRENT_DATE),
            PricingSpecName VARCHAR(255),
            UOM VARCHAR(50),
            Amount DECIMAL(20, 6),
            price_type VARCHAR(50),
            CURRENCY_CODE VARCHAR(50),
            remark VARCHAR(255),
            OPCO_ID INT
        )
        """
    table_temp_entitlement_data_load='temp_entitlement_data'
    create_table_entitlement_data_load =f"""
        CREATE TABLE {table_temp_entitlement_data_load} (
            ENTITLEMENT_NAME VARCHAR(255),
            ENTITLEMENT_TYPE VARCHAR(255),
            ENTITLEMENT_QTY DECIMAL(20, 6),
            ENTITLEMENT_UOM VARCHAR(50),
            ENTITLEMENT_INTERVAL VARCHAR(50),
            IS_PAYG_ENABLED BOOLEAN,
            IS_PAYG_CAPPED BOOLEAN,
            PAYG_CAP DECIMAL(20, 6),
            IS_UNLIMITED_QTY BOOLEAN,
            REMARK VARCHAR(255),
            OPCO_ID INT
        )
        """
    
    table_temp_discount_data='temp_discount_data'
    create_table_discount_data =f"""
        CREATE TABLE {table_temp_discount_data} (
            Discount_Name VARCHAR(255),
            PC_Discount_Type VARCHAR(255),
            Discount_Type VARCHAR(255),
            Start_Date DATE DEFAULT (CURRENT_DATE),
            Discount_Category VARCHAR(255),
            Unit_Of_Measure VARCHAR(255),
            Discount_Level VARCHAR(255),
            GL_Code VARCHAR(255),
            Discount_Amount DECIMAL(20,4),
            Is_Override TINYINT,
            Charge_Rule_Name VARCHAR(255),
            Rule_Category VARCHAR(255),
            Rule_Param_Name VARCHAR(255),
            Rule_Value VARCHAR(255),
            Rule_UOM VARCHAR(255),
            Discount_SubCategory VARCHAR(255),
            Charge_Category VARCHAR(255),
            Start_Value INT,
            End_Value INT,
            Rule_Parameter_Name VARCHAR(255),
            Duration VARCHAR(255),
            Frequency VARCHAR(255),
            Retention TINYINT,
            REMARK VARCHAR(255),
            OPCO_ID INT
        )
        """
    create_or_replace_table(product_catalogue, table_temp_zonegroup_zone_country, create_table_temp_zonegroup_zone_country, logger_info, logger_error)
    create_or_replace_table(product_catalogue, table_temp_zone_product_pricing, create_table_temp_zone_product_pricing, logger_info, logger_error)
    create_or_replace_table(product_catalogue,table_temp_entitlement_data_load,create_table_entitlement_data_load, logger_info, logger_error)
    create_or_replace_table(product_catalogue,table_temp_discount_data,create_table_discount_data, logger_info, logger_error)
    main(product_catalogue,zone_group_data,zone_product_data,entitlement_data,dicount_data)
    
