import sys
sys.path.append("..")
from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *

dir_path = dirname(abspath(__file__))

# Assuming data_df_device_plan is your DataFrame

# Generate timestamp
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
# File name with timestamp

logs = {
    "migration_info_logger":f"A1_ingestion_billing_bss_info_{current_time_stamp}.log",
    "migration_error_logger":f"A1_ingestion_billing_bss_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

aircontrol_database = aircontrol_db_configs["DATABASE"]
aircontrol_host = aircontrol_db_configs["HOST"]
aircontrol_username = aircontrol_db_configs["USER"]
aircontrol_password = aircontrol_db_configs["PASSWORD"]
aircontrol_jdbcPort = aircontrol_db_configs["PORT"]
aircontrol_procedure_name = aircontrol_db_configs["procedure_name"]


bss_database = bss_db_configs['DATABASE']
bss_host = bss_db_configs['HOST']
bss_username = bss_db_configs['USER']
bss_password = bss_db_configs['PASSWORD']
bss_jdbcPort = bss_db_configs['PORT']
bss_procedure_name = bss_db_configs['procedure_name']

router_database = router_db_configs['DATABASE']
router_host = router_db_configs['HOST']
router_username = router_db_configs['USER']
router_password = router_db_configs['PASSWORD']
router_jdbcPort = router_db_configs['PORT']
router_procedure_name = router_db_configs['procedure_name']



def generate_procedure_error_file(query,db_config,column_names,procedure_error_directory,error_file_name,logger_error,logger_info):
    try:
        fetch_error_success = query
        fetch_error_success_data = sql_query_fetch(fetch_error_success,db_config,logger_error)
        print('error result : ',fetch_error_success_data)
        if len(fetch_error_success_data) != 0:
            # Specify the filename for the CSV file (replace 'output.csv' with your desired filename)
            df_error = pd.DataFrame(fetch_error_success_data, columns=column_names)
            df_error.to_csv(os.path.join(procedure_error_directory, error_file_name), index=False)
        else:
            print("No data retrieved from the database.")
    except Exception as e:
        logger_info.error("Error Fetching asset files :{}".format(e))
        logger_error.error("Error Fetching asset files :{}".format(e))
        exit(0)


def convert_timestamps_to_string(row_data):
    for key, value in row_data.items():
        if isinstance(value, pd.Timestamp):
            row_data[key] = value.strftime('%Y-%m-%d %H:%M:%S')
    return row_data



def billing_mapping_prerequisite():
    try:
        # Read the data from the 'migration_device_plan' table
        try:
            data_df_assets = read_table_as_df('migration_device_plan', billing_db_configs, logger_info, logger_error)
            data_df_assets.columns = data_df_assets.columns.str.lower()
            data_df_assets["event_date"] = billing_bss_assets_event_date
        except Exception as e:
            logger_error.error(f"Error reading table 'migration_device_plan': {e}")
            return None

        try:
            # Select relevant columns
            data_df_assets = data_df_assets[["imsi", "event_date", "activation_date", "iccid", "msisdn", "reason", "state"]]
            print("data_df_assets2", data_df_assets)
        except KeyError as e:
            logger_error.error(f"Error selecting columns: {e}")
            return None
        except Exception as e:
            logger_error.error(f"Unexpected error processing data_df_assets: {e}")
            return None

        try:
            # Fetch additional data from the assets table
            select_id_dvc_svc_query = "SELECT ID,IMSI, ENT_ACCOUNTID, DEVICE_PLAN_ID, SERVICE_PLAN_ID FROM assets"
            id_dvc_svc = sql_query_fetch(select_id_dvc_svc_query, aircontrol_db_configs, logger_error)
            id_dvc_svc = pd.DataFrame(id_dvc_svc, columns=["imsi_id", "imsi", "account_id", "device_id", "service_plan_id"])
        except Exception as e:
            logger_error.error(f"Error fetching or processing data from the 'assets' table: {e}")
            return None

        try:
            # Merge the fetched data with the original data
            data_df_assets = data_df_assets.merge(id_dvc_svc, on='imsi', how='left')
            data_df_assets = data_df_assets[["imsi_id", "imsi", "account_id", "event_date", "activation_date", "device_id", "service_plan_id", "iccid", "msisdn", "reason", "state"]]
            print("data_df_assets2", data_df_assets)
        except Exception as e:
            logger_error.error(f"Error merging data: {e}")
            return None

        try:
            # Fill NaN values and convert columns to integers where applicable
            data_df_assets.fillna("", inplace=True)
            data_df_assets["account_id"] = data_df_assets["account_id"].apply(lambda x: int(x) if x != '' else x)
            data_df_assets["device_id"] = data_df_assets["device_id"].apply(lambda x: int(x) if x != '' else x)
            data_df_assets["service_plan_id"] = data_df_assets["service_plan_id"].apply(lambda x: int(x) if x != '' else x)
        except ValueError as e:
            logger_error.error(f"Error converting columns to integers: {e}")
        except Exception as e:
            logger_error.error(f"Unexpected error during data transformation: {e}")

        # Return the final DataFrame
        return data_df_assets

    except Exception as e:
        logger_error.error(f"Unexpected error in billing_mapping_prerequisite function: {e}")
        return None



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
        if 'NAME' not in df.columns:
            df['NAME'] = np.nan
        if 'billing_account_id' not in df.columns:
            df['billing_account_id'] = np.nan

        # Update the DataFrame in chunks
        start = 0
        for i, (ent_account_id, device_plan_id) in enumerate(update_dict.items()):
            end = start + chunk_size
            if i < remaining:  # Distribute the remaining rows
                end += 1
            df.loc[start:end, 'billing_account_id'] = ent_account_id
            df.loc[start:end, 'NAME'] = device_plan_id
            start = end + 1

        return df

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")
        return df



def billing_mapping():
    
    data_df_assets=billing_mapping_prerequisite()                       
    # data_df_assets.to_csv("helmnbjubu.csv",index=False)

    num_rows_before = len(data_df_assets)

    # Drop rows where 'activation_date' is missing
    data_df_assets = data_df_assets[data_df_assets['activation_date'] != '']

    # Count the number of rows after dropping NaN values
    num_rows_after = len(data_df_assets)

    # Calculate the number of dropped rows
    num_dropped_rows = num_rows_before - num_rows_after

    # Print the resulting DataFrame
    print("num_dropped_rows",num_dropped_rows)
        
    data_df_device_plan=read_table_as_df('migration_device_plan', migration_db_name, logger_info, logger_error)                #pd.read_csv(billing_file_path['file_migration_charges'], skipinitialspace=True, keep_default_na=False, dtype=str)
    

    data_df_assets = data_df_assets[~data_df_assets["device_id"].isin([""])]
    data_df_assets = data_df_assets[~data_df_assets["service_plan_id"].isin([""])]

    data_df_device_plan.columns = data_df_device_plan.columns.str.lower()

    for column in data_df_assets.columns:
        data_df_assets[column] = data_df_assets[column].apply(lambda x: str(x).strip())

    for column in data_df_device_plan.columns:
        data_df_device_plan[column] = data_df_device_plan[column].apply(lambda x: str(x).strip())


    for index, row in  data_df_device_plan.iterrows():
        try:
            select_dvc_tmp_ID_query=f"""SELECT id as device_plan_id ,REPLACE(JSON_EXTRACT(extra_metadata, '$.templateId'),'"','') as templateId, \
            PLAN_TYPE as type from device_rate_plan where plan_name='{row['name']}' \
            and account_id in (SELECT ID from accounts WHERE legacy_Ban='{row['billing_account_id']}') and device_rate_plan.DELETED=0;"""

            id_dvc_tmp = sql_query_fetch(select_dvc_tmp_ID_query, aircontrol_db_configs, logger_error)

            row["device_plan_id"] = id_dvc_tmp[0][0]

            print( id_dvc_tmp[0][0])
            row["template_id"] = id_dvc_tmp[0][1]
            print(id_dvc_tmp[0][1])
            row["type"] = id_dvc_tmp[0][2]
            print(row["type"])

        except Exception as e:
            logger_info.error(e)



    data_df_device_plan = data_df_device_plan[~data_df_device_plan["device_plan_id"].isin([""])]

    print(data_df_device_plan)

    tarrifs_ids_querry=f"""select a.PLAN_ID, a.CHARGE_SPEC_ID, a.CHARGE_CATEGORY, a.gl_code_id, a.action_type, \
     a.is_proration, b.disc_id, b.disc_gl_code_id, p.apn_type from (select pc .PLAN_ID as PLAN_ID , \
     pc .CHARGE_SPEC_ID as CHARGE_SPEC_ID ,cs .CHARGE_CATEGORY as CHARGE_CATEGORY,cs.GL_CODE_ID  as gl_code_id , \
     cs .ACTION_TYPE as action_type ,cs .IS_PRORATION as is_proration  \
     from plan_chargespecs pc inner join charging_spec cs on pc .CHARGE_SPEC_ID = cs .CHARGE_SPEC_ID \
     where cs .LIFE_CYCLE_STATUS = 'LIVE'  and pc.plan_id in \
     ( select plan_id from plan where LIFE_CYCLE_STATUS = 'LIVE') and is_enabled is true \
      and pc.LIFE_CYCLE_STATUS='LIVE') a left join \
    (select dc.CHARGING_SPEC_ID as CHARGE_SPEC_ID, dc .discount_id as disc_id, d .gl_code_id as disc_gl_code_id \
     from discount_chargespec dc left join discount d on dc.discount_id =d.discount_id where dc.is_enabled is true and \
     dc.LIFE_CYCLE_STATUS = 'LIVE' and d.LIFE_CYCLE_STATUS = 'LIVE' and  d.GL_CODE_ID is not null) b \
     on a.charge_spec_id =b.charge_spec_id left join plan p on p.plan_id=a.plan_id and p.LIFE_CYCLE_STATUS='LIVE';"""
    id_dvc_tmp = sql_query_fetch(tarrifs_ids_querry, product_catalogue, logger_error)

    data_df_tarrifs_ids = pd.DataFrame(id_dvc_tmp, columns=["plan_id","charge_spec_id","charge_category","gl_code_id","action_type","is_proration", "discount_id", "discount_glcode_id", "APN_TYPE"])
    #plan_id

    data_df_tarrifs_ids['is_proration'].fillna(0, inplace=True)

    data_df_tarrifs_ids["is_proration"] = data_df_tarrifs_ids["is_proration"].apply(lambda x: int(x) if x != '' else x)

    data_df_tarrifs_ids.replace({np.nan: ""}, inplace=True)
    
    data_df_tarrifs_ids["discount_id"] = data_df_tarrifs_ids["discount_id"].apply(lambda x: int(x) if x != '' else  None)
    data_df_tarrifs_ids["discount_glcode_id"] = data_df_tarrifs_ids["discount_glcode_id"].apply(lambda x: int(x) if x != '' else None)
    data_df_tarrifs_ids.replace({np.nan: None}, inplace=True)
    print(data_df_tarrifs_ids)

    print(data_df_tarrifs_ids.columns)
    print(data_df_assets.columns)
    print(data_df_device_plan)

    print(data_df_device_plan)
    print(data_df_device_plan.columns)

    data_df_device_plan["device_plan_id"] = data_df_device_plan["device_plan_id"].apply(lambda x: int(x) if x != '' else x)
    data_df_device_plan["billing_account_id"] = data_df_device_plan["billing_account_id"].apply(lambda x: int(x) if x != '' else x)
    # data_df_device_plan["template_id"] = data_df_device_plan["template_id"].apply(lambda x: int(x) if x != '' else x)
    data_df_device_plan["template_id"] = data_df_device_plan["template_id"].apply(lambda x: int(float(x)) if x != '' else x)
    data_df_device_plan["pool_limit"] = data_df_device_plan["pool_limit"].apply(lambda x: int(x) if x != '' else x)
    data_df_device_plan["pool_limit"] = data_df_device_plan["pool_limit"].apply(lambda x: 0 if x == '' else x)

    truncate_mysql_table(billing_db_configs, "migration_assets",  logger_error)
    truncate_mysql_table(billing_db_configs, "migration_device_plan", logger_error)
    truncate_mysql_table(billing_db_configs, "migration_billing_charges", logger_error)

    print("test", len(data_df_assets))
    data_df_assets_error, data_df_assets = insert_batches_df_into_mysql(data_df_assets, billing_db_configs, "migration_assets",   logger_info, logger_error)

    data_df_device_plan_error, data_df_device_plan = insert_batches_df_into_mysql(data_df_device_plan, billing_db_configs, "migration_device_plan" , logger_info, logger_error)

    print("test", data_df_tarrifs_ids)
    data_df_tarrifs_ids_error, data_df_tarrifs_ids = insert_batches_df_into_mysql(data_df_tarrifs_ids, billing_db_configs,"migration_billing_charges",  logger_info, logger_error)

    data_df_assets.to_csv(os.path.join(dir_path,"billing_success_failure", f"data_df_assets_{timestamp}.csv"), index = False)
    data_df_assets_error.to_csv(os.path.join(dir_path,"billing_success_failure",  f"data_df_assets_error_{timestamp}.csv"), index = False)
    data_df_device_plan.to_csv(os.path.join(dir_path,"billing_success_failure", f"data_df_device_plan_{timestamp}.csv"), index = False)
    data_df_device_plan_error.to_csv(os.path.join(dir_path,"billing_success_failure",  f"data_df_device_plan_error_{timestamp}.csv"), index = False)
    data_df_tarrifs_ids.to_csv(os.path.join(dir_path,"billing_success_failure", f"data_df_tarrifs_ids_{timestamp}.csv"), index = False)
    data_df_tarrifs_ids_error.to_csv(os.path.join(dir_path,"billing_success_failure", f"data_df_tarrifs_ids_error_{timestamp}.csv"), index = False)


    sim_count_query = "select count(*) from sim_activation;"

    before_procedure_call = sql_query_fetch(sim_count_query ,billing_db_configs, logger_error)

    logger_info.info("Billing Sim count before procedure call {}".format(before_procedure_call))

    print(billing_db_configs)

    print("billing_db_configs : -", billing_db_configs['procedure_name'])
    call_procedure(billing_db_configs['procedure_name'], billing_db_configs, logger_error, logger_info)


    after_procedure_call = sql_query_fetch(sim_count_query, billing_db_configs, logger_error)


    logger_info.info("Billing Sim count after procedure call {}".format(after_procedure_call))


    #select_querry_failure = f"""select a.imsi,a.account_id,a.event_date,a.activation_date,a.device_id,a.service_plan_id,a.iccid, a.msisdn, a.reason, a.state, b.status, b.remarks from migration_assets a join migration_assets_validation b on a.id=b.assets_id and b.status ='FAILED';"""
    select_querry_failure = f"""select a.id, a.imsi,a.account_id,a.event_date,a.activation_date,a.device_id,a.service_plan_id,a.iccid,a.msisdn,a.reason,a.state,b.status,b.remarks from migration_assets a join migration_assets_validation b on a.id= b.assets_id AND b.status = 'FAILED' union select a.id, a.imsi,a.account_id,a.event_date,a.activation_date,a.device_id,a.service_plan_id,a.iccid,a.msisdn,a.reason,a.state,'NOT PROCESSED' as status,'NULL' as remarks FROM migration_assets a where a.id not in (select assets_id from migration_assets_validation );"""
    billing_failure = sql_query_fetch(select_querry_failure, billing_db_configs, logger_error)
    print(len(billing_failure))

    billing_failure_df = pd.DataFrame(billing_failure, columns=["ID","imsi", "account_id", "event_date", "activation_date", "device_id", "service_Plan_Id", "iccid", "msisdn", "reason", "State", "status", "remarks"])

    print(billing_failure_df)
    billing_failure_df.to_csv(os.path.join(dir_path, "billing_success_failure", f"Billing_Failure_{timestamp}.csv"), index=False)





def bss_mapping():
    
    data_df_assets = billing_mapping_prerequisite()

    for column in data_df_assets.columns:
        data_df_assets[column] = data_df_assets[column].apply(lambda x: str(x).strip())


    # data_df_assets = data_df_assets[~data_df_assets["device_id"].isin([""])]
    # data_df_assets = data_df_assets[~data_df_assets["service_plan_id"].isin([""])]
    data_df_assets.replace({np.nan: ""}, inplace=True)

    data_df_assets.rename(columns = {'device_id' : 'device_plan_id'}, inplace = True)
    print("account_id", data_df_assets["account_id"])
    print("account_id,latest", type(data_df_assets["account_id"]))
    data_df_assets["status"] = 0
    data_df_assets["account_id"] = data_df_assets["account_id"].apply(lambda x: int(x) if x != '' else x)
    data_df_assets["account_id"] = data_df_assets["account_id"].apply(lambda x: str(int(float(x))) if isinstance(x, str) and x.endswith('.0') else x)

    print("account_id,latest", type(data_df_assets["account_id"]))
    print("account_id",data_df_assets["account_id"])
    # data_df_assets["account_id"] = data_df_assets["account_id"].apply(lambda x: pd.to_numeric(x, errors='coerce', downcast='integer') if x != '' else x)
    data_df_assets["device_plan_id"] = data_df_assets["device_plan_id"].apply(lambda x: int(x) if x != '' else x)
    data_df_assets["service_plan_id"] = data_df_assets["service_plan_id"].apply(lambda x: int(x) if x != '' else x)
    data_df_assets=data_df_assets.drop(columns=["imsi_id"])
    # data_df_assets.replace({np.nan: None}, inplace=True)
    data_df_assets.replace({"": None}, inplace=True)
    print("data_df_assets1", data_df_assets)
    data_df_assets.replace({np.nan: None}, inplace=True)
    print("data_df_assets2", data_df_assets)

    
    
    #data_df_assets = data_df_assets.applymap(lambda x: None if pd.isna(x) or x == '' else x)

    truncate_mysql_table( bss_db_configs, "migration_asset", logger_error)
    data_bss_df_assets_error, data_bss_df_assets = insert_batches_df_into_mysql(data_df_assets, bss_db_configs, "migration_asset", logger_info, logger_error)

    data_bss_df_assets_error.to_csv(os.path.join(dir_path, "bss_success_failure",f"data_bss_df_assets_error_{timestamp}.csv"))
    data_bss_df_assets.to_csv(os.path.join(dir_path, "bss_success_failure", f"data_bss_df_assets_{timestamp}.csv"))

    # print(data_bss_df_assets)
    # print(data_bss_df_assets_error)


    sim_count_query = f"select count(*)from tuser_sim_card;"

    before_procedure_call = sql_query_fetch(sim_count_query, bss_db_configs, logger_error)

    logger_info.info("BSS Sim count before procedure call {}".format(before_procedure_call))

    print(bss_db_configs['procedure_name'])
    call_procedure_with_parameter(bss_db_configs['procedure_name'], bss_db_configs, logger_error, logger_info,bss_proration_enabled,bss_client_type)

    after_procedure_call = sql_query_fetch(sim_count_query, bss_db_configs, logger_error)

    logger_info.info("BSS Sim count after procedure call {}".format(after_procedure_call))

    select_querry_failure = f"""select imsi, account_id, event_date, activation_date, device_plan_id, service_plan_id, iccid,  msisdn, reason, State, status from migration_asset where status = 0;"""

    bss_failure = sql_query_fetch(select_querry_failure, bss_db_configs, logger_error)

    print("bssfaliure",bss_failure)

    bss_failure_df = pd.DataFrame(bss_failure,columns=["imsi", "account_id", "event_date", "activation_date", "device_id", \
                                                       "service_Plan_Id", "iccid", "msisdn", "reason", "State",  "status",])

    print(bss_failure_df)
    bss_failure_df.to_csv(os.path.join(dir_path, "bss_success_failure", f"bss_failure_df_{timestamp}.csv"))





if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "billing":
            print("billing")
            billing_mapping()
        
        if arg == "bss":
            print("bss")
            bss_mapping()