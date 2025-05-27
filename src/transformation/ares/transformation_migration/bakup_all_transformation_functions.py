import sys

sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *
from src.utils.utils_lib import *
import datetime
import json
import re
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))



from datetime import datetime, timedelta

# Get current time in IST
ist_time = datetime.now()

# Define the time difference between IST and Vienna time zones
ist_offset = timedelta(hours=5, minutes=30)  # IST is 5 hours and 30 minutes ahead of UTC
vienna_offset = timedelta(hours=1)  # Vienna time zone is 1 hour ahead of UTC

# Calculate the current time in Vienna
vienna_time = ist_time - ist_offset + vienna_offset


def is_ipv4(ip):
    ipv4_pattern = r'^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$'
    return bool(re.match(ipv4_pattern, ip))


# Function to check if the given IP is IPv6
def is_ipv6(ip):
    ipv6_pattern = r'^([a-fA-F0-9:]+:+)+[a-fA-F0-9:]+/\d{1,3}$'
    return bool(re.match(ipv6_pattern, ip))


# Function to process the IP string for IPv4 and IPv6 addresses
def process_ip(ip):
    result = {'subnet': '', 'subnetIpv6': ''}

    try:
        # Split the input IP string by spaces
        ip_parts = ip.split()
        # print(ip_parts)
        # print("type_of_ip_part",type(ip_parts))
       

        # Loop through each part and assign to the correct column based on type
        for part in ip_parts:
            if is_ipv4(part):
                result['subnet'] += part + ' '  # Append IPv4 to 'subnet'
            elif is_ipv6(part):

                result['subnetIpv6'] += part + ' '  # Append IPv6 to 'subnetIpv6'

        # Strip any trailing spaces
        result['subnet'] = result['subnet'].strip()
        result['subnetIpv6'] = result['subnetIpv6'].strip()

    except Exception as e:
        print(f"Error occurred while processing IPs: {e}")
    
    return result

# Main function to handle the row processing
def process_ip_assignment(row):
    try:
        if row['IP_ASSIGNMENT'] == 'static':
            if row['TYPE'] == 'IPv4':
                # Only update 'subnet' for IPv4
                return pd.Series([row['IP_POOL'], None])  
            elif row['TYPE'] == 'IPv6':
                # Only update 'subnetIpv6' for IPv6
                return pd.Series([None, row['IP_POOL']])  
            elif row['TYPE'] == 'IPv4 and IPv6':
                # Use process_ip function to handle both IPv4 and IPv6
                print("ip_pool",row['IP_POOL'])
                ip_result = process_ip(row['IP_POOL'])
                return pd.Series([ip_result['subnet'], ip_result['subnetIpv6']])
        # Default case when conditions are not met
        return pd.Series([None, None])

    except Exception as e:
        print(f"Error processing row: {row} -> {e}")
        return pd.Series([None, None])  # Return None values if an error occurs

def get_id(row,country_id_mapping,logger_error):
    try:
        # Split the string by semicolon to get key-value pairs
        key_value_pairs = row.split(';')

        # Iterate over key-value pairs to find the value for "Country" key
        for pair in key_value_pairs:
            key, value = pair.split(':')
            if key.strip() == 'COUNTRY':
                country_name = value.strip()
                return int(country_id_mapping.get(country_name,0))
    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred in get_id function: {e}")
        return None


def extract_data_from_address(address, keyword,logger_error):
    try:
        # Split the address string into key-value pairs
        address_parts = address.split(';')
        address_dict = {}

        # Populate the dictionary with key-value pairs
        for part in address_parts:
            key, value = part.split(':')
            address_dict[key.strip().lower()] = value.strip()

        # Extract the value based on the provided keyword
        result = address_dict.get(keyword.lower())
        return result

    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None

def merge_and_create_address(df1, df2, key, logger_error):
    # print(df1.columns)
    # print(df2.columns)
    try:
        # Check if 'PARTY_ROLE_ID' exists in df1
        if 'PARTY_ROLE_ID' not in df1.columns:
            raise KeyError(f"'PARTY_ROLE_ID' column is missing in the provided DataFrame.")
        
        # Merge df1 and df2 on PARTY_ROLE_ID and key
        merged_df = pd.merge(df2, df1, left_on=key, right_on='PARTY_ROLE_ID', how='left')
        # merged_df.to_csv("merged_df.csv",index=False)
        
        
        merged_df['company_address'] = merged_df.apply(
            lambda row: f"COUNTRY:{row['COUNTRY']};STREET:{row['STREET']};BUILDING:{row['BUILDING']};POSTAL_CODE:{row['POSTAL_CODE']};CITY:{row['CITY']};STATE:{'STATE'};COUNTRY:{'COUNTRY'}"
            if pd.notnull(row['PARTY_ROLE_ID']) else None, axis=1)
        
        return merged_df

    except KeyError as e:
        logger_error.error(f"Key error: {e}")
        return None
    except Exception as e:
        logger_error.error(f"An error occurred during merging or address formatting: {e}")
        return None




def Enterprise_Customer_transformation(df, country_id_mapping, _dict,logger_info,logger_error,company_address_tables_df):
    try:
        df=merge_and_create_address(company_address_tables_df,df,'CRM_ID',logger_error)
        print("company_address",df['company_address'])
        filtered_df = pd.DataFrame()

        # df.to_csv("validation.csv", index=False)
        
        ##### default values
        filtered_df['legacyBan'] = df['CRM_ID']
        filtered_df['frequency'] = 'Monthly'
        
        print("filtered_df", filtered_df['frequency'])
        
        # Mapping values
        filtered_df['billingFlag'] = df['INVOICING_LEVEL_TYPE'].map({'Customer': 'false', 'Business Unit': 'true'})
        filtered_df['accountState'] = df['ACTIVATION_STATUS'].map({'Live': 'Active', 'Test': 'Test'})
        
        # Map other columns
        filtered_df['parentAccountId'] = df['OPCO_CRM_ID']
        filtered_df['name'] = df['EC_NAME']
        
        filtered_df['contractNumber'] = df['FRAME_CONTRACT_NUMBER']
        filtered_df['NotificationCentreApiUrl'] = notificaton_url  #notificationCentreApiUrl
        

        filtered_df['countryId'] = df['company_address'].apply(get_id, country_id_mapping=country_id_mapping,logger_error=logger_error)
        
       
        df['CURRENCY'] = 'EUR'
        filtered_df['currencyId'] = df['CURRENCY'].map(_dict).fillna(0).astype('Int64')
        print(filtered_df['currencyId'])
        
        

        # Fill in default values for other columns
        filtered_df['billDate'] = '1'

        
        filtered_df['billingContactName'] = '-'
        filtered_df['billingAddress'] = df['company_address'].apply(lambda x: extract_data_from_address(x, 'STREET', logger_error))
        filtered_df['billingAddressLine2']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'BUILDING', logger_error))
        filtered_df['billingZipCode']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'POSTAL_CODE', logger_error))
        filtered_df['billingCity']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'CITY', logger_error))
        filtered_df['billingState']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'STATE', logger_error))
        filtered_df['billingCountry']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'COUNTRY', logger_error))
        filtered_df['billingEmail'] = '-'
        filtered_df['billingTelephone'] = '-'
        filtered_df['billingMobile'] = '-'

        filtered_df['primaryContactFirstName'] = '-'
        filtered_df['primaryContactLastName'] = '-'
        filtered_df['primaryContactTelephone'] = ''
        filtered_df['primaryContactMobile'] = ''
        filtered_df['primaryContactEmail'] = ''
        
        
        filtered_df['terminationStatus'] = 4
        filtered_df['terminationStateStatus'] = 'true'
        filtered_df['terminationRetentionStatus'] = 'true'

        filtered_df['accountType'] = 'Enterprise Customer Account'
        filtered_df['accountModel'] = ''
        filtered_df['classifier'] = 'E_SIM'
        filtered_df['state'] = ''
        filtered_df['accountSegment'] = ''
        filtered_df['redirectionRatingGroupId'] = 0
        filtered_df['redirectionUrl'] = ''
        filtered_df['bssId'] =''
        filtered_df['bssUserName'] = ''
        filtered_df['bssPassword'] = ''
        filtered_df['accountCommitments']=''

        
        filtered_df['soContactFirstName'] = ''
        filtered_df['soContactLastName'] = ''
        filtered_df['soContactEmail'] = ''
        filtered_df['soContactTelephone'] = ''
        filtered_df['soContactMobile'] = ''
        filtered_df['soContactAddress'] = ''
        filtered_df['sourceNumber'] = random_number(5)
        filtered_df['modemType'] = ''
        filtered_df['unitType'] = ''
        filtered_df['simType'] = ''
        filtered_df['deviceVolume'] = ''
        filtered_df['deviceDescription'] = ''
        filtered_df['Notes'] = ''
        filtered_df['bssClientCode'] = ''
        filtered_df['goup_user_name'] = ''
        filtered_df['goup_user_key'] = ''
        filtered_df['goup_password'] = ''
        filtered_df['application_key'] = ''
        filtered_df['suspensionStatus'] = 'true'
        filtered_df['goup_url'] = ''
        filtered_df['token_url'] = ''
        filtered_df['isBss'] = 1
        filtered_df['regionId'] = ''
        filtered_df['areaCode'] = ''
        filtered_df['primaryContactAddress'] = '-'
        filtered_df['primaryContactAddressLine2']=''
        filtered_df['zipCode']=filtered_df['billingZipCode']
        filtered_df['primaryContactCity']=''
        filtered_df['primaryContactState']=''
        filtered_df['primaryContactCountry']=''

        filtered_df['billingSecondaryEmail'] = '-'
        filtered_df['externalId'] = ''
        filtered_df['isActivate'] = 1
        filtered_df['imeiLock'] = 'false'
        filtered_df['serviceGrant'] = 'false'
        filtered_df['maxSimNumber'] = 0
        filtered_df['simAccountType'] = 'true'
        filtered_df['isThirdPartyAccount'] = 'false'
        filtered_df['associatedAccountIds'] = ''
        filtered_df['taxId'] = ''
        filtered_df['smsrId'] = ''
        filtered_df['iccidManager'] = ''
        filtered_df['profileType'] = ''
        filtered_df['providerId'] = ''
        filtered_df['enterpriseId'] = ''
        filtered_df['simManufacturer'] = ''
        filtered_df['whiteList'] = 'false'
        filtered_df['extendedDetail'] = 'false'
        filtered_df['NotificationUrlSmsForwarding'] = '' #NotificationUrlSmsForwarding
        filtered_df['featureSubTypeSmsForwarding'] = '1'  ## need to be discuss 
        filtered_df['extraMetadata'] =df.apply(lambda row: {
        "cdrConfigurationEnabled": False if pd.isnull(row["ACTIVATE_PUSH_CDR"]) or row["ACTIVATE_PUSH_CDR"] == "" else row["ACTIVATE_PUSH_CDR"],
        "simCommitmentAllow": "false",
        "billingItemId": "",
        "retryLimit": "2",
        "cdrConfiguration": (
            [
                {
                    "api_url": row["PUSH_CDR_URL_1"],
                    "secret_Key": "",
                    "path": "",
                    "webhookusername": row["PUSH_CDR_PSWD_1"],
                    "webhookauthentication_type": "Basic",
                    "webhookPassword": row["PUSH_CDR_LOGIN_1"],
                    "webhookheader_type": "",
                    "dataFormat": "basic",
                    "showValue": False
                }
            ] + (
                [
                    {
                        "api_url": row["PUSH_CDR_URL_2"],
                        "secret_Key": "Api Key",
                        "path": "",
                        "webhookusername": row["PUSH_CDR_PSWD_2"],
                        "webhookauthentication_type": "API_Key",
                        "webhookPassword": row["PUSH_CDR_LOGIN_2"],
                        "webhookheader_type": "etertert",
                        "dataFormat": "basic",
                        "showValue": False
                    }
                ] if pd.notnull(row["PUSH_CDR_URL_2"]) and row["PUSH_CDR_URL_2"] != "" else []
            )
        ) if not pd.isnull(row["ACTIVATE_PUSH_CDR"]) and row["ACTIVATE_PUSH_CDR"] != "" else False
    },
    axis=1
)

        filtered_df['calendarMonth']='true'
        filtered_df['salesforceId']=df['SALESFORCE_CUSTOMER_ID']

        ### Newly added keys
        filtered_df['billingPrimaryCountryCode'] = 1
        filtered_df['billingSecondaryCountryCode'] = 1
        filtered_df['contactDetailsPrimaryCountryCode'] = 1
        filtered_df['contactDetailsSecondaryCountryCode'] = ''
        
            # print(filtered_df[column],default_value)
        
        print(filtered_df)
        logger_info.info(f"length of the succesfully,{len(filtered_df)}")
        # filtered_df.to_csv("hel4.csv",index=False)    
        return filtered_df

    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None



def users_transformation(df,logger_info,logger_error,country_id_mapping,company_address_tables_df,role_map_dict):
    try:
        filtered_df = pd.DataFrame()
        

        df['CRM_BU_ID'] = df['CRM_BU_ID'].replace('', pd.NA)
        print(df['CRM_BU_ID'])
        
        # Ensure CRM_BU_ID and CRM_CUSTOMER_ID are appropriate for conversion
        # Convert non-numeric values to NaN
        df['CRM_BU_ID'] = pd.to_numeric(df['CRM_BU_ID'], errors='coerce')
        df['CRM_CUSTOMER_ID'] = pd.to_numeric(df['CRM_CUSTOMER_ID'], errors='coerce')
        df['account_id']=df['CRM_BU_ID'].fillna(df['CRM_CUSTOMER_ID']).fillna(0).astype(int)
        df=merge_and_create_address(company_address_tables_df,df,'account_id',logger_error)
        
        
        
        filtered_df['firstName'] = df['FIRST_NAME']
        filtered_df['lastName'] = df['LAST_NAME']
        filtered_df['primaryPhone'] = df['PHONE_NUMBER']
        filtered_df['secondaryPhone'] = ''
        filtered_df['email'] = df['EMAIL']
        filtered_df['emailConf'] = df['EMAIL']
        
        
        # Handle NA values before converting to int
        filtered_df['accountid'] = df['account_id'] 
        df['USERTYPE'] = df['USERTYPE'].map(role_map_dict)
 
        filtered_df['roleId'] = df.apply(lambda row: f"{row['account_id']}_{row['USERTYPE']}", axis=1)
        filtered_df['countryid'] = df['company_address'].apply(get_id, country_id_mapping=country_id_mapping,logger_error=logger_error)
        filtered_df['timeZoneId'] =  Vienna_Time_Zone
        filtered_df['locked'] = 'true'
        filtered_df['groupId'] = '0'
        filtered_df['userName'] = df['LOGIN']
        filtered_df['userType'] = '1'
        filtered_df['userAccountType'] = 'NormalUser'
        filtered_df['supervisorId'] = ''
        filtered_df['resetPasswordAction'] = 'false'
        filtered_df['reason'] = "MIGRATION"
        filtered_df['countryCode']=''
        filtered_df['secondaryCountryCode']=''
        
    
        logger_info.info(f"length of the succesfully retrun in users,{len(filtered_df)}")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None

def bussinesss_unit_transformation(df,country_id_mapping,_dict,logger_info,logger_error,company_address_tables_df,billing_freqency_id_dict):
    try:
        df=merge_and_create_address(company_address_tables_df,df,'BUCRM_ID',logger_error)
        print("company_address",df['company_address'])
        filtered_df = pd.DataFrame()
        # df.to_csv("validation.csv", index=False)
        
       
        ##this point to understand
        filtered_df['billingFlag'] = df['INVOICING_LEVEL_TYPE'].map({'Customer': 'true', 'Business Unit': 'false'})
        filtered_df['accountState'] = df['ACTIVATION_STATUS'].map({'Live': 'Active', 'Test': 'Test'})

        
        filtered_df['legacyBan'] = df['BUCRM_ID']
        filtered_df['parentAccountId'] = df['EC_CRM_ID']
        filtered_df['name'] = df['BU_NAME']
                    
 
        filtered_df['contractNumber'] = '-'


       
        filtered_df['countryId'] =df['company_address'].apply(get_id, country_id_mapping=country_id_mapping,logger_error=logger_error)


        # Use np.select to apply the conditions and labels
        filtered_df['frequency'] = df['BILLING_CYCLE_ID'].map(billing_freqency_id_dict)
    
        filtered_df['currencyId'] = df['CURRENCY'].map(_dict).fillna(0).astype('Int64')
        

        # Fill in default values for other columns
        filtered_df['billDate'] = filtered_df['billingFlag'].apply(lambda x: '' if x == 'false' else 1)

        
        filtered_df['billingContactName'] = '-'
        filtered_df['billingAddress'] = df['company_address'].apply(lambda x: extract_data_from_address(x, 'STREET', logger_error))
        filtered_df['billingAddressLine2']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'BUILDING', logger_error))
        filtered_df['billingZipCode']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'POSTAL_CODE', logger_error))
        filtered_df['billingCity']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'CITY', logger_error))
        filtered_df['billingState']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'STATE', logger_error))
        filtered_df['billingCountry']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'COUNTRY', logger_error))
        filtered_df['billingEmail'] = '-'
        filtered_df['billingTelephone'] = '-'
        filtered_df['billingMobile'] = ''

        filtered_df['primaryContactFirstName'] = '-'
        filtered_df['primaryContactLastName'] = '-'
        filtered_df['primaryContactTelephone'] = ''
        filtered_df['primaryContactMobile'] = ''
        filtered_df['primaryContactEmail'] = ''
        
        
        filtered_df['terminationStatus'] = 4
        filtered_df['terminationStateStatus'] = 'true'
        filtered_df['terminationRetentionStatus'] = 'true'

        filtered_df['accountType'] =  'Enterprise Business Unit'
        filtered_df['accountModel'] = ''
        filtered_df['classifier'] = 'E_SIM'
        filtered_df['state'] = ''
        filtered_df['accountSegment'] = ''
        filtered_df['redirectionRatingGroupId'] = 0
        filtered_df['redirectionUrl'] = ''
        filtered_df['bssId'] =''
        filtered_df['bssUserName'] = ''
        filtered_df['bssPassword'] = ''
        filtered_df['accountCommitments']=''

        
        filtered_df['soContactFirstName'] = ''
        filtered_df['soContactLastName'] = ''
        filtered_df['soContactEmail'] = ''
        filtered_df['soContactTelephone'] = ''
        filtered_df['soContactMobile'] = ''
        filtered_df['soContactAddress'] = ''
        filtered_df['sourceNumber'] = random_number(5)
        filtered_df['modemType'] = ''
        filtered_df['unitType'] = ''
        filtered_df['simType'] = ''
        filtered_df['deviceVolume'] = ''
        filtered_df['deviceDescription'] = ''
        filtered_df['Notes'] = ''
        filtered_df['bssClientCode'] = ''
        filtered_df['goup_user_name'] = ''
        filtered_df['goup_user_key'] = ''
        filtered_df['goup_password'] = ''
        filtered_df['application_key'] = ''
        filtered_df['suspensionStatus'] = 'true'
        filtered_df['goup_url'] = ''
        filtered_df['token_url'] = ''
        filtered_df['isBss'] = 1
        filtered_df['regionId'] = ''
        filtered_df['areaCode'] = ''
        filtered_df['primaryContactAddress'] = '-'
        filtered_df['primaryContactAddressLine2']=''
        filtered_df['zipCode']=filtered_df['billingZipCode']
        filtered_df['primaryContactCity']=''
        filtered_df['primaryContactState']=''
        filtered_df['primaryContactCountry']=''

        filtered_df['billingSecondaryEmail'] = '-'
        filtered_df['externalId'] = ''
        filtered_df['isActivate'] = 1
        filtered_df['imeiLock'] = 'false'
        filtered_df['serviceGrant'] = 'false'
        filtered_df['maxSimNumber'] = 0
        filtered_df['simAccountType'] = 'true'
        filtered_df['isThirdPartyAccount'] = 'false'
        filtered_df['associatedAccountIds'] = ''
        filtered_df['taxId'] = ''
        filtered_df['smsrId'] = ''
        filtered_df['iccidManager'] = ''
        filtered_df['profileType'] = ''
        filtered_df['providerId'] = ''
        filtered_df['enterpriseId'] = ''
        filtered_df['simManufacturer'] = ''
        filtered_df['whiteList'] = 'false'
        filtered_df['extendedDetail'] = 'false'
        filtered_df['NotificationUrlSmsForwarding'] = '' 
        filtered_df['featureSubTypeSmsForwarding'] = ''
        filtered_df['extraMetadata']='{"cdrConfigurationEnabled":"false","simCommitmentAllow":"false","billingItemId":"","includedInBilling":false,"deliveryConfirmation":true}'
        filtered_df['calendarMonth']='true'
        filtered_df['salesforceId']=df['SALESFORCE_CUSTOMER_ID']
        filtered_df['billingItemId']=''
        filtered_df['smsConfiguration']= df.apply(
    lambda row: f"""{{
        "api_url": "{row['SMS_FORWARDING_HTTP_END_POINT']}",
        "webhookauthentication_type": "Basic",
        "webhookusername": "{row['SMS_FORWARDING_LOGIN']}",
        "webhookPassword": "{row['SMS_FORWARDING_PASSWORD']}",
        "webhookheader_type": "",
        "secret_Key": "",
        "path": "",
        "isSSLAction": false
    }}""",
    axis=1
)



         ### Newly added keys
        filtered_df['billingPrimaryCountryCode'] = 1
        filtered_df['billingSecondaryCountryCode'] = 1
        filtered_df['contactDetailsPrimaryCountryCode'] = 1
        filtered_df['contactDetailsSecondaryCountryCode'] = ''
        logger_info.info("bussiness_unit applied successfully.")

        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None



def update_COMPANYADDRESS(df, country_dict, logger_info, logger_error):
    try:
        df1 = read_table_as_df('bu_success', validation_db_configs, logger_error, logger_info)
        df1['TYPE'] = df1['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
        df1['EC_STATUS'] = df1['EC_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)

        df2 = read_table_as_df('ec_success', validation_db_configs, logger_error, logger_info)
        df2['TYPE'] = df2['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
        df2['BU_STATUS'] = df2['BU_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)
        logger_info.info("Starting the update_COMPANYADDRESS function.")
       
        # Convert empty strings in 'CRM_BU_ID' to NaN for proper filtering
        df['CRM_BU_ID'] = df['CRM_BU_ID'].replace('', pd.NA)

        # Convert columns to the same type (string) before merging
        df['CRM_BU_ID'] = df['CRM_BU_ID'].astype(str)
        df1['BUCRM_ID'] = df1['BUCRM_ID'].astype(str)
        df['CRM_CUSTOMER_ID'] = df['CRM_CUSTOMER_ID'].astype(str)
        df2['CRM_ID'] = df2['CRM_ID'].astype(str)

        # Step 1: Check if CRM_BU_ID exists in df1
        df_with_bu_id = df.dropna(subset=['CRM_BU_ID'])
        df_without_bu_id = df[df['CRM_BU_ID'].isna()]

        # Debug information
        logger_info.info(f"df_with_bu_id: {df_with_bu_id.shape}")
        logger_info.info(f"df_without_bu_id: {df_without_bu_id.shape}")

        # Step 2: Inner join with df1 based on CRM_BU_ID and BUCRM_ID
        if not df_with_bu_id.empty:
            df_with_bu_id = df_with_bu_id.merge(df1[['BUCRM_ID', 'COMPANYADDRESS']], 
                                                left_on='CRM_BU_ID', 
                                                right_on='BUCRM_ID', 
                                                how='left')
            print("df_with_bu_id",df_with_bu_id)
            df_with_bu_id = df_with_bu_id.drop(columns=['BUCRM_ID'])
            
            # Convert COMPANYADDRESS to string and extract country ID using get_id function
            df_with_bu_id['COMPANYADDRESS'] = df_with_bu_id['COMPANYADDRESS'].astype(str)
            df_with_bu_id['country_id'] = df_with_bu_id['COMPANYADDRESS'].apply(get_id, country_id_mapping=country_dict,logger_error=logger_error)
            df_with_bu_id = df_with_bu_id.drop(columns=['COMPANYADDRESS'])

        # Step 3: Check if CRM_CUSTOMER_ID exists in df2 for rows without CRM_BU_ID
        if not df_without_bu_id.empty:
            df_without_bu_id = df_without_bu_id.merge(df2[['CRM_ID', 'COMPANYADDRESS']], 
                                                      left_on='CRM_CUSTOMER_ID', 
                                                      right_on='CRM_ID', 
                                                      how='left')
            print("df_without_bu_id",df_without_bu_id)
            df_without_bu_id = df_without_bu_id.drop(columns=['CRM_ID'])
            

            # Convert COMPANYADDRESS to string and extract country ID using get_id function
            df_without_bu_id['COMPANYADDRESS'] = df_without_bu_id['COMPANYADDRESS'].astype(str)

            df_without_bu_id['country_id'] = df_without_bu_id['COMPANYADDRESS'].apply(get_id, country_id_mapping=country_dict,logger_error=logger_error)
            df_without_bu_id = df_without_bu_id.drop(columns=['COMPANYADDRESS'])

        # Debug information
        logger_info.info(f"df_with_bu_id after merge: {df_with_bu_id.shape}")
        logger_info.info(f"df_without_bu_id after merge: {df_without_bu_id.shape}")

        
        
        # Combine the two dataframes
        result_df = pd.concat([df_with_bu_id, df_without_bu_id], ignore_index=True)
         # Default to default_country_id if country_id is NA
        result_df['country_id'] = result_df['country_id'].fillna(default_country_id)
        result_df['country_id']=result_df['country_id'].astype('Int64')
        logger_info.info("Successfully updated the company address.")
        print(result_df)
        result_df.to_csv("users_trans.csv",index=False)
        return result_df

    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None





def role_transformation(df,logger_info,logger_error,role_map_dict,role_screen_df):
    try:
        filtered_df = pd.DataFrame()
        # Convert to uppercase and strip whitespace to ensure consistency
        df['USERTYPE'] = df['USERTYPE'].str.upper().str.strip()
        role_screen_df['roleName'] = role_screen_df['roleName'].str.upper().str.strip()
        df = df.merge(role_screen_df[['roleName', 'roleToScreenList', 'roleToTabList']], 
              left_on='USERTYPE', 
              right_on='roleName', 
              how='left').drop('roleName', axis=1)
  


        filtered_df['roleName'] = df['USERTYPE'].map(role_map_dict)
        # print(filtered_df['roleName'])
        # print("user_type,",filtered_df['roleName'])
        # Replace empty strings with NaN
        df['CRM_BU_ID'] = df['CRM_BU_ID'].replace('', pd.NA)
        filtered_df['accountid'] = df['CRM_BU_ID'].fillna(df['CRM_CUSTOMER_ID']).astype(int)
        print(filtered_df['accountid'])
        filtered_df['roleDescription']=filtered_df['roleName']
        filtered_df['roleName'] = filtered_df['roleName'].astype(str)
        

        # Map 'roleToScreenList' values from df2 to filtered_df
        filtered_df['roleToScreenList'] = df['roleToScreenList']

        filtered_df['roleToTabList'] = df['roleToTabList']
        filtered_df['groupId'] = 0 
        logger_info.info("Role_transformation succesfully ")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None


def apn_transformations(df,logger_info,logger_error):
    try:
        filtered_df = pd.DataFrame()
        filtered_df['apnName'] = df['APN']
        filtered_df['apnDescription'] = df['APN']
        filtered_df['apnId'] = df['APN_ID'] ## use lagacy_id to understand this logic
        
        filtered_df['apnType'] = df.apply(
            lambda row: 'true' if row['IP_ASSIGNMENT'] == 'static' and (row['TYPE'] == 'IPv4' or row['TYPE'] == 'IPv4 and IPv6') 
            else ('false' if row['IP_ASSIGNMENT'] == 'dynamic' else None),
            axis=1
        )

        filtered_df['apnTypeIpv6'] = df.apply(
            lambda row: 'true' if row['IP_ASSIGNMENT'] == 'static' and (row['TYPE'] == 'IPv6' or row['TYPE'] == 'IPv6 and IPv4') 
            else ('false' if row['IP_ASSIGNMENT'] == 'dynamic' else None),
            axis=1
        )
        
        filtered_df['privateShared'] = 'true'
        filtered_df['apnCategory'] = 1
        filtered_df['addressType'] = df['TYPE'].apply(lambda x: 1 if x == 'IPv4' else (0 if x == 'IPv6' else (2 if x == 'IPv4 and IPv6' else None)))
        filtered_df['ipPoolAllocationType']=df['IP_ASSIGNMENT']
        filtered_df['radiusAuthenticationEnable']='false'
        filtered_df['radiusAuthType']=''
        filtered_df['radiusAuthType']=''
        filtered_df['radiusUsername']='imsi@apn'
        filtered_df['radiusPassword']=''
        filtered_df['radiusForwardingEnable']='false'


        filtered_df['eqosid'] = ''
        filtered_df['apnIp'] = ''
        filtered_df['mcc'] = ''
        filtered_df['mnc'] = ''
        filtered_df['hlrApnId'] = ''
        filtered_df['hssContextId'] = ''
        filtered_df['profile2g3g'] = ''
        filtered_df['uplink2g3g'] = ''
        filtered_df['uplinkunit2g3g'] = ''
        filtered_df['downlink2g3g'] = ''
        filtered_df['downlinkunit2g3g'] = ''
        filtered_df['profilelte'] = ''
        filtered_df['uplinklte'] = ''
        filtered_df['uplinkunitlte'] = ''
        filtered_df['downllinklte'] = ''
        filtered_df['downllinunitklte'] = ''
        filtered_df['hssProfileId'] = ''
        

        filtered_df[['subnet', 'subnetIpv6']] = df.apply(lambda row: process_ip_assignment(row), axis=1)

        filtered_df['ipPoolType'] = ''
        filtered_df['requestSubType'] = ''
        filtered_df['requestFrom'] = 'GUI'
        filtered_df['info'] = ''
        filtered_df['apnServiceType'] = ''
        filtered_df['apnWlBlcategory'] = ''
        filtered_df['splitBilling'] = ''
        filtered_df['roamingEnabled'] = 'false'
 


        logger_info.info("APN transformations applied successfully.")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None



def notification_transformations(df,logger_info,logger_error):
    try:
        filtered_df = pd.DataFrame()
        filtered_df['templateName'] = df['NAME']
        
        # Corrected nested conditional assignment for notificationType
        filtered_df['notificationType'] = df['TYPE'].apply(
            lambda x: 'SMS' if x == 'Bulk SMS template' else ('EMAIL' if x == 'Mail Template' else x)
        )
        
        filtered_df['accountId'] =  np.where(df['BU_ID'].isna(), df['CUSTOMER_ID'], df['BU_ID'])
        filtered_df['language'] = df['PREFERRED_LANGUAGE']
       
        filtered_df['subject']=np.where(df['TYPE'] == 'Mail Template', df['subject'], np.where(df['TYPE'] == 'Bulk SMS Template', None, df['subject']))
        filtered_df['message']=df['TEXT']
        filtered_df['description']=df['TEMPLATE_DESCRIPTION']
        filtered_df['category']=df['SMS_TYPE']

        logger_info.info("notification_transformations applied successfully.")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None






def lable_creation_transformations(df,logger_info,logger_error):
    try:
        filtered_df = pd.DataFrame()
        filtered_df['name'] = df['NAME']

        filtered_df['description']=df['TEXT']
        filtered_df['accountId']= np.select([df['LEVEL_TYPE'] == 17120, df['LEVEL_TYPE'] == 17119, df['LEVEL_TYPE'] == 17121],[df['CUSTOMER_ID'], df['BU_ID'], df['OPCOID']],default=None)

        logger_info.info("lable_creation_transformations applied successfully.")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None










def assets_transformations(df,logger_info,logger_error):
    try:
        ##this point to understand
        
        conditions = (df['ICCID'] == df['ICCID']) & \
                    (df['IMEI'] == df['IMEI']) & \
                    (df['IMSI'] == df['IMSI']) & \
                    (df['DEVICE_IP_ADDRESS'] == df['IP_ADDRESS']) & \
                    (df['KL'] == df['KL']) & \
                    (df['STATE_MODIFIED_DATE'] == df['LASTMODIFDATE'])& \
                    (df['MSISDN'] == df['MSISDN']) & \
                    (df['OPC'] == df['OPC']) & \
                    (df['PIN1'] == df['PIN1'])& \
                    (df['PIN2'] == df['PIN2'])& \
                    (df['PUK1'] == df['PUK1']) & \
                    (df['PUK2'] == df['PUK2']) & \
                    (df['DEVICE_PLAN_ID'] == df['SERVICE_PROFILE_ID'])
        

        # Apply the conditions to filter df
        filtered_df = df[conditions]

        filtered_df['locked'] = 'false'
        filtered_df['secondaryPhone'] = ''
        filtered_df['groupId'] = ''
        filtered_df['userType'] = '1'
        filtered_df['userAccountType'] = 'NormalUser'
        filtered_df['supervisorId'] = ''
        filtered_df['resetPasswordAction'] = 'true'
        filtered_df['reason'] = ''
        filtered_df['timeZoneId']=vienna_time
        filtered_df['emailConf']==filtered_df['email']
        logger_info.info(f"assets_transformations successfully ")
        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None
