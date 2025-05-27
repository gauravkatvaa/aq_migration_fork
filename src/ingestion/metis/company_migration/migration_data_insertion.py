import sys
# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.custom.metis.config import *
from conf.config import *
from os import listdir
dir_path = dirname(abspath(__file__))

import datetime
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"maxis_ingestion_company_info_{current_time_stamp}.log",
    "migration_error_logger":f"maxis_ingestion_company_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

insertion_error_dir_aircontrol = os.path.join(dir_path, 'Insertion_Error')
# print('insertion path ',insertion_error_dir_aircontrol)
procedure_error_dir_aircontrol = os.path.join(dir_path, 'Procedure_Error_Company')
insertion_error_dir_router = os.path.join(dir_path, 'Insertion_Error')
procedure_error_dir_router = os.path.join(dir_path, 'Procedure_Error_Goup')

############ Error File Names #######################################################
asset_procedure_error_file_name = asset_error_file_name + "_" + current_time_stamp + ".csv"
asset__extended_procedure_error_file_name = asset_extended_error_file_name + "_" + current_time_stamp + ".csv"
router_procedure_error_file_name = router_error_file_name + "_" + current_time_stamp + ".csv"


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
            f.write(f"current time  {current_time}:procedure_name  {procedure_name}, result {result}\n")
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
    history_directory = f'{company_history_file_path}/{current_date}'

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
    ##########  Contact Info   #######################

    file_table_mapper = {'migration_contact_info.csv': 'migration_contact_info', 'migration_account_extended.csv': 'migration_account_extended',
                        'migration_accounts.csv': 'migration_accounts', 'migration_account_goup_mappings.csv': 'migration_account_goup_mappings',
                        'migration_zones.csv': 'migration_zones', 'migration_zone_to_country.csv': 'migration_zone_to_country',
                        'migration_role_access.csv': 'migration_role_access',
                        'migration_role_to_screen_mapping.csv': 'migration_role_to_screen_mapping',
                        'migration_role_to_tab_mapping.csv': 'migration_role_to_tab_mapping',
                        'migration_price_model_rate_plan.csv': 'migration_price_model_rate_plan',
                        # 'migration_price_service_type.csv': 'migration_price_service_type',
                        'migration_price_to_model_type.csv': 'migration_price_to_model_type',
                        'migration_pricing_categories.csv': 'migration_pricing_categories',
                        'migration_whole_sale_rate_plan.csv': 'migration_whole_sale_rate_plan',
                        'migration_whole_sale_to_pricing_categories.csv': 'migration_whole_sale_to_pricing_categories',
                        'migration_users.csv': 'migration_users', 'migration_user_details.csv': 'migration_user_details',
                        'migration_contect_info_procedure.csv': 'migration_contact_info',
                        'migration_user_extended_accounts.csv':'migration_user_extended_accounts'}

    try:
        for file in listdir(company_input_file_path):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                csv_file_name_all.append(file)
                csv_file_path_all.append(os.path.join(company_input_file_path, file))

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
        print("No input files found under  :{}".format(company_input_file_path))
        logger_info.info("No input files found under  :{}".format(company_input_file_path))

    print('length of path',len(csv_file_path_all))
    ######  Process each file ########
    for csv_file_path in csv_file_path_all:
        print("csv file path : ",csv_file_path)
        try:
            insertion_error_filename = csv_file_path.split("/")[-1]

            data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str)
            data_df.replace({np.nan: None}, inplace=True)
            logger_info.info(f"Loaded file  : %s", csv_file_path)
            print('Loaded File : ',csv_file_path)
            print('Row Count : ',len(data_df))
            logger_info.info(f"Row count : %s" % len(data_df))
            table_name = file_table_mapper[csv_file_path.split("/")[-1]]
            logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))
            # print('table',table_name)
            ###single_insert_data
            dr_error, df_success = insert_batches_df_into_mysql(data_df, aircontrol_db_configs,
                                                               table_name,
                                                               logger_info, logger_error)

            append_to_data_value_file(table_name, len(data_df), len(df_success), len(dr_error),
                                      company_data_record_file)
            if not dr_error.empty:
                dr_error.to_csv(
                    os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)

        except Exception as e:
            print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

        # Move file to history
#        move_to_history(current_time_stamp,csv_file_path)


    # ###  Call Procedure ###############
    result_1=call_procedure(aircontrol_procedure['account_bulk_insert'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['account_bulk_insert'],  result_1, company_procdure_record_file)
    result_2=call_procedure(aircontrol_procedure['organization_procedure_name'],aircontrol_db_configs,logger_error,logger_info)
    append_to_data_for_sp_value_file(aircontrol_procedure['organization_procedure_name'], result_2, company_procdure_record_file)
    ###################### Generating Error File #################################

    try:
        error_table_names = ['migration_tracking_history','migration_accounts_error_history','migration_accounts_extended_error_history']

        if not os.path.exists(procedure_error_dir_aircontrol):
            os.makedirs(procedure_error_dir_aircontrol)

        for table_name in error_table_names:
            df = generate_procedure_error_file(aircontrol_db_configs, table_name, logger_error, logger_info)
            print('length of {} error file : {}'.format(table_name,len(df)))
            logger_info.info('length of {} error file : {}'.format(table_name,len(df)))
            if len(df)!=0:
                file_name = table_name + '_' + current_time_stamp + '.csv'
                df.to_csv(os.path.join(procedure_error_dir_aircontrol,file_name))
    
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
    logger_info.info("--------------Goup Data Processing Started-----------------")
    print("--------------Goup Data Processing Started----------------------------")
    csv_file_name_all = []
    csv_file_path_all = []

    file_table_mapper = {
        'migration_account_mapping.csv': 'migration_account_mapping',

    }

    try:
        for file in listdir(goup_file_path):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                csv_file_name_all.append(file)
                csv_file_path_all.append(os.path.join(goup_file_path, file))

    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))

    if len(csv_file_name_all):
        ###### Truncate Tables ##########
        for table in file_table_mapper.values():
            logger_info.info(f"Truncating table : %s", table)
            # Commented for testing
            truncate_mysql_table(goup_db_configs, table, logger_error)
    else:
        print("No input files found under  :{}".format(goup_file_path))
        logger_info.info("No input files found under  :{}".format(goup_file_path))


    ######  Process each file ########
    for csv_file_path in csv_file_path_all:
        try:
            insertion_error_filename = csv_file_path.split("/")[-1]

            data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str)
            data_df.replace({np.nan: None}, inplace=True)
            logger_info.info(f"Loaded file  : %s", csv_file_path)
            logger_info.info(f"Row count : %s" % len(data_df))
            table_name = file_table_mapper[csv_file_path.split("/")[-1]]
            logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))

            ##single_insert_data
            dr_error, df_success = insert_batches_df_into_mysql(data_df, goup_db_configs,
                                                                       table_name,
                                                                       logger_info, logger_error)

            append_to_data_value_file(table_name,len(data_df),len(df_success),len(dr_error),company_router_data_record_file)

            if not dr_error.empty:
                dr_error.to_csv(
                    os.path.join(insertion_error_dir_aircontrol, insertion_error_filename), index=False)

        except Exception as e:
            print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

        ## Move file to history
        # move_to_history(current_time_stamp, csv_file_path)


    result_3=call_procedure(goup_procedure['account_procedure'],goup_db_configs, logger_error, logger_info)
    append_to_data_for_sp_value_file(goup_procedure['account_procedure'], result_3, company_procdure_router_record_file)

    # ###################### Generating Error File #################################

    table_name = 'migration_accounts_error_history'
    df = generate_procedure_error_file(goup_db_configs, table_name, logger_error, logger_info)
    print('length of {} error file : {}'.format(table_name,len(df)))
    logger_info.info('length of {} error file : {}'.format(table_name,len(df)))
    if len(df)!=0:
        file_name = table_name + '_' + current_time_stamp + '.csv'
        if not os.path.exists(procedure_error_dir_router):
            os.makedirs(procedure_error_dir_router)
        df.to_csv(os.path.join(procedure_error_dir_router,file_name))

    logger_info.info("--------------Goup Data Processing Ended-------------------")


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))


    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "aircontrol":
            print("aircontrol")
            empty_csv_file(company_data_record_file)
            empty_csv_file(company_procdure_record_file)
            aircontrol_mapping()

        if arg == "goup":
            print("goup")
            empty_csv_file(company_router_data_record_file)
            empty_csv_file(company_procdure_router_record_file)
            router_mapping()
