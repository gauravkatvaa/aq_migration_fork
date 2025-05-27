import pandas as pd
import os
from datetime import datetime
import mysql.connector

from config import *

from os.path import dirname, abspath, join


from logger import logger_
dir_path = dirname(abspath(__file__))

logger_info = logger_(dir_path, logs["migration_info_logger"])
logger_error = logger_(dir_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

from mysql.connector import Error



def run_query_and_append_to_csv(database_tables_dict, output_csv, database_config, result_column):
    try:
        # Initialize an empty DataFrame to store results
        result_df = pd.DataFrame(columns=["Database", "Table_Name", result_column])

        # Iterate over each database and its tables
        for database, tables_list in database_tables_dict.items():
            try:
                # Connect to MySQL database
                connection = mysql.connector.connect(
                    host=database_config["HOST"],
                    user=database_config["USER"],
                    password=database_config["PASSWORD"],
                    database=database,  # Connect to the current database
                    port=database_config["PORT"]
                )

                # Execute query for each table in the current database
                for table in tables_list:
                    try:
                        query = f"SELECT max(id) FROM {table};"
                        # print("table", table)
                        cursor = connection.cursor()
                        cursor.execute(query)
                        result = cursor.fetchone()[0]
                        cursor.close()
                        print(f"Database: {database}, Table: {table}, Result: {result}")
                        # Append database name, table name, and result to DataFrame
                        result_df = result_df.append({"Database": database, "Table_Name": table, result_column: result}, ignore_index=True)
                    except Error as e:
                        if e.errno == 1054 and 'id' in str(e):
                            print(f"Unknown column 'id' in table '{table}', moving to next table.")
                            logger_info.info(f"Unknown column 'id' in table '{table}', moving to next table.")
                            continue  # Move to the next table
                        else:
                            print(f"An error occurred while executing query for table '{table}': {e}")
                            logger_info.info(f"An error occurred while executing query for table '{table}': {e}")

                # If the output CSV file exists, remove its contents
                if os.path.isfile(output_csv):
                    open(output_csv, 'w').close()
                with open(output_csv, 'a') as f:
                    f.write('Database,Table_Name,After_Execution\n')
                # Append DataFrame to CSV
                result_df.to_csv(output_csv, mode='a', index=False, header=False)

                # Close database connection
                connection.close()
            except Exception as e:
                # print(f"An error occurred: {e}")
                logger_error.error(f"An error occurred: {e}")

    except Exception as e:
        # print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")


if __name__ == '__main__':
    # Loop through tables and run query
    output_csv = 'post_max_id.csv'  # Update with your desired output CSV file
    result_column = "After_Execution"  # Update accordingly when calling the function

    run_query_and_append_to_csv(database_tables_dict, output_csv, db_config, result_column)
