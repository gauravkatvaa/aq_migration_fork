import sys
# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.custom.metis.config import *
from conf.config import *
import datetime
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

insertion_error_dir = os.path.join(dir_path,'Insertion_Error')
procedure_error_dir = os.path.join(dir_path,'Procedure_Error_Aircontrol')

logs = {
    "migration_info_logger":f"maxis_transformation_info_{current_time_stamp}.log",
    "migration_error_logger":f"maxis_transformation_error_{current_time_stamp}.log"
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
        df.at[i, column_name] = initial_value + i
        # print(initial_value + i)
    return df
def process_dataframe_for_service(df):
    # Connect to the MySQL database
    ##run the quey and insert into the df the resukt


    try:
        connection = mysql.connector.connect(
            host=aircontrol_db_configs["HOST"],
            user=aircontrol_db_configs["USER"],
            password=aircontrol_db_configs["PASSWORD"],
            database=aircontrol_db_configs["DATABASE"],
            port=aircontrol_db_configs["PORT"]
        )

         # Replace with your actual query
        cursor = connection.cursor()
        # query = db_config["query"]
        query = "SELECT IFNULL(MAX(id),0)+1 FROM accounts;"
        cursor.execute(query)
        data=cursor.fetchall()
        print("reslutofquery",data[0][0])
        connection.commit()
        cursor.close()
        connection.close()

        df['ID']=np.nan
        df=update_column(df,'ID',data[0][0]+base_offset)
        df['ID']= df['ID'].astype(int)
        df.reset_index(drop=True, inplace=True)

        # print("updated")

        print("updated_code",df)

        return df


    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Close the database connection
        connection.close()




def calulate_dataframe():
    your_dataframe = pd.read_csv("new_file2.csv")
    try:
        # Create a dictionary to store Level 1 values in key-value pairs
        level1_dict = dict(zip(your_dataframe[your_dataframe['LEVEL'] == 1]['ACCOUNT_NO'],
                               your_dataframe[your_dataframe['LEVEL'] == 1]['ID']))

        # Create a new column 'LEVEL_1_ACCOUNT_ID' based on conditions
        your_dataframe['PARENT_ACCOUNT_ID'] = your_dataframe.apply(
            lambda row: level1_dict.get(row['MASTER_ACCOUNT_NO']) if row['LEVEL'] == 2 else None,
            axis=1
        )
        your_dataframe['PARENT_ACCOUNT_ID'] = your_dataframe['PARENT_ACCOUNT_ID'].apply(lambda x: str(int(x)) if not pd.isnull(x) else None)
        # print(your_dataframe)
        your_dataframe.reset_index(drop=True, inplace=True)

        # your_dataframe.to_csv("yogesu2.csv")
        return your_dataframe
    except Exception as e:
        logger_error.error("file for datafram is not found error is {}".format(e))
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
        logger_error.error("time_string facing issue in parse_datetime function error is {}".format(e))

    return parsed_time



def process_dataframe(data_df):
    # Check for duplicate values in the 'brn' column
    duplicate_brn = data_df.duplicated(subset='brn', keep=False)

    if any(duplicate_brn):
        # Filter rows with duplicate 'brn' values
        duplicate_rows = data_df[duplicate_brn]

        # Sort by 'last_login' in descending order within each group of duplicate 'brn' values
        duplicate_rows = duplicate_rows.sort_values(by=['brn', 'last_login'], ascending=[True, False])

        # Drop duplicates based on 'brn' and 'role_name', keeping the first occurrence (latest 'last_login')
        data_df = data_df.drop_duplicates(subset=['brn', 'role_name'], keep='first')

    return data_df
def convert_date_columns(data_df):
    try:
        if 'SERVICE_ACTIVE_DT' in data_df.columns:
            data_df['SERVICE_ACTIVE_DT'] = pd.to_datetime(data_df['SERVICE_ACTIVE_DT'], errors='coerce')
            data_df['SERVICE_ACTIVE_DT'] = data_df['SERVICE_ACTIVE_DT'].dt.strftime('%Y-%m-%d %H:%M:%S')

        if 'SERVICE_INACTIVE_DT' in data_df.columns:
            data_df['SERVICE_INACTIVE_DT'] = pd.to_datetime(data_df['SERVICE_INACTIVE_DT'], errors='coerce')
            data_df['SERVICE_INACTIVE_DT'] = data_df['SERVICE_INACTIVE_DT'].dt.strftime('%Y-%m-%d %H:%M:%S')
            # print("insidefunction",data_df['SERVICE_INACTIVE_DT'])

        if 'SERVICE_STATUS_CHG_DATE' in data_df.columns:
            data_df['SERVICE_STATUS_CHG_DATE'] = pd.to_datetime(data_df['SERVICE_STATUS_CHG_DATE'], errors='coerce')
            data_df['SERVICE_STATUS_CHG_DATE'] = data_df['SERVICE_STATUS_CHG_DATE'].dt.strftime('%Y-%m-%d %H:%M:%S')

        if 'CONTRACT_START_DATE' in data_df.columns:
            data_df['CONTRACT_START_DATE'] = pd.to_datetime(data_df['CONTRACT_START_DATE'], errors='coerce')
            data_df['CONTRACT_START_DATE'] = data_df['CONTRACT_START_DATE'].dt.strftime('%Y-%m-%d %H:%M:%S')

        if 'CONTRACT_END_DATE' in data_df.columns:
            data_df['CONTRACT_END_DATE'] = pd.to_datetime(data_df['CONTRACT_END_DATE'], errors='coerce')
            data_df['CONTRACT_END_DATE'] = data_df['CONTRACT_END_DATE'].dt.strftime('%Y-%m-%d %H:%M:%S')

        return data_df
    except Exception as e:
        logger_error.error('No df found so we do not reason {}'.format(e))

def append_to_data_value_file(current_time,procedure_name, success_count, fail_count, data_value_file):
    try:
        with open(data_value_file, 'a') as f:
            f.write(f"current time{current_time}:{procedure_name}, Success:{success_count}, Fail:{fail_count}\n")
    except Exception as e:
        print(f"An error occurred while appending to the data value file: {e}")
        logger_error.error(f"An error occurred while appending to the data value file: {e}")


def empty_csv_file(file_name):
    try:
        current_directory = os.getcwd()
        file_path = os.path.join(current_directory, file_name)
        with open(file_path, 'w') as f:
            f.write('')
        print("data_from_file delete")
        return True
    except Exception as e:
        print(f"An error occurred while emptying the file: {str(e)}")
        logger_error.error(f"An error occurred while emptying the file: {str(e)}")
        return False

def pull_transformed_data_from_sp():
    """
    Method to call stored procedure for each output file and place on destination path defined in config
    :return: None
    """
    logger_info.info("-------------- Pull transformed data from DP Started -------------------")
    print("-------------- Pull transformed data from DP Started -------------------")

    file_sp_mapper = {

        'migration_contact_info.csv': 'migration_contect_info_procedure',
        'migration_account_extended.csv': 'migration_account_extended_procedure',
        'migration_accounts.csv': 'migration_account_procedure',
        'migration_account_goup_mappings.csv': 'migration_account_goup_mappings_procedure',
        'migration_zones.csv': 'migration_zone_procedure',
        'migration_zone_to_country.csv': 'migration_zone_to_country_procedure',
        'migration_role_access.csv': 'migration_role_access_procedure',
        'migration_role_to_screen_mapping.csv': 'migration_role_to_screen_mapping_procedure',
        'migration_role_to_tab_mapping.csv': 'migration_role_to_tab_mapping_procedure',
        'migration_price_model_rate_plan.csv':'migration_price_model_rate_plan_procedure',
        #'price_service_type.csv':'/M2M_Company_Files/',
        'migration_price_to_model_type.csv':'migration_price_to_model_type_procedure',
        'migration_pricing_categories.csv':'migration_pricing_categories_procedure',
        'migration_whole_sale_rate_plan.csv':'migration_whole_sale_rate_plan_procedure',
        'migration_whole_sale_to_pricing_categories.csv':'migration_whole_sale_to_pricing_categories_procedure',
        'migration_account_mapping.csv': 'migration_accounts_goup_procedure',
        ##user
        'migration_users.csv': 'migration_users_procedure',
        'migration_user_details.csv': 'migration_user_details_procedure',
        'migration_contect_info_procedure.csv': 'migration_user_contect_info_procedure',
        'migration_user_extended_accounts.csv': 'migration_users_extended_account_procedure',

        ##sevice
        'migration_service_plan.csv': 'migration_service_plan_info_procedure',
        'migration_service_plan_to_service_type.csv': 'migration_service_plan_to_service_type_info_procedure',
        'migration_device_rate_plan.csv': 'migration_device_rate_plan_procedure',
        'migration_service_apn_details.csv': 'migration_service_apn_details_procedure',
        'migration_service_apn_ip.csv': 'migration_service_apn_ip_procedure',
        #

        # ##routerandassest
        'migration_sim_provisioned_range_details.csv': 'migration_sim_provisioned_range_details_procedure',
        # 'data.csv':'migration_account_batch_mapping_procedure',
        'migration_sim_provisioned_ranges_level1.csv': 'migration_sim_provisioned_ranges_level1_procedure',
        'migration_sim_provisioned_ranges_level2.csv': 'migration_sim_provisioned_ranges_level2_procedure',
        'migration_sim_provisioned_ranges_level3.csv': 'migration_sim_provisioned_ranges_level3_procedure',
        'migration_assets_extended.csv': 'migration_asset_extended_procedure',
        'migration_assets.csv': 'migration_assests_details_procedure',
        'migration_sim_provisioned_range_to_account_level3.csv': 'migration_sim_provisioned_ranges_to_account_procedure',

        ###service_Table(Goup amd Router)
        'migration_goup_assets.csv': 'migration_goup_assets_procedure',
        'migration_goup_service_plan.csv':'migration_goup_service_procedure',

    }

    try:
        for migrated_data_file, sp_call in file_sp_mapper.items() :
            logger_info.info('Calling SP {} to fetch data'.format(sp_call))
            resultset,column_names = call_procedure(sp_call,migration_db_configs,logger_error,logger_info)
            #print('row values',resultset)
            if resultset :
                df = pd.DataFrame(resultset, columns=column_names,dtype=str)

                path = "%s%s"%(output_file_base_dir,output_file_path[migrated_data_file])
                #print(path)
                file_path=path+migrated_data_file
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
                current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                append_to_data_value_file(current_time,sp_call, len(resultset),0,sp_result_values_file)
                logger_info.info('Output file generated by SP {} is placed at {}'.format(sp_call,path))

            else:
                logger_info.info('SP {} no return data'.format(sp_call))


    except Exception as e:
        logger_info.error('Error while writing {} file data from db {}'.format(migrated_data_file, e))
        logger_error.error('Error while writing {} file data from db {}'.format(migrated_data_file, e))



def push_input_to_migration():
    """
        Method to call sql insert query  for each input file and place on destination path defined in config
        :return: None
    """
    logger_info.info("--------------Push Input Data Started-------------------")
    print("--------------Push Input Data Started------------------------------")

    csv_file_name_all = []
    csv_file_path_all = []

    current_date = datetime.datetime.now().strftime("%Y%m%d%H%M")
    file_table_mapper = {
        'eCMP_M2M_Service_Status.csv':'ecmp_service_status',
        'eCMP_M2M_Company.csv':'ecmp_m2m_company',
        '6_users.csv':'pic_user',
        'contact_list_users.csv':'pic_user',

        # Add more file-to-table mappings as needed
    }

    try:
        for file in listdir(input_file_path):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                csv_file_name_all.append(file)
                csv_file_path_all.append(os.path.join(input_file_path, file))

    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))

    if len(csv_file_name_all):

        ###### Truncate Tables ##########
        for table in file_table_mapper.values() :
            logger_info.info(f"Truncating table : %s", table )
            # Commented for testing
            truncate_mysql_table(migration_db_configs, table, logger_error)


    else:
        print("No input files found under  :{}".format(input_file_path))
        logger_info.info("No input files found under  :{}".format(input_file_path))

    ###### Process each file ########
    for csv_file_path in csv_file_path_all:
        try:
            insertion_error_filename = csv_file_path.split("/")[-1]
            data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str,keep_default_na=False)
            # data_df.replace({np.nan: None}, inplace=True)
            # data_df = data_df.replace({np.nan:None},inplace=True)
            # data_df.fillna("", inplace=True)
            data_df.columns = data_df.columns.str.replace(' ', '_')

            logger_info.info(f"Loaded file  : %s", csv_file_path)

            logger_info.info(f"Row count : %s" % len(data_df))
            table_name = file_table_mapper[csv_file_path.split("/")[-1]]
            logger_info.info(f"Target table : %s Columns : %s " % (table_name, data_df.columns))
            if table_name == 'ecmp_m2m_company':
                data_df['BILL_COMPANY'] = data_df['BILL_COMPANY'] + '_' + data_df['EXT_ACCOUNT_NO']

                data_df['ACCOUNT_TYPE'].replace({'non-billable': 0, 'billable': 1}, inplace=True)
                data_df['BILL_PERIOD'].replace('^B', '', regex=True, inplace=True)
                data_df = data_df.applymap(str)

            if table_name == 'ecmp_m2m_company':
                print("table_calling")
                data_df=process_dataframe_for_service(data_df)
                data_df.to_csv("new_file2.csv", index=False)
                data_df=calulate_dataframe()
                data_df = data_df.applymap(str)
            if table_name =='pic_user':
                count=1
                for index, row in data_df.iterrows():

                    if row['email'].startswith('dummy'):
                        # Split the email address into local part and domain part
                        local_part, domain_part = row['email'].split('@')
                        # Append "_row[brn]" to the local part
                        new_email = f"{local_part}_{row['brn']}@{domain_part}"
                        data_df.at[index, 'email'] = new_email
                        count += 1


                    if row['login_name'].startswith('dummy'):
                        local_part, domain_part = row['login_name'].split('@')
                        # Append "_row[brn]" to the local part
                        new_login_name = f"{local_part}_{row['brn']}@{domain_part}"
                        data_df.at[index, 'login_name'] = new_login_name
                        count += 1

                # print("count of user those have dummy that we have changes ",count)
                logger_info.info(f"count of user those have dummy that we have changes ,{count}")


            if table_name == 'ecmp_service_status':
                data_df['BILL_COMPANY'] = data_df['BILL_COMPANY'] + '_' + data_df['EXT_ACCOUNT_NO']
                data_df['BILL_PERIOD'].replace('^B', '', regex=True, inplace=True)
                # data_df = data_df[~data_df['STATUS_ID'].isin(['Transferred In', 'Transferred Out'])]
                data_df['STATUS_ID'].replace('Transferred In','Active',regex=True,inplace=True)
                data_df=convert_date_columns(data_df)
                #data_df.replace({np.nan: None}, inplace=True)
                data_df = data_df.applymap(str)


            #data_df.replace({np.nan: None}, inplace=True)


            # print(data_df)
            # data_df.to_csv("new3_file.csv", index=False)

            ##single_insert_data_using_chunks
            dr_error, df_success = insert_batches_df_into_mysql(data_df, migration_db_configs,
                                                                                     table_name,
                                                                                  logger_info, logger_error)
            current_time=datetime.datetime.now().strftime("%Y%m%d%H%M")
            append_to_data_value_file(current_time,table_name, len(df_success), len(dr_error),file_result_values)
            if not dr_error.empty:
                    dr_error.to_csv(
                            os.path.join(insertion_error_dir,insertion_error_filename), index=False)

        except Exception as e:
            print('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_info.error('Error while inserting {} file data into db {}'.format(insertion_error_filename, e))
            logger_error.error('Error while inserting {} data into db {}'.format(insertion_error_filename, e))

    ## Move file to history
#        move_to_history(current_date, csv_file_path)

    logger_info.info("-------------- Data Processing Ended-------------------")

if __name__ == "__main__":
    empty_csv_file(file_result_values)
    push_input_to_migration()
    print("Initiating file creation")
    empty_csv_file(sp_result_values_file)
    pull_transformed_data_from_sp()




