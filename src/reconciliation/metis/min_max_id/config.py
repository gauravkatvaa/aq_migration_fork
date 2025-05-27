
# Database configuration


database_tables_dict = {
        #thisdb is aircontrol_db
        "maxis_dev_mg": ['assets_extended', 'assets', 'apn_ip_mapping', 'Service_Apn_ip', 'sim_provisioned_range_details', 'sim_provisioned_ranges_level1', 'sim_provisioned_ranges_level2','sim_provisioned_ranges_level3', 'sim_provisioned_ranges_level4', 'sim_provisioned_ranges_level5','sim_provisioned_ranges_level6', 'service_plan',
                   'device_rate_plan', 'accounts', 'contact_info', 'account_extended', 'account_goup_mappings', 'zones','zone_to_country', 'role_access', 'role_to_screen_mapping', 'role_to_tab_mapping','price_model_rate_plan', 'price_to_model_type', 'pricing_categories', 'whole_sale_rate_plan','whole_sale_to_pricing_categories', 'users', 'user_extended_accounts', 'user_details','migration_account_extended','migration_account_goup_mappings' ,'migration_accounts' ,'migration_assest_id' ,'migration_assets' ,'migration_assets_extended' ,'migration_contact_info','migration_device_rate_plan','migration_device_rate_plan_error_history','migration_price_model_rate_plan','migration_price_to_model_type','migration_pricing_categories' ,'migration_role_access','migration_role_to_screen_mapping','migration_role_to_tab_mapping','migration_service_apn_details' ,'migration_service_apn_details_error_history','migration_service_apn_ip','migration_service_apn_ip_error_history','migration_service_plan','migration_sim_provisioned_range_details','migration_sim_provisioned_range_details_error_datails','migration_sim_provisioned_range_details_error_history','migration_sim_provisioned_ranges_level5',
                         'migration_tracking_history','migration_user_details','migration_user_extended_accounts' ,'migration_users','migration_users_dummy','migration_whole_sale_rate_plan','migration_whole_sale_to_pricing_categories','migration_zone_to_country','migration_zones'
                         ],
       #  ##this db is for cdr (usages)
        "maxis_dev_cdr": ["cdr_sms_details_daily","cdr_voice_details_daily","cdr_data_details_daily"],
        "cmp_maxis_interface_thirdparty_migration":['service_plan','device_plan','apn'],
        "development_goup_router_maxis_mgr":['sim_home_identifiers','sim_donor_identfiers','sim_map '],


    }

db_config = {
    "HOST": "10.235.55.177",
    "USER": "maxisdb",
    "PASSWORD": "Airlinq@123",
    "DATABASE": "maxis_migration",
    "PORT": 3306,
    "Table_name":"migration_maxid_auditing",
}

###################################################################config_error_collection##################################################

database_error_dict={

    "maxis_dev_mg": ['migration_accounts_error_history','migration_accounts_extended_error_history','migration_assets_error_history','migration_assets_extended_error_history','migration_device_rate_plan_error_history','migration_service_apn_details_error_history','migration_service_apn_ip_error_history','migration_service_plan_error_history','migration_service_plan_to_service_type_error_history','migration_sim_provisioned_range_details_error_datails','migration_sim_provisioned_range_details_error_history',
                     'sim_provisioned_range_to_account_level1_error_history','sim_provisioned_range_to_account_level2_error_history'
'           sim_provisioned_range_to_account_level4_error_history','sim_provisioned_ranges_level1_error_history','sim_provisioned_ranges_level2_error_history','sim_provisioned_ranges_level3_error_history','sim_provisioned_ranges_level4_error_history'],
    "cmp_maxis_interface_thirdparty_migration":['migration_accounts_error_history','migration_service_error_history'],
    # "development_goup_router_maxis_mgr":['sim_home_identifiers','sim_donor_identfiers','sim_map '],

}
###changes your path
m2m_company_error_directory1="/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Company_Table_Migration/Insertion_Error/"
m2m_company_error_directory2="/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Company_Table_Migration/Procedure_Error_Company/"
m2m_company_error_directory3="/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Company_Table_Migration/Procedure_Error_Goup/"

m2m_service_error_directory1 = "/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Service_Table_Migration/Insertion_Error/"
m2m_service_error_directory2 = "/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Service_Table_Migration/Procedure_Error_Aircontrol/"
m2m_service_error_directory3 = "/home/yogesh/Documents/influx_db/maxis_migration/Migration_Scripts/M2M_Service_Table_Migration/Procedure_Error_Router/"

##input_directory
input_directories = [m2m_service_error_directory1,m2m_service_error_directory2,m2m_service_error_directory3,m2m_company_error_directory1,m2m_company_error_directory2,m2m_company_error_directory3]

history_file_path = '/home/yogesh/Documents/influx_db/maxis_migration/history'
error_directory = "/home/yogesh/Documents/influx_db/maxis_migration/ERROR_DIRECTORY"

####offset
offset=5



logs = {
    "migration_info_logger":"min_max_id_info_logger.log",
    "migration_error_logger":"min_max_id_error_logger.log"
}
