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

# Updated entity mapping dictionaries
error_message_tables = {
    "apn_failure": "APN",
    "bu_failure": "BU",
    "cost_center_failure": "Cost Centers",
    "ec_failure": "EC",
    "notifications_failure": "Notification Template",
    "report_subscriptions_failure": "Report Subscriptions",
    "role_failure": "Role and Access",
    "triggers_failure": "Rule Engine",
    "user_failure": "Users",
    "labels_failure": "Labels",
    "cost_centers_failure": "Cost Centers",
    "trigger_failure": "Rule Engine",
    "users_failure": "Users",
    "asset_failure": "Sim Assets",
    "ip_pool_failure": "IP Pool",
    # "life_cycles_failure": "Life Cycles",
    "service_profiles_failure": "Device Plan"
}


db_table = {
    "validation_db_tables": [
        "apn_failure", "bu_failure", "cost_centers_failure", "ec_failure", 
        "notifications_failure", "report_subscriptions_failure", "trigger_failure", 
        "users_failure", "asset_failure", "ip_pool_failure", 
        # "life_cycles_failure",
        "service_profiles_failure"
    ],
    "ingestion_db_tables": [
        "apn_failure", "bu_failure", "cost_center_failure", "ec_failure", 
        "notifications_failure", "report_subscriptions_failure", "role_failure", 
        "triggers_failure", "user_failure",
    ]
}

csv_and_excel_fille_path = {
    "metadata_db_validation_summary_file": "validation_summary_file.csv",
    "metadata_db_loading_summary_file": "loading_summary_file.csv",
    "validation_db_tables_error_code_file": "error_code.csv",
    "ingestion_db_tables_errormessage_file": "error_messages.csv",
    "code_with_error_message_file": "code_with_error_message.csv",
    "reconciliation_report_matrix_csv_file": "ReconciliationReportMatrix.csv",
    "reconciliation_report_matrix_xlsx_file": "ReconciliationReportMatrix.xlsx",
    "combine_validation_error_excel_file": "validation_tables.xlsx",
    "combine_ingestion_error_excel_file": "loading_tables.xlsx"
}


def create_main_report_reconciliation_excel_file(FinalReconcilation_path):
    try:
        Reconcilation_matrix_file = f"{logs_path}/ReconciliationReportMatrix.xlsx"
        validation_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
        loading_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"
        bu_apn_report_file = f"{logs_path}/BU_APN_REPORT.csv"
        
        file_paths = [Reconcilation_matrix_file, validation_file, loading_file, bu_apn_report_file] 
        FinalReconcilation_file = FinalReconcilation_path
        clear_csv(FinalReconcilation_file)
        
        # Create a new workbook with a default summary sheet
        reconciliation_wb = Workbook()
        summary_sheet = reconciliation_wb.active
        summary_sheet.title = "Reconciliation Summary"
        summary_sheet.append(["File", "Status"])
        
        # Add a special sheet for BU_APN_REPORT if it exists
        if os.path.exists(bu_apn_report_file):
            try:
                bu_apn_df = pd.read_csv(bu_apn_report_file)
                bu_apn_sheet = reconciliation_wb.create_sheet(title="BU_APN_REPORT")
                
                # Add headers
                headers = list(bu_apn_df.columns)
                bu_apn_sheet.append(headers)
                
                # Add data rows
                for _, row in bu_apn_df.iterrows():
                    bu_apn_sheet.append(row.tolist())
                    
                summary_sheet.append(["BU_APN_REPORT", "Added successfully"])
            except Exception as bu_e:
                logger_error.error(f"Error adding BU_APN_REPORT: {bu_e}")
                summary_sheet.append(["BU_APN_REPORT", f"Error: {str(bu_e)[:100]}"])
        
        # Check files and process them
        for file in file_paths:
            if file == bu_apn_report_file:
                continue  # Skip BU_APN_REPORT as it's handled separately
                
            try:
                if not os.path.exists(file):
                    summary_sheet.append([os.path.basename(file), "Missing"])
                    logger_error.error(f"Missing file for final report: {file}")
                    continue
                    
                wb = load_workbook(file)  # Load the current workbook
                if len(wb.sheetnames) == 0:
                    summary_sheet.append([os.path.basename(file), "No sheets found"])
                    continue
                    
                summary_sheet.append([os.path.basename(file), f"{len(wb.sheetnames)} sheets found"])
                
                for sheet_name in wb.sheetnames:
                    try:
                        sheet = wb[sheet_name]
                        
                        # Keep the sheet name as is (already formatted correctly in source files)
                        unique_name = sheet_name
                        
                        # Check if this sheet name already exists, if so, make it unique
                        counter = 1
                        original_name = unique_name
                        while unique_name in reconciliation_wb.sheetnames:
                            unique_name = f"{original_name[:27]}_{counter}"
                            counter += 1
                            
                        new_sheet = reconciliation_wb.create_sheet(title=unique_name)
                        
                        # Copy the sheet contents
                        for row in sheet.iter_rows(values_only=True):
                            new_sheet.append(row)
                    except Exception as sheet_e:
                        logger_error.error(f"Error processing sheet {sheet_name} in {file}: {sheet_e}")
                        summary_sheet.append([f"{os.path.basename(file)} - {sheet_name}", f"Error: {str(sheet_e)[:100]}"])
            except Exception as e:
                logger_error.error(f"Error processing workbook {file}: {e}")
                summary_sheet.append([os.path.basename(file), f"Error: {str(e)[:100]}"])
                
        # Ensure we have at least one sheet before saving
        if len(reconciliation_wb.sheetnames) == 0:
            reconciliation_wb.create_sheet(title="No Data")
            
        # Save the workbook
        reconciliation_wb.save(FinalReconcilation_file)
        print(f"Final Reconciliation file created successfully at: {os.path.abspath(FinalReconcilation_file)}")
    except Exception as e:
        print(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
        logger_error.error(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
        
        # Create a minimal report in case of error
        try:
            reconciliation_wb = Workbook()
            sheet = reconciliation_wb.active
            sheet.title = "Error"
            sheet.append(["An error occurred while creating the reconciliation report:", str(e)])
            reconciliation_wb.save(FinalReconcilation_file)
            print(f"Error report created at: {os.path.abspath(FinalReconcilation_file)}")
        except Exception as save_e:
            logger_error.error(f"Failed to create error report: {save_e}")
            

def create_bu_apn_report(database_config_validation, database_config_ingestion):
    """
    Creates a BU_APN_REPORT by joining bu_success and apn_success tables
    to show BU association with APN count.
    """
    try:
        output_file = f"{logs_path}/BU_APN_REPORT.csv"
        clear_csv(output_file)
        
        # Connect to validation database to get bu_success and apn_success tables
        db_validation = mysql_connection(
            database_config_validation["DATABASE"], 
            database_config_validation["HOST"], 
            database_config_validation["USER"], 
            database_config_validation['PASSWORD'],
            database_config_validation["PORT"]
        )
        
        # First check if both tables exist
        cursor = db_validation.cursor()
        
        # Get the list of tables in the database
        cursor.execute("SHOW TABLES")
        tables = [table[0] for table in cursor.fetchall()]
        
        if 'bu_success' not in tables or 'apn_success' not in tables:
            logger_error.error("Required tables (bu_success or apn_success) not found in validation database")
            # Create a dummy report with headers
            df = pd.DataFrame(columns=["BU NAME", "CRM BU ID", "APN COUNT", "APN IDs"])
            df.to_csv(output_file, index=False)
            return
        
        # Query to join bu_success and apn_success tables
        try:
            query = """
            SELECT 
                b.bu_name as 'BU NAME',
                b.BUCRM_ID as 'CRM BU ID',
                COUNT(a.APN_ID) as 'APN COUNT',
                GROUP_CONCAT(a.APN_ID) as 'APN IDs'
            FROM 
                bu_success b
            LEFT JOIN 
                apn_success a ON b.bu_name = a.customer
            GROUP BY 
                b.bu_name, b.BUCRM_ID
            """
            
            # Execute the query
            cursor.execute(query)
            columns = [desc[0] for desc in cursor.description]
            data = cursor.fetchall()
            
            if data:
                # Create DataFrame and save to CSV
                df = pd.DataFrame(data, columns=columns)
                df.to_csv(output_file, index=False)
                
                print(f"BU_APN_REPORT created successfully and saved to {output_file}")
                return df
            else:
                logger_error.error("No data found when joining bu_success and apn_success tables")
                # Create a dummy report with headers
                df = pd.DataFrame(columns=["BU NAME", "CRM BU ID", "APN COUNT", "APN IDs"])
                df.to_csv(output_file, index=False)
                return df
                
        except Exception as query_e:
            logger_error.error(f"Error executing query to create BU_APN_REPORT: {query_e}")
            # Try an alternative approach if the join fails
            try:
                # First get BU data
                cursor.execute("SELECT bu_name as 'BU NAME', BUBUCRM_ID as 'CRM BU ID' FROM bu_success")
                bu_data = cursor.fetchall()
                bu_columns = [desc[0] for desc in cursor.description]
                
                # Create DataFrame for BUs
                bu_df = pd.DataFrame(bu_data, columns=bu_columns)
                
                # For each BU, try to get APN count
                apn_counts = []
                apn_ids = []
                
                for bu_name in bu_df['BU NAME']:
                    try:
                        cursor.execute(f"SELECT COUNT(id) FROM apn_success WHERE customer = '{bu_name}'")
                        count = cursor.fetchone()[0]
                        
                        cursor.execute(f"SELECT GROUP_CONCAT(id) FROM apn_success WHERE customer = '{bu_name}'")
                        ids = cursor.fetchone()[0]
                        if not ids:
                            ids = ''
                    except:
                        count = 0
                        ids = ''
                        
                    apn_counts.append(count)
                    apn_ids.append(ids)
                
                # Add APN data to the BU DataFrame
                bu_df['APN COUNT'] = apn_counts
                bu_df['APN IDs'] = apn_ids
                
                # Save to CSV
                bu_df.to_csv(output_file, index=False)
                print(f"BU_APN_REPORT created using alternative method and saved to {output_file}")
                return bu_df
                
            except Exception as alt_e:
                logger_error.error(f"Alternative approach also failed: {alt_e}")
                # Create a dummy report with headers
                df = pd.DataFrame(columns=["BU NAME", "CRM BU ID", "APN COUNT", "APN IDs"])
                df.to_csv(output_file, index=False)
                return df
    except Exception as e:
        logger_error.error(f"Error creating BU_APN_REPORT: {e}")
        # Create a dummy report with headers
        df = pd.DataFrame(columns=["BU NAME", "CRM BU ID", "APN COUNT", "APN IDs"])
        df.to_csv(output_file, index=False)
        return df
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db_validation' in locals() and db_validation.is_connected():
            db_validation.close()


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


def convert_required_df_in_csv(df_report, fileName):
    try:
        df_report = df_report.drop(columns=["sequence_id", "execution_time", "create_date"])
        df_grouped = df_report.groupby("entity_type", as_index=False).sum(numeric_only=True)
        print(df_grouped.to_string())
        df_grouped.to_csv(f"{logs_path}/{fileName}.csv", index=False)
        print(f"CSV file saved to {logs_path}/{fileName}.csv")
        
    except Exception as e:
        print(f"Error: {e}, while converting required df_in_csv: {df_report}")
        logger_error.error(f"Error: {e}, while converting required df_in_csv: {df_report}")


def fetch_error_message_from_mutiple_table(database_config, tables):    
    try:
        clear_csv(f"{logs_path}/error_messages.csv")
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        
        # Empty list to store results
        data = []
        final_data = []
        
        for table in tables:
            try:
                query = f"SELECT errorMessage FROM {table}"
                cursor.execute(query)
        
                # Fetch all results and store them in the list
                results = cursor.fetchall()
                
                table_data = []
                for row in results:
                    table_data.append(row[0])
                
                if table_data:  # Only process if we got data
                    unique_list = list(set(table_data))            
                    result_string = ', '.join(map(str, unique_list))
                    final_data.append((error_message_tables.get(table, table), result_string))
                else:
                    # Handle empty result case - add entry with "No Error" message
                    final_data.append((error_message_tables.get(table, table), "No Error"))
            except Exception as table_e:
                logger_error.error(f"Error querying table {table}: {table_e}")
                # Still add an entry with "No Error" message for failed table query
                final_data.append((error_message_tables.get(table, table), "No Error"))
        
        if final_data:  # Only create CSV if we have data
            df = pd.DataFrame(final_data, columns=["entity_type", "error_message"])
            df.to_csv(f"{logs_path}/error_messages.csv", index=False)
        else:
            # Create empty dataframe with required columns if no data
            df = pd.DataFrame(columns=["entity_type", "error_message"])
            df.to_csv(f"{logs_path}/error_messages.csv", index=False)
            
    except Exception as e:
        logger_error.error(f"Error: {e}")
        # Create default file with empty structure
        df = pd.DataFrame(columns=["entity_type", "error_message"])
        df.to_csv(f"{logs_path}/error_messages.csv", index=False)
    finally:
        if 'db' in locals() and db.is_connected():
            cursor.close()
            db.close()
            print("MySQL connection is closed")


def fetch_errorcode_from_mutiple_table(database_config, tables):    
    try:
        clear_csv(f"{logs_path}/error_code.csv")
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()

        # Empty list to store results
        data = []
        final_data = []
        
        for table in tables:
            try:
                query = f"SELECT code FROM {table}"
                cursor.execute(query)
                
                # Fetch all results and store them in the list
                results = cursor.fetchall()
                
                table_data = []
                for row in results:
                    table_data.append(row[0])
                
                if table_data:  # Only process if we got data
                    unique_list = list(set(table_data))            
                    result_string = ', '.join(map(str, unique_list))
                    final_data.append((error_message_tables.get(table, table), result_string))
                else:
                    # Handle empty result case - add entry with "No Error" message
                    final_data.append((error_message_tables.get(table, table), "No Error"))
            except Exception as table_e:
                logger_error.error(f"Error querying table {table}: {table_e}")
                # Still add an entry with "No Error" message for failed table query
                final_data.append((error_message_tables.get(table, table), "No Error"))
        
        if final_data:  # Only create CSV if we have data
            df = pd.DataFrame(final_data, columns=["entity_type", "error_code"])
            df.to_csv(f"{logs_path}/error_code.csv", index=False)
        else:
            # Create empty dataframe with required columns if no data
            df = pd.DataFrame(columns=["entity_type", "error_code"])
            df.to_csv(f"{logs_path}/error_code.csv", index=False)

    except Exception as e:
        logger_error.error(f"Error: {e}")
        # Create default file with empty structure
        df = pd.DataFrame(columns=["entity_type", "error_code"])
        df.to_csv(f"{logs_path}/error_code.csv", index=False)
    finally:
        if 'db' in locals() and db.is_connected():
            cursor.close()
            db.close()
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
        
        # Check if files exist before reading
        if not os.path.exists(validation_file):
            logger_error.error(f"File not found: {validation_file}")
            return
            
        if not os.path.exists(loading_file):
            logger_error.error(f"File not found: {loading_file}")
            return
            
        if not os.path.exists(error_message_file):
            logger_error.error(f"File not found: {error_message_file}")
            return
        
        df_validation = pd.read_csv(validation_file)
        df_loading = pd.read_csv(loading_file)
        df_error = pd.read_csv(error_message_file)
        
        # Normalize entity names in all dataframes
        for df in [df_validation, df_loading, df_error]:
            if 'entity_type' in df.columns:
                df['entity_type'] = df['entity_type'].replace(replace_entity_type)
        
        df_merged = df_validation.merge(df_loading, on="entity_type", how="outer", suffixes=("_validation", "_loading"))
        
        df_final = df_merged.merge(df_error, on="entity_type", how="outer")        
        df_final.fillna({"total_count_validation": 0, "failure_count_validation": 0, "failure_count_loading": 0,
                        "success_count_loading": 0, "code_with_error_message": "No Error"}, inplace=True)        
        df_final.to_csv(df_final_file, index=False)        
        
        df_main_reconciliation = pd.DataFrame()
        df_main_reconciliation["Entity"] = df_final["entity_type"]
        df_main_reconciliation["Record Count"] = df_final["total_count_validation"]
        
        # Calculate rejected count but ensure it's logical
        # Rejected count cannot be more than total record count
        df_main_reconciliation["Rejected"] = df_final.apply(
            lambda row: min(row["failure_count_validation"] + row["failure_count_loading"], row["total_count_validation"]) 
            if row["total_count_validation"] > 0 else 0, axis=1
        )
        
        df_main_reconciliation["Duplicate"] = 0  # Fill with zero
        
        # Total loaded cannot exceed record count
        df_main_reconciliation["Total Loaded"] = df_final.apply(
            lambda row: min(row["success_count_loading"], row["total_count_validation"]) 
            if row["total_count_validation"] > 0 else 0, axis=1
        )
        
        # Make sure percentages make sense
        df_main_reconciliation["Rejected Percentage(%)"] = df_main_reconciliation.apply(
            lambda row: (row["Rejected"] / row["Record Count"]) * 100 
            if row["Record Count"] > 0 else 0, axis=1
        )
        
        df_main_reconciliation["Loaded Percentage(%)"] = df_main_reconciliation.apply(
            lambda row: (row["Total Loaded"] / row["Record Count"]) * 100 
            if row["Record Count"] > 0 else 0, axis=1
        )
        
        # Add remarks and handle "No Error" cases properly
        def format_remarks(row):
            validation_rejected_error_codes = row["validation_rejected_error_codes"]
            ingestion_failed_error_message = row["ingestion_failed_error_message"]
            
            error_msg = ""

            if validation_rejected_error_codes == "No Error":
                error_msg += "In validation records, no error"
            
            else:
                error_msg += f"Validation Rejected Error Codes: {validation_rejected_error_codes}"
            
            if ingestion_failed_error_message == "No Error":
                error_msg += " In ingestion failed, no error"

            else:
                error_msg += f" Ingestion Failed Error Message: {ingestion_failed_error_message}"            
                


        df_main_reconciliation["Remarks"] = df_final.apply(
            lambda row: format_remarks({
            "Rejected": min(row["failure_count_validation"] + row["failure_count_loading"], row["total_count_validation"]) 
            if row["total_count_validation"] > 0 else 0, 
            "validation_rejected_error_codes": row["validation_rejected_error_codes"],
            "ingestion_failed_error_message": row["ingestion_failed_error_message"]
            }), axis=1
        )
        
        df_main_reconciliation.to_csv(output_file, index=False)
        with pd.ExcelWriter(output_file_excel, engine='xlsxwriter') as writer:
            df_main_reconciliation.to_excel(writer, sheet_name='RECONCILIATION_MATRIX', index=False)
        
        print("Reconciliation Matrix file created successfully!")
    except Exception as e:
        print(f"Error: {e}, while reconciliation_matrix_csv_and_excel_file")
        logger_error.error(f"Error: {e}, reconciliation_matrix_csv_and_excel_file")


def make_csv_as_code_with_error_message():
    try:
        error_message_file = f"{logs_path}/error_messages.csv"
        error_code_file = f"{logs_path}/error_code.csv"
        output_file = f"{logs_path}/code_with_error_message.csv"
        
        clear_csv(output_file)
        
        # Check if files exist before reading
        if not os.path.exists(error_message_file):
            logger_error.error(f"File not found: {error_message_file}")
            # Create a default file
            default_data = []
            for entity in set([v for v in error_message_tables.values()]):
                default_data.append({
                    "entity_type": entity, 
                    "validation_rejected_error_codes": "No Error", 
                    "ingestion_failed_error_message": "No Error"
                })
            pd.DataFrame(default_data).to_csv(output_file, index=False)
            return
            
        if not os.path.exists(error_code_file):
            logger_error.error(f"File not found: {error_code_file}")
            # Create a default file
            default_data = []
            for entity in set([v for v in error_message_tables.values()]):
                default_data.append({
                    "entity_type": entity, 
                    "validation_rejected_error_codes": "No Error", 
                    "ingestion_failed_error_message": "No Error"
                })
            pd.DataFrame(default_data).to_csv(output_file, index=False)
            return
        
        error_message_df = pd.read_csv(error_message_file)
        error_code_df = pd.read_csv(error_code_file)
        
        # Normalize entity names
        error_message_df['entity_type'] = error_message_df['entity_type'].replace(replace_entity_type)
        error_code_df['entity_type'] = error_code_df['entity_type'].replace(replace_entity_type)
        
        # Rename columns for clarity
        error_code_df.rename(columns={"error_code": "validation_rejected_error_codes"}, inplace=True)
        error_message_df.rename(columns={"error_message": "ingestion_failed_error_message"}, inplace=True)
        
        # Merge the dataframes
        merged_df = pd.merge(error_code_df, error_message_df, on="entity_type", how="outer")
        
        # Fill missing values with "No Error"
        merged_df.fillna({
            "validation_rejected_error_codes": "No Error", 
            "ingestion_failed_error_message": "No Error"
        }, inplace=True)
        
        # Select the required columns
        final_df = merged_df[["entity_type", "validation_rejected_error_codes", "ingestion_failed_error_message"]]
        final_df.to_csv(output_file, index=False)

        print("CSV file 'code_with_error_message.csv' created successfully!")
    except Exception as e:
        print(f"Error: {e}, while make_csv_as_code_with_error_message")
        logger_error.error(f"Error: {e}, while make_csv_as_code_with_error_message")
        
        # Create a default file in case of error
        default_data = []
        for entity in set([v for v in error_message_tables.values()]):
            default_data.append({
                "entity_type": entity, 
                "validation_rejected_error_codes": "No Error", 
                "ingestion_failed_error_message": "No Error"
            })
        pd.DataFrame(default_data).to_csv(f"{logs_path}/code_with_error_message.csv", index=False)


def make_csv_and_excel_from_validation_db_tables(database_config, table_list):
    try:
        clear_files(reconcilation_validation_dir_path)
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'], database_config["PORT"])
        cursor = db.cursor()
        output_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
        
        # Keep track of successful exports
        successful_exports = False
        
        # Create a workbook outside of ExcelWriter to avoid errors when no sheets are added
        workbook = Workbook()
        default_sheet = workbook.active
        default_sheet.title = "Validation Summary"
        default_sheet.append(["Entity", "Status"])
        
        for table in table_list:
            try:
                query = f"SELECT * FROM {table}"
                cursor.execute(query)
                columns = [desc[0] for desc in cursor.description]
                data = cursor.fetchall()               
                df = pd.DataFrame(data, columns=columns)               
                if df.empty:
                    entity_name = error_message_tables.get(table, table)
                    default_sheet.append([entity_name, "No errors found"])
                    print(f"Skipping {table} as it is empty.")
                    continue
                
                # Map the entity name for sheet name display
                entity_name = error_message_tables.get(table, table)
                sheet_name = f"{entity_name[:31]}"  # Excel has 31 char limit for sheet names
                
                # Add the entity name to the summary sheet
                default_sheet.append([entity_name, "Errors found - see details in separate sheet"])
                
                # Add data to a new sheet
                new_sheet = workbook.create_sheet(sheet_name)
                # Add headers
                new_sheet.append(columns)
                # Add data rows
                for row_data in data:
                    new_sheet.append(row_data)
                
                # Also save as CSV
                csv_file = f"{reconcilation_validation_dir_path}/{database_config['DATABASE']}_{table}.csv"                 
                df.to_csv(csv_file, index=False)
                
                successful_exports = True
                print(f"Exported {table} successfully.")
            except Exception as e:
                print(f"Error exporting {table}: {e}")
                entity_name = error_message_tables.get(table, table)
                default_sheet.append([entity_name, f"Error: {str(e)[:100]}"])  # Truncate long error messages
                logger_error.error(f"Error: {e}, while make_csv_and_excel_from_validation_db_tables: {table}")
        
        # Save the workbook
        workbook.save(output_file)
        
        cursor.close()
        db.close()
        print(f"All tables exported to {output_file}")
    except Exception as e:
        logger_error.error(f"Error: {e}")
        # Create an empty Excel file to prevent later errors
        workbook = Workbook()
        sheet = workbook.active
        sheet.title = "Export Error"
        sheet.append(["Error occurred during export", str(e)])
        try:
            workbook.save(output_file)
        except Exception as save_e:
            logger_error.error(f"Failed to save error workbook: {save_e}")
    finally:
        if 'db' in locals() and db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def make_csv_and_excel_from_loading_db_tables(database_config, table_list):
    try:
        clear_files(reconcilation_ingestion_dir_path)
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'], database_config["PORT"])
        cursor = db.cursor()
        output_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"       
        
        # Create a workbook outside of ExcelWriter to avoid errors when no sheets are added
        workbook = Workbook()
        default_sheet = workbook.active
        default_sheet.title = "Loading Summary"
        default_sheet.append(["Entity", "Status"])
        
        for table in table_list:
            try:
                query = f"SELECT * FROM {table}"
                cursor.execute(query)
                columns = [desc[0] for desc in cursor.description]
                data = cursor.fetchall()               
                df = pd.DataFrame(data, columns=columns)               
                if df.empty:
                    entity_name = error_message_tables.get(table, table)
                    default_sheet.append([entity_name, "No errors found"])
                    print(f"Skipping {table} as it is empty.")
                    continue
                
                # Map the entity name for sheet name display with requested format
                entity_name = error_message_tables.get(table, table).upper()
                sheet_name = f"INGESTION_{entity_name}_FAILURE"
                # Excel has 31 char limit for sheet names
                # if len(sheet_name) > 31:
                #     sheet_name = sheet_name[:31]
                
                # Add the entity name to the summary sheet
                default_sheet.append([entity_name, "Errors found - see details in separate sheet"])
                
                # Add data to a new sheet
                new_sheet = workbook.create_sheet(sheet_name)
                # Add headers
                new_sheet.append(columns)
                # Add data rows
                for row_data in data:
                    new_sheet.append(row_data)
                
                # Also save as CSV
                csv_file = f"{reconcilation_ingestion_dir_path}/{database_config['DATABASE']}_{table}.csv"                 
                df.to_csv(csv_file, index=False)
                
                print(f"Exported {table} successfully.")
            except Exception as e:
                print(f"Error exporting {table}: {e}")
                entity_name = error_message_tables.get(table, table)
                default_sheet.append([entity_name, f"Error: {str(e)[:100]}"])  # Truncate long error messages
                logger_error.error(f"Error: {e}, while make_csv_and_excel_from_loading_db_tables: {table}")
        
        # Save the workbook
        workbook.save(output_file)
        
        cursor.close()
        db.close()
        print(f"All tables exported to {output_file}")
    except Exception as e:
        logger_error.error(f"Error: {e}")
        # Create an empty Excel file to prevent later errors
        workbook = Workbook()
        sheet = workbook.active
        sheet.title = "Export Error"
        sheet.append(["Error occurred during export", str(e)])
        try:
            workbook.save(output_file)
        except Exception as save_e:
            logger_error.error(f"Failed to save error workbook: {save_e}")
    finally:
        if 'db' in locals() and db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


# def create_main_report_reconciliation_excel_file(FinalReconcilation_path):
#     try:
#         Reconcilation_matrix_file = f"{logs_path}/ReconciliationReportMatrix.xlsx"
#         validation_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
#         loading_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"
#         file_paths = [Reconcilation_matrix_file, validation_file, loading_file] 
#         FinalReconcilation_file = FinalReconcilation_path
#         clear_csv(FinalReconcilation_file)
        
#         # Create a new workbook with a default summary sheet
#         reconciliation_wb = Workbook()
#         summary_sheet = reconciliation_wb.active
#         summary_sheet.title = "RECONCILIATION_MATRIX"
#         summary_sheet.append(["File", "Status"])
        
#         # Check files and process them
#         for file in file_paths:
#             try:
#                 if not os.path.exists(file):
#                     summary_sheet.append([os.path.basename(file), "Missing"])
#                     logger_error.error(f"Missing file for final report: {file}")
#                     continue
                    
#                 wb = load_workbook(file)  # Load the current workbook
#                 if len(wb.sheetnames) == 0:
#                     summary_sheet.append([os.path.basename(file), "No sheets found"])
#                     continue
                    
#                 summary_sheet.append([os.path.basename(file), f"{len(wb.sheetnames)} sheets found"])
                
#                 for sheet_name in wb.sheetnames:
#                     try:
#                         sheet = wb[sheet_name]
#                         # Use the sheet name directly without modifications
#                         new_sheet = reconciliation_wb.create_sheet(title=sheet_name)
                        
#                         # Copy the sheet contents
#                         for row in sheet.iter_rows(values_only=True):
#                             new_sheet.append(row)
#                     except Exception as sheet_e:
#                         logger_error.error(f"Error processing sheet {sheet_name} in {file}: {sheet_e}")
#                         summary_sheet.append([f"{file} - {sheet_name}", f"Error: {sheet_e}"])
                        
#             except Exception as e:
#                 logger_error.error(f"Error processing workbook {file}: {e}")
#                 summary_sheet.append([os.path.basename(file), f"Error: {str(e)[:100]}"])
                
#         # Ensure we have at least one sheet before saving
#         if len(reconciliation_wb.sheetnames) == 0:
#             reconciliation_wb.create_sheet(title="No Data")
            
#         # Save the workbook
#         reconciliation_wb.save(FinalReconcilation_file)
#         print("Final Reconciliation file created successfully!")
#     except Exception as e:
#         print(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
#         logger_error.error(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
        
#         # Create a minimal report in case of error
#         try:
#             reconciliation_wb = Workbook()
#             sheet = reconciliation_wb.active
#             sheet.title = "Error"
#             sheet.append(["An error occurred while creating the reconciliation report:", str(e)])
#             reconciliation_wb.save(FinalReconcilation_file)
#         except Exception as save_e:
#             logger_error.error(f"Failed to create error report: {save_e}")


def create_main_report_reconciliation_excel_file(FinalReconcilation_path):
    try:
        Reconcilation_matrix_file = f"{logs_path}/ReconciliationReportMatrix.xlsx"
        validation_file = f"{reconcilation_validation_dir_path}/validation_tables.xlsx"
        loading_file = f"{reconcilation_ingestion_dir_path}/loading_tables.xlsx"
        bu_apn_report_file = f"{logs_path}/BU_APN_REPORT.csv"
        
        file_paths = [Reconcilation_matrix_file, validation_file, loading_file] 
        FinalReconcilation_file = FinalReconcilation_path
        clear_csv(FinalReconcilation_file)
        
        # Store sheet data temporarily to reorder them
        sheet_data = {}
        
        # First, collect all the data we need from the files
        # Start with the RECONCILIATION_MATRIX with actual data (not file counts)
        if os.path.exists(Reconcilation_matrix_file):
            try:
                matrix_wb = load_workbook(Reconcilation_matrix_file)
                
                # Find the real RECONCILIATION_MATRIX sheet with data
                for sheet_name in matrix_wb.sheetnames:
                    if sheet_name == "RECONCILIATION_MATRIX":
                        sheet = matrix_wb[sheet_name]
                        first_row = next(sheet.iter_rows(values_only=True), None)
                        # Check if this is the data sheet (has "Entity" column) vs the file count sheet
                        if first_row and "Entity" in first_row:
                            rows_data = []
                            for row in sheet.iter_rows(values_only=True):
                                rows_data.append(row)
                            sheet_data["RECONCILIATION_MATRIX"] = rows_data
            except Exception as e:
                logger_error.error(f"Error processing matrix file: {e}")
        
        # Add BU_APN_REPORT data
        if os.path.exists(bu_apn_report_file):
            try:
                bu_apn_df = pd.read_csv(bu_apn_report_file)
                rows_data = []
                
                # Add headers
                rows_data.append(tuple(bu_apn_df.columns))
                
                # Add data rows
                for _, row in bu_apn_df.iterrows():
                    rows_data.append(tuple(row.tolist()))
                
                sheet_data["BU_APN_REPORT"] = rows_data
                logger_info.info("BU_APN_REPORT data prepared successfully")
            except Exception as bu_e:
                logger_error.error(f"Error processing BU_APN_REPORT: {bu_e}")
        
        # Process validation and loading files
        for file in [validation_file, loading_file]:
            try:
                if not os.path.exists(file):
                    logger_error.error(f"Missing file for final report: {file}")
                    continue
                    
                wb = load_workbook(file)
                if len(wb.sheetnames) == 0:
                    logger_error.error(f"No sheets found in {file}")
                    continue
                
                for sheet_name in wb.sheetnames:
                    try:
                        sheet = wb[sheet_name]
                        
                        # Ensure unique sheet names
                        unique_name = sheet_name
                        counter = 1
                        while unique_name in sheet_data:
                            unique_name = f"{sheet_name[:27]}_{counter}"
                            counter += 1
                        
                        # Store the sheet data
                        rows_data = []
                        for row in sheet.iter_rows(values_only=True):
                            rows_data.append(row)
                        
                        sheet_data[unique_name] = rows_data
                    except Exception as sheet_e:
                        logger_error.error(f"Error processing sheet {sheet_name} in {file}: {sheet_e}")
            except Exception as e:
                logger_error.error(f"Error processing workbook {file}: {e}")
        
        # Now create a new workbook with sheets in the desired order
        reconciliation_wb = Workbook()
        
        # Get the default sheet
        default_sheet = reconciliation_wb.active
        
        # Define our preferred order for sheets
        preferred_order = ["RECONCILIATION_MATRIX", "BU_APN_REPORT"]
        
        # First add sheets in the preferred order if they exist
        for sheet_name in preferred_order:
            if sheet_name in sheet_data:
                if sheet_name == "RECONCILIATION_MATRIX":
                    # Use the default sheet for first sheet
                    default_sheet.title = sheet_name
                    for row in sheet_data[sheet_name]:
                        default_sheet.append(row)
                else:
                    # Create new sheets for others
                    new_sheet = reconciliation_wb.create_sheet(title=sheet_name)
                    for row in sheet_data[sheet_name]:
                        new_sheet.append(row)
                
                # Remove from dictionary to avoid duplication
                del sheet_data[sheet_name]
        
        # If we didn't use the default sheet, rename it to a placeholder
        if default_sheet.title not in preferred_order:
            for i, (sheet_name, rows) in enumerate(sheet_data.items()):
                if i == 0:
                    # Use the default sheet for the first remaining sheet
                    default_sheet.title = sheet_name
                    for row in rows:
                        default_sheet.append(row)
                else:
                    # Create new sheets for others
                    new_sheet = reconciliation_wb.create_sheet(title=sheet_name)
                    for row in rows:
                        new_sheet.append(row)
        else:
            # Add remaining sheets in original order
            for sheet_name, rows in sheet_data.items():
                new_sheet = reconciliation_wb.create_sheet(title=sheet_name)
                for row in rows:
                    new_sheet.append(row)
                
        # Save the workbook
        reconciliation_wb.save(FinalReconcilation_file)
        print(f"Final Reconciliation file created successfully at: {os.path.abspath(FinalReconcilation_file)}")
    except Exception as e:
        print(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
        logger_error.error(f"Error: {e}, while creating_main_report_reconciliation_excel_file")
        
        # Create a minimal report in case of error
        try:
            reconciliation_wb = Workbook()
            sheet = reconciliation_wb.active
            sheet.title = "Error"
            sheet.append(["An error occurred while creating the reconciliation report:", str(e)])
            reconciliation_wb.save(FinalReconcilation_file)
            print(f"Error report created at: {os.path.abspath(FinalReconcilation_file)}")
        except Exception as save_e:
            logger_error.error(f"Failed to create error report: {save_e}")

def validation_reconciliation_report():
    try:    
        # Clear previous files
        clear_csv(f"{logs_path}/validation_summary_file.csv")
        clear_csv(f"{logs_path}/loading_summary_file.csv")
        
        # Process validation summary
        try:
            df_report_validation = read_table_as_df('validation_summary', metadata_db_configs, logger_info, logger_error)
            df_report_validation["entity_type"] = df_report_validation["entity_type"].replace(replace_entity_type)
            print(df_report_validation.to_string())   
            convert_required_df_in_csv(df_report_validation, 'validation_summary_file')
        except Exception as e:
            logger_error.error(f"Error processing validation summary: {e}")
            # Create an empty validation summary file
            dummy_df = pd.DataFrame(columns=["entity_type", "total_count", "failure_count"])
            dummy_df.to_csv(f"{logs_path}/validation_summary_file.csv", index=False)
        
        # Process loading summary
        try:
            df_report_loading = read_table_as_df('loading_summary', metadata_db_configs, logger_info, logger_error)
            df_report_loading["entity_type"] = df_report_loading["entity_type"].replace(replace_entity_type)
            print(df_report_loading.to_string()) 
            convert_required_df_in_csv(df_report_loading, 'loading_summary_file')
        except Exception as e:
            logger_error.error(f"Error processing loading summary: {e}")
            # Create an empty loading summary file
            dummy_df = pd.DataFrame(columns=["entity_type", "success_count", "failure_count"])
            dummy_df.to_csv(f"{logs_path}/loading_summary_file.csv", index=False)
        
        # Fetch error codes and messages
        try:
            fetch_errorcode_from_mutiple_table(validation_db_configs, db_table["validation_db_tables"])
        except Exception as e:
            logger_error.error(f"Error fetching error codes: {e}")
            
        try:
            fetch_error_message_from_mutiple_table(ingestion_db_configs, db_table["ingestion_db_tables"])
        except Exception as e:
            logger_error.error(f"Error fetching error messages: {e}")
        
        # Create combined files
        make_csv_as_code_with_error_message()
        reconciliation_matrix_csv_and_excel_file()
        
        # Create BU_APN_REPORT
        try:
            create_bu_apn_report(validation_db_configs, ingestion_db_configs)
        except Exception as e:
            logger_error.error(f"Error creating BU_APN_REPORT: {e}")
            # Create a dummy BU_APN_REPORT
            dummy_df = pd.DataFrame(columns=["BU NAME", "CRM BU ID", "APN COUNT", "APN IDs"])
            dummy_df.to_csv(f"{logs_path}/BU_APN_REPORT.csv", index=False)
        
        # Export DB tables
        make_csv_and_excel_from_validation_db_tables(validation_db_configs, db_table["validation_db_tables"])
        make_csv_and_excel_from_loading_db_tables(ingestion_db_configs, db_table["ingestion_db_tables"])
        
        # Create final consolidated report
        create_main_report_reconciliation_excel_file(FinalReconcilation_path)
        
        # Print final path
        print(f"\n\n==== SUMMARY ====")
        print(f"Reconciliation process completed.")
        print(f"Final report is available at: {os.path.abspath(FinalReconcilation_path)}")
        print(f"=================\n")
        logger_info.info(f"Final report created at: {os.path.abspath(FinalReconcilation_path)}")
        
    except Exception as e:
        print(f"Error: {e}, while validation_reconciliation_report")
        logger_error.error(f"Error: {e}, while validation_reconciliation_report")
        
        # Try to create a minimal report even if errors occurred
        try:
            dummy_df = pd.DataFrame({
                "Entity": list(set([v for v in error_message_tables.values()])),
                "Record Count": 0,
                "Rejected": 0,
                "Duplicate": 0,
                "Total Loaded": 0,
                "Rejected Percentage(%)": 0,
                "Loaded Percentage(%)": 0,
                "Remarks": "Error in reconciliation process"
            })
            dummy_df.to_csv(f"{logs_path}/ReconciliationReportMatrix.csv", index=False)
            
            with pd.ExcelWriter(f"{logs_path}/ReconciliationReportMatrix.xlsx", engine='xlsxwriter') as writer:
                dummy_df.to_excel(writer, sheet_name='RECONCILIATION_MATRIX', index=False)
                
            # Still try to create final report even with minimal data
            create_main_report_reconciliation_excel_file(FinalReconcilation_path)
            
            # Print final path even in error case
            print(f"\n\n==== ERROR SUMMARY ====")
            print(f"Reconciliation process encountered errors.")
            print(f"A minimal report is available at: {os.path.abspath(FinalReconcilation_path)}")
            print(f"=======================\n")
            logger_error.info(f"Minimal error report created at: {os.path.abspath(FinalReconcilation_path)}")
        except Exception as recovery_e:
            logger_error.error(f"Failed to create recovery report: {recovery_e}")


if __name__ == "__main__":
    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    
    for arg in sys.argv[1:]:                     
        if arg == "final_report":
            print("Running final_reconciliation_report_file")
            validation_reconciliation_report()