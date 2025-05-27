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
    '''
    Function to merge two DataFrames and create a new column 'company_address' based on the provided key.
    The 'company_address' column is formatted as a string with the following format:
    "COUNTRY:<COUNTRY>;STREET:<STREET>;BUILDING:<BUILDING>;POSTAL_CODE:<POSTAL_CODE>;CITY:<CITY>;STATE:<STATE>;COUNTRY:<COUNTRY>"
    where the values are extracted from the columns in df2.
    '''
    
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
            lambda row: f"COUNTRY:{row['COUNTRY']};STREET:{row['STREET']};BUILDING:{row['BUILDING']};POSTAL_CODE:{row['POSTAL_CODE']};CITY:{row['CITY']};STATE:{row['STATE']};COUNTRY:{row['COUNTRY']}"
            if pd.notnull(row['PARTY_ROLE_ID']) else None, axis=1)
        
        return merged_df

    except KeyError as e:
        logger_error.error(f"Key error: {e}")
        return None
    except Exception as e:
        logger_error.error(f"An error occurred during merging or address formatting: {e}")
        return None

        # Function to generate a random number with the specified number of digits
def random_number(num_digits):
    return random.randint(10**(num_digits - 1), 10**num_digits - 1)


def Enterprise_Customer_transformation(df, country_id_mapping, _dict,logger_info,logger_error,company_address_tables_df):
    try:
        df = merge_and_create_address(company_address_tables_df,df,'CRM_ID',logger_error)
        print("company_address",df['company_address'])
        filtered_df = pd.DataFrame()

        df.to_csv("validation.csv", index=False)
        
        ##### default values
        filtered_df['legacyBan'] = df['CRM_ID']
        filtered_df['frequency'] = 'Monthly'
        
        print("filtered_df", filtered_df['frequency'])
        
        # Mapping values
        filtered_df['billingFlag'] = df['INVOICING_LEVEL_TYPE'].map({'Customer': 'true', 'Business Unit': 'false'})
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
        # filtered_df['billingCountry']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'COUNTRY', logger_error))
        filtered_df['billingCountry']=filtered_df['countryId']
        filtered_df['billingEmail'] = '-'
        filtered_df['billingTelephone'] = '-'
        filtered_df['billingMobile'] = '-'

        filtered_df['primaryContactFirstName'] = '-'
        filtered_df['primaryContactLastName'] = '-'
        filtered_df['primaryContactTelephone'] = '-'
        filtered_df['primaryContactMobile'] = '-'
        filtered_df['primaryContactEmail'] = '-'
        
        
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
        # Apply the function to each row in the DataFrame
        filtered_df['sourceNumber'] = [random_number(8) for _ in range(len(filtered_df))]
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
        filtered_df['isBss'] = 0
        filtered_df['regionId'] = ''
        filtered_df['areaCode'] = ''
        filtered_df['primaryContactAddress'] = '-'
        filtered_df['primaryContactAddressLine2']=''
        filtered_df['zipCode']=filtered_df['billingZipCode']
        filtered_df['primaryContactCity']=''
        filtered_df['primaryContactState']=''
        filtered_df['primaryContactCountry']=filtered_df['countryId']   #''

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
        # filtered_df['extraMetadata'] =df.apply(lambda row: {
        # "cdrConfigurationEnabled": False if pd.isnull(row["ACTIVATE_PUSH_CDR"]) or row["ACTIVATE_PUSH_CDR"] == "" else row["ACTIVATE_PUSH_CDR"],
        # "simCommitmentAllow": "false",
        # "billingItemId": "",
        # "retryLimit": "2",
        # "cdrConfiguration": ([
        # {
        #     "api_url": row["PUSH_CDR_URL_1"],
        #     "secret_Key": "",
        #     "path": "",
        #     "webhookusername": row["PUSH_CDR_PSWD_1"], []
        #     "webhookauthentication_type": "Basic",
        #     "webhookPassword": row["PUSH_CDR_LOGIN_1"],
        #     "webhookheader_type": "",
        #     "dataFormat": "basic",
        #     "showValue": False
        # }]) if not pd.isnull(row["ACTIVATE_PUSH_CDR"]) and row["ACTIVATE_PUSH_CDR"] != "" else False},axis=1)
        filtered_df['extraMetadata'] = df.apply(
            lambda row: json.dumps({
                "cdrConfigurationEnabled": "false" if pd.isnull(row["ACTIVATE_PUSH_CDR"]) or row["ACTIVATE_PUSH_CDR"] == "" else row["ACTIVATE_PUSH_CDR"],
                "simCommitmentAllow": "false",
                "billingItemId": "",
                "retryLimit": "2",
                "cdrConfiguration": ([
                    {
                        "api_url": row["PUSH_CDR_URL_1"],
                        "secret_Key": "",
                        "path": "",
                        "webhookusername": row["PUSH_CDR_PSWD_1"],
                        "webhookauthentication_type": "Basic",
                        "webhookPassword": row["PUSH_CDR_LOGIN_1"],
                        "webhookheader_type": "",
                        "dataFormat": "basic",
                        "showValue": 'false'
                    }
                ]) if not pd.isnull(row["ACTIVATE_PUSH_CDR"]) and row["ACTIVATE_PUSH_CDR"] != "" else []
            }),
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


def validate_and_separate_phone_number(phone_number):
    """
    Validates a phone number and separates the country code from the phone number
    using the comprehensive AT&T country codes list.
    
    Args:
        phone_number (str): The full phone number string in format like +918320925571
        
    Returns:
        tuple: (country_code, phone_number) if valid, else (None, None)
    """

    # Remove any spaces
    phone_number = phone_number.strip()
    
    # Check if the phone number starts with a '+'
    if not phone_number.startswith('+'):
        return None, None
    
    # Remove the '+' sign
    phone_number = phone_number[1:]
    
    # Complete list of country codes from the AT&T document
    # Format: country_code: [list of countries] - we only need the codes themselves
    country_codes = {
        "1": ["US", "Canada", "Puerto Rico", "US Virgin Islands", "Bahamas", "Barbados", "Bermuda", "Dominican Republic", "Jamaica"],
        "7": ["Russia", "Kazakhstan"],
        "20": ["Egypt"],
        "27": ["South Africa"],
        "30": ["Greece"],
        "31": ["Netherlands"],
        "32": ["Belgium"],
        "33": ["France"],
        "34": ["Spain"],
        "36": ["Hungary"],
        "39": ["Italy", "Holy See (Vatican City)"],
        "40": ["Romania"],
        "41": ["Switzerland"],
        "43": ["Austria"],
        "44": ["United Kingdom", "Isle of Man", "Jersey"],
        "45": ["Denmark"],
        "46": ["Sweden"],
        "47": ["Norway", "Svalbard"],
        "48": ["Poland"],
        "49": ["Germany"],
        "51": ["Peru"],
        "52": ["Mexico"],
        "53": ["Cuba"],
        "54": ["Argentina"],
        "55": ["Brazil"],
        "56": ["Chile"],
        "57": ["Colombia"],
        "58": ["Venezuela"],
        "60": ["Malaysia"],
        "61": ["Australia", "Christmas Island", "Cocos (Keeling) Islands"],
        "62": ["Indonesia"],
        "63": ["Philippines"],
        "64": ["New Zealand"],
        "65": ["Singapore"],
        "66": ["Thailand"],
        "81": ["Japan"],
        "82": ["South Korea"],
        "84": ["Vietnam"],
        "86": ["China"],
        "90": ["Turkey"],
        "91": ["India"],
        "92": ["Pakistan"],
        "93": ["Afghanistan"],
        "94": ["Sri Lanka"],
        "95": ["Burma (Myanmar)"],
        "98": ["Iran"],
        "211": ["South Sudan"],
        "212": ["Morocco", "Western Sahara"],
        "213": ["Algeria"],
        "216": ["Tunisia"],
        "218": ["Libya"],
        "220": ["Gambia"],
        "221": ["Senegal"],
        "222": ["Mauritania"],
        "223": ["Mali"],
        "224": ["Guinea"],
        "225": ["Ivory Coast (Côte d'Ivoire)"],
        "226": ["Burkina Faso"],
        "227": ["Niger"],
        "228": ["Togo"],
        "229": ["Benin"],
        "230": ["Mauritius"],
        "231": ["Liberia"],
        "232": ["Sierra Leone"],
        "233": ["Ghana"],
        "234": ["Nigeria"],
        "235": ["Chad"],
        "236": ["Central African Republic"],
        "237": ["Cameroon"],
        "238": ["Cape Verde"],
        "239": ["Sao Tome and Principe"],
        "240": ["Equatorial Guinea"],
        "241": ["Gabon"],
        "242": ["Congo", "Republic of the Congo"],
        "243": ["Democratic Republic of the Congo"],
        "244": ["Angola"],
        "245": ["Guinea-Bissau"],
        "246": ["Diego Garcia"],
        "247": ["Ascension Island"],
        "248": ["Seychelles"],
        "249": ["Sudan"],
        "250": ["Rwanda"],
        "251": ["Ethiopia"],
        "252": ["Somalia"],
        "253": ["Djibouti"],
        "254": ["Kenya"],
        "255": ["Tanzania"],
        "256": ["Uganda"],
        "257": ["Burundi"],
        "258": ["Mozambique"],
        "260": ["Zambia"],
        "261": ["Madagascar"],
        "262": ["Reunion Island", "Mayotte"],
        "263": ["Zimbabwe"],
        "264": ["Namibia"],
        "265": ["Malawi"],
        "266": ["Lesotho"],
        "267": ["Botswana"],
        "268": ["Swaziland"],
        "269": ["Comoros"],
        "290": ["Saint Helena"],
        "291": ["Eritrea"],
        "297": ["Aruba"],
        "298": ["Faroe Islands"],
        "299": ["Greenland"],
        "350": ["Gibraltar"],
        "351": ["Portugal"],
        "352": ["Luxembourg"],
        "353": ["Ireland"],
        "354": ["Iceland"],
        "355": ["Albania"],
        "356": ["Malta"],
        "357": ["Cyprus"],
        "358": ["Finland"],
        "359": ["Bulgaria"],
        "370": ["Lithuania"],
        "371": ["Latvia"],
        "372": ["Estonia"],
        "373": ["Moldova"],
        "374": ["Armenia"],
        "375": ["Belarus"],
        "376": ["Andorra"],
        "377": ["Monaco"],
        "378": ["San Marino"],
        "380": ["Ukraine"],
        "381": ["Serbia"],
        "382": ["Montenegro"],
        "385": ["Croatia"],
        "386": ["Slovenia"],
        "387": ["Bosnia and Herzegovina"],
        "389": ["Macedonia"],
        "420": ["Czech Republic"],
        "421": ["Slovakia"],
        "423": ["Liechtenstein"],
        "500": ["Falkland Islands"],
        "501": ["Belize"],
        "502": ["Guatemala"],
        "503": ["El Salvador"],
        "504": ["Honduras"],
        "505": ["Nicaragua"],
        "506": ["Costa Rica"],
        "507": ["Panama"],
        "508": ["Saint Pierre and Miquelon"],
        "509": ["Haiti"],
        "590": ["Guadeloupe", "Saint Barthelemy", "Saint Martin"],
        "591": ["Bolivia"],
        "592": ["Guyana"],
        "593": ["Ecuador"],
        "594": ["French Guiana"],
        "595": ["Paraguay"],
        "596": ["Martinique"],
        "597": ["Suriname"],
        "598": ["Uruguay"],
        "599": ["Netherlands Antilles"],
        "670": ["Timor-Leste (East Timor)"],
        "672": ["Antarctica", "Norfolk Island"],
        "673": ["Brunei"],
        "674": ["Nauru"],
        "675": ["Papua New Guinea"],
        "676": ["Tonga Islands"],
        "677": ["Solomon Islands"],
        "678": ["Vanuatu"],
        "679": ["Fiji"],
        "680": ["Palau"],
        "681": ["Wallis and Futuna"],
        "682": ["Cook Islands"],
        "683": ["Niue"],
        "685": ["Samoa"],
        "686": ["Kiribati"],
        "687": ["New Caledonia"],
        "688": ["Tuvalu"],
        "689": ["French Polynesia"],
        "690": ["Tokelau"],
        "691": ["Micronesia"],
        "692": ["Marshall Islands"],
        "850": ["North Korea"],
        "852": ["Hong Kong"],
        "853": ["Macau"],
        "855": ["Cambodia"],
        "856": ["Laos"],
        "870": ["Pitcairn Islands"],
        "880": ["Bangladesh"],
        "886": ["Taiwan"],
        "960": ["Maldives"],
        "961": ["Lebanon"],
        "962": ["Jordan"],
        "963": ["Syria"],
        "964": ["Iraq"],
        "965": ["Kuwait"],
        "966": ["Saudi Arabia"],
        "967": ["Yemen"],
        "968": ["Oman"],
        "970": ["Palestine"],
        "971": ["United Arab Emirates"],
        "972": ["Israel"],
        "973": ["Bahrain"],
        "974": ["Qatar"],
        "975": ["Bhutan"],
        "976": ["Mongolia"],
        "977": ["Nepal"],
        "992": ["Tajikistan"],
        "993": ["Turkmenistan"],
        "994": ["Azerbaijan"],
        "995": ["Georgia"],
        "996": ["Kyrgyzstan"],
        "998": ["Uzbekistan"],
    }
    
    # Handle special cases for multi-code countries (like Dominican Republic)
    multi_codes = {
        "1246": "Barbados",
        "1264": "Anguilla",
        "1268": "Antigua and Barbuda",
        "1284": "British Virgin Islands",
        "1340": "US Virgin Islands",
        "1345": "Cayman Islands",
        "1441": "Bermuda",
        "1473": "Grenada",
        "1649": "Turks and Caicos Islands",
        "1664": "Montserrat",
        "1671": "Guam",
        "1684": "American Samoa",
        "1721": "Sint Maarten",
        "1758": "Saint Lucia",
        "1767": "Dominica",
        "1784": "Saint Vincent and the Grenadines",
        "1787": "Puerto Rico",
        "1809": "Dominican Republic",
        "1829": "Dominican Republic",
        "1849": "Dominican Republic",
        "1868": "Trinidad and Tobago",
        "1869": "Saint Kitts and Nevis",
        "1876": "Jamaica",
        "1939": "Puerto Rico"
    }
    
    # Special case check for countries with multi-digit dialing codes starting with 1
    if phone_number.startswith('1') and len(phone_number) >= 4:
        prefix = phone_number[:4]  # Check the first 4 digits (1 + 3-digit area code)
        if prefix in multi_codes:
            return prefix[:1], phone_number[1:]  # Return "1" as country code
    
    # Try matching country codes in decreasing order of length
    # This ensures we match the longest country code first (e.g., "998" before "9")
    sorted_codes = sorted(country_codes.keys(), key=len, reverse=True)
    
    for code in sorted_codes:
        if phone_number.startswith(code):
            return code, phone_number[len(code):]
    
    # If no country code matches, return None
    return None, None


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
        
        filtered_df['countryCode'], filtered_df['primaryPhone'] = zip(*df['PHONE_NUMBER'].apply(validate_and_separate_phone_number))
        
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
        # filtered_df['billingCountry']=df['company_address'].apply(lambda x: extract_data_from_address(x, 'COUNTRY', logger_error))
        filtered_df['billingCountry']=filtered_df['countryId']
        filtered_df['billingEmail'] = '-'
        filtered_df['billingTelephone'] = '-'
        filtered_df['billingMobile'] = ''

        filtered_df['primaryContactFirstName'] = '-'
        filtered_df['primaryContactLastName'] = '-'
        filtered_df['primaryContactTelephone'] = '-'
        filtered_df['primaryContactMobile'] = '-'
        filtered_df['primaryContactEmail'] = '-'
        
        
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
        filtered_df['sourceNumber'] = df['SMS_FORWARDING_EXTERNAL_NUMBER']
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
        filtered_df['isBss'] = 0
        filtered_df['regionId'] = ''
        filtered_df['areaCode'] = ''
        filtered_df['primaryContactAddress'] = '-'
        filtered_df['primaryContactAddressLine2']=''
        filtered_df['zipCode']=filtered_df['billingZipCode']
        filtered_df['primaryContactCity']=''
        filtered_df['primaryContactState']=''
        filtered_df['primaryContactCountry']=filtered_df['countryId'] # ''

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
        filtered_df['featureSubTypeSmsForwarding'] ='1'

        filtered_df['deliveryConfirmation'] = df['API_SMS_DELIVERY_CONFIRMATION'].apply(lambda x: "true" if str(x).lower() == "yes" else "false")
        filtered_df['extraMetadata'] = filtered_df.apply(
            lambda row: json.dumps({
                "cdrConfigurationEnabled": False,
                "simCommitmentAllow": False,
                "billingItemId": "",
                "includedInBilling": False,
                "deliveryConfirmation": row['deliveryConfirmation']
            }),
            axis=1
        )
        # drop deliveryConfirmation column
        filtered_df.drop(columns=['deliveryConfirmation'], inplace=True)
        
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
            "isSSLAction": false}}""",
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
        df1['BU_STATUS'] = df1['BU_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)

        df2 = read_table_as_df('ec_success', validation_db_configs, logger_error, logger_info)
        df2['TYPE'] = df2['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
        df2['EC_STATUS'] = df2['EC_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)
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


def cost_center_transformation(df1,logger_info,logger_error ):
    """
    Performs the equivalent of the SQL query using pandas operations:
    SELECT b1.legacyBan AS buAccountId, a1.CC_NAME AS name, a1.COMMENTS AS comments
    FROM df1 AS a1
    LEFT JOIN df2 AS b1
    ON b1.legacyBan = a1.CCCRM_ID
    WHERE b1.legacyBan IS NOT NULL AND b1.legacyBan <> '';

    Parameters:
        df1 (pd.DataFrame): DataFrame representing validation.cost_centers_success
        df2 (pd.DataFrame): DataFrame representing transformation.bu_success

    Returns:
        pd.DataFrame: The resulting merged DataFrame.
    """
    try:

        df2 = read_table_as_df('bu_success', transformation_db_configs, logger_error, logger_info)
        df2['TYPE'] = df1['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
        df2['BU_STATUS'] = df1['BU_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)
        # Perform a left join
        merged_df = df1.merge(df2, left_on='CCCRM_ID', right_on='legacyBan', how='left')

        # Filter rows where legacyBan is not null and not empty
        filtered_df = merged_df.query("legacyBan.notnull() and legacyBan != ''")

        # Select and rename the desired columns
        result_df = filtered_df[['legacyBan', 'CC_NAME', 'COMMENTS']].rename(
            columns={
                'legacyBan': 'buAccountId',
                'CC_NAME': 'name',
                'COMMENTS': 'comments'
            }
        )
        return result_df

    except KeyError as e:
        print(f"KeyError: Missing expected column - {e}")
        logger_error.error(f"KeyError: Missing expected column - {e}")
        return None
    except pd.errors.MergeError as e:
        print(f"MergeError: Issue with merging DataFrames - {e}")
        logger_error.error(f"MergeError: Issue with merging DataFrames - {e}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        logger_error.error(f"An unexpected error occurred: {e}")
        return None


def report_subscriptions_creation_transformations(df,logger_info,logger_error):
    try:
        filtered_df = pd.DataFrame()
        filtered_df['accountId'] =  df['CRMBU_ID'].fillna(df['CRMEC_ID']).fillna(df['CRMOPCO_ID']).astype(int)
        filtered_df['isEmailEnable'] = np.where(df['MAIL_NOTIFICATION'] == 0, 'false', 'true')
        filtered_df['emailId']=df['RECEPIENTS']
        filtered_df['reportType'] = df['FILE_TYPE'].str.upper()
        filtered_df['type'] = np.where(df['REPORT_TYPE'] == 17590, 'SUBSCRIPTION', df['REPORT_TYPE'])
        filtered_df['reportStartDate']=''
        filtered_df['reportEndDate']=''
        filtered_df['roleId']=''
        mapping = {'Business Unit': 'BU', 'Customer': 'CUSTOMER'}
        filtered_df['level'] = df['AGGREGATION_LEVEL'].map(mapping).fillna('MNO')
        filtered_df['subscriptionType']='SINGLE_REPORT'
        filtered_df['subscriptionName']=df['NAME']
        filtered_df['fromValue']=''
        filtered_df['toValue']=''
        
        report_mapping = {
            "SIM Report": [{"reportCategoryId": 126, "frequency": "MONTH"}],
            "CDR Export": [{"reportCategoryId": 114, "frequency": "MONTH"}],
            "Usage per IMSI": [{"reportCategoryId": 129,"frequency":"MONTH"}]
        }

        # Map values based on REPORT_DEF_NAME column
        filtered_df['reportSubscriptionDetails'] = df['REPORT_DEF_NAME'].map(report_mapping).apply(json.dumps)
        filtered_df['from_plan']=''
        filtered_df['to_plan']=''

        logger_info.info("report_subscriptions_creation_transformations applied successfully.")



        return filtered_df
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None


def calculate_ip_range(row):
    try:
        start_ip = ipaddress.ip_address(row['RANGE_START'])
        end_ip = ipaddress.ip_address(row['RANGE_END'])
        
        # Calculate the number of IPs in the range (inclusive)
        requested_ips = int(end_ip) - int(start_ip) + 1
        
        return requested_ips
    except Exception as e:
        print(f"Error calculating IP range for row: {row}")
        print(f"Error details: {e}")
        return None


def ip_pool_transformation(df, logger_info, logger_error):
    try:
        filtered_df = pd.DataFrame()
        filtered_df['accountId'] = df['BU_ID']
        filtered_df['ipPoolName'] = df['NAME']
        filtered_df['rangeStart'] = df['RANGE_START']
        filtered_df['rangeEnd'] = df['RANGE_END']
        filtered_df['apnId'] = df['ID']
        filtered_df['requestedIps'] = df.apply(calculate_ip_range, axis=1)

        return filtered_df
    
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")
        return None