import json
from urllib.parse import urlencode
import urllib.parse
import random


def replace_none_with_null(data):
    if isinstance(data, dict):
        return {key: replace_none_with_null(value) if value is not None else None for key, value in data.items()}
    elif isinstance(data, list):
        return [replace_none_with_null(item) if item is not None else None for item in data]
    else:
        return data


def enterprise_customer_payload(row,logger_error,parent_id):
  try:

    # payload = 'parentAccountId=6&name=TestAcc01&accountModel=&classifier=E_SIM&state=&billingFlag=true&accountSegment=&redirectionRatingGroupId=0&redirectionUrl=&bssId=&bssUserName=&bssPassword=&billingContactName=yash&billingAddress=Yash&billingEmail=yash.sharma%40airlinq.com&billingTelephone=9992229992&billingMobile=&primaryContactFirstName=Yash&primaryContactLastName=Yash&primaryContactTelephone=9992229992&primaryContactMobile=&primaryContactEmail=yash.sharma%40airlinq.com&soContactFirstName=&soContactLastName=&soContactEmail=&soContactTelephone=&soContactMobile=&soContactAddress=&sourceNumber=59998&modemType=&unitType=&simType=&deviceVolume=&deviceDescription=&notes=&bssClientCode=&goup_user_name=&goup_user_key=&goup_password=&application_key=&goup_url=&token_url=&isBss=1&accountType=Enterprise%20Business%20Unit&billDate=2&frequency=Monthly&regionId=&areaCode=&legacyBan=&billingSecondaryEmail=yash.sharma%40airlinq.com&primaryContactAddress=yash&countryId=107&currencyId=10&externalId=&isActivate=1&imeiLock=false&serviceGrant=false&accountState=Active&suspensionStatus=false&terminationStatus=4&terminationStateStatus=false&terminationRetentionStatus=&maxSimNumber=0&simAccountType=true&isThirdPartyAccount=false&associatedAccountIds=&taxId=&smsrId=&iccidManager=&profileType=&providerId=&enterpriseId=&simManufacturer=&contractNumber=rr45&whiteList=false&notificationCentreApiUrl=https%3A%2F%2F192.168.1.37%3A8016%2FNotificationCenter%2Fimei%2Fnotification&extendedDetail=false&notificationUrlSmsForwarding=&featureSubTypeSmsForwarding=1&accountCommitments='
    payload = {
      'parentAccountId': parent_id,
      'name': row['name'],
      'accountModel': row['accountModel'],
      'classifier': row['classifier'],
      'state': row['state'],
      'billingFlag': row['billingflag'],
      'accountSegment': row['accountSegment'],
      'redirectionRatingGroupId': row['redirectionRatingGroupId'],
      'redirectionUrl': row['redirectionUrl'],
      'bssId': row['bssid'],
      'bssUserName': row['bssUserName'],
      'bssPassword': row['bssPassword'],
      'accountCommitments':row['accountCommitments'],
      'billingContactName': row['billingContactName'],
      'billingAddress': row['billingAddress'],
      'billingAddressLine2': row['billingAddressLine2'],
      'billingZipCode':row['billingZipCode'],
      'billingCity':row['billingCity'],
      'billingState':row['billingState'],
      'billingCountry':row['billingCountry'],
      'billingEmail': row['billingEmail'],
      'billingTelephone': row['billingTelephone'],
      'billingMobile': row['billingMobile'],
      'primaryContactFirstName': row['primaryContactFirstName'],
      'primaryContactLastName': row['primaryContactLastName'],
      'primaryContactTelephone': row['primaryContactTelephone'],
      'primaryContactMobile': row['primaryContactMobile'],
      'primaryContactEmail': row['primaryContactEmail'],
      'soContactFirstName': row['soContactFirstName'],
      'soContactLastName': row['soContactLastName'],
      'soContactEmail': row['soContactEmail'],
      'soContactTelephone': row['soContactTelephone'],
      'soContactMobile': row['soContactMobile'],
      'soContactAddress': row['soContactAddress'],
      # 'sourceNumber':row['sourceNumber'],
      'sourceNumber':'',
      # 'sourceNumber':'5674892',
      'modemType': row['modemType'],
      'unitType': row['unitType'],
      'simType': row['simType'],
      'deviceVolume': row['deviceVolume'],
      'deviceDescription': row['deviceDescription'],
      'notes': row['notes'],
      'bssClientCode': row['bssClientCode'],
      'goup_user_name': row['goup_user_name'],
      'goup_user_key': row['goup_user_key'],
      'goup_password': row['goup_password'],
      'application_key': row['application_key'],
      'goup_url': row['goup_url'],
      'token_url': row['token_url'],
      'isBss': row['isBss'],
      'accountType': row['accountType'],
      'billDate': row['billDate'],
      'frequency': row['frequency'] if row['frequency'] and row['frequency'] != '' else 'Monthly',
      'regionId': row['regionId'],
      'areaCode': row['areaCode'],
      'legacyBan': row['legacyBan'],
      'billingSecondaryEmail': row['billingSecondaryEmail'],
      'primaryContactAddress': row['primaryContactAddress'],
      'primaryContactAddressLine2' : row['primaryContactAddressLine2'],
      'zipCode': row['zipCode'],
      'primaryContactCity':row['primaryContactCity'],
      'primaryContactState': row['primaryContactState'],
      'primaryContactCountry': row['primaryContactCountry'],
      'countryId': row['countryId'],
      'currencyId': row['currencyid'],
      'externalId': row['externalId'],
      'isActivate': row['isActivate'],
      'imeiLock': row['imeiLock'],
      'serviceGrant': row['serviceGrant'],
      'accountState': row['accountState'],
      # 'suspensionStatus': row['suspensionStatus'],
      'suspensionStatus': 'false',
      'terminationStatus': row['terminationStatus'],
      'terminationStateStatus': 'false',    #row['terminationStateStatus'],
      'terminationRetentionStatus':  '' ,  #row['terminationRetentionStatus'],
      'maxSimNumber': row['maxSimNumber'],
      'simAccountType': row['simAccountType'],
      'isThirdPartyAccount': row['isThirdPartyAccount'],
      'associatedAccountIds': row['associatedAccountIds'],
      'taxId': row['taxId'],
      'smsrId': row['smsrId'],
      'iccidManager': row['iccidManager'],
      'profileType': row['profileType'],
      'providerId': row['providerId'],
      'enterpriseId': row['enterpriseId'],
      'simManufacturer': row['simManufacturer'],
      'contractNumber': row['contractNumber'],
      'whiteList': row['whiteList'],
      'notificationCentreApiUrl': row['notificationCentreApiUrl'],
      'extendedDetail': row['extendedDetail'],
      'notificationUrlSmsForwarding': row['notificationUrlSmsForwarding'],
      'featureSubTypeSmsForwarding': row['featureSubTypeSmsForwarding'],
      'extraMetadata': row['extraMetadata'],
      'salesforceId': row['salesforceId'],
      'calendarMonth' : row['calendarMonth'],
      'billingPrimaryCountryCode': 1,
      'billingSecondaryCountryCode': 1,
      'contactDetailsPrimaryCountryCode': 1,
      'contactDetailsSecondaryCountryCode': '',
      # "relationId": "202415175563",
      # "requestId":"GCAPI20250307080826510"
      "relationId": "202415175563" + str(random.randint(1000, 9999)),
      "requestId": "GCAPI20250307080826510" + str(random.randint(1000, 9999))
    }
    # print("State : ",payload['state'])
    # payload = json.dumps(payload)
    # payload = urlencode(payload)
    payload = urlencode(payload, quote_via=urllib.parse.quote)
    # payload = urlencode(payload)
    # payload = payload.replace('+', '%20')
    return payload
  except Exception as e:
    print("Error ", e)
    logger_error.error('Error {}'.format(e))


def cost_center_payload(bu_account_id,row,logger_error):
  try:
    payload = {
      'buAccountId':bu_account_id,
      'name':row['name'],
      'comments':row['comments']
    }
    payload = urlencode(payload, quote_via=urllib.parse.quote)
    return payload
  except Exception as e:
    print("Error In Cost Center Payload ", e)
    logger_error.error('Error In Cost Center Payload {}'.format(e))


def user_payload(row,role_id,logger_error):
  try:
    payload = {
      'firstName':row['firstName'],
      'lastName':row['lastName'],
      'primaryPhone':row['primaryPhone'],
      'secondaryPhone':row['secondaryPhone'],
      'email':row['email'],
      'emailConf':row['emailConf'],
      'roleId':role_id,
      'countryId':row['countryId'],
      'timeZoneId':row['timeZoneId'],
      'locked':row['locked'],
      'accountId':row['account_id'],
      'userName':row['userName'],
      'groupId':row['groupId'],
      'userType':row['userType'],
      'userAccountType':row['userAccountType'],
      'supervisorId':row['supervisorId'],
      'resetPasswordAction':row['resetPasswordAction'],
      'reason':row['reason'],
      'secondaryCountryCode':row['secondaryCountryCode'],
      'countryCode':row['countryCode']
    }
    payload = urlencode(payload, quote_via=urllib.parse.quote)
    return payload
  except Exception as e:
    print("Error In User Payload ", e)
    logger_error.error('Error In User Payload {}'.format(e))


def role_access_payload(row,logger_error,account_id):

  try:
    payload = {
      'groupId': row['groupId'],
      'accountId': account_id,
      'roleName': row['roleName'],
      'roleDescription': row['roleDescription'],
      'roleToScreenList': row['roleToScreenList'],
      'roleToTabList': row['roleToTabList']
    }
    payload = urlencode(payload, quote_via=urllib.parse.quote)
    return payload
  except Exception as e:
    print("Error ", e)
    logger_error.error('Error {}'.format(e))


def create_apn_payload(row,account_id,subnet_ip,ipv6_subnet,logger_error):

    # Load the CSV file
    # Extracting username and password from the current row
    try:

      payload = {
        'accountId': str(account_id),
        'apnName': row['apnName'],
        'apnDescription': row['apnDescription'],
        'apnId': row['apnId'],
        'apnType': row['apnType'],
        'apnTypeIpv6':row['apnTypeIpv6'],
        'privateShared': row['privateShared'],
        'eqosid': row['eqosid'],
        'apnIp': row['apnIp'],
        'apnCategory': row['apnCategory'],
        'addressType': row['addressType'],
        'mcc': row['mcc'],
        'mnc': row['mnc'],
        'hlrApnId': row['hlrApnId'],
        'hssContextId': row['hssContextId'],
        'profile2g3g': row['profile2g3g'],
        'uplink2g3g': row['uplink2g3g'],
        'uplinkunit2g3g': row['uplinkunit2g3g'],
        'downlink2g3g': row['downlink2g3g'],
        'downlinkunit2g3g': row['downlinkunit2g3g'],
        'profilelte': row['profilelte'],
        'uplinklte': row['uplinklte'],
        'uplinkunitlte': row['uplinkunitlte'],
        'downllinklte': row['downllinklte'],
        'downllinunitklte': row['downllinunitklte'],
        'hssProfileId': row['hssProfileId'],
        'ipPoolAllocationType': row['ipPoolAllocationType'],
        'subnet': subnet_ip,
        'subnetIpv6': ipv6_subnet,
        'ipPoolType': row['ipPoolType'],
        'requestSubType': row['requestSubType'],
        'requestFrom': row['requestFrom'],
        'info': row['info'],
        'apnServiceType': row['apnServiceType'],
        'apnWlBlcategory': row['apnWlBlcategory'],
        'splitBilling': row['splitBilling'],
        'roamingEnabled': row['roamingEnabled'],
        'radiusAuthenticationEnable': row['radiusAuthenticationEnable'],
        'radiusAuthType': row['radiusAuthType'],
        'radiusUsername': row['radiusUsername'],
        'radiusPassword': row['radiusPassword'],
        'radiusForwardingEnable': row['radiusForwardingEnable']
      }

      payload = urlencode(payload, quote_via=urllib.parse.quote)
      return payload
    except Exception as e:
      print("Error ", e)
      logger_error.error('Error {}'.format(e))


def add_sim_product_payload(row, account_id):
    """
    Creates a payload for adding a SIM product.

    Args:
        row: A dictionary or a row of data containing product details.
        account_id: The account ID associated with the product.

    Returns:
        A dictionary representing the payload.
    """
    payload = {
        'accountId': account_id,
        'customerName': row['customer_name'],
        'productName': row['productName'],
        'serviceType': 'Postpaid' if row['service type'].upper() == 'POSTPAID' else 'Prepaid' if row['service type'].upper() == 'PREPAID' else row['service type'],
        'serviceSubType1': row['serviceSubType1'],
        'serviceSubType2': row['serviceSubType2'],
        'serviceSubType3': row['serviceSubType3'],
        'serviceSubType4': row['serviceSubType4'],
        'defaultSubscriptionProfile':row['defaultSubscriptionProfile'],
        'alternativeSubscriptionProfile':row['alternativeSubscriptionProfile'],
        'packagingSize': row['packagingSize'],
        'ordered': row['ordered'],
        'comments': row['comments']
    }
    return payload


def assign_customer_to_sim_product(account_id):
  payload = {
    'customers': str(account_id)
  }
  return payload


def report_subscriptions_payload(row):
  payload = {
        "accountId": row["account_id"],
        "isEmailEnable":row["isEmailEnable"] ,
        "emailId": row["emailId"],
        "type": row["type"],
        "reportType": row["reportType"],
        "reportStartDate": row["reportStartDate"],
        "reportEndDate": row["reportEndDate"],
        "roleId":row["roleId"],
        "level": row["level"],
        "subscriptionName": row["subscriptionName"],
        "subscriptionType":row['subscriptionType'],
        "fromValue": row["fromValue"],
        "toValue": row["toValue"],
        "reportSubscriptionDetails": row['reportSubscriptionDetails'],
        "from_plan": row["from_plan"],
        "to_plan": row["to_plan"]
    }
  
  return payload

# def create_ip_pool_payload(row):
#   payload = {
#     'accountId': row['accountId'],
#     'apnId': row['apnId'],
#     'requestedIps': row['requestedIps'],
#     'availablerange': row['availablerange']
#   }

#   return {
#     'accountId': 40006,
#     'apnId': 978,
#     'requestedIps': 2,
#     'availablerange': json.dumps([{"id":None,"errorCode":0,"errorMessage":None,"createDate":None,"apnId":None,"startingIp":"98.23.34.13","endingIp":"98.23.34.14","subnet":"98.23.34.13/30","noOfHost":"2","availableHost":None,"nextAvailableHost":"98.23.34.15","totalHost":0,"availableHostCount":None,"addressType":0,"fullyUsed":None,"serviceApnIpAllocationId":700,"remaningNoOfHosts":None}])
#   }


def create_ip_poll_payload(row, ip_available_range):
  ip_range = replace_none_with_null(ip_available_range)
 
  ip_range_output = json.dumps(ip_range) 
  
  payload = {
    'accountId': row['account_id'],
    'apnId': row['apn_id'],
    'availableRange': ip_range_output,
    'requestedIps': row['requestedIps']
  }

  return payload

