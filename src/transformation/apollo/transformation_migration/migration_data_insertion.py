import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.apollo.config import *
from transform_procedure import *
from collections import defaultdict
today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

insertion_error_dir = os.path.join(dir_path,'insertion_error')
procedure_error_dir = os.path.join(dir_path,'procedure_error_aircontrol')

input_date_formate="%d-%b-%y %I.%M.%S.%f %p"
logs = {
    "migration_info_logger":f"stc_transformation_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_transformation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{transformation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()


############# Generate Error Files for Failed entries during procedure execution
def generate_procedure_error_file(query,db_config,column_names,procedure_error_directory,error_file_name,logger_error,logger_info):
    """
    :param query: query to fetch the result.
    :param db_config: database config details
    :param column_names: column names of the table to generate the file
    :param procedure_error_directory: procedure error directory path
    :param error_file_name: error file name of records failed during procedure execution
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will generate procedure error files
    """
    try:
        fetch_error_success = query
        fetch_error_success_data = sql_query_fetch(fetch_error_success,db_config,logger_error)
        if len(fetch_error_success_data) != 0:
            # Specify the filename for the CSV file (replace 'output.csv' with your desired filename)
            logger_info.error("Error Entries {}".format(fetch_error_success_data))
            logger_error.error("Error Entries {}".format(fetch_error_success_data))
            df_error = pd.DataFrame(fetch_error_success_data, columns=column_names)
            df_error.to_csv(os.path.join(procedure_error_directory, error_file_name), index=False)
        else:
            logger_info.info("No Error data retrieved from the database.")
    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))
        exit(0)

def move_to_history(current_date,source_file):
    """
    Method to move processed file to history
    :param current_date: Migration date time eg 202402260000
    :param source_file: Path of file to be moved
    :return: None
    """

    # Define the source file and history directory
    history_directory = f'{history_file_path_transformation}/{current_date}'

    # Create the history directory if it doesn't exist
    if not os.path.exists(history_directory):
        os.makedirs(history_directory)

    # Move the file to the history directory
    destination_file = os.path.join(history_directory, os.path.basename(source_file))
    os.rename(source_file, destination_file)

    print(f"File moved to history {destination_file}")
    logger_info.info(f"File moved to history {destination_file}")

# def calculate_dp_name(row):
    # """
    # Method to derive new column "dp_name" in Service_Profile_Config_cdp table by formula
    # :param row: Dataframe row
    # :return: column "dp_name" value
    # """
    

#     bundle_name = "Bundle SDV Ind" if "Individual" in row['BUNDLE'] else "Bundle SDV Pl"
#     """
#     dp_name = bundle_name + (' - ' + row['DATA_SIZE'] if not row['DATA_SIZE'] in ('NA', None, '') else '') + (
#         ' ' + str(row['SMS_SIZE']) + ' SMS' if not row['SMS_SIZE'] in ('NA', None, '') else '')
#     """
#     dp_name = (bundle_name + (' - ' + row['DATA_SIZE'] if not row['DATA_SIZE'] in ('NA',None,'') else '') + 
#                (' ' + str(row['SMS_SIZE']) + ' SMS' if not row['SMS_SIZE'] in ('NA',None,'') else '') + 
#                (' - ' + str(row['TARIFF_PLAN_ID']) if not row['TARIFF_PLAN_ID'] in ('NA', None, '') else '')
#                ) 
#     #print("dp_name:",dp_name)
#     return dp_name



def calculate_dp_name_logic(row):
    """
    Method to derive new column "dp_name" in Service_Profile_Config_cdp table by formula
    :param row: Dataframe row
    :return: column "dp_name" value
    """
    bundle_name = "Bundle SDV Ind" if "Individual" in row['BUNDLE'] else "Bundle SDV Pl"
    
    ak_value = (
        (bundle_name + (' - ' + row['DATA_SIZE'] if not row['DATA_SIZE'] in ('NA',None,'') else '') + 
        # (' ' + f"{str(row['SMS_SIZE'])}SMS" if row['SMS_SIZE'] not in ('NA', None, '', '0 SMS') else '') +
        (' ' + f"{str(row['SMS_SIZE'])} SMS"  if not row['SMS_SIZE'] in ('NA',None,'','0 SMS') else '')+
               (' - ' + str(row['TARIFF_PLAN_ID']) if not row['TARIFF_PLAN_ID'] in ('NA', None, '') else '')
        )+
        ((" - weekly" if "weekly" in row['BUNDLE'] else
          " - years" if "years" in row['BUNDLE'] else
          " - Yearly" if "Yearly" in row['BUNDLE'] else "")
         if any(x in row['BUNDLE'] for x in ["weekly", "years", "Yearly"]) else "") +
        ('-' + row['NBIOT_SIZE'] if row['NBIOT_SIZE'] not in ('NA', None, '', '0 MB', '0 MIN') else '-')
    ).strip()
    
    if "Voice" in row['BUNDLE']:
        am_value = (ak_value + "" + row['BUNDLE'][row['BUNDLE'].find("Voice") + len("Voice"):]).strip()
    else:
        am_value = ak_value
    
    if am_value.endswith('-'):
        am_value = am_value[:-1]
        
    return am_value
# print(df)
def parse_datetime(time_string):
    """
    Method to parse date string in format "08-MAR-22 06.17.45.000000000 PM" to datetime object
    :param time_string: input date string in format "08-MAR-22 06.17.45.000000000 PM"
    :return: parsed datetime object
    """
    try:
        time_string_lowercase = time_string[:4] + time_string[4:7].lower() + time_string[7:18] + time_string[-3:]
        format_string = '%d-%b-%y %I.%M.%S %p'
        #print(time_string_lowercase)
        parsed_time = datetime.strptime(time_string_lowercase, format_string)
    except Exception as e:
        parsed_time =datetime.now()

    return parsed_time




def convert_timestamps_for_new_latest(df, columns):
    """
    Converts specified Timestamp columns in the DataFrame to strings and replaces NaT with None.

    Parameters:
    df (pd.DataFrame): DataFrame containing the data to process.
    columns (list): List of column names to be converted.

    Returns:
    pd.DataFrame: DataFrame with converted timestamp columns.
    """
    try:
        for column in columns:
            if column in df.columns:
                try:
                    
                    # Try to convert to datetime using a specific format
                    df[column] = pd.to_datetime(df[column],errors='coerce')
                    # Convert to string format and replace NaT with None
                    df[column] = df[column].apply(lambda x: x.strftime('%Y-%m-%d %H:%M:%S') if not pd.isna(x) else None)
                    logger_info.info(f"Successfully converted column: {column}")
                except Exception as e:
                    logger_error.error(f"Error converting column {column}: {e}")
            else:
                logger_error.error(f"Column {column} not found in DataFrame")
    except Exception as e:
        logger_error.error(f"Error converting timestamp columns: {e}")

    return df





def process_lable_source_data(data_df, logger_info, logger_error):
    """
    Processes data for the 'lable_source' table by splitting, exploding, and transforming specified columns.

    :param data_df: Input DataFrame containing the data for the 'lable_source' table
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :return: Processed DataFrame
    """
    try:
        # Copy the DataFrame to avoid modifying the original one
        data_df_copy = data_df.copy()

        # Columns to be split and exploded
        split_columns = ['CUSTLABEL', 'BULABEL', 'OPCOLABEL']

        # Split the specified columns by commas
        for col in split_columns:
            data_df_copy[col] = data_df_copy[col].str.split(',')
            

        # Save intermediate DataFrame to CSV (for debugging purposes)
        # data_df_copy.to_csv("yo43g.csv", index=False)
        logger_info.info("Intermediate DataFrame saved to yog.csv")
        # print(data_df_copy)

        # Explode each of the specified columns
        for col in split_columns:
            data_df_copy = data_df_copy.explode(col)

        # Save intermediate exploded DataFrame to CSV (for debugging purposes)
        # data_df_copy.to_csv("yog1.csv", index=False)
        logger_info.info("Exploded DataFrame saved to yog1.csv")
        # print(data_df_copy)

        # Create a new DataFrame with specific columns and transformations
        data_df_processed = pd.DataFrame()
        coulms_required=['CREATIONDATE']
        data_df_copy=convert_timestamps_for_new_latest(data_df,coulms_required)
        data_df_processed['CREATIONDATE'] = data_df_copy['CREATIONDATE']
        data_df_processed['IMSI'] = data_df_copy['IMSI']
        data_df_processed['BUID'] = data_df_copy['BU_ID']
        data_df_processed['OPCO_ID'] = data_df_copy['OPCO_ID']
        data_df_processed['EC_ID'] = data_df_copy['EC_ID']
        data_df_processed['CUSTLABEL'] = data_df_copy['CUSTLABEL']
        data_df_processed['BULABEL'] = data_df_copy['BULABEL']
        data_df_processed['OPCOLABEL'] = data_df_copy['OPCOLABEL']

        # Replace NaT values with None
        data_df_processed.replace({pd.NaT: None}, inplace=True)

        # Save the final processed DataFrame to CSV
        data_df_processed.to_csv("yohe2.csv", index=False)
        logger_info.info("Final DataFrame saved to yohe2.csv")
        print(data_df_processed)

        return data_df_processed

    except Exception as e:
        logger_error.error(f"Error processing data: {e}")
        return pd.DataFrame()  # Return an empty DataFrame in case of error




def process_sim_traction(data_df, split_columns):
    """
    Processes data for the 'lable_source' table by splitting, exploding, and transforming specified columns.

    :param data_df: Input DataFrame containing the data for the 'lable_source' table
    :param split_columns: List of columns to split and explode
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :return: Processed DataFrame
    """
    try:
        # Copy the DataFrame to avoid modifying the original one
        data_df_copy = data_df.copy()

        # Split and explode specified columns
        for col in split_columns:
            data_df_copy[col] = data_df_copy[col].str.split(',')
            data_df_copy = data_df_copy.explode(col)

        # Create a new DataFrame with required columns
        data_df_processed = pd.DataFrame({
            'MSISDN': data_df_copy['MSISDN'],
            'IMSI': data_df_copy['IMSI'],
            'ICCID': data_df_copy['ICCID'],
            'TRANSACTION_CONTEXT': data_df_copy['TRANSACTION_CONTEXT'],
            'SUSPENSION_TYPE': data_df_copy['SUSPENSION_TYPE'],
            'TRX_TYPE': data_df_copy['TRX_TYPE'],
            'START_DATE': data_df_copy['START_DATE']
        })

        # Replace NaT values with None
        data_df_processed.replace({pd.NaT: None}, inplace=True)

        # Save the final processed DataFrame to CSV
        data_df_processed.to_csv("sim_traction_df.csv", index=False)
        logger_info.info("Final DataFrame saved to sim_traction_df.csv")

        return data_df_processed

    except Exception as e:
        logger_error.error(f"Error processing data: {e}")
        return pd.DataFrame()  # Return an empty DataFrame in case of error

def pull_transformed_data_from_sp():
    """
    Method to call stored procedure for each output file and place on destination path defined in config
    :return: None
    """
    logger_info.info("-------------- Pull transformed data from DP Started -------------------")
    print("-------------- Pull transformed data from DP Started -------------------")

    file_sp_mapper = {
        'cost_center_cdp.csv':'cost_center_cdp',
        'addCustomerForprivateapn.csv':'additional_bus_for_static_apns_cdp',
        'apnCreation.csv':'apn_management_cdp',
        'asset_dummy.csv':'assests_details_cdp',
        'asset_extended_dummy.csv':'asset_extended_cdp;',
        'AccountOnboard.csv':'customer_account_cdp',
        'AccountOnboard_1.csv':'customer_account_cdp_bu',
        'lead_person_creation.csv':'lead_person_CDP',
        'migration_assets.csv':'migration_assets_cdp',
        'migration_device_plan.csv':'migration_device_plan_cdp',
        'userCreation.csv':'user_management_cdp',
        'Goup_router_bulk_upload_dummy.csv':'Goup_router_bulk_upload_dumm',
        'ip_pooling.csv': 'ip_pooling_22',
        'sim_product_type_Creation.csv':'sim_products_cdp',
        'CSRMappingDetails.xlsx': 'csr_mapping_details',
        'CSRMappingMaster.xlsx': 'csr_mapping_master',
        'migration_sim_range.csv': 'migration_sim_range',
        'migration_map_user_sim_order.csv': 'migration_map_user_sim_order',
        'migration_order_shipping_status.csv':'migration_order_shipping_status',
        'migration_sim_event_log.csv':'migration_sim_event_log',
        'migration_sim_provisioned_range_details.csv':'migration_sim_provisioned_range_details',
        'label_cdp.csv':'migration_tag',
        'api_user_cdp.csv':'migration_api_user',
        'ip_white_listing_cdp.csv':'ip_white_listing',       
    }

    try:
        for migrated_data_file, sp_call in file_sp_mapper.items() :
            logger_info.info('Calling SP {} to fetch data'.format(sp_call))
            if migrated_data_file=='cost_center_cdp.csv':
                # print("coast_center_come")
                resultset = sql_query_fetch(querry_for_cost_center_cdp,migration_db_configs, logger_error)
                # print(resultset)
                column_names=cost_center_column
                print('Procedure Result Count for cost center',len(resultset))
            else:
                resultset,column_names = call_procedure_with_param(sp_call,migration_db_configs,logger_error,logger_info)
            if resultset :
                # print('column_names',column_names)
                df = pd.DataFrame(resultset, columns=column_names)
                path = "%s%s"%(output_file_base_dir,output_file_path[migrated_data_file])
                #print(path)
                file_path=path+migrated_data_file
                print("File Path",file_path)
                try :
                    os.remove(file_path)
                    logger_info.info('Removed file from path {}'.format(file_path))
                except Exception as e :
                    logger_info.info('No file found at path {}'.format(file_path))
            
                # Create the directory if it doesn't exist
                # os.makedirs(path, exist_ok=True)
                if 'xlsx' in migrated_data_file:
                    df.to_excel(os.path.join(path,migrated_data_file), index=False)
                else :
                    df.to_csv(os.path.join(path,migrated_data_file), index=False)
                logger_info.info('Output file generated by SP {} is placed at {}'.format(sp_call,path))
            else:
                logger_info.info('SP {} no return data'.format(sp_call))


    except Exception as e:
        logger_info.error('Error while writing {} file data from db {}'.format(migrated_data_file, e))
        logger_error.error('Error while writing {} file data from db {}'.format(migrated_data_file, e))


def convert_timestamp(ts):
    # Truncate the microseconds part to six digits
    if ts.strip():
        date_part, time_part, period = ts.split()
        time_part, microseconds = time_part.rsplit('.', 1)
        microseconds = microseconds[:6]  # Truncate to six digits
        ts_corrected = f"{date_part} {time_part}.{microseconds} {period}"
        
        input_format = "%d-%b-%y %I.%M.%S.%f %p"
        parsed_timestamp = datetime.strptime(ts_corrected, input_format)
        output_format = "%Y-%m-%d %H:%M:%S"
        return parsed_timestamp.strftime(output_format)
    else:
        return ''

def convert_timestamp_for_sim_tractions(ts):
    # Check if the input string is not empty
    if ts.strip():
        try:
            # Split the timestamp into its components
            date_part, time_part, period = ts.split()
            
            # Split the time part into time and microseconds
            time_part, microseconds = time_part.rsplit('.', 1)
            microseconds = microseconds[:6]  # Truncate microseconds to six digits
            
            # Reconstruct the corrected timestamp string
            ts_corrected = f"{date_part} {time_part}.{microseconds} {period}"
            
            # Define the input and output formats
            input_format = "%d-%b-%y %I.%M.%S.%f %p"
            output_format = "%Y-%m-%d %H:%M:%S"
            
            # Parse the corrected timestamp string to a datetime object
            parsed_timestamp = datetime.strptime(ts_corrected, input_format)
            
            # Convert the datetime object to the desired output format
            return parsed_timestamp.strftime(output_format)
        except Exception as e:
            # Handle parsing errors
            print(f"Error parsing timestamp '{ts}': {e}")
            return ''
    else:
        return ''


def push_input_to_migration(file_table_mapper,input_file_path):
    """
    1) This Method First truncate the table 'migration_assets' , 'migration_assets_extended' and then
    2) It will First fetch the maxid of assets and asset extended tables increment the max id by 1 and
    then fill that in id column of asset and asset extended files dataframe.
    3) Insert the data in 'migration_assets' , 'migration_assets_extended' tables, if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    4) A procedure will be called which will return the result.
    5) Error occurred during procedure execution will be maintained in a table 'migration_assets_extended_error_history'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    """

    logger_info.info("--------------Push Input Data Started-------------------")
    print("--------------Push Input Data Started------------------------------")

    current_date = datetime.now().strftime("%Y%m%d%H%M")

    # Use defaultdict to handle multiple files for the same table
    table_file_mapper = defaultdict(list)
    for file_name, table_name in file_table_mapper.items():
        table_file_mapper[table_name].append(file_name)

    print("db details", migration_db_configs)

    for table_name, file_names in table_file_mapper.items():
        if len(file_names) and any(os.path.exists(os.path.join(input_file_path, file_name)) for file_name in file_names):
            logger_info.info(f"Truncating table: {table_name}")
            # Uncomment the following line for actual use
            print(f"Truncating table: {table_name}")
            truncate_mysql_table(migration_db_configs, table_name, logger_error)
        else:
            print(f"No input files found under: {input_file_path} for table: {table_name}")
            logger_error.error(f"No input files found under: {input_file_path} for table: {table_name}")
            continue

        for csv_file_name in file_names:
            csv_file_path = os.path.join(input_file_path, csv_file_name)

            try:
                insertion_error_filename = os.path.basename(csv_file_path)
                
                if insertion_error_filename == "assets_cdp.csv":
                    print("assets_cdp.csv detected")
                    data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str, keep_default_na=True)
                else:
                    data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str, keep_default_na=False)
                
                data_df.replace({np.nan: None}, inplace=True)
                data_df.fillna("", inplace=True)
                data_df.columns = data_df.columns.str.replace(' ', '_')

                logger_info.info(f"Loaded file: {csv_file_path}")
                logger_info.info(f"Row count: {len(data_df)}")
                logger_info.info(f"Target table: {table_name}, Columns: {data_df.columns}")

                

                if table_name == 'assets_cdp':
                    
                    coulms_required=['LASTMODIFDATE', 'CREATIONDATE', 'SPMODIFDATE', 'ACTIVATIONDATE']
                    data_df=convert_timestamps_for_new_latest(data_df,coulms_required)

                    data_df['MSISDN'] = data_df['MSISDN'].astype(str).str.split('.').str[0].astype(int)
                    data_df.replace({pd.NaT: None}, inplace=True)
                    data_df.to_csv("assets_data_vaify.csv",index=False)

                if table_name == 'apns_cdp':
                    # data_df['CREATED_AT'] = data_df['CREATED_AT'].apply(parse_datetime)
                    coulms_required=['CREATED_AT']
                    data_df=convert_timestamps_for_new_latest(data_df,coulms_required)
                    data_df.rename(columns={'BU_LIST': 'BU_ID'}, inplace=True)
                    data_df.replace({np.nan: None}, inplace=True)
                    data_df.replace({pd.NaT: None}, inplace=True)
                    data_df.replace({'': None}, inplace=True)
                    # data_df.to_csv("apns_data_vaify.csv",index=False)



                if table_name =='acct_att_cdp':
                    if migration_add_email== 'yes':
                        data_df['ACCOUNT_MANAGER_EMAIL']=data_df['ACCOUNT_MANAGER_EMAIL'].str.replace('@', '@migration')    
                    
                        data_df['CONTACT_PERSON_EMAIL']=data_df['CONTACT_PERSON_EMAIL'].str.replace('@', '@migration')                  



                if table_name =='billing_account_cdp':
                    if migration_add_email== 'yes':
                        data_df['BU_ACCOUNT_MANAGER_EMAIL']=data_df['BU_ACCOUNT_MANAGER_EMAIL'].str.replace('@', '@migration')    
                    
                        

                if table_name =='users_details_cdp':
                    if migration_add_email== 'yes':
                        data_df['EMAIL']=data_df['EMAIL'].str.replace('@', '@migration')    
                    
                        
    
                if table_name == 'Service_Profile_Config_cdp':
                    # Apply function to DataFrame
                    data_df['DPName'] = data_df.apply(calculate_dp_name_logic, axis=1)
                    # data_df['DPName'] = data_df.apply(calculate_dp_name, axis=1)
                    data_df.to_csv("dp_name.csv",index=False)


                if table_name == 'lable_source':
                    print("Processing lable_source data")
                    data_df = process_lable_source_data(data_df, logger_info, logger_error)
                    data_df.to_csv("lable_data_insert.csv",index=False)
                if table_name=='sim_transactions_cdp1':
                    print("before_len",len(data_df))
                    data_df['START_DATE'] = data_df['START_DATE'].apply(convert_timestamp_for_sim_tractions)
                   
                    data_df['END_DATE'] = data_df['END_DATE'].apply(convert_timestamp_for_sim_tractions)
                    data_df['TARGET_DATE'] = data_df['TARGET_DATE'].apply(convert_timestamp_for_sim_tractions)

                    # coulms_required=['START_DATE','END_DATE','TARGET_DATE']
                    if 'TRX_TYPE' in data_df.columns:
                        # Filter condition
                        filter_values = ['sim suspension', 'Administrative suspend of BU sims']

                        # Separate rows based on filter condition
                        df = data_df[data_df['TRX_TYPE'].isin(filter_values)].reset_index(drop=True)
                        # df = data_df[data_df['TRX_TYPE'] == 'SUSPENSION_TYPE'].reset_index(drop=True)
                    else:
                        print("columns not exits")
                    print(len(df))

                    # data_df=convert_timestamps_for_new_latest(data_df,coulms_required)
                    print(df['START_DATE'])
                    # Split the columns with comma-separated values
                    columns_to_split = ['IMSI']
                    data_df=process_sim_traction(df,columns_to_split)
                    print(data_df)
                    data_df.replace({pd.NaT: None}, inplace=True)
                    # max_len, max_len_col = data_df.astype(str).applymap(len).max().max(), data_df.astype(str).applymap(len).max().idxmax()
                    
                    # print("max_len           ",max_len,max_len_col)
                    # data_df.to_csv("sim_transaction.csv",index=False)
                   

                
                if table_name == 'sim_order_cdp':
                    
                    data_df['START_DATE'] = data_df['START_DATE'].apply(convert_timestamp)
                   
                    data_df['END_DATE'] = data_df['END_DATE'].apply(convert_timestamp)
                    data_df['EXPECTED_DELIVERY_DATE'] = data_df['EXPECTED_DELIVERY_DATE'].apply(convert_timestamp)
                    data_df['SIM_ORDER_FROM_OPCO_ORDER_DATE'] = data_df['SIM_ORDER_FROM_OPCO_ORDER_DATE'].apply(convert_timestamp)
                    # coulms_required=['START_DATE','END_DATE','EXPECTED_DELIVERY_DATE','SIM_ORDER_FROM_OPCO_ORDER_DATE']
                    # data_df=convert_timestamps_for_new_latest(data_df,coulms_required)
                    data_df.replace({pd.NaT: None}, inplace=True)
                   
                # print("lats_uppdate_colums",data_df['LASTMODIFDATE'],data_df['CREATIONDATE'],data_df['ACTIVATIONDATE'])
                data_df.replace({np.nan: None}, inplace=True)
                data_df.replace({pd.NaT: None}, inplace=True)
                data_df.replace({'': None}, inplace=True)
                dr_error, df_success = insert_batches_df_into_mysql(data_df, migration_db_configs, table_name, logger_info, logger_error)
                # dr_error,df_success=insert_batches_df_into_mysqlfrom_yogesh(data_df, migration_db_configs, table_name, logger_info, logger_error)
                print(f"tablename: {table_name}, len_of_success: {len(df_success)}")
                if not dr_error.empty:
                    dr_error.to_csv(os.path.join(insertion_error_dir, insertion_error_filename), index=False)

            except Exception as e:
                print(f'Error while inserting {insertion_error_filename} file data into db: {e}')
                logger_info.error(f'Error while inserting {insertion_error_filename} file data into db: {e}')
                logger_error.error(f'Error while inserting {insertion_error_filename} data into db: {e}')

            # Uncomment the following line for actual use
            # move_to_history(current_date, csv_file_path)

    logger_info.info("-------------- Data Processing Ended-------------------")


####("Delete_files")
def delete_files(file_path, file_list):
    """
    Deletes files from the specified directory.
    :param file_path: File path or subdirectory
    :param file_list: List of files to be deleted
    """
    for file_name in file_list:
        full_path = os.path.join(file_path, file_name)
        try:
            os.remove(full_path)
            print(f"File '{file_name}' deleted successfully from '{file_path}'.")
            logger_error.info(f"File '{file_name}' deleted successfully from '{file_path}'.")
        except FileNotFoundError:
            print(f"File '{file_name}' not found in '{file_path}'.")
            logger_error.error(f"File '{file_name}' not found in '{file_path}'.")
        except Exception as e:
            print(f"Error deleting file '{file_name}' from '{file_path}': {e}")
            logger_error.error(f"Error deleting file '{file_name}' from '{file_path}': {e}")



if __name__ == "__main__":
    file_table_mapper= {
        'assets_cdp.csv': 'assets_cdp',
        'APN_IP_Addressess_cdp.csv': 'apn_ip_addressess_cdp',
        'customer_details_cdp.csv': 'customer_details_cdp',
        # 'TriggersDetails.csv': 'triggers_cdp',
        'acct_att_cdp.csv': 'acct_att_cdp',
        'address_details_cdp.csv': 'address_details_cdp',
        'APN-ip-pools-state-t_cdp.csv': 'apn_ip_pools_state_t_cdp',
        'apns_cdp.csv': 'apns_cdp', 
        'white_listing_cdp.csv':'white_listing_cdp',
        'sim_orders_ap_fp_status.csv':'sim_orders_ap_fp_status',
        'sim_transactions.csv':'sim_transactions_cdp1',       
    }
    file_table_mapper1={
        'sim_products_cdp.csv': 'sim_products_cdp',
        'users_details_cdp.csv': 'users_details_cdp',
        'Service_Profile_Config_cdp.csv': 'Service_Profile_Config_cdp',
        'APN_SP_cdp.csv':'apn_sp_cdp',
        'assets_cdp.csv':'lable_source',
        'Billing_Account_cdp.csv':'billing_account_cdp',
        'IMSI_Range_cdp.csv':'imsi_range_cdp',
        'SIM_Order_cdp.csv':'sim_order_cdp',
        'cost_center_cdp.csv':'cost_center_cdp',
        'Discount.csv':'discount',
        
    }
    file_table_mapper_for_pc={
        'dp_apo_bundle_charging_spec_data.csv':'dp_apo_bundle_charging_spec_dat',
        'dp_generic_vas_susp_charges_data.csv':'dp_generic_vas_susp_charges_dat',
        'account_plan_charges.csv':'account_plan_charges',
        'dp_child_vas_charges.csv':'dp_child_vas_charges',
    }
    push_input_to_migration(file_table_mapper,input_file_path)
    push_input_to_migration(file_table_mapper1,input_file_path)
    push_input_to_migration(file_table_mapper_for_pc,pc_valid_file_path)
    print("Initiating file creation")
    pull_transformed_data_from_sp()