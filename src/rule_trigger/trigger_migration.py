import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from conf.custom.apollo.config import *
from conf.config import *
from urllib.parse import urlencode,urlparse,parse_qs,quote
import requests 
from trigger_payload import *
from src.utils.library import *
today = datetime.now()


from src.utils.utils_lib import api_call,encode_to_base64
initiate_call = api_call()

current_date_time_str_logs = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"stc_ingestion_trigger_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"stc_ingestion_trigger_error_{current_date_time_str_logs}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'
dir_path = dirname(abspath(__file__))

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def get_user_token(username, password):
    """
    :param username: username to get the token
    :param password: password to get the token
    :return: It will return the token
    """
    payload = f"username={username}&password={password}"
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    url = api_validate_url

    token = None

    try:
        response = requests.request("POST", url, headers=headers, data=payload, verify=False)

        print(response.status_code)
        # print(response.content)

        token = json.loads(response.content)
        print(token)

        token = token["token"]

        logger_info.info("Token : {}".format(token))

    except Exception as e:
        print("Token API Error : {}".format(e))
        logger_error.error("Token API Error : {}".format(e))

    return token




def initiate_api_call(api_url,payload,token,bu_account_id):
    initiate_call = api_call()

    json_obj_dict = None
    error_json_obj_dict = None
    try:
        status_code = None
        content = None
        status_code, content = initiate_call.call_api(
            api_url, payload, token, bu_account_id)
        print('Status Code : ',status_code)
        logger_info.info("api_url \n {} ".format(api_url))
        logger_info.info("payload \n {} ".format(payload))
        logger_info.info("status {} content {} ".format(status_code, content))

    except Exception as e:
        logger_error.error("api_url \n {} ".format(api_url))
        logger_error.error("payload \n {} ".format(payload))
        logger_error.error("status {} content {} error {}".format(status_code, content, e))

    if status_code is not None and content is not None:
        try:
            payload = json.dumps(payload)
            if content.startswith(b'{'):
                content_dict = None
                content_dict = json.loads(content.decode('utf-8'))
                # print("content dict 1",content_dict)
                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    json_obj_dict.update(content_dict)
                    # return json_obj_dict

                else:
                    error_dict = {"errorMessage": content_dict["errorMessage"]}

                    error_json_obj_dict = json.loads(payload)
                    error_json_obj_dict.update(error_dict)
                    # error_list_sim_onboarding_columns.append(json_obj_dict)
                    # return error_json_obj_dict
            else:
                # Handling HTML response for error

                error_message = "HTTP Status 400 – Bad Request"
                error_dict = {"errorMessage": error_message}
                error_json_obj_dict = json.loads(payload)
                error_json_obj_dict.update(error_dict)

        except Exception as e:
            error_dict = {"errorMessage": "error in calling API %s" % e}
            error_json_obj_dict = json.loads(payload)
            error_json_obj_dict.update(error_dict)
            # return error_json_obj_dict
            # error_list_sim_onboarding_columns.append(json_obj_dict)
        return json_obj_dict,error_json_obj_dict

def fetch_account_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('crn',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT NOTIFICATION_UUID,ID FROM accounts WHERE NOTIFICATION_UUID IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,reference_number,aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None

def fetch_device_plan_id(plan_name):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('crn',plan_name)
    format_strings = ','.join(['%s'] * len(plan_name))
    querry = f"""SELECT PLAN_NAME,ID FROM accounts WHERE PLAN_NAME IN({format_strings});"""
    # print('hello amit',reference_number)
    account_id = sql_data_fetch(querry,plan_name,aircontrol_db_configs, logger_error)
    
    if account_id:
        print("device plan id : ", account_id)
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None
    
def create_template(token):
    df_template = pd.read_csv(template_file_path,keep_default_na=False, dtype=str)
    uuids = df_template['notification_uuid'].tolist()
    uuid_to_account_id = fetch_account_id(uuids)
    df_template['account_id'] = df_template['notification_uuid'].map(uuid_to_account_id)
    df_template['account_id'] = df_template['account_id'].fillna('')
    print("Length of template file",len(df_template))
    logger_info.info("Length of template file {}".format(len(df_template)))
    
    try:
        error_list = []
        success_list = []
        for index,row in df_template.iterrows():
            message = encode_to_base64(row['message'])
            subject = encode_to_base64(row['subject'])
            if len(row['account_id']) !=0:
                nf_template_payload = template_payload(row,message,subject)
                print(nf_template_payload)
                success_dict,error_dict = initiate_api_call(template_api_url, nf_template_payload, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)
            else:
                
                print("Account Id : {}, not Found in table for CRN {}".format(row['account_id'],
                                                                                        row['notification_uuid']))
                logger_error.error("Account Id : {}, not Found in table for CRN : {}".format(row['account_id'],
                                                                                        row['notification_uuid']))
        success_df = pd.DataFrame(success_list)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/template_success_{current_date_time_str_logs}.csv", index=False)
        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/template_error_{current_date_time_str_logs}.csv", index=False)
    except Exception as e:
        print("Error : {}, while processing template file : {}".format(e, df_template))
        logger_error.error("Error : {}, while processing template file : {}".format(e, df_template))


def create_trigger(file_path,column_mapping):

    try:
        df_trigger = pd.read_csv(file_path,keep_default_na=False, dtype=str)
        uuids = df_trigger['notification_uuid'].tolist()
        uuid_to_account_id = fetch_account_id(uuids)
        df_trigger['account_id'] = df_trigger['notification_uuid'].map(uuid_to_account_id)
        df_trigger['account_id'] = df_trigger['account_id'].fillna('')
        print(df_trigger['account_id'])


        ### Device Plan Id Fetch #############
        device_plan_name = df_trigger['in_device_plan'].tolist()
        new_device_plan = df_trigger['changed_device_plane_id'].tolist()
        device_plan_to_device_id = fetch_device_plan_id(device_plan_name)

        def map_dp_to_dp_id(plan):
            if device_plan_to_device_id is None:
                return ' '
            return device_plan_to_device_id.get(plan, ' ')
        
        df_trigger['in_device_plane_id'] = df_trigger['in_device_plan'].apply(map_dp_to_dp_id).fillna('')

        changed_dp_to_device_id = fetch_device_plan_id(new_device_plan)

        def map_new_dp_to_dp_id(uuid):
            if changed_dp_to_device_id is None:
                return ''
            return changed_dp_to_device_id.get(uuid, '')
        
        df_trigger['new_device_plane_id'] = df_trigger['changed_device_plane_id'].apply(map_new_dp_to_dp_id).fillna('')
        ############ template id fetch #######################
        # Extract unique ACCOUNT_ID and TEMPLATE_NAME values
        account_ids = df_trigger['account_id'].dropna().unique()
        template_names = df_trigger['templateName'].unique()

        # Construct the WHERE clause for the SQL query
        filtered_account_ids = [str(account_id) for account_id in account_ids if account_id]

        # Construct the WHERE clause for the SQL query
        account_ids_str = ','.join(filtered_account_ids)
        template_names_str = ','.join(f"'{name}'" for name in template_names if name)
        
        query = f"""
        SELECT MAX(id) as template_id, TEMPLATE_NAME as templateName, ACCOUNT_ID as account_id, NOTIFICATION_TYPE as notification_type
        FROM notification_trigger_template
        WHERE ACCOUNT_ID IN ({account_ids_str}) AND TEMPLATE_NAME IN ({template_names_str})
        GROUP BY ACCOUNT_ID, TEMPLATE_NAME;
        """
        df_trigger_id = fetch_param_as_df(query,aircontrol_db_configs,logger_info, logger_error)
        
        df_trigger_id = df_trigger_id.astype(str)
        df_trigger = pd.merge(df_trigger, df_trigger_id, on=['templateName', 'account_id'], how='left')
        
        # Step 5: Fill NaN values in the 'id' column with empty strings
        df_trigger['template_id'] = df_trigger['template_id'].fillna('')
        df_trigger['notification_type'] = df_trigger['notification_type'].fillna('')
        print(df_trigger)
        
        df_trigger.to_csv('temp.csv',index=False)
        print("Length of trigger file",len(df_trigger))
        logger_info.info("Length of trigger file {}".format(len(df_trigger)))
        try:
            error_list = []
            success_list = []
            for index,row in df_trigger.iterrows():
                
                if len(row['account_id']) !=0:

                    rule_trigger_payload = trigger_payload(row,account_id_token, column_mapping,logger_error)
                    print('trigger template payload',rule_trigger_payload)
                    success_dict,error_dict = initiate_api_call(trigger_api_url, rule_trigger_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    print("Account Id : {}, not Found in table for CRN {}".format(row['account_id'],
                                                                                            row['notification_uuid']))
                    logger_error.error("Account Id : {}, not Found in table for CRN : {}".format(row['account_id'],
                                                                                            row['notification_uuid']))
            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/trigger_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/trigger_error_{current_date_time_str_logs}.csv", index=False)

        except Exception as e:
            print("Error : {}, while processing template file : {}".format(e, df_trigger))
            logger_error.error("Error : {}, while processing template file : {}".format(e, df_trigger))


    except Exception as e:
            print("Error : {}, while trigger ingestion".format(e))
            logger_error.error("Error : {}, while trigger ingestion".format(e))





if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments
    column_mapping = {
    ### mapper column : Your file column name
    'Trigger': 'Trigger',
    'Trigger ID': 'Trigger ID',  # Correctly map 'Trigger ID'
    'Eravel Unit': 'Unit (Inactivity Period Online)',  # Example dynamic value column mapping
    'Eravel Value': 'Inactive Hours, Days or Months (Inactivity Period Online)',  # Example dynamic value column mapping
    # 'Comparator IDs': 'Comparator IDs',  # Example dynamic value column mapping
    'Condition Value': 'Parameter (Number of SIMs)',  # Example dynamic value column mapping
    'Data (Time period first activity)': 'Data (Time period first activity)',
    'SMS (Time period first activity)': 'SMS (Time period first activity)',
    'Only Roaming Activity (Time period first activity)':'Only Roaming Activity (Time period first activity)',
    'Service Profile ID':'in_device_plane_id',
    'Time Passed':'Number of Days (Time Period SIM in SP)',
    'Change Type (Country or operator change)':'Change Type (Country or operator change)',
    'Duration in Seconds (Session Lenght)':'Duration in Seconds (Session Lenght)',
    'Number of Days (Time Period first activity)':'Number of Days (Time Period first activity)',
    # 'Condition IDs':''
    }
    
    for arg in sys.argv[1:]:
        token = get_user_token(username, password)
        print('token :',token)
        if arg == "template":
            print("template")
            create_template(token)

        if arg == 'trigger':
            create_trigger(trigger_file_path,column_mapping)