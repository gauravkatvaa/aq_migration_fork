import sys

# # Add the parent directory to sys.path
sys.path.append("..")
from conf.custom.apollo.config import *
from src.utils.library import *
from src.utils.utils_lib import *
from conf.config import *
today = datetime.now()
import traceback
current_date_time_str_logs = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"stc_transformation_trigger_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"stc_transformation_trigger_error_{current_date_time_str_logs}.log"
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


application_level_mapping = {
    'All SIMS of Business Unit': 'BU',
    'SIM': 'SIM',
    'All SIMS of Cost Center': 'CC',
    'All SIMS of Customer': 'EC'
}
aggregation_level_mapping = {
    'SIM':'SIM',
    'Business unit':'BU'
}

in_category_mapping = {
    'SIM Lifecycle':'SIMlifecycle',
    'Fraud prevention' : 'FraudPrevention',
    'Cost control': 'CostControl',
    'Others':'Others'
}

inactive_unit = {
    'HOURS':1,
    'DAYS':2,
    'MONTHS':3
}

comparator_id = {
    'Higher than limit':1
}

# Define the mapping dictionary
rule_access_mapping = {
    (1, 1): 'RW',
    (0, 1): 'R',
    (0, 0): ''
}

action_mapping = {
    'Send E-mail':1,
    'Send SMS':2,
    'Change Service Profile':6,
    'Suspend SIM':4,
    'Raise an Alert in web GUI':8,
}

attribute_mapper = {
        'SERVICE_PROFILE': 281,
        'RULE': 196
    }

reset_period_mapper = {
    'Billing cycle' : 'Billingcycle',
    'Daily':'Daily',
    'Monthly':'Monthly',
    'Unlimited':'Unlimited',
    '6 months':'6months'
}

message_replacements = {
    'AGGREGATION_LEVEL_MATCHING': 'Aggregation Level',
    'TRIGGER': 'Trigger',
    'TRIGGER_LEVEL': 'Application Level'
}

# Columns to process
columns_to_process = ['Message', 'SMS Message']

# Function to replace placeholders in the specified columns
def replace_message_in_columns(row, columns):
    for column in columns:
        message = row[column]
        for pattern, col in message_replacements.items():
            message = re.sub(r'\{' + pattern + r'\}', row[col], message)
        row[column] = message
    return row


def calculate_dp_name(row):
    bundle_name = "Bundle SDV Ind" if "Individual" in row['BUNDLE'] else "Bundle SDV Pl"
    
    ak_value = (
        (bundle_name + (' - ' + row['DATA_SIZE'] if not row['DATA_SIZE'] in ('NA',None,'') else '') + 
        # (' ' + f"{str(row['SMS_SIZE'])}SMS" if row['SMS_SIZE'] not in ('NA', None, '', '0 SMS') else '') +
        (' ' + f"{str(row['SMS_SIZE'])} SMS"  if not row['SMS_SIZE'] in ('NA',None,'','0 SMS') else '')+
               (' - ' + str(row['TARIFF_PLAN_ID']) if not row['TARIFF_PLAN_ID'] in ('NA', None, '') else '')
        )+
        ((" - weekly" if "weekly" in row['BUNDLE'] else
          " - years" if "years" in row['BUNDLE'] else
          " - Yearly" if "Yearly" in row['BUNDLE'] else "")
         if any(x in row['BUNDLE'] for x in ["weekly", "years", "Yearly"]) else "") +
        ('-' + row['NBIOT_SIZE'] if row['NBIOT_SIZE'] not in ('NA', None, '', '0 MB', '0 MIN') else '-')
    ).strip()
    
    if "Voice" in row['BUNDLE']:
        am_value = (ak_value + "" + row['BUNDLE'][row['BUNDLE'].find("Voice") + len("Voice"):]).strip()
    else:
        am_value = ak_value
    
    if am_value.endswith('-'):
        am_value = am_value[:-1]
        
    return am_value

def trigger_transformation():
    trigger_df = pd.read_csv(f'{input_file_path}/TriggersDetails.csv',skipinitialspace=True,keep_default_na=False,dtype=str)
    trigger_df = trigger_df.apply(lambda row: replace_message_in_columns(row, columns_to_process), axis=1)
    trigger_df.loc[trigger_df['Mail Template Name'].str.strip() == '', 'Mail Template Name'] = trigger_df['Name']
    trigger_df.loc[trigger_df['SMS Template Name'].str.strip() == '', 'SMS Template Name'] = trigger_df['Name']
    trigger_df.loc[trigger_df['Description'].str.strip() == '', 'Description'] = trigger_df['Name']
    trigger_df.loc[trigger_df['Aggregation Level'].str.strip() == '', 'Aggregation Level'] = 'SIM'
    trigger_df['E-Mail Address'] = trigger_df['E-Mail Address'].str.replace('@','@migration')
    #### Service Profile Df
    service_profile_df = pd.read_csv(f'{input_file_path}/Service_Profile_Config_cdp.csv',skipinitialspace=True,keep_default_na=False,dtype=str)
    #### Billing Df
    service_profile_df['DPName'] = service_profile_df.apply(calculate_dp_name, axis=1)
    df_billing = pd.read_csv(f'{input_file_path}/Billing_Account_cdp.csv',skipinitialspace=True,keep_default_na=False,dtype=str)
    df_target = pd.DataFrame()
    df_notification_template = pd.DataFrame()

    try:
        merged_df = pd.merge(trigger_df, service_profile_df, left_on='Service Profile ID', right_on='SERVICE_PROFILE_ID',
                         how='left')
        trigger_df['Device Plan Name'] = merged_df['DPName']
        # df_trigger = df_trigger.drop(columns=['SERVICE_PROFILE_ID', 'Bundle Name'])

        changed_device_plan = pd.merge(trigger_df, service_profile_df, left_on='New Service Profile ID',
                                    right_on='SERVICE_PROFILE_ID', how='left')

        trigger_df['Changed Device Plan'] = changed_device_plan['DPName']

        # Apply the transformation using lambda and mapping
        ################## Rule Transformation ############################################################################

        df_billing_new = df_billing.copy()
        df_billing = df_billing.set_index('BUID')
        # df_billing_new = df_billing_new.set_index('CUSTOMER_ID')
        trigger_df['account_id'] = ''
        trigger_df_index_account_id = trigger_df.columns.get_loc("account_id")
        for index,row in trigger_df.iterrows():
            if row['Business Unit ID'] in df_billing.index and len(row['Business Unit ID'])!=0:
                # print('CRN', df_billing.loc[row["Business Unit ID"], "BILLING_ACCOUNT"])
                trigger_df.iloc[index,trigger_df_index_account_id] = df_billing.loc[row["Business Unit ID"], "BILLING_ACCOUNT"]
            elif (len(row['Business Unit ID'])==0):
                # print('CUID',df_billing_new.loc[df_billing_new['CUSTOMER_ID'] == row['Customer ID'], 'CUSTOMER_REFERENCE'].values[0])
                trigger_df.iloc[index,trigger_df_index_account_id] = df_billing_new.loc[df_billing_new['CUSTOMER_ID'] == row['Customer ID'], 'CUSTOMER_REFERENCE'].values[0]


        df = trigger_df
        
            

        df.drop_duplicates(inplace=True)
        df['Reset Period'] = df.apply(lambda row:row['Reset Period'] if len(row['Reset Period'])!=0 else 'Billing cycle',axis=1)
        df_target['notification_uuid'] = df['account_id']
        df_target['templateName'] = df.apply(lambda row: row['Mail Template Name'] if row['Action'] == 'Send E-mail' else (row['SMS Template Name'] if row['Action'] == 'Send SMS' else None), axis=1)
        # df_target['templateName'] = df['Mail Template Name']
        df_target['user_id'] = df['Created by']
        df_target['rule_name'] = df['Name']
        df_target['in_application_level'] = df['Application Level'].apply(lambda x: application_level_mapping.get(x, x))
        df_target['all_devices'] = df['Application Level'].apply(lambda x:0 if x=='SIM' else 1)
        df_target['in_any_service_profile'] = df['Any Service Profile']
        df_target['rule_description'] = df['Description']
        df_target['imsi_from'] = df['IMSI']
        df_target['in_aggregation_level'] = df['Aggregation Level'].apply(lambda x: aggregation_level_mapping.get(x, x))
        df_target['in_reset_period'] = df['Reset Period'].apply(lambda x: reset_period_mapper.get(x, x))
        df_target['in_category'] = df['Category'].apply(lambda x: in_category_mapping.get(x, x))
        df_target['Number of Days (Time Period SIM in SP)'] = df['Number of Days (Time Period SIM in SP)']
        df_target['Data (Time period first activity)'] = df['Data (Time period first activity)']
        df_target['SMS (Time period first activity)'] = df['SMS (Time period first activity)']
        df_target['Only Roaming Activity (Time period first activity)'] = df['Only Roaming Activity (Time period first activity)']
        df_target['Trigger'] = df['Trigger']
        df_target['Number of Days (Time Period first activity)'] = df['Number of Days (Time Period first activity)']
        df_target['Change Type (Country or operator change)'] = df['Change Type (Country or operator change)']
        df_target['Inactive Hours, Days or Months (Inactivity Period Online)'] = df['Inactive Hours, Days or Months (Inactivity Period Online)']
        df_target['Unit (Inactivity Period Online)'] = df['Inactive Hours, Days or Months (Inactivity Period Online)'].apply(lambda x: inactive_unit.get(x, x))
        df_target['Mode (Number of SIMs)'] = df['Mode (Number of SIMs)'].apply(lambda x: comparator_id.get(x, x))
        df_target['Parameter (Number of SIMs)'] = df['Parameter (Number of SIMs)']
        df_target['Duration in Seconds (Session Lenght)'] = df['Duration in Seconds (Session Lenght)']
        # Create a new column 'in_rule_access' based on the values in columns 'J' and 'I'
        df_target['in_rule_access'] = df.apply(lambda row: rule_access_mapping.get((row['Editable by Customer'], row['Visible to Customer']), ''), axis=1)
        df_target['start_time'] = pd.to_datetime(df['Activation Date'], format='%m/%d/%Y',errors='coerce').dt.strftime('%Y-%m-%d %H:%M:%S')
        df_target['in_device_plan'] = df['Device Plan Name'] + "_" + df['account_id']
        df_target['action_type_id'] = df['Action'].apply(lambda x: action_mapping.get(x, x))
        df_target['action_email_id'] = df['E-Mail Address']
        df_target['action_contact_number'] = df['Phone Number']
        df_target['state_change'] = df['Action'].apply(lambda x: 'Suspended' if x=='Suspend SIM' else '')
        df_target['changed_device_plane_id'] = df['Changed Device Plan'] + "_" + df['account_id']
        df_target['in_device_update_in_next_bill_cycle'] = df['Action'].apply(lambda x: '0' if x=='Change Service Profile' else '')
        df_target['in_sim_update_in_next_bill_cycle'] = df['Action'].apply(lambda x: '0' if x=='Suspend SIM' else '')
        print(df_target)
        df_target.to_csv(f'{output_file_base_dir}/trigger_cdp.csv',index=False)


        ################################ Notification Template ######################################################
        # If 
        filtered_df = df[df['Action'].isin(['Send E-mail', 'Send SMS'])]
        filtered_df = drop_duplicates_and_save_duplicates(filtered_df, f'{error_record_file_path}/duplicate_templates.csv',logger_info,['Customer ID','Mail Template Name'])
        print('len of filtered df',len(filtered_df))
        

        df_notification_template['id'] = ""
        df_notification_template['notification_uuid'] = filtered_df['account_id']
        df_notification_template['templateName'] = filtered_df.apply(lambda row: row['Mail Template Name'] if row['Action'] == 'Send E-mail' else (row['SMS Template Name'] if row['Action'] == 'Send SMS' else None), axis=1)
        df_notification_template['language'] = 'en'
        df_notification_template['subject'] = filtered_df.apply(lambda row: row['Subject'] if row['Action'] == 'Send E-mail' else None if row['Action'] == 'Send SMS' else None, axis=1)

        # Transformation using lambda
        df_notification_template['message'] = filtered_df.apply(lambda row: row['Message'] if row['Action'] == 'Send E-mail' else (row['SMS Message'] if row['Action'] == 'Send SMS' else None), axis=1)
        df_notification_template['description'] = filtered_df['Description']

        df_notification_template['category'] = ''
        df_notification_template['notificationType'] = filtered_df.apply(lambda row: 'Email' if row['Action'] == 'Send E-mail' else ('SMS' if row['Action'] == 'Send SMS' else None), axis=1)
        df_notification_template['templateType'] = filtered_df.apply(lambda row: 'Email' if row['Action'] == 'Send E-mail' else ('SMS' if row['Action'] == 'Send SMS' else None), axis=1)

        # Function to find and replace keys with their values in the 'attribute_id' column
        def find_attribute_id(message):
            for key, value in attribute_mapper.items():
                if key in message:
                    return value
            return ''

        df_notification_template['attributeString'] = df_notification_template['message'].apply(find_attribute_id)
        df_notification_template['attributeString'] = df_notification_template['attributeString'].fillna('')
        df_notification_template.to_csv(f'{output_file_base_dir}/template.csv',index=False)
        print(df_notification_template)

    except Exception as e:
        print("Error while transforming data {}".format(e))
        traceback.print_exc()
        logger_error.error("Error while transforming data {}".format(e))


trigger_transformation()
