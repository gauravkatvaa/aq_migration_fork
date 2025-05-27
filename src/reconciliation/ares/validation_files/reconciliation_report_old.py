import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *
from contextlib import closing 
import csv
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

dir_path = dirname(abspath(__file__))

logs = {
    "migration_info_logger":f"A1_reconciliation_validator_info_{current_time_stamp}.log",
    "migration_error_logger":f"A1_reconciliation_validator_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}{reconciliation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

reconcilation_validation_dir_path = f'{logs_path}/{validation_log_dir}'
if not os.path.exists(reconcilation_validation_dir_path):
    os.makedirs(reconcilation_validation_dir_path)

reconcilation_ingestion_dir_path = f'{logs_path}/{ingestion_log_dir}'
if not os.path.exists(reconcilation_ingestion_dir_path):
    os.makedirs(reconcilation_ingestion_dir_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def clear_csv(file_path):
    """
    Deletes the CSV file if it exists.
    """
    try:
        if os.path.isfile(file_path):
            os.remove(file_path)
            logger_info.info(f"Successfully deleted file {file_path}")
        else:
            logger_info.info(f"No file found at {file_path} to delete")
    except Exception as e:
        logger_error.error(f"Error deleting file {file_path}: {e}")

def clear_files(directory_path):
    """
    Deletes all CSV and XLSX files in the specified directory.
    """
    try:
        file_patterns = ["*.csv", "*.xlsx"]
        files_deleted = False

        for pattern in file_patterns:
            for file_path in glob(os.path.join(directory_path, pattern)):
                os.remove(file_path)
                logger_info.info(f"Successfully deleted file {file_path}")
                files_deleted = True
        
        if not files_deleted:
            logger_info.info("No CSV or XLSX files found to delete.")
    except Exception as e:
        logger_error.error(f"Error deleting files: {e}")


def convert_required_df_in_csv(df_report,fileName):
    try:
        df_report = df_report.drop(columns=["sequence_id", "execution_time", "create_date"])
        df_grouped = df_report.groupby("entity_type", as_index=False).sum(numeric_only=True)
        print(df_grouped.to_string())
        #csv_file = "validation_summary_file.csv"
        df_grouped.to_csv(f"{logs_path}/{fileName}.csv", index=False)
        print(f"CSV file saved to {logs_path}/{fileName}.csv")
        
    except Exception as e:
        print("Error : {}, while converting required df_in_csv: {}".format(e, df_report))
        logger_error.error("Error : {}, while converting required df_in_csv: {}".format(e, df_report)) 

def fetch_error_message_from_mutiple_table(database_config,tables):    
    try:
        clear_csv(f"{logs_path}/error_messages.csv")
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        #tables = ["apn_failure", "bu_failure", "cost_center_failure","ec_failure","notifications_failure","report_subscriptions_failure","role_failure","triggers_failure","user_failure"]  

        # Empty list to store results
        data = []
        final_data = []
        for table in tables:
            query = f"SELECT errorMessage FROM {table}"
            #print("q",query)
            cursor.execute(query)
    
            # Fetch all results and store them in the list
            results = cursor.fetchall()
            #while row:
            for row in results:
                #data.append((error_message_tables[table], row[0]))
                data.append(row[0])
            unique_list = list(set(data))            
            result_string = ', '.join(map(str, unique_list))
            final_data.append((error_message_tables[table], result_string))
                #row = cursor.fetchone()
        df = pd.DataFrame(final_data, columns=["entity_type", "error_message"])
        df.to_csv(f"{logs_path}/error_messages.csv", index=False)
        
        cursor.close()
        db.close()       

    except Exception as e:
        logger_error.error("Error : {} ".format(e))        
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")

def fetch_errorcode_from_mutiple_table(database_config,tables):    
    try:
        clear_csv(f"{logs_path}/error_code.csv")
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        #tables = ["apn_failure", "bu_failure", "cost_centers_failure","ec_failure","notifications_failure","report_subscriptions_failure","trigger_failure","users_failure"]  

        # Empty list to store results
        data = []
        final_data = []
        for table in tables:
            query = f"SELECT code FROM {table}"
            #print("q",query)
            cursor.execute(query)
    
            # Fetch all results and store them in the list
            results = cursor.fetchall()
            #while row:
            for row in results:
                #data.append((error_message_tables[table], row[0]))
                data.append(row[0])
            unique_list = list(set(data))            
            result_string = ', '.join(map(str, unique_list))
            final_data.append((error_message_tables[table], result_string))
                #row = cursor.fetchone()
        df = pd.DataFrame(final_data, columns=["entity_type", "error_code"])
        df.to_csv(f"{logs_path}/error_code.csv", index=False)       
        
        # # print(data)
        cursor.close()
        db.close()
        # return data

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        #return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def reconciliation_matrix_csv_and_excel_file():
    try:
        validation_file = f"{logs_path}/validation_summary_file.csv"
        loading_file = f"{logs_path}/loading_summary_file.csv"
        error_message_file = f"{logs_path}/code_with_error_message.csv"
        output_file = f"{logs_path}/ReconciliationReportMatrix.csv"
        df_final_file = f"{logs_path}/df_final.csv"
        output_file_excel = f"{logs_path}/ReconciliationReportMatrix.xlsx"

        clear_csv(output_file)
        clear_csv(df_final_file)
        clear_csv(output_file_excel)
        
        df_validation = pd.read_csv(validation_file)
        df_loading = pd.read_csv(loading_file)
        df_error = pd.read_csv(error_message_file)
        
        df_merged = df_validation.merge(df_loading, on="entity_type", how="outer", suffixes=("_validation", "_loading"))
        
        df_final = df_merged.merge(df_error, on="entity_type", how="outer")        
        df_final.fillna({"total_count_validation": 0, "failure_count_validation": 0, "failure_count_loading": 0,
                        "success_count_loading": 0, "code_with_error_message": "No Error"}, inplace=True)        
        df_final.to_csv(df_final_file, index=False)        
        df_main_reconciliation = pd.DataFrame()
        df_main_reconciliation["Entity"] = df_final["entity_type"]
        df_main_reconciliation["Record Count"] = df_final["total_count_validation"]
        df_main_reconciliation["Rejected"] = df_final["failure_count_validation"] + df_final["failure_count_loading"]
        df_main_reconciliation["Duplicate"] = 0  # Fill with zero
        df_main_reconciliation["Total Loaded"] = df_final["success_count_loading"]        
        df_main_reconciliation["Rejected Percentage(%)"] = df_main_reconciliation.apply(lambda row: (row["Rejected"] / row["Record Count"]) * 100 if row["Record Count"] != 0 else 0, axis=1)
        
        df_main_reconciliation["Loaded Percentage(%)"] = df_main_reconciliation.apply(lambda row: (row["Total Loaded"] / row["Record Count"]) * 100 if row["Record Count"] != 0 else 0, axis=1)
        df_main_reconciliation["Remarks"] = df_main_reconciliation["Rejected"].astype(int).astype(str) + " : " + df_final["code_with_error_message"]
        
        df_main_reconciliation.to_csv(output_file, index=False)
        with pd.ExcelWriter(output_file_excel, engine='xlsxwriter') as writer:
            df_main_reconciliation.to_excel(writer, sheet_name='Reconciliation_Matrix', index=False)
        

        print("Reconciliation Matrix file created successfully!")
    except Exception as e:
        print("Error : {}, while reconciliation_matrix_csv_and_excel_file: {}".format(e, df_validation))
        logger_error.error("Error : {}, reconciliation_matrix_csv_and_excel_file: {}".format(e, df_validation))


def make_csv_as_code_with_error_message():
    try:
        error_message_df = pd.read_csv(f"{logs_path}/error_messages.csv")
        error_code_df = pd.read_csv(f"{logs_path}/error_code.csv")
        clear_csv(f"{logs_path}/code_with_error_message.csv")
        
        merged_df = pd.merge(error_code_df, error_message_df, on="entity_type", how="outer")

        merged_df["code_with_error_message"] = (
            "recods are rejected due to the - " + merged_df["error_code"].astype(str) + " " + merged_df["error_message"].astype(str)
        )
        
        final_df = merged_df[["entity_type", "code_with_error_message"]]

        
        final_df.to_csv(f"{logs_path}/code_with_error_message.csv", index=False)

        print("CSV file 'code_with_error_message.csv' created successfully!")
    except Exception as e:
        print("Error : {}, while make_csv_as_code_with_error_message: {}".format(e, error_message_df))
        logger_error.error("Error : {}, while make_csv_as_code_with_error_message: {}".format(e, error_message_df))

def make_csv_and_excel_from_validation_db_tables(database_config,table_list):
    try:
        #validation_loading_error_files_path = f"{logs_path}/validation_loading"
        clear_files(reconcilation_validation_dir_path)
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'], database_config["PORT"])
        cursor = db.cursor()
        output_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
        
        #table_list = ["apn_failure", "bu_failure", "cost_centers_failure","ec_failure","notifications_failure","report_subscriptions_failure","trigger_failure","users_failure"] 
        with pd.ExcelWriter(output_file, engine="openpyxl") as writer:
            for table in table_list:
                try:
                    query = f"SELECT * FROM {table}"
                    cursor.execute(query)
                    columns = [desc[0] for desc in cursor.description]
                    data = cursor.fetchall()               
                    df = pd.DataFrame(data, columns=columns)               
                    if df.empty:
                        print(f"Skipping {table} as it is empty.")
                        continue
                    csv_file = f"{reconcilation_validation_dir_path}/{database_config['DATABASE']}_{table}.csv"                 
                    df.to_csv(csv_file, index=False)            
                    df.to_excel(writer, sheet_name=f"{database_config['DATABASE']}_{table}", index=False)

                    print(f"Exported {table} successfully.")
                except Exception as e:
                    print(f"Error exporting {table}: {e}")
                    logger_error.error("Error : {}, while make_csv_and_excel_from_validation_db_tables: {}".format(e, table))

        
        cursor.close()
        db.close()
        print(f"All tables exported to {output_file}")
    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        #return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")

def make_csv_and_excel_from_loading_db_tables(database_config,table_list):
    try:
        #loading_error_files_path = f"{logs_path}/loading"
        clear_files(reconcilation_ingestion_dir_path)
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'], database_config["PORT"])
        cursor = db.cursor()
        output_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"       
         
        #table_list = ["apn_failure", "bu_failure", "cost_center_failure","ec_failure","notifications_failure","report_subscriptions_failure","role_failure","triggers_failure","user_failure"]
        with pd.ExcelWriter(output_file, engine="openpyxl") as writer:
            for table in table_list:
                try:
                    query = f"SELECT * FROM {table}"
                    cursor.execute(query)
                    columns = [desc[0] for desc in cursor.description]
                    data = cursor.fetchall()               
                    df = pd.DataFrame(data, columns=columns)               
                    if df.empty:
                        print(f"Skipping {table} as it is empty.")
                        continue
                    csv_file = f"{reconcilation_ingestion_dir_path}/{database_config['DATABASE']}_{table}.csv"                 
                    df.to_csv(csv_file, index=False)            
                    df.to_excel(writer, sheet_name=f"{database_config['DATABASE']}_{table}", index=False)

                    print(f"Exported {table} successfully.")
                except Exception as e:
                    print(f"Error exporting {table}: {e}")
                    logger_error.error("Error : {}, while make_csv_and_excel_from_loading_db_tables: {}".format(e, table))

        
        cursor.close()
        db.close()
        print(f"All tables exported to {output_file}")
    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        #return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")

def create_main_report_reconciliation_excel_file(FinalReconcilation_path):
    try:
        Reconcilation_matrix_file = f"{logs_path}/ReconciliationReportMatrix.xlsx"
        validation_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
        loading_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"
        file_paths = [Reconcilation_matrix_file, validation_file, loading_file] 
        FinalReconcilation_file = FinalReconcilation_path
        clear_csv(FinalReconcilation_file)
        
        reconciliation_wb = Workbook()
        reconciliation_wb.remove(reconciliation_wb.active)  # Remove default sheet

        for file in file_paths:
            wb = load_workbook(file)  # Load the current workbook
            for sheet_name in wb.sheetnames:
                sheet = wb[sheet_name]
                #new_sheet = reconciliation_wb.create_sheet(title=f"{sheet_name}_{file_paths.index(file)+1}")
                new_sheet = reconciliation_wb.create_sheet(title=f"{sheet_name}")   
                
                for row in sheet.iter_rows(values_only=True):
                    new_sheet.append(row)

        reconciliation_wb.save(FinalReconcilation_file)
        print("Final Reconciliation file created successfully!")
    except Exception as e:
        print("Error : {}, while creating_main_report_reconciliation_excel_file: {}".format(e))
        logger_error.error("Error : {}, while creating_main_report_reconciliation_excel_file: {}".format(e))

def validation_reconciliation_report():
    try:    
        clear_csv(f"{logs_path}/validation_summary_file.csv")
        df_report_validation = read_table_as_df('validation_summary',metadata_db_configs,logger_info, logger_error)
        #print("df_report_validation ")
        df_report_validation["entity_type"] = df_report_validation["entity_type"].replace(replace_entity_type)
        print(df_report_validation.to_string())   
        convert_required_df_in_csv(df_report_validation,'validation_summary_file')
        clear_csv(f"{logs_path}/loading_summary_file.csv")
        df_report_loading = read_table_as_df('loading_summary',metadata_db_configs,logger_info, logger_error)
        #print("df_report_validation ")
        df_report_loading["entity_type"] = df_report_loading["entity_type"].replace(replace_entity_type)
        print(df_report_loading.to_string()) 
        convert_required_df_in_csv(df_report_loading,'loading_summary_file')
        fetch_errorcode_from_mutiple_table(validation_db_configs,db_table["validation_db_tables"])
        fetch_error_message_from_mutiple_table(ingestion_db_configs,db_table["ingestion_db_tables"])
        make_csv_as_code_with_error_message()
        reconciliation_matrix_csv_and_excel_file()
        make_csv_and_excel_from_validation_db_tables(validation_db_configs,db_table["validation_db_tables"])
        make_csv_and_excel_from_loading_db_tables(ingestion_db_configs,db_table["ingestion_db_tables"])
        create_main_report_reconciliation_excel_file(FinalReconcilation_path)        
        
    except Exception as e:
        print("Error : {}, while validation_reconciliation_reportt: {}".format(e, df_report_validation))
        logger_error.error("Error : {}, while validation_reconciliation_report: {}".format(e, df_report_validation))





if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments


    for arg in sys.argv[1:]:                     

        
        if arg == "final_report":
            print("final_reconciliation_report_file")
            validation_reconciliation_report()
            # make_csv_and_excel_from_validation_db_tables(validation_db_configs,db_table["validation_db_tables"])
            # make_csv_and_excel_from_loading_db_tables(ingestion_db_configs,db_table["ingestion_db_tables"])
            #create_main_report_reconciliation_excel_file(FinalReconcilation_path)
            