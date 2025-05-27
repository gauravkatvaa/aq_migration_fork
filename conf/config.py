from dotenv import load_dotenv
import os
# Load environment variables from .env file
load_dotenv("../env/.env")

db_host = os.getenv("DB_HOST")
print("db host",db_host)
db_user = os.getenv("DB_USERNAME")
db_password = os.getenv("DB_PASSWORD")
aircontrol_db_host = os.getenv("AIRCONTROL_DB_HOST")
aircontrol_db_user = os.getenv("AIRCONTROL_USERNAME")
aircontrol_db_password = os.getenv("AIRCONTROL_PASSWORD")
aircontrol_db_name = os.getenv("AIRCONTROL_DB_NAME")
goup_thirdparty_db_name = os.getenv("GOUP_THIRDPARTY_DB_NAME")
goup_router_db_name = os.getenv("GOUP_ROUTER_DB_NAME")
bss_db_host = os.getenv("BSS_DB_HOST")
bss_db_user = os.getenv("BSS_DB_USERNAME")
bss_db_password = os.getenv("BSS_DB_PASSWORD")
bss_db_name = os.getenv("BSS_DB_NAME")
billing_db_host=os.getenv("BILLING_DB_HOST")
billing_db_username=os.getenv("BILLING_DB_USERNAME")
billing_db_password=os.getenv("BILLING_DB_PASSWORD")
billing_db_name = os.getenv("BILLING_DB_NAME")
pc_db_host = os.getenv("PRODUCT_CATALOGUE_DB_HOST")
pc_db_username = os.getenv("PRODUCT_CATALOGUE_DB_USERNAME")
pc_db_password = os.getenv("PRODUCT_CATALOGUE_DB_PASSWORD")
pc_db_name = os.getenv("PRODUCT_CATALOGUE_DB_NAME")
system_path = os.getenv("SYSTEM_CLIENT_PATH")
migration_db_name = os.getenv("MIGRATION_DB_NAME")
db_router_host=os.getenv("ROUTER_DB_HOST")


######## Oracle Db ################################

oracle_db_hostname = os.getenv("ORACLE_DB_HOST")
oracle_db_username = os.getenv("ORACLE_DB_USERNAME")
oracle_db_password = os.getenv("ORACLE_DB_PASSWORD")
oracle_db_sid = os.getenv("ORACLE_DB_SID")

chunk_size = 100000

offset=10000000

#####migration add in emails if yes then add other not
migration_add_email='yes'

logs_path = f'{system_path}/migration/logs/'
directory_path = f'{system_path}/migration/'
account_id_token = os.getenv("OPCO_ACCOUNT_ID")

x_user_id = os.getenv("X_USER_ID")
validation_log_dir = 'validation'
transformation_log_dir = 'transformation'
ingestion_log_dir = 'ingestion'
reconciliation_log_dir = 'reconciliation'
dbdeploy_log_dir='dbdeploy'
rollback_log_dir='rollback'
#################################### Aircontrol Mapping ################################################################
migration_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE": migration_db_name,
    "PORT": 3306,
}

aircontrol_db_configs = {
    "HOST" : aircontrol_db_host,
    "USER" : aircontrol_db_user,
    "PASSWORD" : aircontrol_db_password,
    "DATABASE" : aircontrol_db_name,
    "PORT": 3306,
    "procedure_name" : "migration_sim_bulk_insert",
    "sim_range_procedure_bulk_insert_proc": "sim_range_procedure_bulk_insert",
    "map_user_sim_order_procedure_bulk_insert_proc": "map_user_sim_order_procedure_bulk_insert",
    "order_shipping_status_bulk_insert_proc":"order_shipping_status_bulk_insert",
    "sim_event_log_bulk_insert_proc":"sim_event_log_bulk_insert",
    "sim_label_procedure":"tag_details",
    "sim_provisioned_range_details": "sim_provisioned_range_details"
}





########################### Goup Third Party DB Mapping  ###############################################################

goup_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE" : goup_thirdparty_db_name,
    "PORT": 3306,
    "procedure_name" : "migration_account_mapping"
}









################################ Router DB Config #############################################################################
router_db_configs = {
    "HOST" : db_router_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE" : goup_router_db_name,
    "PORT": 3306,
    "procedure_name" : "insert_sim_data_new"
}



############################### BSS, BILLING, PC DB Config #############################################################
bss_db_configs = {
    "HOST" : bss_db_host,
    "USER" : bss_db_user,
    "PASSWORD" : bss_db_password,
    "DATABASE" : bss_db_name,
    "PORT": 3306,
    "procedure_name" : "start_register_user_batch_call"
}

bss_proration_enabled = 1
bss_client_type = 44

billing_db_configs = {
    "HOST" : billing_db_host,
    "USER" : billing_db_username,
    "PASSWORD" : billing_db_password,
    "DATABASE" : billing_db_name,
    "PORT": 3306,
    "procedure_name" : "SIM_MIGRATION_PROCEDURE"
}




product_catalogue = {
    "HOST" : pc_db_host,
    "USER" : pc_db_username,
    "PASSWORD" : pc_db_password,
    "DATABASE" : pc_db_name,
    "PORT": 3306,
    "procedure_name" : ""

}

# Combine all configurations into a single dictionary
db_connections = {
    'Aircontrol': aircontrol_db_configs,
    'RouterDB': router_db_configs,
    'BSSDB': bss_db_configs,
    'Billing':billing_db_configs,
    # Add more connections if needed
}





oracle_source_db = {
    "HOST": oracle_db_hostname,
    "USER": oracle_db_username,
    "PASSWORD": oracle_db_password,
    "DATABASE_SID": oracle_db_sid,
    "PORT": 1521
}





###############################################

ac_db_configs = {
    "HOST" : aircontrol_db_host,
    "USER" : aircontrol_db_user,
    "PASSWORD" : aircontrol_db_password,
    "DATABASE" : aircontrol_db_name,
    "PORT": 3306,

}


opco_account_id = os.getenv("ACCOUNT_ID_OPCO_USER")

########################### Private shared flag #############
private_shared_at_mno_flag = 'no'
