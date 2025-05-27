import sys
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *
from src.utils.library import *
from collections import defaultdict
today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))

insertion_error_dir = os.path.join(dir_path,'insertion_error')
procedure_error_dir = os.path.join(dir_path,'procedure_error_aircontrol')

input_date_formate="%d-%b-%y %I.%M.%S.%f %p"
logs = {
    "migration_info_logger":f"A1_data_ingesstion_info_{current_time_stamp}.log",
    "migration_error_logger":f"A1_data_ingestion_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{transformation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()




def push_input_to_migration(file_table_mapper,input_file_path):
 

    logger_info.info("--------------Push Input Data Started-------------------")
    print("--------------Push Input Data Started------------------------------")


    # Use defaultdict to handle multiple files for the same table
    table_file_mapper = defaultdict(list)
    for file_name, table_name in file_table_mapper.items():
        table_file_mapper[table_name].append(file_name)

    print("db details", transformation_db_configs)

    for table_name, file_names in table_file_mapper.items():
        if len(file_names) and any(os.path.exists(os.path.join(input_file_path, file_name)) for file_name in file_names):
            logger_info.info(f"Truncating table: {table_name}")
            # Uncomment the following line for actual use
            print(f"Truncating table: {table_name}")
            truncate_mysql_table(transformation_db_configs, table_name, logger_error)
        else:
            print(f"No input files found under: {input_file_path} for table: {table_name}")
            logger_error.error(f"No input files found under: {input_file_path} for table: {table_name}")
            continue

        for csv_file_name in file_names:
            csv_file_path = os.path.join(input_file_path, csv_file_name)

            try:
                insertion_error_filename = os.path.basename(csv_file_path)
                
                
                data_df = pd.read_csv(csv_file_path, skipinitialspace=True, dtype=str, keep_default_na=False)
                print(data_df)
                
                data_df.replace({np.nan: None}, inplace=True)
                data_df.fillna("", inplace=True)
                data_df.columns = data_df.columns.str.replace(' ', '_')

                logger_info.info(f"Loaded file: {csv_file_path}")
                logger_info.info(f"Row count: {len(data_df)}")
                logger_info.info(f"Target table: {table_name}, Columns: {data_df.columns}")

                data_df.replace({np.nan: None}, inplace=True)
                data_df.replace({pd.NaT: None}, inplace=True)
                data_df.replace({'': None}, inplace=True)
                dr_error, df_success = insert_batches_df_into_mysql(data_df, transformation_db_configs, table_name, logger_info, logger_error)
                # dr_error,df_success=insert_batches_df_into_mysqlfrom_yogesh(data_df, transformation_db_configs, table_name, logger_info, logger_error)
                print(f"tablename: {table_name}, len_of_success: {len(df_success)}")
                if not dr_error.empty:
                    dr_error.to_csv(os.path.join(insertion_error_dir, insertion_error_filename), index=False)

            except Exception as e:
                print(f'Error while inserting {insertion_error_filename} file data into db: {e}')
                logger_info.error(f'Error while inserting {insertion_error_filename} file data into db: {e}')
                logger_error.error(f'Error while inserting {insertion_error_filename} data into db: {e}')

            # Uncomment the following line for actual use
            # move_to_history(current_date, csv_file_path)

    logger_info.info("-------------- Data Processing Ended-------------------")



if __name__ == "__main__":
    file_table_mapper= {
        'ec_success.csv':'ec_success',
        'bu_success.csv':'bu_success',
        'role_success.csv':'role_success',
        'apn_success.csv':'apn_success',
        'user_success.csv':'user_success',
    }

    push_input_to_migration(file_table_mapper,input_file_path)
  