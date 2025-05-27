import sys

# # Add the parent directory to sys.path
sys.path.append("..")


from conf.custom.ares.config import *
from src.utils.library import *
today = datetime.now()
curr_date = today.strftime("%Y%m%d")



current_date_time_str_logs = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"ares_rule_transformation_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"ares_rule_transformation_error_{current_date_time_str_logs}.log"
}

logs_path = f'{logs_path}/{transformation_log_dir}'
dir_path = dirname(abspath(__file__))

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

action_mapping = {
    'TRIGGER_ITEM_ACTION.SUSPEND_SIM':1,
    'TRIGGER_ITEM_ACTION.SEND_MAIL':2,
    'TRIGGER_ITEM_ACTION.CHANGE_SP':6,
    'TRIGGER_ITEM_ACTION.CHANGE_SP_FOR_GROUP':4,
    'TRIGGER_ITEM_ACTION.SEND_SMS':8
}

in_category_mapping = {
    'TRIGGER_TYPE.SIM_LIFECYCLE':'SIMlifecycle',
    'TRIGGER_TYPE.FRAUD_PREVENTION' : 'FraudPrevention',
    'TRIGGER_TYPE.COST_CONTROL': 'CostControl',
    'TRIGGER_TYPE.OTHERS':'Others'
}

rule_access_mapping = {
    (1, 1): 'RW',
    (0, 1): 'R',
    (0, 0): ''
}

# {TRIGGER}{AGGREGATION_LEVEL_MATCHING}{MATCHING_CONDITION}{SERVICE_PROFILE}

# OVER > 10MB // {TRIGGER} // {TRIGGER_LEVEL} // {MATCHING_CONDITION} // {SERVICE_PROFILE}

message_replacements = {
    'AGGREGATION_LEVEL_MATCHING': 'Aggregation Level',
    'TRIGGER': '##rule_category##',
    'TRIGGER_LEVEL': 'Application Level',
    'SERVICE_PROFILE': '##Device_Plan##',
    'MATCHING_CONDITION':''
}


# Function to replace placeholders in the specified columns
def replace_message_in_columns(row, columns):
    for column in columns:
        message = row[column]
        
        if message:  
            for pattern, replacement in message_replacements.items():
                # Perform case-insensitive replacement for all cases of the pattern
                message = re.sub(r'\{' + pattern + r'\}', replacement, message, flags=re.IGNORECASE)
        
        row[column] = message
    return row


def rule_trigger_transformation():
    """
    Transform validated trigger data for ingestion into the target system.
    This function reads from the validation database and prepares data for the transformation database.
    """
    try:
        # truncate transformation trigger_success table in transformation layer
        truncate_mysql_table(transformation_db_configs, 'trigger_success', logger_error)

        # Read data from validation layer
        trigger_df = read_table_as_df('trigger_success', validation_db_configs, logger_info, logger_error)
        
        # Check if the dataframe is empty
        if trigger_df.empty:
            logger_info.info("No data found in trigger_success table")
            return

        # Process message fields
        columns_to_process = ['T_IAS_SMS_MESSAGE', 'T_IAS_MAIL_MESSAGE', 'T_IAS_MAIL_SUBJECT']
        trigger_df = trigger_df.apply(lambda row: replace_message_in_columns(row, columns_to_process), axis=1)
        
        # Initialize target dataframe
        df_target = pd.DataFrame()

        # Handle missing values
        trigger_df['CRMEC_ID'] = trigger_df['CRMEC_ID'].replace('', pd.NA)
        trigger_df['CRMBU_ID'] = trigger_df['CRMBU_ID'].replace('', pd.NA)
        trigger_df['CRMCC_ID'] = trigger_df['CRMCC_ID'].replace('', pd.NA)

        # Map fields from source to target
        df_target['rule_name'] = trigger_df['NAME']
        
        # Account ID hierarchical mapping
        df_target['accountId'] = np.where(
            trigger_df['CRMCC_ID'].notna(),  # First check CRMCC_ID
            trigger_df['CRMCC_ID'],
            np.where(
                trigger_df['CRMBU_ID'].notna(),  # Then check CRMBU_ID
                trigger_df['CRMBU_ID'],
                trigger_df['CRMEC_ID']  # Finally use CRMEC_ID
            )
        )

        # Initialize rule category
        df_target['rule_category_id'] = ''
        df_target['user_id'] = trigger_df['CREATED_BY'].astype(str)  # Use CREATED_BY as user_id

        # Convert activation date with multiple formats
        df_target['start_time'] = pd.to_datetime(trigger_df['ACTIVATION_DATE'], 
                                               format='%d-%b-%y', errors='coerce')
        
        # Try second format if first one fails
        mask = df_target['start_time'].isna()
        df_target.loc[mask, 'start_time'] = pd.to_datetime(
            trigger_df.loc[mask, 'ACTIVATION_DATE'], 
            format='%Y-%m-%d %H:%M:%S.%f', 
            errors='coerce'
        )

        # Rule description logic
        df_target['rule_description'] = np.where(
            trigger_df['DESCRIPTION'].str.strip().fillna('') == '',  # If description is empty
            np.where(
                trigger_df['T_IC_TP_SIM_IN_SP_CONDITION'].str.strip().fillna('') == '',  # And condition is empty
                trigger_df['NAME'],  # Use name
                trigger_df['T_IC_TP_SIM_IN_SP_CONDITION']  # Otherwise use condition
            ),
            trigger_df['DESCRIPTION']  # Use description if available
        )

        # IMSI and device level settings
        df_target['imsi_from'] = trigger_df.apply(
            lambda row: row['IMSI'] if row['LEVEL_TYPE'] == 'TRIGGER_LEVEL.SIM' else '', 
            axis=1
        )
        
        df_target['all_devices'] = trigger_df.apply(
            lambda row: '0' if row['LEVEL_TYPE'] == 'TRIGGER_LEVEL.SIM' else '1', 
            axis=1
        )
        
        # Application level
        df_target['in_application_level'] = trigger_df['LEVEL_TYPE']
        
        # Action mappings
        action_mapping = {
            'TRIGGER_ITEM_ACTION.SUSPEND_SIM': '1',
            'TRIGGER_ITEM_ACTION.SEND_MAIL': '2',
            'TRIGGER_ITEM_ACTION.CHANGE_SP': '3',
            'TRIGGER_ITEM_ACTION.SEND_SMS': '4',
            'TRIGGER_ITEM_ACTION.CHANGE_SP_FOR_GROUP': '5',
            '17455': '1'  # Mapping for numeric code
        }
        
        df_target['action_type_id'] = trigger_df['ACTION_TYPE'].apply(
            lambda x: action_mapping.get(x, x)
        )
        
        # Contact information
        df_target['action_email_id'] = trigger_df['T_IAS_MAIL_ADDRESS']
        df_target['action_contact_number'] = trigger_df['T_IAS_SMS_PHONE']
        
        # State change based on action type
        df_target['state_change'] = trigger_df['ACTION_TYPE'].apply(
            lambda x: 'Suspended' if str(x) in ['TRIGGER_ITEM_ACTION.SUSPEND_SIM', '17455'] else ''
        )

        # Device plan changes
        df_target['changed_device_plan_id'] = np.where(
            (trigger_df['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.CHANGE_SP') & 
            (trigger_df['T_IA_CSP_NEW_SP_CONTEXT'].notna()), 
            trigger_df['T_IA_CSP_NEW_SP_CONTEXT'], 
            np.where(
                (trigger_df['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP') & 
                (trigger_df['T_IA_CSP_4G_NEW_SP_CONTEXT'].notna()), 
                trigger_df['T_IA_CSP_4G_NEW_SP_CONTEXT'], 
                ''
            )
        )
        
        # Webhook metadata
        df_target['webhook_metadata'] = trigger_df['ACTION_TYPE']
        df_target['in_reset_period'] = ''
        
        # Category mapping
        in_category_mapping = {
            'TRIGGER_TYPE.SIM_LIFECYCLE': 'SimLifecycle',
            'TRIGGER_TYPE.FRAUD_PREVENTION': 'FraudPrevention',
            'TRIGGER_TYPE.COST_CONTROL': 'CostControl',
            'TRIGGER_TYPE.OTHERS': 'Others'
        }
        
        df_target['in_category'] = trigger_df['T_TYPE'].apply(
            lambda x: in_category_mapping.get(x, x)
        )
        
        # Rule access mapping
        rule_access_mapping = {
            ('1', '1'): 'RW',  # editable=1, visible=1
            ('0', '1'): 'RO',  # editable=0, visible=1
            ('0', '0'): 'NA',  # editable=0, visible=0
            ('1', '0'): 'RW'   # editable=1, visible=0 (fallback)
        }
        
        df_target['in_rule_access'] = trigger_df.apply(
            lambda row: rule_access_mapping.get((str(row['EDITABLE']), str(row['VISIBLE'])), ''),
            axis=1
        )
        
        df_target['in_sim_next_bill_cycle_change'] = ''
        
        # Device update flags
        df_target['in_device_update_in_next_bill_cycle'] = (
            (
                (trigger_df['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE') &
                (trigger_df['T_IA_CSP_SP_IN_NNBC'].notna() & (trigger_df['T_IA_CSP_SP_IN_NNBC'] != ''))
            ) |
            (
                (trigger_df['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE_FOR_GROUP') &
                (trigger_df['T_IA_CSP_4G_SP_IN_NBC'].notna() & (trigger_df['T_IA_CSP_4G_SP_IN_NBC'] != ''))
            )
        ).astype(int)
        
        # Next bill cycle change ID
        df_target['in_device_next_bill_cycle_change_id'] = np.where(
            (trigger_df['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE') & 
            (trigger_df['T_IA_CSP_SP_IN_NNBC'].notna()), 
            trigger_df['T_IA_CSP_SP_IN_NNBC'], 
            np.where(
                (trigger_df['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE_FOR_GROUP') & 
                (trigger_df['T_IA_CSP_4G_SP_IN_NBC'].notna()), 
                trigger_df['T_IA_CSP_4G_SP_IN_NBC'], 
                ''
            )
        )
        
        # Creation date
        df_target['create_date'] = trigger_df['CREATION_DATE']
        df_target['is_active'] = trigger_df['ACTIVE'].astype(str)
        
        # Copy over condition and attribute fields
        attributes_to_copy = [
            'CONDITION_TYPE', 'T_IAA_C_TP_FA_DATA', 'T_IAA_COND_TP_FA_SMS', 
            'T_IAA_C_TP_FA_VOICE', 'T_IC_POINT_IN_TIME_TIME', 'T_IC_CT_SP_CONTEXT',
            'T_IC_VT_SP_CONTEXT', 'T_IC_TP_SIM_IN_SP_SP_CONTEXT', 
            'T_IC_TP_SIM_IN_SP_NO_OF_DAYS', 'T_IC_TP_FACTIVITY_NO_DAYS',
            'T_IC_SP_CHANGE_SP_CONTEXT', 'T_IC_COOC_SP_CONTEXT', 
            'T_IC_COOC_CHANGE_TYPE', 'T_IAA_MAIL_TEMPLATE', 'T_IAA_SMS_TEMPLATE'
        ]
        
        for col in attributes_to_copy:
            if col in trigger_df.columns:
                df_target[col] = trigger_df[col]
        
        # Handle notification templates
        df_target['T_IAA_MAIL_DEFINITION'] = trigger_df.apply(
            lambda row: 'EMAIL' if 'T_IAA_MAIL_DEFINITION' in row and row['T_IAA_MAIL_DEFINITION'] == 'Mail Template' else None,
            axis=1
        )
        
        df_target['T_IAS_MAIL_MESSAGE'] = trigger_df['T_IAS_MAIL_MESSAGE'] if 'T_IAS_MAIL_MESSAGE' in trigger_df.columns else ''
        df_target['T_IAS_MAIL_SUBJECT'] = trigger_df['T_IAS_MAIL_SUBJECT'] if 'T_IAS_MAIL_SUBJECT' in trigger_df.columns else ''
        
        df_target['T_IAA_SMS_DEFINITION'] = trigger_df.apply(
            lambda row: 'SMS' if 'T_IAA_SMS_DEFINITION' in row and row['T_IAA_SMS_DEFINITION'] == 'SMS Template' else None,
            axis=1
        )
        
        df_target['T_IAS_SMS_MESSAGE'] = trigger_df['T_IAS_SMS_MESSAGE'] if 'T_IAS_SMS_MESSAGE' in trigger_df.columns else ''
        
        # Save to CSV and insert into database
        df_target.to_csv('trigger_transform.csv', index=False)
        insert_batches_df_into_mysql(df_target, transformation_db_configs, 'trigger_success', logger_info, logger_error)
        
        logger_info.info(f"Successfully transformed {len(df_target)} trigger records")
        
    except Exception as e:
        logger_error.error(f"Error While Trigger Transformation: {e}")
        print(f"Error While Trigger Transformation: {e}")



def update_language(account_id,bu_language_dict,ec_language_dict):
    if account_id in bu_language_dict:
        return bu_language_dict[account_id]
    elif account_id in ec_language_dict:
        return ec_language_dict[account_id]
    else:
        return None


def notification_template_transform():

    try:
        # truncate transformation trigger_success table in transformation layer
        truncate_mysql_table(transformation_db_configs, 'notifications_success', logger_error)
        notification_df = read_table_as_df('notifications_success', validation_db_configs, logger_info, logger_error)
        
        if notification_df.empty:
            print("No data found in notifications_success table")
            logger_info.info("No data found in notifications_success table")
            return

        query_get_language_ec=f"select CRM_ID, PREFERRED_LANGUAGE from ec_success"
        ec_language_dict = create_iso_code_id_dict(query_get_language_ec, validation_db_configs, logger_error)

        # notification_df.apply(lambda row: 'EMAIL' if row['TYPE'] == 'Mail Template' else ('SMS' if row['TYPE'] == 'Bulk SMS template' else None), axis=1)
        query_get_language_bu=f"select BUCRM_ID, PREFERRED_LANGUAGE from bu_success"
        bu_language_dict = create_iso_code_id_dict(query_get_language_bu, validation_db_configs, logger_error)
        
        columns_to_process = ['TEXT', 'SUBJECT']

        notification_df = notification_df.apply(lambda row: replace_message_in_columns(row, columns_to_process), axis=1)
        df_target = pd.DataFrame()

        df_target['id'] = notification_df['ID']
        df_target['templateName'] = notification_df['NAME']
        df_target['notificationType'] = notification_df.apply(lambda row: 'EMAIL' if row['TYPE'] == 'Mail Template' else ('SMS' if row['TYPE'] == 'Bulk SMS template' else None), axis=1)
        
        notification_df['BU_ID'] = notification_df['BU_ID'].replace('', pd.NA)
        df_target['accountId'] = notification_df['BU_ID'].fillna(notification_df['CUSTOMER_ID'])

        df_target['language'] =  df_target['accountId'].apply(lambda x: update_language(x, bu_language_dict, ec_language_dict))
        df_target['subject'] = notification_df.apply(lambda row: row['SUBJECT'] if row['TYPE'] == 'Mail Template' else '', axis=1)
        
        df_target['message'] = notification_df['TEXT']
        df_target['description'] = notification_df['TEMPLATE_DESCRIPTION']
        df_target['category'] = notification_df['SMS_TYPE']

        df_target.to_csv('notification_transform.csv',index=False)
        print('notification transform csv created')
        print(f'notification csv data: {df_target}')
        logger_info.info(f'notification csv data: {df_target}')
        insert_batches_df_into_mysql(df_target, transformation_db_configs, 'notifications_success', logger_info, logger_error)
        print('notification data inserted into mysql transfomation db notifications_success table')
        logger_info.info(f'notification data inserted into mysql transfomation db notifications_success table')

    except Exception as e:
        print("Error While Notification Template Transformation : {}".format(e))
        logger_error.error("Error While Notification Template Transformation : {}".format(e))


if __name__ == "__main__":
    for arg in sys.argv[1:]:
        if arg == "trigger":
            rule_trigger_transformation()

        if arg == "notification":
            notification_template_transform()