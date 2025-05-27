
# Database configuration


database_tables_dict = {
        #thisdb is aircontrol_db
        "maxis_dev_mg": ['assets_extended', 'assets', 'apn_ip_mapping', 'Service_Apn_ip', 'sim_provisioned_range_details', 'sim_provisioned_ranges_level1', 'sim_provisioned_ranges_level2',
                   'sim_provisioned_ranges_level3', 'sim_provisioned_ranges_level4', 'sim_provisioned_ranges_level5',
                   'sim_provisioned_ranges_level6', 'sim_provisioned_ranges_level7',
                   'sim_provisioned_range_to_account_level1', 'sim_provisioned_range_to_account_level2',
                   'sim_provisioned_range_to_account_level3', 'sim_provisioned_range_to_account_level4',
                   'sim_provisioned_range_to_account_level5', 'sim_provisioned_range_to_account_level6',
                   'sim_provisioned_range_to_account_level7', 'service_plan_to_service_type', 'service_plan',
                   'device_rate_plan', 'accounts', 'contact_info', 'account_extended', 'account_goup_mappings', 'zones',
                   'zone_to_country', 'role_access', 'role_to_screen_mapping', 'role_to_tab_mapping',
                   'price_model_rate_plan', 'price_to_model_type', 'pricing_categories', 'whole_sale_rate_plan',
                   'whole_sale_to_pricing_categories', 'users', 'user_extended_accounts', 'user_details','migration_account_extended'
                   , 'migration_account_goup_mappings' , 'migration_accounts' , 'migration_accounts_error_history', 'migration_accounts_extended_error_history'
                   , 'migration_accounts_new' , 'migration_assest_id' , 'migration_assets' , 'migration_assets_error_history', 'migration_assets_extended' , 'migration_assets_extended_error_history' , 'migration_contact_info', 'migration_device_rate_plan', 'migration_device_rate_plan_error_history', 'migration_price_model_rate_plan'
                   , 'migration_price_to_model_type', 'migration_pricing_categories' , 'migration_role_access', 'migration_role_to_screen_mapping', 'migration_role_to_tab_mapping', 'migration_service_apn_details' , 'migration_service_apn_details_error_history', 'migration_service_apn_ip', 'migration_service_apn_ip_error_history'
                   , 'migration_service_plan', 'migration_service_plan_error_history', 'migration_service_plan_to_service_type' , 'migration_service_plan_to_service_type_error_history', 'migration_service_type', 'migration_sim_provisioned_range_details'
                   , 'migration_sim_provisioned_range_details_error_datails', 'migration_sim_provisioned_range_details_error_history', 'migration_sim_provisioned_range_to_account_level1', 'migration_sim_provisioned_range_to_account_level2'
                   , 'migration_sim_provisioned_range_to_account_level3', 'migration_sim_provisioned_range_to_account_level4'
                   , 'migration_sim_provisioned_ranges_level1', 'migration_sim_provisioned_ranges_level2'
                   , 'migration_sim_provisioned_ranges_level3', 'migration_sim_provisioned_ranges_level4', 'migration_sim_provisioned_ranges_level5', 'migration_sim_provisioned_ranges_level6', 'migration_tables_max_id', 'migration_tracking_history', 'migration_user_details', 'migration_user_extended_accounts' , 'migration_users', 'migration_users_dummy', 'migration_whole_sale_rate_plan', 'migration_whole_sale_to_pricing_categories', 'migration_zone_to_country', 'migration_zones'
                         ],
        ##this db is for cdr (usages)
        #"cdr": [],
        "maxis_migration":["ecmp_service_status",'pic_user','ecmp_m2m_company'],
        "cmp_maxis_interface_thirdparty_migration":['service_plan','device_plan','apn'],
       # "cmp_maxis_interface_migration":['sim_home_identifiers','sim_donor_identfiers','sim_map '],
    

    }

db_config = {
    "HOST": "10.235.55.177",
    "USER": "maxisdb",
    "PASSWORD": "Airlinq@123",
    "DATABASE": "maxis_dev_mg",
    "PORT": 3306,
}