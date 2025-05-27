from dotenv import load_dotenv
import os
# Load environment variables from .env file
load_dotenv("../env/.env")

system_path = os.getenv("SYSTEM_CLIENT_PATH")
aircontrol_api_host_port = os.getenv("AIRCONTROL_API_HOST_PORT")
soap_api_host_port = os.getenv("SOAP_API_HOST_PORT")
ocs_asset_path = os.getenv("OCS_FILE_PATH")
print("system path",system_path)
print("api host port",aircontrol_api_host_port)

########################################### STC Validation Layer Config ##############################################

feed_file_path = f'{system_path}/migration/data/custom/apollo/input_data'
error_record_file_path = f'{system_path}/migration/data/custom/apollo/error_records'
input_file_path = f'{system_path}/migration/data/custom/apollo/valid_records'
history_files_path = f'{system_path}/migration/src/validation/apollo/file_validation_script/history'
history_file_path_transformation = f'{system_path}/table_migration/history'
pc_valid_file_path=f'{system_path}/migration/pc_migration_scripts/scripts4_pc_import'

output_file_base_dir = f'{system_path}/migration/data/custom/apollo/transformed_records'


chunk_size=10000
country='Saudi Arabia'
###
table_name=['accounts','sim_range','map_user_sim_order','order_shipping_status','sim_event_log','sim_provisioned_range_details','map_user_sim_order','tag','sim_range_msisdn',]
KSA_OPCO_user='KSA_OPCO'


output_file_path = {
    'addCustomerForprivateapn.csv': '/',
    'apnCreation.csv': '/',
    'asset_dummy.csv': '/input_asset/',
    'asset_extended_dummy.csv': '/input_asset_extended/',
    'AccountOnboard.csv': '/',
    'lead_person_creation.csv': '/',
    'migration_assets.csv': '/billing_files/',
    'migration_device_plan.csv': '/billing_files/',
    'userCreation.csv': '/',
    'CSRJourney.xlsx': '/',
    'Goup_router_bulk_upload_dummy.csv':'/input_router/',
    'ip_pooling.csv': '/',
    'sim_product_type_Creation.csv':'/',
    'CSRMappingDetails.xlsx': '/',
    'CSRMappingMaster.xlsx': '/',
    'AccountOnboard_1.csv':'/',
    'migration_map_user_sim_order.csv':'/sim_range_order/',
    'migration_sim_range.csv':'/sim_range_order/',
    'migration_order_shipping_status.csv':'/sim_range_order/',
    'migration_sim_event_log.csv':'/sim_range_order/',
    'migration_sim_provisioned_range_details.csv':'/sim_range_order/',
    'migration_sim_range_msisdn.csv':'/sim_range_order/',
    'cost_center_cdp.csv':'/',
    'label_cdp.csv':'/',
    'api_user_cdp.csv':'/',
    'ip_white_listing_cdp.csv':'/',


}

querry_for_cost_center_cdp='SELECT a1.CCNAME,b1.billing_account FROM cost_center_cdp a1  LEFT JOIN billing_account_cdp b1 ON  b1.BUID =BUID_EXT ;'

cost_center_column=['name','buAccountId']
############################# Aircontrol config ############################s
public_subnet_file_path = f'{feed_file_path}/Copy_of_IP_Pools_with_BU_Subnets.csv'
private_subnet_file_path = f'{feed_file_path}/private_APNs.csv'

apn_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/apnCreation.csv'
sim_product_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/sim_product_type_Creation.csv'
lead_person_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/lead_person_creation.csv'
user_creation_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/userCreation.csv'
account_onboarding_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/AccountOnboard.csv'

bu_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/bu_unit_df.csv'
# account_onboarding_csv_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/AccountOnboard_1.csv'
ip_pool_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/ip_pooling.csv'
aircontrol_get_subnet_ip = f"https://{aircontrol_api_host_port}/api/apn/ipaddress/range/?subnetIp="
aircontrol_create_apn_new = f"https://{aircontrol_api_host_port}/api/create/apn/stc"
aircontrol_add_sim_product_type = f"https://{aircontrol_api_host_port}/api/add/product/catlog"
aircontrol_assign_customer_sim_product = f"https://{aircontrol_api_host_port}/api/create/product/catalog/details/"
aircontrol_api_url_users_creation = f"https://{aircontrol_api_host_port}/api/add/user"
aircontrol_api_get_ip_pool = f"https://{aircontrol_api_host_port}/api/ipPool/available/range?apnId="
aircontrol_api_create_ip_pool = f"https://{aircontrol_api_host_port}/api/create/ipPool"
soap_api_url=soap_api_host_port
# soap_api_url = f'https://{soap_api_host_port}/GoupRouterSOAP/services/CustomerOnboardOperationsImplService?wsdl'
# soap_api_url = f'https://{soap_api_host_port}/STCCMPSoapInterfaceS4P2/services/CustomerOnboardOperationsImplService?wsdl'
########################## Asset Table Migration Ingestion Layer ######################################################

################### Aircontrol #######################
asset_error_file_name = 'asset_procedure_error.csv'
asset_extended_error_file_name = 'asset_extended_procedure_error.csv'
assets_insertion_error_filename = 'assets_extended_insertion_error.csv'
assets_extended_insertion_error_filename = 'assets_insertion_error.csv'

aircontrol_file_path = {
    'file_path_assets' : f'{system_path}/migration/data/custom/apollo/transformed_records/input_asset/',
    'file_path_asset_extended' : f'{system_path}/migration/data/custom/apollo/transformed_records/input_asset_extended/'
}

################## Router #############################
router_error_file_name = 'router_error_file.csv'
router_insertion_error_file_name = 'assets_router_insertion_error.csv'

router_file_path = {
    'file_path_router' : f'{system_path}/migration/data/custom/apollo/transformed_records/input_router/',

}


###historydirctory
history_file_path=f'{system_path}/migration/src/ingestion/apollo/asset_table_migration/history'
###input_dirctory_
sim_Range_input_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/sim_range_order'



################################ BSS BILLING Migration #################################################################

billing_bss_assets_event_date = "2024-02-28 00:00:00"


billing_file_path = {
    'file_migration_assets' : f'{system_path}/migration/data/custom/apollo/transformed_records/billing_files/migration_assets.csv',
    'file_migration_charges' : f'{system_path}/migration/data/custom/apollo/transformed_records/billing_files/migration_device_plan.csv',
    'file_migration_plan' : f'{system_path}/migration/data/custom/apollo/transformed_records/billing_files/migration_tarrifs_ids.csv',
    'bss_common_csv' : f'{system_path}/migration/data/custom/apollo/transformed_records/billing_bss_common_csv_file/data_df_assets.csv'
}


############################ OCS File Path #############################################################################
ocs_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/input_asset/asset_dummy.csv'
ocs_output_file_path = ocs_asset_path

############################### CSR Journey ############################################################################

############################## PC API Details ################################################################

api_validate_url = f"https://{aircontrol_api_host_port}/api/validate/user"
apn_list_url  = f"https://{aircontrol_api_host_port}/api/apn/list?opcoLevel=true&buAccountId="

product_catalogue_tarrifplan_url= f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/tariffplan?currency=EUR"

product_catalogue_accountplan_url = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/accountplan?"
csrDevicePlanAccountPlanUrl = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/deviceplan?accountPlan="
csrAddOnPlanAccountPlanUrl = f"https://{aircontrol_api_host_port}/restservices/productcatalogue/v1/catalog/aircontrol/addonplan?accountPlan="
csr_get_wholesale_Url = f"https://{aircontrol_api_host_port}/api/wholesale/plans?"
csr_get_price_model_url = f"https://{aircontrol_api_host_port}/api/price/models?"
csr_get_account_level_discount = f"https://{aircontrol_api_host_port}//restservices/productcatalogue/v1/catalog/aircontrol/account-level-discont?planId="

############# CSR File Path #################
mapping_master_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/CSRMappingMaster.xlsx'
mapping_details_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/CSRMappingDetails.xlsx'


username = os.getenv("OPCO_USERNAME")
password = os.getenv("OPCO_PASSWORD")



############################## Aircontrol API Details ################################################################


aircontrol_create_wholesale = f"https://{aircontrol_api_host_port}/api/create/wholesale"
aircontrol_create_account_discount = f"https://{aircontrol_api_host_port}//create/account/discount"
aircontrol_create_apn = f"https://{aircontrol_api_host_port}/api/create/apn/stc/bulk"
aircontrol_create_charges = f"https://{aircontrol_api_host_port}/api/csr/create/charges"
aircontrol_create_zone = f"https://{aircontrol_api_host_port}/api/create/zone"
aircontrol_create_price_model = f"https://{aircontrol_api_host_port}/api/create/priceModel"
aircontrol_create_service_plan = f"https://{aircontrol_api_host_port}/api/create/servicePlan"
aircontrol_create_device_plan = f"https://{aircontrol_api_host_port}/api/create/deviceplan?=null"
aircontrol_create_data_plan = f"https://{aircontrol_api_host_port}/api/create/bulk/dataPlan"
aircontrol_create_data_plan_publish_status = f"https://{aircontrol_api_host_port}/api/update/dataPlans/publishStatus?"

############################## Reconcillation Report ###############
output_file_name=f'{system_path}/migration/src/reconciliation/apollo/stc_data_validation/Validation_files/'
post_csv_file_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/post_csv_file.csv'
pre_csv_file_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/pre_max_id.csv'
final_csv_file_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/final_csv.csv'
aircontrol_reconcilation_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/aircontrol_recon.csv'
billing_reconcilation_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/billing_recon.csv'
bss_reconcilation_path = f'{system_path}/migration/data/custom/apollo/reconciliation_result/bss_recon.csv'


################################### Product Catalogue_file_path####################
zone_group_data = f'{system_path}/migration/data/custom/apollo/valid_records/zonegroup_load_data.csv'
zone_product_data = f'{system_path}/migration/data/custom/apollo/valid_records/zone_product_pricing_load_data.csv'
entitlement_data=f'{system_path}/migration/data/custom/apollo/valid_records/Entitlement_data_load.csv'
dicount_data=f'{system_path}/migration/data/custom/apollo/valid_records/Discount_data_load.csv'



################################# Cost Center ###############################################################

cost_center_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/cost_center_cdp.csv'

cost_center_api_url = f'https://{aircontrol_api_host_port}/api/costCenter'


################################# Api User ###############################################################

api_user_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/api_user_cdp.csv'

api_user_api_url = f'https://{aircontrol_api_host_port}/api/create/apiUser'




################################# white listing  ###############################################################

white_listing_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/ip_white_listing_cdp.csv'

white_listing_api_url = f'https://{aircontrol_api_host_port}/api/create/ipwhitelist'




################################# apn assing  ###############################################################

apn_assign_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/addCustomerForprivateapn.csv'

apn_assign_api_url = f'https://{aircontrol_api_host_port}//api/apn/assign?'

################################# ip_polling assing  ###############################################################

ip_pooling_assign_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/ip_pooling.csv'

ip_pooling_assign_api_url = f'https://{aircontrol_api_host_port}//api/add/bu/ipPooling?'



################################# Template & Trigger ####################################################

template_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/template.csv'
trigger_file_path = f'{system_path}/migration/data/custom/apollo/transformed_records/trigger_cdp.csv'

template_api_url = f'https://{aircontrol_api_host_port}/api/createOrUpdate/trigger/template'
trigger_api_url = f'https://{aircontrol_api_host_port}//api/add/rule'



################################dict
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
aircontrol_db_deploy_script1=f"{system_path}/migration/db/apollo/loading/aircontrol/gecontrol_table_09072024.sql"
aircontrol_db_procedure_script=f"{system_path}/migration/db/apollo/loading/aircontrol/gecontrol_SPS_09072024.sql"
aircontrol_db_deploy_script2=f"{system_path}/migration/db/apollo/loading/aircontrol/cmp_stc_staging_SPS.sql" #migration_sim_range_19072024.sql"
aircontrol_db_deploy_script3=f"{system_path}/migration/db/apollo/loading/aircontrol/sim_range_procedure_bulk_insert_08092024.sql"
aircontrol_db_deploy_script4=f"{system_path}/migration/db/apollo/loading/aircontrol/sim_event_log_bulk_insert_10092024.sql"
aircontrol_db_deploy_script5=f"{system_path}/migration/db/apollo/loading/aircontrol/migration_sim_range_msisdn_11092024.sql"
aircontrol_reconcilation_procedure=f"{system_path}/migration/db/apollo/loading/aircontrol/sp_tbl_air_control_stc_after_migration_account_level_recon_01082024.sql"
rollback_aircontrol_procedure=f"{system_path}/migration/db/apollo/rollback/aircontrol/gcontrol_accounts_deletion_v1_09092024.sql"

router_db_deploy_script1=f"{system_path}/migration/db/apollo/loading/router/router_procedure_14.06.2024.sql"
router_db_deploy_script2=f"{system_path}/migration/db/apollo/loading/router/router_table_14.06.2024.sql"

billing_reconcilation_procedure=f"{system_path}/migration/db/apollo/asset/billing/brstcbilling_stc_after_migration_account_level_recon_01082024.sql"
billing_db_dump=f"{system_path}/migration/db/apollo/asset/billing/billing_file.sql"



bss_db_deploy1=f"{system_path}/migration/db/apollo/asset/bss/create_table_migration_asset.sql"
bss_db_deploy2=f"{system_path}/migration/db/apollo/asset/bss/register_user.sql"
bss_db_deploy3=f"{system_path}/migration/db/apollo/asset/bss/start_register_user_batch_call.sql"
bss_db_rollback_script=f"{system_path}/migration/db/apollo/rollback/bss/stcdeleteentaccount.sql"
bss_reconcilation_procedure=f"{system_path}/migration/db/apollo/asset/bss/bss_stc_after_migration_account_level_recon_01082024.sql"

product_catalogue_db_deploy1=f"{system_path}/migration/pc_migration_scripts/scripts4_pc_import/0_zonegroup_data_StoredProcedure.sql"


transformation_db_deploy1=f"{system_path}/migration/db/apollo/transformation/stc_migration_12092024.sql" #stc_migration_SPS_Functions.sql#stc_migration_complete_bkp_20062024013313.sql"


############################        List _of_db_deploye         #########################################

transformation_db_deploy_list=[transformation_db_deploy1]

aircontrol_db_deploy_script_list=[aircontrol_db_deploy_script1,aircontrol_db_procedure_script,aircontrol_db_deploy_script2,aircontrol_db_deploy_script3,aircontrol_db_deploy_script4,
aircontrol_db_deploy_script5,aircontrol_reconcilation_procedure,rollback_aircontrol_procedure]

router_db_deploy_script_list=[router_db_deploy_script1,router_db_deploy_script2]

product_catalogue_db_deploy_list=[product_catalogue_db_deploy1]

bss_db_deploy_list=[bss_db_deploy1,bss_db_deploy2,bss_db_deploy3,bss_db_rollback_script,bss_reconcilation_procedure]

billing_db_deploy_script_list=[billing_reconcilation_procedure,billing_db_dump]

###############################################Reconsilation###########################################
Reconsilation_file_name=f"{system_path}/migration/data/custom/apollo/reconciliation_result/valiation.csv"
transformation_ingestion_file_name=f"{system_path}/migration/data/custom/apollo/reconciliation_result/transformation_ingestion.csv"
transformation_procedure_file_name=f"{system_path}/migration/data/custom/apollo/reconciliation_result/transformation_procedure.csv"







############################################ DP_name_matching_sheet_path #############################
dP_name_matching_sheet_path=f"{system_path}/migration/data/custom/apollo/input_data/dp_name_match.csv"