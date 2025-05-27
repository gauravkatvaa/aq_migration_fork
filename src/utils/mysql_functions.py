"""
Created on 22 Feb 2024
@author: amit.k@airlinq.com

This file contain db related function:
1. mysql_connection : Generate mysql connection.
2. sql_query_fetch : Fetching sql query ,execute and return data.


"""
import sys
sys.path.append("..")

import traceback
from conf.config import *
from conf.custom.apollo.config import KSA_OPCO_user, table_name, country
import mysql.connector
import pandas as pd
import numpy as np
import cx_Oracle
from conf.config import chunk_size


def convert_timestamps_to_string(row_data):
    """
    :param row_data: dataframe row data
    :return: this function will return the converted row data
    """
    for key, value in row_data.items():
        if isinstance(value, pd.Timestamp):
            row_data[key] = value.strftime('%Y-%m-%d %H:%M:%S')
    return row_data

def mysql_connection(aircontrol_database,aircontrol_host,aircontrol_username,aircontrol_password,aircontrol_jdbcPort):
    '''

    :return: Generate mysql connection.
    '''
    try:
        mysql_conn = mysql.connector.connect(host=aircontrol_host, user=aircontrol_username,
                                             database=aircontrol_database, password=aircontrol_password, port=aircontrol_jdbcPort)

        if mysql_conn.is_connected():
            print('Connect Established with DB')
        return mysql_conn

    except Exception as e:
        print("Error connecting to MySQL server: {}".format(e))
        return None


def execute_query(database_configs, query, logger_error):
    """
    Execute a SQL query on the specified database.
    
    :param database_configs: Database configuration details
    :param query: SQL query to be executed
    :return: None
    """
    try:
        conn = mysql_connection(database_configs["DATABASE"], database_configs["HOST"], database_configs["USER"], database_configs['PASSWORD'],
                         database_configs["PORT"])
        cursor = conn.cursor()
        cursor.execute(query)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as e:
        logger_error.error(f"Error executing query: {e}")


def create_or_replace_table(database_config, table_name, table_structure, logger_info, logger_error):
    """
    Drop the table if it exists and create a new table with the provided structure.
    
    :param db_config: Database configuration details
    :param table_name: Name of the table to be created
    :param table_structure: SQL statement defining the table structure
    :param logger_info: Info logger
    :param logger_error: Error logger
    """
    try:
        # Connect to the database
        conn =  mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = conn.cursor()
        
        # Drop table if it exists
        drop_table_sql = f"DROP TABLE IF EXISTS {table_name}"
        cursor.execute(drop_table_sql)
        logger_info.info(f"Table {table_name} dropped if it existed.")
        
        # Create table
        cursor.execute(table_structure)
        logger_info.info(f"Table {table_name} created successfully.")
        
    except Exception as err:
        logger_error.error(f"Error: {err}")
        # print(f"Error: {err}")
    finally:
        # Close cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            print("MySQL connection is closed")



def sql_query_fetch(querry,database_config, logger_error):
    '''

    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        cursor.execute(querry)
        data = cursor.fetchall()
        # print(data)
        cursor.close()
        db.close()
        return data

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def truncate_mysql_table(database_config, table_name, logger_error):
    '''

        :param querry: select query to delete table data
        :param logger_error: error logs
        :return: Fetching the data by using query ,execute and return data.
        '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                              database_config['PASSWORD'],
                              database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        asset_query = f"TRUNCATE {table_name};"
        cursor.execute(asset_query)
        db.commit()
        cursor.close()
        db.close()
        print("Data Truncated from Table : {}".format(table_name))
    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")

def create_iso_code_id_dict(query, db_connection_details,logger_error):
    try:
        # Establish database connection
        connection = mysql_connection(db_connection_details["DATABASE"], db_connection_details["HOST"], db_connection_details["USER"], db_connection_details['PASSWORD'],
                         db_connection_details["PORT"])
        cursor = connection.cursor()

        # Query to select ISO_CODE and ID from the specified table
        # sql_query = f"SELECT ISO_CODE, ID FROM {table_name}"
        sql_query=query
        cursor.execute(sql_query)

        # Construct dictionary from query results
        iso_code_id_dict = {iso_code: id for iso_code, id in cursor}

        # Close cursor and connection
        cursor.close()
        connection.close()

        return iso_code_id_dict
    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred:{e}")
        return None



def call_procedure(procedure_name,database_config,logger_error,logger_info):
    """
    :param procedure_name: procedure name
    :param database_config: database config details
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will print the procedure result
    """
    try:
        print('.............................Procedure called..........................................')
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],database_config["PASSWORD"],
                         database_config["PORT"])
        cursor = mysql_conn.cursor()
        print("{} procedure called".format(procedure_name))
        logger_info.info('{} procedure called'.format(procedure_name))
        cursor.callproc(procedure_name,args=())
        # print out the result
        fetch_result = []
        for result in cursor.stored_results():
            fetch_result.append(result.fetchall())
        # print(,fetch_result)
        print('Procedure Result : ',fetch_result)
        logger_info.info('Procedure Result : {}'.format(fetch_result))
    except Exception as e:
        logger_info.error('{} Error while calling procedure'.format(e))
        logger_error.error('{} Error while calling procedure'.format(e))
        print(e)

    finally:
        cursor.close()
        mysql_conn.commit()
        mysql_conn.close()
        print("MySQL connection is closed")

# def call_procedure(procedure_name, database_config, logger_error, logger_info):
#     """
#     :param procedure_name: procedure name
#     :param database_config: database config details
#     :param logger_error: logger error
#     :param logger_info: logger info
#     :return: It will print the procedure result
#     """
#     fetch_result = None  # Initialize fetch_result to None
#     try:
#         print('.............................Procedure called..........................................')
#         mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
#                                       database_config["PASSWORD"], database_config["PORT"])
#         cursor = mysql_conn.cursor()
#         print("{} procedure called".format(procedure_name))
#         logger_info.info('{} procedure called'.format(procedure_name))
#         if procedure_name=="migration_service_mapping_goup" or procedure_name=="migration_account_mapping":
#             cursor.callproc(procedure_name,args=(offset,))
#         else:
#             cursor.callproc(procedure_name, args=())
#
#         # print out the result
#         for result in cursor.stored_results():
#             fetch_result = result.fetchall()
#         # print(fetch_result)
#         print('Procedure Result : ', fetch_result)
#         logger_info.info('Procedure Result : {}'.format(fetch_result))
#     except Exception as e:
#         logger_info.error('{} Error while calling procedure'.format(e))
#         logger_error.error('{} Error while calling procedure'.format(e))
#         print(e)
#     finally:
#         cursor.close()
#         mysql_conn.commit()
#         mysql_conn.close()
#         print("MySQL connection is closed")
#
#     # Check if fetch_result is still None and return it accordingly
#     return fetch_result if fetch_result is not None else []


def insert_batches_df_into_mysql(df, database_config, table_name, logger_info, logger_error):
    """
    df: dataframe
    database_config: db config
    table_name: table name in which insertion will be done.
    logger_info: info logger
    logger_error: logger error
    return valid and failed dataframe
    """
    try:

        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        #cursor = db.cursor()
        
        drop_row_index = []
        df.reset_index(drop=True, inplace=True)
        chunks = np.array_split(df, len(df) // chunk_size + 1)
        print("length of chunks", len(chunks))
        for chunk in chunks:
            print(len(chunk))
            try:
                if not db.is_connected():
                    db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                          database_config['PASSWORD'],
                                          database_config["PORT"])

                cursor = db.cursor()
                # query = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s'] * len(df.columns))})"
                query = f"INSERT INTO {table_name} ({', '.join([f'`{col}`' for col in df.columns])}) VALUES ({', '.join(['%s'] * len(df.columns))})"
                # print('query : ',query)
                records = chunk.itertuples(index=False)
                values = [tuple(row) for row in records]
                # print('value : ',values)
                print("len of inserted values : ", len(values))
                cursor.executemany(query, values)
                db.commit()
                print(f"Data Inserted into Table {table_name} DB  : {len(values)}")
                logger_info.info("Data Inserted into Table {} DB  : {}".format(table_name,len(values)))
            except Exception as e:
                # exit(0)
                for index, row in chunk.iterrows():
                    
                    try:
                        if not db.is_connected():
                            db = mysql_connection(database_config["DATABASE"], database_config["HOST"],
                                                  database_config["USER"],
                                                  database_config['PASSWORD'],
                                                  database_config["PORT"])
                        cursor = db.cursor()
                        query = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s'] * len(df.columns))})"
                        print('query : ', query)
                        values = tuple(row.values)
                        print('values:',values)
                        # print('len of inserted chunk : ', len(values))
                        cursor.execute(query, values)
                        db.commit()
                        print(f"Data Inserted into Table {table_name} DB  : {len(values)}")
                        logger_info.info("Data Inserted into Table {} DB  : {}".format(table_name,len(values)))
                        # logger_info.debug("Data Inserterd into DB : {}".format(values))
                    except Exception as e:
                        print(f"got error while inserting {e}")
                        logger_error.error("Error {} while inserting data into Table {} values: {}".format(e,table_name,values))
                        # logger_error.warning("Error {} while inserting data into Table {} values: {}".format(e,table_name,values))
                        drop_row_index = drop_row_index.append(index)
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df.iloc[drop_row_index, :]
        return df_partial_error, df
    except Exception as e:
        cursor.close()
        db.close()
        logger_error.error("Error {} while inserting data into Table {} values: {}".format(e,table_name,values))
        return df,  pd.DataFrame()
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def insert_single_df_into_mysql(df, database_config, table_name, logger_info, logger_error):
    """
    :param df: dataframe
    :param database_config: db config details
    :param table_name: required table name
    :param logger_info: logger info
    :param logger_error: logger error
    :return: success and failure dataframes
    """
    try:

        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])

        drop_row_index =[]
        for index, row in df.iterrows():
            row = convert_timestamps_to_string(row)
            try:
                if not db.is_connected():
                    db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                          database_config['PASSWORD'],
                                          database_config["PORT"])

                cursor = db.cursor()
                col_list = []
                for col in row.keys():
                    col_list.append ('%s'%col)


                query = f"INSERT INTO {table_name} VALUES ({', '.join(['%s'] * len(row))})"
                value = tuple(row.values)
                #print('value : ',value)
                # Commented for testing
                cursor.execute(query, value)

                db.commit()
                logger_info.info("Data Inserted into Table {} DB  : {}".format(table_name,value))
            except Exception as e:
                drop_row_index.append(index)
                print("-- Error : ",table_name , 'value : ', value,"error : ",e)
                logger_error.error("Table name : {} value : {} Error : {}".format(table_name,value, e))

            cursor.close()
        db.close()
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df.iloc[drop_row_index, :]
        df = df.drop(drop_row_index)
        df = df.reset_index(drop=True)
        return df_partial_error, df

    except Exception as e:
        cursor.close()
        db.close()
        logger_error.error('Error while inserting data to db : {} '.format(e))
        return df,  pd.DataFrame()

    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def generate_procedure_error_file(database_config,table_name,logger_error,logger_info):
    """
    :param db_config: database config details
    :param table_name: table name to query 
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will generate procedure error dataframe
    """
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                              database_config['PASSWORD'],
                              database_config["PORT"])
        df = pd.DataFrame()
        cursor = db.cursor()
        select_query = f"SELECT * FROM {table_name}"
        cursor.execute(select_query)
        row = cursor.fetchall()
        # Execute a describe query to get column names
        describe_query = f"DESCRIBE {table_name}"
        cursor.execute(describe_query)
        column_names = [column[0] for column in cursor.fetchall()]
        if len(row)!=0:
            df = pd.DataFrame(row, columns=column_names)
            logger_info.error("Error Entries {} in Table {}".format(row,table_name))
            logger_error.error("Error Entries {}in Table {}".format(row,table_name))
        
        db.commit()
        cursor.close()
        db.close()
        print('DB Connection Closed')
        return df
    except Exception as e:
        logger_info.error("Error Fetching error data :{} from table {}".format(e,table_name))
        logger_error.error("Error Fetching error data :{} from table {}".format(e,table_name))
        exit(0)




def read_table_as_df(table_name,database_config,logger_info, logger_error):
    '''
    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        query = 'SELECT * FROM {};'.format(table_name)

        df = pd.read_sql(query, db)
        # print(data)
        cursor.close()
        db.close()
        logger_info.info("Successfully Fetched data from Table {} data {} ".format(table_name,df))
        return df

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def read_df_oracle(connection_params, table_name, chunk_size,logger_info,logger_error):
    try:
        print("Establishing connection to the Oracle database...")
        # Establish a connection to the Oracle database
        
        connection = cx_Oracle.connect(
            f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
            f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
        )
        print("Connection established successfully!")

        
        print(f"Fetching data from table: {table_name}")
        logger_info.info(f"Fetching data from table: {table_name}")
        # Execute the query to fetch all data from the table
        
        query = f"SELECT * FROM {table_name}"

        cursor = connection.cursor()
        # cursor.execute(query)

        # Read data in chunks
        chunks = []
        for chunk in pd.read_sql(query, connection, chunksize=chunk_size):
            chunks.append(chunk)

        df = pd.concat(chunks)
        df = df.astype(str)
        # Fetch data directly into a DataFrame
        # df = pd.read_sql(query, connection,chunksize=chunk_size)
        # df = df.astype(str)
        cursor.close()
        connection.close()
        df.replace(np.nan, None, inplace=True)
        return df

    except cx_Oracle.DatabaseError as e:
        print(f"Database error: {e}")
        logger_error.error(f"Database error: {e}")
        return None


def truncate_oracle_table(connection_params, table_name, logger_info, logger_error):
    """
    Truncate the specified Oracle table.
    
    :param connection_params: Oracle database connection parameters
    :param table_name: Name of the table to truncate
    :param logger_info: Info logger
    :param logger_error: Error logger
    """
    try:
        print("Establishing connection to the Oracle database...")
        # Establish a connection to the Oracle database
        connection = cx_Oracle.connect(
            f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
            f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
        )
        print("Connection established successfully!")
        
        # Create a cursor object
        cursor = connection.cursor()
        
        # Truncate the specified table
        print(f"Truncating table: {table_name}")
        logger_info.info(f"Truncating table: {table_name}")
        
        # Construct the TRUNCATE query
        truncate_query = f"TRUNCATE TABLE {table_name}"
        
        # Execute the TRUNCATE query
        cursor.execute(truncate_query)
        
        # Commit the transaction
        connection.commit()
        
        # Close the cursor and connection
        cursor.close()
        connection.close()
        print("Table truncated successfully!")
        logger_info.info("Table truncated successfully!")
        
    except cx_Oracle.DatabaseError as e:
        print(f"Database error: {e}")
        logger_error.error(f"Database error: {e}")
        return None

def insert_into_oracle_table(connection_params, table_name, df, logger_info, logger_error):
    """
    Insert data into the specified Oracle table with improved error handling and SQL injection protection.
    
    :param connection_params: Oracle database connection parameters
    :param table_name: Name of the table to insert data into
    :param df: DataFrame containing the data to be inserted
    :param logger_info: Info logger
    :param logger_error: Error logger
    """
    connection = None
    try:
        print("Establishing connection to the Oracle database...")
        # Establish a connection to the Oracle database
        connection = cx_Oracle.connect(
            f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
            f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
        )
        print("Connection established successfully!")
        
        # Create a cursor object
        cursor = connection.cursor()
        
        # Insert data into the specified table
        print(f"Inserting data into table: {table_name}")
        logger_info.info(f"Inserting data into table: {table_name}")
        
        # Convert NaN values to None
        df.replace(np.nan, None, inplace=True)
        
        # Insert data using parameterized queries
        for index, row in df.iterrows():
            columns = list(row.index)
            values = list(row.values)  # FIXED: removed parentheses, values is an array not a method
            
            # Create placeholders for parameterized query
            placeholders = ", ".join([":"+str(i+1) for i in range(len(columns))])
            columns_str = ", ".join(columns)
            
            # Prepare the query with placeholders instead of direct values
            insert_query = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders})"
            
            # Process values to handle special cases
            processed_values = []
            for value in values:
                if value is None:
                    processed_values.append(None)
                elif isinstance(value, str):
                    # Trim strings to avoid unnecessary spaces that might cause issues
                    processed_values.append(value.strip())
                elif isinstance(value, float) and value.is_integer():
                    # Convert floats that are actually integers to integers
                    # (e.g., 11882.0 -> 11882)
                    processed_values.append(int(value))
                else:
                    processed_values.append(value)
            
            # Execute the INSERT query with parameterized values
            try:
                cursor.execute(insert_query, processed_values)
            except cx_Oracle.DatabaseError as e:
                error_obj = e.args[0]
                error_code = error_obj.code
                error_message = error_obj.message
                
                # Handle specific Oracle errors
                if error_code == 917:  # ORA-00917: missing comma
                    logger_error.error(f"SQL Syntax error: {error_message}. Row: {index}")
                    # Try alternate approach for this specific row
                    try:
                        # Create a direct SQL statement but with proper escaping
                        values_escaped = []
                        for val in processed_values:
                            if val is None:
                                values_escaped.append("NULL")
                            elif isinstance(val, (int, float)):
                                values_escaped.append(str(val))
                            elif isinstance(val, str):
                                # Double up single quotes in strings to escape them
                                escaped_val = val.replace("'", "''")
                                values_escaped.append(f"'{escaped_val}'")
                            else:
                                values_escaped.append(f"'{val}'")
                        
                        direct_sql = f"INSERT INTO {table_name} ({columns_str}) VALUES ({', '.join(values_escaped)})"
                        cursor.execute(direct_sql)
                        logger_info.info(f"Row {index} inserted using fallback method")
                    except Exception as fallback_error:
                        logger_error.error(f"Fallback insertion also failed for row {index}: {fallback_error}")
                elif error_code == 1:  # ORA-00001: unique constraint violation
                    logger_error.error(f"Unique constraint violation: {error_message}. Row: {index}")
                elif error_code == 1400:  # ORA-01400: cannot insert NULL
                    logger_error.error(f"NULL value in non-nullable column: {error_message}. Row: {index}")
                else:
                    logger_error.error(f"Oracle error {error_code}: {error_message}. Row: {index}")
            except Exception as e:
                logger_error.error(f"Unexpected error inserting row {index}: {e}")
        
        # Commit the transaction
        connection.commit()
        logger_info.info("Data inserted successfully!")
        print("Data inserted successfully!")
        
    except cx_Oracle.DatabaseError as e:
        error_obj = e.args[0]
        logger_error.error(f"Oracle Database Error {error_obj.code}: {error_obj.message}")
        print(f"Oracle Database Error {error_obj.code}: {error_obj.message}")
        if connection:
            connection.rollback()
    except Exception as e:
        logger_error.error(f"General error: {str(e)}")
        print(f"General error: {str(e)}")
        if connection:
            connection.rollback()
    finally:
        # Ensure resources are cleaned up even if an error occurs
        if connection:
            try:
                cursor.close()
            except:
                pass
            connection.close()
            print("Database connection closed.")
            

def insert_into_summary_table(database_config,table_name,logger_info,logger_error,*args):
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                              database_config['PASSWORD'],
                              database_config["PORT"])
        cursor = db.cursor()
        columns = ['entity_type', 'total_count', 'success_count', 'failure_count', 'execution_time', 'create_date']
        placeholders = ', '.join(['%s'] * len(args))
        query = f"INSERT INTO {table_name} ({', '.join([f'`{col}`' for col in columns])}) VALUES ({placeholders})"

        cursor.execute(query, args)
        db.commit()
        cursor.close()
        db.close()
        logger_info.info("Data inserted successfully into table {} values {}".format(table_name,args))
    except mysql.connector.Error as e:
        logger_error.error("Error While inserting into table {} : {} ".format(table_name,e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def sql_query_fetch_single_conn(querry,data,database_config, logger_error):
    '''

    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        # print(" DB Connection Established")

        cos_id = []
        not_found_uuid = []
        for uuid in data:
            try:
                if not db.is_connected():
                    db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                          database_config['PASSWORD'],
                                          database_config["PORT"])

                cursor = db.cursor()
                query_new = querry + f'{uuid}'
                cursor.execute(query_new)
                data = cursor.fetchall()
                if data:
                    cos_id.append(data[0][0])
                else:
                    not_found_uuid.append(uuid)
                    print("cosId {}, is not found for ENT_ACCOUNT_ID {}".format(data, uuid))
                    logger_error.error("cosId {}, is not found for ENT_ACCOUNT_ID {}".format(data,uuid))
                cursor.close()

            except Exception as e:
                print("Error : {} ".format(e))
                logger_error.error("Error : {} ".format(e))


        db.close()
        print("DB Connection Closed")
        return cos_id,not_found_uuid

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def sql_data_fetch(querry,uuids,database_config, logger_error):
    '''

    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
        # Disable safe updates
        # cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        cursor.execute(querry, tuple(uuids))
        data = cursor.fetchall()
        # print(data)
        cursor.close()
        db.close()
        return data

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def fetch_param_as_df(query,database_config,logger_info, logger_error):
    '''

    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config['PASSWORD'],
                         database_config["PORT"])
        cursor = db.cursor()
       

        df = pd.read_sql(query, db)
        # print(data)
        cursor.close()
        db.close()
        logger_info.info("Successfully Fetched data from Table {} data {} ".format(table_name,df))
        return df

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def call_procedure_with_parameter(procedure_name,database_config,logger_error,logger_info,*args):
    """
    :param procedure_name: procedure name
    :param database_config: database config details
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will print the procedure result
    """
    fetch_result = []
    # column_names = None
    try:
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],database_config["PASSWORD"],
                         database_config["PORT"])
        cursor = mysql_conn.cursor()
        # print(country,accounts_opco_id)
        cursor.execute("SET SQL_SAFE_UPDATES = 0;")
        cursor.callproc(procedure_name, args=(args))
        print("Procedure Called")
        for result in cursor.stored_results():
            fetch_result.append(result.fetchall())
        print(fetch_result)
        print(f"{procedure_name} procedure called and arguments {(args)}")
        logger_info.info(f"{procedure_name} procedure called and arguments {(args)}")
        logger_info.info('{} Fetched Result from procedure {}'.format(fetch_result,procedure_name))
    except Exception as e:
        logger_info.error('{} Error while calling procedure'.format(e))
        logger_error.error('{} Error while calling procedure'.format(e))
        #print(e)
        print(traceback.format_exc())

    finally:
        cursor.close()
        mysql_conn.commit()
        mysql_conn.close()
        print("MySQL connection is closed")


def procedure_call_oracle(connection_params, procedure_name,logger_info,logger_error,args):

    try:
        print("Establishing connection to the Oracle database...")
        # Establish a connection to the Oracle database
        connection = cx_Oracle.connect(
            f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
            f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
        )
        print("Connection established successfully!")

        
        print(f"Procedure Name : {procedure_name}")
        logger_info.info(f"Procedure Name : {procedure_name}")
        # Execute the query to fetch all data from the table
        cursor = connection.cursor()
        # output_param = cursor.var(cx_Oracle.STRING) 
        out_status = cursor.var(cx_Oracle.NUMBER)
        out_message = cursor.var(cx_Oracle.STRING, 200)
        print("args :",int(args))
        cursor.callproc(procedure_name,[int(args),out_status,out_message])
        # cursor.callproc(procedure_name,[args])

        # Fetch the output parameter value
        print("Status: ",out_status.getvalue())
        print("Message: ",out_message.getvalue())
        # cursor.execute(query)

        cursor.close()
        connection.commit()
        connection.close()
   
    except cx_Oracle.DatabaseError as e:
        print(f"Database error: {e}")
        logger_error.error(f"Database error: {e}")
        return None