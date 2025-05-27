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
    "migration_info_logger":f"stc_ingestion_ocs_asset_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_ingestion_ocs_asset_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def ac_fetch_account_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    # print('crn',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT NOTIFICATION_UUID,COS_ID FROM accounts WHERE NOTIFICATION_UUID IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,reference_number,aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None


# def ocs_mapping():
#     """
#     1) This Method First truncate the table.
#     2) Insert the data in the table names given in file_table_mapper if any failure
#     while insertion an error file will be generated in 'Insertion_Error' directory.
#     3) A procedure will be called which will return the result.
#     4) Error occurred during procedure execution will be maintained in a table 'error_history_table'
#     a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
#     :return: None
#     """

#     logger_info.info("--------------OCS Data Processing Started-------------------")
#     print("--------------OCS Data Processing Started------------------------------")

#     df = pd.read_csv(ocs_file_path,skipinitialspace=True, dtype=str,keep_default_na=False)
#     try:
#         filtered_df = df[~df['STATE'].isin(['Warm', 'TestReady'])]
#         print('File Length : ',len(filtered_df))
#         columns = ['cosId', 'isRange', 'type', 'rangeFrom', 'rangeTo', 'number', 'status', 'user']

#         data = []
#         ent_id = list(filtered_df['ENT_ACCOUNTID'])
#         # print(ent_id)
#         querry = "SELECT COS_ID FROM accounts WHERE NOTIFICATION_UUID="
#         ocsId,not_found_uuid = sql_query_fetch_single_conn(querry,ent_id, aircontrol_db_configs, logger_error)

#         if ocsId:
#             filtered_df = filtered_df[~filtered_df['ENT_ACCOUNTID'].isin(not_found_uuid)]
#             filtered_df['cosId'] = ocsId
#             print("Filtered dataframe : ",filtered_df)
#             logger_info.info("Filtered Dataframe : {}".format(filtered_df))
#             df_ocs = pd.DataFrame(data=data,columns=columns, dtype=str)
#             df_ocs['cosId'] = filtered_df['cosId']
#             df_ocs['rangeFrom'] = ""
#             df_ocs['rangeTo'] = ""
#             df_ocs['isRange'] = "N"
#             df_ocs['type'] = "I"
#             df_ocs['number'] = filtered_df['IMSI']
#             df_ocs['status'] = "1"
#             df_ocs['user'] = "migration"
#             df_ocs.to_csv(f"{ocs_output_file_path}/ocs_asset.csv",index=False)

#         else:
#             print("cosIds : {},Not found for ENT_ACCOUNTID {}".format(ocsId, filtered_df['ENT_ACCOUNTID']))
#             logger_info.info("cosIds : {},Not Found for ENT_ACCOUNTID {}".format(ocsId,filtered_df['ENT_ACCOUNTID']))

#     except Exception as e:
#         print("Error {}, while processing file {}".format(e,ocs_file_path))
#         logger_error.error("Error {}, while processing file {}".format(e,ocs_file_path))

#     logger_info.info("--------------OCS Data Processing End-------------------")
#     print("--------------OCS Data Processing End------------------------------")


def ocs_mapping():
    """
    1) This Method First truncate the table.
    2) Insert the data in the table names given in file_table_mapper if any failure
    while insertion an error file will be generated in 'Insertion_Error' directory.
    3) A procedure will be called which will return the result.
    4) Error occurred during procedure execution will be maintained in a table 'error_history_table'
    a query will be fired which will pull those error records from the table and create an error file inside 'Procedure_Error_Router'.
    :return: None
    """

    logger_info.info("--------------OCS Data Processing Started-------------------")
    print("--------------OCS Data Processing Started------------------------------")

    df = pd.read_csv(ocs_file_path,skipinitialspace=True, dtype=str,keep_default_na=False)
    try:
        filtered_df = df[~df['STATE'].isin(['Warm', 'TestReady'])]
        print('File Length : ',len(filtered_df))
        columns = ['cosId', 'isRange', 'type', 'rangeFrom', 'rangeTo', 'number', 'status', 'user']

        data = []
        ent_id = filtered_df['ENT_ACCOUNTID'].tolist()
        # print(ent_id)
        querry = "SELECT COS_ID FROM accounts WHERE NOTIFICATION_UUID="
        # ocsId,not_found_uuid = sql_query_fetch_single_conn(querry,ent_id, aircontrol_db_configs, logger_error)
        uuid_to_account_id = ac_fetch_account_id(ent_id)
        if uuid_to_account_id is not None:
            filtered_df['cosId'] = filtered_df['ENT_ACCOUNTID'].map(uuid_to_account_id)
            # filtered_df = filtered_df[~filtered_df['ENT_ACCOUNTID'].isin(not_found_uuid)]
            # filtered_df['cosId'] = ocsId
            print("Filtered dataframe : ",filtered_df)
            logger_info.info("Filtered Dataframe : {}".format(filtered_df))
            df_ocs = pd.DataFrame(data=data,columns=columns, dtype=str)
            df_ocs['cosId'] = filtered_df['cosId']
            df_ocs['rangeFrom'] = ""
            df_ocs['rangeTo'] = ""
            df_ocs['isRange'] = "N"
            df_ocs['type'] = "I"
            df_ocs['number'] = filtered_df['IMSI']
            df_ocs['status'] = "1"
            df_ocs['user'] = "migration"

            df_empty_cosId = df_ocs[df_ocs['cosId'].isna()]
            # Add error message column
            df_empty_cosId['error_message'] = "cosId not found in table"
            df_empty_cosId.to_csv(f'{logs_path}/cosId_not_found.csv',index=False)
            # Drop rows with empty ocsId from the original DataFrame
            df_ocs = df_ocs.dropna(subset=['cosId'])

            df_ocs.to_csv(f"{ocs_output_file_path}/ocs_asset.csv",index=False)

        else:
            print("cosIds : {},Not found for ENT_ACCOUNTID {}".format(ocsId, filtered_df['ENT_ACCOUNTID']))
            logger_info.info("cosIds : {},Not Found for ENT_ACCOUNTID {}".format(ocsId,filtered_df['ENT_ACCOUNTID']))

    except Exception as e:
        print("Error {}, while processing file {}".format(e,ocs_file_path))
        logger_error.error("Error {}, while processing file {}".format(e,ocs_file_path))

    logger_info.info("--------------OCS Data Processing End-------------------")
    print("--------------OCS Data Processing End------------------------------")

if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "ocs":
            ocs_mapping()
