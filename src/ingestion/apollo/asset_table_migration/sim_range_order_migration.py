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
insertion_error_dir_aircontrol = os.path.join(dir_path, 'insertion_error')
procedure_error_dir_aircontrol = os.path.join(dir_path, 'procedure_error_aircontrol')
insertion_error_dir_router = os.path.join(dir_path, 'insertion_error')
procedure_error_dir_router = os.path.join(dir_path, 'procedure_error_router')

############ Error File Names #######################################################

############ Logger ################################################################

logs = {
    "migration_info_logger":f"stc_ingestion_sim_range_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_ingestion_sim_range_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()




def convert_timestamps_to_string(row_data):
    """
    :param row_data: dataframe row data
    :return: this function will return the converted row data
    """
    for key, value in row_data.items():
        if isinstance(value, pd.Timestamp):
            row_data[key] = value.strftime('%Y-%m-%d %H:%M:%S')
    return row_data


try:
    for file in listdir(dir_path):
        if file.endswith(".csv"):
            delete_csv_file_path = None
            delete_csv_file_path = os.path.join(dir_path, file)
            os.remove(delete_csv_file_path)
except Exception as e:
    print("Delete csv/txt error :", e)


def update_column(df, column_name, initial_value):
    """
    :param df: required dataframe
    :param column_name: required column names of dataframe.
    :param initial_value: this is maxid fetched from asset and asset extended query.
    :return: It will return dataframe.
    """
    # Update value for the first row
    # print('initial value',initial_value)
    df.at[0, column_name] = initial_value
    # Increment value for subsequent rows
    for i in range(0, len(df)):
        df.at[i, column_name] = initial_value + i + 1
        # print(initial_value + i)
    return df


def move_to_history(current_date, source_file):
    """
    Method to move processed file to history
    :param current_date: Migration date time eg  202402260000
    :param source_file: Path of file to be moved
    :return: None
    """

    # Define the source file and history directory
    history_directory = f'{history_file_path}/{current_date}'

    # Create the history directory if it doesn't exist
    if not os.path.exists(history_directory):
        os.makedirs(history_directory)

    # Move the file to the history directory
    destination_file = os.path.join(history_directory, os.path.basename(source_file))
    os.rename(source_file, destination_file)

    print(f"File moved to history {destination_file}")
    logger_info.info(f"File moved to history {destination_file}")


def aircontrol_mapping():
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
        'migration_map_user_sim_order.csv':'migration_map_user_sim_order',
        'migration_sim_range.csv':'migration_sim_range',
        'migration_sim_event_log.csv': 'migration_sim_event_log',
        'migration_order_shipping_status.csv': 'migration_order_shipping_status',
        'migration_sim_provisioned_range_details.csv':'migration_sim_provisioned_range_details'
                         }

    try:
        for file in listdir(sim_Range_input_file_path):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                csv_file_name_all.append(file)
                csv_file_path_all.append(os.path.join(sim_Range_input_file_path, file))

    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))

    if len(csv_file_name_all):
        ###### Truncate Tables ##########
        for table in file_table_mapper.values():
            logger_info.info(f"Truncating table : %s", table)
            # Commented for testing
            truncate_mysql_table(aircontrol_db_configs, table, logger_error)
    else:
        print("No input files found under  :{}".format(sim_Range_input_file_path))
        logger_info.info("No input files found under  :{}".format(sim_Range_input_file_path))

    print('length of path', len(csv_file_path_all))
    ######  Process each file ########
    for csv_file_path in csv_file_path_all:
        print("csv file path : ", csv_file_path)
        try:
            insertion_error_filename = csv_file_path.split("/")[-1]

            data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str)
            data_df.replace({np.nan: None}, inplace=True)
            logger_info.info(f"Loaded file  : %s", csv_file_path)
            print('Loaded File', csv_file_path)
            print('Row Count', len(data_df))
            logger_info.info(f"Row count : %s" % len(data_df))
            table_name = file_table_mapper[csv_file_path.split("/")[-1]]
            logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))
            # print('table',table_name)
            print(data_df)
            ###single_insert_data
            dr_error, df_success = insert_batches_df_into_mysql(data_df, aircontrol_db_configs,
                                                                table_name,
                                                                logger_info, logger_error)

            if not dr_error.empty:
                dr_error.to_csv(
                    os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)

        except Exception as e:
            print('Error : {} while inserting {} file data into db'.format(e,insertion_error_filename))
            logger_info.error('Error : {} while inserting {} file data into db'.format(e,insertion_error_filename))
            logger_error.error('Error : {} while inserting {} data into db'.format(e,insertion_error_filename))

    # move_to_history(current_time_stamp, csv_file_path)
    
def call_order_procdure():
    try:
        # #####  Call Procedure ###############

        call_procedure(aircontrol_db_configs['order_shipping_status_bulk_insert_proc'], aircontrol_db_configs, logger_error,
                                  logger_info)


    except Exception as e:
        print('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))


def call_map_user_procdure():
    try:
        # #####  Call Procedure ###############
        call_procedure(aircontrol_db_configs['map_user_sim_order_procedure_bulk_insert_proc'], aircontrol_db_configs, logger_error,
                       logger_info)

    except Exception as e:
        print('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))


    # move_to_history(current_time_stamp, csv_file_path)


def call_sim_range_procdure():
    try:
        # #####  Call Procedure ###############
        call_procedure(aircontrol_db_configs['sim_range_procedure_bulk_insert_proc'], aircontrol_db_configs, logger_error,
                       logger_info)

    except Exception as e:
        print('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))

def call_event_range_procdure():
    try:
        # #####  Call Procedure ###############
        call_procedure(aircontrol_db_configs['sim_event_log_bulk_insert_proc'], aircontrol_db_configs, logger_error,
                       logger_info)

    except Exception as e:
        print('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))

def call_sim_provisioned_range_details_procdure():
    try:
        # #####  Call Procedure ###############
        call_procedure(aircontrol_db_configs['sim_provisioned_range_details'], aircontrol_db_configs, logger_error,
                       logger_info)

    except Exception as e:
        print('Error while call procedure {}'.format(e))
        logger_error.error('Error while call procedure {}'.format(e))

if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "order":
            print("order")
            aircontrol_mapping()
            call_order_procdure()

        if arg == "map":
            print("map")
            call_map_user_procdure()
        if arg =="range":
            print("range")
            call_sim_range_procdure()
        if arg=="event":
            print("event")
            # aircontrol_mapping()
            call_sim_provisioned_range_details_procdure()
            call_event_range_procdure()
            # aircontrol_mapping()
            
            



