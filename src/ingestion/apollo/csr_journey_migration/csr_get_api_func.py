import sys
sys.path.append("..")

from conf.custom.apollo.config import *
from urllib.parse import urlencode,urlparse,parse_qs,quote
import requests
from pay_loads import *
from src.utils.library import *
from conf.config import *


dir_path = dirname(abspath(__file__))

from src.utils.utils_lib import api_call,random_number
today = datetime.now()
# print(today)

current_date_time_str_logs = today.strftime("%Y%m%d%H%M")


logs = {
    "migration_info_logger":f"stc_ingestion_csr_journey_info_{current_date_time_str_logs}.log",
    "migration_error_logger":f"stc_ingestion_csr_journey_error_{current_date_time_str_logs}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

success_file_path = os.path.join(dir_path,'api_success_entries')
failure_file_path = os.path.join(dir_path,'api_failed_entries')

def convert_dataframe_to_dict(dict, df):
    """
    dict : it will take empty dictionary
    df: the dataframe which is to be converted to dictionary
    """
    for index, row in df.iterrows():
        device_plan = row["SERVICE_PROFILE_ID"]
        data_dict = row.to_dict()
        dict[device_plan] = {
            "data": data_dict,
        }

def urlencoded_to_json(payload_encoded):
    # Parse URL-encoded payload into dictionary
    payload_decoded = parse_qs(payload_encoded)
    payload_json = {}
    for key, value in payload_decoded.items():
        payload_json[key] = value[0] if len(value) == 1 else value
    return payload_json


def ensure_json(data):
    try:
        # Try to parse the data as JSON
        json_data = json.loads(data)
        return data  # It is already JSON, return as is
    except (TypeError, json.JSONDecodeError):
        # If parsing fails, convert to JSON
        return json.dumps(data)



def csr_get_price_model_id(token,csr_get_price_model_url,roam_price_model_name):

    # csrGetPriceModelUrl = csr_get_price_model_url + f"offset=0&limit=20&searchValue={roam_price_model_name}&condition="
    csrGetPriceModelUrl = csr_get_price_model_url + f"offset=0&limit=20&condition=&searchValue={roam_price_model_name}"
    csrGetPriceModelUrl = quote(csrGetPriceModelUrl, safe=':/?&=')
    print("Journey Url : ",csrGetPriceModelUrl)
    payload={}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-user-id': 'AB',
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrGetPriceModelUrl, headers=headers, data=payload, verify = False)

    print(response.status_code)

    content = json.loads(response.content)

    logger_info.info("PC Get price model id api_url \n {} ".format(csrGetPriceModelUrl))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("Get price model id status {} content {}".format(response.status_code, content))

    # print("Get Whole Sale Plan List :",data)

    data = content
    if data is not None:
        id = data["data"][0]["id"]
        zone_id = data["data"][0]["zone"]
        print(f"\n -------{data}---------\n")

        return id,zone_id

# def api_validate_user_csr( username, password):


#       payload=f"username={username}&password={password}"
#       headers = {
#         'Content-Type': 'application/x-www-form-urlencoded'
#       }
#       url = api_validate_url

#       token = None

#       try:
#           response = requests.request("POST", url, headers=headers, data=payload, verify = False)

#           print(response.status_code)
#           #print(response.content)

#           token = json.loads(response.content)
#           print(token)

#           token = token["token"]

#           logger_info.info("Token : {}".format(token))

#       except Exception as e:
#           print("Token API Error : {}".format(e))
#           logger_error.error("Token API Error : {}".format(e))

#       return token



def fetch_account_id_cu(accountName):
    querry = f"""select id from accounts where LEGACY_BAN = '{accountName}' and TYPE = 4 and LOCKED != 1 and DELETED != 1;"""
    data = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    if data:
        data = data[0][0]
        return data
    return None

def fetch_account_id_bu(accountName):
    querry = f"""select id from accounts where LEGACY_BAN = '{accountName}' and TYPE = 5 and LOCKED != 1 and DELETED != 1;"""
    data = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
    if data:
        data = data[0][0]
        return data
    return None


def csr_get_price_model_id(token, csr_get_price_model_url, roam_price_model_name):
    csrGetPriceModelUrl = csr_get_price_model_url + f"offset=0&limit=20&searchValue={roam_price_model_name}&condition="
    csrGetPriceModelUrl = quote(csrGetPriceModelUrl, safe=':/?&=')
    print("Journey Url : ", csrGetPriceModelUrl)
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrGetPriceModelUrl, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)

    logger_info.info("PC Get price model id api_url \n {} ".format(csrGetPriceModelUrl))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("Get price model id status {} content {}".format(response.status_code, content))

    # print("Get Whole Sale Plan List :",data)

    data = content
    if data is not None:
        id = data["data"][0]["id"]
        zone_id = data["data"][0]["zone"]
        print(f"\n -------{data}---------\n")

        return id, zone_id


def api_validate_user_csr(username, password):
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



    except Exception as e:
        print("Token API Error : {}".format(e))
        logger_error.error("Token API Error : {}".format(e))

    return token


# def fetch_account_id(accountName):
#     querry = f"""select id from accounts where NAME = '{accountName}';"""
#     data = sql_query_fetch(querry, aircontrol_db_configs, logger_error)
#     data = data[0][0]
#     return data




def product_catalogue_accountplan(tariffPlan, product_catalogue_accountplan_url, account_id, apnType, token):
    product_catalogue_accountplan_url = product_catalogue_accountplan_url + f"tariffPlan={tariffPlan}&apnType={apnType}"
    product_catalogue_accountplan_url = quote(product_catalogue_accountplan_url, safe=':/?&=')

    # product_catalogue_accountplan_url = product_catalogue_accountplan_url + f"tariffPlan={tariffPlan}"
    print(product_catalogue_accountplan_url)
    payload = {}
    token = f'Bearer {token}'

    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-id': 'BIPUL',
        'x-user-opco': account_id_token,
    }

    accountPlan = None
    accountPlan_desc = None
    tariff_plan_id = None
    account_plan_id = None
    try:
        response = requests.request("GET", product_catalogue_accountplan_url, headers=headers, data=payload,
                                    verify=False)

        print(response.status_code)

        content = json.loads(response.content)
        if content is not None:
            accountPlan = content['data']['data']
            if accountPlan:
                accountPlan_desc = accountPlan[0]['description']
                tariff_plan_id = accountPlan[0]['tariffPlanId']
                account_plan_id = accountPlan[0]['templateId']
                logger_info.info(" Product Catalogue Account Plan api_url \n {} ".format(product_catalogue_accountplan_url))
                # logger_info.info("payload \n {} ".format(payload))
                logger_info.info("status {} content {}".format(response.status_code, content))
                logger_info.info(
                    "Product Catalogue accountPlan data {} account_plan_name {} ".format(accountPlan, accountPlan_desc))
                return accountPlan, accountPlan_desc, tariff_plan_id,account_plan_id
        
    except Exception as e:
        print("PC AccountPlan API Error : {}".format(e))
        logger_error.error("PC AccountPlan API Error : {}".format(e))

    return accountPlan, accountPlan_desc, tariff_plan_id, account_plan_id


def csrWholeSalePlan(token, csrDevicePlanAccountPlanUrl, plan_name, account_id):
    csrDevicePlanAccountPlanUrl = csrDevicePlanAccountPlanUrl + f"offset=0&limit=20&searchValue={plan_name}&condition="
    # csrDevicePlanAccountPlanUrl = csrDevicePlanAccountPlanUrl + f"offset=0&limit=20&searchValue={plan_name}&accountId={account_id}&condition="
    csrDevicePlanAccountPlanUrl = quote(csrDevicePlanAccountPlanUrl, safe=':/?&=')

    print("Journey Url : ", csrDevicePlanAccountPlanUrl)
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-id': 'AB',
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrDevicePlanAccountPlanUrl, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)
    logger_info.info("PC Whole Sale Plan Content {}".format(content))
    # print("Get Whole Sale Plan List :",data)
    logger_info.info("Product Catalogue Wholesale Plan api_url \n {} ".format(csrDevicePlanAccountPlanUrl))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("status {} content {}".format(response.status_code, content))

    data = content
    print("Whole Sale Plan",data)
    if data is not None:
        csr_id = data["data"][0]["metaData"]["csrId"]
        meta_data = data["data"][0]["metaData"]
        print(f"\n -------{data}---------\n")

        return csr_id, meta_data


def csrDevicePlanAccountPlan(token, csrDevicePlanAccountPlanUrl, accountPlan_desc, device_plan_desc):
    csrDevicePlanAccountPlanUrl = csrDevicePlanAccountPlanUrl + accountPlan_desc
    # csrDevicePlanAccountPlanUrl = quote(csrDevicePlanAccountPlanUrl, safe=':/?&=')
    print("CSR PC Device Plan :", csrDevicePlanAccountPlanUrl)
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-id': 'AB',
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrDevicePlanAccountPlanUrl, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)
    # content = content['data']['data'][0]['description']
    data = content
    if data is not None:
        data = data["data"]["data"]
        # print(data)
        logger_info.info("PC Device Plan api_url \n {} ".format(csrDevicePlanAccountPlanUrl))
        # logger_info.info("payload \n {} ".format(payload))
        logger_info.info("status {} content {}".format(response.status_code, content))
        logger_info.info("CSR Device Plan Account Plan Content {}".format(data))

        print(f"\n -------{data}---------\n")
        print("desc", device_plan_desc)
        for lst in data:
            print("--------------------------")
            if lst["planDesc"] == device_plan_desc.strip():
                # print(lst)
                return lst
    return None


def csrAddOnPlanAccountPlan(token, csrAddOnPlanAccountPlanUrl, accountPlanType):
    csrAddOnPlanAccountPlanUrl = csrAddOnPlanAccountPlanUrl + accountPlanType
    # csrAddOnPlanAccountPlanUrl = quote(csrAddOnPlanAccountPlanUrl, safe=':/?&=')
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-id': 'AB',
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrAddOnPlanAccountPlanUrl, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)
    print('addon content : ', content)
    # disc = content['data']['data'][0]['description']
    # print("disco ++++++++++", disc)
    data = content

    logger_info.info("Product Catalogue AddOn Plan api_url \n {} ".format(csrAddOnPlanAccountPlanUrl))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("status {} content {}".format(response.status_code, content))

    if data["data"]["data"]:
        print(data["data"]["data"])

        data = data["data"]["data"]
        # print(len(data))
        # print(data)
        return data
    return None


def tarrif_plan(token, tariffPlanId):
    payload = {}
    # account_id = 3
    token = f'Bearer {token}'
    headers = {
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
        'Content-Type': 'application/json',
        'accountId': account_id_token,
        'x-user-id': 'AA',
        'x-user-opco': account_id_token
    }
    print(product_catalogue_tarrifplan_url)
    print("Headers",headers)
    response = requests.request("GET", product_catalogue_tarrifplan_url, headers=headers, data=payload, verify=False)

    content = response.content
    data = json.loads(content.decode('utf-8'))
    data = data["data"]["data"]
    logger_info.info(" Product Catalogue Tariff Plan api_url \n {} ".format(product_catalogue_tarrifplan_url))
    logger_info.info("status {} content {}".format(response.status_code, content))
    # print(data)
    for lst in data:
        if lst["name"] == tariffPlanId:
            return lst

    # print(data["data"]["data"])
    return None


def get_apn_list(token, account_id, apnName,apn_category,tariff_plan_id):
    url = apn_list_url + str(account_id) + f'&apnCategory={apn_category}&tarrifPlanId={tariff_plan_id}'
    # account_id = f"'{account_id}'"
    # url = quote(url, safe=':/?&=')
    payload = {}
    print(url)
    headers = {
        'Accept': 'application/json, text/plain, */*',
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json',
        'Language': 'en',
        'accountId': account_id_token,
    }

    response = requests.request("GET", url, headers=headers, data=payload, verify=False)

    # print(response.content)

    content = response.content
    # print("AK412 : ",response)
    data = json.loads(content.decode('utf-8'))

    logger_info.info(" PC APN List api_url \n {} ".format(url))
    logger_info.info("status {} content {}".format(response.status_code, content))
    if data is not None:
        for lst in data:
            if lst["apnName"].lower() == apnName.lower():
                return lst, lst["apnCategory"]
            # if lst["apnName"] == apnName and lst["status"] != "IN_USE" :
            #     return  lst

    return None,None




def read_excel_device_plan_list(file_path):
    df = pd.read_excel(file_path, engine='openpyxl', usecols=['Device Plan LIST'])
    df.fillna('None', inplace=True)
    processed_device_plan_list = []
    for device_plan_list in df['Device Plan LIST']:
        device_plans = [plan.strip() for plan in device_plan_list.split('&&') if plan.strip()]
        processed_device_plan_list.append(device_plans)
    device_plan_list_dict = {'Device Plan LIST': processed_device_plan_list}
    return device_plan_list_dict







def csr_get_account_plan_discount(token, csrAddOnPlanAccountPlanUrl, accountPlanType):
    csrAddOnPlanAccountPlanUrl = csrAddOnPlanAccountPlanUrl + accountPlanType
    csrAddOnPlanAccountPlanUrl = quote(csrAddOnPlanAccountPlanUrl, safe=':/?&=')
    payload = {}
    token = f'Bearer {token}'
    headers = {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'accountId': account_id_token,
        'x-user-id': 'AB',
        'x-user-opco': account_id_token
    }

    response = requests.request("GET", csrAddOnPlanAccountPlanUrl, headers=headers, data=payload, verify=False)

    print(response.status_code)

    content = json.loads(response.content)
    print('addon content : ', content)
    # disc = content['data']['data'][0]['description']
    # print("disco ++++++++++", disc)
    data = content

    logger_info.info("Product Catalogue AddOn Plan api_url \n {} ".format(csrAddOnPlanAccountPlanUrl))
    # logger_info.info("payload \n {} ".format(payload))
    logger_info.info("status {} content {}".format(response.status_code, content))

    if data:
        print(data["data"]["data"])

        data = data["data"]["data"]
        # print(len(data))
        # print(data)
        return data
    return None