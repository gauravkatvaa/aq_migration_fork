from conf.custom.metis.config import *
import mysql.connector
import traceback
from conf.config import aircontrol_db_configs

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

        cursor = db.cursor()

        if table_name == 'accounts':
            if not hasattr(sql_query_table_data, 'accounts_flag'):
                sql_query_table_data.accounts_flag = 1
                asset_query = f"SELECT IFNULL(MAX(id), 0) FROM {table_name} WHERE NAME='{opco_user}';"
            elif hasattr(sql_query_table_data, 'accounts_flag') and sql_query_table_data.accounts_flag == 1:
                asset_query = f"SELECT IFNULL(MAX(id), 0) + {high_offset} FROM {table_name};"
                sql_query_table_data.accounts_flag = 2
            elif hasattr(sql_query_table_data, 'accounts_flag') and sql_query_table_data.accounts_flag == 2:
                asset_query = f"SELECT IFNULL(MAX(id), 0) FROM {table_name} WHERE type=2;"
                sql_query_table_data.accounts_flag = 3
            else:
                asset_query = f"SELECT IFNULL(MAX(id), 0) FROM {table_name} WHERE type=3"

        elif table_name == 'account_goup_mappings':
            if not hasattr(sql_query_table_data, 'account_goup_mappings_flag'):
                sql_query_table_data.account_goup_mappings_flag = 1
                asset_query = f"SELECT IFNULL(MAX(id), 0) + {high_offset} FROM {table_name};"
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 1:
                asset_query = f"SELECT goup_user_name FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 2
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 2:
                asset_query = f"SELECT goup_user_key FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 3
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 3:
                asset_query = f"SELECT goup_password FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 4
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 4:
                asset_query = f"SELECT application_key FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 5
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 5:
                asset_query = f"SELECT goup_url FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 6
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 6:
                asset_query = f"SELECT auth_token_url FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 7
            elif hasattr(sql_query_table_data,
                         'account_goup_mappings_flag') and sql_query_table_data.account_goup_mappings_flag == 7:
                asset_query = f"SELECT validate_token_url FROM {table_name} ORDER BY id DESC LIMIT 1;"
                sql_query_table_data.account_goup_mappings_flag = 8
        else:
            asset_query = f"SELECT IFNULL(MAX(id), 0) + {high_offset} FROM {table_name};"

        # Execute the query
        cursor.execute(asset_query)

        # Fetch the result
        data = cursor.fetchall()

        # Extract the result value
        table_name_result = data[0][0]
        print(asset_query)
        print("Result of query:", table_name_result)

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




def callthe_upper_function(table_name):
    data=[]
    for table in table_name:
        result = sql_query_table_data(aircontrol_db_configs, table)
        print(f"Result for table '{table}': {result}")
        data.append(result)
    return data
c=callthe_upper_function(table_name)


"""role_tab_id=c[0],role_screen_id=c[1],role_id=c[2],whole_sale_rate_plan_id=c[3],pricing_categories_id=c[4],
price_model_type_id=c[5],price_model_id=c[6],zone_id=c[7],opco_account_id=c[8],account_extend_id=c[9],max_account_id=c[10],contact_info_id=c[11]
"""

role_tab_id=c[0]
role_screen_id=c[1]
role_id=c[2]
whole_sale_rate_plan_id=c[3]
pricing_categories_id=c[4]
price_model_type_id=c[5]
price_model_id=c[6]
zone_id=c[7]
opco_account_id=c[8]
account_extend_id=c[9]
max_account_id=c[10]
contact_info_id=c[11]
whole_sale_to_pricing_categories_id=c[12]
users_id=c[13]
migration_contact_info_id=c[14]
user_details_id=c[15]
account_goup_mappings_id=c[16]
##router
sim_provisioned_range_details_id=c[17]
sim_provisioned_ranges_level1_id=c[18]
sim_provisioned_ranges_level2_id=c[19]
sim_provisioned_ranges_level3_id=c[20]
accounttype2_id=c[21]
accounttype3_id=c[22]
assets_extended_id=c[23]
##sevice
device_rate_plan_id=c[24]
service_plan_id=c[25]
service_apn_details_id=c[26]
migration_service_apn_details_id=c[27]
service_api_ip_id=c[28]
assets_id=c[29]
goup_user_name_id=c[30]
goup_user_key_id=c[31]
goup_password_id=c[32]
application_key_id=c[33]
goup_url_id=c[34]
auth_token_url_id=c[35]
validate_token_url_id=c[36]





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

        if procedure_name == 'migration_contect_info_procedure':
            print(procedure_name,contact_info_id)
            # logger_info.info(procedure_name,contact_info_id)
            cursor.callproc(procedure_name,args=(contact_info_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({contact_info_id})")

        elif procedure_name =='migration_account_extended_procedure':
            print(procedure_name,account_extend_id)
            # logger_info.info(procedure_name,account_extend_id)
            cursor.callproc(procedure_name,args=(account_extend_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({account_extend_id})")

        elif procedure_name == 'migration_asset_extended_procedure':
            print(procedure_name,account_extend_id)
            cursor.callproc(procedure_name, args=(account_extend_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({account_extend_id})")
        #
        elif procedure_name =='migration_account_goup_mappings_procedure':
            print(procedure_name,(account_goup_mappings_id,goup_user_name_id,goup_user_key_id,goup_password_id,application_key_id,goup_url_id,auth_token_url_id,validate_token_url_id))
            cursor.callproc(procedure_name,args=(account_goup_mappings_id,goup_user_name_id,goup_user_key_id,goup_password_id,application_key_id,goup_url_id,auth_token_url_id,validate_token_url_id))
            logger_info.info(f"procedure call{procedure_name},arg=({account_goup_mappings_id,goup_user_name_id,goup_user_key_id,goup_password_id,application_key_id,goup_url_id,auth_token_url_id,validate_token_url_id})")

        elif procedure_name == 'migration_account_procedure':
            # print("data")
            print(procedure_name,max_account_id,contact_info_id,account_extend_id,opco_account_id)
            cursor.callproc(procedure_name, args=(max_account_id,contact_info_id,account_extend_id,opco_account_id))
            logger_info.info(f"procedure call{procedure_name},arg=({max_account_id,contact_info_id,account_extend_id,opco_account_id})")

        elif procedure_name =='migration_zone_procedure':
            print(procedure_name,account_extend_id,zone_id)
            cursor.callproc(procedure_name, args=(account_extend_id,zone_id))
            logger_info.info(f"procedure call{procedure_name},arg=({account_extend_id,zone_id})")

        elif procedure_name == 'migration_zone_to_country_procedure':
            print(procedure_name,zone_id)
            cursor.callproc(procedure_name, args=(zone_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({zone_id})")

        elif procedure_name == 'migration_price_model_rate_plan_procedure':
            print(procedure_name,account_extend_id,price_model_id)
            cursor.callproc(procedure_name, args=(account_extend_id,price_model_id))
            logger_info.info(f"procedure call{procedure_name},arg=({account_extend_id,price_model_id})")


        elif procedure_name == 'migration_price_to_model_type_procedure':
            print(procedure_name,price_model_id,price_model_type_id)
            cursor.callproc(procedure_name, args=(price_model_id,price_model_type_id))
            logger_info.info(f"procedure call{procedure_name},arg=({price_model_id,price_model_type_id})")

        elif procedure_name == 'migration_pricing_categories_procedure':
            print(procedure_name,pricing_categories_id)
            cursor.callproc(procedure_name, args=(pricing_categories_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({pricing_categories_id})")

        elif procedure_name == 'migration_whole_sale_rate_plan_procedure':
            print(procedure_name,account_extend_id, whole_sale_rate_plan_id)
            cursor.callproc(procedure_name, args=(account_extend_id, whole_sale_rate_plan_id))
            logger_info.info(f"procedure call{procedure_name},arg=({account_extend_id, whole_sale_rate_plan_id})")

        elif procedure_name == 'migration_whole_sale_to_pricing_categories_procedure':
            print(procedure_name,whole_sale_rate_plan_id,pricing_categories_id,whole_sale_to_pricing_categories_id)
            cursor.callproc(procedure_name, args=(whole_sale_rate_plan_id,pricing_categories_id,whole_sale_to_pricing_categories_id))
            logger_info.info(f"procedure call{procedure_name},arg=({whole_sale_rate_plan_id,pricing_categories_id,whole_sale_to_pricing_categories_id})")

        elif procedure_name == 'migration_role_access_procedure':
            print(procedure_name,role_id,max_account_id)
            cursor.callproc(procedure_name, args=(role_id,max_account_id))
            logger_info.info(f"procedure call{procedure_name},arg=({role_id,max_account_id})")

        elif procedure_name=='migration_role_to_screen_mapping_procedure':
            print(procedure_name,role_screen_id,role_id)
            cursor.callproc(procedure_name,args=(role_screen_id,role_id))
            logger_info.info(f"procedure call{procedure_name},arg=({role_screen_id,role_id})")

        elif procedure_name =='migration_role_to_tab_mapping_procedure':
            print(procedure_name,role_tab_id,role_id)
            cursor.callproc(procedure_name,args=(role_tab_id,role_id))
            logger_info.info(f"procedure call{procedure_name},arg=({role_tab_id,role_id})")

        elif procedure_name =='migration_accounts_goup':
            print(procedure_name,max_account_id,zone_id,price_model_id)

            cursor.callproc(procedure_name,args=(max_account_id,zone_id,price_model_id))
            logger_info.info(f"procedure call{procedure_name},arg=({max_account_id,zone_id,price_model_id})")

        elif procedure_name =='migration_accounts_goup_procedure':
            print(procedure_name,max_account_id,zone_id,price_model_id)
            cursor.callproc(procedure_name,args=(max_account_id,zone_id,price_model_id))
            logger_info.info(f"procedure call{procedure_name},arg=({max_account_id,zone_id,price_model_id})")
        ##user
        elif procedure_name =='migration_user_contect_info_procedure':
            print(procedure_name,migration_contact_info_id)
            cursor.callproc(procedure_name,args=(migration_contact_info_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({migration_contact_info_id})")

        elif procedure_name =='migration_users_procedure':
            print(procedure_name,users_id,migration_contact_info_id,user_details_id,role_id)
            cursor.callproc(procedure_name,args=(users_id,migration_contact_info_id,user_details_id,role_id))
            logger_info.info(f"procedure call{procedure_name},arg=({users_id},{migration_contact_info_id},{user_details_id},{role_id})")

        elif procedure_name =='migration_user_details_procedure':
            print(procedure_name,user_details_id)
            cursor.callproc(procedure_name,args=(user_details_id,))
            logger_info.info(f"procedure call{procedure_name},arg={user_details_id}")

        elif procedure_name =='migration_users_extended_account_procedure':
            print(procedure_name,users_id,migration_contact_info_id,user_details_id,role_id)
            cursor.callproc(procedure_name,args=(users_id,migration_contact_info_id,user_details_id,role_id))
            logger_info.info(f"procedure call{procedure_name},arg=({price_model_id, price_model_type_id})")

        ##Router_andassets
        elif procedure_name =='migration_sim_provisioned_range_details_procedure':
            print(procedure_name,sim_provisioned_range_details_id)
            cursor.callproc(procedure_name,args=(sim_provisioned_range_details_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({sim_provisioned_range_details_id})")



        elif procedure_name =='migration_sim_provisioned_ranges_level1_procedure':
            print(procedure_name,sim_provisioned_range_details_id,sim_provisioned_ranges_level1_id)
            cursor.callproc('migration_account_batch_mapping_procedure',args=())
            # print("run")
            cursor.callproc(procedure_name,args=(sim_provisioned_range_details_id,sim_provisioned_ranges_level1_id))
            logger_info.info(f"procedure call{procedure_name},arg=({sim_provisioned_range_details_id,sim_provisioned_ranges_level1_id})")

        elif procedure_name =='migration_sim_provisioned_ranges_level2_procedure':
            print(procedure_name,sim_provisioned_range_details_id,sim_provisioned_ranges_level2_id,accounttype2_id,accounttype3_id)
            cursor.callproc('migration_account_batch_mapping_procedure', args=())
            cursor.callproc(procedure_name,args=(sim_provisioned_range_details_id,sim_provisioned_ranges_level2_id,accounttype2_id,accounttype3_id))
            logger_info.info(f"procedure call{procedure_name},arg=({sim_provisioned_range_details_id,sim_provisioned_ranges_level2_id,accounttype2_id,accounttype3_id})")

        elif procedure_name=='migration_sim_provisioned_ranges_level3_procedure':
            print(procedure_name,sim_provisioned_range_details_id,sim_provisioned_ranges_level3_id,accounttype2_id,accounttype3_id)
            cursor.callproc('migration_account_batch_mapping_procedure', args=())
            cursor.callproc(procedure_name,args=(sim_provisioned_range_details_id,sim_provisioned_ranges_level3_id,accounttype2_id,accounttype3_id))
            logger_info.info(f"procedure call{procedure_name},arg=({sim_provisioned_range_details_id,sim_provisioned_ranges_level3_id,accounttype2_id,accounttype3_id})")


        elif procedure_name == 'migration_sim_provisioned_ranges_to_account_procedure':
            print(procedure_name, sim_provisioned_ranges_level1_id,accounttype3_id)
            cursor.callproc(procedure_name, args=(sim_provisioned_ranges_level1_id,accounttype3_id))
            logger_info.info(f"procedure call{procedure_name},arg=({sim_provisioned_ranges_level1_id,accounttype3_id})")

        elif procedure_name == 'migration_asset_extended_procedure':
            print(procedure_name, assets_extended_id)
            cursor.callproc(procedure_name, args=(assets_extended_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({assets_extended_id})")


        elif procedure_name=='migration_assests_details_procedure':
            #migration_assests_details_procedure('Malaysia',accounttype2_id,assets_id,assets_extended_id)
            print(procedure_name,('Malaysia',accounttype2_id,assets_id,assets_extended_id))
            cursor.callproc(procedure_name,args=('Malaysia',accounttype2_id,assets_id,assets_extended_id))
            logger_info.info(f"procedure call{procedure_name},arg=('Malaysia',{accounttype2_id,assets_id,assets_extended_id})")


        ##service
        elif procedure_name == 'migration_device_rate_plan_procedure':
            print(procedure_name,(device_rate_plan_id,zone_id,price_model_id))
            cursor.callproc(procedure_name,args=(device_rate_plan_id,zone_id,price_model_id))
            logger_info.info(f"procedure call{procedure_name},arg=({device_rate_plan_id,zone_id,price_model_id})")

        elif procedure_name == 'migration_service_apn_details_procedure':
            print(procedure_name,(service_apn_details_id))
            cursor.callproc(procedure_name,args=(service_apn_details_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({service_apn_details_id})")

        elif procedure_name == 'migration_service_apn_ip_procedure':
            print(procedure_name,(service_api_ip_id,service_apn_details_id))
            cursor.callproc(procedure_name,args=(service_api_ip_id,service_apn_details_id))
            logger_info.info(f"procedure call{procedure_name},arg=({service_api_ip_id,service_apn_details_id})")

        elif procedure_name == 'migration_service_plan_info_procedure':
            print(procedure_name,(service_plan_id))
            cursor.callproc(procedure_name,args=(service_plan_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({service_plan_id,})")

        elif procedure_name == 'migration_service_plan_to_service_type_info_procedure':
            print(procedure_name,(service_plan_id))
            cursor.callproc(procedure_name,args=(service_plan_id,))
            logger_info.info(f"procedure call{procedure_name},arg=({service_plan_id})")

        ##service_planGoup
        elif procedure_name=='migration_goup_service_procedure':
            print(procedure_name, (service_plan_id,device_rate_plan_id,migration_service_apn_details_id))
            cursor.callproc(procedure_name, args=(service_plan_id,device_rate_plan_id,migration_service_apn_details_id))
            logger_info.info(f"procedure call{procedure_name},arg=({service_plan_id,device_rate_plan_id,migration_service_apn_details_id})")



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
    return fetch_result,column_names