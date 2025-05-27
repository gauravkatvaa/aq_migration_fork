from logging import Logger
import sys

sys.path.append("..")

from src.utils.library import *
from conf.config import *
from all_transformed_functions import *
from conf.custom.ares.config import *
from transform_procedure import *
import time 
import datetime
from conf.config import *
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

logs = {
    "migration_info_logger": f"A1_transformation_info_{current_time_stamp}.log",
    "migration_error_logger": f"A1_transformation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{transformation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def update_column(df, column_name, initial_value):
    """
    :param df: required dataframe
    :param column_name: required column names of dataframe.
    :param initial_value: this is maxid fetched from asset and asset extended query.
    :return: It will return dataframe.
    """
    # Update value for the first row
    # print('initial value',initial_value)
    df.at[0, column_name] = initial_value
    # Increment value for subsequent rows
    for i in range(0, len(df)):
        df.at[i, column_name] = initial_value + i + 1
        # print(initial_value + i)
    return df


def update_ent_account_and_device_plan(df, update_dict):
    """
    Updates the 'ENT_ACCOUNTID' and 'DEVICE_PLAN_ID' columns of the DataFrame based on the given dictionary.

    Parameters:
    df (pd.DataFrame): The DataFrame to update.
    update_dict (dict): A dictionary where keys are 'ENT_ACCOUNTID' and values are 'DEVICE_PLAN_ID'.

    Returns:
    pd.DataFrame: The updated DataFrame.
    """
    try:
        # Calculate the chunk size
        chunk_size = len(df) // len(update_dict)
        remaining = len(df) % len(update_dict)

        # Ensure 'ENT_ACCOUNTID' and 'DEVICE_PLAN_ID' columns exist in the DataFrame
        if 'ENT_ACCOUNTID' not in df.columns:
            df['ENT_ACCOUNTID'] = np.nan
        if 'DEVICE_PLAN_ID' not in df.columns:
            df['DEVICE_PLAN_ID'] = np.nan

        # Update the DataFrame in chunks
        start = 0
        for i, (ent_account_id, device_plan_id) in enumerate(update_dict.items()):
            end = start + chunk_size
            if i < remaining:  # Distribute the remaining rows
                end += 1
            df.loc[start:end, 'ENT_ACCOUNTID'] = ent_account_id
            df.loc[start:end, 'DEVICE_PLAN_ID'] = device_plan_id
            start = end + 1

        return df

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")
        return df


def pull_transformed_data_from_sp(file_sp_mapper):
    """
    Method to call stored procedure for each output file and place on destination path defined in config
    :return: None
    """
    logger_info.info("-------------- Pull transformed data from DP Started -------------------")
    print("-------------- Pull transformed data from DP Started -------------------")

    try:
        asset_extended_fetch_max_id =f"""SELECT MAX(id) + {offset} AS max_id FROM (SELECT id FROM assets UNION SELECT id FROM assets_extended) AS combined_ids;"""
        maxid_extended = sql_query_fetch(asset_extended_fetch_max_id,aircontrol_db_configs,logger_error)
        maxid_extended = maxid_extended[0][0]
        for migrated_data_table, sp_call in file_sp_mapper.items() : 
            start_time = time.time()
            logger_info.info('Calling SP {} to fetch data'.format(sp_call))
            if sp_call == 'migration_assets':            
                resultset, column_names = call_procedure_with_param(sp_call,'assets',transformation_db_configs,aircontrol_db_configs, logger_error, logger_info)
            elif sp_call == 'csr_mapping_master' or sp_call =='csr_mapping_details':
                # why this special case you see these 2 stored procedure are under the validation db
                resultset, column_names = call_procedure_with_param(sp_call, '', validation_db_configs, aircontrol_db_configs, logger_error, logger_info)
            else :
                resultset, column_names = call_procedure_with_param(sp_call, '', transformation_db_configs, aircontrol_db_configs, logger_error, logger_info)
            
            if resultset:
                df = pd.DataFrame(resultset, columns=column_names)
                print("procedure_df", df)
                print(df.columns)
                
                # Check if DataFrame is not empty
                if not df.empty:
                    # print(migrated_data_table)
                    if migrated_data_table == 'migration_assets':
                        # print("hello",migrated_data_table)
                        df = update_column(df, 'ID', maxid_extended)
                        df = update_column(df, 'ASSETS_EXTENDED_ID', maxid_extended)
                        df.replace({np.nan: None}, inplace=True)
                        truncate_mysql_table(aircontrol_db_configs,migrated_data_table, logger_error)
                        # Ingest data into table
                        df_partial_error, df_success = insert_batches_df_into_mysql(df, aircontrol_db_configs, migrated_data_table, logger_info, logger_error)
                        # goup_router_df = df[['ICCID', 'IMSI', 'MSISDN']]
                        # df_partial_error_goup, df_success_goup = insert_batches_df_into_mysql(goup_router_df, goup_db_configs, migrated_data_table, logger_info, logger_error)
                        
                        logger_info.info('Data ingested into table {}'.format(migrated_data_table))
                        end_time = round((time.time() - start_time), 2)
                        curr_date = today.strftime("%Y%m%d")
                        
                        insert_into_summary_table(metadata_db_configs, 'transformation_summary', logger_info, logger_error, migrated_data_table, len(df), len(df_success), len(df_partial_error), end_time, curr_date)
                        # insert_into_summary_table(metadata_db_configs, 'transformation_summary', logger_info, logger_error, 'goup_migration_assest', len(goup_router_df), len(df_success_goup), len(df_partial_error_goup), end_time, curr_date)
                    
                    elif migrated_data_table == 'migration_asset_extended':
                        df = update_column(df, 'ID', maxid_extended)
                        df.replace({np.nan: None}, inplace=True)
                        truncate_mysql_table(aircontrol_db_configs,migrated_data_table, logger_error)
                        df_partial_error, df_success = insert_batches_df_into_mysql(df,aircontrol_db_configs, migrated_data_table, logger_info, logger_error)

                    elif migrated_data_table in ['migration_assets_cdp', 'migration_device_plan_cdp']:
                        truncate_mysql_table(transformation_db_configs, migrated_data_table, logger_error)
                        df_partial_error, df_success = insert_batches_df_into_mysql(df, transformation_db_configs, migrated_data_table, logger_info, logger_error)

                    elif migrated_data_table in ['csr_mapping_master', 'csr_mapping_details']:
                        df.replace({np.nan: None}, inplace=True)
                        truncate_mysql_table(transformation_db_configs, migrated_data_table, logger_error)
                        df_partial_error, df_success = insert_batches_df_into_mysql(df, transformation_db_configs, migrated_data_table, logger_info, logger_error)

                    else:
                        logger_message = f'{migrated_data_table} no data insert'
                        logger_info.info(logger_message)
                        print(logger_message)
                
                else:
                    logger_info.info("df is empty")

            
                logger_info.info('Data ingested into table {}'.format(table_name))
                end_time = round((time.time() - start_time), 2)
                curr_date = today.strftime("%Y%m%d")
                insert_into_summary_table(metadata_db_configs, 'transformation_summary', logger_info, logger_error, migrated_data_table,len(df), len(df_success), len(df_partial_error), end_time, curr_date)        
            
            else:
                logger_info.info('SP {} no return data'.format(sp_call))


    except Exception as e:
        logger_error.error('Error while ingesting data into table {}'.format(migrated_data_table, e))


def data_transformation_insert_db(file_table_transformation_mapper):
    """
    Method to call stored procedure for each output file and place on destination path defined in config
    :return: None
    """
    logger_info.info("-------------- Pull transformed data from DP Started -------------------")
    print("-------------- Pull transformed data from DP Started -------------------")
    
    iso_code_id_dict = create_iso_code_id_dict(query_to_find_iso_id, metadata_db_configs, logger_error)
    currency_id_dict = create_iso_code_id_dict(query_to_find_currency_id, metadata_db_configs, logger_error)
    billing_freqency_id_dict = create_iso_code_id_dict(query_to_get_frequency, metadata_db_configs, logger_error)
    new_role_name_dict = create_iso_code_id_dict(query_to_get_new_role_mapping, metadata_db_configs, logger_error)
    company_address_list = sql_query_fetch(query_to_find_company_address, metadata_db_configs, logger_error)
    company_address_df = pd.DataFrame(company_address_list)
    company_address_df.columns = ['PARTY_ROLE_ID', 'COUNTRY', 'CITY', 'STREET', 'POSTAL_CODE', 'STATE','BUILDING']
    
    role_tab_list = sql_query_fetch(query_to_get_role_tab_screen_mapping, metadata_db_configs, logger_error)
    role_tab_list_df = pd.DataFrame(role_tab_list)
    role_tab_list_df.columns = ['roleName', 'roleToScreenList', 'roleToTabList']
    
    try:
        for table_validation, table_transformation in file_table_transformation_mapper:
            start_time = time.time()
            truncate_mysql_table(transformation_db_configs, table_transformation, logger_error)
            logger_info.info('Calling table_validation {} to fetch data'.format(table_validation))
            df = read_table_as_df(table_validation, validation_db_configs, logger_info, logger_error)
    
            if not df.empty:
                try:
                    count = 0
                    count += 1
                
                    if table_validation == 'ec_success':
                        df['TYPE'] = df['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
                        df['EC_STATUS'] = df['EC_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)
                        df['ACTIVATE_PUSH_CDR']=df['ACTIVATE_PUSH_CDR'].str.replace('YES_NO_DICTIONARY.', '', regex=False)

                        transformated_df = Enterprise_Customer_transformation(df, iso_code_id_dict, currency_id_dict,logger_info ,logger_error, company_address_df)
                        # print(transformated_df)
                    
                    elif table_validation == 'bu_success':
                        df['TYPE'] = df['TYPE'].str.replace('CUSTOMER_TYPE.', '', regex=False)
                        df['BU_STATUS'] = df['BU_STATUS'].str.replace('CUSTOMER_STATUS.', '', regex=False)
                        transformated_df = bussinesss_unit_transformation(df, iso_code_id_dict, currency_id_dict, logger_info, logger_error, company_address_df, billing_freqency_id_dict)
                        transformated_df.to_csv("bussiness_unit.csv", index=False)
                    
                    elif table_validation == 'users_success':
                        df['USERTYPE'] = df['USERTYPE'].str.replace('ROLES.', '', regex=False)
                        df['USERCATEGORY'] = df['USERCATEGORY'].str.replace('ROLES.', '', regex=False)

                        if table_transformation == 'role_success':
                            # print("hello2")
                            transformated_df = role_transformation(df, logger_info, logger_error, new_role_name_dict, role_tab_list_df)
                            transformated_df.to_csv("role_unit.csv", index=False)
                        else:
                            transformated_df = users_transformation(df, logger_info, logger_error, iso_code_id_dict, company_address_df, new_role_name_dict)
                            transformated_df.to_csv("users_unit1.csv", index=False)

                    elif table_validation == 'apn_success':
                        transformated_df = apn_transformations(df, logger_info, logger_error)
                        transformated_df.to_csv("apn_unit.csv", index=False)  

                    elif table_validation=='report_subscriptions_success':
                        transformated_df=report_subscriptions_creation_transformations(df, logger_info, logger_error)      

                    if table_validation=='cost_centers_success':
                        cost_center_list=sql_query_fetch(cost_center_query,validation_db_configs,logger_error) 
                        transformated_df = pd.DataFrame(cost_center_list)
                        transformated_df.columns = ['buAccountId', 'name', 'comments']
                    
                    if table_validation == 'ip_pool_success':
                        transformated_df = ip_pool_transformation(df, logger_info, logger_error)
                        transformated_df.to_csv("ip_pool_unit.csv", index=False)

                    transformated_df = transformated_df.applymap(lambda x: int(x) if isinstance(x, np.int64) else x)
                    
                    transformated_df.replace({np.nan: None}, inplace=True)
                    transformated_df.replace({pd.NaT: None}, inplace=True)
                    transformated_df.replace({pd.NA: None}, inplace=True)
                    transformated_df.replace({'': None}, inplace=True)

                    df_partial_error, df_success = insert_batches_df_into_mysql(transformated_df, transformation_db_configs, table_transformation, logger_info, logger_error)

                    end_time = round((time.time() - start_time), 2)
                    curr_date = today.strftime("%Y%m%d")
                    insert_into_summary_table(metadata_db_configs, 'transformation_summary', logger_info, logger_error, table_transformation, len(df), len(df_success), len(df_partial_error), end_time, curr_date)
                
                except Exception as e:
                    logger_error.error('table_transformation {} no data insert {}'.format(table_transformation, e))
            
            else:
                logger_error.error('table_tr {} no return data'.format(table_validation))

    except Exception as e:
        logger_info.error('Error while writing {} file data from db {}'.format(table_validation, e))
        logger_error.error('Error while writing {} file data from db {}'.format(table_validation, e))


if __name__ == "__main__": 
    
    file_table_transformation_mapper = [
        ('ec_success','ec_success'),  
        ('bu_success','bu_success'),
        ('users_success', 'user_success'),
        ('users_success', 'role_success'),
        ('apn_success', 'apn_success'),
        ('cost_centers_success','cost_center_success'),
        ('report_subscriptions_success','report_subscriptions_success'),
        ('ip_pool_success', 'ip_pool_success'),
   ]

    pull_procedure_file_sp_mapper = {
        'migration_assets': 'migration_assets',
        'migration_asset_extended': 'migration_asset_extended',
        'migration_assets_cdp': 'migration_assets_billing_bss',
        'migration_device_plan_cdp': 'migration_device_plan_cdp',
        'migration_tag_details': 'tag_details',
        'csr_mapping_master': 'csr_mapping_master',
        'csr_mapping_details': 'csr_mapping_details'
    }

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    

    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "ingestion":
            print("ingestion")
            # The partiular requirement is to truncate the transformation summary table 
            # before executing the transformation so that we can have the fresh data
            truncate_mysql_table(metadata_db_configs, 'transformation_summary', logger_error)
            
            # Then starting the migration of file_table_mappers 
            data_transformation_insert_db(file_table_transformation_mapper)
        
        if arg == "csr":
            file_sp_mapper = {
                'csr_mapping_master': 'csr_mapping_master',
                'csr_mapping_details': 'csr_mapping_details'
            }
            pull_transformed_data_from_sp(file_sp_mapper=file_sp_mapper)
        
        if arg == "user":
            print("user")
            data_transformation_insert_db([('users_success', 'user_success')])
        
        if arg == "roles":
            print("roles")
            data_transformation_insert_db([('users_success', 'role_success')])

        if arg == "reports":
            print("reports")
            data_transformation_insert_db([('report_subscriptions_success','report_subscriptions_success')])

        if arg == "ec":
            print("ec")
            data_transformation_insert_db([('ec_success', 'ec_success')])
        
        if arg == "bu":
            print("bu")
            data_transformation_insert_db([('bu_success', 'bu_success')])
        
        if arg == "apn":
            print("apn")
            data_transformation_insert_db([('apn_success', 'apn_success')])
        
        if arg == "cost_center":
            print("cost_center")
            data_transformation_insert_db([('cost_centers_success', 'cost_center_success')])

        if arg == "ip_pool":
            print("ip pool")
            data_transformation_insert_db([('ip_pool_success', 'ip_pool_success')])

        if arg == "procedure":
            print("procedure")
            pull_transformed_data_from_sp(file_sp_mapper=pull_procedure_file_sp_mapper)
