import sys
sys.path.append("..")

# from library import *

import requests
import urllib3
import re
import os
from conf.config import account_id_token,x_user_id
import string
import base64
import random
# from library import *
import datetime
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class api_call:
    def __init__(self):
        pass

    def call_api(self, url, payload, token, account_id):
        """
        url: api url
        payload: payload for api calling
        return: It will return status_code and content
        """
        print('API Url :', url)
        print(payload)
        token = f'Bearer {token}'
        print('token : ',token)

        headers = {
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Authorization': token,
            'Language' : 'en',
            # 'Origin':'https://192.168.1.26:7886',
            # 'X-Requested-With':'XMLHttpRequest',
            'Content-Type': 'application/x-www-form-urlencoded',
            'accountId': account_id_token,
            'x-user-id': x_user_id,
            'x-user-opco': account_id_token
        }

        status_code = None
        content = None
        try:
            # Pretty print the curl command
            curl_command = f"curl -X POST '{url}' -H 'Authorization: {token}' -H 'Content-Type: application/x-www-form-urlencoded' -d '{payload}'"
            print("Curl Command:\n", curl_command)
            response = requests.request("POST", url, headers=headers, data=payload, verify=False)
            print('response',response.content)
            status_code = response.status_code
            content = response.content
        except Exception as e:
            print("API Calling Error : ", e)

        return status_code, content



def check_length(value, max_length):
    """
    :param value: value you want to check
    :param max_length: max length of value
    :return: if value == max_length then return TRUE else FALSE
    """
    return len(value) <= max_length

    

def encode_to_base64(message_string):
    message_bytes = message_string.encode('utf-8')

    # Encode the bytes to Base64
    base64_bytes = base64.b64encode(message_bytes)

    # Convert the Base64 bytes back to a string
    base64_message = base64_bytes.decode('utf-8')
    return base64_message

def remove_special_characters(df, column_name):
    """
    df: dataframe
    column_name: column names from which special characters need to remove.
    return: valid dataframe
    """
    # Use a regular expression to match and replace special characters and spaces
    df[column_name] = df[column_name].apply(lambda x: re.sub(r'[^\w]', '', str(x)))
    return df

def delete_before(path,dir_path):
    """
    path : path of csv file
    return: remove file from the path any file is already exist with .csv extension
    """
    directory_path = os.path.join(dir_path, path)
    file_list = os.listdir(directory_path)

    # Iterate through the files
    for file_name in file_list:
        if file_name.endswith(".csv"):
            try:
                file_path = os.path.join(directory_path, file_name)
                os.remove(file_path)
            except Exception as e:
                print("Error : {} deleting previous csv file", e)
                exit(0)


def validate_email(email):
    """
    email : email id to validate
    return: true if email id is valid else return false
    """
    # Define a regular expression pattern for a basic email validation
    email_pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')

    # Count the number of '@' symbols in the email address
    at_count = email.count('@')
    # Check if the email matches the pattern and has at most 2 '@' symbols
    if email_pattern.match(email) and at_count < 2:
        return True
    else:
        return False


def is_alphanumeric(input_string):
    """
    input_string: input string to validate
    return: true is string is alphanumeric else return false
    """
    stripped_string = input_string
    special_characters = "=!\@#$%^&*()_+[]{}|;:',.<>?-/`~ "
    for char in special_characters:
        input_string = input_string.replace(char, '')
    alphanumeric_chars = [char for char in stripped_string if char.isalnum()]
    stripp_string = ''.join(alphanumeric_chars)
    return stripp_string == input_string


def is_valid_phone_number(phone_number):
    """
    Validates phone numbers for the Airlinq Platform 2FA system.
    
    Requirements:
    - Must not be empty
    - Must start with + sign followed by country code
    - Must only contain digits after the + sign
    - Must be of reasonable length (typically 7-15 digits after country code)
    
    Args:
        phone_number: The phone number to validate
        
    Returns:
        bool: True if the phone number is valid, False otherwise
    """
    # Check if the phone number is not None or empty
    if not phone_number:
        return False
    
    # Check if the phone number starts with '+' and contains only digits after that
    pattern = r'^\+[0-9]{7,15}$'
    if not re.match(pattern, phone_number):
        return False
    
    return True
        

def check_enum(value, allowed_values):
    """
    value: value coming in row.
    allowed_values: allowed enum values.
    return true is string is valid enum else return false.
    """
    # Remove spaces and special characters from value and allowed_values
    value = ''.join(e for e in value if e.isalnum())
    allowed_values = [''.join(e for e in val if e.isalnum()) for val in allowed_values]

    # Convert both value and allowed_values to uppercase
    value = value.upper()
    allowed_values = [val.upper() for val in allowed_values]

    if value in allowed_values:
        return True
    else:
        return False


def drop_duplicates_and_save_duplicates(df, csv_filename,logger_info,unique_column):
    """
    df: dataframe from which duplicates need to be removed.
    csv_filename: csv file name.
    logger_info: logger_info
    unique_column: unique columns on which duplicates need to be checked.
    return: valid dataframe
    """

    # Identify duplicate rows
    duplicates = df[df.duplicated(subset=unique_column,keep='first')]

    print('Length of Duplicate records : ', len(duplicates))
    logger_info.info('Length of Duplicate records : {}'.format(len(duplicates)))
    # Drop duplicates from the original DataFrame
    df.drop_duplicates(subset=unique_column,keep='first', inplace=True, ignore_index=True)
    # print(df_no_duplicates)
    # Save duplicate rows to a CSV file
    if not duplicates.empty:
        duplicates.to_csv(csv_filename, index=False)

    return df



def random_number(length_of_digits):
    '''
    param: length_of_digits
    return: return the combination of timestamp and random number as requestId
    '''
    N = int(length_of_digits)
    randm = ''.join(random.choices(string.digits, k=N))
    request_id = randm
    return request_id




# Define a function to check if the string contains only letters and digits
def drop_special_character_data(buname):
    pattern = r'^[\w\s\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF\u4E00-\u9FFF]+$'
    return bool(pd.Series(buname).str.match(pattern).all())


# Function to trim the alternateName column
def trim_data(trimmed_name):
    if len(trimmed_name) > 50:
        # Remove white spaces
        return trimmed_name[:50]
       
    return trimmed_name



def convert_timestamp(ts):
    if ts.strip():  # Check if the timestamp is not empty
        # Truncate the microseconds part to six digits
        date_part, time_part, period = ts.split()
        time_part, microseconds = time_part.rsplit('.', 1)
        microseconds = microseconds[:6]  # Truncate to six digits
        ts_corrected = f"{date_part} {time_part}.{microseconds} {period}"

        input_format = "%d-%b-%y %I.%M.%S.%f %p"
        parsed_timestamp = datetime.strptime(ts_corrected, input_format)
        output_format = "%Y-%m-%d %H:%M:%S"
        return parsed_timestamp.strftime(output_format)
    else:
        return ''


def validate_date(date):
    pattern1 = r'^\d{2}-[A-Z]{3}-\d{2}$'
    pattern2 = r'^\d{2}-[A-Z]{3}-\d{2} \d{2}\.\d{2}\.\d{2}\.\d{9} (AM|PM)$'
    pattern3 = r'^\d{2}-\d{2}-\d{2}$'
    
    return bool(re.match(pattern1, date) or re.match(pattern2, date) or re.match(pattern3, date))


import ipaddress

def is_ip_address(value):
    try:
        if value is None or value == '' or value == 'None':
            return False
        ipaddress.ip_address(value)
        return True
    except ValueError:
        return False