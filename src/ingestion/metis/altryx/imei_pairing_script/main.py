import os
import logging
import paramiko
import pandas as pd
from sqlalchemy import create_engine, text
from config import *
import shutil
import datetime

logging.basicConfig(filename='imei_pairing.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s: %(message)s')

# Database connection information
engine = create_engine('mysql+mysqlconnector://', connect_args=meta_db_config)
connection = engine.connect()
remote_path = local_csv_file_path["csv_file_path"]

# local_path = "local_csv_files"
csv_history = local_csv_file_path["csv_file_path_history"]
success_path = local_csv_file_path["success_csv_file_path"]
error_path = local_csv_file_path["error_csv_file_path"]

# Ask the user whether to perform only validation
validation_only_input = input("Perform only validation? Enter True or False: ").strip().lower()
validation_only = validation_only_input == 'true'

local_csv_directory = local_csv_file_path["csv_file_path"]
# os.makedirs(local_path, exist_ok=True)
success_directory = local_csv_file_path["success_csv_file_path"]
os.makedirs(success_directory, exist_ok=True)
directory = local_csv_file_path["error_csv_file_path"]
history_directory = local_csv_file_path["csv_file_path_history"]
os.makedirs(history_directory, exist_ok=True)
os.makedirs(directory, exist_ok=True)


def add_reason(row):
    """
    :param row:
    :return: reason column into the validation error file and application error
            file if any error in rows
    """
    reasons = []
    if not pd.notna(row['imsi']):
        reasons.append('imsi is missing')
    elif not row['imsi'].isdigit():
        reasons.append('imsi is not numeric')
    if not pd.notna(row['msisdn']):
        reasons.append('msisdn is missing')
    elif not row['msisdn'].isdigit():
        reasons.append('msisdn is not numeric')
    if not pd.notna(row['imei_lock']):
        reasons.append('imei lock is missing')
    # elif not row['imei_lock'].isdigit():
    #     reasons.append('imei_lock is not numeric')

    if reasons:
        return ', '.join(reasons)
    else:
        return 'Ok'


local_files = os.listdir(local_csv_directory)
csv_files = [file for file in local_files if file.endswith('.csv')]

for csv_file in csv_files:
    # original_filename = os.path.splitext(csv_file)[0]
    # csv_file_path = os.path.join(local_path, csv_file)

    csv_file_path = os.path.join(local_csv_directory, csv_file)
    original_filename = os.path.splitext(csv_file)[0]
    print(original_filename)

    # Create an empty DataFrame to store data from the current CSV file
    combined_df = pd.DataFrame()

    # Create lists to store duplicate IMSIs and validation errors as entire rows
    duplicate_imsis = []
    validation_errors = []

    # Keep track of CSV files that exist in assets
    csv_files_in_assets = set()

    # Initialize duplicate_imsis_df as an empty DataFrame
    duplicate_imsis_df = pd.DataFrame()
    unmatched_df = pd.DataFrame()

    # Specify data types for columns to preserve leading zeros
    dtypes = {
        'imsi': str,
        'msisdn': str
    }

    df = pd.read_csv(csv_file_path, dtype=dtypes)

    df['reason'] = df.apply(add_reason, axis=1)
    # Data type validation and check for non-numeric values

    print("Dataframe : \n", df)

    error_df = df[df['reason'] != 'Ok']
    print("validation error rows : \n", error_df)

    # validation_errors_file_path = os.path.join(directory, f'{original_filename}_validation_errors.csv')
    # error_df.to_csv(validation_errors_file_path, index=False)

    df = df[df['reason'] == 'Ok']

    # Save the validation error rows before moving the original file to history
    if not error_df.empty:
        validation_errors_file_path = os.path.join(directory, f'{original_filename}_validation_errors.csv')
        csv_file_name = f'{original_filename}_validation_errors.csv'
        error_df.to_csv(validation_errors_file_path, index=False)
        error_df.to_csv(os.path.join(error_directory, csv_file_name), index=False)

    # Now move the original CSV file to the history folder
    history_file_path = os.path.join(history_directory, csv_file)
    shutil.move(csv_file_path, history_file_path)

    # Check for duplicate IMSIs within the same CSV file and store entire rows
    duplicate_imsis.extend(df[df.duplicated('imsi', keep='last')].to_dict(orient='records'))

    # Remove duplicate rows from the CSV file
    df.drop_duplicates(subset='imsi', keep='last', inplace=True)

    # Append the data from the current CSV file to the combined DataFrame
    combined_df = combined_df.append(df, ignore_index=True)
    print("Combine DF : \n", combined_df)

    # combined_df['alias'] = combined_df['alias'].str.lstrip()

    imsi_values = df['imsi'].astype(str)
    csv_files_in_assets.update(imsi_values)

    # Save the modified CSV file
    df.to_csv(csv_file_path, index=False)

    if duplicate_imsis:
        duplicate_imsis_df = pd.DataFrame(duplicate_imsis)
        duplicate_imsis_df['reason'] = 'Duplicate IMSI / MSISDN in Assets table'

    print(combined_df)

    # Create a connection to the database
    connection = engine.connect()

    # Create a list to store the unmatched rows from the CSV file
    unmatched_rows = []

    # Create a list to store bulk updates
    updates = []

    # Create a list to store rows processed successfully into the database
    successful_updates = []

    # Fetch existing imsi, msisdn pairs from the database into a set for fast lookup
    existing_pairs = set(
        (str(row["imsi"]), str(row["msisdn"])) for row in
        connection.execute("SELECT imsi, msisdn FROM assets").fetchall()
    )

    print("Existing Pairs in the Database:")
    print(existing_pairs)

    # Iterate through the CSV rows
    for index, row in combined_df.iterrows():
        imsi = str(row["imsi"])
        msisdn = str(row["msisdn"])
        current_imei = str(row["imei_lock"])

        if pd.notna(current_imei):  # Check if device_id is not NaN
            if (imsi, msisdn) not in existing_pairs:
                unmatched_rows.append(row)
            else:
                updates.append({"imsi": imsi, "msisdn": msisdn, "current_imei": current_imei})
                successful_updates.append(row)  # Store the successful updates

    if not validation_only:
        if updates:
            update_query = text(
                """
                UPDATE assets
                SET current_imei = :current_imei
                WHERE imsi = :imsi AND msisdn = :msisdn
                """
            )
            connection.execute(update_query, updates, multi=True)

        # Close the database connection
        connection.close()
        if unmatched_rows:
            print("Unmatched rows :\n")
            unmatched_df = pd.DataFrame(unmatched_rows)
            unmatched_df['reason'] = 'IMSI, MSISDN Pair not Match in Assets Table'
            print(unmatched_df)
            print("Rows Do not match into Assets table")

            csv_file_name_app = f'{original_filename}_application_errors.csv'
            print("file name : ", csv_file_name_app)
            csv_paths = os.path.join(directory, csv_file_name_app)
            print("csv path : ", csv_paths)

            if not duplicate_imsis_df.empty or not unmatched_df.empty:
                application_error = pd.concat([duplicate_imsis_df, unmatched_df])
                application_error.to_csv(csv_paths, index=False)
                application_error.to_csv(os.path.join(error_directory, csv_file_name_app), index=False)
            else:
                application_error = None

        # Create a CSV file for rows processed successfully into the database

        if successful_updates:
            successful_updates_df = pd.DataFrame(successful_updates)
            successful_updates_file_path = os.path.join(success_directory,
                                                        f'{original_filename}_successful_updates.csv')
            column_to_drop = 'reason'
            successful_updates_df = successful_updates_df.drop(column_to_drop, axis=1)
            successful_updates_df.to_csv(successful_updates_file_path, index=False)

            logging.info("Rows Processed Successfully into Database")
            logging.info(f"\n{successful_updates_df}")

        # Remove the current CSV file from the local_csv_path directory
        # os.remove(csv_file_path)
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
