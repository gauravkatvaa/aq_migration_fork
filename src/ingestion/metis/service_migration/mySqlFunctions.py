"""
Created on 22 Feb 2024
@author: amit.k@airlinq.com

This file contain db related function:
1. mysql_connection : Generate mysql connection.
2. sql_query_fetch : Fetching sql query ,execute and return data.


"""

import mysql.connector
from config import *
import pandas as pd
import numpy as np


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


def sql_query_delete_table(database_config, table_name, logger_error):
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
        asset_query = f"DELETE FROM {table_name};"
        cursor.execute(asset_query)
        db.commit()
        cursor.close()
        db.close()
    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def call_procedure(procedure_name, database_config, logger_error, logger_info):
    """
    :param procedure_name: procedure name
    :param database_config: database config details
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will print the procedure result
    """
    fetch_result = None  # Initialize fetch_result to None
    try:
        print('.............................Procedure called..........................................')
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                      database_config["PASSWORD"], database_config["PORT"])
        cursor = mysql_conn.cursor()
        print("{} procedure called".format(procedure_name))
        if procedure_name=="migration_service_mapping_goup":
            cursor.callproc(procedure_name,args=(high_offset,))
        else:
            cursor.callproc(procedure_name, args=())
        print("{} procedure called".format(procedure_name))
        logger_info.info('{} procedure called'.format(procedure_name))

        # print out the result
        for result in cursor.stored_results():
            fetch_result = result.fetchall()
        # print(fetch_result)
        print('Procedure Result : ', fetch_result)
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

    # Check if fetch_result is still None and return it accordingly
    return fetch_result if fetch_result is not None else []

######################### Edit by nimish ###########################################



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
            #print(chunk)
            try:
                if not db.is_connected():
                    db = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                          database_config['PASSWORD'],
                                          database_config["PORT"])

                cursor = db.cursor()
                query = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s'] * len(df.columns))})"
                # print('query : ',query)
                records = chunk.itertuples(index=False)
                values = [tuple(row) for row in records]
                # print('value : ',values)
                print("len of inserted values : ", len(values))
                cursor.executemany(query, values)
                db.commit()
                logger_info.info("Data Inserterd into DB : {}".format(values))
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
                        # print('query : ', query)
                        values = tuple(row.values)
                        print('len of inserted chunk : ', len(values))
                        cursor.execute(query, values)
                        db.commit()
                        logger_info.info("Data Inserterd into DB : {}".format(values))
                    except Exception as e:
                        logger_error.error("Error {} while inserting data into Table {} values: {}".format(e,table_name,values))
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




######################### Edit by Amit ###########################################


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
