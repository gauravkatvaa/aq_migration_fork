"""
Created on 02 Feb 2024
@author: amit.k@airlinq.com

Script to convert incoming csv file into the desired format of csv file

1) M2M_Customer_to_AQ :- If any mandatory column value is empty in case of eCMP M2M Company File then this function Drop those particular records(rows)
    -> Second Check will be to check if any column dataType mismatch then drop those records , datatype check is implemented on isNumeric,isAlphaNumeric, checkEnum and checkDateTime
"""

import sys

import pandas as pd
import csv

# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.library import *
from src.utils.utils_lib import *
from conf.custom.apollo.config import *
import datetime
import time
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

dir_path = dirname(abspath(__file__))



def append_to_data_value_file(filename, length_of_original_file, length_of_error, is_duplicate,data_value_file):
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    header_company = ["Entity", "Record Count", "Rejected", "Duplicate"]

    # Check if the data value file exists and is empty
    if not os.path.exists(data_value_file) or os.path.getsize(data_value_file) == 0:
        try:
            # Write the header along with the data
            with open(data_value_file, 'w', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(header_company)  # Write input headers
                writer.writerow([filename, length_of_original_file, length_of_error, is_duplicate])
        except Exception as e:
            print(f"An error occurred while writing to the data value file: {e}")
            logger_error.error(f"An error occurred while writing to the data value file: {e}")
    else:
        try:
            # Append the data
            with open(data_value_file, 'a', newline='') as f:
                writer = csv.writer(f)
                writer.writerow([filename, length_of_original_file, length_of_error, is_duplicate])
        except Exception as e:
            print(f"An error occurred while appending to the data value file: {e}")
            logger_error.error(f"An error occurred while appending to the data value file: {e}")


def process_discount_dataframe(df):
    # Initialize an empty DataFrame for errors with an additional column for the reason
    error_df = pd.DataFrame(columns=df.columns.tolist() + ['Reason'])

    # Create an empty list to collect rows to keep
    rows_to_keep = []

    # Function to process each group based on the conditions
    def process_group(group):
        try:
            max_value = group['DISCOUNTPERCENTAGEVALUE'].max()
            max_rows = group[group['DISCOUNTPERCENTAGEVALUE'] == max_value]
            non_max_rows = group[group['DISCOUNTPERCENTAGEVALUE'] < max_value]

            # Append rows with max DISCOUNTPERCENTAGEVALUE to rows_to_keep
            for _, row in max_rows.iterrows():
                rows_to_keep.append(row)

            # Append non-max rows to error_df with reasons
            for _, row in non_max_rows.iterrows():
                reason = f"Row dropped because BUSINESSUNITID {row['BUSINESSUNITID']}, DISOCUNTEDRATINGELEMENTS {row['DISOCUNTEDRATINGELEMENTS']} value is less than maximum."
                row_with_reason = row.append(pd.Series([reason], index=['Reason']))
                error_df.loc[len(error_df)] = row_with_reason
                # logger_info.info(f"Row added to error_df: {row_with_reason}")
        except Exception as e:
            # logger_error.error(f"An error occurred while processing the group: {e}")
            print(f"An error occurred while processing the group: {e}")


    # Process the DataFrame
    for discount_level in ['SIM level', 'Account level']:
        try:
            if discount_level == 'Account level':
                df_level = df[df['DISCOUNTLEVEL'] == discount_level]
                grouped = df_level.groupby(['BUSINESSUNITID', 'DISOCUNTEDRATINGELEMENTS'])
            else:
                df_level = df[df['DISCOUNTLEVEL'] == discount_level]
                grouped = df_level.groupby(['BUSINESSUNITID', 'DISCOUNTEDPRODUCTTARIFFNAME', 'DISOCUNTEDRATINGELEMENTS','SERVICEPROFILEID'])

            for _, group in grouped:
                process_group(group)
        except Exception as e:
            # logger_error.error(f"An error occurred while processing the discount level '{discount_level}': {e}")
            print(f"An error occurred while processing the discount level '{discount_level}': {e}")
    # Create the success DataFrame from the rows_to_keep list
    try:
        success_df = pd.DataFrame(rows_to_keep, columns=df.columns)
    except Exception as e:
        # logger_error.error(f"An error occurred while creating the success DataFrame: {e}")
        success_df = pd.DataFrame(columns=df.columns)  # Create an empty DataFrame if there's an error

    return success_df, error_df





def check_account_id_in_column(df, number_list, column_name):
    """
    Function to check if any number from a list exists in a specified column of a DataFrame.
    Uses vectorized operations for efficiency.
    
    Parameters:
    df (pd.DataFrame): The DataFrame to check.
    number_list (list): The list of numbers to check for.
    column_name (str): The column to check in the DataFrame.
    
    Returns:
    pd.DataFrame: success_df containing rows with matches.
    pd.DataFrame: error_df containing rows without matches and reasons.
    """
    print("function_is_calling")
    # Create boolean masks for matching and non-matching rows
    match_mask = df[column_name].isin(number_list)
    error_mask = ~match_mask
    
    # Extract matching and non-matching rows
    success_df = df[match_mask].copy()
    error_df = df[error_mask].copy()
    
    # Add reason column to error_df
    error_df['Reason'] = f"{column_name} value does not match with Assets Table"
    
    return success_df, error_df

def check_account_id_in_column_for_trigger_df(df, number_list, second_number_list,opco_list, bu_id_column, customer_id_column,opco_column_name,filename):
    """
    Function to check if any number from a list exists in 'bu_id' or 'customer_id' column of a DataFrame.
    Rows with matches are appended to a success DataFrame.
    Rows without matches are appended to an error DataFrame with a reason, except those where 'is_public' is 0.

    Parameters:
    df (pd.DataFrame): The DataFrame to check.
    number_list (list): The list of numbers to check for the 'bu_id' column.
    second_number_list (list): The list of numbers to check for the 'customer_id' column when 'bu_id' is empty.
    bu_id_column (str): The column to check for the primary list.
    customer_id_column (str): The column to check for the secondary list when 'bu_id' is empty.

    Returns:
    pd.DataFrame: success_df containing rows with matches.
    pd.DataFrame: error_df containing rows without matches and reasons.
    """
    # Create masks for matching and non-matching rows
    bu_id_empty_mask = df[bu_id_column].isna() | (df[bu_id_column] == '')
    bu_id_match_mask = df[bu_id_column].isin(number_list)
    customer_id_match_mask = df[customer_id_column].isin(second_number_list)
    
    # Combined masks
    success_mask = bu_id_match_mask | (bu_id_empty_mask & customer_id_match_mask)
    error_mask = ~success_mask 

    if filename=='users_details_cdp':
        lead_person_id_match_mask = df['ROLE_NAME'].isin(['OpCo_AM','Lead Person'])
        success_mask = bu_id_match_mask | lead_person_id_match_mask | (bu_id_empty_mask & customer_id_match_mask)
        error_mask = ~success_mask
        # print("AMIT")
    # Extract matching and non-matching rows
    success_df = df[success_mask].copy()
    error_df = df[error_mask].copy()
    
    # Add reason column to error_df
    error_df['Reason'] = (
        f"{bu_id_column} value does not match with the first list and "
        f"{customer_id_column} value does not match with the second list when {bu_id_column} is empty"
    )

    return success_df, error_df




def process_apns_cdp(df, bu_list, BU_LIST_col, customer_col, CU_ID_list, logger_info, logger_error):
    try:
        # Print the total number of rows in the DataFrame
        logger_info.info(f"Total rows in the DataFrame: {len(df)}")

        # Check if 'IS_PRIVATE' column exists in the DataFrame
        if 'IS_PRIVATE' not in df.columns:
            raise ValueError("Column 'IS_PRIVATE' not found in DataFrame.")

        # Initialize an empty DataFrame for errors with an additional column for the reason
        error_df = pd.DataFrame(columns=df.columns.tolist() + ['Reason'])

        def check_bu_list(row):
            try:
                is_private = int(row['IS_PRIVATE'])  # Convert IS_PRIVATE to int
                if is_private == 1:
                    bu_values = row[BU_LIST_col].split(',')
                    
                    if 'All' in bu_values:
                        if row[customer_col] not in CU_ID_list:
                            reason = f"{customer_col} '{row[customer_col]}' does not exist in CU_ID_list"
                            row_copy = row.copy()
                            row_copy['Reason'] = reason
                            error_df.loc[len(error_df)] = row_copy
                            return None, reason
                        return row, None  # If 'ALL' is present and customer_col is valid, return the row

                    valid_bu_values = [bu for bu in bu_values if bu in bu_list]
                    invalid_bu_values = [bu for bu in bu_values if bu not in bu_list]

                    if valid_bu_values:
                        row[BU_LIST_col] = ','.join(valid_bu_values)
                        if invalid_bu_values:
                            reason = f"Removed invalid {BU_LIST_col} values: {', '.join(invalid_bu_values)}"
                            row_copy = row.copy()
                            row_copy['Reason'] = reason
                            error_df.loc[len(error_df)] = row_copy
                        return row, None  # Return the row and None for error reason if no errors
                    else:
                        reason = f"{BU_LIST_col} values '{', '.join(invalid_bu_values)}' do not match the provided list"
                        row_copy = row.copy()
                        row_copy['Reason'] = reason
                        error_df.loc[len(error_df)] = row_copy
                        return None, reason  # Return None for row and reason for errors
                return row, None  # Return the row and None for error reason if is_private is not 1
            except Exception as e:
                logger_error.error(f"Error processing row {row}: {e}")
                raise

        matched_rows = []
        error_rows = []

        for _, row in df.iterrows():
            updated_row, reason = check_bu_list(row)
            if updated_row is not None:
                matched_rows.append(updated_row)
            if reason:
                row['Reason'] = reason
                error_rows.append(row)

        # Create DataFrames from the lists of rows
        matched_df = pd.DataFrame(matched_rows)
        error_df = pd.DataFrame(error_rows)

        # Convert 'IS_PRIVATE' column to integer type
        if 'IS_PRIVATE' in matched_df.columns:
            matched_df['IS_PRIVATE'] = matched_df['IS_PRIVATE'].astype(int)
        if 'IS_PRIVATE' in error_df.columns:
            error_df['IS_PRIVATE'] = error_df['IS_PRIVATE'].astype(int)

        # Log the number of matched and error records
        logger_info.info(f"Matched records: {len(matched_df)}")
        logger_info.info(f"Error records: {len(error_df)}")

        return matched_df, error_df

    except Exception as e:
        logger_error.error(f"An error occurred during the processing: {e}")
        # Return empty DataFrames if an error occurs
        return pd.DataFrame(), pd.DataFrame()

def validate_feed_file(input_feed_file_path,column_error_path, duplicate_file_name, logger_info, logger_error,file_name,bu_list,cu_list,opco_list):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        drop_row_index = []
       
        start_time = time.time()
        if file_name in ['zonegroup_load_data', 'Entitlement_data_load', 'zone_product_pricing_load_data']:
    
            df_address_details_cdp=pd.read_csv(f"{input_feed_file_path}/{file_name}.csv",keep_default_na=False,skipinitialspace=True,dtype=str,encoding='latin1')
            print(df_address_details_cdp)
        
        else:
            df_address_details_cdp = pd.read_csv(f"{input_feed_file_path}/{file_name}.csv",keep_default_na=False,skipinitialspace=True,dtype=str)
        length_of_original_df = len(df_address_details_cdp)
        
        print("################ Processing {} File #######################".format(file_name))
        
        logger_info.info("################ Processing {} File #######################".format(file_name))
        print("Length of original File : ",length_of_original_df)
        logger_info.info("Length of original File {}".format(length_of_original_df))
        duplicate_error_ec_filename = duplicate_file_name + "_" + current_time_stamp + ".csv"
        company_duplication_error_path = os.path.join(column_error_path, duplicate_error_ec_filename)
        duplicates = df_address_details_cdp[df_address_details_cdp.duplicated()]
        print('Length of Duplicate records : ', len(duplicates))
        duplicate_len=len(duplicates)
        logger_info.info('Length of Duplicate records : {}'.format(len(duplicates)))
        if not duplicates.empty:
            duplicates.to_csv(company_duplication_error_path, index=False)

        df_address_details_cdp = df_address_details_cdp.drop_duplicates()
        
        # df_address_details_cdp = drop_duplicates_and_save_duplicates(df_address_details_cdp, company_duplication_error_path,logger_info,'CUSTOMER_ID')
        # print('\n duplicate data frame', df_address_details_cdp)
        for column in df_address_details_cdp.columns:
            df_address_details_cdp[column] = df_address_details_cdp[column].apply(lambda x: str(x).strip())

        df_address_details_cdp = df_address_details_cdp.astype(str)

        df_address_details_cdp["Missing_Columns"] = ''
        df_address_details_cdp["Type_Mismatch"] = ''

        column_error_list = []
        data_type_mismatch = []
        if file_name == 'address_details_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['PARTY_ROLE_ID']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("PARTY_ROLE_ID", lambda x: x.isnumeric(), "Type Mismatch PARTY_ROLE_ID")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'assets_cdp':
            try:
                duplicate_colums = duplicate_file_name  + "_" + current_time_stamp + ".csv"
                company_duplication_error = os.path.join(column_error_path, duplicate_colums)
                after_len=len(df_address_details_cdp)
                df_address_details_cdp=drop_duplicates_and_save_duplicates(df_address_details_cdp,company_duplication_error ,logger_info,['IMSI', 'ICCID', 'MSISDN'])
                duplicate_len=duplicate_len+(after_len-len(df_address_details_cdp))
                
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['IMSI', 'ICCID', 'MSISDN', 'SIM_STATUS', 'SIMPRODUCT_ID']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    # Checking for additional condition
                    if row['SIM_STATUS'] in ['A', 'B'] and len(row['SERVICE_PROFILE_ID']) == 0:
                        error_list.append("Missing value SERVICE_PROFILE_ID when SIM_STATUS is 'A' or 'B'")

                    # if row['SIM_STATUS'] in ['S', 'V']:
                    #     error_list.append("Missing value Suspension Reason Not Found")

                    # SIM_STATUS
                    # if row['SIM_STATUS'] in ['A','S','V'] and len(row['ACTIVATIONDATE'])==0:
                    #     error_list.append("Missing value ACTIVATIONDATE when SIM_STATUS is 'A' 'S' and 'V'")

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("IMSI", lambda x: x.isnumeric(), "Type Mismatch IMSI"),
                        ("ICCID", lambda x: x.isnumeric(), "Type Mismatch ICCID"),
                        ("MSISDN", lambda x: x.isnumeric(), "Type Mismatch MSISDN"),
                        ("SIM_STATUS", lambda x: check_enum(x, allowed_values=['1','2','3','4','5','A','S','V','R']),
                         "Type Mismatch SIM_STATUS")
                        # ("SIM_STATUS", lambda x: is_alphanumeric(x), "Type Mismatch SIM_STATUS"),
                        # ("SIMPRODUCT_ID", lambda x: x.isnumeric(), "Type Mismatch SIMPRODUCT_ID"),
                        # ("PIN1", lambda x: x.isnumeric(), "Type Mismatch PIN1"),
                        # ("PIN2", lambda x: x.isnumeric(), "Type Mismatch PIN2"),
                        # ("PUK1", lambda x: x.isnumeric(), "Type Mismatch PUK1"),
                    ]
                   
                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)
            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'acct_att_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['CUSTOMER_ID', 'ACTIVATION_STATUS', 'COMPANY_ID', 'CURRENCY',
                                        'CUSTOMER_CATEGORY_STC', 'CONTACT_PPERSON_MOBILE', 'CONTACT_PERSON_EMAIL',
                                        'SEGMENT']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    # Checking for additional condition
                    # if row['CUSTOMER_MANAGED'] == 'UNMANAGED' and len(row['LEAD_PERSON_ID']) == 0:
                    #     error_list.append("Missing value LEAD_PERSON_ID when CUSTOMER_MANAGED is 'UNMANAGED'")

                    if row['CUSTOMER_MANAGED'] == 'MANAGED' and len(row['ACCOUNT_MANAGER_ID']) == 0:
                        error_list.append("Missing value ACCOUNT_MANAGER_ID when CUSTOMER_MANAGED is 'MANAGED'")

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("CUSTOMER_ID", lambda x: x.isnumeric(), "Type Mismatch CUSTOMER_ID"),
                        ("ACTIVATION_STATUS", lambda x: check_enum(x, allowed_values=['Live', 'Test']),
                         "Type Mismatch ACTIVATION_STATUS"),
                        ("COMPANY_ID", lambda x: x.isnumeric(), "Type Mismatch COMPANY_ID"),
                        ("CURRENCY", lambda x: is_alphanumeric(x), "Type Mismatch CURRENCY"),
                        ("CONTACT_PPERSON_MOBILE", lambda x: x.isnumeric(), "Type Mismatch CONTACT_PPERSON_MOBILE"),
                        ("CONTACT_PERSON_EMAIL", lambda x: is_alphanumeric(x), "Type Mismatch CONTACT_PERSON_EMAIL"),
                        ("LEAD_PERSON_ID", lambda x: x.isnumeric(), "Type Mismatch LEAD_PERSON_ID"),
                        ###this is the tempory check 
                        # ("SEGMENT",lambda x: check_enum(x, allowed_values=['IC','NG','NR','NS','RC','SD','CS','ST','ZN','KA','G1','G2','G3','LB','MA','RE','G4']),"Type Mismatch SEGMENT"),
                        ("ACCOUNT_MANAGER_ID", lambda x: x.isnumeric(), "Type Mismatch ACCOUNT_MANAGER_ID")
                        # ("PIN2", lambda x: x.isnumeric(), "Type Mismatch PIN2"),
                        # ("PUK1", lambda x: x.isnumeric(), "Type Mismatch PUK1"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'lead_person_gct':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['userName']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("userName", lambda x: is_alphanumeric(x), "Type Mismatch userName")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'users_details_cdp':
            try:
                duplicate_colums = duplicate_file_name  + "_" + current_time_stamp + ".csv"
                company_duplication_error = os.path.join(column_error_path, duplicate_colums)
                after_len=len(df_address_details_cdp)

                df_address_details_cdp=drop_duplicates_and_save_duplicates(df_address_details_cdp,company_duplication_error ,logger_info,['USER_ID', 'LOGIN'])

                duplicate_len=duplicate_len+(after_len-len(df_address_details_cdp))

                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['USER_ID', 'LOGIN']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("USER_ID", lambda x: x.isnumeric(), "Type Mismatch USER_ID"),
                        ("LOGIN", lambda x: is_alphanumeric(x), "Type Mismatch LOGIN")
                    ]
                    

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'apns_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ID', 'CDP_APN_ID', 'NAME','IS_STATIC','IS_PRIVATE']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]
                    ## Checking for additional condition
                    if row['IS_STATIC'] == '1' and len(row['STARTING_IP']) == 0 and len(row['ENDING_IP']) == 0:
                        error_list.append("Missing value STARTING_IP and ENDING_IP when IS_STATIC is '1'")

                    if row['IS_STATIC'] == '1' and (len(row['SUBNET']) == 0 or len(row['NO_OF_HOSTS']) == 0) :
                        error_list.append("Missing value SUBNET and NO_OF_HOSTS when IS_STATIC is '1'")
                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("ID", lambda x: x.isnumeric(), "Type Mismatch ID"),
                        ("CDP_APN_ID", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'APN_IP_Addressess_cdp':
            try:

                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ID', 'IP_ADDRESS']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("ID", lambda x: x.isnumeric(), "Type Mismatch ID")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),

                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'APN-ip-pools-state-t_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ID', 'FIRST_AVAILABLE_IP']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("ID", lambda x: x.isnumeric(), "Type Mismatch ID")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))


        elif file_name == 'APN_SP_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []
                    # transformation
                    # Trim whitespace and convert SP_ID to integer
                    row["SP_ID"] = row["SP_ID"].strip()
                    row['APN_NAME'] = row['APN_NAME'].strip()
                    required_columns = ['APN_ID','SP_ID']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("SP_ID", lambda x: x.isnumeric(), "Type Mismatch SP_ID")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'SIM_Order_cdp':
            try:
                df_address_details_cdp['SIM_ORDER_CUST_DELVRY_POST_COD'] = df_address_details_cdp['SIM_ORDER_CUST_DELVRY_POST_COD'].apply(lambda x: '00000' if len(x) > 5 else x)
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ID','SIM_QUANTITY','CREATE_BY','BU_ID']#'AWB_NUMBER',AUTO_ACTIVATION,'SIM_ORDER_CATEGORY'
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    if row['AUTO_ACTIVATION'] == '1' and len(row['SERVICE_PROFILE']) == 0:
                        error_list.append("Missing value SERVICE_PROFILE when AUTO_ACTIVATION is '1'")

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("ID", lambda x: x.isnumeric(), "Type Mismatch ID"),
                        ("SIM_RPODUCUT_ID", lambda x: x.isnumeric(), "Type Mismatch SIM_RPODUCUT_ID")
                        # ("SIM_ORDER_CUST_DELVRY_POST_COD", lambda x: x.isnumeric(), "Type Mismatch SIM_ORDER_CUST_DELVRY_POST_COD")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]
                    # print("AMIT")
                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    # print("AMIT")
                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))


            
        elif file_name == 'sim_products_cdp':
            try:
                duplicate_colums = duplicate_file_name  + "_" + current_time_stamp + ".csv"
                company_duplication_error = os.path.join(column_error_path, duplicate_colums)
                after_len=len(df_address_details_cdp)
                df_address_details_cdp=drop_duplicates_and_save_duplicates(df_address_details_cdp,company_duplication_error ,logger_info,['title'])
                duplicate_len=duplicate_len+(after_len-len(df_address_details_cdp))
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['sim product id','title','service type','service sub type 1','service sub type 2','service sub type 3','service sub type 4',
                    'packaging size','can be ordered']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("sim product id", lambda x: x.isnumeric(), "Type Mismatch sim product id")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        
        elif file_name == 'IMSI_Range_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['CRMCUSTOMER_ID','IMSI_START','IMSI_END','ICCID_START','ICCID_END','IMSI_RANGE_TOTAL_SIM_COUNT']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("CRMCUSTOMER_ID", lambda x: x.isnumeric(), "Type Mismatch CRMCUSTOMER_ID")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'Service_Profile_Config_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['CUST_ID','CUSTNAME','BUID','BUNAME','SERVICE_PROFILE_ID','BUNDLE_ID']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("CUST_ID", lambda x: x.isnumeric(), "Type Mismatch CUST_ID"),
                        ("BUID", lambda x: x.isnumeric(), "Type Mismatch BUID"),
                        ("SERVICE_PROFILE_ID", lambda x: x.isnumeric(), "Type Mismatch SERVICE_PROFILE_ID"),
                        ("BUNDLE_ID", lambda x: x.isnumeric(), "Type Mismatch BUNDLE_ID")
                        
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))
        

        elif file_name == 'cost_center_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['CUSTNAME','BUID_EXT','BUNAME','CUSTID_EXT','CCID_EXT','CCNAME']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ('BUID_EXT', lambda x: x.isnumeric(), "Type Mismatch BUID_EXT"),
                        ('CUSTID_EXT', lambda x: x.isnumeric(), "Type Mismatch CUSTID_EXT"),
                        ('CCID_EXT', lambda x: x.isnumeric(), "Type Mismatch CCID_EXT"),
                        ('CUSTNAME', lambda x: is_alphanumeric(x), "Type Mismatch CUSTNAME"),
                        ('BUNAME', lambda x: is_alphanumeric(x), "Type Mismatch BUNAME"),
                        ('CCNAME', lambda x: is_alphanumeric(x), "Type Mismatch CCNAME")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))
        
        elif file_name == 'TriggersDetails':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []
                    
                    required_columns = ['Trigger ID','Name','Trigger','Category','Application Level','Customer ID','Any Service Profile']###'Description',

                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    if len(row['Customer ID']) == 0 and len(row['Business Unit ID']) == 0:
                        error_list.append("Missing value Customer ID and Business Unit ID")

                    if row['Trigger'] == 'Volume threshold' and len(row['Aggregation Level']) ==0:
                        error_list.append("Missing value Aggregation Level when Trigger is Volume Thresold")
                    
                    error_list.extend(f"Missing value {col}" for col in missing_columns)
                    # print('error list : ',error_list)
                    checks = [
                        ("Trigger ID", lambda x: x.isnumeric(), "Type Mismatch Trigger ID"),
                        ("Trigger", lambda x: check_enum(x,allowed_values=['Volume threshold','Time passed since SIM is in Service Profile','Time passed since First Activity',
                        'Session length','Other Attribute Threshold' ,'Inactivity Trigger for Data','IMEI Mismatch','Data Session end','Country or operator change']), "Type of Trigger not matched enum values are incorrect"),
                        ("Category",lambda x: check_enum(x,allowed_values=['Others','SIM Lifecycle','Fraud prevention','Cost control']),"Type of Category not matched enum values are incorrect"),
                        ("Application Level", lambda x: check_enum(x,allowed_values=['All SIMS of Business Unit', 'All SIMS of Cost Center', 'All SIMS of Customer','SIM']),"Type of Application Level not matched enum values are incorrect"),
                        ("Customer ID", lambda x: x.isnumeric(), "Type of Customer ID is not an integer"),
                        ("Business Unit ID", lambda x: x.isnumeric(), "Type of Business Unit ID is not an integer")
                   
                    ]
                    
                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)
                   
                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))


        
        elif file_name == 'zone_product_pricing_load_data':
            # print("AMIT")
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []
                    
                    required_columns = ['ZoneName', 'ProductName', 'ProductType', 'PricingSpecName', 'UOM','Amount', 'price_type', 'CURRENCY_CODE']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]
                   
                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("CURRENCY_CODE", lambda x: is_alphanumeric(x), "Type Mismatch CURRENCY_CODE"),
                        ("ZoneName", lambda x: check_length(x,200), "Type length Mismatch ZoneName"),
                        ("ProductName", lambda x: check_length(x,200), "Type length Mismatch ProductName"),
                        ("PricingSpecName", lambda x: check_length(x,200), "Type length Mismatch PricingSpecName")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        
        elif file_name == 'temp_discount_data':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['Discount_Name','PC_Discount_Type','Discount_Type','Discount_Category','Unit_Of_Measure']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ('Unit_Of_Measure', lambda x: x.isnumeric(), "Type Mismatch Unit_Of_Measure")
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))   


        elif file_name == 'zonegroup_load_data':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ZONE_GROUP_NAME','ZONE_NAME','ZONE_TYPE','Countries','OPCO_NAME']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("ZONE_GROUP_NAME", lambda x: is_alphanumeric(x), "Type Mismatch ZONE_GROUP_NAME"),
                        ("OPCO_NAME", lambda x: is_alphanumeric(x), "Type Mismatch OPCO_NAME"),
                        ("ZONE_NAME", lambda x: check_length(x,100), "Type length Mismatch Zone_Name"),
                        ("ZONE_TYPE", lambda x: check_length(x,100), "Type length Mismatch ZONE_TYPE")
                        
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))



        elif file_name == 'Entitlement_data_load':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['ENTITLEMENT_NAME','ENTITLEMENT_TYPE','ENTITLEMENT_QTY','ENTITLEMENT_UOM','ENTITLEMENT_INTERVAL','IS_PAYG_ENABLED','IS_PAYG_CAPPED','PAYG_CAP','IS_UNLIMITED_QTY']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ('ENTITLEMENT_INTERVAL', lambda x: x.isnumeric(), "Type Mismatch ENTITLEMENT_INTERVAL"),
                        ('IS_PAYG_ENABLED', lambda x: x.isnumeric(), "Type Mismatch IS_PAYG_ENABLED"),
                        #,'IS_PAYG_CAPPED,PAYG_CAP','IS_UNLIMITED_QTY'
                        ('IS_PAYG_CAPPED', lambda x: x.isnumeric(), "Type Mismatch IS_PAYG_CAPPED"),
                        ('IS_UNLIMITED_QTY', lambda x: x.isnumeric(), "Type Mismatch IS_UNLIMITED_QTY"),
                        ('PAYG_CAP', lambda x: x.isnumeric(), "Type Mismatch PAYG_CAP")
                        
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))        



        elif file_name == 'white_listing_cdp':
            try:

                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['POLICY_ID','CUST_ID','CUST_NAME','BU_NAME','HOST_NAME','ADDRESS','TYPE','PORT','PROTOCOL']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ('POLICY_ID', lambda x: x.isnumeric(), "Type Mismatch POLICY_ID"),
                        ('CUST_ID', lambda x: x.isnumeric(), "Type Mismatch CUST_ID"),
                        ('PORT', lambda x: x.isnumeric(), "Type Mismatch PORT"),
                        ('ADDRESS', lambda x: is_alphanumeric(x), "Type Mismatch ADDRESS")
                        
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        elif file_name == 'Discount':
            try:

                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['DISCOUNTLEVEL','BUSINESSUNITID','DISOCUNTEDRATINGELEMENTS','DISCOUNTEDPRODUCTTARIFFNAME']
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ('DISCOUNTPERCENTAGEVALUE', lambda x: x.isnumeric(), "Type Mismatch DISCOUNTPERCENTAGEVALUE"),
                        
                        
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))




        elif file_name == 'customer_details_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['CUSTOMER_ID','CUSTOMER_NAME','CUSTOMER_REFERENCE','BU_ID'] 
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)
                    
                    checks = [
                        ('CUSTOMER_ID', lambda x: x.isnumeric(), "Type Mismatch CUSTOMER_ID"),
                        # ('CUSTOMER_NAME', lambda x: drop_special_character_data(x), "Type Mismatch CUSTOMER_NAME"),
                        ('CUSTOMER_REFERENCE', lambda x: x.isnumeric(), "Type Mismatch CUSTOMER_REFERENCE"),
                        # ('BUNAME', lambda x: drop_special_character_data(x), "Type Mismatch BUNAME"),
                        ('BU_ID', lambda x: x.isnumeric(), "Type Mismatch BU_ID")
                    ]
                    
                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)


                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))
        

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_address_details_cdp.iloc[drop_row_index, :]

        df_partial_error = df_address_details_cdp.iloc[drop_row_index, :]
        df_address_details_cdp = df_address_details_cdp.drop(drop_row_index)

        df_address_details_cdp = df_address_details_cdp.reset_index(drop=True)
        if file_name in['assets_cdp','SIM_Order_cdp','sim_transactions']:
            df_address_details_cdp,error_df=check_account_id_in_column(df_address_details_cdp, bu_list, 'BU_ID')
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is : {file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)
        
        elif file_name=='Service_Profile_Config_cdp':
            df_address_details_cdp,error_df=check_account_id_in_column(df_address_details_cdp, bu_list, 'BUID')
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)

        
        ####for this i have to verify the columns
        elif file_name=='TriggersDetails':
            df_address_details_cdp,error_df=check_account_id_in_column_for_trigger_df(df_address_details_cdp, bu_list, cu_list,opco_list, 'Business Unit ID', 'Customer ID','opcoId',file_name)
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)

        elif file_name == 'users_details_cdp':
            df_address_details_cdp,error_df=check_account_id_in_column_for_trigger_df(df_address_details_cdp, bu_list, cu_list,opco_list,'BU_ID', 'CUSTOMER_ID','OPCO_ID',file_name)
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)

        elif file_name=='white_listing_cdp':
            df_address_details_cdp,error_df=check_account_id_in_column(df_address_details_cdp, bu_list, 'BU_NAME')
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)
        
        elif file_name =='acct_att_cdp':
            df_address_details_cdp,error_df=check_account_id_in_column(df_address_details_cdp,cu_list, 'CUSTOMER_ID')
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)
        
  
        elif file_name=='IMSI_Range_cdp':
            df_address_details_cdp,error_df=check_account_id_in_column(df_address_details_cdp,cu_list, 'CRMCUSTOMER_ID')
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(error_df))
            df_partial_error = pd.concat([df_partial_error, error_df], ignore_index=True)
        elif file_name=='Discount':
            df_address_details_cdp,df_error=process_discount_dataframe(df_address_details_cdp)
            
            df_address_details_cdp,df_error1=check_account_id_in_column(df_address_details_cdp, bu_list, 'BUSINESSUNITID')
            df_partial_error['Reason']=''
            df_partial_error = pd.concat([df_partial_error, df_error,df_error1], ignore_index=True)


        elif file_name=='apns_cdp':
            # df_address_details_cdp.to_csv("csv1.csv",index=False)
            df_address_details_cdp,non_matching_df=process_apns_cdp(df_address_details_cdp,bu_list,'BU_LIST','CUSTOMER_ID',cu_list,logger_info,logger_error)
            print("len_of_matched",len(df_address_details_cdp))
            df_partial_error['Reason']=''
            # error_df.to_csv("hello3.csv",index=False)
            print(f"length_of_that_recods_where_account_id_not_present_in_bu_id file_name is{file_name}",len(non_matching_df))
            df_partial_error = pd.concat([df_partial_error, non_matching_df], ignore_index=True)
            
        
        # delete_before(validation_error_dir,dir_path)
        print('Length of {} records validation Error : {}'.format(file_name,len(df_partial_error)))
        logger_info.info('Length of {} records validation Error : {}'.format(file_name,len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            csv_filename = file_name + '_' + current_time_stamp + '.csv'
            missing_value_errors = list(set(column_error_list))
            print('{} missing errors : {}'.format(file_name,missing_value_errors))
            logger_info.info('{} missing errors : {}'.format(file_name,missing_value_errors))
            type_mismatch_errors = list(set(data_type_mismatch))
            print('{} type mismatch errors : {}'.format(file_name,type_mismatch_errors))
            logger_info.info('{} type mismatch errors : {}'.format(file_name,type_mismatch_errors))
            df_partial_error.to_csv(os.path.join(column_error_path, csv_filename), index=False)

        
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        # insert_into_summary_table(aircontrol_db_configs,'validation_summary' ,logger_info, logger_error,'acct_att_cdp Customer', length_of_original_df, len(df_address_details_cdp), len(df_partial_error),
        #                           end_time)
        append_to_data_value_file(file_name,length_of_original_df,len(df_partial_error),duplicate_len,Reconsilation_file_name)
        df_address_details_cdp.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)
        df_address_details_cdp.to_csv(f'{input_file_path}/{file_name}.csv',index=False)
        # return df_address_details_cdp

    except Exception as e:
        logger_error.error("error processing {} customer data :{}".format(file_name,e))
        raise ValueError("error processing {} customer data".format(file_name))









def partial_validation(input_feed_file_path,column_error_path, duplicate_file_name, logger_info, logger_error,file_name):
    try:
        drop_row_index = []
       
        start_time = time.time()
        df_address_details_cdp = pd.read_csv(f"{input_feed_file_path}/{file_name}.csv",keep_default_na=False,skipinitialspace=True,dtype=str)
        length_of_original_df = len(df_address_details_cdp)
        
        print("################ Processing {} File #######################".format(file_name))
        
        logger_info.info("################ Processing {} File #######################".format(file_name))
        print("Length of original File : ",length_of_original_df)
        logger_info.info("Length of original File {}".format(length_of_original_df))
        duplicate_error_ec_filename = duplicate_file_name + "_" + current_time_stamp + ".csv"
        company_duplication_error_path = os.path.join(column_error_path, duplicate_error_ec_filename)
        duplicates = df_address_details_cdp[df_address_details_cdp.duplicated()]
        print('Length of Duplicate records : ', len(duplicates))
        duplicate_len=len(duplicates)
        logger_info.info('Length of Duplicate records : {}'.format(len(duplicates)))
        if not duplicates.empty:
            duplicates.to_csv(company_duplication_error_path, index=False)

        df_address_details_cdp = df_address_details_cdp.drop_duplicates()
        
        # df_address_details_cdp = drop_duplicates_and_save_duplicates(df_address_details_cdp, company_duplication_error_path,logger_info,'CUSTOMER_ID')
        # print('\n duplicate data frame', df_address_details_cdp)
        for column in df_address_details_cdp.columns:
            df_address_details_cdp[column] = df_address_details_cdp[column].apply(lambda x: str(x).strip())

        df_address_details_cdp = df_address_details_cdp.astype(str)

        df_address_details_cdp["Missing_Columns"] = ''
        df_address_details_cdp["Type_Mismatch"] = ''

        column_error_list = []
        data_type_mismatch = []
        if file_name == 'Billing_Account_cdp':
            try:
                for index, row in df_address_details_cdp.iterrows():
                    error_list = []
                    data_type_error_list = []

                    required_columns = ['BILLING_ACCOUNT','CUSTOMER_REFERENCE']   #,'BU_SIM_PRODUCT_IDS'
                    missing_columns = [col for col in required_columns if len(str(row[col])) == 0]

                    error_list.extend(f"Missing value {col}" for col in missing_columns)

                    checks = [
                        ("BILLING_ACCOUNT", lambda x: x.isnumeric(), "Type Mismatch BILLING_ACCOUNT")
                        # ("IP_ADDRESS", lambda x: is_alphanumeric(x), "Type Mismatch CDP_APN_ID"),
                    ]

                    for col, check_func, error_message in checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            data_type_error_list.append(error_message)

                    if error_list or data_type_error_list:
                        drop_row_index.append(index)

                    row["Missing_Columns"] = ', '.join(error_list)
                    row["Type_Mismatch"] = ', '.join(data_type_error_list)
                    column_error_list.extend(error_list)
                    data_type_mismatch.extend(data_type_error_list)

            except Exception as e:
                logger_error.error("Error during validation :{}".format(e))

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_address_details_cdp.iloc[drop_row_index, :]

        df_partial_error = df_address_details_cdp.iloc[drop_row_index, :]

        # delete_before(validation_error_dir,dir_path)
        print('Length of {} records validation Error : {}'.format(file_name,len(df_partial_error)))
        logger_info.info('Length of {} records validation Error : {}'.format(file_name,len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            csv_filename = file_name + '_' + current_time_stamp + '.csv'
            missing_value_errors = list(set(column_error_list))
            print('{} missing errors : {}'.format(file_name,missing_value_errors))
            logger_info.info('{} missing errors : {}'.format(file_name,missing_value_errors))
            type_mismatch_errors = list(set(data_type_mismatch))
            print('{} type mismatch errors : {}'.format(file_name,type_mismatch_errors))
            logger_info.info('{} type mismatch errors : {}'.format(file_name,type_mismatch_errors))
            df_partial_error.to_csv(os.path.join(column_error_path, csv_filename), index=False)

        df_address_details_cdp = df_address_details_cdp.drop(drop_row_index)

        df_address_details_cdp = df_address_details_cdp.reset_index(drop=True)

        ############### Insert into db ###############################
        # insert_batches_df_into_mysql(df_address_details_cdp, aircontrol_db_configs, 'ec_success', logger_info, logger_error)
        # insert_batches_df_into_mysql(df_partial_error, aircontrol_db_configs, 'ec_failure', logger_info, logger_error)
        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        # insert_into_summary_table(aircontrol_db_configs,'validation_summary' ,logger_info, logger_error,'acct_att_cdp Customer', length_of_original_df, len(df_address_details_cdp), len(df_partial_error),
        #                           end_time)
        append_to_data_value_file(file_name,length_of_original_df,len(df_partial_error),duplicate_len,Reconsilation_file_name)

        df_address_details_cdp.drop(columns=['Missing_Columns', 'Type_Mismatch'], inplace=True)
        df_address_details_cdp.to_csv(f'{input_file_path}/{file_name}.csv',index=False)
        bu_id_list = df_address_details_cdp['BUID'].tolist()
        customer_id_list=df_address_details_cdp['CUSTOMER_ID'].tolist()
        opco_id_list = df_address_details_cdp['BU_OWNING_OPCO'].tolist()
        return bu_id_list,customer_id_list,opco_id_list
    except Exception as e:
        logger_error.error("error processing {} customer data :{}".format(file_name,e))
        raise ValueError("error processing {} customer data".format(file_name))