import json
from urllib.parse import urlencode
import urllib.parse
from src.utils.library import *
from os.path import dirname, abspath, join
dir_path = dirname(abspath(__file__))
from roam_zone_extraction import extract_prices_for_roam
from datetime import datetime


# def replace_none_with_empty_string_or(data):
#     if isinstance(data, dict):
#         return {k: replace_none_with_empty_string_or_"null"(v) if v is not None else ""null"" for k, v in data.items()}
#     elif isinstance(data, list):
#         return [replace_none_with_empty_string_or_"null"(item) for item in data]
#     elif data is None:
#         return ""null""
#     else:
#         return data
    
def replace_none_values(data):
    """
    Recursively replaces string "None" or "NONE" with Python None in the provided data.

    Args:
        data: The input data which can be a dictionary, list, or any other type.

    Returns:
        The data with "None" or "NONE" replaced by Python None.
    """
    if isinstance(data, dict):
        return {k: replace_none_values(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [replace_none_values(item) for item in data]
    elif isinstance(data, str) and data in {"None", "NONE"}:
        return None
    return data


def convert_nested_json(payload, keys):
    """
    Converts specified keys in the payload from JSON strings to Python objects.

    Args:
        payload: The dictionary containing the payload data.
        keys: A list of keys whose values are JSON strings to be converted.

    Returns:
        The payload with specified keys converted to Python objects.
    """
    for key in keys:
        if key in payload:
            payload[key] = json.loads(payload[key])
    return payload


def clean_payload(payload):
    """
    Cleans the payload by converting JSON strings to Python objects and
    replacing string "None" or "NONE" with Python None.

    Args:
        payload: The dictionary containing the payload data.

    Returns:
        The cleaned payload.
    """
    # json_keys = ['eventBaseFees','products', 'oneTimeCharge', 'recurringCharge', 'initialPgData', 'metaData']
    json_keys = ['products', 'oneTimeCharge', 'recurringCharge', 'initialPgData', 'metaData']
    # Convert nested JSON strings to Python objects
    payload = convert_nested_json(payload, json_keys)

    # Replace "None" and "NONE" with None
    payload = replace_none_values(payload)

    # Convert nested Python objects back to JSON strings
    for key in json_keys:
        if key in payload:
            payload[key] = json.dumps(payload[key], ensure_ascii=False)

    return payload

def convert_values_to_string(payload):
    for key, value in payload.items():
        payload[key] = str(value)
    return payload

def convert_float_to_int(obj):
    if isinstance(obj, dict):
        for key, value in obj.items():
            if isinstance(value, float):
                obj[key] = int(value)
            elif isinstance(value, (dict, list)):
                convert_float_to_int(value)
    elif isinstance(obj, list):
        for i in range(len(obj)):
            if isinstance(obj[i], float):
                obj[i] = int(obj[i])
            elif isinstance(obj[i], (dict, list)):
                convert_float_to_int(obj[i])
    return obj



def fetch_service_type_id(service_type_id_list, isRoaming):
    for item in service_type_id_list[:]:  # Make a copy to iterate over while extending the original list
        if item == '3':
            if isRoaming == '1':
                service_type_id_list.extend(['3', '5', '6', '13'])  # Convert to strings
            else:
                service_type_id_list.extend(['3', '13'])
            service_type_id_list = [x for x in service_type_id_list if x != '14']  # Convert to string

        elif item == '4':
            if isRoaming == '1':
                service_type_id_list.extend(['4', '5', '6', '13'])  # Convert to strings
            else:
                service_type_id_list.extend(['4', '13'])

        elif item == '12':
            if isRoaming == '1':
                service_type_id_list.extend(['12', '7', '8', '9', '10'])  # Convert to strings
            else:
                service_type_id_list.extend(['12', '7', '8'])

        elif item == '13':
            if isRoaming == '1':
                service_type_id_list.extend(['13', '3', '4', '5', '6'])  # Convert to strings
            else:
                service_type_id_list.extend(['13', '3', '4'])
            service_type_id_list = [x for x in service_type_id_list if x != '14']  # Convert to string

        elif item == '11':
            if isRoaming == '1':
                service_type_id_list.extend(['11', '1', '2'])  # Convert to strings
            else:
                service_type_id_list.extend(['11', '1'])

    return service_type_id_list



def device_plan_payload(data,servicePlan,accountId,csrId,apnId,txn_no,df_dp_data,metaData,roam_price_model_id,home_price_model_id,zone_id,sp_name):
    # servicePlan = 40473
    service_type_id = []
    is_roaming = df_dp_data['Service Plan param Is Roaming']
    print("Original service list : ", service_type_id)
    service_type_is_mapping = {
        'Service Plan param Data': '11',
        'Service Plan param SMS': '12',
        'Service Plan param Voice': '13',
        'Service Plan param International Voice': '14',
        'Service Plan param Voice Incoming': '4',
        'Service Plan param Voice Outgoing': '3'
    }

    for key in service_type_is_mapping.keys():
        if df_dp_data[key] == '1':
            service_type_id.append(service_type_is_mapping[key])

    print("Updated Service List ", service_type_id)
    service_id_list = fetch_service_type_id(service_type_id, is_roaming)
    print("Service Type List",service_id_list)
    # print("SPMAR25",servicePlan)
    api_response = {
        "dataVolumePayg": data['dataVolumePayg'],
        "dataVolumeUnitPayg": data['dataVolumeUnitPayg'],
        "quotaOverBitData": data['quotaOverBitData'],
        "smsLimitPayg": data['smsLimitPayg'],
        "smsVolumePayg": data['smsVolumePayg'],
        "voiceLimitPayg": data['voiceLimitPayg'],
        "voiceVolumePayg": data['voiceVolumePayg'],
        "voiceVolumeUnitPayg": data['voiceVolumeUnitPayg'],
        "quotaOverBitVoice": data['quotaOverBitVoice'],
        "nbiotLimitPayg": data['nbiotLimitPayg'],
        "nbiotDataVolumePayg": data['nbiotDataVolumePayg'],
        "nbiotVolumeUnitPayg": data['nbiotVolumeUnitPayg'],
        "quotaOverBitNbIotData": data['quotaOverBitNbIotData']
    }

    initialPgData = '{"dataVolumePayg":"","dataVolumeUnitPayg":"","quotaOverBitData":"","smsLimitPayg":"","smsVolumePayg":0,"voiceLimitPayg":"","voiceVolumePayg":10,"voiceVolumeUnitPayg":"0","quotaOverBitVoice":"true","nbiotLimitPayg":"false","nbiotDataVolumePayg":0,"nbiotVolumeUnitPayg":"","quotaOverBitNbIotData":"false"}'

    # Parse initialPgData string to dictionary
    initialPgData_dict = json.loads(initialPgData)

    # Update initialPgData_dict with values from api_response
    initialPgData_dict.update(api_response)

    # Convert updated dictionary back to JSON string
    initialPgData_updated = convert_float_to_int(initialPgData_dict)
    initialPgData_updated = json.dumps(initialPgData_updated)

    # print("IPSP",initialPgData_updated)
    event_base_json = json.dumps(data['eventBaseFees'])

    products_json = None
    if data['products'] is not None:
        for product in data['products']:
            # json_object = json.loads(product['product_char'])

            # json_string_single_quotes = dict(json_object)
            json_string_single_quotes = str(eval(product['product_char']))
            # json_string_single_quotes = json.dumps(json_string_single_quotes)
            product['product_char'] = json_string_single_quotes
            # product['entitlements'] = [] if product.get('entitlements') == [None] else product['entitlements']
            # print('IDENTIFY',product['product_char'])



        products_json = convert_float_to_int(data['products'])

    

    products_json = json.dumps(products_json)

    # print("LSGCSK", products_json)
    recurring_json = json.dumps(data['recurringCharge'])
    metaData_conversion = None
    if metaData is not None:
        metaData_conversion = convert_float_to_int(metaData)
    meta_data = json.dumps(metaData_conversion)
    # print('meta12data', meta_data)
    otc_charge_json = json.dumps(data['oneTimeCharge'])


    # vas = []
    # for vas_charge in data['vas']:
    #     if vas_charge['name'] == df_dp_data["Device Level Vas Charge"]:
    #         updated_item = vas_charge.copy()
    #         vas.append(updated_item)

    

    # for disc in data['discount']:
    #     device_level_discount_list = df_dp_data["Device_Level_Discount_Name"].split("&&")
    #     for device_level in device_level_discount_list:
    #         if disc['chargeId'] == device_level:
    #             updated_item = disc.copy()
    #             discount.append(updated_item)

    discount = []
    device_plan_level = {
    "name": "DP_LEVEL_DISCOUNT",
    "operationType": 0,
    "chargeId": None,
    "price": None,
    "id": None,
    "extraMetadata": {
        "end_date": None,
      "gl_code": 671,
      "uom": "%",
      "amount": "20.0",
      "charge_category": [
        "All Usages"
      ],
      "is_prorated": True,
      "sub_category": "Device Plan Level",
      "name": "Device : All Usages",
      "id": 28,
      "type": "Flat",
      "category": "Usage",
      "start_date": "2024-03-18",
    #   "uuid": "8a1db5db-4513-4229-a5d3-48da46143187",
      "plan": "",
      "discountLevel": "Device Plan Level"
    }
    }



    today = datetime.today()
    # Calculate previous month
    if today.month == 1:  # Handle January case
        previous_month = 12
        year = today.year - 1
    else:
        previous_month = today.month - 1
        year = today.year

    start_date = datetime(year, previous_month, 28).strftime('%Y-%m-%d')

    # print("DP",data['devicePlanLevelDiscount'])
    # discount_level_discount = {}
    if data['devicePlanLevelDiscount'] is not None:
        for disc in data['devicePlanLevelDiscount']:
            device_level_discount_list = df_dp_data["Device_Level_Discount_Name"].split("&&")
            device_level_price_list = df_dp_data['Device_level_Discount_Price'].split("&&")
            for device_level,device_level_price in zip(device_level_discount_list,device_level_price_list):
                # print("before discount name from pc : ",disc['name'])
                # print("before discount name : ",device_level)
                # print("comparison of discount : ",(disc['name'] == device_level))
                if (disc['name'] == device_level):
                    updated_item = device_plan_level.copy()
                    extra_mdata = updated_item['extraMetadata']
                    extra_mdata.update(disc)
                    extra_mdata['plan'] = sp_name
                    extra_mdata['amount'] = device_level_price
                    extra_mdata['start_date'] = start_date
                    updated_item['extraMetadata'] = extra_mdata
                    discount.append(updated_item)

    vas_json = json.dumps(data['vas'])
    discount_json = json.dumps(discount)
    # print("Device Plan Discount",discount_json)
    # apn_id_string = ','.join(str(apn_id) for apn_id in apnId)
    apn_id_string = ','.join(str(apn_id) for apn_id in set(apnId))

    try:

        payload = {
            'planActivation': data['planActivation'],
            'planDesc': '831' if '13' in service_id_list else data['planDesc'],
            # 'validUpTo': data['validUpTo'],
            'validUpTo': '',
            'device_plan_transition': data['device_plan_transition'],
            'zoneGroupid': data['zoneGroupid'],
            'planName': sp_name,
            'discount': discount_json if discount_json != '[]' else '',
            'quotaOverBitData': 'false' if df_dp_data['Data PAYG'] == '0' else 'true',
            'nbiotLimitPayg': data['nbiotLimitPayg'],
            'voiceVolumeUnitPayg': data['voiceVolumeUnitPayg'],
            'quotaOverBitVoice': 'false' if df_dp_data['Voice PAYG'] == '0' else 'true',
            'dataLimitPayg': data['dataLimitPayg'],
            'templateId': data['templateId'],
            'quotaProration': data['quotaProration'],
            'nbiotVolumeUnitPayg': data['nbiotVolumeUnitPayg'],
            'frequency': data['frequency'],
            'eventBaseFees': event_base_json if event_base_json != 'null' else '',
            'products': products_json if products_json != 'null' else '',
            'catalogId': data['catalogId'],
            'zone': zone_id,
            'smsLimitPayg': data['smsLimitPayg'],
            'quotaOverBitNbIotData': data['quotaOverBitNbIotData'],
            'oneTimeCharge': otc_charge_json,
            'nbiotDataVolumePayg': data['nbiotDataVolumePayg'],
            'zoneGroupName': data['zoneGroupName'],
            'planType': data['planType'],
            'device_plan_type': data['device_plan_type'],
            'externalId': data['externalId'],
            'vas': vas_json if vas_json != 'null' else '',
            'tariffPlanId': data['tariffPlanId'],
            'dataVolumeUnitPayg': data['dataVolumeUnitPayg'],
            'enabledRecurringQuota': 'false',
            'rcProration': data['rcProration'],
            'voiceLimitPayg': data['voiceLimitPayg'],
            'smsVolumePayg': int(data['smsVolumePayg']) if data.get('smsVolumePayg') else '0',
            'voiceVolumePayg': int(data['voiceVolumePayg']) if data.get('voiceVolumePayg') else '0',
            'dataVolumePayg': int(data['dataVolumePayg']) if data.get('voiceVolumePayg') else '0',
            'roamPriceModel': str(roam_price_model_id) if str(roam_price_model_id)!='None' else '',  # 8790
            'homePriceModel': str(home_price_model_id) if str(home_price_model_id)!='None' else '',  # 8789
            'maxPoolSize': int(data['maxPoolSize']) if data.get('maxPoolSize') else '0',
            'startDate': data['startDate'],
            'status': data['status'],
            'recurringCharge': recurring_json if recurring_json != 'null' else '',
            'uuid': 'f2acb68b-63fe-48da-99c9-1cef3f5f05a6',
            'initialPgData': initialPgData_updated,
            'metaData': meta_data,
            'quotaOverBitSms': 'false' if df_dp_data['SMS PAYG'] == '0' else 'true',
            'servicePlan': str(servicePlan),  #40442
            'currentlyAddedDevicePlan': "true",
            'accountId': accountId,
            'csrId': csrId,
            'txn': txn_no,
            'apnId': apn_id_string,
            'sms': int(df_dp_data['Service Plan param SMS']) if df_dp_data['Service Plan param SMS'] else '0',  # Service Plan param SMS
            'voice': int(df_dp_data['Service Plan param Voice']) if df_dp_data['Service Plan param Voice'] else '0', #  Service Plan param Voice
            'smsRoamingVolumePayg': int(df_dp_data['SMS PAYG']) if df_dp_data['SMS PAYG'] else '0',  # SMS PAYG
            'publish': "true", #default "true"
            'dataUnit': 'MB', # not present in pc device plan
            'dataValue': '0',  # not present in pc device plan
            'dataRoamingLimitPayg': "false" if df_dp_data['Data PAYG'] == '0' else "true",  # Data PAYG  J column
            'spCharge': '',    #  Device Level Vas Charge  (pc api )
            'fromCsr': "true",
            'quotaFrequency': data['frequency']  # need to check (frequencey)
        }
        payload = clean_payload(payload)
       
        return payload
    except Exception as e:
        print("Error In Payload : ",e)



#### Service plan data need to take from csr mapping details







def service_plan(data,service_plan_name,accountId,txn_no,csr_id):
    service_type_id = []
    is_roaming = data['Service Plan param Is Roaming']
    print("Original service list : ",service_type_id)
    service_type_is_mapping = {
        'Service Plan param Data': '11',
        'Service Plan param SMS': '12',
        'Service Plan param Voice': '13',
        'Service Plan param International Voice': '14',
        'Service Plan param Voice Incoming': '4',
        'Service Plan param Voice Outgoing': '3'
    }

    for key in service_type_is_mapping.keys():
        if data[key] == '1':
            service_type_id.append(service_type_is_mapping[key])

    print("Updated Service List ",service_type_id)
    service_id_list = fetch_service_type_id(service_type_id, is_roaming)
    print("Manipulated Service Id",service_id_list)
    unique_service_id_list = list(set(service_id_list))
    print("Final service list : ", unique_service_id_list)

    service_type_id_string = ','.join(str(type_id) for type_id in unique_service_id_list)


    payload =  {
        'servicePlanName': service_plan_name,  #  devicePlanName + "_SP"
        'serviceTypeIds': str(service_type_id_string),  ##  3,4,14(price_service_type)
        'voice_payg': 'false' if data['Voice PAYG'] == '0' else 'true',  # file index f
        'sms_payg': 'false' if data['SMS PAYG'] == '0' else 'true',  # h
        'data_payg': 'false' if data['Data PAYG'] == '0' else 'true', # j
        'nbiot_payg': 'false' if data['Nbiot Data PAYG'] == '0' else 'true', # l
        'roaming': data['Service Plan param Is Roaming'], #  is_roaming index - m
        'bandwidthDownlink': '',
        'bandwidthUplink': '',
        'roamingTemplateHlr': '',
        'roamingTemplateSor': '',
        'accountId': accountId,
        'csrId': csr_id,
        'txn': str(txn_no),  # random_number
        'servicePlanDescription': service_plan_name,
        'externalId': str(txn_no),
        'servicePlanTypeId': '',
        'stcData':int(data['Service Plan param Data']) if data['Service Plan param Data'] else '0',  # I ( service plan param data)
        'stcSms': int(data['Service Plan param SMS']) if data['Service Plan param SMS'] else '0',  # G
        'stcVoice': int(data['Service Plan param Voice']) if data['Service Plan param Voice'] else '0',  # D
        'voiceInternational': data['Service Plan param International Voice'] if data['Service Plan param International Voice'] else '0',  # E
        'voiceIncoming': data['Service Plan param Voice Incoming'] if data['Service Plan param Voice Incoming'] else '0', # C
        'voiceOutgoing':data['Service Plan param Voice Outgoing'] if data['Service Plan param Voice Outgoing'] else '0',  # B
        'networkType': ''
    }
    # url_encoded_data = urlencode(payload)

    return payload



### need to get it from device plan pc response key (homePriceModel)
def price_model(data,accountId,txn_no,model_type,zone_id,zone_id_mapping,roam_zone_data,logger_info):

    

    if model_type == 'roam':
        zone_mapping_dict = {item['zone_name']: item['zone_id'] for item in zone_id_mapping}
        updated_roamServiceType = []

        roamServiceType = extract_prices_for_roam(roam_zone_data, base_charge=False)

        for service in roamServiceType:
            zone_name = service.get('zone_name')
            if zone_name in zone_mapping_dict:
                service['action'] = str(zone_mapping_dict[zone_name])
                service.pop('zone_name', None)
                updated_roamServiceType.append(service)
                

        price_model_data = data['roamPriceModel']
        service_type_disc_json = json.dumps(updated_roamServiceType)
        # logger_info.info("Amit if {}".format(price_model_data))
        
    else:
        price_model_data = data['homePriceModel']
    
    service_type_json = service_type_disc_json if model_type == 'roam' else json.dumps(price_model_data['service_types'])
    

    payload = {
        "serviceType": price_model_data['serviceType'],
        "normalRate": price_model_data['normalRate'],
        "roaming": price_model_data['roaming'],
        "peakHoursEnd": price_model_data['peakHoursEnd'],
        "priceType": price_model_data['priceType'],
        "discount": service_type_json if service_type_json else '', 
        "externalId": price_model_data['externalId'],
        "modelTypes": '[]',
        "unit": price_model_data['unit'],
        "currencyName": price_model_data['currencyName'],
        "zone": zone_id,  # Assuming zone_id is available in products
        # "zone": price_model_data['zone'],  # Assuming zone_id is available in products
        "peakHours": price_model_data['peakHours'],
        "peakRate": price_model_data['peakRate'],
        "name": price_model_data['name'],
        "service_types": service_type_json if service_type_json else '',
        "peakHoursStart": price_model_data['peakHoursStart'],
        "accountId": accountId,
        "txn": str(txn_no),
        "fromCsr": "true",
        "zoneServiceList": ''  # Doubt on this
    }


    return payload



def apn_stc_bulk(data,txn_no):
    data_list_json = json.dumps(data)
    payload =  {
        "apnList": data_list_json,
        "txn": str(txn_no)
    }

    return payload

## tariff plan api
def wholesale(data,accountId,apnType,tariffPlanName,txn_no,df_data):
    otc_charge_json = json.dumps(data[0]['oneTimeCharge'])
    event_base_json = json.dumps(data[0]['eventBaseFees'])
    recurring_charge_json = json.dumps(data[0]['recurringCharge'])

    # discount_json = json.dumps(data[0]['discount'])
    # vas_json = json.dumps(data[0]['vas'])
    # print('discount list : ',account_level_discount_list)
    # vas = []
    # for vas_charge in data[0]['vas']:
    #     if vas_charge['name'] == df_data["Account Level VAS Charge"]:
    #         updated_item = vas_charge.copy()
    #         vas.append(updated_item)

    for vas_charge in data[0]['vas']:
        vas_charge["alreadySelAccVasCharge"] = True
        vas_charge["operationType"] = 0

    discount = []
    for disc in data[0]['discount']:
        
        account_level_discount_list = df_data["Account Level Discount Name"].split("&&")
        
        for account_level in account_level_discount_list:
            if disc['chargeId'] == account_level:
                updated_item = disc.copy()
                discount.append(updated_item)
        print('discount list : ',account_level_discount_list)

  

    # print('account discount list : ',discount)

    vas_json = json.dumps(data[0]['vas'])
    discount_json = json.dumps(discount)

    payload = {
        # 'penalties': str(data[0]['penalties']),
        'penalties': '',
        'endDate': '',
        'description': str(data[0]['description']),
        'externalId': str(data[0]['externalId']),
        'tariffPlanId': str(data[0]['tariffPlanId']),
        'templateId': str(data[0]['templateId']),
        'rcProration': str(data[0]['rcProration']) if str(data[0]['rcProration'])!='None' else '',
        'otcProration': str(data[0]['otcProration']) if str(data[0]['otcProration'])!='None' else '',
        # 'otcProration': '',
        # 'catalogId': str(data[0]['otcProration']),  # Check if this is correct
        'catalogId': str(data[0]['catalogId']) if str(data[0]['catalogId'])!='None' else '',  # Check if this is correct
        'name': str(data[0]['name']),
        'currency': str(data[0]['currency']),
        'dunningProfile': str(data[0]['dunningProfile']),
        'legacyPlanId': str(data[0]['legacyPlanId']),
        'startDate': str(data[0]['startDate']),
        'accountId': str(accountId),  # bu account id
        'apnType': str(apnType),  ## apn type
        'txn': str(txn_no),  ## random number
        'simStatusTotalLines': '',
        'eventBaseFees': event_base_json,  ## not required
        'recurringCharge': recurring_charge_json,  ## not required
        'oneTimeCharge': otc_charge_json,  ## not required
        'credit': '',
        # 'discount': discount_json,
        'discount':'',
        'tariffPlanName': str(tariffPlanName),
        'vas': vas_json
     }
    # payload = json.dumps(payload)
    # url_encoded_data = urlencode(payload)

    return payload


def charges(data,accountId,txn_no):

    penalty_data = {
        "accountId": accountId,
        "currency" : "SAR",
        "name" : str(data['Penalties']),
        "price" : data['Penalties Amout'],
        "createDate" : data['Penalties Create Date'],
        "glcode" : "M_OC12",
        "id" : "null"
    }
    # penalty_data = json.dumps(penalty_data)
    print('penalty data : ',penalty_data)
    adjustment_data = {
        "accountId": accountId,
        "glcode": "M_OC14",
        "id": "null",
        "name": str(data['Adjustments']),
        "createDate": data['Adjustments Create Date'],
        "price": data['Adjustments Amount'],
    }
    # adjustment_data = json.dumps(adjustment_data)
    payload =  {
        'penalty': f"[{json.dumps(penalty_data)}]" if data['Penalties'] else '[]',   ### account plan api (sanju pipal)
        'adjustment': f"[{json.dumps(adjustment_data)}]" if data['Adjustments'] else '[]',
        'txn': str(txn_no),  ## random value same for a single operation
        'accountId': str(accountId),  # bu_account_id
      }

    # url_encoded_data = urlencode(payload)
    # json_dump = json.dumps(payload)
    return payload


def zone(roam_zone_name,roam_zone_countryId,accountId):

    payload =  {
    'accountId': accountId,
    'name': str(roam_zone_name),
    'countryIds': str(roam_zone_countryId),
    'forCsr': "true"
   }
    # url_encoded_data = urlencode(payload)

    return payload


#csrAddOnPlanAccountPlanUrl


def data_plan(data,account_id,txn_no,csr_id,df_dp_data):
    data_plan_payload_field = {
        'accountId': account_id,
        'csrId': csr_id,
        'txn': str(txn_no),
        'fromCsr': 'true'
    }

    desired_object = []
    # data = json.loads(data)
    for plan in data:
        addon_plan_list = df_dp_data["Addon Plan"].split("&&")
        for add_on_plan in addon_plan_list:
            if plan['description'] == add_on_plan:
                updated_item = plan.copy()
                # Append data_plan_payload_field dictionary to the updated_item
                updated_item.update(data_plan_payload_field)
                desired_object.append(updated_item)


    for data_plans in desired_object:
        addon_plan_charge = json.dumps(data_plans['addonPlanCharge'])
        data_plans['addonPlanCharge'] = addon_plan_charge
        data_plans['validityTerm'] = data_plans['dataValue']
        # data_plans['product_char'] = json_string_single_quotes

    dataplan_json = json.dumps(desired_object)

    payload = {
    # 'dataPlan': str(desired_object),
    'dataPlan': dataplan_json,
    }

    # payload_json = json.dumps(payload)
    # url_encoded_data = urlencode(payload)

    return payload


def data_plan_publish_status(plan_id):
    payload = {
        'planIds' : str(plan_id),
        # 'planIds':'189,190,191,192,193,194',
        'action':'PUBLISH'
    }

    # payload = urlencode(payload, quote_via=urllib.parse.quote)
    payload = json.dumps(payload)
    return payload


from collections import OrderedDict


def unique_preserve_order_ordered(input_string):
    return list(OrderedDict.fromkeys(input_string.split("&&")))

def account_level_discount_payload(account_id,account_level_discount,df_data,csrId):

    pricing_category_list = []

    pricing_category = {
        "operationType": 0,
        "name": "ACCOUNT_LEVEL_DISCOUNT",
        "price": None,
        "extraMdata": "{\"p_uuid\":\"dd733ca9-c6f4-4c91-9c0f-be19d2ef34c1\",\"uuid\":\"fd5da3e1-807d-4ccb-ac38-4625ca0287df\",\"extraMetadata\":null,\"applicableTo\":\"specific\",\"end_date\":null,\"gl_code\":749,\"uom\":\"%\",\"amount\":\"100\",\"charge_category\":[\"Account Level VAS RC\"],\"is_prorated\":false,\"sub_category\":\"Account Level\",\"name\":\"Private APN Installation Fees Discount\",\"id\":87,\"type\":\"Flat\",\"category\":\"Billing\",\"start_date\":\"2024-11-28\",\"discountLevel\":\"Account Level\",\"plan\":\"\",\"operationType\":0}"
    }
    today = datetime.today()
    # Calculate previous month
    if today.month == 1:  # Handle January case
        previous_month = 12
        year = today.year - 1
    else:
        previous_month = today.month - 1
        year = today.year

    start_date = datetime(year, previous_month, 28).strftime('%Y-%m-%d')

    # account_level_discount = {}
    for disc in account_level_discount:
        # account_level_discount_list = df_data["Account Level Discount Name"].split("&&")
        account_level_discount_list = unique_preserve_order_ordered(df_data["Account Level Discount Name"])
        account_level_price_list = df_data["Account_level_Discount_Price"].split("&&")
        for account_level, account_price in zip(account_level_discount_list, account_level_price_list):
            if (disc['name'] == account_level):
                updated_item = pricing_category.copy()
                extra_mdata = json.loads(updated_item['extraMdata'])
                extra_mdata.update(disc)
                extra_mdata['amount'] = account_price
                extra_mdata['start_date'] = start_date
                updated_item['extraMdata'] = json.dumps(extra_mdata)
                pricing_category_list.append(updated_item)

    pricing_category_json = json.dumps(pricing_category_list)
    
    payload = {
        'accountId':account_id,
        'operation':0,
        'pricingCategoriesList':pricing_category_json,
        'csrId':csrId  
    }
    print("helloyogesh_sharma",payload)

    return payload