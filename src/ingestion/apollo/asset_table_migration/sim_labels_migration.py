import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.apollo.config import *



dir_path = dirname(abspath(__file__))
from datetime import datetime, timedelta, timezone, date
import datetime

today = datetime.datetime.now()

current_time_stamp = today.strftime("%Y%m%d%H%M")

############ Logger ################################################################

logs = {
    "migration_info_logger":f"stc_ingestion_sim_label_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_ingestion_sim_label_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])
from collections import defaultdict
logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()
insertion_error_dir_aircontrol = os.path.join(dir_path, 'insertion_error')
procedure_error_dir_aircontrol = os.path.join(dir_path, 'procedure_error_aircontrol')
insertion_error_dir_router = os.path.join(dir_path, 'insertion_error')
procedure_error_dir_router = os.path.join(dir_path, 'procedure_error_router')

# def sim_label():
#     """
#     1) This Method First truncate the table.
#     2) Insert the data in the table names given in file_table_mapper if any failure
#     while insertion an error file will be generated in 'Insertion_Error' directory.
#     3) A procedure will be called which will return the result.
#     4) Error occurred during procedure execution will be maintained in a table 'error_history_table'
#     a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
#     :return: None
#     """
#     logger_info.info("--------------Aircontrol Data Processing Started-------------------")
#     print("--------------Aircontrol Data Processing Started------------------------------")

#     csv_file_name_all = []
#     csv_file_path_all = []

#     file_table_mapper = {
#                             'label.csv':'migration_tag',
        
#                          }

#     try:
#         for file in listdir(output_file_base_dir):
#             if (file.endswith(".csv") or file.endswith(".xlsx")):
#                 csv_file_name_all.append(file)
#                 csv_file_path_all.append(os.path.join(output_file_base_dir, file))

#     except Exception as e:
#         logger_info.error("Error Fetching label files :{}".format(e))
#         logger_error.error("Error Fetching label files :{}".format(e))

#     if len(csv_file_name_all):
#         ###### Truncate Tables ##########
#         for table in file_table_mapper.values():
#             logger_info.info(f"Truncating table : %s", table)
#             # Commented for testing
#             sql_query_delete_table(aircontrol_db_configs, table, logger_error)
#     else:
#         print("No input files found under  :{}".format(output_file_base_dir))
#         logger_info.info("No input files found under  :{}".format(output_file_base_dir))

#     print('length of path', len(csv_file_path_all))
#     ######  Process each file ########
#     for csv_file_path in csv_file_path_all:
#         print("csv file path : ", csv_file_path)
#         try:
#             insertion_error_filename = csv_file_path.split("/")[-1]

#             data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str)
#             data_df.replace({np.nan: None}, inplace=True)
#             logger_info.info(f"Loaded file  : %s", csv_file_path)
#             print('Loaded File', csv_file_path)
#             print('Row Count', len(data_df))
#             logger_info.info(f"Row count : %s" % len(data_df))
#             table_name = file_table_mapper[csv_file_path.split("/")[-1]]
#             logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))
#             print('table',table_name)
#             ###single_insert_data
#             dr_error, df_success = insert_batches_df_into_mysql(data_df, aircontrol_db_configs,
#                                                                 table_name,
#                                                                 logger_info, logger_error)

#             if not dr_error.empty:
#                 dr_error.to_csv(
#                     os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)

#         except Exception as e:
#             print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
#             logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
#             logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

#     # move_to_history(current_time_stamp, csv_file_path)

#     call_procedure(aircontrol_db_configs['sim_label_procedure'], aircontrol_db_configs, logger_error,
#                                   logger_info)


def sim_label():
    """
    1) This Method First truncate the table.
    2) Insert the data in the table names given in file_table_mapper if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    3) A procedure will be called which will return the result.
    4) Error occurred during procedure execution will be maintained in a table 'error_history_table'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    """
    logger_info.info("--------------Aircontrol Data Processing Started-------------------")
    print("--------------Aircontrol Data Processing Started------------------------------")

    csv_file_name_all = []
    csv_file_path_all = []

    file_table_mapper = {
        'label_cdp.csv':'migration_tag',
                         }

    


    # Use defaultdict to handle multiple files for the same table
    table_file_mapper = defaultdict(list)
    for file_name, table_name in file_table_mapper.items():
        table_file_mapper[table_name].append(file_name)

    print("db details", aircontrol_db_configs)

    for table_name, file_names in table_file_mapper.items():
        if len(file_names) and any(
                os.path.exists(os.path.join(f"{output_file_base_dir}/", file_name)) for file_name in file_names):
            logger_info.info(f"Truncating table: {table_name}")
            # Uncomment the following line for actual use
            print(f"Truncating table: {table_name}")
            truncate_mysql_table(aircontrol_db_configs, table_name, logger_error)
        else:
            print(f"No input files found under: {output_file_base_dir} for table: {file_name}")
            logger_error.error(f"No input files found under: {output_file_base_dir} for table: {file_name}")
            continue

        for csv_file_name in file_names:
            csv_file_path = os.path.join(output_file_base_dir, csv_file_name)

            try:
                insertion_error_filename = os.path.basename(csv_file_path)
                data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str, keep_default_na=False)

                data_df.replace({np.nan: None}, inplace=True)
                data_df.fillna("", inplace=True)
                data_df.columns = data_df.columns.str.replace(' ', '_')

                logger_info.info(f"Loaded file: {csv_file_path}")
                logger_info.info(f"Row count: {len(data_df)}")
                logger_info.info(f"Row count : %s" % len(data_df))
                data_df.replace({np.nan: None}, inplace=True)
                data_df.replace({pd.NaT: None}, inplace=True)
                data_df.replace({'': None}, inplace=True)
                logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))
                print('table',table_name)

                ###single_insert_data
                dr_error, df_success = insert_batches_df_into_mysql(data_df, aircontrol_db_configs,
                                                                    table_name,
                                                                    logger_info, logger_error)

                if not dr_error.empty:
                    dr_error.to_csv(
                        os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)

            except Exception as e:
                print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
                logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
                logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

    # move_to_history(current_time_stamp, csv_file_path)

    call_procedure(aircontrol_db_configs['sim_label_procedure'], aircontrol_db_configs, logger_error,
                                  logger_info)



if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "sim_label":
            print("sim_label")
            sim_label()
