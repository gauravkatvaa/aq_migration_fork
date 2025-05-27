from dotenv import load_dotenv
import os
# Load environment variables from .env file
load_dotenv("../env/.env")
system_path = os.getenv("SYSTEM_CLIENT_PATH")
aircontrol_api_host_port = os.getenv("AIRCONTROL_API_HOST_PORT")
username = os.getenv("OPCO_USERNAME")
password = os.getenv("OPCO_PASSWORD")


db_host = os.getenv("DB_HOST")
print("db host",db_host)
db_user = os.getenv("DB_USERNAME")
db_password = os.getenv("DB_PASSWORD")
notification_center_api_host=os.getenv("NOTIFICATION_CENTER_HOST")

################################## Validation Config ###################################################################




validation_error_dir = 'validation_error'

ec_duplicate_file_name = 'ec_duplicate_records'
feed_file_validation_data_formate="feed_file_validation_data_formate.csv"

error_directory=f'{system_path}/migration/src/validation/maxis/file_validation_script/'




################################################transformation_procedure_files###########################################

output_file_path = {
    'asset_dummy.csv': '/input_asset/',
    'asset_extended_dummy.csv': '/input_asset_extended/',
    'migration_assets.csv': '/billing_files/',
    'migration_device_plan.csv': '/billing_files/',
    'Goup_router_bulk_upload_dummy.csv':'/input_router/',
    'ip_white_listing_cdp.csv':'/',


}
output_file_base_dir = f'{system_path}/migration/data/custom/areas/transformed_records'

metadata_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE": 'metadata',
    "PORT": 3306,
}

validation_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE": 'validation',
    "PORT": 3306,
}


transformation_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE": 'transformation',
    "PORT": 3306,
}


ingestion_db_configs = {
    "HOST" : db_host,
    "USER" : db_user,
    "PASSWORD" : db_password,
    "DATABASE": 'ingestion',
    "PORT": 3306,
}



Vienna_Time_Zone=1
table_currency_id='currency'
table_cuntry_id='country'
table_company_address='addresses'
frequency_table='dic_bill_cycle'
new_role_mapping_table='dic_user_roles_lookup'
role_tab_table='role_table_list'



query_to_find_currency_id=f"SELECT CURRENCY, ID FROM {table_currency_id}"
query_to_find_iso_id=f"SELECT ISO_CODE, ID FROM {table_cuntry_id}"
query_to_find_company_address=f"SELECT PARTY_ROLE_ID,SUBSTRING_INDEX(COUNTRY, '.', -1) AS COUNTRY,CITY,STREET,POSTAL_CODE,STATE,BUILDING FROM {table_company_address} WHERE ADDRESS_TYPE = 'Company address'"
query_to_get_frequency=f" select ID ,BCTYPE from {frequency_table}"
query_to_get_new_role_mapping=f"SELECT LEGACYROLE,NEWROLE FROM {new_role_mapping_table}"
query_to_get_role_tab_screen_mapping=f"select roleDescription as roleName,roleToScreenList,roleToTabList from {role_tab_table}"
default_country_id=0

notificaton_url=f"https://{notification_center_api_host}/NotificationCenter/imei/notification"

###########################################cost_center_query#######################

cost_center_query = """
SELECT  b1.legacyBan AS buAccountId,a1.CC_NAME AS name,a1.COMMENTS AS comments FROM validation.cost_centers_success a1 LEFT JOIN transformation.bu_success b1 ON b1.legacyBan = a1.CCCRM_ID WHERE b1.legacyBan IS NOT NULL AND b1.legacyBan <> '';"""
###################################### Aircontrol Api Details ###############################################################################



api_validate_url = f"https://{aircontrol_api_host_port}/api/validate/user/v4"
ec_bu_onboarding_url = f"https://{aircontrol_api_host_port}/api/create/account"
user_onboarding_url = f"https://{aircontrol_api_host_port}/api/add/user"
role_creation_url = f"https://{aircontrol_api_host_port}/api/create/role"
aircontrol_get_subnet_ip = f"https://{aircontrol_api_host_port}/api/apn/ipaddress/range/?subnetIp="
aircontrol_create_apn_new = f"https://{aircontrol_api_host_port}/api/create/apn/stc"
cc_onboarding_url = f"https://{aircontrol_api_host_port}/api/costCenter"

aircontrol_add_sim_product_type = f"https://{aircontrol_api_host_port}/api/add/product/catlog"
aircontrol_assign_customer_sim_product = f"https://{aircontrol_api_host_port}/api/create/product/catalog/details/"

report_subscripttions_url=f"https://{aircontrol_api_host_port}/api/subscription/create"
aircontrol_create_ip_pool = f"https://{aircontrol_api_host_port}/api/create/ip/pool"
aircontrol_create_ip_pool_range = f"https://{aircontrol_api_host_port}/api/ipPool/available/range/v2"
ip_assignment_file_upload = f"https://{aircontrol_api_host_port}/api/importFile/deviceData"

# Notification Template and Trigger
aircontrol_create_template = f"https://{aircontrol_api_host_port}/api/createOrUpdate/trigger/template"
aircontrol_create_trigger = f"https://{aircontrol_api_host_port}/api/add/rule"


# CSR Jounery API
aircontrol_publish_zone_group = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/publishZoneGroup/"
product_catalogue_tarrifplan_url= f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/tariffplan"
apn_list_url  = f"https://{aircontrol_api_host_port}/api/apn/list?opcoLevel=true&buAccountId="
product_catalogue_accountplan_url = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/accountplan?"
csrDevicePlanAccountPlanUrl = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/deviceplan?accountPlanId="
csr_get_account_level_discount = f"https://{aircontrol_api_host_port}//restservices/productcatalogue/v1/catalog/aircontrol/account-level-discont?planId="
aircontrol_create_wholesale = f"https://{aircontrol_api_host_port}/api/create/wholesale"
csr_get_wholesale_Url = f"https://{aircontrol_api_host_port}/api/wholesale/plans?"
aircontrol_create_account_discount = f"https://{aircontrol_api_host_port}//create/account/discount"
aircontrol_create_apn = f"https://{aircontrol_api_host_port}/api/create/apn/stc/bulk"
csrAddOnPlanAccountPlanUrl = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/addonplan?accountPlanId="
aircontrol_create_data_plan = f"https://{aircontrol_api_host_port}/api/create/bulk/dataPlan"
aircontrol_create_data_plan_publish_status = f"https://{aircontrol_api_host_port}/api/update/dataPlans/publishStatus?"
aircontrol_create_charges = f"https://{aircontrol_api_host_port}/api/csr/create/charges"
aircontrol_create_zone = f"https://{aircontrol_api_host_port}/api/create/zone"
aircontrol_create_price_model = f"https://{aircontrol_api_host_port}/api/create/priceModel"
csr_get_price_model_url = f"https://{aircontrol_api_host_port}/api/price/models?"
aircontrol_create_service_plan = f"https://{aircontrol_api_host_port}/api/create/servicePlan"
aircontrol_create_device_plan = f"https://{aircontrol_api_host_port}/api/create/deviceplan?"


################################ BSS BILLING Migration #################################################################

billing_bss_assets_event_date = "2024-02-28 00:00:00"

############################## Reconcillation Report ###############
output_file_name=f'{system_path}/migration/src/reconciliation/ares/stc_data_validation/Validation_files/'
post_csv_file_path = f'{system_path}/migration/data/custom/ares/reconciliation_result/post_csv_file.csv'
pre_csv_file_path = f'{system_path}/migration/data/custom/ares/reconciliation_result/pre_max_id.csv'
final_csv_file_path = f'{system_path}/migration/data/custom/ares/reconciliation_result/final_csv.csv'
input_file_path=f'{system_path}/migration/data/custom/ares/input_data'
FinalReconcilation_path=f'{system_path}/migration/data/custom/ares/reconciliation_result/ReconciliationReport.xlsx'

################################dict_for_device_plan
update_dict = {
    '35022264190':'DP-SIM-PRIVATE_35022264190',
    '35019750718':'DP-SIM-PRIVATE_35019750718',
    '35013267454':'DP-SIM-PUBLIC_35013267454',
}

#####this is use for 
# Dictionary with queries and their aliases
queries = {
    'Aircontrol': {
        'select max(id) from users': 'user_max_id',
        'select max(id) from role_access':'role_access_max_id',
        'select max(id) from map_user_sim_order':'map_user_sim_order_max_id',
        'select max(id) from sim_range':'sim_range_max_id',
        'select max(id) from order_shipping_status':'order_shipping_status_max_id',
        'select max(id) from sim_event_log':'sim_event_log_max_id',
        'select max(id) from accounts':'accounts_max_id',
        'select max(id) from assets':'assets_max_id',
        'select max(id) from assets_extended':'assets_extended_max_id',
        'select count(*) from accounts':'accounts_count',
        'select count(*) from map_user_sim_order':'map_user_sim_order_count',
        'select count(*) from sim_range':'sim_range_count',
        'select count(*) from order_shipping_status':'order_shipping_status_count',
        'select count(*) from sim_event_log':'sim_event_log_count',
        'select count(*) from users':'users_count',
        'select count(*) from role_access':'role_access_count',
        'select count(*) from assets':'assets_count',
        'select count(*) from assets_extended':'assets_extended_count'
    },
    'RouterDB': {
        'select max(id) from assets':'migration_assets_max_id',
        'select max(id) from sim_map':'sim_map_max_id',
        'select max(id) from sim_donor_identfiers':'sim_donor_identfiers_max_id',
    },
    'Billing': {
        'select max(id) from account':'account_max_id',
        'select count(id) from account':'brstcbilling_s4p2d2.account_count_id',
        'select count(*) from sim_activation':'sim_activation_count_id',
        'select count(*) from billing_charges':'billing_charges_count_id'
    },
    'BSSDB': {
        'select max(ACCOUNT_ID) from tenterprise_account':'tenterprise_account_max_account_id',
        'select count(*) from tenterprise_account':'tenterprise_account_count',
        'SELECT COUNT(*) FROM tuser_sim_card WHERE imsi IN (SELECT imsi FROM migration_asset)':'tuser_sim_card_count',
        'SELECT COUNT(*) FROM tsim_card WHERE imsi IN (SELECT imsi FROM migration_asset)':'tsim_card_count',
        'select count(*) from migration_asset where status=1':'migration_asset_count'
    },
}



####################################################DB_DEPLOY_script##################################
aircontrol_db_rollback_script=f"{system_path}/migration/db/ares/rollback/aircontrol/gcontrol_accounts_deletion_v1.sql"
asset_migration_helpr_tables_procedure_script = f"{system_path}/migration/db/ares/loading/aircontrol/gcontrol_procedure.sql"

billing_db_rollback_script = f"{system_path}/migration/db/ares/rollback/billing/SP_BillingBuCleanup.sql"
bss_db_rollback_script = f"{system_path}/migration/db/ares/rollback/bss/removeAccountDetails.sql"


billing_db_deploy_script0 = f"{system_path}/migration/db/ares/transformation/A1_billing_file_22022025.sql"

bss_db_deploy1 = f"{system_path}/migration/db/ares/asset/bss/create_table_migration_asset.sql"
bss_db_deploy2 = f"{system_path}/migration/db/ares/asset/bss/register_user.sql"
bss_db_deploy3 = f"{system_path}/migration/db/ares/asset/bss/start_register_user_batch_call.sql"
bss_db_deploy4 = f"{system_path}/migration/db/ares/asset/bss/migration-optimization.sql"
bss_db_deploy5 = f"{system_path}/migration/db/ares/asset/bss/register_user_optimized.sql"
bss_db_deploy6 = f"{system_path}/migration/db/ares/asset/bss/start_register_user_batch_call_optimized.sql"
bss_reconcilation_procedure=f"{system_path}/migration/db/ares/asset/bss/bss_stc_after_migration_account_level_recon_01082024.sql"

a1_validation_db_deploy = f"{system_path}/migration/db/ares/transformation/validation.sql"
a1_transformation_db_deploy = f"{system_path}/migration/db/ares/transformation/transformation.sql"
a1_ingestion_db_deploy = f"{system_path}/migration/db/ares/transformation/ingestion.sql"
a1_metadata_db_deploy = f"{system_path}/migration/db/ares/transformation/metadata.sql"


csr_mapping_details_sp = f"{system_path}/migration/db/ares/procedures/csr_mapping_details.sql"
csr_mapping_master_sp = f"{system_path}/migration/db/ares/procedures/csr_mapping_master.sql"

############################        List _of_db_deploye         #########################################

a1_migration_db_deploy_list = [a1_validation_db_deploy, a1_transformation_db_deploy, a1_ingestion_db_deploy, a1_metadata_db_deploy]

aircontrol_db_deploy_script_list = [aircontrol_db_rollback_script, asset_migration_helpr_tables_procedure_script]

# bss_db_deploy_list = [bss_db_deploy1, bss_db_deploy2, bss_db_deploy3, bss_db_deploy4, bss_db_deploy5, bss_db_deploy6, bss_reconcilation_procedure]
bss_db_deploy_list = [bss_db_rollback_script]

# billing_db_deploy_script_list = [billing_db_deploy_script0]
billing_db_deploy_script_list = [billing_db_rollback_script]

validation_db_procedures_list = [csr_mapping_details_sp, csr_mapping_master_sp]

###############################  DB Helper vairables ######################################################

# For trigger_success and failure you have to create tables manually 
oracle_mysql_success_failure_table_mapper = {
    'CUSTOMERS': ('ec_success', 'ec_failure'),
    'BUSINESS_UNITS': ('bu_success', 'bu_failure'),
    'USERS': ('users_success', 'users_failure'),
    'COST_CENTERS': ('cost_centers_success', 'cost_centers_failure'),
    'DIC_APNS': ('apn_success', 'apn_failure'),
    'NOTIFICATIONS': ('notifications_success', 'notifications_failure'),
    'SERVICE_PROFILES': ('service_profiles_success', 'service_profiles_failure'),
    'LIFE_CYCLES': ('life_cycles_success', 'life_cycles_failure'),
    'SIM_ASSETS': ('asset_success', 'asset_failure'),
    'REPORTS': ('report_subscriptions_success', 'report_subscriptions_failure'),
    'IP_POOL': ('ip_pool_success', 'ip_pool_failure'),
}

mysql_table_oracle_table_mapper = {
    'ec_failure': 'CUSTOMER_VALIDATION_REJECTS',
    'bu_failure': 'BUSINESS_UNITS_VALIDATION_REJECTS',
    'users_failure': 'USERS_VALIDATION_REJECTS',
    'cost_centers_failure': 'COST_CENTERS_VALIDATION_REJECTS',
    'apn_failure': 'DIC_APNS_VALIDATION_REJECTS',
    'notifications_failure': 'NOTIFICATIONS_VALIDATION_REJECTS',
    'trigger_failure': 'TRIGGERS_VALIDATION_REJECTS',
    'service_profiles_failure': 'SERVICE_PROFILES_VALIDATION_REJECTS',
    'life_cycles_failure': 'LIFE_CYCLES_VALIDATION_REJECTS',
    'asset_failure': 'SIM_ASSETS_VALIDATION_REJECTS',
    'report_subscriptions_failure': 'REPORTS_VALIDATION_REJECTS',
    'ip_pool_failure': 'IP_POOL_VALIDATION_REJECTS',
}

mysql_oracle_error_codes_tables_mapper = {
    'ec_error_codes': 'CUSTOMER_ERROR_CODES',
    'bu_error_codes': 'BUSINESS_UNITS_ERROR_CODES',
    'apn_error_codes': 'DIC_APNS_ERROR_CODES',
    'asset_error_codes': 'SIM_ASSETS_ERROR_CODES',
    'cost_centers_error_codes': 'COST_CENTERS_ERROR_CODES',
    'ip_pool_error_codes': 'IP_POOL_ERROR_CODES',
    'life_cycles_error_codes': 'LIFE_CYCLES_ERROR_CODES',
    'notifications_error_codes': 'NOTIFICATIONS_ERROR_CODES',
    'report_subscriptions_error_codes': 'REPORTS_ERROR_CODES',
    'service_profiles_error_codes': 'SERVICE_PROFILES_ERROR_CODES',
    'triggers_error_codes': 'TRIGGERS_ERROR_CODES',
    'users_error_codes': 'USERS_ERROR_CODES',
}




###Reconciliation Report config #####

error_message_tables = {
    "apn_failure": "Apn",
    "bu_failure": "Business Unit",
    "cost_center_failure":"CostCenter",
    "ec_failure": "Enterprise Customer",
    "notifications_failure": "notification_template",
    "report_subscriptions_failure": "Report Subscriptions",
    "role_failure": "Role and Access",
    "triggers_failure": "rule_trigger",
    "user_failure": "User",
    "labels_failure":"Labels",
    "cost_centers_failure":"CostCenter",
    "trigger_failure":"rule_trigger",
    "users_failure": "User"
}

replace_entity_type = {
    "Enterprise Customer": "EC",
    "Business Unit": "BU",
    "Cost_Center": "Cost Centers",
    "notification_template": "Notification Template",
    "Report Subscriptions": "Report Subscriptions",
    "Role and Access": "Role and Access",
    "rule_trigger": "Rule Engine",
    "User": "User",
    "life_cycles": "Life Cycles",
    "service_profiles": "Device Details",
    "apn creation": "APN",
    "asset": "Sim Assets"
}

db_table ={
    "validation_db_tables":["apn_failure", "bu_failure", "cost_centers_failure","ec_failure","notifications_failure","report_subscriptions_failure","trigger_failure","users_failure"] ,
    "ingestion_db_tables": ["apn_failure", "bu_failure", "cost_center_failure","ec_failure","notifications_failure","report_subscriptions_failure","role_failure","triggers_failure","user_failure"] 
}

csv_and_excel_fille_path = {
    "metadata_db_validation_summary_file":"validation_summary_file.csv",
    "metadata_db_loading_summary_file":"loading_summary_file.csv",
    "validation_db_tables_error_code_file":"error_code.csv",
    "ingestion_db_tables_errormessage_file":"error_messages.csv",
    "code_with_error_message_file":"code_with_error_message.csv",
    "reconciliation_report_matrix_csv_file":"ReconciliationReportMatrix.csv",
    "reconciliation_report_matrix_xlsx_file":"ReconciliationReportMatrix.xlsx",
    "combine_validation_error_excel_file": "validation_tables.xlsx",
    "combine_ingestion_error_excel_file":"loading_tables.xlsx"
}