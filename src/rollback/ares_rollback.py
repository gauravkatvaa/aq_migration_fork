import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *


today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

insertion_error_dir = os.path.join(dir_path,'insertion_error')
procedure_error_dir = os.path.join(dir_path,'procedure_error_aircontrol')

input_date_formate="%d-%b-%y %I.%M.%S.%f %p"
logs = {
    "migration_info_logger":f"ares_rollback_info_{current_time_stamp}.log",
    "migration_error_logger":f"ares_rollback_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{rollback_log_dir}'

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
    print('customer_reference_numbers: ',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT LEGACY_BAN,ID FROM accounts WHERE LEGACY_BAN IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,reference_number,aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None

def ac_fetch_account_id_cost_center(cost_center_name):
    """
    :param cost_center_name: List of cost center names (LEGACY_BAN values)
    :return: List of account IDs
    """
    print('customer_reference_numbers: :', cost_center_name)

    if not cost_center_name:
        return []

    # Convert the list to a properly formatted SQL string
    cost_center_str = ', '.join(f"'{val}'" for val in cost_center_name)
    
    query = f"""SELECT id FROM accounts 
                WHERE PARENT_ACCOUNT_ID IN (
                    SELECT id FROM accounts 
                    WHERE LEGACY_BAN IN ({cost_center_str}) 
                ) 
                AND type = 6;"""

    print("Executing query:", query)


    
    # Fetch result
    account_id_list = sql_query_fetch(query, aircontrol_db_configs, logger_error)
    # Extract unique IDs as strings and remove duplicates
    flattened_ids = list(set(str(row[0]) for row in account_id_list))
    return flattened_ids if flattened_ids else []


       


def extract_custom_list(dataframe):
    """
    Extracts a list of tuples from the given DataFrame.
    Each tuple contains: (cos_id, apn_name, the first 3 characters of mccmnc as an integer).

    Parameters:
    dataframe (pd.DataFrame): DataFrame with the columns 'cos_id', 'apn_name', and 'mccmnc'.

    Returns:
    list: A list of tuples with the specified columns or an empty list if an error occurs.
    """
    try:
        # Extract the relevant columns into a list of tuples
        result_list = dataframe.apply(
            lambda row: (
                row['cos_id'],
                row['apn_name'],
                int(row['mccmnc'][:3])  # Extract the first 3 characters and convert to int
            ), axis=1
        ).tolist()
        return result_list
    except KeyError as e:
        error_msg = f"KeyError - missing column: {e}"
        print(error_msg)
        logger_error.error(error_msg)
        return []
    except ValueError as ve:
        value_error_msg = f"ValueError - issue with data conversion: {ve}"
        print(value_error_msg)
        logger_error.error(value_error_msg)
        return []
    except Exception as ex:
        general_error_msg = f"An unexpected error occurred while extracting the list: {ex}"
        print(general_error_msg)
        logger_error.error(general_error_msg)
        return []




# def get_data_remove_ocs_procedure_call(account_id):
#     try:
#         # Define the query to fetch data from the database
#         query = f"""SELECT a.id as account_id, a.name as account_name, a.COS_ID as cos_id, 
#                 np.NAME as network_name, MCCMNC as mccmnc, d.id as device_plan_id, 
#                 d.plan_name as device_plan_name, apn.id as apn_id, apn.APN_NAME as apn_name 
#                 FROM Accounts as a 
#                 INNER JOIN device_rate_plan as d ON a.id = d.account_id 
#                 INNER JOIN device_plan_to_service_apn_mapping as dpapn ON d.id = dpapn.DEVICE_PLAN_ID_ID 
#                 INNER JOIN service_apn_details as apn ON apn.id = dpapn.apn_id 
#                 INNER JOIN network_providers as np ON a.COUNTRIES_ID = np.COUNTRY_ID 
#                 WHERE a.id = {account_id};"""

#         # Fetch data using the SQL query
#         # data = sql_query_fetch(query, aircontrol_db_configs, logger_error)
#         data=fetch_param_as_df(query,aircontrol_db_configs,logger_info,logger_error)
#         # print(query)
#         # print(data)
#         if data.empty:
#             print("DataFrame is empty. No data found for the given account ID.")
#             logger_info.info("DataFrame is empty. No data found for the given account ID.")
#             return  

#         # Extract the result list using the custom function
#         result_list = extract_custom_list(data)
#         # print("result_list",result_list)

#         # Check if the result list is not None and call the procedure for each entry
#         # Check if the result list is not empty
#         if result_list:
#             print("Starting procedure calls for each entry in result_list.")
#             for list_data in result_list:
#                 # print("list_for_calling ",list_data)
#                 procedure_call_oracle_with_list(oracle_source_db, 'remove_migrated_apn', logger_info, logger_error, list_data)
#         else:
#             print("result_list is empty. No procedure calls will be made.")
#             logger_info.info("result_list is empty. No procedure calls will be made.")

#     except Exception as e:
#         error_msg = f"An error occurred in get_data_remove_ocs_procedure_call function: {e}"
#         print(error_msg)
#         logger_error.error(error_msg)

def ac_fetch_cos_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('customer_reference_numbers: ',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT LEGACY_BAN,COS_ID FROM accounts WHERE LEGACY_BAN IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,reference_number,aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None



def ac_fetch_cos_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('customer_reference_numbers: ',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT LEGACY_BAN,COS_ID FROM accounts WHERE LEGACY_BAN IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,reference_number,aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None
    
def ac_fetch_cost_cos_id(name):
    """
    :param name: List of account IDs
    :return: List of unique COS_IDs
    """
    print('customer_reference_numbers: :', name)
    
    if not name:
        return []

    # Convert the list to a properly formatted SQL string
    cost_center_str = ', '.join(f"'{val}'" for val in name)

    query = f"""SELECT DISTINCT COS_ID FROM accounts WHERE id IN ({cost_center_str}) AND type = 6;"""
    
    print("Executing query:", query)

    # Fetch result
    account_id_list = sql_query_fetch(query, aircontrol_db_configs, logger_error)

    # Extract unique IDs as strings and remove duplicates
    flattened_ids = list(set(str(row[0]) for row in account_id_list if row[0] is not None))

    return flattened_ids


def aircontrol_rollback(rollback_ac_account_ids, cost_center_account_id):
    try:
        account_ids = rollback_ac_account_ids

        # Determine final all_account_ids based on conditions
        if cost_center_account_id and account_ids:
            all_account_ids = cost_center_account_id + account_ids
        elif cost_center_account_id and not account_ids:
            all_account_ids = cost_center_account_id
        elif not cost_center_account_id and account_ids:
            all_account_ids = account_ids
        else:
            all_account_ids = []


        print("all_account_ids:", all_account_ids)

        # If there are any account IDs, join them as a comma-separated string and call the procedure
        if all_account_ids:
            account_ids_str = ','.join(list(all_account_ids))
            print(f'Aircontrol IDs will rollback: {account_ids_str}')
            call_procedure_with_parameter('gcontrol_accounts_deletion_v1_remove_account', aircontrol_db_configs, logger_error, logger_info, account_ids_str)
        else:
            print("Not a single accountId found in accounts table")
            logger_error.error("Not a single accountId found in accounts table")

    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))


def billing_rollback(rollback_ac_account_ids, cost_center_account_id):
    try:
        if cost_center_account_id is not None:
            for cost_center_id in cost_center_account_id:
                if cost_center_id:
                    print('cost_center_id: ', cost_center_id)
                    call_procedure_with_parameter('SP_BillingBuCleanup', billing_db_configs, logger_error, logger_info, cost_center_id, billing_db_configs['DATABASE'])
        
        if rollback_ac_account_ids is not None:
            for rollback_ac_account_id in rollback_ac_account_ids:
                if rollback_ac_account_id:
                    print('rollback_ac_account_id: ', rollback_ac_account_id)
                    call_procedure_with_parameter('SP_BillingBuCleanup', billing_db_configs, logger_error, logger_info, rollback_ac_account_id, billing_db_configs['DATABASE'])
        else:
            print("Not a single accountId found in accounts table")
            logger_error.error("Not a single accountId found in accounts table")

    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))


def bss_rollback(rollback_ac_account_ids, cost_center_account_id):
    try:
        if cost_center_account_id is not None:
            for cost_center_id in cost_center_account_id:
                if cost_center_id:
                    call_procedure_with_parameter('removeAccountDetails', bss_db_configs, logger_error, logger_info, cost_center_id)

        if rollback_ac_account_ids is not None:
            for rollback_ac_account_id in rollback_ac_account_ids:
                if rollback_ac_account_id:
                    call_procedure_with_parameter('removeAccountDetails', bss_db_configs, logger_error, logger_info, rollback_ac_account_id)
        else:
            print("Not a single accountId found in accounts table")
            logger_error.error("Not a single accountId found in accounts table")
    except Exception as e:
        print("Error {} while running bss rollback script".format(e))
        logger_error.error("Error {} while running bss rollback script".format(e))


def ocs_rollback(filepath, cost_center_df, uuid_cost_center):
    df_account = pd.read_csv(filepath, dtype=str, keep_default_na=False)
    print("Account File Length : {}".format(len(df_account)))

    try:
        uuids = df_account['customerReferenceNumber'].unique().tolist()
        uuid_to_account_id =ac_fetch_cos_id(uuids)

        uuid_bu = df_account['billingAccountNumber'].unique().tolist()
        uuid_bu_to_account_id = ac_fetch_cos_id(uuid_bu)

        # Process cost center data if available
        if uuid_cost_center and cost_center_df is not None:
            cost_center_account_id = ac_fetch_cost_cos_id(uuid_cost_center)
            if cost_center_account_id:
                for cost_center_id in cost_center_account_id:
                    if cost_center_id:
                        print(cost_center_id)
                        procedure_call_oracle(oracle_source_db, 'remove_migrated_cos', logger_info, logger_error, cost_center_id)

        # Process customerReferenceNumber
        if uuid_to_account_id:
            df_account['cos_id'] = df_account['customerReferenceNumber'].map(lambda x: uuid_to_account_id.get(x, '')).fillna('')

        # Process billingAccountNumber
        if uuid_bu_to_account_id:
            df_account['bu_cos_id'] = df_account['billingAccountNumber'].map(lambda x: uuid_bu_to_account_id.get(x, '')).fillna('')

        # Call stored procedure for each valid cos_id and bu_cos_id
        for _, row in df_account.iterrows():
            if row['bu_cos_id']:
                procedure_call_oracle(oracle_source_db, 'remove_migrated_cos', logger_info, logger_error, row['bu_cos_id'])
            if row['cos_id']:
                procedure_call_oracle(oracle_source_db, 'remove_migrated_cos', logger_info, logger_error, row['cos_id'])

    except Exception as e:
        error_msg = f"Error {e} while running OCS rollback script"
        print(error_msg)
        logger_error.error(error_msg)


def router_rollback(filepath):
    df_asset = pd.read_csv(f'{filepath}Goup_router_bulk_upload_dummy.csv',dtype=str,keep_default_na=False)
    print("Router Asset File Length : {}".format(len(df_asset)))

 
    try:
        imsi_list = df_asset['IMSI'].astype(str).tolist()
        imsi_string = ','.join(f"'{imsi}'" for imsi in imsi_list)
        call_procedure_with_parameter('router_assets_deletion',router_db_configs,logger_error,logger_info,imsi_string)
                
    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))


def bss_imsi_rollback(filepath):
    df_asset = pd.read_csv(f'{filepath}/billing_files/migration_assets.csv',dtype=str,keep_default_na=False)
    print("Router Asset File Length : {}".format(len(df_asset)))

 
    try:
        # imsi_list = df_asset['IMSI'].astype(str).tolist()
        # imsi_string = ','.join(f"'{imsi}'" for imsi in imsi_list)
        # call_procedure_with_parameter('removeSimCardDetais',bss_db_configs,logger_error,logger_info,imsi_string)

        imsi_list = df_asset['IMSI'].astype(str).tolist()
        call_procedure('removeSimCardDetais', bss_db_configs, logger_error, logger_info)
        # for imsi_string in imsi_list:
        #     call_procedure_with_parameter('removeSimCardDetais', bss_db_configs, logger_error, logger_info, imsi_string)   
    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))



# def ocs_rollback_apn(filepath,cost_center_df,uuid_cost_center):
#     df_account = pd.read_csv(filepath,dtype=str,keep_default_na=False)
#     # df_account = pd.read_csv('/opt/migration/src/rollback/accounts.csv',dtype=str,keep_default_na=False)
#     print("Account File Length : {}".format(len(df_account)))
 

#     try:
#         uuids = df_account['customerReferenceNumber'].unique().tolist()
#         uuid_to_account_id = ac_fetch_account_id(uuids)

#         uuid_bu = df_account['billingAccountNumber'].unique().tolist()
#         uuid_bu_to_account_id = ac_fetch_account_id(uuid_bu)
        
#         # Process cost center data if available
#         if uuid_cost_center and cost_center_df is not None:
#             cost_center_account_id = ac_fetch_cost_cos_id(uuid_cost_center)
#             if cost_center_account_id:
#                 for cost_center_id in cost_center_account_id:
#                     if cost_center_id:
#                         print(cost_center_id)
#                         get_data_remove_ocs_procedure_call(cost_center_id)

#         if uuid_to_account_id is not None:
            
#             df_account['cos_id'] = df_account['customerReferenceNumber'].map(uuid_to_account_id).fillna('')
#             if uuid_bu_to_account_id is not None:
#                 df_account['bu_cos_id'] = df_account['billingAccountNumber'].map(uuid_bu_to_account_id).fillna('')
#             for idx,row in df_account.iterrows():
#                 if uuid_bu_to_account_id is not None:
#                     if len(row['bu_cos_id'])!=0:
#                         get_data_remove_ocs_procedure_call(row['bu_cos_id'])
                        
#                 if len(row['cos_id'])!=0:
#                     get_data_remove_ocs_procedure_call(row['cos_id'])
                    
                
        
#     except Exception as e:
#         print("Error {} while running ocs_rollback_rating_group".format(e))
#         logger_error.error("Error {} while running ocs_rollback_rating_group".format(e))



def create_db_dumps(databse_configs, logger_error):
    """
    Creates a SQL dump of all databases used in the script and saves it in the logs/rollback folder.
    """
    try:
        # Define the dump directory
        dump_dir = os.path.join(logs_path, f'db_dump_before_rollback_{current_time_stamp}')
        if not os.path.exists(dump_dir):
            os.makedirs(dump_dir)

            try:
                dump_file = os.path.join(dump_dir, f"{databse_configs['DATABASE']}_full_dump_{current_time_stamp}.sql")
                dump_command = (
                    f"mysqldump -u {databse_configs['USER']} -p{databse_configs['PASSWORD']} "
                    f"-h {databse_configs['HOST']} {databse_configs['DATABASE']} > {dump_file}"
                )
                os.system(dump_command)
                logger_info.info(f"Dumped full database {databse_configs['DATABASE']} to {dump_file}")
            except Exception as e:
                logger_error.error(f"Error dumping database {databse_configs['DATABASE']}: {e}")

    except Exception as e:
        logger_error.error(f"Error creating database dumps: {e}")


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    cost_center_df = None
    uuid_cost_to_account_id = None
    uuid_cost_center = None

    cost_center_df = read_table_as_df('cost_center_success', transformation_db_configs, logger_info, logger_error)
    uuid_cost_center = cost_center_df['buAccountId'].unique().tolist()
    uuid_cost_to_account_id = ac_fetch_account_id_cost_center(uuid_cost_center)
    print("uuid_cost_to_account_id: ", uuid_cost_to_account_id)

    onboarded_ec_df = read_table_as_df('ec_success', transformation_db_configs, logger_info, logger_error)
    onboarded_bu_df = read_table_as_df('bu_success', transformation_db_configs, logger_info, logger_error)

    onboarded_ec_file_path = f'{dir_path}//onboarded_ec.csv'
    onboarded_bu_file_path = f'{dir_path}//onboarded_bu.csv'

    onboarded_ec_df.to_csv(onboarded_ec_file_path, index=False)
    onboarded_bu_df.to_csv(onboarded_bu_file_path, index=False)

    onboarded_accounts = pd.concat([onboarded_ec_df, onboarded_bu_df], ignore_index=True)
    onboarded_accounts_file_path = f'{dir_path}//onboarded_accounts.csv'
    onboarded_accounts.to_csv(onboarded_accounts_file_path, index=False)

    print("Accounts EC that will be rollback: {}".format(len(onboarded_ec_df)))
    print("Accounts BU that will be rollback: {}".format(len(onboarded_bu_df)))

    legacy_ban_list = onboarded_accounts['legacyBan'].unique().tolist()
    print("Legacy BAN List:", legacy_ban_list)

    rollback_ac_id_map = ac_fetch_account_id(legacy_ban_list)
    rollback_ac_id = []
    
    if rollback_ac_id_map is None:
        print("No account IDs found for the given legacy BAN list.")
        logger_error.error("No account IDs found for the given legacy BAN list.")
        rollback_ac_id = []

    else: 
        for key, value in rollback_ac_id_map.items():
            if value is not None:
                rollback_ac_id.append(value)
    
    print("Rollback Account IDs:", rollback_ac_id)
    
    for arg in sys.argv[1:]:
        if arg == "aircontrol":
            print("aircontrol")
            aircontrol_rollback(rollback_ac_id, uuid_cost_to_account_id)

        if arg == "billing":
            print("billing")
            billing_rollback(rollback_ac_id, uuid_cost_to_account_id)

        if arg == "bss":
            print("bss")
            bss_rollback(rollback_ac_id, uuid_cost_to_account_id)

        if arg == "ocs":
            print("ocs")
            ocs_rollback(onboarded_accounts_file_path,cost_center_df,uuid_cost_to_account_id)

        # if arg == "router":
            # print("Router")
            # router_rollback(router_file_path['file_path_router'])

        # if arg == "ocsapn":
            # print("ocsapn")
            # ocs_rollback_apn(account_onboarding_csv_file_path,cost_center_df,uuid_cost_to_account_id) 

        if arg =="bss_imsi":
            print("bss_imsi_delete")
            bss_imsi_rollback(output_file_base_dir)       
        
        if arg == "dump_db":
            print("Dumping DB before rollback instances")
            create_db_dumps(bss_db_configs, logger_error)

        if arg == "custom":
            rollback_ac_id = ["40842", "40857", "40858", "40859", "40844", "40861", "40843", "40860"]
            print("Custom Rollback IDs:", rollback_ac_id)
            bss_rollback(rollback_ac_id, uuid_cost_to_account_id)
            billing_rollback(rollback_ac_id, uuid_cost_to_account_id)
            aircontrol_rollback(rollback_ac_id, uuid_cost_to_account_id)

        if arg== "all":
            # print("ocs")
            # ocs_rollback(account_onboarding_csv_file_path,cost_center_df,uuid_cost_to_account_id)
            print("bss")
            bss_rollback(rollback_ac_id, uuid_cost_to_account_id)
            print("billing")
            billing_rollback(rollback_ac_id, uuid_cost_to_account_id)
            print("aircontrol")
            aircontrol_rollback(rollback_ac_id, uuid_cost_to_account_id)