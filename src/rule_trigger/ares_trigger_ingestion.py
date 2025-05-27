import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from conf.custom.ares.config import *
from conf.config import *
from urllib.parse import *
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
                    error_message = content_dict.get("errorMessage") or content_dict.get("message")
                    error_dict = {"errorMessage": error_message}
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


def initiate_api_call_nf_template(api_url, payload, token, parent_id_colun_name):
    initiate_call = api_call()

    json_obj_dict = None
    error_json_obj_dict = None
    result_dict_id = None  # To store legacyBan as key and id as value
    try:
        status_code = None
        content = None
        status_code, content = initiate_call.call_api(
            api_url, payload, token, parent_id_colun_name)
        print('Status Code : ', status_code)
        logger_info.info("api_url \n {} ".format(api_url))
        logger_info.info("payload \n {} ".format(payload))
        logger_info.info("status {} content {} ".format(status_code, content))

    except Exception as e:
        logger_error.error("api_url \n {} ".format(api_url))
        logger_error.error("payload \n {} ".format(payload))
        logger_error.error("status {} content {} error {}".format(status_code, content, e))

    if status_code is not None and content is not None:
        try:
            # Before calling parse_qs(), check the type
            if isinstance(payload, dict):
                # Convert dictionary to a query string
                payload = urlencode(payload)
            # Or if it's bytes
            elif isinstance(payload, bytes):
                payload = payload.decode('utf-8')

            parsed_payload_dict = parse_qs(payload)
            flattened_payload_dict = {k: v[0] if len(v) == 1 else v for k, v in parsed_payload_dict.items()}
            payload = json.dumps(flattened_payload_dict)

            # Extract legacyBan from payload (assuming it's present in the payload)
            legacy_ban = flattened_payload_dict.get(parent_id_colun_name)
            notification_type = flattened_payload_dict.get('notificationType')
            template_name = flattened_payload_dict.get('templateName')
            if content.startswith(b'{'):
                content_dict = json.loads(content.decode('utf-8'))

                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    # json_obj_dict.update(content_dict)


                    # Extract 'id' from the response
                    response_id = content_dict.get('id')

                    if legacy_ban and response_id:
                        # Populate result_dict with both 'id' and 'crm_id'
                        result_dict = {}
                        result_dict['id'] = int(response_id)
                        result_dict['template_id'] = legacy_ban
                        result_dict['notificationType'] = notification_type
                        result_dict['templateName'] = template_name
                        result_dict_id = result_dict

                else:
                    error_dict = {"errorMessage": content_dict["errorMessage"]}
                    error_json_obj_dict = json.loads(payload)
                    error_json_obj_dict.update(error_dict)

            else:
                # Handling HTML response for error
                error_message = "HTTP Status 400 – Bad Request"
                error_dict = {"errorMessage": error_message}
                error_json_obj_dict = json.loads(payload)
                error_json_obj_dict.update(error_dict)

        except Exception as e:
            error_dict = {"errorMessage": "Error in calling API: %s" % e}
            error_json_obj_dict = json.loads(payload)
            error_json_obj_dict.update(error_dict)

    return json_obj_dict, error_json_obj_dict, result_dict_id


def fetch_account_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('crn',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    query = f"""SELECT LEGACY_BAN,ID FROM accounts WHERE LEGACY_BAN IN({format_strings});"""

    account_id = sql_data_fetch(query, reference_number, aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
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


def create_subject_message(row):
    """
    Extract subject, message, and notification type from a trigger row.
    
    Args:
        row (Series): A row from the trigger dataframe
        
    Returns:
        tuple: (subject, message, notification_type)
    """
    # Default values
    subject = row.get('rule_name', '')
    message = row.get('rule_name', '')
    notification_type = 'EMAIL'  # Default to EMAIL
    
    # Determine notification type and content based on available fields
    if row.get('action_type_id') == '2' or 'MAIL' in row.get('webhook_metadata', '').upper():
        # Email type
        notification_type = 'EMAIL'
        if row.get('T_IAS_MAIL_MESSAGE'):
            message = row.get('T_IAS_MAIL_MESSAGE')
        if row.get('T_IAS_MAIL_SUBJECT'):
            subject = row.get('T_IAS_MAIL_SUBJECT')
    elif row.get('action_type_id') == '4' or 'SMS' in row.get('webhook_metadata', '').upper():
        # SMS type
        notification_type = 'SMS'
        if row.get('T_IAS_SMS_MESSAGE'):
            message = row.get('T_IAS_SMS_MESSAGE')
    
    # Encode content if needed (assuming this function exists)
    try:
        subject = encode_to_base64(subject)
        message = encode_to_base64(message)
    except:
        # If encoding function is not available, use as-is
        pass
    
    return subject, message, notification_type


def create_template(token):
    start_time = time.time()
    df_template = read_table_as_df('notifications_success', transformation_db_configs, logger_info, logger_error)

    uuids = df_template['accountId'].tolist()
    uuid_to_account_id = fetch_account_id(uuids)
    df_template['accountId'] = df_template['accountId'].astype(str)
    df_template['account_id'] = df_template['accountId'].map(uuid_to_account_id)
    df_template['account_id'] = df_template['account_id'].fillna('')
    
    print("Length of template file",len(df_template))
    logger_info.info("Length of template file {}".format(len(df_template)))
    
    try:
        error_list = []
        success_list = []
        id_mapping_list = []
        for index, row in df_template.iterrows():
            message = encode_to_base64(row['message'])
            subject = encode_to_base64(row['subject'])
            
            if len(row['account_id']) != 0:
                nf_template_payload = template_payload(row, message, subject)
                print(nf_template_payload)
                success_dict, error_dict, id_mapping_dict = initiate_api_call_nf_template(aircontrol_create_template, nf_template_payload, token, 'accountId')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)

                if id_mapping_dict is not None:
                    id_mapping_list.append(id_mapping_dict)
            else:
                print("Account Id : {}, not Found in table for CRN {}".format(row['account_id'], row['accountId']))
                logger_error.error("Account Id : {}, not Found in table for CRN : {}".format(row['account_id'], row['accountId']))

        success_df = pd.DataFrame(success_list)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/template_success_{current_date_time_str_logs}.csv", index=False)

        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/template_error_{current_date_time_str_logs}.csv", index=False)

        id_mapping_df = pd.DataFrame(id_mapping_list)

        if not id_mapping_df.empty:
            insert_batches_df_into_mysql(id_mapping_df, metadata_db_configs, 'template_id_mapping', logger_info,
                                         logger_error)


        end_time = round((time.time() - start_time), 2)
        curr_date = today.strftime("%Y%m%d")
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error, 'Notification Template', len(df_template), 
                                  len(success_df), len(error_df), end_time, curr_date)

    except Exception as e:
        print("Error : {}, while processing template file : {}".format(e, df_template))
        logger_error.error("Error : {}, while processing template file : {}".format(e, df_template))


def create_trigger(column_mapping):
    """
    Create triggers in target system based on transformed data.
    
    Args:
        column_mapping (dict): A dictionary mapping field names between systems
        
    Returns:
        None
    """
    try:
        # Read transformed trigger data
        df_trigger = read_table_as_df('trigger_success', transformation_db_configs, logger_info, logger_error)
        
        if df_trigger.empty:
            logger_info.info("No trigger data found for ingestion")
            return
            
        # Convert all accountId values to strings for mapping
        df_trigger['accountId'] = df_trigger['accountId'].astype(str)
        
        # Fetch account IDs from legacy IDs
        uuids = df_trigger['accountId'].tolist()
        uuid_to_account_id = fetch_account_id(uuids)
        
        # Map legacy IDs to account IDs
        df_trigger['account_id'] = df_trigger['accountId'].map(uuid_to_account_id)
        df_trigger['account_id'] = df_trigger['account_id'].fillna('')
        
        logger_info.info(f"Mapped {len([id for id in df_trigger['account_id'] if id])} account IDs successfully")
        
        # Load template mappings
        template_id_df = read_table_as_df('template_id_mapping', metadata_db_configs, logger_info, logger_error)
        
        # Create dictionaries for template lookups
        if not template_id_df.empty:
            template_id_mapping = template_id_df.set_index('template_id')['id'].to_dict()
            notification_type_mapping = template_id_df.set_index('template_id')['notificationType'].to_dict()
            template_name_mapping = template_id_df.set_index('template_id')['templateName'].to_dict()
            
            # Map template IDs - first try MAIL template, then SMS template
            df_trigger['template_id'] = df_trigger['T_IAA_MAIL_TEMPLATE'].map(template_id_mapping).fillna(
                df_trigger['T_IAA_SMS_TEMPLATE'].map(template_id_mapping)
            )
            
            # Map notification types
            df_trigger['notificationType'] = df_trigger['T_IAA_MAIL_TEMPLATE'].map(notification_type_mapping).fillna(
                df_trigger['T_IAA_SMS_TEMPLATE'].map(notification_type_mapping)
            )
            
            # Map template names
            df_trigger['templateName'] = df_trigger['T_IAA_MAIL_TEMPLATE'].map(template_name_mapping).fillna(
                df_trigger['T_IAA_SMS_TEMPLATE'].map(template_name_mapping)
            )
        else:
            # Initialize empty columns if no template mappings exist
            df_trigger['template_id'] = ''
            df_trigger['notificationType'] = ''
            df_trigger['templateName'] = ''
        
        # Fill NaN values in template columns
        df_trigger['template_id'] = df_trigger['template_id'].fillna('')
        df_trigger['notificationType'] = df_trigger['notificationType'].fillna('')
        df_trigger['templateName'] = df_trigger['templateName'].fillna('')
        
        # Save intermediate state for debugging
        df_trigger.to_csv('trigger_ingestion_temp.csv', index=False)
        logger_info.info(f"Processing {len(df_trigger)} triggers for ingestion")
        
        # Track success and error results
        success_list = []
        error_list = []
        
        # Process each trigger
        for index, row in df_trigger.iterrows():
            # Skip records with no account ID
            if not row['account_id']:
                logger_error.error(f"Account ID not found for legacy ID: {row['accountId']}")
                continue
                
            # Create template if needed
            if not row['template_id'] and (row['T_IAS_MAIL_MESSAGE'] or row['T_IAS_SMS_MESSAGE']):
                # Determine message type and content
                subject, message, notification_type = create_subject_message(row)
                notification_template_payload = template_payload_from_trigger_df(row, message, subject, notification_type)
                
                try:
                    # Create template
                    try:
                        # Convert the payload dictionary to query parameters
                        query_params = urlencode(notification_template_payload)
                        url_with_params = f"{aircontrol_create_template}?{query_params}"
                        
                        logger_info.info(f"Making Template API call to URL: {url_with_params}")
                        print(f"Making Template API call to URL: {url_with_params}")
                        
                        # Make the POST request with query parameters
                        response = requests.post(
                            url_with_params,
                            headers={'Authorization': f"Bearer {token}"},
                            verify=False,
                        )
                        
                        # Extract status code and content from the response
                        status_code = response.status_code
                        content = response.content
                        
                        logger_info.info(f"Template API call completed: status={status_code}, content={content}")
                        print(f"Template API call completed: status={status_code}, content={content}")
                    
                    except Exception as e:
                        logger_error.error(f"Error during Template API call: {e}")
                        print(f"Error during Template API call: {e}")
                        raise
                    
                    # Process response
                    if content and content.startswith(b'{'):
                        content_dict = json.loads(content.decode('utf-8'))
                        
                        if status_code == 200:
                            # Update template ID
                            template_id = content_dict.get('id')
                            if template_id:
                                df_trigger.at[index, 'template_id'] = template_id
                                df_trigger.at[index, 'notificationType'] = notification_type
                                logger_info.info(f"Created template ID {template_id} for trigger {row['rule_name']}")
                        else:
                            error_msg = content_dict.get("errorMessage", "Unknown error")
                            logger_error.error(f"Template creation failed: {error_msg}")
                    else:
                        logger_error.error("Template creation failed with non-JSON response")
                        
                except Exception as e:
                    logger_error.error(f"Exception during template creation: {e}")
            
            # Create trigger
            try:
                rule_trigger_payload = trigger_payload(row, account_id_token, column_mapping, logger_error)
                
                if rule_trigger_payload:
                    # Call API to create trigger
                    success_dict, error_dict = initiate_api_call(
                        aircontrol_create_trigger, 
                        rule_trigger_payload, 
                        token, 
                        ''
                    )
                    
                    # Track results
                    if success_dict:
                        success_list.append(success_dict)
                        logger_info.info(f"Successfully created trigger: {row['rule_name']}")
                    
                    if error_dict:
                        error_list.append(error_dict)
                        logger_error.error(f"Error creating trigger: {row['rule_name']}")
                else:
                    logger_error.error(f"Failed to generate payload for trigger: {row['rule_name']}")
            
            except Exception as e:
                logger_error.error(f"Exception during trigger creation: {e}")
        
        # Save results to CSV files
        if success_list:
            success_df = pd.DataFrame(success_list)
            success_df.to_csv(f"{logs_path}/trigger_success_{current_date_time_str_logs}.csv", index=False)
            logger_info.info(f"Created {len(success_list)} triggers successfully")
        
        if error_list:
            error_df = pd.DataFrame(error_list)
            error_df.to_csv(f"{logs_path}/trigger_error_{current_date_time_str_logs}.csv", index=False)
            logger_error.info(f"Failed to create {len(error_list)} triggers")

    except Exception as e:
        logger_error.error(f"Error during trigger ingestion: {e}")
        print(f"Error during trigger ingestion: {e}")
        raise


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))

    column_mapping = {
        'Trigger' : 'CONDITION_TYPE',
        'new_device_plane_id' : 'T_IC_SP_CHANGE_SP_CONTEXT',
        'T_IAA_C_TP_FA_DATA' : 'T_IAA_C_TP_FA_DATA',
        'T_IAA_COND_TP_FA_SMS' : 'T_IAA_COND_TP_FA_SMS',
        'T_IAA_C_TP_FA_VOICE' : 'T_IAA_C_TP_FA_VOICE',
        'TIC_POINT_IN_TIME_TIME' : 'TIC_POINT_IN_TIME_TIME',
        'T_IC_CT_SP_CONTEXT' : 'T_IC_CT_SP_CONTEXT',
        'T_IC_VT_SP_CONTEXT' : 'T_IC_VT_SP_CONTEXT',
        'T_IC_TP_SIM_IN_SP_SP_CONTEXT' : 'T_IC_TP_SIM_IN_SP_SP_CONTEXT',
        'T_IC_TP_SIM_IN_SP_NO_OF_DAYS' : 'T_IC_TP_SIM_IN_SP_NO_OF_DAYS',
        'T_IC_TP_FACTIVITY_NO_DAYS' : 'T_IC_TP_FACTIVITY_NO_DAYS',
        'T_IC_SP_CHANGE_SP_CONTEXT' : 'T_IC_SP_CHANGE_SP_CONTEXT',
        'T_IC_TP_SIM_IN_SP_SP_CONTEXT' : 'T_IC_TP_SIM_IN_SP_SP_CONTEXT',
        'T_IC_COOC_CHANGE_TYPE' : 'T_IC_COOC_CHANGE_TYPE'
    }

    # Access individual arguments    
    for arg in sys.argv[1:]:
        token = get_user_token(username, password)
        
        print('token :',token)
        if arg == "template":
            print("template")
            create_template(token)

        if arg == 'trigger':
            print("trigger")
            create_trigger(column_mapping)