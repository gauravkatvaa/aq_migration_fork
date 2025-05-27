import os
import shutil
import glob

import mysql.connector

import mysql.connector
from final_max_id import *
from config import *
from logger import *
from os.path import dirname, abspath, join


dir_path = dirname(abspath(__file__))

logger_info = logger_(dir_path, logs["migration_info_logger"])
logger_error = logger_(dir_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def query_and_save_to_csv(database_tables_dict, database_config, output_directory):
    try:
        # Iterate over each database and its tables
        for database, tables_list in database_tables_dict.items():
            # Connect to MySQL database
            connection = mysql.connector.connect(
                host=database_config["HOST"],
                user=database_config["USER"],
                password=database_config["PASSWORD"],
                database=database,
                port=database_config["PORT"]
            )

            for table in tables_list:
                print("table_name",table)
                # Execute SQL query to select all data from the table
                query = f"SELECT * FROM {database}.{table}"
                cursor = connection.cursor()
                cursor.execute(query)

                # Fetch all rows from the result set
                rows = cursor.fetchall()
                print(rows)

                # Check if any data is fetched
                if rows:
                    # Convert the result set to a DataFrame
                    df = pd.DataFrame(rows, columns=[desc[0] for desc in cursor.description])

                    # Save the DataFrame to a CSV file
                    csv_file_path = f"{output_directory}/{table}.csv"
                    df.to_csv(csv_file_path, index=False)

                    print(f"Data from table '{table}' saved to '{csv_file_path}'")
                    logger_info.info(f"Data from table '{table}' saved to '{csv_file_path}'")
                else:
                    print(f"No data found for table '{table}'")
                    logger_error.error(f"No data found for table '{table}'")

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")
    finally:
        # Close database connection
        if connection and connection.is_connected():
            connection.close()

def move_to_history(source_directory):
    """
    Method to move all files from source directory to history directory
    :param source_directory: Path of the source directory containing files to be moved
    :return: None
    """
    try:
        # Generate current date and time
        current_date = datetime.now().strftime("%Y%m%d%H%M")

        # Define the history directory
        history_directory = f'{history_file_path}/{current_date}'

        # Create the history directory if it doesn't exist
        if not os.path.exists(history_directory):
            os.makedirs(history_directory)

        # Get a list of all files in the source directory
        files_to_move = [os.path.join(source_directory, file) for file in os.listdir(source_directory)]

        # Move each file to the history directory
        for source_file in files_to_move:
            destination_file = os.path.join(history_directory, os.path.basename(source_file))
            os.rename(source_file, destination_file)
            print(f"File moved to history: {destination_file}")
            logger_info.info(f"File moved to history: {destination_file}")

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred in  move_to_history function: {e}")



def collect_errors_and_combine_to_csv(input_directories, error_directory):

    try:
        # Create the error directory if it doesn't exist
        if not os.path.exists(error_directory):
            os.makedirs(error_directory)

        # Move error files from input directories to the error directory
        for directory in input_directories:
            error_files = glob.glob(os.path.join(directory, '*.csv'))
            for error_file in error_files:
                shutil.move(error_file, error_directory)
                print(f"Moved {error_file} to {error_directory}")
                logger_info.info(f"Moved {error_file} to {error_directory}")

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred in collect_errors_and_combine_to_csv this function: {e}")

if __name__ == "__main__":

    merge_csv_files_with_offset('post_max_id.csv', 'pre_max_id.csv',offset,'max_id_validate.csv')
    # Example usage:
    csv_file_path = 'max_id_validate.csv'  # Update with your CSV file path
    insert_data_from_csv(csv_file_path,db_config)
    move_to_history(error_directory)
    query_and_save_to_csv(database_error_dict, db_config,error_directory)
    collect_errors_and_combine_to_csv(input_directories,error_directory)
