"""
Created on 02 Feb 2024
@author: amit.k@airlinq.com

Script to convert incoming csv file into the desired format of csv file

1) M2M_Customer_to_AQ :- If any mandatory column value is empty in case of eCMP M2M Company File then this function Drop those particular records(rows)
    -> Second Check will be to check if any column dataType mismatch then drop those records , datatype check is implemented on isNumeric,isAlphaNumeric, checkEnum and checkDateTime
"""

import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.library import *
from conf.custom.metis.config import *


dir_path = dirname(abspath(__file__))



def remove_special_characters(df, column_name):
    """
    df: dataframe
    column_name: column names from which special characters need to remove.
    return: valid dataframe
    """
    # Use a regular expression to match and replace special characters and spaces
    df[column_name] = df[column_name].apply(lambda x: re.sub(r'[^\w]', '', str(x)))
    return df

def filter_and_drop_mismatched_brn(pic_user, filtered_brn_list, output_file_path, error_message,logger_info,logger_error,filename):
    """
    pic_user: Altrix pic users dataframe
    filtered_brn_list: Filtered list of brn from M2M Company file.
    output_file_path: output file path to put mismatch brn.
    error_message: error message for the brn which is not present in pic user.
    logger_info: logger info
    logger_error: logger error
    filename: pic original file name.
    return: validate pic user data
    """
    # Filter out mismatched BRNs
    try:
        mismatched_brn_indices = pic_user[~pic_user['brn'].isin(filtered_brn_list)].index
        # Add a column with the specified value
        pic_user["Error_Message"] = ""
        pic_user.loc[mismatched_brn_indices, "Error_Message"] = error_message
        mismatched_brn_df = pic_user.loc[mismatched_brn_indices].copy()
        print('Length of BRN Not Present In Company : ', len(mismatched_brn_df))
        logger_info.info('Length of BRN Not Present In Company : {}'.format(len(mismatched_brn_df)))
        # Save the resulting DataFrame to a file
        mismatched_brn_df.to_csv(os.path.join(output_file_path,filename), index=False)
        mismatched_brn_df.to_csv(os.path.join(error_directory, filename), index=False)

        # Drop mismatched BRN records from the original DataFrame
        pic_user.drop(index=mismatched_brn_indices, inplace=True)
        pic_user = pic_user.reset_index(drop=True)
        pic_user.drop(columns=['Error_Message'], inplace=True)
        
        return pic_user
    except Exception as e:
        logger_error.error("Error : {} while doing cross file validation.".format(e))
        logger_info.error("Error : {} while doing cross file validation.".format(e))


def delete_before(path):
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

# check if alphanumeric or not
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


# function to check enum
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
    duplicates = df[df.duplicated(subset=unique_column,keep=False)]

    print('Length of Duplicate records : ', len(duplicates))
    logger_info.info('Length of Duplicate records : {}'.format(len(duplicates)))
    # Drop duplicates from the original DataFrame
    df.drop_duplicates(subset=unique_column,keep='first', inplace=True, ignore_index=True)
    # print(df_no_duplicates)
    # Save duplicate rows to a CSV file
    if not duplicates.empty:
        duplicates.to_csv(csv_filename, index=False)


    return df



def M2M_Customer_to_AQ(df_maxis, column_error_path, duplication_error_path, logger_info, logger_error,file_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        drop_row_index = []




        df_maxis = drop_duplicates_and_save_duplicates(df_maxis, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_maxis)
        for column in df_maxis.columns:
            df_maxis[column] = df_maxis[column].apply(lambda x: str(x).strip())

        df_maxis = df_maxis.astype(str)

        df_maxis["Missing_Columns"] = ''
        df_maxis["Type_Mismatch"] = ''



        column_error_list = []
        data_type_mismatch = []
        for index, row in df_maxis.iterrows():
            error_list = []
            data_type_error_list = []
            if len(row["ACCOUNT_NO"]) == 0 \
                    or len(row["BILL_COUNTRY_CODE"]) == 0 \
                    or len(row["BILL_COMPANY"]) == 0 or len(row["BILL_PERIOD"]) == 0 or len(row["BRN_NO"]) == 0 \
                    or ((len(row["PARENT_ID"]) == 0) and (row["ACCOUNT_NO"] != row["MASTER_ACCOUNT_NO"])) \
                    or len(row["ACCOUNT_TYPE"]) == 0 or len(row["LEVEL"]) == 0:
                drop_row_index.append(index)
                if len(row["ACCOUNT_NO"]) == 0:
                    logger_error.error("Missing value ACCOUNT_NO in row : {} ".format(index))
                    error_list.append("Missing value ACCOUNT_NO")
                if len(row["BILL_COUNTRY_CODE"]) == 0:
                    logger_error.error("Missing value BILL_COUNTRY_CODE in row : {} ".format(index))
                    error_list.append("Missing value BILL_COUNTRY_CODE")
                if len(row["BILL_COMPANY"]) == 0:
                    logger_error.error("Missing value BILL_COMPANY in row : {} ".format(index))
                    error_list.append("Missing value BILL_COMPANY")
                if len(row["BILL_PERIOD"]) == 0:
                    logger_error.error("Missing value BILL_PERIOD in row : {} ".format(index))
                    error_list.append("Missing value BILL_PERIOD")
                if len(row["BRN_NO"]) == 0:
                    logger_error.error("Missing value BRN_NO in row : {} ".format(index))
                    error_list.append("Missing value BRN_NO")

                if (len(row["PARENT_ID"]) == 0) and (row["ACCOUNT_NO"] != row["MASTER_ACCOUNT_NO"]):
                    logger_error.error("Missing value PARENT_ID in row : {} ".format(index))
                    error_list.append("Missing value PARENT_ID")

                if len(row["ACCOUNT_TYPE"]) == 0:
                    logger_error.error("Missing value ACCOUNT_TYPE in row : {} ".format(index))
                    error_list.append("Missing value ACCOUNT_TYPE")

                if len(row["LEVEL"]) == 0:
                    logger_error.error("Missing value LEVEL in row : {} ".format(index))
                    error_list.append("Missing value LEVEL")


            elif (not ((row["ACCOUNT_NO"]).isnumeric())) or (
                    len(row["BILL_ZIP"]) != 0 and (not (is_alphanumeric(row["BILL_ZIP"])))) \
                    or (len(row["MASTER_ACCOUNT_NO"]) != 0 and (not ((row["MASTER_ACCOUNT_NO"]).isnumeric()))) or (
                    (len(row["PARENT_ID"]) != 0) and (not ((row["PARENT_ID"]).isnumeric()))) \
                    or (len(row["BILL_CITY"]) != 0 and (not (is_alphanumeric(row["BILL_CITY"])))) or (
            not (is_alphanumeric(row["BILL_PERIOD"]))) \
                    or (not (is_alphanumeric(row["BRN_NO"]))) or (
            not (check_enum(row["ACCOUNT_TYPE"], allowed_values=['billable', 'Non billable']))) \
                    or (not (check_enum(row["LEVEL"], allowed_values=['1', '2', '3']))):
                # or (len(row["BILL_ADDRESS1"]) != 0 and (not (is_alphanumeric(row["BILL_ADDRESS1"])))) \
                drop_row_index.append(index)

                if (not ((row["ACCOUNT_NO"]).isnumeric())):
                    logger_error.error("Type Mismatch ACCOUNT_TYPE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch ACCOUNT_TYPE")
                if (len(row["BILL_ZIP"]) != 0 and (not (is_alphanumeric(row["BILL_ZIP"])))):
                    logger_error.error("Type Mismatch BILL_ZIP in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch BILL_ZIP")
                if (len(row["MASTER_ACCOUNT_NO"]) != 0 and (not ((row["MASTER_ACCOUNT_NO"]).isnumeric()))):
                    logger_error.error("Type Mismatch MASTER_ACCOUNT_NO in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch MASTER_ACCOUNT_NO")
                if ((len(row["PARENT_ID"]) != 0) and (not ((row["PARENT_ID"]).isnumeric()))):
                    logger_error.error("Type Mismatch PARENT_ID in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch PARENT_ID")

                if (len(row["BILL_CITY"]) != 0 and (not (is_alphanumeric(row["BILL_CITY"])))):
                    logger_error.error("Type Mismatch BILL_CITY in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch BILL_CITY")

                if (not (is_alphanumeric(row["BILL_PERIOD"]))):
                    logger_error.error("Type Mismatch BILL_PERIOD in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch BILL_PERIOD")

                if (not (is_alphanumeric(row["BRN_NO"]))):
                    logger_error.error("Type Mismatch BRN_NO in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch BRN_NO")

                if (not (check_enum(row["ACCOUNT_TYPE"], allowed_values=['billable', 'Non billable']))):
                    logger_error.error("Type Mismatch ACCOUNT_TYPE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch ACCOUNT_TYPE")

                if (not (check_enum(row["LEVEL"], allowed_values=['1', '2', '3']))):
                    logger_error.error("Type Mismatch LEVEL in row : {} ".format(index))
                    logger_info.error("Type Mismatch LEVEL in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch LEVEL")

            row["Missing_Columns"] = ', '.join(error_list)
            row["Type_Mismatch"] = ', '.join(data_type_error_list)
            column_error_list.extend(error_list)
            data_type_mismatch.extend(data_type_error_list)

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_maxis.iloc[drop_row_index, :]

        df_partial_error = df_maxis.iloc[drop_row_index, :]

        delete_before(validation_error_dir)
        print('Length of Company validation Error file : ', len(df_partial_error))
        logger_info.info('Length Company of validation Error file : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            missing_value_errors = list(set(column_error_list))
            print("Company Common Errors : ", missing_value_errors)
            logger_info.info('Company Common Errors : {}'.format(missing_value_errors))
            for error in missing_value_errors:
                # filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                filtered_df = df_partial_error[
                    df_partial_error['Missing_Columns'].str.contains(error, case=False, na=False)]
                # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                csv_filename = f"{error}_{file_name}"
                filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)



            # print("type errors", data_type_mismatch)
            if len(data_type_mismatch) != 0:
                type_mismatch_errors = list(set(data_type_mismatch))
                print("Company Type Errors : ", type_mismatch_errors)
                logger_info.info('company file type mismatch errors : {}'.format(type_mismatch_errors))
                for error in type_mismatch_errors:
                    # type_filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                    type_filtered_df = df_partial_error[
                        df_partial_error['Type_Mismatch'].str.contains(error, case=False, na=False)]
                    # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                    csv_filename = f"{error}_{file_name}"
                    type_filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                    type_filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)
        df_maxis = df_maxis.drop(drop_row_index)

        df_maxis = df_maxis.reset_index(drop=True)
        type_mismatch_df = df_partial_error[
            (df_partial_error['Missing_Columns'].str.contains("Missing value BILL_COMPANY", case=False, na=False)) |
            (df_partial_error['Missing_Columns'].str.contains("Missing value BRN_NO", case=False, na=False))
            ].copy()
        df_maxis.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)
        type_mismatch_df.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)
        print(type_mismatch_df)

        # print("*****************************")
        return df_maxis,type_mismatch_df

    except Exception as e:
        logger_error.error("error processing m2m_company csv file:{}".format(e))
        raise ValueError("error processing m2m_company csv file")

def PIC_USER_TO_AQ(df_maxis, column_error_path,required_columns,logger_info, logger_error,file_name):
    """
           Method to check missing values in csv file PIC User and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filterd dataframe"""
    try:
        drop_row_index = []

        df_maxis = drop_duplicates_and_save_duplicates(df_maxis, file_name,logger_info,['email','brn'])
        df_maxis = remove_special_characters(df_maxis,'mobile_phone')
        # print('\n duplicate data frame', df_maxis)
        for column in df_maxis.columns:
            df_maxis[column] = df_maxis[column].apply(lambda x: str(x).strip())

        df_maxis = df_maxis.astype(str)

        df_maxis["Missing_Columns"] = ''
        df_maxis["Type_Mismatch"] = ''

        def validate_date(test_str):
            pattern_str = r'\d{4}[/\-]\d{2}[/\-]\d{2} \d{2}:\d{2}'
            if re.match(pattern_str, test_str):
                return True
            else:
                return False

        column_error_list = []
        data_type_mismatch = []
        for index, row in df_maxis.iterrows():
            error_list = []
            data_type_error_list = []

            missing_columns = [col for col in required_columns if len(row[col]) == 0]
            # drop record if column is null
            if missing_columns:
                drop_row_index.append(index)
                error_list.extend([f"Missing value {col}" for col in missing_columns])


            elif (len(row["brn"]) != 0 and (not (is_alphanumeric(row["brn"])))):
                logger_error.error("Type Mismatch brn in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch brn")
                drop_row_index.append(index)

            elif (len(row["last_name"]) != 0 and (not (isinstance(row["last_name"], str)))):
                logger_error.error("Type Mismatch last_name in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch last_name")
                drop_row_index.append(index)


            elif (len(row["first_name"]) != 0 and (not (isinstance(row["first_name"],str)))):
                logger_error.error("Type Mismatch first_name in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch first_name")
                drop_row_index.append(index)

            elif (len(row["email"]) != 0 and (not (validate_email(row["email"])))):
                logger_error.error("Type Mismatch email in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch email")
                drop_row_index.append(index)

            elif (len(row["login_name"]) != 0 and (not (validate_email(row["login_name"])))):
                logger_error.error("Type Mismatch login_name in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch login_name")
                drop_row_index.append(index)

            elif (len(row["last_login"]) != 0 and (not (validate_date(row["last_login"])))):
                logger_error.error("Type Mismatch login_name in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch login_name")
                drop_row_index.append(index)

            elif (len(row["mobile_phone"]) != 0) and (not ((row["mobile_phone"]).isnumeric())):
                logger_error.error("Type Mismatch mobile_phone in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch mobile_phone")
                drop_row_index.append(index)

            elif (len(row["role_name"]) != 0 and (not (check_enum(row["role_name"], allowed_values=['CBAS', 'CADM','COPR','MACC','MADM','MOPR','MCUS','MOP3','CAPI'])))):
                logger_error.error("Type Mismatch role_name in row : {} ".format(index))
                data_type_error_list.append("Type Mismatch role_name")
                drop_row_index.append(index)


            row["Missing_Columns"] = ', '.join(error_list)
            row["Type_Mismatch"] = ', '.join(data_type_error_list)
            column_error_list.extend(error_list)
            data_type_mismatch.extend(data_type_error_list)


        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_maxis.iloc[drop_row_index, :]

        df_partial_error = df_maxis.iloc[drop_row_index, :]

        # delete_before(validation_error_dir)
        print('Length of Pic validation Error file : ', len(df_partial_error))
        logger_info.info('Length of Pic validation Error file : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            missing_value_errors = list(set(column_error_list))
            print("Pic Common Errors : ", missing_value_errors)
            logger_info.info('Pic Common Errors : {}'.format(missing_value_errors))
            for error in missing_value_errors:
                # filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                filtered_df = df_partial_error[
                    df_partial_error['Missing_Columns'].str.contains(error, case=False, na=False)]
                # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                csv_filename = f"{error}_{file_name}"
                filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)

            # print("type errors", data_type_mismatch)
            if len(data_type_mismatch) != 0:
                type_mismatch_errors = list(set(data_type_mismatch))
                print("Pic Type Errors : ", type_mismatch_errors)
                logger_info.info('Pic type mismatch errors : {}'.format(type_mismatch_errors))
                for error in type_mismatch_errors:
                    # type_filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                    type_filtered_df = df_partial_error[
                        df_partial_error['Type_Mismatch'].str.contains(error, case=False, na=False)]
                    # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                    csv_filename = f"{error}_{file_name}"
                    type_filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                    type_filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)
        df_maxis = df_maxis.drop(drop_row_index)

        df_maxis = df_maxis.reset_index(drop=True)

        df_maxis.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)

        # print("*****************************")
        return df_maxis

    except Exception as e:
        logger_error.error("error processing Pic csv file:{}".format(e))
        raise ValueError("error processing Pic csv file")


def M2M_Service_to_AQ(df_maxis, column_error_path, duplication_error_path, logger_info, logger_error, file_name):
    """
           Method to check missing values in csv file and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filterd dataframe"""
    try:
        drop_row_index = []

        df_maxis = drop_duplicates_and_save_duplicates(df_maxis, duplication_error_path,logger_info,'IMSI')

        df_maxis = df_maxis.astype(str)

        def validate_date(test_str):
            pattern_str = r'\d{2}[/\-]\d{2}[/\-]\d{4} \d{2}:\d{2}'
            if re.match(pattern_str, test_str):
                return True
            else:
                return False

        for column in df_maxis.columns:
            df_maxis[column] = df_maxis[column].apply(lambda x: str(x).strip())

        df_maxis["Missing_Columns"] = ''
        df_maxis["Type_Mismatch"] = ''

        column_error_list = []
        data_type_mismatch = []
        for index, row in df_maxis.iterrows():

            error_list = []
            data_type_error_list = []
            if (len(row["ACCOUNT_NO"]) == 0 and len(row["BILLABLE_ACCOUNT_NO"]) == 0) \
                    or (len(row["MI_COMPONENTID"]) == 0 and (
                    row["PLAN_CATEGORY"] == 'IOT Refresh Plan' or row["PLAN_CATEGORY"] == 'IOT NaaS Plan')) \
                    or (len(row["STATUS_REASON_ID"]) == 0 and row["STATUS_ID"] == 'Suspend') \
                    or (len(row["STATUS_REASON"]) == 0 and row["STATUS_ID"] == 'Suspend') \
                    or len(row["SIM_CARD_SERIAL_NO"]) == 0 \
                    or len(row["IMSI"]) == 0 \
                    or len(row["MSISDN"]) == 0 \
                    or len(row["PACKAGE_NAME"]) == 0 \
                    or len(row["COMPONENT_ID"]) == 0 \
                    or len(row["FUP_PPU_POOL_TYPE"]) == 0 \
                    or len(row["PLAN_CATEGORY"]) == 0 \
                    or len(row["STATUS_ID"]) == 0:
                drop_row_index.append(index)

                if (len(row["ACCOUNT_NO"]) == 0 and len(row["BILLABLE_ACCOUNT_NO"]) == 0):
                    logger_error.error("Missing value ACCOUNT_NO and BILLABLE_ACCOUNT_NO in row : {} ".format(index))
                    error_list.append("Missing value ACCOUNT_NO and BILLABLE_ACCOUNT_NO")

                if (len(row["MI_COMPONENTID"]) == 0 and (
                        row["PLAN_CATEGORY"] == 'IOT Refresh Plan' or row["PLAN_CATEGORY"] == 'IOT NaaS Plan')):
                    logger_error.error("Missing value BILL_ADDRESS1 in row : {} ".format(index))
                    error_list.append("Missing value MI_COMPONENTID")
                if (len(row["STATUS_REASON_ID"]) == 0 and row["STATUS_ID"] == 'Suspend'):
                    logger_error.error("Missing value STATUS_REASON_ID in row : {} ".format(index))
                    error_list.append("Missing value STATUS_REASON_ID")
                if (row["STATUS_REASON"] == '' and row["STATUS_ID"] == 'Suspend'):
                    logger_error.error("Missing value STATUS_REASON in row : {} ".format(index))
                    error_list.append("Missing value STATUS_REASON")
                if len(row["SIM_CARD_SERIAL_NO"]) == 0:
                    logger_error.error("Missing value SIM_CARD_SERIAL_NO in row : {} ".format(index))
                    error_list.append("Missing value SIM_CARD_SERIAL_NO")
                if len(row["IMSI"]) == 0:
                    logger_error.error("Missing value IMSI in row : {} ".format(index))
                    error_list.append("Missing value IMSI")
                if len(row["MSISDN"]) == 0:
                    logger_error.error("Missing value MSISDN in row : {} ".format(index))
                    error_list.append("Missing value MSISDN")
                if len(row["PACKAGE_NAME"]) == 0:
                    logger_error.error("Missing value PACKAGE_NAME in row : {} ".format(index))
                    error_list.append("Missing value PACKAGE_NAME")
                if len(row["COMPONENT_ID"]) == 0:
                    logger_error.error("Missing value COMPONENT_ID in row : {} ".format(index))
                    error_list.append("Missing value COMPONENT_ID")
                if len(row["FUP_PPU_POOL_TYPE"]) == 0:
                    logger_error.error("Missing value FUP_PPU_POOL_TYPE in row : {} ".format(index))
                    error_list.append("Missing value FUP_PPU_POOL_TYPE")
                if len(row["PLAN_CATEGORY"]) == 0:
                    logger_error.error("Missing value PLAN_CATEGORY in row : {} ".format(index))
                    error_list.append("Missing value PLAN_CATEGORY")
                if len(row["STATUS_ID"]) == 0:
                    logger_error.error("Missing value STATUS_ID in row : {} ".format(index))
                    error_list.append("Missing value STATUS_ID")

            elif (len(row["ACCOUNT_NO"]) != 0 and (not ((row["ACCOUNT_NO"]).isnumeric()))) or (
                    len(row["BILLABLE_ACCOUNT_NO"]) != 0 and (not ((row["BILLABLE_ACCOUNT_NO"]).isnumeric()))) \
                    or (not ((row["SIM_CARD_SERIAL_NO"]).isnumeric())) or (not ((row["IMSI"]).isnumeric())) or (
            not ((row["MSISDN"]).isnumeric())) \
                    or (not ((row["COMPONENT_ID"]).isnumeric())) \
                    or (not (is_alphanumeric(row["PACKAGE_NAME"]))) \
                    or (len(row["SERVICE_ACTIVE_DT"]) != 0 and (not validate_date(row["SERVICE_ACTIVE_DT"]))) \
                    or (
                    len(row["SERVICE_STATUS_CHG_DATE"]) != 0 and (not validate_date(row["SERVICE_STATUS_CHG_DATE"]))) \
                    or (len(row["CONTRACT_START_DATE"]) != 0 and (not validate_date(row["CONTRACT_START_DATE"]))) \
                    or (len(row["CONTRACT_END_DATE"]) != 0 and (not validate_date(row["CONTRACT_END_DATE"]))) \
                    or (not check_enum(row['FUP_PPU_POOL_TYPE'], allowed_values=['FUP', 'PPU', 'POOL'])) \
                    or (not check_enum(row['PLAN_CATEGORY'],
                                       allowed_values=['M2M Legacy Plan', 'IOT Refresh Plan', 'M2M New Plan',
                                                       'M2M PPU Plan', 'IOT NaaS Plan'])) \
                    or (not check_enum(row['STATUS_ID'],
                                       allowed_values=['Active', 'Suspend', 'Terminated', 'Transferred In',
                                                       'Transferred Out'])) \
                    or (len(row["VOICE_INDICATOR"]) != 0 and (
            not check_enum(row['VOICE_INDICATOR'], allowed_values=['TRUE', 'FALSE']))) \
                    or (len(row["SMS_INDICATOR"]) != 0 and (
            not check_enum(row['SMS_INDICATOR'], allowed_values=['TRUE', 'FALSE']))) \
                    or (len(row["ROAM_INDICATOR"]) != 0 and (
            not check_enum(row['ROAM_INDICATOR'], allowed_values=['TRUE', 'FALSE']))):
                drop_row_index.append(index)

                if (len(row["ACCOUNT_NO"]) != 0 and (not ((row["ACCOUNT_NO"]).isnumeric()))):
                    logger_error.error("Type Mismatch ACCOUNT_NO in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch ACCOUNT_NO")

                if (not ((row["SIM_CARD_SERIAL_NO"]).isnumeric())):
                    logger_error.error("Type Mismatch SIM_CARD_SERIAL_NO in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch SIM_CARD_SERIAL_NO")

                if (not ((row["IMSI"]).isnumeric())):
                    logger_error.error("Type Mismatch IMSI in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch IMSI")

                if (not ((row["MSISDN"]).isnumeric())):
                    logger_error.error("Type Mismatch MSISDN in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch MSISDN")

                if (not ((row["COMPONENT_ID"]).isnumeric())):
                    logger_error.error("Type Mismatch COMPONENT_ID in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch COMPONENT_ID")

                if (not (is_alphanumeric(row["PACKAGE_NAME"]))):
                    logger_error.error("Type Mismatch PACKAGE_NAME in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch PACKAGE_NAME")

                if (len(row["SERVICE_ACTIVE_DT"]) != 0 and (not validate_date(row["SERVICE_ACTIVE_DT"]))):
                    logger_error.error("Type Mismatch SERVICE_ACTIVE_DT in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch SERVICE_ACTIVE_DT")

                if (len(row["SERVICE_STATUS_CHG_DATE"]) != 0 and (not validate_date(row["SERVICE_STATUS_CHG_DATE"]))):
                    logger_error.error("Type Mismatch SERVICE_STATUS_CHG_DATE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch SERVICE_STATUS_CHG_DATE")
                if (len(row["CONTRACT_START_DATE"]) != 0 and (not validate_date(row["CONTRACT_START_DATE"]))):
                    logger_error.error("Type Mismatch CONTRACT_START_DATE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch CONTRACT_START_DATE")
                if (len(row["CONTRACT_END_DATE"]) != 0 and (not validate_date(row["CONTRACT_END_DATE"]))):
                    logger_error.error("Type Mismatch CONTRACT_END_DATE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch CONTRACT_END_DATE")

                if (not check_enum(row['FUP_PPU_POOL_TYPE'], allowed_values=['FUP', 'PPU', 'POOL'])):
                    logger_error.error("Type Mismatch FUP_PPU_POOL_TYPE in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch FUP_PPU_POOL_TYPE")
                if (not check_enum(row['PLAN_CATEGORY'],
                                   allowed_values=['M2M Legacy Plan', 'IOT Refresh Plan', 'M2M New Plan',
                                                   'M2M PPU Plan', 'IOT NaaS Plan'])):
                    logger_error.error("Type Mismatch PLAN_CATEGORY in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch PLAN_CATEGORY")
                if (not check_enum(row['STATUS_ID'],
                                   allowed_values=['Active', 'Suspend', 'Terminated', 'Transferred In',
                                                   'Transferred Out'])):
                    logger_error.error("Type Mismatch STATUS_ID in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch STATUS_ID")
                if (len(row["VOICE_INDICATOR"]) != 0 and (
                not check_enum(row['VOICE_INDICATOR'], allowed_values=['TRUE', 'FALSE']))):
                    logger_error.error("Type Mismatch VOICE_INDICATOR in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch VOICE_INDICATOR")
                if (len(row["SMS_INDICATOR"]) != 0 and (
                not check_enum(row['SMS_INDICATOR'], allowed_values=['TRUE', 'FALSE']))):
                    logger_error.error("Type Mismatch SMS_INDICATOR in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch SMS_INDICATOR")
                if (len(row["ROAM_INDICATOR"]) != 0 and (
                not check_enum(row['ROAM_INDICATOR'], allowed_values=['TRUE', 'FALSE']))):
                    logger_error.error("Type Mismatch ROAM_INDICATOR in row : {} ".format(index))
                    data_type_error_list.append("Type Mismatch ROAM_INDICATOR")

            row["Missing_Columns"] = ', '.join(error_list)
            row["Type_Mismatch"] = ', '.join(data_type_error_list)
            column_error_list.extend(error_list)
            data_type_mismatch.extend(data_type_error_list)

        # print('sdfgh',drop_row_index)
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_maxis.iloc[drop_row_index, :]

        # df_partial_error = df_maxis.iloc[drop_row_index, :]
        # delete_before(validation_error_dir)

        if not df_partial_error.empty:
            missing_value_errors = list(set(column_error_list))
            print("Service Common Errors : ", missing_value_errors)
            logger_info.info('Service Common Errors : {}'.format(missing_value_errors))
            for error in missing_value_errors:
                # filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                filtered_df = df_partial_error[
                    df_partial_error['Missing_Columns'].str.contains(error, case=False, na=False)]
                # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                csv_filename = f"{error}_{file_name}"
                filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)

            # print("type errors", data_type_mismatch)
            if len(data_type_mismatch) != 0:
                type_mismatch_errors = list(set(data_type_mismatch))
                print("Service Type Errors : ", type_mismatch_errors)
                logger_info.info('type mismatch errors : {}'.format(type_mismatch_errors))
                for error in type_mismatch_errors:
                    # type_filtered_df = df_partial_error[df_partial_error['Missing_Columns'].apply(lambda x: error in eval(x))].copy()
                    type_filtered_df = df_partial_error[
                        df_partial_error['Type_Mismatch'].str.contains(error, case=False, na=False)]
                    # filtered_df['Missing_Columns'] = [[error]] * len(filtered_df)
                    csv_filename = f"{error}_{file_name}"
                    type_filtered_df.to_csv(os.path.join(column_error_path, csv_filename), index=False)
                    type_filtered_df.to_csv(os.path.join(error_directory, csv_filename), index=False)
        print('Length of Service validation Error file : ', len(df_partial_error))
        logger_info.info("Length of Service validation Error file : {}".format(len(df_partial_error)))
        df_maxis = df_maxis.drop(drop_row_index)

        df_maxis = df_maxis.reset_index(drop=True)
        df_maxis.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)

        # print("*****************************")

        return df_maxis

    except Exception as e:
        logger_error.error("error processing csv file:{}".format(e))
        raise ValueError("error processing csv file")
