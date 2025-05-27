"""
Created on 19 March 2024
@author: amit.k@airlinq.com

csr_journey - This function is used to create the csr journey for the bu, it will fetch the customer, device plan, apn, tariff plan details
from the Excel file and then call the apis. Firstly will call validate api user api to get the token and then will call
apis in the below sequence.

API Order
1) call apn_list_url api to fetch the apn details like apn type on the basis of name given in the excel list
2) call product_catalogue_accountplan_url api
3) then will call account plan api to fetch account plan data and account plan name
4) then call get account level discount api to fetch account level discount details
5) then will call aircontrol_create_wholesale api with the account plan api response
6) call account level discount create api 
7) then will call csr_get_wholesale_Url api to fetch the metaData and csrId
8) then will call aircontrol_create_apn(Create bulk apn) api to create the apn by using apn details from the response of apn_list_url api
9) call Get addon plan details api 
10) call data plan api create data plan
11) call publish data plan api
12) then will call charges api with the penalty and adjustment recieved from excel file.
13) then will call csrDevicePlanAccountPlanUrl api to fetch the home price model, roam price model and device plan details
14) If roamPriceModel and homePriceModel details are not empty then will call the following below api in the given sequence
	1) For Roam Price Model the sequence will be call create zone api -> price model -> price model offset
	2) For Home Price Model the sequence will be call create zone api -> price model -> price model offset -> and then call zone api for both roam and home price model.

15) If roamPriceModel is empty then will call the following below api in the given sequence
	1) For Home Price Model the sequence will be call create zone api -> price model -> price model offset.

16) If homePriceModel is empty then will call the following below api in the given sequence
	1) For Roam Price Model the sequence will be call create zone api -> price model -> price model offset.

17) then will call service plan api aircontrol_create_service_plan with service plan name and excel file data.
18) then will call device plan api aircontrol_create_device_plan in end.
"""

import sys
sys.path.append("..")

from conf.custom.apollo.config import *
from urllib.parse import urlencode,urlparse,parse_qs,quote
import requests
from pay_loads import *
from src.utils.library import *
from conf.config import *
from csr_get_api_func import *

dir_path = dirname(abspath(__file__))

from src.utils.utils_lib import api_call,random_number
today = datetime.now()
# print(today)

current_date_time_str_logs = today.strftime("%Y%m%d%H%M")



csr_log_path = f'{logs_path}/csr_journey_api_log'



# # Create the history directory if it doesn't exist
if not os.path.exists(csr_log_path):
    os.makedirs(csr_log_path)




def initiate_api_call(api_url,payload,token,bu_account_id,filename):

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
            payload = ensure_json(payload)
            if content.startswith(b'{') or content.startswith(b'['):
                content_dict = None
                content_dict = json.loads(content.decode('utf-8'))
                # print("content dict 1",content_dict)
                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    json_obj_dict.update(content_dict)
                    # return json_obj_dict

                else:
                    error_message = content_dict.get("errorMessage") or content_dict.get("message") or "Unknown error"
                    error_dict = {"errorMessage": error_message}
                    error_json_obj_dict = json.loads(payload)
                    error_json_obj_dict.update(error_dict)
                    # error_list_sim_onboarding_columns.append(json_obj_dict)
                    # return error_json_obj_dict
            else:
                # Handling HTML response for error

                if status_code == 200:
                    json_obj_dict = json.loads(payload)
                    json_obj_dict.update({"message": content}) 
                    
                else:
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





token = api_validate_user_csr(username, password)



def csr_journey():
    
    df_mapping_master = pd.read_excel(mapping_master_file_path, engine='openpyxl',keep_default_na=False,dtype=str)
    df_mapping_master['Device Plan LIST'] = df_mapping_master['Device Plan LIST'].str.replace('–', '-')

    
    df_mapping_details = pd.read_excel(mapping_details_file_path, engine='openpyxl',keep_default_na=False,dtype=str)
    df_mapping_details['Device Plan'] = df_mapping_details['Device Plan'].str.replace('–', '-')
    dict_mapping = {}
    convert_dataframe_to_dict(dict_mapping,df_mapping_details)
    print('dict mapping : ',dict_mapping)
    txn_no = random_number(8)
    initiate_call = api_call()
    try:
        json_obj_dict = None
        error_json_obj_dict = None
        wholesale_success_list = []
        wholesale_error_list = []
        account_level_success_list = []
        account_level_error_list = []
        apn_success_list = []
        apn_error_list = []
        data_plan_success_list = []
        data_plan_error_list = []
        data_plan__publish_success_list = []
        data_plan__publish_error_list = []
        charges_success_list = []
        charges_error_list = []
        price_model_success_list = []
        price_model_error_list = []
        device_plan_success_list = []
        device_plan_error_list = []

        for index,row in df_mapping_master.iterrows():
            apn_list = row['APN LIST'].split("&&")
            device_plan_list = row['Device Plan LIST'].split("&&")
            service_profile_id_list = row['SERVICE_PROFILE_ID'].split("&&")
            cu_account_name = row['CUSTOMER_REFERENCE']
            bu_account_name = row['BILLING_ACCOUNT']

            # tariffPlan = "TP-1098-ALL"

            cu_account_id = fetch_account_id_cu(cu_account_name)
            # print(cu_account_id)

            bu_account_id = fetch_account_id_bu(bu_account_name)
            if (cu_account_id is not None) and (bu_account_id is not None):

                # tariffPlanId = '19750'
                tariffPlanName = row['Tariff Plan']
               
                tariff_data = {"name":f'{tariffPlanName}'}

                tariff_plan_data = tarrif_plan(token, tariffPlanName)
                apn_category = 'any'
                apn_list_new = []
                apn_type_list = []

                try:
                    for apn in apn_list:
                        print("APN NAME",apn)
                        apn_content,apn_type = get_apn_list(token, bu_account_id, apn,apn_category,tariff_plan_data["id"])
                        # print('apn content +++++++++',apn_content)
                        logger_info.info("PC Get Apn apn_content {} apn_type {}".format(apn_content, apn_type))
                        if apn_content is not None and apn_type is not None:
                            # print('apn list content',apn_content)
                            apn_list_new.append(apn_content)

                            apn_type_list.append(apn_type)
                        else:
                            print("APN List from PC is comming empty for {}".format(apn))
                            
                            logger_error.error("APN List from PC is comming empty for apn {} tariff plan {}".format(apn,tariffPlanName))
                            logger_info.info("APN List from PC is comming empty for apn {} tariff plan {}".format(apn,tariffPlanName))

                        # print("apn type list", type(apn_type_list))
                except Exception as e:
                    print("Error while Iterating Apn List : {}".format(e))
                    logger_error.error("Error while Iterating Apn List : {}".format(e))

                

                if apn_type_list and apn_list_new:

                    for accountid in apn_list_new:
                        accountid.update({'accountId': f'{bu_account_id}'})

                    apn_payload = apn_stc_bulk(apn_list_new,txn_no)
                    # print('apn payload', apn_payload)
                    print("APN Type List :",apn_type_list)

                    apn_type = None
                    apn_type_list_lower = [str(item) for item in apn_type_list]
                    if "1" not in apn_type_list_lower and "2" in apn_type_list_lower:
                        apn_type = "public"
                    elif "1" in apn_type_list_lower and "2" not in apn_type_list_lower:
                        apn_type =  "private"
                    elif "1" in apn_type_list_lower and "2" in apn_type_list_lower:
                        apn_type =  "any"


                    apn_type = "any"
                    print("APN TYPE : ",apn_type)
                    logger_info.info("APN Type {}".format(apn_type))

                    try:
                        for device_plan_name,service_id in zip(device_plan_list,service_profile_id_list):
                            print(
                                "############################################# API CAll Initiated ##############################################")

                            account_level_discount_data = None

                            accountPlan_data, accountPlan_desc, tariff_plan_id,account_plan_id = product_catalogue_accountplan(tariffPlanName,
                                                                                            product_catalogue_accountplan_url,
                                                                                            bu_account_id, apn_type, token)
                            if tariff_plan_id is not None:
                                account_level_discount_data = csr_get_account_plan_discount(token, csr_get_account_level_discount, tariff_plan_id) 
                            
                            if accountPlan_data is not None and accountPlan_desc is not None:
                                print('account plan data : ', accountPlan_data)
                                print('account plan desc : ', accountPlan_desc)
                                print('Account Level Discount Data : ',account_level_discount_data)
                                logger_info.info(
                                    "PC Account Plan data {} description {}".format(accountPlan_data, accountPlan_desc))
                                
                                if service_id in dict_mapping:
                                    
                                    df_dp_data = dict_mapping[service_id]['data']
                                    
                                    wholesale_payload = wholesale(accountPlan_data, bu_account_id, apn_type, tariff_data["name"],
                                                            txn_no,df_dp_data)
                                    
                                    wholesale_success_dict,wholesale_error_dict =  initiate_api_call(aircontrol_create_wholesale, wholesale_payload, token, bu_account_id, 'wholesale')

                                    if wholesale_success_dict is not None:
                                        wholesale_success_list.append(wholesale_success_dict)
                                    if wholesale_error_dict is not None:
                                        wholesale_error_list.append(wholesale_error_dict)

                                    if (account_level_discount_data is not None) and (len(df_dp_data['Account Level Discount Name'])!=0):
                                        account_level_payload = account_level_discount_payload(bu_account_id,account_level_discount_data,df_dp_data)
                                        account_level_success_dict,account_level_error_dict =  initiate_api_call(aircontrol_create_account_discount, account_level_payload, token, bu_account_id, 'account_level')
                                        if account_level_success_dict is not None:
                                            account_level_success_list.append(account_level_success_dict)
                                        if account_level_error_dict is not None:
                                            account_level_error_list.append(account_level_error_dict)

                                csr_id, metaData = csrWholeSalePlan(token, csr_get_wholesale_Url, accountPlan_data[0]['name'],
                                                                    bu_account_id)
                                
                                csr_id = int(csr_id)
                                print('meta12data', metaData)
                                logger_info.info("PC WholeSale Plan csr_id {} metaData {}".format(csr_id, metaData))
                                
                                
                                print("APNDC", apn_payload)
                                apn_success_dict,apn_error_dict = initiate_api_call(aircontrol_create_apn, apn_payload, token, bu_account_id, 'apn')
                                if apn_success_dict is not None:
                                    apn_success_list.append(apn_success_dict)
                                if apn_error_dict is not None:
                                    apn_error_list.append(apn_error_dict)
                                #################### Add On Plan ###################################################################
                                addon_plan = csrAddOnPlanAccountPlan(token, csrAddOnPlanAccountPlanUrl, accountPlan_desc)

                                if addon_plan is not None:
                                    logger_info.info("PC Addon Plan addon_plan_data {}".format(addon_plan))
                                    
                                    if service_id in dict_mapping:
                                        df_dp_data = dict_mapping[service_id]['data']

                                        dataplan_payload = data_plan(addon_plan, bu_account_id, txn_no, csr_id,df_dp_data)
                                        # print("Add Payload : ", dataplan_payload)

                                        data_plan_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_data_plan, dataplan_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            print("data plan response : ",response_data)
                                            data_plan_id = response_data['createdList'][0]["id"]
                                            print("Data Plan Id : ", data_plan_id)
                                            logger_info.info("Data Plan Id {}".format(data_plan_id))
                                            logger_info.info(
                                                " Data Plan status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "Data Plan status {} content {} error {}".format(status_code, content, e))
                                            
                                        if status_code is not None and content is not None:
                                            try:
                                                payload = json.dumps(dataplan_payload)
                                                if content.startswith(b'{'):
                                                    content_diIPV6ct = None
                                                    content_dict = json.loads(content.decode('utf-8'))
                                                    # print("content dict 1",content_dict)
                                                    if status_code == 200:
                                                        json_obj_dict = json.loads(payload)
                                                        json_obj_dict.update(content_dict)
                                                        data_plan_success_list.append(json_obj_dict)
                                                        # return json_obj_dict

                                                    else:
                                                        error_dict = {"errorMessage": content_dict["errorMessage"]}

                                                        error_json_obj_dict = json.loads(payload)
                                                        error_json_obj_dict.update(error_dict)
                                                        data_plan_error_list.append(error_json_obj_dict)
                                                        # error_list_sim_onboarding_columns.append(json_obj_dict)
                                                        # return error_json_obj_dict
                                                else:
                                                    # Handling HTML response for error

                                                    error_message = "HTTP Status 400 – Bad Request"
                                                    error_dict = {"errorMessage": error_message}
                                                    error_json_obj_dict = json.loads(payload)
                                                    error_json_obj_dict.update(error_dict)
                                                    data_plan_error_list.append(error_json_obj_dict)

                                            except Exception as e:
                                                error_dict = {"errorMessage": "error in calling API %s" % e}
                                                error_json_obj_dict = json.loads(payload)
                                                error_json_obj_dict.update(error_dict)
                                                data_plan_error_list.append(error_json_obj_dict)

                                        if data_plan_id is not None:
                                            dataplan_publish_status_payload = data_plan_publish_status(data_plan_id)
                                            print("Data Plan Publish :", dataplan_publish_status_payload)

                                            data_plan_publish_url = aircontrol_create_data_plan_publish_status + f"txn={txn_no}"

                                            data_plan_publish_success_dict,data_plan_publish_error_dict = initiate_api_call(data_plan_publish_url, dataplan_publish_status_payload, token, bu_account_id,'data_publish')
                                            if data_plan_publish_success_dict is not None:
                                                data_plan__publish_success_list.append(data_plan_publish_success_dict)
                                            if data_plan_publish_error_dict is not None:
                                                data_plan__publish_error_list.append(data_plan_publish_error_dict)
                                ################################## Charges #################################################
                                
                                if service_id in dict_mapping:
                                    df_dp_data = dict_mapping[service_id]['data']
                                    charges_payload = charges(df_dp_data, bu_account_id, txn_no)
                                    print("Charges Payload", charges_payload)
                                    charges_success_dict,charges_error_dict = initiate_api_call(aircontrol_create_charges, charges_payload, token,
                                                    bu_account_id, 'charges')
                                    if charges_success_dict is not None:
                                        charges_success_list.append(charges_success_dict)
                                    if charges_error_dict is not None:
                                        charges_error_list.append(charges_error_dict)

                                service_plan_name = device_plan_name + '_SP'
                                print("service plan name : ",service_plan_name)
                                logger_info.info("Service Plan name {}".format(service_plan_name))
                                # print("device plan name : ",device_plan_name)
                                logger_info.info("Device Plan name {}".format(device_plan_name))
                                # # device_plan_desc = 'DP-SIM-PUBLIC'
                                device_plan = csrDevicePlanAccountPlan(token, csrDevicePlanAccountPlanUrl, accountPlan_desc, device_plan_name)
                                if device_plan is not None:
                                    logger_info.info("PC Device_Plan_Account_Plan {}".format(device_plan_name))
                                    print('PC DP Data',device_plan)
                                    zone_group_id = device_plan['zoneGroupid']
                                    zone_goup_name = device_plan['zoneGroupName']
                                    roam_price_model = device_plan['roamPriceModel']
                                    home_price_model = device_plan['homePriceModel']
                                    roam_price_model_id = None
                                    home_price_model_id = None
                                    dp_zone_id = None
                                    ##################### Calling APIs For Home and Roam Zone ######################################################
                                    if (roam_price_model is not None and roam_price_model['zone'] is not None) and (home_price_model is not None and home_price_model['zone'] is not None):
                                        roam_zone_countryId = device_plan['roamPriceModel']['zone'][0]['countryIds']
                                        home_zone_countryId = device_plan['homePriceModel']['zone']['countryIds']

                                        roam_zone_name = device_plan['roamPriceModel']['zone'][0]['name']
                                        home_zone_name = device_plan['homePriceModel']['zone']['name']

                                        ######################### Home Zone ###############################################

                                        home_zone_payload = zone(home_zone_name, home_zone_countryId, bu_account_id,zone_group_id,zone_goup_name)
                                        print("home zone payload", home_zone_payload)

                                        home_zone_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_zone, home_zone_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            home_zone_id = response_data["id"]
                                            print("Zone Id : ", home_zone_id)
                                            logger_info.info("Zone Id {}".format(home_zone_id))
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        response_home = price_model(device_plan, bu_account_id, txn_no, 'home', home_zone_id)
                                        print("Roam Price Model Payload", response_home)

                                        price_model_success_dict,price_model_error_dict = initiate_api_call(aircontrol_create_price_model, response_home, token,
                                                        bu_account_id, 'price_model')
                                        if price_model_success_dict is not None:
                                            price_model_success_list.append(price_model_success_dict)
                                        if price_model_error_dict is not None:
                                            price_model_error_list.append(price_model_error_dict)
                                        home_price_model_name = device_plan['homePriceModel']['name']
                                        home_price_model_id, dp_zone_id = csr_get_price_model_id(token, csr_get_price_model_url,
                                                                                                home_price_model_name)
                                        # print("DCMI", home_price_model_id)

                                        ######################## Roam Zone ##################################################
                                        roam_zone_payload = zone(roam_zone_name, roam_zone_countryId, bu_account_id,zone_group_id,zone_goup_name)
                                        print("Roam zone payload", roam_zone_payload)

                                        roam_zone_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_zone, roam_zone_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            roam_zone_id = response_data["id"]
                                            print("Zone Id : ", roam_zone_id)
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        response_roam = price_model(device_plan, bu_account_id,txn_no,'roam',roam_zone_id)
                                        print('roam price model payload',response_roam)

                                        price_model_success_dict,price_model_error_dict = initiate_api_call(aircontrol_create_price_model, response_roam, token,
                                                        bu_account_id, 'price_model')
                                        
                                        if price_model_success_dict is not None:
                                            price_model_success_list.append(price_model_success_dict)
                                        if price_model_error_dict is not None:
                                            price_model_error_list.append(price_model_error_dict)

                                        roam_price_model_name = device_plan['roamPriceModel']['name']



                                        roam_price_model_id,dp_zone_id = csr_get_price_model_id(token, csr_get_price_model_url,
                                                                                    roam_price_model_name)
                                        # print("KKR", roam_price_model_id)


                                        combined_zone_payload = zone(roam_zone_name, roam_zone_countryId, bu_account_id,zone_group_id,zone_goup_name)
                                        print("home zone payload", combined_zone_payload)

                                        combined_zone_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_zone, combined_zone_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            combined_zone_id = response_data["id"]
                                            print("Combined Zone Id : ", combined_zone_id)
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        dp_zone_id = combined_zone_id

                                    elif (roam_price_model is None or roam_price_model['zone'] is None):
                                        # Call price model API once with homePriceModel data
                                        home_zone_countryId = device_plan['homePriceModel']['zone']['countryIds']
                                        home_zone_name = device_plan['homePriceModel']['zone']['name']
                                        home_zone_payload = zone(home_zone_name, home_zone_countryId, bu_account_id,zone_group_id,zone_goup_name)
                                        print("home zone payload", home_zone_payload)

                                        home_zone_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_zone, home_zone_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            home_zone_id = response_data["id"]
                                            print("Zone Id : ", home_zone_id)
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        response_home = price_model(device_plan, bu_account_id, txn_no, 'home', home_zone_id)

                                        price_model_success_dict,price_model_error_dict = initiate_api_call(aircontrol_create_price_model, response_home, token,
                                                        bu_account_id, 'price_model')
                                        if price_model_success_dict is not None:
                                            price_model_success_list.append(price_model_success_dict)
                                        if price_model_error_dict is not None:
                                            price_model_error_list.append(price_model_error_dict)

                                        home_price_model_name = device_plan['homePriceModel']['name']
                                        home_price_model_id,dp_zone_id = csr_get_price_model_id(token, csr_get_price_model_url,
                                                                                    home_price_model_name)
                                        print("DCMI", home_price_model_id)
                                    else:
                                        # Call price model API once with roamPriceModel data
                                        roam_zone_countryId = device_plan['roamPriceModel']['zone'][0]['countryIds']
                                        roam_zone_name = device_plan['roamPriceModel']['zone'][0]['name']
                                        roam_zone_payload = zone(roam_zone_name, roam_zone_countryId, bu_account_id,zone_group_id,zone_goup_name)
                                        print("Roam zone payload", roam_zone_payload)

                                        roam_zone_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_zone, roam_zone_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            roam_zone_id = response_data["id"]
                                            print("Zone Id : ", roam_zone_id)
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        response_roam = price_model(device_plan, bu_account_id, txn_no, 'roam', roam_zone_id)
                                        print('roam price model payload', response_roam)

                                        price_model_success_dict,price_model_error_dict = initiate_api_call(aircontrol_create_price_model, response_roam, token,
                                                        bu_account_id, 'price_model')
                                        if price_model_success_dict is not None:
                                            price_model_success_list.append(price_model_success_dict)
                                        if price_model_error_dict is not None:
                                            price_model_error_list.append(price_model_error_dict)

                                        roam_price_model_name = device_plan['roamPriceModel']['name']

                                        roam_price_model_id,dp_zone_id = csr_get_price_model_id(token, csr_get_price_model_url,
                                                                                    roam_price_model_name)

                                    ############################## Get Roam and Home Zone Id ##########################################3

                                    
                                    if service_id in dict_mapping:
                                    
                                        df_dp_data = dict_mapping[service_id]['data']
                                        service_plan_payload = service_plan(df_dp_data,service_plan_name,bu_account_id,txn_no,csr_id)

                                        service_plan_id = None
                                        try:
                                            status_code = None
                                            content = None
                                            print("Api Url ",aircontrol_create_service_plan)
                                            logger_info.info("Api Url : {}".format(aircontrol_create_service_plan))
                                            print("Payload : ", service_plan_payload)
                                            logger_info.info("Payload : {}".format(service_plan_payload))
                                            status_code, content = initiate_call.call_api(
                                                aircontrol_create_service_plan, service_plan_payload, token, bu_account_id)
                                            print('Status Code : ', status_code)
                                            response_data = json.loads(content.decode('utf-8'))
                                            service_plan_id = response_data["id"]
                                            print("Service Plan Id : ", service_plan_id)
                                            logger_info.info(
                                                "status {} content {} ".format(status_code, content))

                                        except Exception as e:
                                            logger_error.error(
                                                "status {} content {} error {}".format(status_code, content, e))

                                        # print('service plan data : ',service_plan_payload)
                                        apn_ids = [apn['id'] for apn in apn_list_new]
                                        print("apn id : ",apn_ids)
                                        logger_info.info("apn id : {}".format(apn_ids))
                                        # service_plan_id = '20922'
                                        if service_plan_id is not None:
                                            device_plan_payload_data = device_plan_payload(device_plan,service_plan_id,bu_account_id,csr_id,apn_ids,txn_no,df_dp_data, metaData,roam_price_model_id,home_price_model_id,dp_zone_id)
                                            print('device payload',device_plan_payload_data)
                                            device_plan_success_dict,device_plan_error_dict = initiate_api_call(aircontrol_create_device_plan, device_plan_payload_data, token,
                                                            bu_account_id,'deviceplan')
                                            if device_plan_success_dict is not None:
                                                device_plan_success_list.append(device_plan_success_dict)
                                            if device_plan_error_dict is not None:
                                                device_plan_error_list.append(device_plan_error_dict)
                                        else:
                                            print("Service Plan Id : {}, cannot be none for device plan creation".format(service_plan_id))
                                            logger_error.error("Service Plan Id : {}, cannot be none for device plan creation".format(service_plan_id))
                                else:
                                    print("Device Plan Data not comming from PC {}".format(device_plan))
                                    logger_error.error("Device Plan Data not comming from PC {}".format(device_plan))
                            else:
                                print("Account Plan data is not comming from PC {}".format(accountPlan_data))
                                logger_error.error("Account Plan data is not comming from PC {}".format(accountPlan_data))
                                logger_info.error("Account Plan data is not comming from PC {}".format(accountPlan_data))
                    except Exception as e:
                        print("Error : {}, while calling DP,SP,ZONE Api device plan list {}".format(e,device_plan_list))
                        logger_error.error("Error : {}, while calling DP,SP,ZONE Api  device plan list {}".format(e,device_plan_list))
                        logger_info.error("Error : {}, while calling DP,SP,ZONE Api  device plan list {}".format(e,device_plan_list))

                else:
                    logger_error.error("Apn List not recieved from PC {}".format(apn_list_new))
                    logger_info.error("Apn List not recieved from PC {}".format(apn_list_new))
                    print("Apn List not recieved from PC {}".format(apn_list_new))
            else:
                if cu_account_id is None:
                    logger_error.error("Account Id Not found for CRN {}".format(cu_account_name))
                    logger_info.error("Account Id Not found for CRN {}".format(cu_account_name))
                    print("Account Id Not found for CRN {}".format(cu_account_name))
                if bu_account_id is None:
                    logger_error.error("Account Id Not found for BILLING_ACCOUNT_NO {}".format(bu_account_name))
                    logger_info.error("Account Id Not found for BILLING_ACCOUNT_NO {}".format(bu_account_name))
                    print("Account Id Not found for BILLING_ACCOUNT_NO {}".format(bu_account_name))

        wholesale_success_df = pd.DataFrame(wholesale_success_list)
        if not wholesale_success_df.empty:
            wholesale_success_df.to_csv(f"{csr_log_path}/wholesale_success_{current_date_time_str_logs}.csv", index=False)
        wholesale_error_df = pd.DataFrame(wholesale_error_list)
        if not wholesale_error_df.empty:
            wholesale_error_df.to_csv(f"{csr_log_path}/wholesale_error_{current_date_time_str_logs}.csv",index=False)

        #### Apn Files ##########
        apn_success_df = pd.DataFrame(apn_success_list)
        if not apn_success_df.empty:
            apn_success_df.to_csv(f"{csr_log_path}/apn_success_{current_date_time_str_logs}.csv", index=False)
        apn_error_df = pd.DataFrame(apn_error_list)
        if not apn_error_df.empty:
            apn_error_df.to_csv(f"{csr_log_path}/apn_error_{current_date_time_str_logs}.csv",index=False)

        data_plan_success_list = []
        data_plan_error_list = []
        
        data_plan_publish_success_df = pd.DataFrame(data_plan_success_list)
        if not data_plan_publish_success_df.empty:
            data_plan_publish_success_df.to_csv(f"{csr_log_path}/data_plan_success_{current_date_time_str_logs}.csv", index=False)
        data_plan_publish_error_df = pd.DataFrame(data_plan_error_list)
        if not data_plan_publish_error_df.empty:
            data_plan_publish_error_df.to_csv(f"{csr_log_path}/data_plan_error_{current_date_time_str_logs}.csv",index=False)

        data_plan_publish_success_df = pd.DataFrame(data_plan__publish_success_list)
        if not data_plan_publish_success_df.empty:
            data_plan_publish_success_df.to_csv(f"{csr_log_path}/data_plan_publish_success_{current_date_time_str_logs}.csv", index=False)
        data_plan_publish_error_df = pd.DataFrame(data_plan__publish_error_list)
        if not data_plan_publish_error_df.empty:
            data_plan_publish_error_df.to_csv(f"{csr_log_path}/data_plan_publish_error_{current_date_time_str_logs}.csv",index=False)

        charges_success_df = pd.DataFrame(charges_success_list)
        if not charges_success_df.empty:
            charges_success_df.to_csv(f"{csr_log_path}/charges_success_{current_date_time_str_logs}.csv", index=False)
        charges_error_df = pd.DataFrame(charges_error_list)
        if not charges_error_df.empty:
            charges_error_df.to_csv(f"{csr_log_path}/charges_error_{current_date_time_str_logs}.csv",index=False)


        price_model_success_df = pd.DataFrame(price_model_success_list)
        if not price_model_success_df.empty:
            price_model_success_df.to_csv(f"{csr_log_path}/price_model_success_{current_date_time_str_logs}.csv", index=False)
        price_model_error_df = pd.DataFrame(price_model_error_list)
        if not price_model_error_df.empty:
            price_model_error_df.to_csv(f"{csr_log_path}/price_model_error_{current_date_time_str_logs}.csv",index=False)

        device_plan_success_df = pd.DataFrame(device_plan_success_list)
        if not device_plan_success_df.empty:
            device_plan_success_df.to_csv(f"{csr_log_path}/device_plan_success_{current_date_time_str_logs}.csv", index=False)
        device_plan_error_df = pd.DataFrame(device_plan_error_list)
        if not device_plan_error_df.empty:
            device_plan_error_df.to_csv(f"{csr_log_path}/device_plan_error_{current_date_time_str_logs}.csv",index=False)

    except Exception as e:
        print("Error {} while Iterating file {}".format(e,''))
        logger_error.error("Error {} while Iterating file {}".format(e,''))



csr_journey()





