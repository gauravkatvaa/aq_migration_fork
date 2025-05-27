import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.utils_lib import *


######################### EC Rules  ######################################################################################################   
   
ec_checks = [
                        ("CRM_ID", lambda x: x.isnumeric(), "108"),
                        ("OPCO_CRM_ID", lambda x: is_alphanumeric(x), "109"),
                        ("ACTIVATION_STATUS", lambda x: check_enum(x, allowed_values=['Live','Test']), "113"),
                        ("EC_NAME", lambda x: check_length(x, 50), "114")
                        
]

ec_required_columns = ['EC_NAME','CRM_ID','OPCO_CRM_ID', 'ACTIVATION_STATUS']

ec_missing_value_mapper = {
    'EC_NAME' : '101',
    'CRM_ID' : '102',
    'OPCO_CRM_ID' : '103',
    'ACTIVATION_STATUS' : '105',
}

######################################### BU Rules  #######################################################################################   

bu_checks = [
                        ("BUCRM_ID", lambda x: x.isnumeric(), "109"),
                        ("EC_CRM_ID", lambda x: x.isnumeric(), "110"),
                        ("BU_NAME",lambda x: check_length(x, 50), "111"),
                        ("BILLING_CYCLE_ID", lambda x: is_alphanumeric(x), "113"),
                        ("ACTIVATION_STATUS", lambda x: check_enum(x, allowed_values=['Live','Test']), "115"),
                        ("CURRENCY", lambda x: check_enum(x, allowed_values=['USD','EUR','CHF']), "112")
                    ]


bu_required_columns = ['BUCRM_ID','EC_CRM_ID', 'BU_NAME',
                                        'BILLING_CYCLE_ID','CURRENCY','ACTIVATION_STATUS']

bu_missing_value_mapper = {
    'BUCRM_ID' : '101',
    'EC_CRM_ID' : '102',
    'BU_NAME' : '103',
    'BILLING_CYCLE_ID' : '105',
    'CURRENCY' : '107',
    'ACTIVATION_STATUS':'108'
}

# This value cannot be missing
# Should be of type Int
# The value should be one of the following:

#     50, 51, 52, 70, 72, 74, 1, 37, 38, 39, 40, 41, 42, 43, 44, 45, 49, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 71, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83

######################################### USER Rules  #######################################################################################   



user_checks = [
                        ("FIRST_NAME", lambda x: is_alphanumeric(x), "108"),
                        ("LAST_NAME", lambda x: is_alphanumeric(x), "109"),
                        ("PHONE_NUMBER", lambda x: is_valid_phone_number(x), "110"),
                        ("EMAIL", lambda x: validate_email(x), "111"),
                        ("CRM_RESELLER_ID", lambda x: x.isnumeric(), "112"),
                        ("CRM_CUSTOMER_ID", lambda x: x.isnumeric(), "113"),
                        ("CRM_BU_ID", lambda x: x.isnumeric(), "114"),
                        ("LOGIN", lambda x: is_alphanumeric(x), "115"),
                    ]


user_required_columns = ['FIRST_NAME','LAST_NAME', 'PHONE_NUMBER', 'EMAIL','LOGIN']

user_missing_value_mapper = {
    'FIRST_NAME' : '101',
    'LAST_NAME' : '102',
    'PHONE_NUMBER' : '103',
    'EMAIL' : '104',
    'LOGIN':'107'
}

############################################## COST CENTER Rules ##############################################################################

cost_center_checks = [
                        ("STATUSNAME", lambda x: check_enum(x, allowed_values=['COST_CENTER_STATUS.ACTIVE','COST_CENTER_STATUS.TERMINATED','COST_CENTER_STATUS.CANCELLED','COST_CENTER_STATUS.PENDING_MODIFICATION','COST_CENTER_STATUS.PENDING_TERMINATION']), "106")
]

cost_center_required_columns = ['STATUSNAME','CC_NAME','CCCRM_ID'] #,'COMPANYADDRESS'


cc_missing_value_mapper = {
    'STATUSNAME' : '101',
    'CC_NAME' : '102',
    'CCCRM_ID' : '103',
}

############################################## APN Rules ######################################################################################

apn_checks = [
    ("APN", lambda x: is_alphanumeric(x), "105"),
    ("APN_ID", lambda x: x.isnumeric(), "106"),
    ("IP_ASSIGNMENT",lambda x: check_enum(x, allowed_values=['dynamic','static']), "107"),
    ("TYPE",lambda x: check_enum(x, allowed_values=['IPv4','IPv6','IPv4 and IPv6']), "108"),
    ("IP_POOL", lambda x: is_valid_subnet(x), "109")
]


def is_valid_subnet(subnet_str):
    """
    Validates if the input string contains valid IPv4 or IPv6 subnet(s) with CIDR notation.
    
    Args:
        subnet_str: String containing one or more subnets potentially separated by
                   commas, spaces, or newlines
    
    Returns:
        bool: True if all subnets are valid, False otherwise
    """
    if not subnet_str or not isinstance(subnet_str, str):
        return False
    
    # Split the string by common delimiters (commas, newlines, spaces)
    subnets = re.split(r'[,\n\s]+', subnet_str.strip())
    
    # Remove empty strings that might result from splitting
    subnets = [s for s in subnets if s]
    
    if not subnets:
        return False
    
    # Check each subnet
    for subnet in subnets:
        # Explicitly check for CIDR notation (must contain '/')
        if '/' not in subnet:
            return False
            
        try:
            # Try to create an IPv4Network or IPv6Network object
            ipaddress.ip_network(subnet, strict=False)
        except ValueError:
            # If the creation fails, the subnet is invalid
            return False
    
    return True

apn_required_columns = ['APN','APN_ID','IP_ASSIGNMENT','TYPE']

apn_missing_value_mapper = {
    'APN':'101',
    'APN_ID' : '102',
    'IP_ASSIGNMENT' : '103',
    'IPvX' : '104'
}


############################################## Assets Rules ###################################################################################

asset_checks = [
    ('ICCID',lambda x: x.isnumeric(), "111"),
    ('IMEI',lambda x: x.isnumeric(), "112"),
    ('IMSI',lambda x: x.isnumeric(), "113"),
    ('MSISDN',lambda x: x.isnumeric(), "114"),
    ("SIM_STATUS",lambda x: check_enum(x, allowed_values=['A','S','4','5']), "115"),
    ('OPCO_ID',lambda x: x.isnumeric(), "116"),
    ('BU_ID',lambda x: x.isnumeric(), "117"),
    ('EXPECTED_IMEI',lambda x: x.isnumeric(), "118"),
    # ('CREATIONDATE',lambda x: validate_date(x),"119"),
    # ('ACTIVEFROM',lambda x: validate_date(x),"120"),
    # ('LASTMODIFDATE',lambda x: validate_date(x),"121"),
    # ('SPMODIFDATE',lambda x: validate_date(x),"122"),
    ('IP_ADDRESS',lambda x: is_ip_address(x),"123"),
    ('ASSIGNED_IP_ADDR',lambda x: is_ip_address(x),"124"),
    ("FREE_TEXT", lambda x: check_length(x, 50), "125")
]

asset_required_columns = ['CREATIONDATE','ACTIVEFROM','ICCID','IMEI','IMSI','MSISDN','SIM_STATUS','OPCO_ID','BU_ID','EXPECTED_IMEI']
asset_missing_value_mapper = {
    'CREATIONDATE':'101',
    'ACTIVEFROM' : '102',
    'ICCID' : '103',
    'IMEI' : '104',
    'IMSI' : '105',
    'MSISDN' : '106',
    'SIM_STATUS' : '107',
    'OPCO_ID' : '108',
    'BU_ID' : '109',
    'EXPECTED_IMEI' : '110'
}


############################################# Rule Engine Trigger Rules #######################################################################

rule_trigger_checks = [
    ("NAME", lambda x: check_length(x, 50), "111"),
    ("CRMEC_ID", lambda x: x.isnumeric(), "112"),
    ("CONDITION_TYPE",lambda x: check_enum(x, allowed_values=['TRIGGER_ITEM_CONDITION.VOLUME_THRESHOLD','TRIGGER_ITEM_CONDITION.COST_THRESHOLD',
    'TRIGGER_ITEM_CONDITION.POINT_IN_TIME','TRIGGER_ITEM_CONDITION.INACTIVITY_PERIOD','TRIGGER_ITEM_CONDITION.SP_CHANGE','TRIGGER_ITEM_CONDITION.TIME_PERIOD',
    '17697','17242','17696','17241','18711','17695','17694']),"113"),
    # ('ACTIVATION_DATE',lambda x: validate_date(x),"114"),
    ("DESCRIPTION",lambda x: check_length(x, 50), "115"),
    ("LEVEL_TYPE",lambda x: check_enum(x, allowed_values=['TRIGGER_LEVEL.BU','TRIGGER_LEVEL.EC','TRIGGER_LEVEL.SIM','TRIGGER_LEVEL.CC']),"116"),
    ("ACTION_TYPE",lambda x: check_enum(x, allowed_values=['TRIGGER_ITEM_ACTION.SUSPEND_SIM','TRIGGER_ITEM_ACTION.SEND_MAIL',
    'TRIGGER_ITEM_ACTION.CHANGE_SP','TRIGGER_ITEM_ACTION.SEND_SMS','TRIGGER_ITEM_ACTION.CHANGE_SP_FOR_GROUP','17455']),"117"),
    ("T_TYPE",lambda x: check_enum(x, allowed_values=['TRIGGER_TYPE.SIM_LIFECYCLE','TRIGGER_TYPE.FRAUD_PREVENTION','TRIGGER_TYPE.COST_CONTROL','TRIGGER_TYPE.OTHERS']),"118"),
    ("ACTIVE",lambda x: check_enum(x, allowed_values=['0','1']), "119")
]

rule_trigger_required_columns = ['NAME','CRMEC_ID','CONDITION_TYPE','CREATED_BY','ACTIVATION_DATE','LEVEL_TYPE','ACTION_TYPE','T_TYPE','ACTIVE']

rule_trigger_missing_value_mapper = {
    'NAME':'101',
    'CRMEC_ID' : '102',
    'CONDITION_TYPE' : '103',
    'CREATED_BY' : '104',
    'ACTIVATION_DATE' : '105',
    'LEVEL_TYPE' : '107',
    'ACTION_TYPE' : '108',
    'T_TYPE' : '109',
    'ACTIVE' : '110'
}

rule_trigger_attr_checks = [
    ("ID", lambda x: x.isnumeric(), "103")
]
rule_trigger_attr_required_columns = ['TYPE','ID']
rule_trigger_attr_missing_value_mapper = {
    'TYPE':'101',
    'ID':'102'
}
############################################# Notification Template Rules #####################################################################

notification_template_checks = [
    ("NAME", lambda x: check_length(x, 50), "105"),
    ("TYPE", lambda x: check_enum(x, allowed_values=['Bulk SMS template','Mail Template']), "106"),
    ("CUSTOMER_ID", lambda x: x.isnumeric(), "107"),
    ("TEMPLATE_DESCRIPTION", lambda x: check_length(x, 500), "109")
]

notification_template_required_columns = ['NAME','TYPE']

notification_template_missing_value_mapper = {
    'NAME':'101',
    'TYPE' : '102',
}


############################################################## Label Rules ###################################################################################


label_creation_checks = [
    ("NAME", lambda x: check_length(x, 50), "104"),
    ("TEXT", lambda x: check_length(x, 50), "105"),
    ("BU_ID", lambda x: x.isnumeric(), "106")
]

label_creation_required_columns = ['NAME','TEXT']

label_creation_missing_value_mapper = {
    'NAME' : '101',
    'TEXT' : '102',
}

label_assignment_checks = [
    ("ICCID", lambda x: x.isnumeric(), "102")
]

label_assignment_required_columns = ['ICCID']

label_assignment_missing_value_mapper = {
    'ICCID' : '101'
}



############################################# Service Profile Rules ############################################################################

service_profiles_checks = [
    ("ID" ,lambda x: x.isnumeric(), "103"),
    ("TYPE", lambda x: check_enum(x, allowed_values=['Sleep','Live','Test']), "104"),
    ("ENABLED_FLAG",lambda x: check_enum(x, allowed_values=['Enabled','Disabled']), "105"),
]

## NAME

service_profiles_required_columns = ['ID','OWNING_LIFECYCLE_ID', 'BUNDLE']

service_profiles_missing_value_mapper = {
    'ID':'101',
    'OWNING_LIFECYCLE_ID':'102',
    'BUNDLE': '106',
}


############################################ Life Cycle #########################################################################################

life_cycles_checks = [
    ("ID" ,lambda x: x.isnumeric(), "104"),
    ("TYPE", lambda x: check_enum(x, allowed_values=['SIM Lifecycle']), "105"),
    ("ENABLE_FLAG",lambda x: check_enum(x, allowed_values=['Enabled','Disabled']), "106")
]

life_cycles_required_columns = ['ID','BU_ID','NAME']
life_cycles_missing_value_mapper = {
    'ID':'101',
    'BU_ID':'102',
    'NAME':'103'
}


######################################### Reports Subrcations   #######################################################################################   

report_checks = [
                        ("CRMEC_ID", lambda x: x.isnumeric(), "110"),
                        ("RECEPIENTS",lambda x: check_length(x, 50), "111"),
                        ("AGGREGATION_LEVEL", lambda x: check_enum(x, allowed_values=['Business Unit','Customer']), "112"),
                        ("MAIL_NOTIFICATION", lambda x: is_alphanumeric(x), "113"),
                        ("REPORT_DEF_NAME", lambda x: check_enum(x, allowed_values=['Usage per IMSI','SIM Report','CDR Export']), "115"),
                    ]


report_subscriptions_required_columns = ['REPORT_DEF_NAME','NAME', 'REPORT_TYPE_NAME',
                                        'FILE_TYPE','CRMEC_ID','MAIL_NOTIFICATION','AGGREGATION_LEVEL','RECEPIENTS']

report_subscriptions_missing_value_mapper = {
    'REPORT_DEF_NAME' : '101',
    'NAME' : '102',
    'REPORT_TYPE_NAME' : '103',
    'FILE_TYPE' : '104',
    'CRMEC_ID' : '105',
    'MAIL_NOTIFICATION':'106',
    'AGGREGATION_LEVEL':'107',
    'RECEPIENTS':'108'
}

# This value cannot be missing
# Should be of type Int
# The value should be one of the following:

#     50, 51, 52, 70, 72, 74, 1, 37, 38, 39, 40, 41, 42, 43, 44, 45, 49, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 71, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83

######################################### IP POOL   #######################################################################################   


# Define required columns
ip_pool_required_columns = ['ID', 'BU_ID', 'RANGE_START', 'RANGE_END']

# Define missing value mapper (error codes)
ip_pool_missing_value_mapper = {
    'ID': '101',           # IP Pool ID is missing
    'BU_ID': '102',        # BU_ID is missing
    'RANGE_START': '103',  # IP Range start is missing
    'RANGE_END': '104'     # IP Range end is missing
}

# Define validation checks
ip_pool_checks = [
    ('BU_ID', lambda x: x.isnumeric(), '105'),  # BU_ID must be numeric
    ('RANGE_START', lambda x: is_ip_address(x), '106'),  # RANGE_START must be a valid IP address
    ('RANGE_END', lambda x: is_ip_address(x), '107')     # RANGE_END must be a valid IP address
]

######################################### bu account to tp mapping #######################################################################################   


# Define required columns
bu_account_to_tp_required_columns = ['EXTERNALACCNUMBER', 'TARIFFPLAN_ID', 'CONTRACTEDFROM', 'CONTRACTEDTO']

# Define missing value mapper (error codes)
bu_account_to_tp_missing_value_mapper = {
    'EXTERNALACCNUMBER': '101',     # EXTERNALACCNUMBER is missing
    'TARIFFPLAN_ID': '102',         # TARIFFPLAN_ID is missing
    'CONTRACTEDFROM': '103',        # CONTRACTEDFROM is missing
    # 'CONTRACTEDTO': '104'           # CONTRACTEDTO is missing
}

bu_account_to_tp_checks = [
    ('EXTERNALACCNUMBER', lambda x: is_alphanumeric(x), '105'),  
    ('TARIFFPLAN_ID', lambda x: x.isnumeric(), '106')
      
]
######################################### dic bill cycle #######################################################################################   


# Define required columns
dic_bill_cycle_required_columns = ['ID', 'BCTYPE']

# Define missing value mapper (error codes)
dic_bill_cycle_missing_value_mapper = {
    'ID': '101',             # id is missing
    'BCTYPE': '102',         # BCTYPE is missing
   
}

dic_bill_cycle_checks = [
    ('id', lambda x: x.isnumeric(), '105') 
]

######################################### dic bill cycle #######################################################################################   

# Define required columns
combined_tariff_plan_required_columns = ['CUSTOMER', 'TARIFF_PLAN', 'RATING_ELEMENT']

# Define error codes
combined_tariff_plan_missing_value_mapper = {
    'CUSTOMER': '101',            # CUSTOMER is missing
    'TARIFF_PLAN': '102',         # TARIFF_PLAN is missing
    'RATING_ELEMENT': '103'       # RATING_ELEMENT is missing
}