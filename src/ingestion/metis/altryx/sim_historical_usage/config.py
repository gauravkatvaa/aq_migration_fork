local_csv_file_path = {
    "csv_file_path": "/home/MIGRATION_SCRIPTS/altryx/testing_files/historical_usage/input/",
    "error_csv_file_path": "/home/MIGRATION_SCRIPTS/altryx/testing_files/historical_usage/error/",
    "csv_file_path_history": "/home/MIGRATION_SCRIPTS/altryx/testing_files/historical_usage/history/",
    "success_csv_file_path": "/home/MIGRATION_SCRIPTS/altryx/testing_files/historical_usage/success/",
    "batches_csv_files": "/home/MIGRATION_SCRIPTS/altryx/testing_files/historical_usage/batches_csv_files/"
}


meta_db_config = {
    "host": "10.235.55.177",
    "user": "maxisdb",
    "password": "Airlinq@123",
    "port": 3306,
    "database": "maxis_dev_cdr"
}

batch_size = {
    "batch_size": 50000
}

#stored_procedures = {
#    "weekly": "call gcontrol_cdr_data_aggregation_weekly();",
#    "monthly": "call gcontrol_cdr_data_aggregation_monthly();"
#}

#batch_size_limits = {
#    "batch_size_weekly": 4,
#    "batch_size_monthly": 8
#}

#procedures = {
#    "weekly": "gcontrol_cdr_data_aggregation_weekly",
#    "monthly": "gcontrol_cdr_data_aggregation_monthly"
#}

error_directory = "/home/MIGRATION_SCRIPTS/ERROR_DIRECTORY"