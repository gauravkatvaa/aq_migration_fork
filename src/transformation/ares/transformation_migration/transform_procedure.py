from conf.custom.apollo.config import KSA_OPCO_user, table_name, country
from src.utils.library import *
import traceback


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


# def call_procedure_with_param(procedure_name, table_names, database_config, max_id_db_config, logger_error, logger_info):
#     """
#     :param procedure_name: procedure name
#     :param table_names: comma-separated string of table names (optional)
#     :param database_config: database config details
#     :param max_id_db_config: database config details for retrieving max_id (optional)
#     :param logger_error: logger error
#     :param logger_info: logger info
#     :return: It will print the procedure result
#     """
#     fetch_result = []
#     column_names = None
#     try:
#         mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config["PASSWORD"], database_config["PORT"])
#         if mysql_conn is None:
#             logger_error.error("Error connecting to database")
#             print("Error connecting to database")
#             return fetch_result, column_names

#         cursor = mysql_conn.cursor()

#         if table_names:
#             try:
#                 # Split the comma-separated string of table names into a list
#                 table_names_list = [table_name.strip() for table_name in table_names.split(",")]

#                 # Retrieve the max_id for each table and store them in a list
#                 max_ids = []
#                 for table_name in table_names_list:
#                     try:
#                         print(max_id_db_config["HOST"],max_id_db_config["DATABASE"])
#                         max_id_conn = mysql_connection(max_id_db_config["DATABASE"], max_id_db_config["HOST"], max_id_db_config["USER"], max_id_db_config["PASSWORD"], max_id_db_config["PORT"])
#                         if max_id_conn is None:
#                             logger_error.error("Error connecting to database for max_id")
#                             print("Error connecting to database for max_id")
#                             return fetch_result, column_names

#                         max_id_cursor = max_id_conn.cursor()
#                         max_id_query = f"SELECT IFNULL(MAX(id), 0) + {offset} FROM {table_name}"
#                         max_id_cursor.execute(max_id_query)
#                         max_id = max_id_cursor.fetchone()[0]
#                         print("max_id",max_id)
#                         max_id_conn.close()
#                         max_ids.append(max_id)
#                     except Exception as e:
#                         logger_error.error(f"Error retrieving max_id for table {table_name}: {e}")
#                         logger_info.error(f"Error retrieving max_id for table {table_name}: {e}")
#                         print(f"Error retrieving max_id for table {table_name}: {e}")

#                 # Call the procedure with the max_ids as arguments
#                 if procedure_name == 'migration_assets':
#                     try:
#                         print(f"{procedure_name} procedure called and arguments {(country, *max_ids)}")
#                         cursor.callproc(procedure_name, args=(country, *max_ids))
                        
#                         logger_info.info(f"{procedure_name} procedure called and arguments {(country, *max_ids)}")
#                     except Exception as e:
#                         logger_error.error(f"Error calling procedure {procedure_name}: {e}")
#                         logger_info.error(f"Error calling procedure {procedure_name}: {e}")
#                         print(f"Error calling procedure {procedure_name}: {e}")

#             except Exception as e:
#                 logger_error.error(f"Error processing table names: {e}")
#                 logger_info.error(f"Error processing table names: {e}")
#                 print(f"Error processing table names: {e}")

#         else:
#             try:
#                 # Call the procedure without retrieving the max_id
#                 cursor.callproc(procedure_name, args=())
#                 print(f"{procedure_name} procedure called")
#                 logger_info.info(f"{procedure_name} procedure called")
#             except Exception as e:
#                 logger_error.error(f"Error calling procedure {procedure_name}: {e}")
#                 logger_info.error(f"Error calling procedure {procedure_name}: {e}")
#                 print(f"Error calling procedure {procedure_name}: {e}")

#     except Exception as e:
#         logger_error.error(f"Error connecting to database: {e}")
#         logger_info.error(f"Error connecting to database: {e}")
#         print(f"Error connecting to database: {e}")

#     finally:
#         cursor.close()
#         mysql_conn.close()
#         print("MySQL connection is closed")

#     return fetch_result, column_names



# ###calling_procedure argumnets like

# #call_procedure_with_param('assests_details_cdp', 'assest_extend,assest', aircontrol_db_configs, max_id_db_configs, logger_error, logger_info)    
# #call_procedure_with_param('assests_details_cdp', '', aircontrol_db_configs, max_id_db_configs, logger_error, logger_info)
# #call_procedure_with_param('assests_details_cdp', 'assest', aircontrol_db_configs, max_id_db_configs, logger_error, logger_info)


def call_procedure_with_param(procedure_name, table_names, database_config, max_id_db_config, logger_error, logger_info):
    fetch_result = []
    column_names = None

    try:
        mysql_conn = mysql_connection(database_config["DATABASE"], database_config["HOST"], database_config["USER"], database_config["PASSWORD"], database_config["PORT"])
        if mysql_conn is None:
            logger_error.error("Error connecting to database")
            print("Error connecting to database")
            return fetch_result, column_names

        cursor = mysql_conn.cursor()

        if table_names:
            try:
                # Split the comma-separated string of table names into a list
                table_names_list = [table_name.strip() for table_name in table_names.split(",")]

                # Retrieve the max_id for each table and store them in a list
                max_ids = []
                for table_name in table_names_list:
                    try:
                        max_id_conn = mysql_connection(max_id_db_config["DATABASE"], max_id_db_config["HOST"], max_id_db_config["USER"], max_id_db_config["PASSWORD"], max_id_db_config["PORT"])
                        if max_id_conn is None:
                            logger_error.error("Error connecting to database for max_id")
                            print("Error connecting to database for max_id")
                            return fetch_result, column_names

                        max_id_cursor = max_id_conn.cursor()
                        max_id_query = f"SELECT IFNULL(MAX(id), 0) + {offset} FROM {table_name}"
                        print("max_id_query",max_id_query)
                        max_id_cursor.execute(max_id_query)
                        max_id = max_id_cursor.fetchone()[0]
                        print("max_id", max_id)
                        max_id_conn.close()
                        max_ids.append(max_id)
                    except Exception as e:
                        logger_error.error(f"Error retrieving max_id for table {table_name}: {e}")
                        logger_info.error(f"Error retrieving max_id for table {table_name}: {e}")
                        print(f"Error retrieving max_id for table {table_name}: {e}")

                # Call the procedure with the max_ids as arguments
                if procedure_name == 'migration_assets':
                    try:
                        print(f"{procedure_name} procedure called with arguments {tuple(max_ids)}")
                        cursor.callproc(procedure_name, args=tuple(max_ids))  # Pass only max_ids to the procedure
                        logger_info.info(f"{procedure_name} procedure called with arguments {tuple(max_ids)}")
                    except Exception as e:
                        logger_error.error(f"Error calling procedure {procedure_name}: {e}")
                        logger_info.error(f"Error calling procedure {procedure_name}: {e}")
                        print(f"Error calling procedure {procedure_name}: {e}")
            except Exception as e:
                logger_error.error(f"Error processing table names: {e}")
                logger_info.error(f"Error processing table names: {e}")
                print(f"Error processing table names: {e}")
        else:
            try:
                # Call the procedure without retrieving the max_id
                cursor.callproc(procedure_name,args=())
                print(f"{procedure_name} procedure called")
                logger_info.info(f"{procedure_name} procedure called")
                
            except Exception as e:
                logger_error.error(f"Error calling procedure {procedure_name}: {e}")
                logger_info.error(f"Error calling procedure {procedure_name}: {e}")
                print(f"Error calling procedure {procedure_name}: {e}")

        for result in cursor.stored_results():
            column_names = [i[0] for i in result.description]
            fetch_result.append(result.fetchall())
        if fetch_result:
            fetch_result = fetch_result[0]
    except Exception as e:
        logger_error.error(f"Error connecting to database: {e}")
        logger_info.error(f"Error connecting to database: {e}")
        print(f"Error connecting to database: {e}")
    finally:
        cursor.close()
        mysql_conn.commit()
        mysql_conn.close()
        print("MySQL connection is closed")

    return fetch_result, column_names
