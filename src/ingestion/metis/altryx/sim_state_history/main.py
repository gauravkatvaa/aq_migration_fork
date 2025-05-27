import os
import logging
import time
from sqlalchemy.exc import IntegrityError
import paramiko
import pandas as pd
import datetime as dt
from sqlalchemy import create_engine
from config import *
from datetime import datetime
import json
from sql_manager import fetch_username_email
import re
import shutil

logging.basicConfig(filename='sim_state_history.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s: %(message)s')

TABLE_NAME = 'assets'

# Ask the user whether to perform only validation
validation_only_input = input("Perform only validation? Enter True or False: ").strip().lower()
validation_only = validation_only_input == 'true'

COLUMNS_TO_FETCH = ['imsi', 'ENT_ACCOUNTID']

remote_path = local_csv_file_path["csv_file_path"]

csv_history = local_csv_file_path["csv_file_path_history"]
success_path = local_csv_file_path["success_csv_file_path"]
error_path = local_csv_file_path["error_csv_file_path"]

history_directory = local_csv_file_path["csv_file_path_history"]
os.makedirs(history_directory, exist_ok=True)

local_csv_directory = local_csv_file_path["csv_file_path"]
csv_folder = 'local_csv_files'
os.makedirs(csv_folder, exist_ok=True)
directory = local_csv_file_path["error_csv_file_path"]
success_directory = local_csv_file_path["success_csv_file_path"]
os.makedirs(directory, exist_ok=True)
os.makedirs(success_directory, exist_ok=True)

directories_to_check = [csv_folder, success_directory, directory]

for directory_path in directories_to_check:
    if os.path.exists(directory_path) and os.path.isdir(directory_path):
        files = os.listdir(directory_path)
        for file in files:
            if file.endswith('.csv'):
                file_path = os.path.join(directory_path, file)
                try:
                    os.remove(file_path)
                    print(f"Removed {file_path}")
                except Exception as e:
                    print(f"Error removing {file_path}: {e}")
    else:
        print(f"The directory {directory_path} does not exist or is not a directory.")


# def connect_to_server(sftp_host, sftp_port, sftp_user, sftp_password):
#     try:
#         ssh_clients = paramiko.SSHClient()
#         ssh_clients.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#         ssh_clients.connect(sftp_host, port=sftp_port, username=sftp_user, password=sftp_password)
#         sftp_conn = ssh_clients.open_sftp()
#         return sftp_conn, ssh_clients
#     except Exception as e:
#         error_msg = f"Error connecting to server: {str(e)}"
#         logging.error(error_msg)
#         print(error_msg)
#         return None, None
#
#
# def fetch_csv_files(sftp_connection, remote_file_path, local_file_path, remote_archive_path):
#     try:
#         remote_files = sftp_connection.listdir(remote_file_path)
#         csv_files = [file for file in remote_files if file.endswith('.csv')]
#
#         if not csv_files:
#             logging.info("No CSV files found in the remote directory.")
#             print("No CSV files found in the remote directory.")
#             return
#
#         for csv_file in csv_files:
#             remote_file_paths = os.path.join(remote_file_path, csv_file)
#             local_file_paths = os.path.join(local_file_path, csv_file)
#
#             timestamp = dt.datetime.now().strftime("%Y%m%d%H%M%S")
#             remote_archive_file_name = f"{timestamp}_{csv_file}"
#             remote_archive_file_paths = os.path.join(remote_archive_path, remote_archive_file_name)
#             # remote_archive_file_paths = os.path.join(remote_archive_path, csv_file)
#
#             # Download the file
#             sftp_connection.get(remote_file_paths, local_file_paths)
#             logging.info(f"Downloaded {csv_file} from {remote_file_paths} to {local_file_paths}")
#
#             # Move the file to the archive location on the remote server
#             sftp_connection.rename(remote_file_paths, remote_archive_file_paths)
#             logging.info(f"Moved {csv_file} to {remote_archive_file_paths}")
#
#     except Exception as e:
#         error_msg = f"Error fetching CSV files: {str(e)}"
#         logging.error(error_msg)
#         print(error_msg)


# sftp, ssh_client = connect_to_server(host, port, user, password)
#
# if sftp:
#     try:
#         fetch_csv_files(sftp, remote_path, csv_folder, csv_history)
#         sftp.close()
#         ssh_client.close()
#     except Exception as e:
#         error_message = f"Error during CSV file retrieval: {str(e)}"
#         logging.error(error_message)
#         print(error_message)
# else:
#     logging.error("Could not establish a connection to the remote server.")

def fetch_assets_id(imsi_list, assets_engine):
    """
    Fetch assets_id for a list of IMSIs from the assets table.
    """
    imsi_str = ','.join(f"'{imsi}'" for imsi in imsi_list)  # Ensure IMSIs are correctly formatted for SQL query
    query = f"SELECT imsi, id as assets_id FROM assets WHERE imsi IN ({imsi_str})"
    try:
        data_ = pd.read_sql(query, assets_engine)
        return data_
    except Exception as e:
        logging.error(f"Error fetching assets_id: {e}")
        return pd.DataFrame()


table_name = 'sim_event_log'
engine = create_engine('mysql+mysqlconnector://', connect_args=meta_db_config)

columns_to_insert = ['CREATE_DATE', 'USERNAME', 'ACCOUNT_ID', 'MESSAGE', 'OLD_VALUE', 'NEW_VALUE', 'EVENTID',
                     'RESULT', 'EXTENDED_LOG_ID'
                     ]

columns_to_insert_in_extended = ['COMMENTS', 'CREATE_DATE', 'ATTRIBUTE', 'ASSET_ID']


def create_json(row):
    if row == 'SUS':
        return {
            "Status": "SUCCESSFUL",
            "New Value": "Suspended",
            "Old Value": "Activated"
        }
    elif row == 'RES':
        return {
            "Status": "SUCCESSFUL",
            "New Value": "Activated",
            "Old Value": "Suspended"
        }


# Separate DataFrames for duplicate IMSIs, validation errors, and IMSIs not in assets
duplicate_imsis = set()  # Use a set to keep track of duplicate IMSIs
validation_errors = []
imsis_not_exist_in_assets = []


def fetch_data_from_db(imsi_list):
    imsi_str = ','.join(map(str, imsi_list))
    query = f"SELECT {', '.join(COLUMNS_TO_FETCH)} FROM {TABLE_NAME} WHERE imsi IN ({imsi_str})"

    try:
        # Fetch data from the database
        data_ = pd.read_sql(query, engine)
        return data_

    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return pd.DataFrame()

    finally:
        # Close the database connection
        engine.dispose()


# Function to check if a string is a valid email address
# def is_valid_email(email):
#     email_regex = r'^[\w\.-]+@[\w\.-]+\.\w+$'
#     return re.match(email_regex, email) is not None
def is_valid_email(email):
    email_regex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(email_regex, email) is not None


# Function to check if a string is a valid datetime
def is_valid_datetime(date_str):
    try:
        pd.to_datetime(date_str, errors='raise')
        return True
    except (ValueError, pd.errors.OutOfBoundsDatetime):
        return False


def add_reason(row):
    reasons = []
    if not pd.notna(row['imsi']):
        reasons.append('imsi is missing')
    elif not row['imsi'].isdigit():
        reasons.append('imsi is not numeric')
    # if not pd.notna(row['msisdn']):
    #     reasons.append('msisdn is missing')
    # elif not row['msisdn'].isdigit():
    #     reasons.append('msisdn is not numeric')
    if not pd.notna(row['email']):
        reasons.append('email is missing')
    if not pd.notna(row['job_type']):
        reasons.append('job_type is missing')
    if not pd.notna(row['ts_req']):
        reasons.append('ts_req is missing')
    # if not is_valid_email(row['email']):
    #     reasons.append('email format not matched')
    is_valid = is_valid_email(row['email'])
    if not is_valid:
        reasons.append('email format not matched')
        print(f"Invalid email: {row['email']}")  # Print the invalid email address for debugging

    if not is_valid_datetime(row['ts_req']):
        reasons.append('datetime format not matched')

    if reasons:
        return ', '.join(reasons)
    else:
        return 'Ok'


local_files = os.listdir(local_csv_directory)
csv_files = [file for file in local_files if file.endswith('.csv')]


def fetch_ids_for_imsi(imsi_df):
    # Prepare a list to hold the results
    results = []

    # Iterate over the IMEI numbers in the given DataFrame
    for imsi in imsi_df['imsi']:
        # Execute SQL query to find the corresponding ID from the assets table
        query = f"SELECT id FROM assets WHERE imsi = '{imsi}'"
        result = pd.read_sql_query(query, engine)

        # Only add to results if the query returned a result
        if not result.empty:
            # Assuming 'id' is the column name in your 'assets' table with the IDs
            asset_id = result.iloc[0]['id']
            results.append({'imsi': imsi, 'ASSET_ID': asset_id})

    # Convert the results list to a DataFrame
    results_df = pd.DataFrame(results)

    # If you prefer to exclude rows with None IDs, you could filter them out. However, in this update,
    # such rows are not added to the results in the first place, making this step unnecessary.

    return results_df


def fetch_ids_and_log_for_imsi(imsi_df):
    results = []
    current_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    for index, row in imsi_df.iterrows():  # Iterate over rows to access other column values
        imsi = row['imsi']
        ts_req = row['ts_req']  # Access the ts_req value for the current row
        email = row['email']
        job = row['job_type']
        # Find the corresponding ID in the assets table
        query_assets = f"SELECT id, ENT_ACCOUNTID from assets WHERE imsi = '{imsi}'"
        result_assets = pd.read_sql_query(query_assets, engine)

        if not result_assets.empty:
            asset_id = result_assets.iloc[0]['id']
            ent_accountid = result_assets.iloc[0]['ENT_ACCOUNTID']

            # Now, find the corresponding extended_log_id based on asset_id
            query_extended_log = f"SELECT id FROM extended_audit_log WHERE asset_id = '{asset_id}' ORDER BY id DESC LIMIT 1"
            result_extended_log = pd.read_sql_query(query_extended_log, engine)

            if not result_extended_log.empty:
                extended_log_id = result_extended_log.iloc[0]['id']

                # Include the ts_req value under the new column name 'timestamp'
                results.append({
                    'imsi': imsi,
                    'id': asset_id,
                    'EXTENDED_LOG_ID': extended_log_id,  # Include the extended_log_id
                    'ENT_ACCOUNTID': ent_accountid,
                    'CREATE_DATE': ts_req,  # Add the ts_req value as 'timestamp'
                    'job': job,
                    'email': email
                })

    results_df = pd.DataFrame(results)
    return results_df


def insert_with_fallback(df, table_name, engine, error_directory):
    try:
        # Attempt bulk insert
        df.to_sql(table_name, engine, if_exists='append', index=False)
    except IntegrityError as e:
        # Log the bulk insert error
        logging.error(f"Bulk insert failed: {e}. Attempting row-by-row insert.")

        # DataFrame to collect rows causing IntegrityError
        error_rows = pd.DataFrame()

        # Attempt row-by-row insert
        for index, row in df.iterrows():
            try:
                engine.execute(
                    f"INSERT INTO {table_name} ({', '.join(row.index)}) VALUES ({', '.join(['%s'] * len(row))})",
                    tuple(row)
                )
            except IntegrityError as e:
                logging.error(f"Error inserting row {index}: {str(e)}")
                error_row = row.to_dict()
                error_row['reason'] = 'Duplicate entry of Create Date'
                error_rows = error_rows.append(error_row, ignore_index=True)

        # Append error_rows to application_errors.csv if there are any
        if not error_rows.empty:
            csv_file_path = os.path.join(error_directory, f'{original_filename}_duplicates_errors.csv')
            file_exists = os.path.isfile(csv_file_path)
            with open(csv_file_path, 'a', newline='', encoding='utf-8') as f:
                error_rows.to_csv(f, index=False, header=not file_exists)
    except Exception as e:
        # Log any other exception that's not an IntegrityError
        logging.error(f"Unexpected error during insert: {e}")


for csv_file in csv_files:
    csv_file_path = os.path.join(local_csv_directory, csv_file)
    original_filename = os.path.splitext(csv_file)[0]

    dtypes = {
        'imsi': str,
        'msisdn': str,
        'imei_lock': str,
        'email': str,
        'job_type': str
    }

    df = pd.read_csv(csv_file_path, dtype=dtypes)

    df['email'] = df['email'].str.strip()
    df['reason'] = df.apply(add_reason, axis=1)

    print("Main df : \n", df)

    error_df = df[df['reason'] != 'Ok']
    print("validation error rows : \n", error_df)

    # validation_errors_file_path = os.path.join(directory, f'{original_filename}_validation_errors.csv')
    # error_df.to_csv(validation_errors_file_path, index=False)

    df = df[df['reason'] == 'Ok']
    print('Dataframe after cleaning : \n', df)
    print(df)

    # Save the validation error rows before moving the original file to history
    if not error_df.empty:
        validation_errors_file_path = os.path.join(directory, f'{original_filename}_validation_errors.csv')
        csv_file_name1 = f'{original_filename}_validation_errors.csv'
        error_df.to_csv(validation_errors_file_path, index=False)
        error_df.to_csv(os.path.join(error_directory, csv_file_name1), index=False)
    # Now move the original CSV file to the history folder
    history_file_path = os.path.join(history_directory, csv_file)
    shutil.move(csv_file_path, history_file_path)

    df['sim_type'] = 3
    df['event'] = 'STATECHANGE'
    df['start_time'] = df['ts_req']
    df['triggered_user_type'] = 1
    df['triggered_by'] = df['email']
    df['completion_time'] = df['ts_req']
    df['extra_metadata'] = df['job_type'].apply(create_json)

    print(df.columns)

    imsis_to_check = df['imsi'].tolist()
    assets_data = fetch_data_from_db(imsis_to_check)

    result_dfs = fetch_ids_for_imsi(df)
    current_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print("IMSI,ASSETSID", result_dfs)
    result_dfs['CREATE_DATE'] = current_datetime
    result_dfs['COMMENTS'] = 'SIM_ALIAS'
    result_dfs['ATTRIBUTE'] = 'DEVICE_ID'
    # result_dfs.to_csv('srvasers.csv', index=False)
    imsis_not_exist_df = pd.DataFrame()
    missing_imsis = set(imsis_to_check) - set(assets_data['imsi'])
    if missing_imsis:
        imsis_not_exist_in_assets.extend(df[df['imsi'].isin(missing_imsis)].to_dict(orient='records'))
        df = df[~df['imsi'].isin(missing_imsis)]

    # Save the cleaned DataFrame back to the main CSV file
    df.to_csv(csv_file_path, index=False)
    print(df, "\n", df.columns)
    result_df = df.merge(assets_data[['imsi', 'ENT_ACCOUNTID']], on='imsi', how='left')

    current_datetime = datetime.now().replace(microsecond=0)
    result_df['create_date'] = current_datetime
    result_df.rename(columns={'ENT_ACCOUNTID': 'account_id'}, inplace=True)
    result_df['extra_metadata'] = result_df['extra_metadata'].apply(lambda x: json.dumps(x))

    # audit_log_df['ACCOUNT_ID'] = df.merge(assets_data[['imsi', 'ENT_ACCOUNTID']], on='imsi', how='left')

    # result_dfs = result_dfs[columns_to_insert_in_extended]

    if validation_only != True:

        # Check if 'ASSET_ID' is in result_dfs before proceeding
        if 'ASSET_ID' in result_dfs.columns:
            # result_dfs.to_csv('srvassets.csv', index=False)
            print(result_dfs.columns)
            result_dfs = result_dfs[columns_to_insert_in_extended]
            result_dfs.to_sql('extended_audit_log', engine, if_exists='append', index=False)

            # Continue with the rest of your logic that depends on 'ASSET_ID'
        else:
            # Handle the case where 'ASSET_ID' is not present.
            print("No 'ASSET_ID' found in result_dfs. Skipping operations that require this column.")
            # This could involve logging a warning, skipping certain operations, or taking corrective actions.
            logging.warning("No 'ASSET_ID' found in result_dfs. Skipping operations that require this column.")
            exit(0)

        time.sleep(5)
        audit_log_df = fetch_ids_and_log_for_imsi(df)
        audit_log_df['NEW_VALUE'] = audit_log_df['job'].apply(lambda x: 'Activated' if x == 'RES' else 'Suspended')
        audit_log_df['OLD_VALUE'] = audit_log_df['job'].apply(lambda x: 'Suspended' if x == 'SUS' else 'Activated')
        audit_log_df['RESULT'] = 'SUCCESSFUL'
        audit_log_df['EVENTID'] = 'Edit'
        audit_log_df['MESSAGE'] = audit_log_df.apply(lambda x: f"State Change for IMSI : {x['imsi']}", axis=1)
        audit_log_df['USERNAME'] = audit_log_df['email']
        audit_log_df['CREATE_DATE'] = pd.to_datetime(audit_log_df['CREATE_DATE'], errors='coerce')
        # audit_log_df['CREATE_DATE'] = audit_log_df['CREATE_DATE']
        audit_log_df['ACCOUNT_ID'] = audit_log_df['ENT_ACCOUNTID']
        # audit_log_df.to_csv('assets.csv', index=False)
        audit_log_df = audit_log_df[columns_to_insert]
        # audit_log_df.to_sql('auditlog', engine, if_exists='append', index=False)
        insert_with_fallback(audit_log_df, 'auditlog', engine, directory)
        rows_count = len(result_df)

        logging.info(f"{rows_count} rows inserted successfully ")
        success_file_path = os.path.join(success_directory, f'{original_filename}_successful_updates.csv')
        # result_df.to_csv(success_file_path, index=False, mode='a',
        #                  header=not os.path.exists(success_directory))
        result_df.to_csv(success_file_path, index=False, header=True)

        if imsis_not_exist_in_assets:
            print("Unmatched rows :\n")
            imsis_not_exist_df = pd.DataFrame(imsis_not_exist_in_assets)
            imsis_not_exist_df['reason'] = 'IMSI not Match in Assets Table'
            print(imsis_not_exist_df)
            print("Rows Do not match into Assets table")

        csv_file_name = f'{original_filename}_application_error.csv'
        csv_file_path = os.path.join(directory, csv_file_name)
        application_error = imsis_not_exist_df
        columns_to_keep = ['imsi', 'msisdn', 'email', 'job_type', 'ts_req', 'reason']
        application_error = application_error[columns_to_keep]
        application_error.to_csv(csv_file_path, index=False)
        application_error.to_csv(os.path.join(error_directory, csv_file_name), index=False)
    else:
        print("Validation Done")

directories_to_check = [local_csv_directory]

for directory_path in directories_to_check:

    if os.path.exists(directory_path) and os.path.isdir(directory_path):
        files = os.listdir(directory_path)
        for file in files:
            if file.endswith('.csv'):
                file_path = os.path.join(directory_path, file)
                try:
                    os.remove(file_path)
                    print(f"Removed {file_path}")
                except Exception as e:
                    print(f"Error removing {file_path}: {e}")
    else:
        print(f"The directory {directory_path} does not exist or is not a directory.")

