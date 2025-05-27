import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from conf.custom.apollo.config import *
from urllib.parse import urlencode,urlparse,parse_qs,quote
import requests
from pay_loads import *
from src.utils.library import *
today = datetime.now()
from src.utils.utils_lib import api_call,trim_data
initiate_call = api_call()
import urllib.parse
current_date_time_str_logs = today.strftime("%Y%m%d%H%M")
import xml.etree.ElementTree as ET

logs = {
    "migration_info_logger":f"stc_ingestion_aircontrol_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"stc_ingestion_aircontrol_error_{current_date_time_str_logs}.log"
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


def call_get_subnet_ip(token, api_url, subnet):
    """
    :param token: auth token
    :param api_url: url
    :param subnet: subnet_ip
    :return: It will return data
    """
    subnet_api_url = api_url + subnet
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

def get_ip_pool_range(token, api_url, retrieved_apn_id,request_ip_count):
    """
    :param token: auth token
    :param api_url: url
    :param retrieved_apn_id: apn id fetched from db
    :param request_ip_count: number of requested ip
    :return: data
    """
    get_ip_pool_url = api_url + f'{retrieved_apn_id}&ipNumber={request_ip_count}'
    subnet_api_url = quote(get_ip_pool_url, safe=':/?&=')
    print("Get Ip Pool Api Url :", subnet_api_url)
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
    }

    response = requests.request("GET", subnet_api_url, headers=headers, data=payload, verify=False)
    logger_info.info("Get Ip Pool \n {} ".format(subnet_api_url))
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

def fetch_opco_account_id():
    querry = f"""SELECT id FROM accounts WHERE name='KSA_OPCO' AND type=3 AND deleted=0"""
    data = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    print("data",data)
    if data:
        data = data[0][0]
        return data
    else:
        return None


def fetch_account_id(reference_number):
    """
    :param reference_number: reference number
    :return: account id
    """
    querry = f"""SELECT ID FROM accounts WHERE NOTIFICATION_UUID = '{reference_number}';"""
    # print('hello amit',reference_number)
    account_id = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        account_id = account_id[0][0]
        return account_id
    else:
        return None

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


def fetch_id_from_apn(apn_id):
    """
    :param apn_id:
    :return:
    """
    format_strings = ','.join(['%s'] * len(apn_id))
    querry = f"""SELECT APN_ID,ID FROM service_apn_assign_pool_allocation WHERE APN_ID IN ({format_strings});"""
    # print('hello amit',reference_number)
    apn_id_new = sql_data_fetch(querry,apn_id,aircontrol_db_configs, logger_error)
    print("Id : ", apn_id_new)
    if apn_id_new:
        apn_id_ac = {sorce_apn_id: str(apn_id) for sorce_apn_id, apn_id in apn_id_new}
        return apn_id_ac
    else:
        return None


def fetch_account_id_lead_creation():
    querry = f"""SELECT id FROM accounts WHERE name='STC_opco_static';"""
    account_id = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    print("account id : ", account_id)
    if account_id:
        account_id = account_id[0][0]
        return account_id
    else:
        return None

def fetch_role_id(notification_uuid, role_id):
    query = f"""SELECT id FROM role_access 
                WHERE Account_ID = (SELECT id FROM accounts WHERE Notification_UUID = '{notification_uuid}') 
                AND role_name LIKE '%{role_id}%' LIMIT 1;"""
    print("query : ",query)
    print("Role Name : ",role_id)
    role_id_new = sql_query_fetch(query, aircontrol_db_configs, logger_error)
    print("Role Id : ", role_id_new)
    if role_id_new:
        role_id_new = role_id_new[0][0]
        return role_id_new
    else:
        return None

def fetch_lead_person_id(lead_person_id):
    format_strings = ','.join(['%s'] * len(lead_person_id))
    querry = f"""SELECT USER_NAME,ID FROM users WHERE USER_NAME IN ({format_strings});"""
    print('Lead Person Id',lead_person_id)
    account_id = sql_data_fetch(querry,lead_person_id,aircontrol_db_configs, logger_error)
    
    if account_id:
        print("user id : ", account_id)
        # account_id = account_id[0][0]
        user_name_to_account_id = {user_name: str(accountid) for user_name, accountid in account_id}
        print("username : ",user_name_to_account_id)
        logger_info.info("username to account id : ".format(user_name_to_account_id))
        return user_name_to_account_id
    else:
        return None

def fetch_lead_person_role_id(role_name):
    querry = f"""SELECT ID FROM role_access WHERE Role_name = '{role_name}';"""
    # print('hello amit',reference_number)
    role_id = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    print("account id : ", role_id)
    if role_id:
        role_id = role_id[0][0]
        return role_id
    else:
        return None



#### New Fetch Account Id function Replace it with old fetch_account_id function when all entities will be uodated with new code #####

def ac_fetch_account_id(reference_number):
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



def initiate_api_call(api_url,payload,token,bu_account_id):
    initiate_call = api_call()

    json_obj_dict = None
    error_json_obj_dict = None
    status_code = None
    content = None
    try:
        status_code, content = initiate_call.call_api(
            api_url, payload, token, bu_account_id)
        print('Status Code : ',status_code)
        # print('AMIT',content)
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





def create_apn(token):

    apn_df = pd.read_csv(apn_csv_file_path, keep_default_na=False, dtype=str)
    print("Length of apn file",len(apn_df))
    logger_info.info("Length of apn file {}".format(len(apn_df)))
    try:
        error_list = []
        success_list = []
        error_list_account_id = []
        account_id = fetch_opco_account_id()
        print("opco account id",account_id)
        logger_info.info("opco account id {}".format(account_id))

        for index, row in apn_df.iterrows():
            # private - 1, public - 2
            if row['ipPoolAllocationType'] == 'static' and row['apnCategory'] == '2':
                # print("hello static")
                
                if account_id is not None:
                    subnet_ip = row['subnet'].split(" ")
                    subnet_list = []
                    for subnet in subnet_ip:
                        data = call_get_subnet_ip(token,aircontrol_get_subnet_ip,subnet)
                        subnet_data = {"subnet":data['givenSubnet'],"startingIp":data['startingIP'],"endingIp":data['endingIP'],"noOfHost":data['noOfHosts'],"addressType":data['addressType']}
                        subnet_list.append(subnet_data)

                    if subnet_list:
                        first_10_subnets = subnet_list[:10]
                        # Convert the first 10 dictionaries to JSON
                        subnet_ip_list = json.dumps(first_10_subnets)
                        apn_payload = create_apn_payload(row,account_id,subnet_ip_list)
                        success_dict,error_dict = initiate_api_call(aircontrol_create_apn_new,apn_payload,token,account_id)
                        if success_dict is not None:
                            success_list.append(success_dict)
                        if error_dict is not None:
                            error_list.append(error_dict)
                else:
                    print("Opco Id Not Found")
                    logger_error.error("Opco Id Not Found")

            if row['ipPoolAllocationType'] == 'static' and row['apnCategory'] == '1':
                # print("hello static")
                bu_account_id = fetch_account_id(row['BuReferenceNumber'])
                cu_account_id = fetch_account_id(row['CustomerReferenceNumber'])
                logger_info.info("bu_account_id {} cu_account_id {} ".format(bu_account_id,cu_account_id))
                if (bu_account_id is not None) and (cu_account_id is not None):
                    combined_id = str(bu_account_id) + ',' + str(cu_account_id)
                    print("Combined Id", combined_id)
                    subnet_ip = row['subnet'].split(" ")
                    subnet_list = []
                    for subnet in subnet_ip:
                        data = call_get_subnet_ip(token, aircontrol_get_subnet_ip, subnet)
                        subnet_data = {"subnet": data['givenSubnet'], "startingIp": data['startingIP'],
                                       "endingIp": data['endingIP'], "noOfHost": data['noOfHosts'],"addressType":data['addressType']}
                        subnet_list.append(subnet_data)
                        # subnet_list.append(data)
                    if subnet_list:
                        first_10_subnets = subnet_list[:10]
                        # Convert the first 10 dictionaries to JSON
                        subnet_ip_list = json.dumps(first_10_subnets)
                        apn_payload = create_apn_payload(row,combined_id,subnet_ip_list)
                        success_dict,error_dict = initiate_api_call(aircontrol_create_apn_new, apn_payload, token, '')
                        if success_dict is not None:
                            success_list.append(success_dict)
                        if error_dict is not None:
                            error_list.append(error_dict)
                else:
                    if bu_account_id is None:
                        print("BU Id {} Not Found for BuReference {}".format(bu_account_id, row['BuReferenceNumber']))
                        logger_error.error(
                            "BU Id {} Not Found for BuReference {}".format(bu_account_id, row['BuReferenceNumber']))

                        error_message = f"Account Id not Found for Reference {row['BuReferenceNumber']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
                    if cu_account_id is None:
                        print(
                            "CU Id {} Not Found for CustomerReference {}".format(cu_account_id,
                                                                                 row['CustomerReferenceNumber']))
                        logger_error.error("CU Id {} Not Found for CustomerReference {}".format(cu_account_id, row[
                            'CustomerReferenceNumber']))

                        error_message = f"Account Id not Found for Reference {row['CustomerReferenceNumber']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)

            if row['ipPoolAllocationType'] == 'dynamic' and row['apnCategory'] == '2':
                # print("hello dynamic")
                if account_id is not None:
                    subnet_ip = row['subnet']
                    # subnet_ip_list = json.dumps(subnet_ip)
                    apn_payload = create_apn_payload(row, account_id,subnet_ip)
                    success_dict,error_dict = initiate_api_call(aircontrol_create_apn_new, apn_payload, token, account_id)
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    print("Opco Id Not Found")
                    logger_error.error("Opco Id Not Found")

            if row['ipPoolAllocationType'] == 'dynamic' and row['apnCategory'] == '1':
                # print("hello dynamic")
                bu_account_id = fetch_account_id(row['BuReferenceNumber'])
                cu_account_id = fetch_account_id(row['CustomerReferenceNumber'])
                logger_info.info("bu_account_id {} cu_account_id {} ".format(bu_account_id,cu_account_id))
                if (bu_account_id is not None) and (cu_account_id is not None):
                    combined_id = str(bu_account_id) + ',' + str(cu_account_id)
                    print("Combined Id",combined_id)
                    subnet_ip = row['subnet']
                    # subnet_ip_list = json.dumps(subnet_ip)
                    apn_payload = create_apn_payload(row,combined_id,subnet_ip)
                    success_dict,error_dict = initiate_api_call(aircontrol_create_apn_new, apn_payload, token, combined_id)
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    if bu_account_id is None:
                        print("BU Id {} Not Found for BuReference {}".format(bu_account_id,row['BuReferenceNumber']))
                        logger_error.error("BU Id {} Not Found for BuReference {}".format(bu_account_id,row['BuReferenceNumber']))
                        error_message = f"Account Id not Found for Reference {row['BuReferenceNumber']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
                    if cu_account_id is None:
                        print(
                            "CU Id {} Not Found for CustomerReference {}".format(cu_account_id,row['CustomerReferenceNumber']))
                        logger_error.error("CU Id {} Not Found for CustomerReference {}".format(cu_account_id,row['CustomerReferenceNumber']))
                        error_message = f"Account Id not Found for Reference {row['CustomerReferenceNumber']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)

        success_df = pd.DataFrame(success_list)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/apn_success_{current_date_time_str_logs}.csv", index=False)
        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/apn_error_{current_date_time_str_logs}.csv", index=False)

        account_id_error_df = pd.DataFrame(error_list_account_id)
        if not account_id_error_df.empty:
            account_id_error_df.to_csv(f"{logs_path}/apn_account_id_error_{current_date_time_str_logs}.csv", index=False)

    except Exception as e:
        print("Error {} while processing apn creation file : {}".format(e,apn_df))
        logger_error.error("Error {} while processing apn creation file : {}".format(e,apn_df))


def sim_product_type(token):
    sim_product_df = pd.read_csv(sim_product_csv_file_path, keep_default_na=False, dtype=str)
    print("Length of Create Sim Product file", len(sim_product_df))
    logger_info.info("Length of Create Sim Product file : {}".format(len(sim_product_df)))
    try:
        account_id = fetch_opco_account_id()
        error_list = []
        success_list = []
        error_list_account_id = []
        
        for index, row in sim_product_df.iterrows():
            
            sim_customer_id = None
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
                            content_dict = None
                            content_dict = json.loads(content.decode('utf-8'))
                            # print("content dict 1",content_dict)
                            if status_code == 200:
                                json_obj_dict = json.loads(payload)
                                json_obj_dict.update(content_dict)
                                success_list.append(json_obj_dict)
                                # return json_obj_dict

                            else:
                                error_dict = {"errorMessage": content_dict["errorMessage"]}
                                error_json_obj_dict = json.loads(payload)
                                error_json_obj_dict.update(error_dict)
                                error_list.append(error_json_obj_dict)
                                # error_list_sim_onboarding_columns.append(json_obj_dict)
                                # return error_json_obj_dict
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
                print("Opco Id : {} Not Found".format(account_id))
                logger_error.error("Opco Id : {} Not Found".format(account_id))

            ########################## Assign Customer to SimProduct Type ##################################################
            customer_reference_id = row['customers'].split(" ")
            if customer_reference_id and sim_customer_id is not None:
                customer_id_lst = []
                for customers in customer_reference_id:
                    cu_account_id = fetch_account_id(customers)
                    customer_id_lst.append(cu_account_id)
                print("Customer Id List : ", customer_id_lst)
                customer_id_lst = [item for item in customer_id_lst if item is not None]
                customer_id_result = ','.join(str(item) for item in customer_id_lst)
                assign_customer_url = aircontrol_assign_customer_sim_product + f'{sim_customer_id}/customer-accounts'
                assign_customer_payload = assign_customer_to_sim_product(customer_id_result)
                success_dict,error_list = initiate_api_call(assign_customer_url, assign_customer_payload, token, account_id)
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)
            else:
                if customer_reference_id is None:
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
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/sim_product_success_{current_date_time_str_logs}.csv", index=False)
        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/sim_product_error_{current_date_time_str_logs}.csv",index=False)

        account_id_error_df = pd.DataFrame(error_list_account_id)
        if not account_id_error_df.empty:
            account_id_error_df.to_csv(f"{logs_path}/sim_product_account_id_error_{current_date_time_str_logs}.csv", index=False)

    except Exception as e:
        print("Error : {}, while processing sim product type file : {}".format(e, sim_product_df))
        logger_error.error("Error : {}, while processing sim product type file : {}".format(e, sim_product_df))


def lead_creation(token):
    lead_person_df = pd.read_csv(lead_person_csv_file_path, keep_default_na=False, dtype=str)
    print("Length of Lead Person file", len(lead_person_df))
    logger_info.info("Length of Lead Person file : {}".format(len(lead_person_df)))
    try:
        account_id = fetch_account_id_lead_creation()
        if account_id is not None:
            error_list = []
            success_list = []
            for index, row in lead_person_df.iterrows():
                role_id_fetching = fetch_lead_person_role_id(row['roleId'])
                payload_lead_person = lead_person_payload(row, account_id,role_id_fetching)
                success_dict,error_dict = initiate_api_call(aircontrol_api_url_users_creation, payload_lead_person, token, account_id)
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)

            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/lead_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/lead_error_{current_date_time_str_logs}.csv",index=False)

        else:
            print("Opco Id : {} Not Found".format(account_id))
            logger_error.error("Opco Id : {} Not Found".format(account_id))
    except Exception as e:
        print("Error : {}, while processing lead person file : {}".format(e, lead_person_df))
        logger_error.error("Error : {}, while processing lead person file : {}".format(e, lead_person_df))


def user_creation(token):

    user_creation_df = pd.read_csv(user_creation_csv_file_path, keep_default_na=False,dtype=str)
    print("Length of User Creation file", len(user_creation_df))
    logger_info.info("Length of User Creation file : {}".format(len(user_creation_df)))

    uuids = user_creation_df['accountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    user_creation_df['account_id'] = user_creation_df['accountId'].map(uuid_to_account_id)
    user_creation_df['account_id'] = user_creation_df['account_id'].fillna('')
    try:
        error_list = []
        success_list = []
        error_list_account_id = []
        for index, row in user_creation_df.iterrows():
            role_id_fetching = fetch_role_id(row['accountId'], row['roleId'])
            if (role_id_fetching is not None) and (len(row['account_id'])!=0):
                # print("KESAR",row['account_id'])
                user_creation_payload = create_user_payload(row, role_id_fetching)
                success_dict,error_dict = initiate_api_call(aircontrol_api_url_users_creation, user_creation_payload, token, row['account_id'])
                if success_dict is not None:
                    success_list.append(success_dict)
                if error_dict is not None:
                    error_list.append(error_dict)
            else:
                if role_id_fetching is None:
                    print("Role Id : {} not Found for role_id {}".format(role_id_fetching,
                                                                                            row['roleId']))
                    logger_error.error("Role Id : {} not Found for role_id {}".format(role_id_fetching,row['roleId']))
                    error_message = f"Role Id not Found for role_id {row['roleId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list_account_id.append(error_dict)
                if len(row['account_id'])==0:
                    print("Account Id : {} not Found for Reference {}".format(row['account_id'],row['accountId']))
                    logger_error.error("Account Id : {} not Found for Reference {}".format(row['account_id'],row['accountId']))
                    error_message = f"Account Id not Found for Reference {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list_account_id.append(error_dict)

        success_df = pd.DataFrame(success_list)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/user_success_{current_date_time_str_logs}.csv", index=False)
        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/user_error_{current_date_time_str_logs}.csv", index=False)

        account_id_error_df = pd.DataFrame(error_list_account_id)
        if not account_id_error_df.empty:
            account_id_error_df.to_csv(f"{logs_path}/user_account_id_error_{current_date_time_str_logs}.csv", index=False)
    except Exception as e:
        print("Error : {}, while processing user creation file : {}".format(e, user_creation_df))
        logger_error.error("Error : {}, while processing user creation file : {}".format(e, user_creation_df))



def account_onboarding(customer_onboarding_df):

    # customer_onboarding_df['alternateName'] = customer_onboarding_df['alternateName'].apply(trim_data)
    print("Length of Account Onboarding file", len(customer_onboarding_df))
    logger_info.info("Length of Account Onboarding file : {}".format(len(customer_onboarding_df)))


    uuids = customer_onboarding_df['leadPersonOrAccManagerID'].tolist()
    uuid_to_account_id = fetch_lead_person_id(uuids)

    def map_uuid_to_account_id(uuid):
        if uuid_to_account_id is None:
            return ''
        return uuid_to_account_id.get(uuid, '')

    customer_onboarding_df['lead_person_id'] = customer_onboarding_df['leadPersonOrAccManagerID'].apply(map_uuid_to_account_id)
    customer_onboarding_df['lead_person_id'] = customer_onboarding_df['lead_person_id'].fillna('')

    headers = {
        "Content-Type": "text/xml;charset=UTF-8",
        "SoapAction": "",
        'Authorization': f'Basic c3RjX2FkbWluOmdsb2JldG91Y2g=',
        "Accept-Encoding": 'gzip,deflate'
    }

    try:
        error_list = []
        success_list = []
        # Iterate over each row in the DataFrame
        for index, row in customer_onboarding_df.iterrows():
            # Create the SOAP body using the data from the CSV row
            customer_onboarding_payload = soap_api_customer_onbording_payload(row)
            # Send the SOAP request
            print("Soap Api payload : ",customer_onboarding_payload)
            logger_info.info("Soap Api payload : {}".format(customer_onboarding_payload))
            print("Soap api url : ",soap_api_url)
            logger_info.info("Soap api url {}".format(soap_api_url))
            print(headers)
            response = requests.post(soap_api_url, data=customer_onboarding_payload, headers=headers, verify=False)
            status_code = None
            content = None
            try:

                status_code = response.status_code
                content = response.text
                print(f'Response for row {index}:', content, "\n Status Code : ", status_code)
                logger_info.info("Customer Onboarding Response for row {}, content {}, status_code {} ".format(index,content,status_code))
            except Exception as e:
                print("Error : {}, while calling soap api".format(e))
                logger_error.error("Error : {}, while calling soap api".format(e))


            if isinstance(customer_onboarding_payload, bytes):
                customer_onboarding_payload = customer_onboarding_payload.decode('utf-8')
            if status_code is not None and content is not None:
                try:
                    root = ET.fromstring(content)
                    namespaces = {
                        'soapenv': 'http://schemas.xmlsoap.org/soap/envelope/',
                        'ns2': 'http://webservices.airlinq.com/'
                    }
                    response_data = {}
                    for customer_response in root.findall('.//ns2:createOnboardCustomerResponse', namespaces):
                        status = customer_response.find('.//return/status', namespaces)
                        if status is not None:
                            response_data['status'] = status.text
                    
                    if status_code == 200 and response_data.get('status') == 'SUCCESS':
                        success_list.append({**row.to_dict(), **response_data})
                    else:
                        error_message = response_data.get('errorMessage', "Unknown error")
                        error_list.append({**row.to_dict(), 'errorMessage': error_message})
                except ET.ParseError as e:
                    error_dict = {"errorMessage": "Error parsing XML: %s" % e}
                    error_list.append({**row.to_dict(), **error_dict})

        success_df = pd.DataFrame(success_list)
        if not success_df.empty:
            success_df.to_csv(f"{logs_path}/account_creation_success_{current_date_time_str_logs}.csv", index=False)
        error_df = pd.DataFrame(error_list)
        if not error_df.empty:
            error_df.to_csv(f"{logs_path}/account_creation_error_{current_date_time_str_logs}.csv",index=False)
        # Print completion message
        print('All SOAP requests have been sent.')

    except Exception as e:
        print("Error : {}, while processing account onboard file : {}".format(e, customer_onboarding_df))
        logger_error.error("Error : {}, while processing account onboard file : {}".format(e, customer_onboarding_df))




def create_ip_pool(token):
    ip_pool_df = pd.read_csv(ip_pool_file_path,keep_default_na=False, dtype=str)
    print("Length of Ip Pooling file", len(ip_pool_df))
    logger_info.info("Length of Ip Pooling file : {}".format(len(ip_pool_df)))

    new_df=ip_pool_df.copy()
    new_df =new_df.assign(BU_ID1=new_df['BU_ID'].str.split(',')).explode('BU_ID1')
    
    uuids = new_df['BU_ID1'].tolist()
    print("list",uuids)
    uuid_to_account_id = ac_fetch_account_id(uuids)
    print("uuo",uuid_to_account_id)
    apnids = ip_pool_df['APN_ID'].tolist()
    apnid_to_apn_id = fetch_apn_id(apnids)

    def map_bu_ids(bu_ids):
        if pd.isna(bu_ids):
            return ''
        # Split the input string by commas and take only the first element
        first_id = bu_ids.split(',')[0]
        # Map the first_id using the uuid_to_account_id dictionary
        mapped_id = uuid_to_account_id.get(first_id, '')
        return mapped_id
        
    
    if (uuid_to_account_id is not None) and (apnid_to_apn_id is not None):
        ip_pool_df['buAccount_id'] = ip_pool_df['BU_ID'].apply(map_bu_ids)
        ip_pool_df['buAccount_id'] = ip_pool_df['buAccount_id'].fillna('')

        ip_pool_df['ac_apn_id'] = ip_pool_df['APN_ID'].map(apnid_to_apn_id)
        ip_pool_df['ac_apn_id'] = ip_pool_df['ac_apn_id'].fillna('')
        ip_pool_df.to_csv("ip_pool.csv",index=False)

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in ip_pool_df.iterrows():
                if (len(row['ac_apn_id'])!=0) and (len(row['buAccount_id'])!=0):
                    ip_pool_range = get_ip_pool_range(token, aircontrol_api_get_ip_pool, row['ac_apn_id'], row['NUMBER_OF_REQUESTED_IPS'])
                    ip_pool_payload = create_ip_poll_payload(row,ip_pool_range)
                    success_dict,error_dict = initiate_api_call(aircontrol_api_create_ip_pool, ip_pool_payload, token, row['buAccount_id'])
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    if len(row['buAccount_id'])==0:
                        print("Account Id : {}, not Found in table for BU_ID {}".format(row['buAccount_id'],
                                                                                                row['BU_ID']))
                        logger_error.error("Account Id : {}, not Found in table for BU_ID : {}".format(row['buAccount_id'],
                                                                                                row['BU_ID']))
                                                                                                
                        error_message = f"Account Id not Found for Reference {row['BU_ID']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)

                    if len(row['ac_apn_id'])==0:
                        print("Apn Id : {}, not Found in table for APN_ID : {}".format(row['ac_apn_id'],
                                                                            row['APN_ID']))
                        logger_error.error("Apn Id : {}, not Found in table for APN_ID : {}".format(row['ac_apn_id'],
                                                                                        row['APN_ID']))
                                                                                    
                        error_message = f"Apn Id not Found for Reference {row['APN_ID']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/ip_pool_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/ip_pool_error_{current_date_time_str_logs}.csv", index=False)

            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/ip_pool_account_id_error_{current_date_time_str_logs}.csv", index=False)
        except Exception as e:
            print("Error : {}, while processing account onboard file : {}".format(e, ip_pool_df))
            logger_error.error("Error : {}, while processing account onboard file : {}".format(e, ip_pool_df))

    else:
        print("Not a single accountId and apnid exist in table")
        logger_error.error("Not a single accountId and apnid exist in table")

def create_cost_center(token):
    cost_center_df = pd.read_csv(cost_center_file_path,keep_default_na=False, dtype=str)
    print("Length of Cost Center file", len(cost_center_df))
    logger_info.info("Length of Cost Center file : {}".format(len(cost_center_df)))

    uuids = cost_center_df['buAccountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    if (uuid_to_account_id is not None):
        cost_center_df['buAccount_id'] = cost_center_df['buAccountId'].map(uuid_to_account_id)
        cost_center_df['buAccount_id'] = cost_center_df['buAccount_id'].fillna('')

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in cost_center_df.iterrows():

                if len(row['buAccount_id'])!=0:
                    cost_center_payload = create_cost_center_payload(row)
                    success_dict,error_dict = initiate_api_call(cost_center_api_url, cost_center_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    print("BU Id : {}, not Found in table for BU_ID {}".format(row['buAccount_id'],
                                                                                            row['buAccountId']))
                    logger_error.error("BU Id : {}, not Found in table for BU_ID : {}".format(row['buAccount_id'],
                                                                                            row['buAccountId']))

                    error_message = f"Account Id not Found for Reference {row['buAccountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list_account_id.append(error_dict)
            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/cost_center_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/cost_center_error_{current_date_time_str_logs}.csv", index=False)

            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/cost_center_account_id_error_{current_date_time_str_logs}.csv", index=False)

        except Exception as e:
            print("Error : {}, while processing cost center file : {}".format(e, cost_center_df))
            logger_error.error("Error : {}, while processing cost center file : {}".format(e, cost_center_df))

    else:
        print("Not a single accountId exist in table")
        logger_error.error("Not a single accountId exist in table")



def create_api_user(token):
    api_user_df = pd.read_csv(api_user_file_path,keep_default_na=False, dtype=str)
    print("Length of api_user file", len(api_user_df))
    logger_info.info("Length of api_user file : {}".format(len(api_user_df)))

    uuids = api_user_df['accountId'].tolist()
    uuid_to_account_id = ac_fetch_account_id(uuids)
    if (uuid_to_account_id is not None):
        api_user_df['account_id'] = api_user_df['accountId'].map(uuid_to_account_id)
        api_user_df['account_id'] = api_user_df['account_id'].fillna('')

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in api_user_df.iterrows():
                if len(row['account_id'])!=0:
                    new_api_user_payload = api_user_payload(row)
                    # Update the original payload with new values
                    # query_string = urllib.parse.urlencode(new_api_user_payload)
                    # print(query_string)
                    # success_dict,error_dict = initiate_api_call(api_user_api_url, query_string, token, '')
                    success_dict,error_dict = initiate_api_call(api_user_api_url, new_api_user_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    print("Account Id : {}, not Found in table for UUID {}".format(row['account_id'],
                                                                                            row['accountId']))
                    logger_error.error("Account Id : {}, not Found in table for UUID : {}".format(row['account_id'],
                                                                                            row['accountId']))
                    error_message = f"Account Id not Found for Reference {row['accountId']}"
                    error_dict = row.to_dict()
                    error_dict['errorMessage'] = error_message
                    error_list_account_id.append(error_dict)

            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/api_user_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/api_user_error_{current_date_time_str_logs}.csv", index=False)
            
            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/api_user_account_id_error_{current_date_time_str_logs}.csv", index=False)

        except Exception as e:
            print("Error : {}, while processing Api_user file : {}".format(e, api_user_df))
            logger_error.error("Error : {}, while processing Api_user file : {}".format(e, api_user_df))
    else:
        print("Not a single accountId exist in table")
        logger_error.error("Not a single accountId exist in table")



def create_apn_assign(token):
    apn_assign_df = pd.read_csv(apn_assign_file_path,keep_default_na=False, dtype=str)
    print("Length of apn_assign file", len(apn_assign_df))
    logger_info.info("Length of apn_assign file : {}".format(len(apn_assign_df)))
    
    new_df=apn_assign_df.copy()
    new_df =new_df.assign(BU_ID=new_df['accountBuId'].str.split(',')).explode('BU_ID')
    
    uuids = new_df ['BU_ID'].tolist()
    print("list",uuids)
    uuid_to_account_id = ac_fetch_account_id(uuids)
    print("uuo",uuid_to_account_id)
    apnids = apn_assign_df['apnId'].tolist()
    print("appnidsf",apnids)
    apnid_to_apn_id = fetch_apn_id(apnids)
   
    def map_bu_ids(bu_ids):
        if pd.isna(bu_ids):
            return ''
        ids = bu_ids.split(',')
        mapped_ids = [uuid_to_account_id.get(uid, '') for uid in ids]
        return ','.join(mapped_ids)
    print("helr",apnid_to_apn_id)
    if (uuid_to_account_id is not None) and (apnid_to_apn_id is not None):
        print('assign apn list',apn_assign_df['apnId'])
        apn_assign_df['ac_apn_id'] = apn_assign_df['apnId'].map(apnid_to_apn_id)
        print(apn_assign_df)
        # print('apn_assign_df',apn_assign_df['ac_apn_id'])
        apn_assign_df['ac_apn_id'] = apn_assign_df['ac_apn_id'].fillna('')
        apn_assign_df['buAccount_id'] = apn_assign_df['accountBuId'].apply(map_bu_ids)
        apn_assign_df['buAccount_id'] = apn_assign_df['buAccount_id'].fillna('')
        apn_assign_df.to_csv("hello2.csv",index=False)

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in apn_assign_df.iterrows():
                if (len(row['ac_apn_id'])!=0):
                    apn_assign_payload = apn_assing_payload(row)
                    print(apn_assign_payload)
                    success_dict,error_dict = initiate_api_call(apn_assign_api_url, apn_assign_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                    pass
                else:
                    if len(row['buAccount_id'])==0:
                        print("Account Id : {}, not Found in table for accountBuId {}".format(row['buAccount_id'],
                                                                                                row['accountBuId']))
                        logger_error.error("Account Id : {}, not Found in table for accountBuId: {}".format(row['buAccount_id'],
                                                                                                row['accountBuId']))

                        error_message = f"Account Id not Found for Reference {row['accountBuId']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
                    if len(row['ac_apn_id'])==0:
                        print("Apn Id : {}, not Found in table for APN_ID : {}".format(row['ac_apn_id'],
                                                                            row['apnId']))
                        logger_error.error("Apn Id : {}, not Found in table for APN_ID : {}".format(row['ac_apn_id'],
                                                                                        row['apnId']))
                        error_message = f"Apn Id not Found for Reference {row['accountBuId']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/apn_assign_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/apn_assign_error_{current_date_time_str_logs}.csv", index=False)

            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/apn_assign_account_id_error_{current_date_time_str_logs}.csv", index=False)
        except Exception as e:
            print("Error : {}, while processing account onboard file : {}".format(e, apn_assign_df))
            logger_error.error("Error : {}, while processing account onboard file : {}".format(e, apn_assign_df))

    else:
        print("Not a single accountId and apnid exist in table")
        logger_error.error("Not a single accountId and apnid exist in table")



def create_ip_pooling_assign(token):
    ip_pooling_df = pd.read_csv(ip_pooling_assign_file_path,keep_default_na=False, dtype=str)
    print("Length of ip_pooling_assign file", len(ip_pooling_df))
    logger_info.info("Length of ip_pooling_assign file : {}".format(len(ip_pooling_df)))
    
    new_df=ip_pooling_df.copy()
    new_df =new_df.assign(BU_ID1=new_df['BU_ID'].str.split(',')).explode('BU_ID')

    uuids = new_df['BU_ID1'].tolist()
    # print("list",uuids)
    uuid_to_account_id = ac_fetch_account_id(uuids)
    apnids = ip_pooling_df['APN_ID'].tolist()
    apnid_to_apn_id = fetch_apn_id(apnids)
    def map_bu_ids(bu_ids):
        if pd.isna(bu_ids):
            return ''
        ids = bu_ids.split(',')
        mapped_ids = [uuid_to_account_id.get(uid, '') for uid in ids]
        return ','.join(mapped_ids)
   
    if (uuid_to_account_id is not None) and (apnid_to_apn_id is not None):
        ip_pooling_df['buAccount_id'] = ip_pooling_df['BU_ID'].apply(map_bu_ids)
        ip_pooling_df['buAccount_id'] = ip_pooling_df['buAccount_id'].fillna('')
        
        
        ip_pooling_df['ac_apn_id'] = ip_pooling_df['APN_ID'].map(apnid_to_apn_id)
        ip_pooling_df['ac_apn_id'] = ip_pooling_df['ac_apn_id'].fillna('')
       
        ids = ip_pooling_df['APN_ID'].tolist()
        get_id_to_apn_id = fetch_id_from_apn(ids)
        ip_pooling_df['allocation_id'] = ip_pooling_df['ac_apn_id'].map(get_id_to_apn_id)
        ip_pooling_df['allocation_id'] = ip_pooling_df['allocation_id'].fillna('')
        

        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in ip_pooling_df.iterrows():
                if (len(row['buAccount_id'])!=0) and (len(row['allocation_id'])!=0):
                    ip_pooling_assign_api_url1=f"{ip_pooling_assign_api_url}allocationId={row['allocation_id']}&accountBuId={row['buAccount_id']}"
                    ip_pooling_assign_payload = ip_pooling_assing_payload()
                    print(ip_pooling_assign_payload)
                    success_dict,error_dict = initiate_api_call(ip_pooling_assign_api_url1, ip_pooling_assign_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                    if len(row['buAccount_id'])==0:
                        print("Account Id : {}, not Found in table for Bu_Id {}".format(row['buAccount_id'],
                                                                                                row['BU_ID']))
                        logger_error.error("Account Id : {}, not Found in table for Bu_Id: {}".format(row['buAccount_id'],
                                                                                                row['BU_ID']))
                        error_message = f"Account Id not Found for Reference {row['BU_ID']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
                    if len(row['allocation_id'])==0:
                        print("allocation_id Id : {}, not Found in table for ac_apn_id : {},when apn_id is :{} ".format(row['allocation_id'],row['ac_apn_id'],
                                                                            row['apnId']))
                        logger_error.error("allocation_id Id : {}, not Found in table for ac_apn_id : {},when apn_id is :{} ".format(row['allocation_id'],
                                                                                        row['ac_apn_id'],row['apnId']))

                        error_message = f"allocation Id not Found when apn_id is {row['apnId']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)
                        
            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/ip_pooling_assign_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/ip_pooling_assign_error_{current_date_time_str_logs}.csv", index=False)
            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/ip_pooling_assign_account_id_error_{current_date_time_str_logs}.csv", index=False)
        except Exception as e:
            print("Error : {}, while processing account onboard file : {}".format(e, ip_pooling_df))
            logger_error.error("Error : {}, while processing account onboard file : {}".format(e, ip_pooling_df))

    else:
        print("Not a single accountId and apnid exist in table")
        logger_error.error("Not a single accountId and apnid exist in table")







def create_white_listing(token):
    white_listing_df = pd.read_csv(white_listing_file_path,keep_default_na=False, dtype=str)
    # Parse the JSON strings in the ipwhitelistingMapping column
    white_listing_df['ipWhitelistingMapping'] = white_listing_df['ipWhitelistingMapping'].apply(json.loads)

    # Group by policy_id and aggregate account_id and customer, and combine ipwhitelistingMapping
    result_df = white_listing_df.groupby('policy_id').agg({
        'account_id': 'first',
        'customer': 'first',
        'ipWhitelistingMapping': list
    }).reset_index()

    # result_df.to_csv('ip_whitelist.csv',index=False)
    print(result_df)
    print("Length of white_listing file", len(white_listing_df))
    logger_info.info("Length of white_listing file : {}".format(len(white_listing_df)))

    uuids = result_df['account_id'].tolist()
    # print('AMIT',uuids)
    uuid_to_account_id = ac_fetch_account_id(uuids)
    uuids_customer = result_df['customer'].tolist()
    uuid_to_customer_id = ac_fetch_account_id(uuids_customer)
    if (uuid_to_account_id is not None) and (uuids_customer is not None):
        result_df['new_account_id'] = result_df['account_id'].map(uuid_to_account_id).fillna('')
        result_df['customer_id'] = result_df['customer'].map(uuid_to_customer_id).fillna('')
        try:
            error_list = []
            success_list = []
            error_list_account_id = []
            for index,row in result_df.iterrows():
                if len(row['account_id']) !=0:
                    ip_whitelist_payload = white_listing_payload(row)
                    # print(ip_whitelist_payload)
                    success_dict,error_dict = initiate_api_call(white_listing_api_url, ip_whitelist_payload, token, '')
                    if success_dict is not None:
                        success_list.append(success_dict)
                    if error_dict is not None:
                        error_list.append(error_dict)
                else:
                        print("Account Id : {}, not Found in table for accountId {}".format(row['account_id'],
                                                                                                row['accountId']))
                        logger_error.error("Account Id : {}, not Found in table for accountId : {}".format(row['account_id'],
                                                                                                row['accountId']))
                        error_message = f"Account Id not Found for Reference {row['accountId']}"
                        error_dict = row.to_dict()
                        error_dict['errorMessage'] = error_message
                        error_list_account_id.append(error_dict)

            success_df = pd.DataFrame(success_list)
            if not success_df.empty:
                success_df.to_csv(f"{logs_path}/white_listing_success_{current_date_time_str_logs}.csv", index=False)
            error_df = pd.DataFrame(error_list)
            if not error_df.empty:
                error_df.to_csv(f"{logs_path}/white_listing_error_{current_date_time_str_logs}.csv", index=False)

            account_id_error_df = pd.DataFrame(error_list_account_id)
            if not account_id_error_df.empty:
                account_id_error_df.to_csv(f"{logs_path}/white_listing_account_id_error_{current_date_time_str_logs}.csv", index=False)

        except Exception as e:
            print("Error : {}, while processing white_listing file : {}".format(e, white_listing_df))
            logger_error.error("Error : {}, while processing white_listing file : {}".format(e, white_listing_df))
    else:
        print("Not a single accountId and customerid exist in table")
        logger_error.error("Not a single accountId and customerid exist in table")

    

if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments

    segment_code_mapping = {
    'B1':'G1',
    'B2':'G2',
    'B3':'G3',
    'MB':'LB'
    }

    for arg in sys.argv[1:]:
        token = get_user_token(username, password)
        if arg == "apn":
            print("apn")
            create_apn(token)

        if arg == "apn_assign":
            print("apn_assign")
            create_apn_assign(token)    

        if arg == "ip_pooling_assign":
            print("ip_pooling_assign")
            create_ip_pooling_assign(token)    
        
        if arg == "sim_product_type":
            print("sim_product_type")
            sim_product_type(token)

        if arg == "lead":
            print("lead person")
            lead_creation(token)

        if arg == "user":
            print("user creation")
            user_creation(token)

        if arg == "ec":
            print("account onboarding")
            customer_onboarding_df = pd.read_csv(account_onboarding_csv_file_path, keep_default_na=False,dtype=str)
            customer_onboarding_df['customerSegmentCode'] = customer_onboarding_df['customerSegmentCode'].apply(lambda x: segment_code_mapping.get(x, x))
            customer_onboarding_df['alternateName'] = customer_onboarding_df['alternateName'].apply(trim_data)
            customer_onboarding_df['billingAccountName'] = customer_onboarding_df['billingAccountName'].apply(trim_data)
            # print(customer_onboarding_df.columns)
            enterpries_customer_df=customer_onboarding_df.drop_duplicates(subset='customerReferenceNumber',keep='first')
            bu_unit_df=customer_onboarding_df[~customer_onboarding_df.index.isin(enterpries_customer_df.index)]
            enterpries_customer_df.to_csv(f"{output_file_base_dir}/enterpries_customer_df.csv",index=False)
            bu_unit_df.to_csv(f"{output_file_base_dir}/bu_unit_df.csv",index=False)
            account_onboarding(enterpries_customer_df)

        if arg == "bu":
            # time.sleep(10)
            bu_unit_df = pd.read_csv(bu_file_path,keep_default_na=False)
            print(bu_unit_df)
            account_onboarding(bu_unit_df)


        if arg == "ip_pool":
            print("Ip Pool Creation")
            create_ip_pool(token)

        if arg == "cost_center":
            print("cost center creation")
            create_cost_center(token)

        if arg == "api_user":
            print("Api user creation")
            create_api_user(token)
            
        if arg == "white_listing":
            print("Ip white_listing creation")
            create_white_listing(token)
        if arg == "some":
            print("apn")
            create_apn(token)
            print("apn_assign")
            create_apn_assign(token) 
            print("sim_product_type")
            sim_product_type(token)
            print("Api user creation")
            create_api_user(token)


