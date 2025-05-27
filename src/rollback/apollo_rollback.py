import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.apollo.config import *
today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

insertion_error_dir = os.path.join(dir_path,'insertion_error')
procedure_error_dir = os.path.join(dir_path,'procedure_error_aircontrol')

input_date_formate="%d-%b-%y %I.%M.%S.%f %p"
logs = {
    "migration_info_logger":f"stc_rollback_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_rollback_error_{current_time_stamp}.log"
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
    print('crn',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT NOTIFICATION_UUID,ID FROM accounts WHERE NOTIFICATION_UUID IN({format_strings});"""
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
    print('crn',reference_number)
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

def aircontrol_rollback(filepath,cost_center_account_id,cost_center_df):
    df_account = pd.read_csv(filepath,dtype=str,keep_default_na=False)
    print("Account File Length : {}".format(len(df_account)))
    try:
        uuids = df_account['customerReferenceNumber'].unique().tolist()
        # print('AMIT',uuids)
        uuid_to_account_id = ac_fetch_account_id(uuids)

        uuid_bu = df_account['billingAccountNumber'].unique().tolist()
        uuid_bu_to_account_id = ac_fetch_account_id(uuid_bu)
        
        if cost_center_account_id is not None:
            cost_center_df['cost_center_id'] = cost_center_df['buAccountId'].map(cost_center_account_id).fillna('')
            for idx,row in cost_center_df.iterrows():
                if len(row['cost_center_id'])!=0:
                    call_procedure_with_parameter('gcontrol_accounts_deletion_v1',aircontrol_db_configs,logger_error,logger_info,row['cost_center_id'])

        if uuid_to_account_id is not None:
            df_account['ec_account_id'] = df_account['customerReferenceNumber'].map(uuid_to_account_id).fillna('')
            df_account['bu_account_id'] = df_account['billingAccountNumber'].map(uuid_bu_to_account_id).fillna('')
            for idx,row in df_account.iterrows():
                if len(row['bu_account_id'])!=0:
                    call_procedure_with_parameter('gcontrol_accounts_deletion_v1',aircontrol_db_configs,logger_error,logger_info,row['bu_account_id'])
                if len(row['ec_account_id'])!=0:
                    call_procedure_with_parameter('gcontrol_accounts_deletion_v1',aircontrol_db_configs,logger_error,logger_info,row['ec_account_id'])
                
        else:
            print("Not a single accountId found in accounts table")
            logger_error.error("Not a single accountId found in accounts table")
    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))







def billing_rollback(filepath,cost_center_account_id,cost_center_df):
    df_account = pd.read_csv(filepath,dtype=str,keep_default_na=False)
    print("Account File Length : {}".format(len(df_account)))
    try:
        uuids = df_account['customerReferenceNumber'].unique().tolist()
        uuid_to_account_id = ac_fetch_account_id(uuids)

        uuid_bu = df_account['billingAccountNumber'].unique().tolist()
        uuid_bu_to_account_id = ac_fetch_account_id(uuid_bu)

        if cost_center_account_id is not None:
            cost_center_df['cost_center_id'] = cost_center_df['buAccountId'].map(cost_center_account_id).fillna('')
            for idx,row in cost_center_df.iterrows():
                if len(row['cost_center_id'])!=0:
                    call_procedure_with_parameter('SP_BillingBuCleanup',billing_db_configs,logger_error,logger_info,row['cost_center_id'],billing_db_configs['DATABASE'])
        if uuid_to_account_id is not None:
            df_account['ec_account_id'] = df_account['customerReferenceNumber'].map(uuid_to_account_id).fillna('')
            df_account['bu_account_id'] = df_account['billingAccountNumber'].map(uuid_bu_to_account_id).fillna('')
            for idx,row in df_account.iterrows():
                if len(row['bu_account_id'])!=0:
                    call_procedure_with_parameter('SP_BillingBuCleanup',billing_db_configs,logger_error,logger_info,row['bu_account_id'],billing_db_configs['DATABASE'])
                if len(row['ec_account_id'])!=0:
                    call_procedure_with_parameter('SP_BillingBuCleanup',billing_db_configs,logger_error,logger_info,row['ec_account_id'],billing_db_configs['DATABASE'])
                

        else:
            print("Not a single accountId found in accounts table")
            logger_error.error("Not a single accountId found in accounts table")

    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))

#billing_rollback(account_onboarding_csv_file_path)



def bss_rollback(filepath,cost_center_account_id,cost_center_df):
    df_account = pd.read_csv(filepath,dtype=str,keep_default_na=False)
    # df_account = pd.read_csv('/opt/migration/src/rollback/accounts.csv',dtype=str,keep_default_na=False)
    print("Account File Length : {}".format(len(df_account)))
    try:
         uuids = df_account['customerReferenceNumber'].unique().tolist()
    #     # print('AMIT',uuids)
         uuid_to_account_id = ac_fetch_account_id(uuids)
         uuid_bu = df_account['billingAccountNumber'].unique().tolist()
         uuid_bu_to_account_id = ac_fetch_account_id(uuid_bu)

         if cost_center_account_id is not None:
            cost_center_df['cost_center_id'] = cost_center_df['buAccountId'].map(cost_center_account_id).fillna('')
            for idx,row in cost_center_df.iterrows():
                if len(row['cost_center_id'])!=0:
                    call_procedure_with_parameter('stcdeleteentaccount',bss_db_configs,logger_error,logger_info,row['cost_center_id'])
         if uuid_to_account_id is not None:
             df_account['ec_account_id'] = df_account['customerReferenceNumber'].map(uuid_to_account_id).fillna('')
             df_account['bu_account_id'] = df_account['billingAccountNumber'].map(uuid_bu_to_account_id).fillna('')
             for idx,row in df_account.iterrows():
                if len(row['bu_account_id'])!=0:
                    call_procedure_with_parameter('stcdeleteentaccount',bss_db_configs,logger_error,logger_info,row['bu_account_id'])
                if len(row['ec_account_id'])!=0:
                    call_procedure_with_parameter('stcdeleteentaccount',bss_db_configs,logger_error,logger_info,row['ec_account_id'])
                

         else:
             print("Not a single accountId found in accounts table")
             logger_error.error("Not a single accountId found in accounts table")
    except Exception as e:
         print("Error {} while running aircontrol rollback script".format(e))
         logger_error.error("Error {} while running aircontrol rollback script".format(e))





def ocs_rollback(filepath,cost_center_df,uuid_cost_center):
    df_account = pd.read_csv(filepath,dtype=str,keep_default_na=False)
    # df_account = pd.read_csv('/opt/migration/src/rollback/accounts.csv',dtype=str,keep_default_na=False)
    print("Account File Length : {}".format(len(df_account)))
 

    try:
        uuids = df_account['customerReferenceNumber'].unique().tolist()
        uuid_to_account_id = ac_fetch_cos_id(uuids)

        uuid_bu = df_account['billingAccountNumber'].unique().tolist()
        uuid_bu_to_account_id = ac_fetch_cos_id(uuid_bu)
        cost_center_account_id = ac_fetch_cos_id(uuid_cost_center)
        if cost_center_account_id is not None:
            cost_center_df['cost_center_id'] = cost_center_df['buAccountId'].map(cost_center_account_id).fillna('')
            for idx,row in cost_center_df.iterrows():
                if len(row['cost_center_id'])!=0:
                    procedure_call_oracle(oracle_source_db,'remove_migrated_cos',logger_info,logger_error,row['cost_center_id'])

        if uuid_to_account_id is not None:
            
            df_account['cos_id'] = df_account['customerReferenceNumber'].map(uuid_to_account_id).fillna('')
            df_account['bu_cos_id'] = df_account['billingAccountNumber'].map(uuid_bu_to_account_id).fillna('')
            for idx,row in df_account.iterrows():
                if len(row['bu_cos_id'])!=0:
                    procedure_call_oracle(oracle_source_db,'remove_migrated_cos',logger_info,logger_error,row['bu_cos_id'])
                if len(row['cos_id'])!=0:
                    procedure_call_oracle(oracle_source_db,'remove_migrated_cos',logger_info,logger_error,row['cos_id'])
                
        
    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))





def router_rollback(filepath):
    df_asset = pd.read_csv(f'{filepath}Goup_router_bulk_upload_dummy.csv',dtype=str,keep_default_na=False)
    print("Router Asset File Length : {}".format(len(df_asset)))

 
    try:
        imsi_list = df_asset['IMSI'].astype(str).tolist()
        imsi_string = ','.join(f"'{imsi}'" for imsi in imsi_list)
        # print("IMSI STRING",imsi_string)
        call_procedure_with_parameter('router_assets_deletion',router_db_configs,logger_error,logger_info,imsi_string)
                
    except Exception as e:
        print("Error {} while running aircontrol rollback script".format(e))
        logger_error.error("Error {} while running aircontrol rollback script".format(e))


    

if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    
    
    cost_center_df = pd.read_csv(cost_center_file_path,dtype=str,keep_default_na=False)
    uuid_cost_center = cost_center_df['buAccountId'].unique().tolist()
    uuid_cost_to_account_id = ac_fetch_account_id(uuid_cost_center)

    for arg in sys.argv[1:]:
        if arg == "aircontrol":
            print("aircontrol")
            aircontrol_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)

        if arg == "billing":
            print("billing")
            billing_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)

        if arg == "bss":
            print("bss")
            bss_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)

        if arg == "ocs":
            print("ocs")
            ocs_rollback(account_onboarding_csv_file_path,cost_center_df,uuid_cost_center)

        if arg == "router":
            print("Router")
            router_rollback(router_file_path['file_path_router'])

        if arg== "all":
            print("ocs")
            ocs_rollback(account_onboarding_csv_file_path,cost_center_df,uuid_cost_center)
            print("bss")
            bss_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)
            print("billing")
            billing_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)
            print("########aircontrol#####################")
            aircontrol_rollback(account_onboarding_csv_file_path,uuid_cost_to_account_id,cost_center_df)
            print("Router")
            router_rollback(router_file_path['file_path_router'])


