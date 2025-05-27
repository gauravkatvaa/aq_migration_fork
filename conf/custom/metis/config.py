from dotenv import load_dotenv
import os
# Load environment variables from .env file
load_dotenv("../env/.env")
system_path = os.getenv("SYSTEM_CLIENT_PATH")

################################## Validation Config ###################################################################

validation_logs = {
    "validation_info_logs" : "validation_info.log",
    "validation_error_logs" : "validation_error.log",
}


input_files_path = f'{system_path}/migration/data/custom/metis/Input'

output_files_path = f'{system_path}/migration/data/custom/metis/Feed_File_Valid_File'

history_files_path = f'{system_path}/migration/src/validation/metis/file_validation_script/history'


# m2m_company_split_files_folder_name = 'M2M_Company'
m2m_company_duplicate_file_name = 'M2M_Company_Duplicate_Records'
m2m_service_duplicate_file_name = 'M2M_Service_Duplicate_Records'
six_users_duplicate_file_name = 'Six_Users_Duplicate_Records'

validation_error_dir = 'VALIDATION_ERROR'

manadatory_column_pic = ["brn","email","login_name","role_name"]




pic_file_prefix = '6_users'
contact_list_file_prefix = 'eCMP_Contact_List'
m2m_company_file_prefix = 'eCMP_M2M_Company'
m2m_service_file_prefix = 'eCMP_Service_Status'

feed_file_validation_data_formate="feed_file_validation_data_formate.csv"



error_directory=f'{system_path}/migration/src/validation/metis/file_validation_script/'

########################################################################################################################


input_file_path = f'{system_path}/migration/data/custom/metis/Feed_File_Valid_File'

history_file_path = f'{system_path}/migration/src/transformation/metis/metis_migration/history'

output_file_base_dir = f'{system_path}/migration/data/custom/metis/transformed_records'

output_file_path = {

    'migration_contact_info.csv': '/M2M_Company_Files/',
    'migration_account_extended.csv': '/M2M_Company_Files/',
    'migration_accounts.csv': '/M2M_Company_Files/',
    'migration_account_goup_mappings.csv': '/M2M_Company_Files/',
    'migration_zones.csv': '/M2M_Company_Files/',
    'migration_zone_to_country.csv': '/M2M_Company_Files/',
    'migration_role_access.csv': '/M2M_Company_Files/',
    'migration_role_to_screen_mapping.csv': '/M2M_Company_Files/',
    'migration_role_to_tab_mapping.csv': '/M2M_Company_Files/',
    'migration_price_model_rate_plan.csv':'/M2M_Company_Files/',
    # 'price_service_type.csv':'/M2M_Company_Files/',
    'migration_price_to_model_type.csv':'/M2M_Company_Files/',
    'migration_pricing_categories.csv':'/M2M_Company_Files/',
    'migration_whole_sale_rate_plan.csv':'/M2M_Company_Files/',
    'migration_whole_sale_to_pricing_categories.csv':'/M2M_Company_Files/',
     ##Gou_poroc
    'migration_account_mapping.csv':'/Goup_Company_Files/',
    #user
    'migration_users.csv':'/M2M_Company_Files/',
    'migration_user_details.csv': '/M2M_Company_Files/',
    'migration_contect_info_procedure.csv': '/M2M_Company_Files/',
    'migration_user_extended_accounts.csv': '/M2M_Company_Files/',
    # ##service
    'migration_service_plan.csv':'/M2M_Service_Files/',
    'migration_service_plan_to_service_type.csv': '/M2M_Service_Files/',
    'migration_device_rate_plan.csv': '/M2M_Service_Files/',
    'migration_service_apn_details.csv': '/M2M_Service_Files/',
    'migration_service_apn_ip.csv': '/M2M_Service_Files/',
    ###single calll
    'data.csv':'/',
    ##Assests
    'migration_sim_provisioned_range_details.csv':'/M2M_Service_Files/',
    'migration_sim_provisioned_ranges_level1.csv':'/M2M_Service_Files/',
    'migration_sim_provisioned_ranges_level2.csv':'/M2M_Service_Files/',
    'migration_sim_provisioned_ranges_level3.csv':'/M2M_Service_Files/',
    'migration_assets_extended.csv':'/M2M_Service_Files/',
    'migration_assets.csv': '/M2M_Service_Files/',
    'migration_sim_provisioned_range_to_account_level3.csv':'/M2M_Service_Files/',

    ###Asset_Table(Goup amd Router)
    'migration_goup_assets.csv':'/Goup_Asset_Files/',
    #### service_Table(Goup amd Router)
    'migration_goup_service_plan.csv':'/Goup_Asset_Files/',

}


chunk_size = 100000
###Query
# query = "SELECT IFNULL(MAX(id),0)+1 FROM accounts;"
opco_user = 'opco'


table_name=['role_to_tab_mapping','role_to_screen_mapping','role_access','whole_sale_rate_plan','pricing_categories',
            'price_to_model_type','price_model_rate_plan','zones','accounts','account_extended','accounts','contact_info',
            'whole_sale_to_pricing_categories','users','contact_info','user_details','account_goup_mappings','sim_provisioned_range_details',
            'sim_provisioned_ranges_level1','sim_provisioned_ranges_level2','sim_provisioned_ranges_level3','accounts','accounts','assets_extended',
            'device_rate_plan','service_plan','service_apn_details','migration_service_apn_details','service_apn_ip']





sp_result_values_file='procedure_csv_file_and_results.csv'
file_result_values='all_csv_valiadate_files.csv'





###offset
base_offset=1
high_offset=0
top_offset=0

########################### Company File Configuration #################################################################
company_history_file_path = f'{system_path}/migration/src/ingestion/metis/company_migration/history'
company_input_file_path = f'{system_path}/migration/data/custom/metis/transformed_records/M2M_Company_Files/'

asset_error_file_name = 'asset_procedure_error'
asset_extended_error_file_name = 'asset_extended_procedure_error'

aircontrol_procedure = {
    "account_bulk_insert" : "migration_account_bulk_insert",
    "organization_procedure_name" : "gcontrol_account_organization_mapping_mv1",
    "device_rate_plan_procedure": "device_rate_plan_procedure",
    "service_apn_details_procedure":"service_apn_details_procedure",
    "service_apn_ip_procedure":"service_apn_ip_procedure",
    "service_plan_info_procedure":"service_plan_info_procedure",
    "service_plan_to_service_type_procedure":"service_plan_to_service_type_procedure",
    "migration_account_batch_mapping_procedure":"migration_account_batch_mapping_procedure",
    "migration_provisioned_range_procedure":"migration_provisioned_range_to_account_bulk_insert",
    "bulk_insert_procedure": "migration_sim_bulk_insert",
}

goup_file_path = f'{system_path}/migration/data/custom/metis/transformed_records/Goup_Company_Files/'

# router_error_file_name = 'router_error_file'

goup_procedure = {
    "account_procedure" : "migration_account_mapping",
    "service_procedure" : "migration_service_mapping_goup"
}

router_procedure = {
    "procedure_name" : "insert_sim_data_new"
}

header_company=["Timestamp","TableName","ValidRecordsTotal", "ValidRecordsSuccess", "ValidationError"]
company_data_record_file="company_data_record_file.csv"
company_router_data_record_file="company_router_data_record_file.csv"
company_procdure_record_file='company_procdure_record_file.csv'
company_procdure_router_record_file='company_procdure_router_record_file.csv'

###################################### Service File Config #############################################################

service_data_record_file="service_data_record_file.csv"
service_router_data_record_file="service_router_data_record_file.csv"
service_procdure_record_file='service_procdure_record_file.csv'
service_procdure_router_record_file='service_procdure_router_record_file.csv'

service_input_file_path = f'{system_path}/migration/data/custom/metis/transformed_records/M2M_Service_Files/'

service_history_file_path = f'{system_path}/migration/src/ingestion/metis/service_migration/history'

goup_router_file_path = f'{system_path}/migration/data/custom/metis/transformed_records/Goup_Asset_Files/'


router_spdp_file_prefix = 'migration_goup_service_plan'


goup_error_file_name = 'router_error_file'
goup_insertion_error_file_name = 'assets_router_insertion_error'


asset_mapping_file_prefix = 'migration_goup_assets'


router_error_file_name = 'router_error_file'
router_insertion_error_file_name = 'assets_router_insertion_error'