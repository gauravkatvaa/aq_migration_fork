from conf.custom.apollo.config import KSA_OPCO_user, table_name, country
import mysql.connector
import traceback
from conf.config import aircontrol_db_configs,offset
import mysql.connector
import pandas as pd
import numpy as np
import cx_Oracle
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
############### Required In Transformation #############################################################################
def sql_query_table_data(database_config, table_name):
    try:
        # Establish a database connection
        db = mysql.connector.connect(
            host=database_config["HOST"],
            user=database_config["USER"],
            password=database_config["PASSWORD"],
            database=database_config["DATABASE"],
            port=database_config["PORT"]
        )
        print(database_config["DATABASE"])
        cursor = db.cursor()
        if table_name == 'accounts':
            asset_query=F"SELECT ID FROM {table_name} WHERE NAME='{KSA_OPCO_user}';"
        elif table_name =='order_shipping_status':
            asset_query=F"SELECT MAX(id) + {offset} FROM {table_name};"
        # elif table_name == 'sim_range': 
        #     asset_query = F"SELECT MAX(id) + {offset} FROM {table_name};"

        elif table_name =='sim_provisioned_range_details':
            asset_query=F"SELECT MAX(id)+{offset} FROM {table_name};"   

        elif table_name =='map_user_sim_order':
            if not hasattr(sql_query_table_data, 'map_flag'):
                sql_query_table_data.map_flag = 1
                asset_query = asset_query = F"SELECT MAX(id) + {offset}  FROM {table_name};"
            elif hasattr(sql_query_table_data, 'map_flag') and sql_query_table_data.map_flag == 1:
                # print(F"SELECT MAX(order_number) FROM {table_name};")
                # asset_query = f"SELECT MAX(CAST(order_number AS SIGNED)) FROM {database_config['DATABASE']}.{table_name};"
                asset_query = f"SELECT order_number FROM {database_config['DATABASE']}.{table_name} ORDER BY id DESC LIMIT 1;"
                print("asset query ",asset_query)
                sql_query_table_data.map_flag = 2    
        else:
            # Generic query for other tables
            asset_query = f"SELECT IFNULL(MAX(id), 0) + {offset} FROM {table_name};"

        # Execute the query
        cursor.execute(asset_query)

        # Fetch the result
        data = cursor.fetchall()

        # Extract the result value
        table_name_result = data[0][0]
        print("Result of query:",asset_query ,table_name_result)

        # Commit the transaction (if needed)
        db.commit()

    except Exception as e:
        print(e)
        # logger_error.error("Error: {}".format(e))
        return None
    finally:
        # Close the cursor and database connection
        if db.is_connected():
            cursor.close()
            db.close()
            print("MySQL connection is closed")

    return table_name_result

def execute_sql_query(query, database_config, logger_error, logger_info):
    """
    :param query: SQL query to execute
    :param database_config: database config details
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will return the query result
    """
    fetch_result = []
    column_names = None
    try:
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],
                                      database_config["PASSWORD"], database_config["PORT"])
        cursor = mysql_conn.cursor()

        cursor.execute(query)

        # Fetch column names
        column_names = [i[0] for i in cursor.description]

        # Fetch result
        fetch_result = cursor.fetchall()
        # Print or log the result count
        print('Query Result Count:', len(fetch_result))
        logger_info.info('Query Result Count: {}'.format(len(fetch_result)))

    except Exception as e:
        logger_info.error('{} Error while executing query'.format(e))
        logger_error.error('{} Error while executing query'.format(e))
        print(traceback.format_exc())

    finally:
        cursor.close()
        mysql_conn.close()
        print("MySQL connection is closed")

    return fetch_result, column_names

def callthe_upper_function(table_name):
    data=[]
    for table in table_name:
        result = sql_query_table_data(aircontrol_db_configs, table)
        print(f"Result for table '{table}': {result}")
        data.append(result)
    return data

c=callthe_upper_function(table_name)

accounts_opco_id=c[0]
sim_range_id=c[1]
map_user_sim_id=c[2]
order_shipping_status_id=c[3]
migration_sim_event_log_id=c[4]
sim_provisioned_range_details_id=c[5]
map_user_sim_order_number_id=c[6]
tag_max_id=c[7]


def call_procedure_with_param(procedure_name,database_config,logger_error,logger_info):
    """
    :param procedure_name: procedure name
    :param database_config: database config details
    :param logger_error: logger error
    :param logger_info: logger info
    :return: It will print the procedure result
    """
    fetch_result = []
    column_names = None
    try:
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"],database_config["PASSWORD"],
                         database_config["PORT"])
        cursor = mysql_conn.cursor()
        # print("procdure_called")
        if procedure_name == 'assests_details_cdp':
            # print("data")
            print(country,accounts_opco_id)
            cursor.callproc(procedure_name, args=(country, accounts_opco_id))
            print(f"{procedure_name}procedure called and arguments {(country, accounts_opco_id)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(country, accounts_opco_id)}")


        elif procedure_name =='sim_products_cdp':
            cursor.callproc(procedure_name,args=(accounts_opco_id,))
            print(f"{procedure_name}procedure called and arguments {(accounts_opco_id,)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(accounts_opco_id,)}")

        elif procedure_name =='migration_sim_range':
            print("sim_range_id,accounts_opco_id",sim_range_id,accounts_opco_id,map_user_sim_id,map_user_sim_order_number_id)
            cursor.callproc(procedure_name,args=(sim_range_id,accounts_opco_id,map_user_sim_id,map_user_sim_order_number_id))
            print(f"{procedure_name}procedure called and arguments {(sim_range_id,accounts_opco_id,map_user_sim_id,map_user_sim_order_number_id)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(sim_range_id,accounts_opco_id,map_user_sim_id,map_user_sim_order_number_id)}")


        elif procedure_name=='migration_order_shipping_status':
            print("order_shipping_status_id",order_shipping_status_id)
            cursor.callproc(procedure_name,args=(order_shipping_status_id,))
            print(f"{procedure_name}procedure called and arguments {(order_shipping_status_id,)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(order_shipping_status_id,)}")


        elif procedure_name=='migration_map_user_sim_order':
            cursor.callproc(procedure_name,args=(map_user_sim_id,map_user_sim_id,order_shipping_status_id))
            print(f"{procedure_name}procedure called and arguments {(map_user_sim_id,map_user_sim_id,order_shipping_status_id)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(map_user_sim_id,map_user_sim_id,order_shipping_status_id)}")


        elif procedure_name=='migration_sim_event_log':
            # cursor.callproc(procedure_name,args=(migration_sim_event_log_id,map_user_sim_id))
            # print(f"{procedure_name}procedure called and arguments {(migration_sim_event_log_id,map_user_sim_id)}")
            # logger_info.info(f"{procedure_name}procedure called and arguments {(migration_sim_event_log_id,map_user_sim_id)}")
            cursor.callproc(procedure_name,args=(sim_range_id,map_user_sim_id))
            print(f"{procedure_name}procedure called and arguments {(sim_range_id,map_user_sim_id)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(sim_range_id,map_user_sim_id)}")


        elif procedure_name=='migration_sim_provisioned_range_details':
            cursor.callproc(procedure_name,args=(sim_provisioned_range_details_id,))
            print(f"{procedure_name}procedure called and arguments {(sim_provisioned_range_details_id,)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(sim_provisioned_range_details_id,)}")
  
        elif procedure_name=='migration_tag':
            cursor.callproc(procedure_name,args=(tag_max_id,))
            print(f"{procedure_name}procedure called and arguments {(tag_max_id,)}")
            logger_info.info(f"{procedure_name}procedure called and arguments {(tag_max_id,)}")
  
        else :
            cursor.callproc(procedure_name,args=())
            print("{} procedure called".format(procedure_name))
            logger_info.info('{} procedure called'.format(procedure_name))
        # print out the result

        for result in cursor.stored_results():
            column_names = [i[0] for i in result.description]
            fetch_result.append(result.fetchall())
        if fetch_result:
            fetch_result = fetch_result[0]

        #print(column_names)

        print('Procedure Result Count : ', len(fetch_result))
        logger_info.info('Procedure Result Count : {}'.format(len(fetch_result)))

        return fetch_result, column_names
    except Exception as e:
        logger_info.error('{} Error while calling procedure'.format(e))
        logger_error.error('{} Error while calling procedure'.format(e))
        #print(e)
        print(traceback.format_exc())

    finally:
        cursor.close()
        # mysql_conn.commit()
        mysql_conn.close()
        print("MySQL connection is closed")




def mysql_connection(database, host, user, password, port):
    """Create and return a MySQL database connection."""
    return mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database,
        port=port
    )

def insert_chunk(cursor, query, values, logger_info, logger_error):
    """Insert a chunk of data into the database."""
    try:
        cursor.executemany(query, values)
        logger_info.info(f"Data Inserted: {len(values)} records")
    except Exception as e:
        logger_error.error(f"Error during chunk insertion: {e}")
        raise

def handle_failed_chunk(db, chunk, query, logger_info, logger_error):
    """Handle failed chunk by splitting it into smaller chunks and attempting to insert them."""
    sub_chunks = np.array_split(chunk, 10)
    for sub_chunk in sub_chunks:
        try:
            cursor = db.cursor()
            sub_values = [tuple(row) for row in sub_chunk.itertuples(index=False)]
            insert_chunk(cursor, query, sub_values, logger_info, logger_error)
            db.commit()
        except Exception as e:
            logger_error.error(f"Error during sub-chunk insertion: {e}")
            handle_failed_rows(db, sub_chunk, query, logger_info, logger_error)

def handle_failed_rows(db, chunk, query, logger_info, logger_error):
    """Handle individual rows that fail to insert."""
    drop_row_index = []
    for index, row in chunk.iterrows():
        try:
            cursor = db.cursor()
            row_values = tuple(row)
            cursor.execute(query, row_values)
            db.commit()
            logger_info.info(f"Data Inserted: 1 record")
        except Exception as e:
            logger_error.error(f"Error inserting row at index {index}: {e}")
            drop_row_index.append(index)
    return drop_row_index

def insert_batches_df_into_mysqlfrom_yogesh(df, database_config, table_name, logger_info, logger_error):
    """
    Inserts data from a dataframe into a MySQL table in batches.

    Parameters:
    df: pd.DataFrame - The dataframe containing data to insert.
    database_config: dict - The database configuration.
    table_name: str - The name of the table to insert data into.
    logger_info: logging.Logger - Logger for info messages.
    logger_error: logging.Logger - Logger for error messages.
    chunk_size: int - Size of chunks to split the dataframe into for insertion.

    Returns:
    df_partial_error: pd.DataFrame - DataFrame of rows that failed to insert.
    df: pd.DataFrame - Original DataFrame.
    """
    chunk_size=offset
    try:
        db = mysql_connection(
            database_config["DATABASE"], 
            database_config["HOST"], 
            database_config["USER"], 
            database_config['PASSWORD'],
            database_config["PORT"]
        )

        df.reset_index(drop=True, inplace=True)
        chunks = np.array_split(df, len(df) // chunk_size + 1)
        drop_row_index = []

        query = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s'] * len(df.columns))})"

        for chunk in chunks:
            try:
                if not db.is_connected():
                    db = mysql_connection(
                        database_config["DATABASE"], 
                        database_config["HOST"], 
                        database_config["USER"], 
                        database_config['PASSWORD'],
                        database_config["PORT"]
                    )
                cursor = db.cursor()
                values = [tuple(row) for row in chunk.itertuples(index=False)]
                insert_chunk(cursor, query, values, logger_info, logger_error)
                db.commit()
            except Exception as e:
                logger_error.error(f"Error during chunk insertion: {e}")
                drop_row_index += handle_failed_rows(db, chunk, query, logger_info, logger_error)

        df_partial_error = pd.DataFrame()
        if drop_row_index:
            df_partial_error = df.iloc[drop_row_index, :]

        return df_partial_error, df

    except Exception as e:
        logger_error.error(f"Critical error: {e}")
        return df, pd.DataFrame()

    finally:
        if db.is_connected():
            db.close()
            print("MySQL connection is closed")

