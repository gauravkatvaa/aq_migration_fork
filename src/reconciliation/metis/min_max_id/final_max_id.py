import pandas as pd
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


def merge_csv_files_with_offset(after_execution_csv, before_execution_csv, offset, output_csv):
    try:
        # Read the first CSV file containing 'After_Execution' data
        after_execution_df = pd.read_csv(after_execution_csv,dtype=str)

        # Read the second CSV file containing 'Before_Execution' data
        before_execution_df = pd.read_csv(before_execution_csv,dtype=str)

        # Merge the two DataFrames on 'Database' and 'Table_Name' columns
        merged_df = pd.merge(after_execution_df, before_execution_df, on=['Database', 'Table_Name'],
                             suffixes=('_After', '_Before'))
        merged_df['After_Execution'].fillna(0, inplace=True)
        # Add the offset
        merged_df['offset'] = offset
        merged_df['Before_Execution'].fillna(0, inplace=True)
        merged_df['Before_Execution'] = merged_df['Before_Execution'].astype(int)
        # if merged_df['Before_Execution']==0:
        #     merged_df['After_Execution_Before_min_id'] = merged_df['Before_Execution']
        # else:
        merged_df['post_mig_minid'] = merged_df['Before_Execution'] + offset
        merged_df['create_date'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        merged_df.rename(columns={'After_Execution': 'post_mig_maxid', 'Before_Execution': 'pre_mig_maxid'},
                         inplace=True)

        # Reorder columns to match the desired order
        merged_df = merged_df[['Database', 'Table_Name','pre_mig_maxid','post_mig_maxid','offset','post_mig_minid','create_date']]

        # Write the merged DataFrame to a new CSV file
        merged_df.to_csv(output_csv, index=False)

        print("Merge operation completed successfully.")
        logger_info.info("Merge operation completed successfully.")

    except FileNotFoundError as e:
        # print(f"File not found: {e}")
        logger_error.error(f"File not found: {e}")
    except Exception as e:
        # print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")





def insert_data_from_csv(csv_file,db_connection):
    try:
        # Read the CSV file into a DataFrame
        df = pd.read_csv(csv_file)

        # Loop through each row in the DataFrame
        for index, row in df.iterrows():
            # Extract data from the row
            database_name = row['Database']
            table_name = row['Table_Name']
            pre_mig_maxid = row['pre_mig_maxid']
            offset = row['offset']
            post_mig_minid = row['post_mig_minid']
            post_mig_maxid = row['post_mig_maxid']
            create_date = row['create_date']

            # Connect to MySQL database
            try:
                connection = mysql.connector.connect(
                    host=db_connection["HOST"],
                    user=db_connection["USER"],
                    password=db_connection["PASSWORD"],
                    database=db_connection["DATABASE"],
                    port=db_connection["PORT"]
                )
                table_to_insert_data=db_connection["Table_name"]
                # Prepare the SQL query to insert data into the table
                sql_query = f"INSERT INTO {table_to_insert_data}  (database_name, table_name, pre_mig_maxid, offset, post_mig_minid, post_mig_maxid, create_date) VALUES (%s, %s, %s, %s, %s, %s, %s)"

                # Execute the SQL query with the extracted data
                cursor = connection.cursor()
                cursor.execute(sql_query, (database_name, table_name, pre_mig_maxid, offset, post_mig_minid, post_mig_maxid, create_date))
                connection.commit()

                # print("Data inserted successfully.")

            except Exception as e:
                print(f"An error occurred while inserting data into the database: {e}")
                logger_error.error(f"An error occurred while inserting data into the database: {e}")

            finally:
                if connection.is_connected():
                    cursor.close()
                    connection.close()
                    print("Connection closed.")

    except Exception as e:
        print(f"An error occurred while reading the CSV file: {e}")
        logger_error.error(f"An error occurred while reading the CSV file: {e}")

if __name__ == '__main__':


    # Example usage:
    merge_csv_files_with_offset('post_max_id.csv', 'pre_max_id.csv',offset,'max_id_validate.csv')
    # Example usage:
    csv_file_path = 'max_id_validate.csv'  # Update with your CSV file path
    insert_data_from_csv(csv_file_path,db_config)
