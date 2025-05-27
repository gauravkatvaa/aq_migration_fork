import os
from os.path import dirname, abspath, join
from os import listdir
from config import *
from logger import logger_
import numpy as np
from mySqlFunctions import *
import sys
dir_path = dirname(abspath(__file__))
import pandas as pd

logger_info = logger_(dir_path, logs["migration_info_logger"])
logger_error = logger_(dir_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

aircontrol_database = aircontrol_db_configs["DATABASE"]
aircontrol_host = aircontrol_db_configs["HOST"]
aircontrol_username = aircontrol_db_configs["USER"]
aircontrol_password = aircontrol_db_configs["PASSWORD"]
aircontrol_jdbcPort = aircontrol_db_configs["PORT"]
aircontrol_procedure_name = aircontrol_db_configs["procedure_name"]
# print(aircontrol_db_configs)

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




def billing_mapping():
    print(billing_file_path['file_migration_assets'])
    data_df_assets=pd.read_csv(billing_file_path['file_migration_assets'], skipinitialspace=True, keep_default_na=False, dtype=str)
    data_df_device_plan=pd.read_csv(billing_file_path['file_migration_charges'], skipinitialspace=True, keep_default_na=False, dtype=str)

    print(data_df_assets)
    print(data_df_device_plan)

    data_df_assets["event_date"] = "2024-02-28 00:00:00"

    for index, row in data_df_assets.iterrows():
        try:
            id_dvc_svc = None
            select_id_dvc_svc_query = f"SELECT ENT_ACCOUNTID, DEVICE_PLAN_ID, SERVICE_PLAN_ID FROM assets WHERE imsi = {row['imsi']}"
            id_dvc_svc = sql_query_fetch(select_id_dvc_svc_query, aircontrol_db_configs, logger_error)
            row["account_id"]=id_dvc_svc[0][0]
            row["device_id"]=id_dvc_svc[0][1]
            row["service_Plan_ID"]=id_dvc_svc[0][2]
        except Exception as e:
            logger_info.error(e)

    for index, row in  data_df_device_plan.iterrows():
        try:
            select_dvc_tmp_ID_query=f"""SELECT id as device_plan_id ,REPLACE(JSON_EXTRACT(extra_metadata, '$.templateId'),'"','') as templateId \
            from device_rate_plan where plan_name='{row['name']}'  \
            and account_id in (SELECT ID from accounts WHERE NOTIFICATION_UUID='{row['billing_account_id']}');"""

            id_dvc_tmp = sql_query_fetch(select_dvc_tmp_ID_query, aircontrol_db_configs, logger_error)

            row["device_plan_id"] = id_dvc_tmp[0][0]
            row["template_id"] = id_dvc_tmp[0][1]

        except Exception as e:
            logger_info.error(e)

    tarrifs_ids_querry=f"""select pc.PLAN_ID,pc.CHARGE_SPEC_ID,cs.CHARGE_CATEGORY,cs.GL_CODE_ID,cs.ACTION_TYPE,cs.IS_PRORATION from plan_chargespecs pc inner join charging_spec \
                            cs on pc.CHARGE_SPEC_ID= cs.CHARGE_SPEC_ID inner join plan p on pc.PLAN_ID=p.PLAN_ID where p.LIFE_CYCLE_STATUS='LIVE' and PLAN_TYPE='Device' group by pc.PLAN_ID,pc.CHARGE_SPEC_ID,cs.CHARGE_CATEGORY,cs.GL_CODE_ID,cs.ACTION_TYPE,cs.IS_PRORATION;"""
    id_dvc_tmp = sql_query_fetch(tarrifs_ids_querry, product_catalogue, logger_error)

    data_df_tarrifs_ids = pd.DataFrame(id_dvc_tmp, columns=["plan_id","charge_spec_id","charge_category","gl_code_id","action_type","is_proration"])
    print(data_df_tarrifs_ids.columns)
    print(data_df_assets.columns)
    print(data_df_device_plan.columns)
    print(data_df_device_plan)

    sql_query_delete_table(billing_db_configs, "migration_assets",  logger_error)
    sql_query_delete_table(billing_db_configs, "migration_device_plan", logger_error)
    sql_query_delete_table(billing_db_configs, "migration_billing_charges", logger_error)

    data_df_assets, data_df_assets_error = insert_single_df_into_mysql(data_df_assets, billing_db_configs, "migration_assets",   logger_info, logger_error)

    data_df_device_plan, data_df_device_plan_error = insert_single_df_into_mysql(data_df_device_plan, billing_db_configs, "migration_device_plan" , logger_info, logger_error)

    data_df_tarrifs_ids, data_df_tarrifs_ids_error = insert_single_df_into_mysql(data_df_tarrifs_ids, billing_db_configs,"migration_billing_charges",  logger_info, logger_error)


    data_df_assets.to_csv("Billing_Success_Failure.csv")
    data_df_assets_error.to_csv("data_df_assets_error.csv")
    data_df_device_plan.to_csv("data_df_device_plan.csv")
    data_df_device_plan_error.to_csv("data_df_device_plan_error.csv")
    data_df_tarrifs_ids.to_csv("data_df_tarrifs_ids.csv")
    data_df_tarrifs_ids_error.to_csv("data_df_tarrifs_ids_error.csv")

    call_procedure(billing_db_configs['procedure_name'], billing_db_configs, logger_error, logger_info)



billing_mapping()

