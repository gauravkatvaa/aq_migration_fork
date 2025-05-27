import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *
from contextlib import closing 
import csv
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

dir_path = dirname(abspath(__file__))

logs = {
    "migration_info_logger":f"A1_reconciliation_validator_info_{current_time_stamp}.log",
    "migration_error_logger":f"A1_reconciliation_validator_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{reconciliation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()


def append_to_csv(file_path, data):
    """
    Appends data to a CSV file. Creates the file if it doesn't exist.
    """
    try:
        file_exists = os.path.isfile(file_path)
        with open(file_path, 'a', newline='') as file:
            writer = csv.writer(file)
            if not file_exists:
                writer.writerow(['Database_name', 'query', 'alias', 'count'])
            writer.writerow(data)
        logger_info.info(f"Successfully appended data to {file_path}")
    except Exception as e:
        logger_error.error(f"Error appending data to CSV: {e}")

def main(csv_file_path):
    try:
        for db_name, db_queries in queries.items():
            if db_name in db_connections:
                # connection_details = convert_config_to_pymysql_format(db_connections[db_name])
                for query, alias in db_queries.items():
                    print(query)
                    querry = f"{query};"
                    logger_info.info(f"Executing query '{query}' on database '{db_name}'")
                    # result_count = execute_query(connection_details, querry)
                    result_count = sql_query_fetch(querry, db_connections[db_name], logger_error)
                    print("query_result", f"{query},{result_count}")
                    if result_count is not None:
                        result = result_count[0][0]
                        data = [db_name, query, alias, result]
                        append_to_csv(csv_file_path, data)
                    else:
                        logger_error.error(f"Failed to execute query '{query}' on database '{db_name}'")
            else:
                logger_error.error(f"No connection string found for database '{db_name}'")
    except Exception as e:
        logger_error.error(f"An error occurred in main: {e}")


def clear_csv(file_path):
    """
    Deletes the CSV file if it exists.
    """
    try:
        if os.path.isfile(file_path):
            os.remove(file_path)
            logger_info.info(f"Successfully deleted file {file_path}")
        else:
            logger_info.info(f"No file found at {file_path} to delete")
    except Exception as e:
        logger_error.error(f"Error deleting file {file_path}: {e}")



def merge_csv_files_with_offset(after_execution_csv, before_execution_csv, output_csv):
    try:
        # Read the first CSV file containing 'After_Execution' data
        after_execution_df = pd.read_csv(after_execution_csv, dtype=str)

        # Read the second CSV file containing 'Before_Execution' data
        before_execution_df = pd.read_csv(before_execution_csv, dtype=str)

        # Merge the two DataFrames on 'Database_name', 'query', and 'alias' columns
        merged_df = pd.merge(after_execution_df, before_execution_df, on=['Database_name', 'query', 'alias'],
                             suffixes=('_After', '_Before'))

        # Fill NaN values in 'count' columns with 0
        merged_df['count_After'].fillna(0, inplace=True)
        merged_df['count_Before'].fillna(0, inplace=True)

        # Convert 'count' columns to integers
        merged_df['count_After'] = merged_df['count_After'].astype(int)
        merged_df['count_Before'] = merged_df['count_Before'].astype(int)

        # Rename columns
        merged_df.rename(columns={'count_Before': 'pre_count', 'count_After': 'post_count'}, inplace=True)

        # Calculate 'Diffrence_data'
        merged_df['Diffrence_data'] = merged_df['post_count'] - merged_df['pre_count']

        # Reorder columns to match the desired order
        merged_df = merged_df[['Database_name', 'query', 'alias', 'pre_count', 'post_count', 'Diffrence_data']]

        # Write the merged DataFrame to a new CSV file
        merged_df.to_csv(output_csv, index=False)

        print("Merge operation completed successfully.")
        logger_info.info("Merge operation completed successfully.")

    except FileNotFoundError as e:
        logger_error.error(f"File not found: {e}")
    except Exception as e:
        logger_error.error(f"An error occurred: {e}")



if __name__ == "__main__":
    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "pre":
            clear_csv(pre_csv_file_path)
            main(pre_csv_file_path)
        if arg =='post':
            clear_csv(post_csv_file_path)
            main(post_csv_file_path)
            clear_csv(final_csv_file_path)
            merge_csv_files_with_offset(post_csv_file_path,pre_csv_file_path,final_csv_file_path)
