

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
    "apn creation": "Apn",
    "Cost_Center": "CostCenter",
    "Cost_Center Customer": "CostCenter",
    "life_cycles": "life_cycle",    
    'Users': "User"
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