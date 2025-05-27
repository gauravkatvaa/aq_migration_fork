import pandas as pd
import os
import mysql.connector
import pandas as pd
import mysql.connector
from config import *


def run_query_and_append_to_csv(database_tables_dict, output_csv, database_config, result_column):
    try:
        # Initialize an empty DataFrame to store results
        result_df = pd.DataFrame(columns=["Table_Name", result_column])

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
                    query = f"SELECT COUNT(*) FROM {table};"
                    cursor = connection.cursor()
                    cursor.execute(query)
                    result = cursor.fetchone()[0]
                    cursor.close()
                    print(f"Database: {database}, Table: {table}, Result: {result}")
                    # Append database name, table name, and result to DataFrame
                    result_df = result_df.append({"Table_Name": table, result_column: result}, ignore_index=True)

                # If the output CSV file exists, remove its contents
                if os.path.isfile(output_csv):
                    open(output_csv, 'w').close()
                with open(output_csv, 'a') as f:
                    f.write('Table_Name,After_Execution\n')
                # Append DataFrame to CSV
                result_df.to_csv(output_csv, mode='a', index=False, header=False)

                # Close database connection
                connection.close()
            except Exception as e:
                print(f"An error occurred: {e}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == '__main__':

    # Loop through tables and run query
    output_csv = 'postexcute.csv'  # Update with your desired output CSV file
    result_column = "After_Execution"  # Update accordingly when calling the function

    run_query_and_append_to_csv(database_tables_dict,output_csv,db_config,result_column)