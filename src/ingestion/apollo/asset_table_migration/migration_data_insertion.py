import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.apollo.config import *
dir_path = dirname(abspath(__file__))

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

insertion_error_dir_aircontrol = os.path.join(dir_path,'insertion_error')
procedure_error_dir_aircontrol = os.path.join(dir_path,'procedure_error_aircontrol')
insertion_error_dir_router = os.path.join(dir_path,'insertion_error')
procedure_error_dir_router = os.path.join(dir_path,'procedure_error_router')



logs = {
    "migration_info_logger":f"stc_ingestion_asset_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_ingestion_asset_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()



# try:
#     for file in listdir(dir_path):
#         if file.endswith(".csv") :
#             delete_csv_file_path = None
#             delete_csv_file_path = os.path.join(dir_path, file)
#             os.remove(delete_csv_file_path)
# except Exception as e:
#     print("Delete csv/txt error :", e)



def convert_timestamps_to_string(row_data):
    """
    :param row_data: dataframe row data
    :return: this function will return the converted row data
    """
    for key, value in row_data.items():
        if isinstance(value, pd.Timestamp):
            row_data[key] = value.strftime('%Y-%m-%d %H:%M:%S')
    return row_data



def update_ent_account_and_device_plan(df, update_dict):
    """
    Updates the 'ENT_ACCOUNTID' and 'DEVICE_PLAN_ID' columns of the DataFrame based on the given dictionary.

    Parameters:
    df (pd.DataFrame): The DataFrame to update.
    update_dict (dict): A dictionary where keys are 'ENT_ACCOUNTID' and values are 'DEVICE_PLAN_ID'.

    Returns:
    pd.DataFrame: The updated DataFrame.
    """
    try:
        # Calculate the chunk size
        chunk_size = len(df) // len(update_dict)
        remaining = len(df) % len(update_dict)

        # Ensure 'ENT_ACCOUNTID' and 'DEVICE_PLAN_ID' columns exist in the DataFrame
        if 'ENT_ACCOUNTID' not in df.columns:
            df['ENT_ACCOUNTID'] = np.nan
        if 'DEVICE_PLAN_ID' not in df.columns:
            df['DEVICE_PLAN_ID'] = np.nan

        # Update the DataFrame in chunks
        start = 0
        for i, (ent_account_id, device_plan_id) in enumerate(update_dict.items()):
            end = start + chunk_size
            if i < remaining:  # Distribute the remaining rows
                end += 1
            df.loc[start:end, 'ENT_ACCOUNTID'] = ent_account_id
            df.loc[start:end, 'DEVICE_PLAN_ID'] = device_plan_id
            start = end + 1

        return df

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")
        return df

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



def aircontrol_mapping():
    """
    1) This Method First truncate the table 'migration_assets' , 'migration_assets_extended' and then
    2) It will First fetech the maxid of assets and asset extended tables increment the max id by 1 and
    then fill that in id column of asset and asset extended files dataframe.
    3) Insert the data in 'migration_assets' , 'migration_assets_extended' tables, if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    4) A procedure will be called which will return the result.
    5) Error occurred during procedure execution will be maintained in a table 'migration_assets_extended_error_history'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    :return:
    """
    logger_info.info("--------------Aircontrol Data Processing Started-------------------")
    print("--------------Aircontrol Data Processing Started------------------------------")

    asset_csv_file_name_all = []
    asset_csv_file_path_all = []
    asset_extended_csv_file_name_all = []
    asset_extended_csv_file_path_all = []

    try:

        for file in listdir(aircontrol_file_path['file_path_assets']):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                asset_csv_file_name_all.append(file)
                asset_csv_file_path_all.append(os.path.join(aircontrol_file_path['file_path_assets'], file))
        asset_extended_file_path_all = aircontrol_file_path['file_path_asset_extended']

        for file in listdir(asset_extended_file_path_all):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                asset_extended_csv_file_name_all.append(file)
                asset_extended_csv_file_path_all.append(os.path.join(asset_extended_file_path_all, file))

    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))


    ##########  Extended Access   #######################

    ###### Truncate Tables ##########
    truncate_mysql_table(aircontrol_db_configs, 'migration_assets_extended', logger_error)
    truncate_mysql_table(aircontrol_db_configs, 'migration_assets', logger_error)

    length_of_extended_csv_files = len(asset_extended_csv_file_name_all)
    print(length_of_extended_csv_files)
    try:
        asset_extended_fetch_max_id = "SELECT MAX(id) AS max_id FROM (SELECT id FROM assets UNION \
        SELECT id FROM assets_extended) AS combined_ids;"
        maxid_extended = sql_query_fetch(asset_extended_fetch_max_id,aircontrol_db_configs,logger_error)
        maxid_extended = maxid_extended[0][0]
        print("max id ",maxid_extended)
    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))
        exit(0)



    filename_extended = asset_extended_csv_file_name_all[0]
    csv_file_path_extended = asset_extended_csv_file_path_all[0]
    logger_info.info(f"------------{filename_extended}------------")
    logger_error.error(f"------------{filename_extended}------------")
    print('csv path asset extended',csv_file_path_extended)


    data_df = pd.read_csv(csv_file_path_extended, skipinitialspace=True,dtype=str)
    print(data_df.columns)

    length_of_asset_csv_files = len(asset_csv_file_name_all)

    print(length_of_asset_csv_files)

    filename_asset = asset_csv_file_name_all[0]
    csv_file_path_asset = asset_csv_file_path_all[0]
    logger_info.info(f"------------{filename_asset}------------")
    logger_error.error(f"------------{filename_asset}------------")
    print('csv path assets', csv_file_path_asset)

    data_assets_df = pd.read_csv(csv_file_path_asset, skipinitialspace=True,dtype=str)
    
    # # data_assets_df=update_ent_account_and_device_plan(data_assets_df, update_dict)
    # data_assets_df.to_csv("asstest_for_tesing.csv",index=False)
    # print(data_assets_df.columns)

    if len(data_df) == len(data_assets_df):
        try:

            data_df = update_column(data_df, 'ID', maxid_extended)
            data_df.replace({np.nan: None}, inplace=True)
            # data_df.replace('', None, inplace=True)
            print(data_df)
            data_df.to_csv('out_asset_extended.csv',index_label=False)
           
            dr_error_extended,df_success_extended = insert_batches_df_into_mysql(data_df, aircontrol_db_configs, "migration_assets_extended", logger_info, logger_error)
            if not dr_error_extended.empty:
                dr_error_extended.to_csv(
                    os.path.join(insertion_error_dir_aircontrol, assets_extended_insertion_error_filename), index=False)

        except Exception as e:
            print(e)
            logger_info.error('Error while inserting data into db {}'.format(e))
            logger_error.error('Error while inserting data into db {}'.format(e))


        ######### Assests #############################

        try:
            data_assets_df = update_column(data_assets_df, 'ID', maxid_extended)
            data_assets_df = update_column(data_assets_df, 'ASSETS_EXTENDED_ID', maxid_extended)
            data_assets_df["IP_ADDRESS"] = data_assets_df["IP_ADDRESS"].fillna("000.000.000.000")
            data_assets_df.replace({np.nan: None}, inplace=True)
            #data_assets_df["IP_ADDRESS"] = data_assets_df["IP_ADDRESS"].apply(lambda x: "000.000.000.000" if x != None else x)
            # data_df.replace('', , inplace=True)
            data_assets_df.to_csv('out_asset.csv', index_label=False)


            print(data_assets_df)

            dr_error_asset, df_success_asset = insert_batches_df_into_mysql(data_assets_df, aircontrol_db_configs,
                                                                                 "migration_assets",
                                                                              logger_info, logger_error)
            if not dr_error_asset.empty:
                dr_error_asset.to_csv(
                    os.path.join(insertion_error_dir_aircontrol,assets_insertion_error_filename), index=False)

        except Exception as e:
            print(e)
            logger_info.error('Error while inserting data into db {}'.format(e))
            logger_error.error('Error while inserting data into db {}'.format(e))

        #####  Call Procedure ###############
        call_procedure(aircontrol_db_configs['procedure_name'],aircontrol_db_configs,logger_error,logger_info)

        migration_asset_error = "select * from  migration_assets_error_history;"
        migration_asset_extended_error = "select * from  migration_assets_extended_error_history;"

        asset_extended_column_name = data_df.columns.values
        # print('column names',asset_extended_column_name)
        asset_extended_column_names = np.append(asset_extended_column_name,'error_message')
        asset_column_name = list(data_assets_df.columns.values)
        asset_column_names = np.append(asset_column_name,'error_message')
        generate_procedure_error_file(migration_asset_extended_error, aircontrol_db_configs, asset_extended_column_names,
                                      procedure_error_dir_aircontrol,asset_extended_error_file_name,logger_error, logger_info)

        generate_procedure_error_file(migration_asset_error, aircontrol_db_configs,
                                      asset_column_names,
                                      procedure_error_dir_aircontrol, asset_error_file_name, logger_error,
                                      logger_info)

        logger_info.info("--------------Aircontrol Data Processing Ended-------------------")
    else:
        print("Length of Files Asset Extended and Assets are not matching")
        logger_info.error("Length of Files Asset Extended and Assets are not matching")
        logger_error.error("Length of Files Asset Extended and Assets are not matching")


def router_mapping():
    """
    1) This Method First truncate the table 'migration_assets' and then insert the data in this table, if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    2) A procedure will be called which will return the result.
    3) Error occurred during procedure execution will be maintained in a table 'migration_assets_error_history_router'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    """
    logger_info.info("--------------Router Data Processing Started-----------------")
    print("--------------Router Data Processing Started----------------------------")

    ###### Truncate Tables ##########
    # print("db details",router_db_configs)
    truncate_mysql_table(router_db_configs, 'migration_assets', logger_error)

    router_csv_file_name_all = []
    router_csv_file_path_all = []

    try:
        for file in listdir(router_file_path['file_path_router']):
            if (file.endswith(".csv") or file.endswith(".xlsx")):
                router_csv_file_name_all.append(file)
                router_csv_file_path_all.append(os.path.join(router_file_path['file_path_router'], file))
    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))

    length_of_router_csv_files = len(router_csv_file_name_all)
    print(length_of_router_csv_files)
    print("path : ",router_csv_file_path_all)
    filename = router_csv_file_name_all[0]
    csv_file_path = router_csv_file_path_all[0]
    logger_info.info(f"------------{filename}------------")
    logger_error.error(f"------------{filename}------------")
    print('csv path router',csv_file_path)
    data_df = pd.read_csv(csv_file_path, dtype=str)
    print(data_df.columns)

    try:
        data_df.replace({np.nan: None}, inplace=True)

        print(data_df)
        dr_error_asset, df_success_asset = insert_batches_df_into_mysql(data_df, router_db_configs,
                                                                       "migration_assets",
                                                                       logger_info, logger_error)

        if not dr_error_asset.empty:
            dr_error_asset.to_csv(
                os.path.join(insertion_error_dir_aircontrol, router_insertion_error_file_name), index=False)

        # os.remove(csv_file_path)
        # exit(0)
    except Exception as e:
        print(e)
        logger_error.error(e)

    call_procedure(router_db_configs['procedure_name'],router_db_configs, logger_error, logger_info)

    ###################### Generating Error File #################################
    fetch_error_success = "select * from  migration_assets_error_history_router;"
    asset_column_name = ['ID','ICCID','IMSI','MSISDN','Error_Message']

    generate_procedure_error_file(fetch_error_success, router_db_configs, asset_column_name,
                                  procedure_error_dir_router, router_error_file_name, logger_error, logger_info)

    logger_info.info("--------------Router Data Processing Ended-------------------")


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "aircontrol":
            print("aircontrol")
            aircontrol_mapping()

        if arg == "router":
            print("router")
            router_mapping()
