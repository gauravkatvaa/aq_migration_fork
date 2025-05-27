import sys

sys.path.append("..")

from src.utils.library import *
from conf.config import *
from all_transformed_functions import *
from conf.custom.ares.config import *
from transform_procedure import *
import time 
import datetime

from concurrent.futures import ThreadPoolExecutor, as_completed


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
def process_table(table_validation, table_transformation, iso_code_id_dict, currency_id_dict, billing_freqency_id_dict,
                  new_role_name_dict, company_address_df, role_tab_list_df, logger_info, logger_error):
    """
    Process a single table by applying transformations and inserting the data into the database.
    This function will be executed in parallel using threads.
    """
    try:
        start_time = time.time()
        truncate_mysql_table(transformation_db_configs, table_transformation, logger_error)
        logger_info.info('Calling table_validation {} to fetch data'.format(table_validation))
        
        df = read_table_as_df(table_validation, validation_db_configs, logger_info, logger_error)

        if not df.empty:
            try:
                if table_validation == 'ec_success':
                    transformated_df = Enterprise_Customer_transformation(df, iso_code_id_dict, currency_id_dict, logger_info, logger_error, company_address_df)
                
                elif table_validation == 'bu_success':
                    transformated_df = bussinesss_unit_transformation(df, iso_code_id_dict, currency_id_dict, logger_info, logger_error, company_address_df, billing_freqency_id_dict)
                
                elif table_validation == 'users_success':
                    if table_transformation == 'role_success':
                        transformated_df = role_transformation(df, logger_info, logger_error, new_role_name_dict, role_tab_list_df)
                    else:
                        transformated_df = users_transformation(df, logger_info, logger_error, iso_code_id_dict, company_address_df, new_role_name_dict)

                elif table_validation == 'apn_success':
                    transformated_df = apn_transformations(df, logger_info, logger_error)

                # Replace missing values with None
                transformated_df.replace({np.nan: None, pd.NaT: None, pd.NA: None, '': None}, inplace=True)

                # Insert transformed data into the database
                df_partial_error, df_success = insert_batches_df_into_mysql(transformated_df, transformation_db_configs, table_transformation, logger_info, logger_error)

                end_time = round((time.time() - start_time), 2)
                curr_date = today.strftime("%Y%m%d")
                insert_into_summary_table(metadata_db_configs, 'transformation_summary', logger_info, logger_error, table_transformation, len(df), len(df_success), len(df_partial_error), end_time, curr_date)
            
            except Exception as e:
                logger_error.error(f'table_transformation {table_transformation} no data insert: {e}')
        else:
            logger_error.error(f'table_validation {table_validation} returned no data.')

    except Exception as e:
        logger_error.error(f'Error processing {table_validation}: {e}')


def data_transformation_insert_db(file_table_transformation_mapper):
    """
    Method to call stored procedure for each output file and place on destination path defined in config
    using multithreading to process tables concurrently.
    :return: None
    """
    logger_info.info("-------------- Pull transformed data from DP Started -------------------")
    
    # Load necessary lookup data
    iso_code_id_dict = create_iso_code_id_dict(query_to_find_iso_id, metadata_db_configs, logger_error)
    currency_id_dict = create_iso_code_id_dict(query_to_find_currency_id, metadata_db_configs, logger_error)
    billing_freqency_id_dict = create_iso_code_id_dict(query_to_get_frequency, metadata_db_configs, logger_error)
    new_role_name_dict = create_iso_code_id_dict(query_to_get_new_role_mapping, metadata_db_configs, logger_error)
    company_address_list = sql_query_fetch(query_to_find_company_address, metadata_db_configs, logger_error)
    company_address_df = pd.DataFrame(company_address_list, columns=['PARTY_ROLE_ID', 'COUNTRY', 'CITY', 'STREET', 'POSTAL_CODE', 'STATE'])
    role_tab_list = sql_query_fetch(query_to_get_role_tab_screen_mapping, metadata_db_configs, logger_error)
    role_tab_list_df = pd.DataFrame(role_tab_list, columns=['roleName', 'roleToScreenList', 'roleToTabList'])

    try:
        # Use ThreadPoolExecutor to process tables concurrently
        with ThreadPoolExecutor(max_workers=5) as executor:
            futures = []
            for table_validation, table_transformation in file_table_transformation_mapper:
                futures.append(
                    executor.submit(process_table, table_validation, table_transformation, iso_code_id_dict, currency_id_dict, 
                                    billing_freqency_id_dict, new_role_name_dict, company_address_df, role_tab_list_df, 
                                    logger_info, logger_error)
                )

            # Wait for all threads to complete
            for future in as_completed(futures):
                try:
                    future.result()
                except Exception as e:
                    logger_error.error(f'Error in thread execution: {e}')

    except Exception as e:
        logger_error.error(f'Error in data transformation: {e}')


if __name__ == "__main__":
    file_table_transformation_mapper_role = [
        ('ec_success', 'ec_success'),
        ('bu_success', 'bu_success'),
        ('users_success', 'user_success'),
        ('users_success', 'role_success'),
        ('apn_success', 'apn_success'),
    ]

    file_table_transformation_mapper_user = [
        ('apn_success', 'apn_success'),
    ]

    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))

    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "role":
            print("Processing role tables")
            data_transformation_insert_db(file_table_transformation_mapper_role)
        elif arg == "user":
            print("Processing user tables")
            data_transformation_insert_db(file_table_transformation_mapper_user)
