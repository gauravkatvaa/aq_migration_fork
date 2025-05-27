import pandas as pd
import numpy as np
import json


def replace_none_with_null(data):
    if isinstance(data, dict):
        return {key: replace_none_with_null(value) if value is not None else None for key, value in data.items()}
    elif isinstance(data, list):
        return [replace_none_with_null(item) if item is not None else None for item in data]
    else:
        return data


def create_apn_payload(row,account_id,subnet_ip):

    # Load the CSV file
    # Extracting username and password from the current row
    payload = {
      'accountId': str(account_id),
      'apnName': row['apnName'],
      'apnDescription': row['apnDescription'],
      'apnId': row['apnId'],
      'apnType': row['apnType'],
      'apnTypeIpv6':'',
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
      'hssProfileId': '32921',
      'ipPoolAllocationType': row['ipPoolAllocationType'],
      'subnet': subnet_ip,
      'ipPoolType': row['ipPoolType'],
      'requestSubType': row['requestSubType'],
      'requestFrom': row['requestFrom'],
      'info': row['info'],
      'subnetIpv6': row['subnetIpv6'],
      'apnServiceType': row['apnServiceType'],
      'apnWlBlcategory':row['apnWlBlcategory'],
      'splitBilling': row['splitBilling'],
      'roamingEnabled': row['roamingEnabled'],
      'radiusAuthenticationEnable': row['radiusAuthenticationEnable'],
      'radiusAuthType':'',
      'radiusUsername':'',
      'radiusPassword':'',
      'radiusForwardingEnable': row['radiusForwardingEnable']
    }
    # URL encoding the payload for the request
    # payload = json.dumps(payload)
    return payload



def add_sim_product_payload(row,account_id):
    payload = {
      'accountId': account_id,
      'customerName': row['customer_name'],
      'productName': row['productName'],
      'serviceType': row['service type'],
      'serviceSubType1': row['serviceSubType1'],
      'serviceSubType2': row['serviceSubType2'],
      'serviceSubType3': row['serviceSubType3'],
      'serviceSubType4': row['serviceSubType4'],
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



def lead_person_payload(row,account_id,role_id):
  payload = {
    'firstName': row['firstName'],
    'lastName': row['lastName'],
    'primaryPhone': row['primaryPhone'],
    'secondaryPhone': row['secondaryPhone'],
    'email': row['email'],
    'emailConf': row['emailConf'],
    'roleId': role_id,
    'countryId': row['countryId'],
    'timeZoneId': row['timeZoneId'],
    'locked': row['locked'],
    'accountId': account_id,
    'userName': row['userName'],
    'groupId': row['groupId'],
    'userType': row['userType'],
    'userAccountType': row['userAccountType'],
    'supervisorId': row['supervisorId'],
    'resetPasswordAction': row['resetPasswordAction'],
    'reason': row['reason']
  }
  # clean_params = {k: ('' if pd.isna(v) else v) for k, v in payload.items()}
  # payload = '&'.join(f"{k}={v}" for k, v in clean_params.items())
  return payload


def create_user_payload(row,role_id):
  payload = {
    'CPDID': row['CPDID'],
    'primaryPhone': row['primaryPhone'],
    'secondaryPhone': row['secondaryPhone'],
    'email': row['email'],
    'emailConf': row['emailConf'],
    'roleId': role_id,
    'countryId': row['countryId'],
    'timeZoneId': row['timeZoneId'],
    'locked': row['locked'],
    'accountId': row['account_id'],
    'userName': row['userName'],
    'groupId': row['groupId'],
    'userType': row['userType'],
    'userAccountType': row['userAccountType'],
    'supervisorId': row['supervisorId'],
    'resetPasswordAction': row['resetPasswordAction'],
    'firstName': row['firstName'],
    'lastName': row['lastName'],
    'reason': 'Not Provided'
  }
  # account_id = fetch_account_id()

  # clean_params = {k: ('' if pd.isna(v) else v) for k, v in params.items()}
  # payload = '&'.join(f"{k}={v}" for k, v in clean_params.items())
  return payload


def soap_api_customer_onbording_payload(row):
  soap_body = f"""<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.airlinq.com/">
      <soapenv:Header>
      <web:orderNumber>{row['orderNumber']}</web:orderNumber>
      <web:taskID>{row['taskId']}</web:taskID>
      </soapenv:Header>
      <soapenv:Body>
      <web:createOnboardCustomer>
      <businessUnitName>{row['businessUnitName']}</businessUnitName>
      <customer>
      <unifiedID>{row['unifiedID']}</unifiedID>
      <customerReferenceNumber>{row['customerReferenceNumber']}</customerReferenceNumber>
      <customerSegmentCode>{row['customerSegmentCode']}</customerSegmentCode>
      <customerType>{row['customerType']}</customerType>
      <billHierarchyFlag>{row['billHierarchyFlag']}</billHierarchyFlag>
      <companyName>{row['companyName']}</companyName>
      <customerName>
      <firstName>{row['firstName']}</firstName>
      <lastName>{row['lastName']}</lastName>
      <alternateName>{row['alternateName']}</alternateName>
      </customerName>
      <partyIdentification>
      <identificationTypeCode>{row['identificationTypeCode']}</identificationTypeCode>
      <identityNumber>{row['identityNumber']}</identityNumber>
      </partyIdentification>
      <primaryPhoneNumber>{row['primaryPhoneNumber']}</primaryPhoneNumber>
      <languageCode>{row['languageCode']}</languageCode>
      <customerAddress>
      <country>{row['country_EC']}</country>
      <zipCode>{row['zipCode_EC']}</zipCode>
      <addressType>{row['addressType_EC']}</addressType>
      <addressLine1>{row['addressLine1_EC']}</addressLine1>
      <addressLine2>{row['addressLine2_EC']}</addressLine2>
      <addressLine3>{row['addressLine3_EC']}</addressLine3>
      <addressLine4>{row['addressLine4_EC']}</addressLine4>
      <addressLine5>{row['addressLine5_EC']}</addressLine5>
      </customerAddress>
      <customerGenre>{row['customerGenre']}</customerGenre>
      <category>{row['category']}</category>
      <maxNumberIMSIs>{row['maxNumberIMSIs']}</maxNumberIMSIs>
      <!--Optional:-->
      <techContactPersonMobile>{row['techContactPersonMobile']}</techContactPersonMobile>
      <!--Optional:-->
      <techContactPersonEmail>{row['techContactPersonEmail']}</techContactPersonEmail>
      <!--Optional:-->
      <leadPersonOrAccManagerID>{row['lead_person_id']}</leadPersonOrAccManagerID>
      <!--Optional:-->
      <localData>{row['c_localData']}</localData>
      <!--Optional:-->
      <dataWithInternet>{row['c_dataWithInternet']}</dataWithInternet>
      <!--Optional:-->
      <voiceWithInternet>{row['c_voiceWithInternet']}</voiceWithInternet>
      <!--Optional:-->
      <preferredLanguage>{row['c_preferredLanguage']}</preferredLanguage>
               </customer>
      <billingAccount>
      <billingAccountName>{row['billingAccountName']}</billingAccountName>
      <billingAccountNumber>{row['billingAccountNumber']}</billingAccountNumber>
      <billingAccountStatus>{row['billingAccountStatus']}</billingAccountStatus>
      <billCycle>{row['billCycle']}</billCycle>
      <maxSIMNumber>{row['maxSIMNumber']}</maxSIMNumber>
      <fingerprintStatus>{row['fingerprintStatus']}</fingerprintStatus>
      <buTechContactPersonMobile>{row['buTechContactPersonMobile']}</buTechContactPersonMobile>
      <buTechContactPersonEmail>{row['buTechContactPersonEmail']}</buTechContactPersonEmail>

      <billingAddress>
      <country>{row['country_BU']}</country>
      <zipCode>{row['zipCode_BU']}</zipCode>
      <addressType>{row['addressType_BU']}</addressType>
      <addressLine1>{row['addressLine1_BU']}</addressLine1>
      <!--Optional:-->
      <addressLine2>{row['addressLine2_BU']}</addressLine2>
      <!--Optional:-->
      <addressLine3>{row['addressLine3_BU']}</addressLine3>
      <!--Optional:-->
      <addressLine4>{row['addressLine4_BU']}</addressLine4>
      <!--Optional:-->
      <addressLine5>{row['addressLine5_BU']}</addressLine5>
      </billingAddress>
      </billingAccount>
      </web:createOnboardCustomer>
      </soapenv:Body>
      </soapenv:Envelope> """

  print(soap_body)
  # print(f"SOAP Body for row {index}:\n{soap_body}\n")
  encoded_soap_body = soap_body.encode('utf-8')
  return encoded_soap_body




def create_ip_poll_payload(row,ip_available_range):

  ip_range = replace_none_with_null(ip_available_range)

  ip_range_output = json.dumps(ip_range) 
  payload = {
    'accountId':row['buAccount_id'],
    'apnId':row['ac_apn_id'],
    'availableRange':ip_range_output,
    'requestedIps': row['NUMBER_OF_REQUESTED_IPS']
  }
  return payload



def create_cost_center_payload(row):
   payload = {
      'buAccountId':row['buAccount_id'],
      'name':row['name'],
      'comments': ''
   }

   return payload


def api_user_payload(row):
  # api_mapping_id = json.dumps(row['apiMappingIds']) 
  payload={
    'accountId':row['account_id'],
    'userName':row['LOGIN'],
    'firstName':row['FIRST_NAME'],
    'lastName':row['LAST_NAME'],
    'emailId':row['EMAIL'],
    'locked':row['locked'],
    'apiMappingIds':row['apiMappingIds'],
    'states':row['states'],
    'reason':row['reason']
  }
  return payload


def white_listing_payload(row):
  whitelist = json.dumps(row['ipWhitelistingMapping'])
  payload={
    'account':row['new_account_id'],
    'customer':row['customer_id'],
    'ipWhitelistingMapping':whitelist
  }
  return payload

def apn_assing_payload(row):
  filtered_accountBuId = ','.join(filter(None, row['buAccount_id'].split(',')))
  payload={
    'apnId':row['ac_apn_id'],
    'accountBuId':filtered_accountBuId
  }
  return payload

def ip_pooling_assing_payload():
  
  payload={}
  return payload
