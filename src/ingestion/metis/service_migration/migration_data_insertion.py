
# from mySqlFunctions import *
# from config import *

import sys
# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.custom.metis.config import *
from conf.config import *

dir_path = dirname(abspath(__file__))
from datetime import datetime, timedelta, timezone, date
import datetime
today = datetime.datetime.now()



current_time_stamp = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"maxis_ingestion_service_info_{current_time_stamp}.log",
    "migration_error_logger":f"maxis_ingestion_service_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

insertion_error_dir_aircontrol = os.path.join(dir_path, 'Insertion_Error')
procedure_error_dir_aircontrol = os.path.join(dir_path, 'Procedure_Error_Aircontrol')
insertion_error_dir_router = os.path.join(dir_path, 'Insertion_Error')
procedure_error_dir_router = os.path.join(dir_path, 'Procedure_Error_Router')

############ Error File Names #######################################################
asset_procedure_error_file_name = asset_error_file_name + "_" + current_time_stamp + ".csv"
asset__extended_procedure_error_file_name = asset_extended_error_file_name + "_" + current_time_stamp + ".csv"
goup_procedure_error_file_name = goup_error_file_name + "_" + current_time_stamp + ".csv"
goup_insertion_error_file_name = goup_insertion_error_file_name + "_" + current_time_stamp + ".csv"
router_procedure_error_file_name = router_error_file_name + "_" + current_time_stamp + ".csv"
router_insertion_error_file_name = router_insertion_error_file_name + "_" + current_time_stamp + ".csv"

############ Logger ################################################################
logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()



def empty_csv_file(file_name):
    try:
        current_directory = os.getcwd()
        file_path = os.path.join(current_directory, file_name)
        with open(file_path, 'w') as f:
            f.write('')
        print(f"data_from_file delete{file_name}")
        return True
    except Exception as e:
        print(f"An error occurred while emptying the file: {str(e)}")
        logger_error.error(f"An error occurred while emptying the file: {str(e)}")
        return False


def append_to_data_value_file(csv_file_name, length_of_original, insertion_success,insertion_failure, data_value_file):
    current_datetime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    try:
        # Check if the file exists
        if not os.path.exists(data_value_file) or os.path.getsize(data_value_file) == 0:
            # Write the header along with the data
            with open(data_value_file, 'w') as f:
                f.write(",".join(header_company) + "\n")  # Write input headers
                f.write(f"{current_datetime},{csv_file_name},{length_of_original},{insertion_success},{insertion_failure}\n")
        else:

            # Append the data
            with open(data_value_file, 'a') as f:
                # Write the header and data
                # f.write(f"{header_company}\n")
                f.write(f"{current_datetime},{csv_file_name},{length_of_original},{insertion_success},{insertion_failure}\n")
    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")


def append_to_data_for_sp_value_file(procedure_name, result, data_value_file):
    current_time=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(data_value_file, 'a') as f:
            f.write(f"current time {current_time} :procedure_name  {procedure_name}, result  {result}\n")
    except Exception as e:
        print(f"An error occurred while appending to the data value file: {e}")
        logger_error.error(f"An error occurred while appending to the data value file: {e}")






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
        if file.endswith(".csv") :
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


def move_to_history(current_date,source_file):
    """
    Method to move processed file to history
    :param current_date: Migration date time eg  202402260000
    :param source_file: Path of file to be moved
    :return: None
    """

    # Define the source file and history directory
    history_directory = f'{service_history_file_path}/{current_date}'

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


    file_table_mapper = {'migration_service_plan.csv': 'migration_service_plan',
                         'migration_service_plan_to_service_type.csv': 'migration_service_plan_to_service_type',
                         'migration_device_rate_plan.csv': 'migration_device_rate_plan',
                         'migration_service_apn_details.csv': 'migration_service_apn_details',
                         'migration_service_apn_ip.csv': 'migration_service_apn_ip',
                         'migration_sim_provisioned_range_details.csv': 'migration_sim_provisioned_range_details',
                         'migration_sim_provisioned_ranges_level1.csv':'migration_sim_provisioned_ranges_level1',
                         'migration_sim_provisioned_ranges_level2.csv': 'migration_sim_provisioned_ranges_level2',
                         'migration_sim_provisioned_ranges_level3.csv':'migration_sim_provisioned_ranges_level3',
                         'migration_assets_extended.csv' : 'migration_assets_extended',
                         'migration_assets.csv': 'migration_assets',
                         'migration_sim_provisioned_range_to_account_level3.csv' : 'migration_sim_provisioned_range_to_account_level3',
                         }

    try:
        for file in listdir(service_input_file_path):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                csv_file_name_all.append(file)
                csv_file_path_all.append(os.path.join(service_input_file_path, file))
    
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
        print("No input files found under  :{}".format(service_input_file_path))
        logger_info.info("No input files found under  :{}".format(service_input_file_path))
    
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
            ###single_insert_data
            dr_error, df_success = insert_batches_df_into_mysql(data_df, aircontrol_db_configs,
                                                                table_name,
                                                                logger_info, logger_error)
            append_to_data_value_file(table_name, len(data_df), len(df_success),
                                      len(dr_error),
                                      service_data_record_file)
            if not dr_error.empty:
                dr_error.to_csv(
                    os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)
    
        except Exception as e:
            print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

       # move_to_history(current_time_stamp, csv_file_path)

    # #####  Call Procedure ###############
    result11=call_procedure(aircontrol_procedure['device_rate_plan_procedure'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['device_rate_plan_procedure'], result11, service_procdure_record_file)
    result12=call_procedure(aircontrol_procedure['service_apn_details_procedure'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['service_apn_details_procedure'], result12,
                                     service_procdure_record_file)
    result13=call_procedure(aircontrol_procedure['service_apn_ip_procedure'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['service_apn_ip_procedure'], result13,
                                     service_procdure_record_file)
    result14=call_procedure(aircontrol_procedure['service_plan_info_procedure'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['service_plan_info_procedure'], result14,
                                     service_procdure_record_file)

    result16=call_procedure(aircontrol_procedure['migration_account_batch_mapping_procedure'], aircontrol_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['migration_account_batch_mapping_procedure'], result16,
                                     service_procdure_record_file)
    result17=call_procedure(aircontrol_procedure['migration_provisioned_range_procedure'], aircontrol_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['migration_provisioned_range_procedure'], result17,
                                     service_procdure_record_file)
    result18=call_procedure(aircontrol_procedure['bulk_insert_procedure'], aircontrol_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['bulk_insert_procedure'], result18,
                                     service_procdure_record_file)
    result15 = call_procedure(aircontrol_procedure['service_plan_to_service_type_procedure'], aircontrol_db_configs,
                              logger_error, logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['service_plan_to_service_type_procedure'], result15,
                                     service_procdure_record_file)

    ###################### Generating Error File #################################
    
    try:
        error_table_names = ['migration_assets_error_history', 'migration_assets_extended_error_history']
    
        if not os.path.exists(procedure_error_dir_aircontrol):
            os.makedirs(procedure_error_dir_aircontrol)
    
        for table_name in error_table_names:
            df = generate_procedure_error_file(aircontrol_db_configs, table_name, logger_error, logger_info)
            print('length of {} error file : {}'.format(table_name, len(df)))
            logger_info.info('length of {} error file : {}'.format(table_name, len(df)))
            if len(df) != 0:
                file_name = table_name + '_' + current_time_stamp + '.csv'
                df.to_csv(os.path.join(procedure_error_dir_aircontrol, file_name))
    
    except Exception as e:
        print('Error while generating error files {}'.format(e))
        logger_info.error('Error while generating error files {}'.format(e))
        logger_error.error('Error while generating error files {}'.format(e))
    

    logger_info.info("--------------Aircontrol Data Processing Ended-------------------")



def router_mapping():
    """
    1) This Method First truncate the table which are inside file_table_mapper and then insert the data in this table, if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    2) A procedure will be called which will return the result.
    3) Error occurred during procedure execution will be maintained in a table 'error_history_tables'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    """
    logger_info.info("--------------Router Data Processing Started-----------------")
    print("--------------Router Data Processing Started----------------------------")

    ###### Truncate Tables ##########

    truncate_mysql_table(goup_db_configs, 'migration_service_mapping', logger_error)
    truncate_mysql_table(router_db_configs, 'migration_assets', logger_error)

    goup_account_mapping = glob(os.path.join(goup_router_file_path, f"{router_spdp_file_prefix}*"))[0]

    account_mapping_df = pd.read_csv(goup_account_mapping, skipinitialspace=True, dtype=str)
    print(account_mapping_df.columns)
    print('Length of account mapping file : ', len(account_mapping_df))
    logger_info.info('Length of account mapping file :'.format(len(account_mapping_df)))

    try:
        account_mapping_df.replace({np.nan: None}, inplace=True)
        print(account_mapping_df)
        dr_error_asset, df_success_asset = insert_batches_df_into_mysql(account_mapping_df, goup_db_configs,
                                                                        "migration_service_mapping",
                                                                        logger_info, logger_error)
        append_to_data_value_file("migration_service_mapping", len(account_mapping_df), len(df_success_asset), len(dr_error_asset),
                                  service_router_data_record_file)
        if not dr_error_asset.empty:
            dr_error_asset.to_csv(
                os.path.join(insertion_error_dir_aircontrol, goup_insertion_error_file_name), index=False)

        # os.remove(csv_file_path)
        # exit(0)
    except Exception as e:
        print(e)
        logger_error.error(e)

    router_account_mapping = glob(os.path.join(goup_router_file_path, f"{asset_mapping_file_prefix}*"))[0]
    router_data_df = pd.read_csv(router_account_mapping, dtype=str)
    print(router_data_df.columns)
    print('Length of asset mapping file : ', len(account_mapping_df))
    logger_info.info('Length of asset mapping file :'.format(len(account_mapping_df)))

    try:
        router_data_df.replace({np.nan: None}, inplace=True)

        print(router_data_df)
        dr_error_asset, df_success_asset = insert_batches_df_into_mysql(router_data_df, router_db_configs,
                                                                       "migration_assets",
                                                                       logger_info, logger_error)
        append_to_data_value_file("migration_assets", len(router_data_df), len(df_success_asset), len(dr_error_asset),
                                  service_router_data_record_file)
        if not dr_error_asset.empty:
            dr_error_asset.to_csv(
                os.path.join(insertion_error_dir_aircontrol, router_insertion_error_file_name), index=False)

        # os.remove(csv_file_path)
        # exit(0)
    except Exception as e:
        print(e)
        logger_error.error(e)


    result1=call_procedure(goup_procedure['service_procedure'],goup_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(goup_procedure['service_procedure'], result1, service_procdure_router_record_file)
    result2=call_procedure(router_procedure['procedure_name'],router_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(router_procedure['procedure_name'], result2, service_procdure_router_record_file)



    ###################### Generating Error File #################################

    try:
        error_table_name_goup = 'migration_service_error_history'

        if not os.path.exists(procedure_error_dir_router):
            os.makedirs(procedure_error_dir_router)


        df_error_goup = generate_procedure_error_file(goup_db_configs, error_table_name_goup, logger_error, logger_info)
        print('length of {} error file : {}'.format(error_table_name_goup, len(df_error_goup)))
        logger_info.info('length of {} error file : {}'.format(error_table_name_goup, len(df_error_goup)))
        if len(df_error_goup) != 0:
            file_name = error_table_name_goup + '_' + current_time_stamp + '.csv'
            df_error_goup.to_csv(os.path.join(procedure_error_dir_router, file_name))

        error_table_name_router = 'migration_assets_error_history_router'

        df_error_router = generate_procedure_error_file(goup_db_configs, error_table_name_router, logger_error, logger_info)
        print('length of {} error file : {}'.format(error_table_name_router, len(df_error_router)))
        logger_info.info('length of {} error file : {}'.format(error_table_name_router, len(df_error_router)))
        if len(df_error_router) != 0:
            file_name = error_table_name_router + '_' + current_time_stamp + '.csv'
            df_error_router.to_csv(os.path.join(procedure_error_dir_router, file_name))

    except Exception as e:
        print('Error while generating error files {}'.format(e))
        logger_info.error('Error while generating error files {}'.format(e))
        logger_error.error('Error while generating error files {}'.format(e))


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "aircontrol":
            print("aircontrol")
            empty_csv_file(service_data_record_file)
            empty_csv_file(service_procdure_record_file)
            aircontrol_mapping()

        if arg == "goup":
            print("goup")
            empty_csv_file(service_router_data_record_file)
            empty_csv_file(service_procdure_router_record_file)
            router_mapping()
