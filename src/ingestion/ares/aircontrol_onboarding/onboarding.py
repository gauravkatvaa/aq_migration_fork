import sys

# # Add the parent directory to sys.path
sys.path.append("..")

from urllib.parse import urlencode,urlparse,parse_qs,quote
import requests
from pay_loads import *
from conf.custom.ares.config import *
from src.utils.library import *
today = datetime.now()
curr_date = today.strftime("%Y%m%d")
from src.utils.utils_lib import api_call
initiate_call = api_call()

current_date_time_str_logs = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"ares_ingestion_aircontrol_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"ares_ingestion_aircontrol_error_{current_date_time_str_logs}.log"
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


# fetch_onboarded_account_ids
# it is fetching legacy_ban list from 122 aircontrol db and returning as list

def fetch_onboarded_account_ids() -> list:
    """
    :return: It will return the list of legacy_ban
    """
    querry = f"""SELECT LEGACY_BAN FROM accounts"""
    data = sql_query_fetch(querry, ac_db_configs, logger_error)
    
    if data:
        data = [i[0] for i in data]
        return data
    else:
        return []

def fetch_apn_id(apn_id):
    """
    :param apn_id:
    :return:
    """
    format_strings = ','.join(['%s'] * len(apn_id))
    querry = f"""SELECT APN_ID,ID FROM service_apn_details WHERE APN_ID IN ({format_strings});"""
    # print('hello amit',reference_number)
    apn_id_new = sql_data_fetch(querry,apn_id,aircontrol_db_configs, logger_error)
    print("Apn Id : ", apn_id_new)
    if apn_id_new:
        apn_id_ac = {str(sorce_apn_id): str(apn_id) for sorce_apn_id, apn_id in apn_id_new}
        return apn_id_ac
    else:
        return None


def fetch_opco_account_id():
    querry = f"""SELECT id FROM accounts WHERE name='A1 Digital Deutschland GmbH' AND type=3 AND deleted=0"""
    data = sql_query_fetch(querry, ac_db_configs, logger_error)
    print("data",data)
    if data:
        data = data[0][0]
        return data
    else:
        return None


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
            parsed_payload_dict = urllib.parse.parse_qs(payload)
            flattened_payload_dict = {k: v[0] if len(v) == 1 else v for k, v in parsed_payload_dict.items()}
            payload = json.dumps(flattened_payload_dict)

            if content.startswith(b'{'):
                content_dict = None
                content_dict = json.loads(content.decode('utf-8'))
                # print("content dict 1",content_dict)
                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    # json_obj_dict.update(content_dict)
                    # return json_obj_dict

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
            error_dict = {"errorMessage": "error in calling API %s" % e}
            error_json_obj_dict = json.loads(payload)
            error_json_obj_dict.update(error_dict)
           
        return json_obj_dict,error_json_obj_dict
    
def initiate_api_apn_call(api_url,payload,token,bu_account_id):
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
            parsed_payload_dict = urllib.parse.parse_qs(payload)
            flattened_payload_dict = {k: v[0] if len(v) == 1 else v for k, v in parsed_payload_dict.items()}
            payload = json.dumps(flattened_payload_dict)

            if content.startswith(b'{') or content.startswith(b'APN'):
                content_dict = None
                #content_dict = json.loads(content.decode('utf-8'))
                # print("content dict 1",content_dict)
                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    # json_obj_dict.update(content_dict)
                    # return json_obj_dict                    

                else:
                    content_dict = json.loads(content.decode('utf-8'))
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
            error_dict = {"errorMessage": "error in calling API %s" % e}
            error_json_obj_dict = json.loads(payload)
            error_json_obj_dict.update(error_dict)
           
        return json_obj_dict,error_json_obj_dict

def initiate_api_call_report_subscription(api_url,payload,token,bu_account_id):
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
            query_string = urllib.parse.urlencode(payload, doseq=True)
            parsed_payload_dict = urllib.parse.parse_qs(query_string)
            flattened_payload_dict = {k: v[0] if len(v) == 1 else v for k, v in parsed_payload_dict.items()}
            payload = json.dumps(flattened_payload_dict)

            if content.startswith(b'{'):
                content_dict = None
                content_dict = json.loads(content.decode('utf-8'))
                # print("content dict 1",content_dict)
                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    # json_obj_dict.update(content_dict)
                    # return json_obj_dict

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
            error_dict = {"errorMessage": "error in calling API %s" % e}
            error_json_obj_dict = json.loads(payload)
            error_json_obj_dict.update(error_dict)
           
        return json_obj_dict,error_json_obj_dict   



def initiate_api_call_ec_bu(api_url, payload, token, parent_id_colun_name):
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
            parsed_payload_dict = urllib.parse.parse_qs(payload)
            flattened_payload_dict = {k: v[0] if len(v) == 1 else v for k, v in parsed_payload_dict.items()}
            payload = json.dumps(flattened_payload_dict)

            # Extract legacyBan from payload (assuming it's present in the payload)
            legacy_ban = flattened_payload_dict.get(parent_id_colun_name)

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
                        result_dict['crm_id'] = legacy_ban
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


def ac_fetch_account_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    print('Legacy ban ',reference_number)
    format_strings = ','.join(['%s'] * len(reference_number))
    querry = f"""SELECT LEGACY_BAN,ID FROM accounts WHERE LEGACY_BAN IN({format_strings});"""

    account_id = sql_data_fetch(querry, reference_number, ac_db_configs, logger_error)
    print("account id : ", account_id)

    if account_id:
        # account_id = account_id[0][0]
        uuid_to_account_id = {uuid: str(accountid) for uuid, accountid in account_id}

        return uuid_to_account_id
    else:
        return None


def fetch_role_id(notification_uuid, role_id):
    query = f"""SELECT id FROM role_access 
                WHERE Account_ID = (SELECT id FROM accounts WHERE LEGACY_BAN = '{notification_uuid}' limit 1) 
                AND role_name LIKE '%{role_id}%' LIMIT 1;"""
    print("query : ",query)
    print("Role Name : ",role_id)
    role_id_new = sql_query_fetch(query, ac_db_configs, logger_error)
    print("Role Id : ", role_id_new)
    if role_id_new:
        role_id_new = role_id_new[0][0]
        return role_id_new
    else:
        return None


def ec_onboarding(token):
    start_time = time.time()
    df_enterprise = read_table_as_df('ec_success',transformation_db_configs,logger_info, logger_error)
    
    df_enterprise = df_enterprise.replace([None, 'None'], '')
    # Alternatively, you can explicitly replace NaN values
    df_enterprise = df_enterprise.fillna('')
    df_enterprise.to_csv('ingest_ec.csv',index=False)

    onboarded_account_ids = fetch_onboarded_account_ids()

    print("df enterprise : ",df_enterprise)
    print("Length of Enterprise Data", len(df_enterprise))
    logger_info.info("Length of Enterprise Data : {}".format(len(df_enterprise)))
    try:
        error_list = []
        success_list = []
        id_mapping_list = []
        parent_account_id = opco_account_id
        for index, row in df_enterprise.iterrows():
            if str(row['legacyBan']) not in onboarded_account_ids:
                ec_payload = enterprise_customer_payload(row,logger_error,parent_account_id)
                success_dict,error_dict,id_mapping_dict = initiate_api_call_ec_bu(ec_bu_onboarding_url, ec_payload, token, 'legacyBan')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)

                if id_mapping_dict is not None:
                    id_mapping_list.append(id_mapping_dict)

        success_df = pd.DataFrame(success_list)
        success_df = success_df.fillna('')

        truncate_mysql_table(ingestion_db_configs, 'ec_success', logger_error)

        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/ec_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'ec_success', logger_info,
                                         logger_error)
        
        error_df = pd.DataFrame(error_list)
        error_df = error_df.fillna('')

        truncate_mysql_table(ingestion_db_configs, 'ec_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/ec_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'ec_failure', logger_info,
                                         logger_error)

        id_mapping_df = pd.DataFrame(id_mapping_list)
        truncate_mysql_table(metadata_db_configs, 'parent_id_mapping', logger_error)
        if not id_mapping_df.empty:
            insert_batches_df_into_mysql(id_mapping_df, metadata_db_configs, 'parent_id_mapping', logger_info,
                                         logger_error)

        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Enterprise Customer', len(df_enterprise), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)
    except Exception as e:
        print("Error : {}, while processing Enterprise data : {}".format(e, df_enterprise))
        logger_error.error("Error : {}, while processing Enterprise data : {}".format(e, df_enterprise))


def bu_onboarding(token):
    start_time = time.time()
    df_bu = read_table_as_df('bu_success',transformation_db_configs,logger_info, logger_error)
    print("df bu ",df_bu)
    df_bu = df_bu.replace([None, 'None'], '')
    df_bu = df_bu.fillna('')
    print("Length of Business Unit Data", len(df_bu))
    logger_info.info("Length of Business Unit Data : {}".format(len(df_bu)))
    
    uuids = df_bu['parentAccountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    df_bu = df_bu.astype(str)
    df_bu['account_id'] = df_bu['parentAccountId'].map(uuid_to_account_id)
    df_bu['account_id'] = df_bu['account_id'].fillna('')

    onboarded_account_ids = fetch_onboarded_account_ids()


    try:
        error_list = []
        success_list = []
        
        for index, row in df_bu.iterrows():
            if len(row['account_id']) != 0 and str(row['legacyBan']):# not in onboarded_account_ids:
                ec_payload = enterprise_customer_payload(row,logger_error,row['account_id'])
                success_dict,error_dict = initiate_api_call(ec_bu_onboarding_url, ec_payload, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                    update_bu_frequency(row['legacyBan'])
                if error_dict is not None:
                    error_list.append(error_dict)
            
            else:
                if str(row['legacyBan']) in onboarded_account_ids:
                    print("Legacy Ban : {} already exist in table".format(row['legacyBan']))
                    logger_error.error("Legacy Ban : {} already exist in table".format(row['legacyBan']))
                else:
                    print("Account Id : {} not Found for accountId {}".format(row['account_id'],row['parentAccountId']))
                    logger_error.error("Account Id : {} not Found for accountId {}".format(row['account_id'],row['parentAccountId']))
                    
        success_df = pd.DataFrame(success_list)
        truncate_mysql_table(ingestion_db_configs, 'bu_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/bu_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'bu_success', logger_info,
                                         logger_error)
        error_df = pd.DataFrame(error_list)
        truncate_mysql_table(ingestion_db_configs, 'bu_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/bu_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'bu_failure', logger_info,
                                         logger_error)

        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Business Unit', len(df_bu), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)
    except Exception as e:
        print("Error : {}, while processing Business Data: {}".format(e, df_bu))
        logger_error.error("Error : {}, while processing Business Data: {}".format(e, df_bu))


def update_bu_frequency(legacy_ban, frequency="Monthly"):
    """
    Update the frequency column for a given BU legacyBan in the AirControl DB.
    If a value is already present, it will not be updated.
    If no value is present, it will be updated to the provided frequency (default: "Monthly").

    :param legacy_ban: The legacyBan of the BU to update.
    :param frequency: The frequency value to set if not already present.
    """
    try:
        # SQL query to check if the frequency column has a value
        check_query = f"SELECT frequency FROM accounts WHERE legacy_ban = {legacy_ban};"
        result = sql_query_fetch(check_query, aircontrol_db_configs, logger_error)

        if result and result[0][0]:  # If frequency is already set, do not update
            logger_info.info(f"Frequency already set for legacyBan {legacy_ban}: {result[0][0]}")
        else:
            # SQL query to update the frequency column
            update_query = f"UPDATE accounts SET frequency = '{frequency}' WHERE legacy_ban = {legacy_ban};"
            execute_query(aircontrol_db_configs, update_query, logger_error)
            logger_info.info(f"Frequency updated to '{frequency}' for legacyBan {legacy_ban}")

    except Exception as e:
        print(f"Error updating frequency for legacyBan {legacy_ban}: {e}")
        logger_error.error(f"Error updating frequency for legacyBan {legacy_ban}: {e}")


def cc_onboarding(token):
    start_time = time.time()
    df_cc = read_table_as_df('cost_center_success',transformation_db_configs,logger_info, logger_error)
    print("df cc ",df_cc)
    df_cc = df_cc.replace([None, 'None'], '')
    df_cc = df_cc.fillna('')
    print("Length of Cost Center Unit Data", len(df_cc))
    logger_info.info("Length of Cost Center Unit Data : {}".format(len(df_cc)))
    
    uuids = df_cc['buAccountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    df_cc = df_cc.astype(str)
    df_cc['account_id'] = df_cc['buAccountId'].map(uuid_to_account_id)
    df_cc['account_id'] = df_cc['account_id'].fillna('')

    try:
        error_list = []
        success_list = []
        
        for index, row in df_cc.iterrows():
            if len(row['account_id']) != 0:
                cc_payload = cost_center_payload(row['account_id'],row,logger_error)
                success_dict,error_dict = initiate_api_call(cc_onboarding_url, cc_payload, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)

        success_df = pd.DataFrame(success_list)
        truncate_mysql_table(ingestion_db_configs, 'cost_center_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/cost_center_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'cost_center_success', logger_info,
                                         logger_error)
        error_df = pd.DataFrame(error_list)
        truncate_mysql_table(ingestion_db_configs, 'cost_center_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/cost_center_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'cost_center_failure', logger_info,
                                         logger_error)

        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Cost_Center', len(df_cc), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)
    except Exception as e:
        print("Error : {}, while processing cost center Data: {}".format(e, df_cc))
        logger_error.error("Error : {}, while processing cost center Data: {}".format(e, df_cc))


def create_role_access(token):
    start_time = time.time()
    df_role = read_table_as_df('role_success',transformation_db_configs,logger_info, logger_error)
    df_role = df_role.replace([None, 'None'], '')
    df_role = df_role.fillna('')
    print("Length of Role and Access Data : ", len(df_role))
    logger_info.info("Length of Role and Access Data : {}".format(len(df_role)))

    uuids = df_role['accountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    if uuid_to_account_id is not None:
        df_role = df_role.astype(str)
        df_role['account_id'] = df_role['accountId'].map(uuid_to_account_id)
        print(df_role['account_id'])
        df_role['account_id'] = df_role['account_id'].fillna('')

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index, row in df_role.iterrows():
                if len(row['account_id']) != 0:
                    role_payload = role_access_payload(row,logger_error,row['account_id'])
                    success_dict,error_dict = initiate_api_call(role_creation_url, role_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    print("Account Id : {} not Found for accountId {}".format(row['account_id'],row['accountId']))
                    logger_error.error("Account Id : {} not Found for accountId {}".format(row['account_id'],row['accountId']))
                    error_message = f"Account Id not Found for accountId {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list.append(error_dict)

            success_df = pd.DataFrame(success_list)
            success_df.fillna('', inplace=True)
            truncate_mysql_table(ingestion_db_configs, 'role_success', logger_error)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/role_success_{current_date_time_str_logs}.csv", index=False)
                insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'role_success', logger_info,
                                            logger_error)
            error_df = pd.DataFrame(error_list)
            error_df.fillna('', inplace=True)
            # error_df.drop('account_id', axis=1, inplace=True)
            truncate_mysql_table(ingestion_db_configs, 'role_failure', logger_error)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/role_error_{current_date_time_str_logs}.csv", index=False)
                insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'role_failure', logger_info,
                                            logger_error)

            end_time = round((time.time() - start_time), 2)
            print("Process execution time {} sec".format(end_time))
            insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                    'Role and Access', len(df_role), len(success_df),
                                    len(error_df),
                                    end_time, curr_date)
        except Exception as e:
            print("Error : {}, while processing Role and Access Data : {}".format(e, df_role))
            logger_error.error("Error : {}, while processing Role and Access Data : {}".format(e, df_role))

    else:
        print("Not a single accountId exist in table")
        logger_error.error("Not a single accountId exist in table")


def create_user(token):
    start_time = time.time()
    df_user = read_table_as_df('user_success',transformation_db_configs,logger_info, logger_error)
    df_user = df_user.replace([None, 'None'], '')
    df_user = df_user.fillna('')
    print("Length of User Data : ", len(df_user))
    logger_info.info("Length of User Data : {}".format(len(df_user)))

    uuids = df_user['accountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    df_user = df_user.astype(str)
    df_user['account_id'] = df_user['accountId'].map(uuid_to_account_id)
    df_user['account_id'] = df_user['account_id'].fillna('')

    try:
        error_list = []
        success_list = []
        for index, row in df_user.iterrows():
            rol_name = row['roleId'].split('_')[1]
            role_id_fetching = fetch_role_id(row['accountId'], rol_name)

            if (role_id_fetching is not None) and (len(row['account_id'])!=0):
                user_payload_data = user_payload(row,role_id_fetching,logger_error)
                success_dict,error_dict = initiate_api_call(user_onboarding_url, user_payload_data, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)
            else:
                if role_id_fetching is None:
                    print("Role Id : not Found for role_name {} & accountId {}".format(rol_name,row['accountId']))
                    logger_error.error("Role Id : not Found for role_name {} & accountId {}".format(rol_name,row['accountId']))
                    error_message = f"Role Id not Found for accountId {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list.append(error_dict)
                else:
                    print("Account Id : {} not Found for accountId {}".format(row['account_id'],row['accountId']))
                    logger_error.error("Account Id : {} not Found for accountId {}".format(row['account_id'],row['accountId']))
                    error_message = f"Account Id not Found for accountId {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list.append(error_dict)

        success_df = pd.DataFrame(success_list)
        success_df = success_df.where(pd.notnull(success_df), None)
        truncate_mysql_table(ingestion_db_configs, 'user_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/user_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'user_success', logger_info,
                                         logger_error)
        error_df = pd.DataFrame(error_list)
        error_df = error_df.where(pd.notnull(error_df), None)
        # Drop 'account_id' column if it exists
        # Check if 'account_id' exists in the DataFrame before dropping it
        if not error_df.empty and 'account_id' in error_df.columns:
            error_df.drop('account_id', axis=1, inplace=True)
        
        truncate_mysql_table(ingestion_db_configs, 'user_failure', logger_error)

        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/user_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'user_failure', logger_info,
                                         logger_error)

        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'User', len(df_user), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)
    except Exception as e:
        print("Error : {}, while processing User Data : {}".format(e, df_user))
        logger_error.error("Error : {}, while processing User Data : {}".format(e, df_user))


################### Apn #########################################################################################

def fetch_mno_account_id():
    querry = f"""SELECT id FROM accounts WHERE name='A1 Digital SIM management' AND type=2 AND deleted=0"""
    data = sql_query_fetch(querry, ac_db_configs, logger_error)
    print("data",data)
    if data:
        data = data[0][0]
        return data
    else:
        return None




def call_get_subnet_ip(token, api_url, subnet,isIpv6):
    """
    :param token: auth token
    :param api_url: url
    :param subnet: subnet_ip
    :return: It will return data
    """
    subnet_api_url = api_url + subnet + f"&isIpv6={isIpv6}"
    subnet_api_url = quote(subnet_api_url, safe=':/?&=')
    print("Get Subnet Api Url :", subnet_api_url)
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
    }

    response = requests.request("GET", subnet_api_url, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)
    # content = content['data']['data'][0]['description']
    data = content

    # print(data)
    logger_info.info("Get Subnet \n {} ".format(subnet_api_url))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("status {} content {}".format(response.status_code, content))


    print(f"\n -------{data}---------\n")
    if data:
        return data
    return None


def call_subnet(column_data,is_ipv6):
    subnet_ip = column_data.split()
    subnet_list = []
    for subnet in subnet_ip:        
        subnet = subnet.replace(',', '')
        data = call_get_subnet_ip(token,aircontrol_get_subnet_ip,subnet,is_ipv6)
        subnet_data = {"subnet":data['givenSubnet'],"startingIp":data['startingIP'],"endingIp":data['endingIP'],"noOfHost":data['noOfHosts'],"addressType":data['addressType']}
        subnet_list.append(subnet_data)
    return subnet_list


def create_apn(token):
    start_time = time.time()
    apn_df = read_table_as_df('apn_success',transformation_db_configs,logger_info, logger_error)
    apn_df = apn_df.replace([None, 'None'], '')
    apn_df = apn_df.fillna('')
    print("Length of apn file",len(apn_df))
    logger_info.info("Length of apn file {}".format(len(apn_df)))
    try:
        # Fetch existing APN_ID and APN_NAME from the database
        existing_apns_query = "SELECT APN_ID, APN_NAME FROM service_apn_details;"
        existing_apns = sql_query_fetch(existing_apns_query, aircontrol_db_configs, logger_error)

        # Create a dictionary for quick lookup
        existing_apns_dict = {str(apn_id): apn_name for apn_id, apn_name in existing_apns}

        # Filter out rows where APN_ID is already onboarded
        apn_df['is_onboarded'] = apn_df['apnId'].apply(lambda x: str(x) in existing_apns_dict)
        onboarded_apns = apn_df[apn_df['is_onboarded']]

        for index, row in onboarded_apns.iterrows():
            apn_id = row['apnId']
            apn_name = existing_apns_dict.get(str(apn_id), "Unknown")
            print(f"APN_ID {apn_id} is already onboarded with APN_NAME {apn_name}, hence no need to onboard again")
            logger_info.info(f"APN_ID {apn_id} is already onboarded with APN_NAME {apn_name} hence no need to onboard again")

        # Remove onboarded APNs from the DataFrame
        apn_df = apn_df[~apn_df['is_onboarded']]
        apn_df.drop(columns=['is_onboarded'], inplace=True)

        error_list = []
        success_list = []
        error_list_account_id = []
        account_id = fetch_mno_account_id()
        # opco_account_id = fetch_opco_account_id()
        print("opco account id",account_id)
        logger_info.info("opco account id {}".format(account_id))
        if account_id is not None:
            for index, row in apn_df.iterrows():
                # private - 1, public - 2
                if row['ipPoolAllocationType'] == 'static' and row['apnCategory'] == '2':
                    # print("hello static")
                    
                    ipv4_subnet_list = call_subnet(row['subnet'],'false') if len(row['subnet'])!=0 else '[]'
                    ipv6_subnet_list = call_subnet(row['subnetIpv6'],'true') if len(row['subnetIpv6'])!=0 else '[]'
                        
                    if ipv4_subnet_list or ipv6_subnet_list:
                    
                        ipv4_subnet_ip_list = json.dumps(ipv4_subnet_list)
                        ipv6_subnet_ip_list = json.dumps(ipv6_subnet_list)
                        apn_payload = create_apn_payload(row,account_id,ipv4_subnet_ip_list,ipv6_subnet_ip_list,logger_error)
                        success_dict,error_dict = initiate_api_apn_call(aircontrol_create_apn_new,apn_payload,token,account_id)
                        if success_dict is not None:
                            success_list.append(success_dict)
                        if error_dict is not None:
                            error_list.append(error_dict)
                    

                if row['ipPoolAllocationType'] == 'static' and row['apnCategory'] == '1':
                    # print("hello static")
                    
                    ipv4_subnet_list = call_subnet(row['subnet'],'false') if len(row['subnet'])!=0 else '[]'
                    print('ipv6 : ',row['subnetIpv6'])
                    ipv6_subnet_list = call_subnet(row['subnetIpv6'],'true') if len(row['subnetIpv6'])!=0 else '[]'
                        
                    if ipv4_subnet_list or ipv6_subnet_list:
                    
                        ipv4_subnet_ip_list = json.dumps(ipv4_subnet_list)
                        ipv6_subnet_ip_list = json.dumps(ipv6_subnet_list)
                        account_id_new = opco_account_id if private_shared_at_mno_flag == 'no' else account_id
                        apn_payload = create_apn_payload(row,account_id_new,ipv4_subnet_ip_list,ipv6_subnet_ip_list,logger_error)
                        success_dict,error_dict = initiate_api_apn_call(aircontrol_create_apn_new,apn_payload,token,account_id_new)
                        if success_dict is not None:
                            success_list.append(success_dict)
                        if error_dict is not None:
                            error_list.append(error_dict)
                
                        
                if row['ipPoolAllocationType'] == 'dynamic' and row['apnCategory'] == '2':
                    # print("hello dynamic")
                    
                    subnet_ip = row['subnet']
                    ipv6_subnet = row['subnetIpv6']
                    # subnet_ip_list = json.dumps(subnet_ip)
                    apn_payload = create_apn_payload(row, account_id,subnet_ip,ipv6_subnet,logger_error)
                    success_dict,error_dict = initiate_api_apn_call(aircontrol_create_apn_new, apn_payload, token, account_id)
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                    
                if row['ipPoolAllocationType'] == 'dynamic' and row['apnCategory'] == '1':
                    # print("hello dynamic")
                    
                    subnet_ip = row['subnet']
                    ipv6_subnet = row['subnetIpv6']
                    # subnet_ip_list = json.dumps(subnet_ip)
                    account_id_new = opco_account_id if private_shared_at_mno_flag == 'no' else account_id
                    apn_payload = create_apn_payload(row,account_id_new,subnet_ip,ipv6_subnet,logger_error)
                    success_dict,error_dict = initiate_api_apn_call(aircontrol_create_apn_new, apn_payload, token, account_id_new)
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                    
        else:
            print("MNO Id Not Found")
            logger_error.error("MNO Account Id Not Found")

        success_df = pd.DataFrame(success_list)
        print("Succcess df here for APN creation")
        print(success_df.to_string())
        truncate_mysql_table(ingestion_db_configs, 'apn_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/apn_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'apn_success', logger_info,
                                            logger_error)

        error_df = pd.DataFrame(error_list)
        # print("failure df here for APN creation")
        #print(error_df.to_string())        
        truncate_mysql_table(ingestion_db_configs, 'apn_failure', logger_error)
        if not error_df.empty:
            error_df.replace({np.nan: None}, inplace=True)
            error_df.to_csv(f"{logs_path}/apn_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'apn_failure', logger_info,
                                         logger_error)


        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Apn', len(apn_df), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)

        # account_id_error_df = pd.DataFrame(error_list_account_id)
        # if not account_id_error_df.empty:
        #     account_id_error_df.to_csv(f"{logs_path}/apn_account_id_error_{current_date_time_str_logs}.csv", index=False)

    except Exception as e:
        print("Error {} while processing apn creation file : {}".format(e,apn_df))
        logger_error.error("Error {} while processing apn creation file : {}".format(e,apn_df))


def create_sim_product(token):
    start_time = time.time()
    sim_product_df = read_table_as_df('sim_product_success',transformation_db_configs,logger_info, logger_error)
    sim_product_df = sim_product_df.replace([None, 'None'], '')
    sim_product_df = sim_product_df.fillna('')
    print("Length of apn file",len(sim_product_df))
    logger_info.info("Length of apn file {}".format(len(sim_product_df)))
    try:
        error_list = []
        success_list = []
        error_list_account_id = []
        account_id = fetch_mno_account_id()
        sim_customer_id = None 
        for index, row in sim_product_df.iterrows():     
            if account_id is not None:
                sim_product_type = add_sim_product_payload(row, account_id)
                json_obj_dict = None
                error_json_obj_dict = None
                status_code = None
                content = None
                try:
                    print("Sim Product Type Api Url : ", aircontrol_add_sim_product_type)
                    logger_info.info("Sim Product Type Api Url {}".format(aircontrol_add_sim_product_type))
                    status_code, content = initiate_call.call_api(
                        aircontrol_add_sim_product_type, sim_product_type, token, account_id)
                    print('Status Code : ', status_code)
                    response_data = json.loads(content.decode('utf-8'))
                    sim_customer_id = response_data['id']
                    print(response_data)
                    print("sim product customer id {}".format(sim_customer_id))
                    logger_info.info("sim product customer id {}".format(sim_customer_id))
                    logger_info.info(
                        "status {} content {} ".format(status_code, content))

                except Exception as e:
                    logger_error.error(
                        "status {} content {} error {}".format(status_code, content, e))

                if status_code is not None and content is not None:
                    try:
                        payload = json.dumps(sim_product_type)
                        if content.startswith(b'{'):
                            content_dict = json.loads(content.decode('utf-8'))
                            if status_code == 200:
                                json_obj_dict = json.loads(payload)
                                json_obj_dict.update(content_dict)
                                success_list.append(json_obj_dict)
                            else:
                                error_dict = {"errorMessage": content_dict.get("errorMessage", "Unknown error")}
                                error_json_obj_dict = json.loads(payload)
                                error_json_obj_dict.update(error_dict)
                                error_list.append(error_json_obj_dict)
                        else:
                            # Handling HTML response for error
                            error_message = "HTTP Status 400 – Bad Request"
                            error_dict = {"errorMessage": error_message}
                            error_json_obj_dict = json.loads(payload)
                            error_json_obj_dict.update(error_dict)
                            error_list.append(error_json_obj_dict)

                    except Exception as e:
                        error_dict = {"errorMessage": "error in calling API %s" % e}
                        error_json_obj_dict = json.loads(payload)
                        error_json_obj_dict.update(error_dict)
                        error_list.append(error_json_obj_dict)        
            else:
                print("MNO Id Not Found")
                logger_error.error("MNO Account Id Not Found")

        
########################## Assign Customer to SimProduct Type ##################################################    

        customer_reference_id = row['customers'].split(" ")
        if customer_reference_id and sim_customer_id is not None:
            customer_id_lst = []
            for customers in customer_reference_id:
                cu_account_id = ac_fetch_account_id(customers)
                if cu_account_id:
                    customer_id_lst.append(cu_account_id)
            
            print("Customer Id List : ", customer_id_lst)
            if customer_id_lst:  # Ensure list is not empty
                customer_id_result = ','.join(str(item) for item in customer_id_lst)
                assign_customer_url = aircontrol_assign_customer_sim_product + f'{sim_customer_id}/customer-accounts'
                assign_customer_payload = assign_customer_to_sim_product(customer_id_result)
                success_dict, error_dict = initiate_api_call(assign_customer_url, assign_customer_payload, token, account_id)
                
                if success_dict:
                    success_list.append(success_dict)
                if error_dict:
                    error_list.append(error_dict)
        else:
            if not customer_reference_id:
                print("No Customer Id Found for customers {}".format(customer_reference_id))
                logger_error.error("No Customer Id Found for customers {}".format(customer_reference_id))
                error_message = f"Account Id not Found for Reference {customer_reference_id}"
                error_dict = row.to_dict()
                error_dict['errorMessage'] = error_message
                error_list_account_id.append(error_dict)
            if sim_customer_id is None:
                print("Sim Customer Id :{} not Found".format(sim_customer_id))
                logger_error.error("Sim Customer Id :{} not Found".format(sim_customer_id))
                error_message = f"Sim Customer Id not Found for Reference {sim_customer_id}"
                error_dict = row.to_dict()
                error_dict['errorMessage'] = error_message
                error_list_account_id.append(error_dict)    

        success_df = pd.DataFrame(success_list)
        truncate_mysql_table(ingestion_db_configs, 'apn_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/apn_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'apn_success', logger_info,
                                            logger_error)

        error_df = pd.DataFrame(error_list)
        truncate_mysql_table(ingestion_db_configs, 'apn_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/apn_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'apn_failure', logger_info,
                                         logger_error)


        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Apn', len(sim_product_df), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)

        # account_id_error_df = pd.DataFrame(error_list_account_id)
        # if not account_id_error_df.empty:
        #     account_id_error_df.to_csv(f"{logs_path}/apn_account_id_error_{current_date_time_str_logs}.csv", index=False)

    except Exception as e:
        print("Error {} while processing apn creation file : {}".format(e,sim_product_df))
        logger_error.error("Error {} while processing apn creation file : {}".format(e,sim_product_df))


def report_subscriptions(token):
    start_time = time.time()
    df_report_subscriptions = read_table_as_df('report_subscriptions_success',transformation_db_configs,logger_info, logger_error)
    print("df_report_subscriptions ",df_report_subscriptions)
    df_report_subscriptions = df_report_subscriptions.replace([None, 'None'], '')
    df_report_subscriptions = df_report_subscriptions.fillna('')
    print("Length of Business Unit Data", len(df_report_subscriptions))
    logger_info.info("Length of Business Unit Data : {}".format(len(df_report_subscriptions)))
    uuids = df_report_subscriptions['accountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    if uuid_to_account_id is not None:
        df_report_subscriptions = df_report_subscriptions.astype(str)
        df_report_subscriptions['account_id'] = df_report_subscriptions['accountId'].map(uuid_to_account_id)
        print(df_report_subscriptions['account_id'])
        df_report_subscriptions['account_id'] = df_report_subscriptions['account_id'].fillna('')
    
    account_id = fetch_mno_account_id()
    # opco_account_id = fetch_opco_account_id()
    print("opco account id",account_id)
    logger_info.info("opco account id {}".format(account_id))
    df_report_subscriptions["account_id"] = account_id

    # df_report_subscriptions['reportSubscriptionDetails'] = df_report_subscriptions['reportSubscriptionDetails'].apply(json.loads)
    
    try:
        error_list = []
        success_list = []
        
        for index,row in df_report_subscriptions.iterrows():
            if len(str(row['account_id'])) != 0:
                report_subscription_payload = report_subscriptions_payload(row)
                success_dict,error_dict = initiate_api_call_report_subscription(report_subscripttions_url, report_subscription_payload, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)

        success_df = pd.DataFrame(success_list)
        truncate_mysql_table(ingestion_db_configs, 'report_subscriptions_success', logger_error)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/report_subscriptions_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'report_subscriptions_success', logger_info,
                                         logger_error)
        error_df = pd.DataFrame(error_list)
        truncate_mysql_table(ingestion_db_configs, 'report_subscriptions_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/report_subscriptions_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'report_subscriptions_failure', logger_info,
                                         logger_error)

        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Report Subscriptions', len(df_report_subscriptions), len(success_df),
                                  len(error_df),
                                  end_time, curr_date)
    except Exception as e:
        print("Error : {}, while processing Business Data: {}".format(e, df_report_subscriptions))
        logger_error.error("Error : {}, while processing Business Data: {}".format(e, df_report_subscriptions))


def get_ip_pool_range(token, api_url, retrieved_apn_id,request_ip_count):
    """
    :param token: auth token
    :param api_url: url
    :param retrieved_apn_id: apn id fetched from db
    :param request_ip_count: number of requested ip
    :return: data
    """

    token = f'Bearer {token}'
    
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
    }

    response = requests.request("GET", api_url, headers=headers, params={
        'apnId': retrieved_apn_id,
        'ipNumber': request_ip_count,
    }, verify=False)
    
    logger_info.info("Get Ip Pool \n {} ".format(api_url))
    
    print('Status Code',response.status_code)

    content = json.loads(response.content)
    # content = content['data']['data'][0]['description']
    data = content

    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("status {} content {}".format(response.status_code, content))


    print(f"\n -------{data}---------\n")
    if data:
        return data
    return None


def create_ip_pool(token:str) -> None:
    start_time = time.time()
    ip_pool_df = read_table_as_df('ip_pool_success',transformation_db_configs,logger_info, logger_error)
    ip_pool_df = ip_pool_df.replace([None, 'None'], '')
    ip_pool_df = ip_pool_df.fillna('')
    print("Length of ip pool file",len(ip_pool_df))
    logger_info.info("Length of ip pool file {}".format(len(ip_pool_df)))
    
    try:
        error_list = []
        success_list = []

        uuids = ip_pool_df['accountId'].tolist()
        uuid_to_account_id = ac_fetch_account_id(uuids)
        
        apnids = ip_pool_df['apnId'].tolist()
        apnid_to_apn_id = fetch_apn_id(apnids)
        
        ip_pool_df = ip_pool_df.astype(str)
        ip_pool_df['account_id'] = ip_pool_df['accountId'].map(uuid_to_account_id)
        ip_pool_df['account_id'] = ip_pool_df['account_id'].fillna('')
        
        ip_pool_df['apn_id'] = ip_pool_df['apnId'].map(apnid_to_apn_id)
        ip_pool_df['apn_id'] = ip_pool_df['apn_id'].fillna('')
        

        for index, row in ip_pool_df.iterrows():
            if len(row['account_id']) != 0 and len(row['apn_id']) != 0:
                ip_pool_range = get_ip_pool_range(token, aircontrol_create_ip_pool_range, row['apn_id'], row['requestedIps'])
                ip_pool_payload = create_ip_poll_payload(row, ip_pool_range)
                success_dict,error_dict = initiate_api_call(aircontrol_create_ip_pool, ip_pool_payload, token, '')
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)
            
            else:
                if len(row['account_id']) == 0:
                    error_message = f"Account Id not Found for accountId {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list.append(error_dict)
                else:
                    error_message = f"APN_ID not Found for APN_ID {row['APN_ID']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list.append(error_dict)

        
        success_df = pd.DataFrame(success_list)
        
        truncate_mysql_table(ingestion_db_configs, 'ip_pool_success', logger_error)

        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/ip_pool_success_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(success_df, ingestion_db_configs, 'ip_pool_success', logger_info,
                                            logger_error)

        error_df = pd.DataFrame(error_list)
        truncate_mysql_table(ingestion_db_configs, 'ip_pool_failure', logger_error)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/ip_pool_error_{current_date_time_str_logs}.csv", index=False)
            insert_batches_df_into_mysql(error_df, ingestion_db_configs, 'ip_pool_failure', logger_info,
                                         logger_error)


        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'loading_summary', logger_info, logger_error,
                                  'Ip Pool', len(ip_pool_df), len(success_df),
                                  len(error_df),
                                  end_time)

    except Exception as e:
        print("Error {} while processing ip pool creation file : {}".format(e,ip_pool_df))
        logger_error.error("Error {} while processing ip pool creation file : {}".format(e,ip_pool_df))


def upload_ip_assignment_file(token, account_id, file_path):
    """
    Upload IP assignment CSV file to the specified API endpoint.
    
    :param token: Bearer token for authentication
    :param account_id: Account ID to be used in headers
    :param file_path: Path to the IP assignment CSV file
    :return: Response from the API
    """
    
    # Prepare the headers
    headers = {
        'Authorization': f'Bearer {token}',
        'Connection': 'keep-alive',
        'X-Requested-With': 'XMLHttpRequest',
        'accountId': str(account_id),
    }
    
    # Prepare the multipart form data
    try:
        with open(file_path, 'rb') as file:
            files = {
                'file': (os.path.basename(file_path), file, 'text/csv')
            }
                        
            # Make the request
            response = requests.post(
                ip_assignment_file_upload, 
                headers=headers, 
                files=files, 
                verify=False
            )
        
        # Log the response
        print(f"Status Code: {response.status_code}")
        print(f"Response Content: {response.text}")
        
        return response
    
    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments

    for arg in sys.argv[1:]:
        token = get_user_token(username, password)
        print("token : ",token)

        if arg == "clear_loading_summary":
            print("clear loading summary")
            truncate_mysql_table(metadata_db_configs, 'loading_summary', logger_error)

        if arg == "ec":
            print("ec onboarding")
            ec_onboarding(token)

        if arg == "bu":
            print("bu onboarding")
            bu_onboarding(token)   

        if arg == "cc":
            print("cost center onboarding")
            cc_onboarding(token)

        if arg == "role_access":
            print("role access")
            create_role_access(token)

        if arg == "user":
            print("user creation")
            create_user(token)

        if arg == "apn":
            print("apn")
            create_apn(token)

        if arg == "report_subscriptions":
            print("report_subscriptions")
            report_subscriptions(token)
        
        if arg == "ip_pool":
            print("ip_pool")
            create_ip_pool(token)
        
        if arg == "ip_assignment":
            print("ip assignment")
            upload_ip_assignment_file(token, account_id_token, 'ip_assignment.csv')
