"""
Created on 6-Dec-2021
@author: sorav.parmar@airlinq.com

Script to inserting the data in cdr_data_details_daily table and run the stored procedures
 on basis of weekly and monthly

"""

# import the required modules
import os
import logging
import time
import warnings
from pandas.core.common import SettingWithCopyWarning
from sqlalchemy.orm import sessionmaker
import paramiko
import pandas as pd
from sqlalchemy import create_engine
from config import *
from datetime import datetime
import datetime as dt
from natsort import natsorted
import re

# Initialize logger
logging.basicConfig(filename='sim_history_usage.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s: %(message)s')

success_path = csv_file_path["success_csv_file_path"]
error_path = csv_file_path["error_csv_file_path"]

csv_folder = 'local_csv_files'
os.makedirs(csv_folder, exist_ok=True)
directory = 'errors'
success_directory = 'success'
batches_directory = 'batches_csv_files'
os.makedirs(directory, exist_ok=True)
os.makedirs(success_directory, exist_ok=True)
os.makedirs(batches_directory, exist_ok=True)

directories_to_check = [csv_folder, success_directory, batches_directory, directory]

# Remove the old files , if present
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

# sftp server configuration
host = sftp_server_configs["HOST"]
user = sftp_server_configs["USERNAME"]
password = sftp_server_configs["PASSWORD"]
port = sftp_server_configs["PORT"]
remote_path = csv_file_path["csv_file_path"]

csv_history = csv_file_path["csv_file_path_history"]


def connect_to_server(sftp_host, sftp_port, sftp_user, sftp_password):
    """

    :param sftp_host: hostname of the server
    :param sftp_port: port
    :param sftp_user: username
    :param sftp_password: password
    :return: sftp connection
    """
    try:
        ssh_clients = paramiko.SSHClient()
        ssh_clients.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_clients.connect(sftp_host, port=sftp_port, username=sftp_user, password=sftp_password)
        sftp_conn = ssh_clients.open_sftp()
        return sftp_conn, ssh_clients
    except Exception as e:
        error_msg = f"Error connecting to server: {str(e)}"
        logging.error(error_msg)
        print(error_msg)
        return None, None


def fetch_csv_files(sftp_connection, remote_file_path, local_file_path, remote_archive_path):
    """

    :param sftp_connection: sftp connection
    :param remote_file_path: remote csv files path
    :param local_file_path: local csv file path
    :param remote_archive_path: remote archive path
    :return: csv files
    """
    try:
        remote_files = sftp_connection.listdir(remote_file_path)
        csv_files = [file for file in remote_files if file.endswith('.csv')]

        if not csv_files:
            logging.info("No CSV files found in the remote directory.")
            print("No CSV files found in the remote directory.")
            return

        for csv_file in csv_files:
            remote_file_paths = os.path.join(remote_file_path, csv_file)
            local_file_paths = os.path.join(local_file_path, csv_file)
            timestamp = dt.datetime.now().strftime("%Y%m%d%H%M%S")
            remote_archive_file_name = f"{timestamp}_{csv_file}"
            remote_archive_file_paths = os.path.join(remote_archive_path, remote_archive_file_name)

            # remote_archive_file_paths = os.path.join(remote_archive_path, csv_file)

            # Download the file
            sftp_connection.get(remote_file_paths, local_file_paths)
            logging.info(f"Downloaded {csv_file} from {remote_file_paths} to {local_file_paths}")

            # Move the file to the archive location on the remote server
            sftp_connection.rename(remote_file_paths, remote_archive_file_paths)
            logging.info(f"Moved {csv_file} to {remote_archive_file_paths}")

    except Exception as e:
        error_msg = f"Error fetching CSV files: {str(e)}"
        logging.error(error_msg)
        print(error_msg)


sftp, ssh_client = connect_to_server(host, port, user, password)

if sftp:
    try:
    	# Fetch csv files from the remote server and put into history
        fetch_csv_files(sftp, remote_path, csv_folder, csv_history)
        sftp.close()
        ssh_client.close()
    except Exception as e:
        error_message = f"Error during CSV file retrieval: {str(e)}"
        logging.error(error_message)
        print(error_message)
else:
    logging.error("Could not establish a connection to the remote server.")

# Separate DataFrames for duplicate IMSIs, validation errors, and IMSIs not in assets
duplicate_imsis = set()
validation_errors = []

columns_to_insert = ['recordType', 'servedImsi', 'servedImeiSV', 'chargingId',
                     'apnId', 'servingNodePlmnId', 'startTime', 'stopTime',
                     'downBytes', 'upBytes', 'totalBytes', 'totalBytesInKb',
                     'sessioncount', 'CREATION_TIME', 'CREATE_DATE',
                     ]


def is_valid_datetime(date_str):
    """

    :param date_str:
    :return: Datetime is valid or not
    """
    try:
        pd.to_datetime(date_str, errors='raise')
        return True
    except (ValueError, pd.errors.OutOfBoundsDatetime):
        return False


# Function to extract the date from the CSV file name
def extract_date(filename):
    match = re.search(r'\d{8}', filename)
    if match:
        return match.group(0)
    return None


def add_reason(row):
    """

    :param row:
    :return: reason if any validation errors
    """
    reasons = []
    if not pd.notna(row['IMSI']):
        reasons.append('imsi is missing')
    elif not row['IMSI'].isdigit():
        reasons.append('imsi is not numeric')
    if not pd.notna(row['MSISDN']):
        reasons.append('msisdn is missing')
    elif not row['MSISDN'].isdigit():
        reasons.append('msisdn is not numeric')
    if not pd.notna(row['RG']):
        reasons.append('rating_group is missing')
    if not pd.notna(row['Up_Usage_Volume_Bytes']):
        reasons.append('up_volume_bytes is missing')
    if not pd.notna(row['Down_Usage_Volume_Bytes']):
        reasons.append('down_volume_bytes is missing')
    if not pd.notna(row['DATE']):
        reasons.append('ts_date is missing')
    if not is_valid_datetime(row['DATE']):
        reasons.append('ts_date datetime format not matched')

    if reasons:
        return ', '.join(reasons)
    else:
        return 'Ok'


duplicate_imsis_df = pd.DataFrame()
filtered_df = pd.DataFrame()

for filename in os.listdir(csv_folder):
    if filename.endswith('.csv'):
        csv_path = os.path.join(csv_folder, filename)
        original_filename = os.path.splitext(filename)[0]

        dtypes = {
            'IMSI': str,
            'MSISDN': str
        }

        df = pd.read_csv(csv_path, dtype=str)

        print(df)
        df['reason'] = df.apply(add_reason, axis=1)

        print("Main df : \n", df)

        error_df = df[df['reason'] != 'Ok']
        print("validation error rows : \n", error_df)
        validation_errors_file_path = os.path.join(directory, f'{original_filename}_validation_errors.csv')
        error_df.to_csv(validation_errors_file_path, index=False)
        df = df[df['reason'] == 'Ok']

        df['DATE'] = pd.to_datetime(df['DATE'])
        # put the data in validation error if rating group is other than 0
        filtered_df = df[df['RG'] != '0']
        indices_to_remove = filtered_df.index

        df.drop(indices_to_remove, inplace=True)
        print("Final DF : ", df, df.count())
        # filtered_df.loc[:, 'reason'] = 'Rating Group is Non - Zeros'
        # Suppress the SettingWithCopyWarning
        with warnings.catch_warnings():
            warnings.simplefilter("ignore", category=SettingWithCopyWarning)

            filtered_df.loc[:, 'reason'] = 'Rating Group is Non - Zeros'

        print("Rating Group is Non - Zeros : ", filtered_df)
        # filtered_df.to_csv('filtered_data.csv', index=False)
        # application_errors_file_path = os.path.join(directory, f'{original_filename}_application_errors.csv')

        # filtered_df.to_csv(application_errors_file_path, index=False)
        # df.to_csv('final_data.csv', index=False)

        duplicate_imsis = []

        duplicate_imsis.extend(df[df.duplicated(['IMSI', 'MSISDN', 'DATE'], keep='last')].to_dict(orient='records'))

        # Save the duplicate rows from the main DataFrame to a new CSV file
        if duplicate_imsis:
            duplicate_imsis_df = pd.DataFrame(duplicate_imsis)
            duplicate_imsis_df['reason'] = 'Duplicate IMSI / MSISDN / DATE Pair in CSV file'
            # print(duplicate_imsis_df)
            # duplicate_imsis_df.to_csv('duplicate_imsis.csv', index=False)
            print("Duplicate IMSIs : ", duplicate_imsis_df)

        df.to_csv(csv_path, index=False)

        df['recordType'] = 4
        df['servingNodePlmnId'] = 'MCC - 502 | MNC - 012'
        df['DATE'] = pd.to_datetime(df['DATE'])
        df['servedImsi'] = df['IMSI']
        df['startTime'] = pd.to_datetime(df['DATE'], format='%m/%d/%Y %H:%M:%S').dt.strftime('%Y-%m-%d 12:00:00')
        df['stopTime'] = pd.to_datetime(df['DATE'], format='%m/%d/%Y %H:%M:%S').dt.strftime('%Y-%m-%d 12:00:00')

        df['downBytes'] = pd.to_numeric(df['Down_Usage_Volume_Bytes'], errors='coerce')
        df['upBytes'] = pd.to_numeric(df['Up_Usage_Volume_Bytes'], errors='coerce')

        df['totalBytes'] = df['downBytes'] + df['upBytes']
        df['totalBytes'] = df['totalBytes'].round().astype(int)

        df['totalBytesInKb'] = (df['totalBytes'] / 1024).astype(int)

        df['sessioncount'] = 1
        df['CREATION_TIME'] = datetime.now().replace(microsecond=0)
        df['CREATE_DATE'] = datetime.now().replace(microsecond=0)
        df['servedImeiSV'] = ''
        df['chargingId'] = ''
        df['apnId'] = ''

        print(df, "\n", df.columns)
        # df.to_csv('srv.csv', index=False)
        config_batch_size = batch_size["batch_size"]

        total_batches = len(df) // config_batch_size + (len(df) % config_batch_size > 0)

        for batch_number in range(1, total_batches + 1):
            start_idx = (batch_number - 1) * config_batch_size
            end_idx = start_idx + config_batch_size
            batch_df = df.iloc[start_idx:end_idx]

            csv_filename = os.path.join(batches_directory, f'{original_filename}_{batch_number}.csv')

            batch_df.to_csv(csv_filename, index=False)

            print(f'Saved {len(batch_df)} records to {csv_filename}')

        csv_file_name = f'{original_filename}_application_error.csv'
        csv_path = os.path.join(directory, csv_file_name)

        if not duplicate_imsis_df.empty or not filtered_df.empty:
            application_error = pd.concat([duplicate_imsis_df, filtered_df])
            application_error.to_csv(csv_path, index=False)
        else:
            application_error = None

local_files = os.listdir(csv_folder)
csv_files = [file for file in local_files if file.endswith('.csv')]
csv_files = natsorted(csv_files)
for csv_file in csv_files:
    csv_file_path = os.path.join(csv_folder, csv_file)
    os.remove(csv_file_path)

# Initialize counters for week and month
week_counter = 0
month_counter = 0
prev_date = None
weekly_procedure_sql = "call maxis_dev_cdr.gcontrol_cdr_data_aggregation_weekly();"
monthly_procedure_sql = "call maxis_dev_cdr.gcontrol_cdr_data_aggregation_monthly();"

if validation_only != "Yes":
    engine = create_engine('mysql+mysqlconnector://', connect_args=meta_db_config)
    conn = engine.connect()
    print("Connect created to Mysql Successfully")

    for batch_csv_file in os.listdir(batches_directory):
        if batch_csv_file.endswith('.csv'):
            df = pd.read_csv(os.path.join(batches_directory, batch_csv_file))
            # Extract the date from the file name
            date_str = extract_date(batch_csv_file)
            if date_str:
                table_name = 'cdr_data_details_daily'

                print("Processing file for date:", date_str)
                print(df.dtypes)
                df = df[columns_to_insert]
                print("df : ", df)

                df.fillna("", inplace=True)
                print(df)

                # insert the data
                df.to_sql(table_name, conn, if_exists='append', index=False)
                print(len(df), "records inserted successfully")

                # Check if the date has changed
                if date_str != prev_date:
                    week_counter += 1
                    prev_date = date_str

                # Check if 7 consecutive days have been inserted
                if week_counter == 2:
                    conn.execute(weekly_procedure_sql)
                    print("Week data inserted")
                    week_counter = 0

                # Check if 30 consecutive days have been inserted
                if month_counter == 3:
                    conn.execute(monthly_procedure_sql)
                    print("Month data inserted")
                    month_counter = 0

                month_counter += 1

            # Close the database connection
    conn.close()
    print("Connection closed successfully")
else:
    print("Validation done")

def upload_files_in_directory(sftp_connection, local_directory, remote_directory):
    """

    :param sftp_connection: sftp connection
    :param local_directory: local directory
    :param remote_directory: remote directory where we're putting the csv files
    :return: nothing
    """
    try:
        # List all files in the local directory
        files_to_upload = [f for f in os.listdir(local_directory) if os.path.isfile(os.path.join(local_directory, f))]

        for file_name in files_to_upload:
            local_path = os.path.join(local_directory, file_name)
            remote_paths = os.path.join(remote_directory, file_name)

            # Upload the file to the remote server
            sftp_connection.put(local_path, remote_paths)
            logging.info(f"Uploaded {local_path} to {remote_paths}")

    except Exception as e:
        error_msg = f"Error uploading files: {str(e)}"
        logging.error(error_msg)
        print(error_msg)


sftp, ssh_client = connect_to_server(host, port, user, password)

if sftp:
    try:
    	# upload the files in success directory
        upload_files_in_directory(sftp, success_directory, success_path)
        upload_files_in_directory(sftp, directory, error_path)

        sftp.close()
        ssh_client.close()
        logging.info("Successfully uploaded files from 'success' and 'error' folders to the remote server")
    except Exception as e:
        error_message = f"Error uploading files: {str(e)}"
        logging.error(error_message)
        print(error_message)
else:
    logging.error("Could not establish a connection to the remote server.")
