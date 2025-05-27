### database details
meta_db_configs = {
    "HOST": "192.168.1.122",
    "USER": "python_dev",
    "DATABASE": "maxis_dev",
    "PASSWORD": "Python@123",
    "PORT": "3306"
}



remoteFilePath ={
'remote_file_path' : '/home/nimish/Downloads/geo_fence'
}

remoteFilePathHistory ={
'remote_file_path' : '/home/nimish/Downloads/geo_fence/History'
}

remoteFilePathNotifications = {
'remote_file_path_notifications' : '/home/nimish/Downloads/geo_fence/notifications'
}

remoteFilePathNotificationsHistory = {
'remote_file_path_notificationsHistory' : '/home/nimish/Downloads/geo_fence/notifications/History'
}




validate_api_user = {

"validate_api_user_url" : "https://192.168.1.227:8010/api/validate/user",
"username": "gtadmin",
"password": "Gtadmin@123"

}

api_details = {
    "bulk-assign-unassign" : "https://192.168.1.227:8010/api/tags/bulk-assign-unassign",
    "addRule" : "https://192.168.1.227:8010/api/add/rule",
    "createTag" : "https://192.168.1.227:8010/api/create/tag",
    "createLbszone" : "https://192.168.1.227:8010/api/create/lbszone/"
}





# crweate tag and tag assign payload..
TagEntityType = 6
colorCoding  = "#4e7894"


## geo fence Rule engine
rule_category_id = 25
rule_erval_unit = 4
rule_erval = 30
rule_description = "geoFenceMigration"
all_devices = 0
default_condition_id = 44
parameter_id = 28
comparator_id =0
condition_id =  28
occurrence_count = 1
erval_unit = 2
erval_value = 1
action_type_id = 1
## Please consider the format "YYYY-MM-DD HH:MM:SS"
geofenceRuleEngineStartDateTime = "2024-03-10 00:00:00"
changed_service_plane_id = 0
changed_coverage_id =  0
changed_device_plane_id = 0










logs = {
    "logs" : "geofence_data_log_info.log",
    "error" : "geofence_data_log_error.log"
}

error_directory = "/home/MIGRATION_SCRIPTS/ERROR_DIRECTORY"