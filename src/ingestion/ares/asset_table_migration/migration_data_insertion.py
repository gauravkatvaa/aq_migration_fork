import sys

# Add the parent directory to sys.path
sys.path.append("..")

from src.utils.library import *
from conf.config import *
from conf.custom.ares.config import *  
from datetime import datetime
import numpy as np
import pandas as pd
import os

dir_path = dirname(abspath(__file__))

today = datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

# Define directories for logs and error files
insertion_error_dir = os.path.join(dir_path, 'insertion_error')
procedure_error_dir = os.path.join(dir_path, 'procedure_error')

# Create directories if they don't exist
if not os.path.exists(insertion_error_dir):
    os.makedirs(insertion_error_dir)
    
if not os.path.exists(procedure_error_dir):
    os.makedirs(procedure_error_dir)

# Log configuration
logs = {
    "migration_info_logger": f"a1_ingestion_asset_info_{current_time_stamp}.log",
    "migration_error_logger": f"a1_ingestion_asset_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{ingestion_log_dir}'

# Create the log directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

# File names for error logging
assets_insertion_error_filename = f"assets_insertion_error_{current_time_stamp}.csv"
assets_extended_insertion_error_filename = f"assets_extended_insertion_error_{current_time_stamp}.csv"
asset_error_file_name = f"asset_error_{current_time_stamp}.csv"
asset_extended_error_file_name = f"asset_extended_error_{current_time_stamp}.csv"


def convert_timestamps_to_string(df, date_columns):
    """
    Converts timestamp values in dataframe to string format.
    
    :param df: DataFrame to process
    :param date_columns: List of date column names
    :return: DataFrame with converted dates
    """
    for col in date_columns:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors='coerce')
            df[col] = df[col].apply(
                lambda x: x.strftime('%Y-%m-%d %H:%M:%S') if not pd.isna(x) else None
            )
    return df


def update_column(df, column_name, initial_value):
    """
    Updates a column in the DataFrame with incrementing values.
    
    :param df: required dataframe
    :param column_name: required column names of dataframe
    :param initial_value: initial value to start incrementing from
    :return: Updated DataFrame
    """
    for i in range(len(df)):
        df.at[i, column_name] = initial_value + i
    return df


def generate_procedure_error_file(query, db_config, column_names, procedure_error_directory, error_file_name, logger_error, logger_info):
    """
    Generates error files for failed entries during procedure execution.
    
    :param query: query to fetch the result
    :param db_config: database config details
    :param column_names: column names of the table to generate the file
    :param procedure_error_directory: procedure error directory path
    :param error_file_name: error file name of records failed during procedure execution
    :param logger_error: logger error
    :param logger_info: logger info
    :return: None
    """
    try:
        fetch_error_success_data = sql_query_fetch(query, db_config, logger_error)
        if len(fetch_error_success_data) != 0:
            logger_info.error(f"Error Entries: {len(fetch_error_success_data)}")
            logger_error.error(f"Error Entries: {len(fetch_error_success_data)}")
            df_error = pd.DataFrame(fetch_error_success_data, columns=column_names)
            df_error.to_csv(os.path.join(procedure_error_directory, error_file_name), index=False)
        else:
            logger_info.info("No Error data retrieved from the database.")
    except Exception as e:
        logger_info.error(f"Error fetching error data: {e}")
        logger_error.error(f"Error fetching error data: {e}")


def prepare_extended_data(data_assets_df, maxid_extended):
    """
    Prepares the assets_extended data from the source data.
    
    :param data_assets_df: Source asset data
    :param maxid_extended: Starting ID for the records
    :return: Prepared DataFrame for assets_extended
    """
    logger_info.info("Preparing extended asset data")
    
    # Map columns based on the assets_extended table structure
    data_extended_df = pd.DataFrame()
    
    # Add ID column and incremental values
    data_extended_df['ID'] = range(maxid_extended, maxid_extended + len(data_assets_df))
    
    # Map the date column
    if 'CREATIONDATE' in data_assets_df.columns:
        data_extended_df['CREATE_DATE'] = data_assets_df['CREATIONDATE']
    else:
        data_extended_df['CREATE_DATE'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # Set SIM type based on data
    # Assuming physical SIMs (type_id=3) if not specified
    data_extended_df['sim_type_id'] = 3
    
    # Set sim_category
    data_extended_df['sim_category'] = '830'  # Default category
    
    # Other default values
    data_extended_df['voice_template'] = None
    data_extended_df['sms_template'] = None
    data_extended_df['data_template'] = None
    data_extended_df['ORDER_NUMBER'] = None
    data_extended_df['SERVICE_GRANT'] = '0'  # Default to No
    data_extended_df['IMEI_LOCK'] = '0'      # Default to No
    data_extended_df['OLD_PROFILE_STATE'] = None
    data_extended_df['CURRENT_PROFILE_STATE'] = None
    data_extended_df['custom_param_1'] = None
    data_extended_df['custom_param_2'] = None
    data_extended_df['custom_param_3'] = None
    data_extended_df['custom_param_4'] = None
    data_extended_df['custom_param_5'] = None
    data_extended_df['BULK_SERVICE_NAME'] = None
    data_extended_df['FVS_DATA'] = None
    data_extended_df['lock_by_user'] = None
    data_extended_df['imei_lock_setup_date'] = None
    data_extended_df['imei_lock_disable_date'] = None
    
    # Convert date columns
    date_columns = ['CREATE_DATE', 'imei_lock_setup_date', 'imei_lock_disable_date']
    data_extended_df = convert_timestamps_to_string(data_extended_df, date_columns)
    
    # Replace NaN values with None
    data_extended_df.replace({np.nan: None}, inplace=True)
    
    logger_info.info(f"Extended asset data prepared: {len(data_extended_df)} records")
    return data_extended_df


def get_device_plan_id_mapping(db_config):
    """
    Extract device plan name to device plan ID mapping from the device_rate_plan table
    in the Aircontrol database.
    
    Args:
        db_config (dict): Database configuration with host, user, password, database name
        
    Returns:
        dict: A dictionary with device plan names as keys and device plan IDs as values
    """
    logger = logging.getLogger(__name__)
    device_plan_mapping = {}
    
    try:
        query = """
            SELECT PLAN_NAME, ID 
            FROM device_rate_plan 
            WHERE DELETED = 0
        """
        
        result = sql_query_fetch(query, db_config, logger_error)
        
        # Process results
        for row in result:
            if row[0] and row[1]:
                device_plan_mapping[row[0]] = row[1]
        
        logger.info(f"Retrieved {len(device_plan_mapping)} device plans")
            
    except Exception as e:
        logger.error(f"Error retrieving device plans from database: {str(e)}")
        return None
    
    return device_plan_mapping


def get_device_plan_name_service_plan_id_mapping(db_config):
    """
    Fetches the mapping of device plan names to service plan IDs from the database.
    
    :param db_config: Database configuration
    :return: Dictionary mapping device plan names to service plan IDs
    """
    logger = logging.getLogger(__name__)
    device_plan_mapping = {}
    
    try:
        query = """
            SELECT ID, BUNDLE
            FROM service_profiles_success
        """
        
        result = sql_query_fetch(query, db_config, logger_error)
        
        # Process results
        for row in result:
            if row[0] and row[1]:
                device_plan_mapping[row[0]] = row[1]
        
        logger.info(f"Retrieved {len(device_plan_mapping)} device plans")
            
    except Exception as e:
        logger.error(f"Error retrieving device plans from database: {str(e)}")
        return None
    
    return device_plan_mapping


def prepare_asset_data(data_assets_df, maxid_extended):
    """
    Prepares the assets data from the source data.
    
    :param data_assets_df: Source asset data
    :param maxid_extended: Starting ID for the records
    :return: Prepared DataFrame for assets
    """
    logger_info.info("Preparing main asset data")
    logger_info.info(f"Fetching device plan data from database")
    device_plan_mapping = get_device_plan_id_mapping(aircontrol_db_configs)

    print(f"Device plan mapping: {device_plan_mapping}")

    # Fetch device plan name to service plan ID mapping
    service_profile_id_device_plan_name = get_device_plan_name_service_plan_id_mapping(validation_db_configs)
    print(f"Device plan name mapping: {service_profile_id_device_plan_name}")
    
    # Create a new DataFrame for migration_assets
    df_migration_assets = pd.DataFrame()
    
    # Add ID column and incremental values
    df_migration_assets['ID'] = range(maxid_extended, maxid_extended + len(data_assets_df))
    
    # Set ASSETS_EXTENDED_ID to match ID
    df_migration_assets['ASSETS_EXTENDED_ID'] = df_migration_assets['ID']
    
    # Map columns from source data to target schema
    # Core SIM identifiers
    if 'IMSI' in data_assets_df.columns:
        df_migration_assets['IMSI'] = data_assets_df['IMSI']
    
    if 'ICCID' in data_assets_df.columns:
        df_migration_assets['ICCID'] = data_assets_df['ICCID']
        df_migration_assets['DONOR_ICCID'] = data_assets_df['ICCID']  # Using ICCID as DONOR_ICCID
    
    if 'MSISDN' in data_assets_df.columns:
        df_migration_assets['MSISDN'] = data_assets_df['MSISDN']
    
    # Other identifiers and statuses
    if 'IMEI' in data_assets_df.columns:
        df_migration_assets['IMEI'] = data_assets_df['IMEI']
        df_migration_assets['CURRENT_IMEI'] = data_assets_df['IMEI']
    
    if 'IP_ADDRESS' in data_assets_df.columns:
        df_migration_assets['IP_ADDRESS'] = data_assets_df['IP_ADDRESS'].fillna('000.000.000.000')
    else:
        df_migration_assets['IP_ADDRESS'] = '000.000.000.000'
    
    if 'SIM_STATUS' in data_assets_df.columns:
        df_migration_assets['STATE'] = data_assets_df['SIM_STATUS']
        df_migration_assets['STATUS'] = data_assets_df['SIM_STATUS']
    else:
        df_migration_assets['STATE'] = 'Activated'
        df_migration_assets['STATUS'] = 'Activated'
    
    # Date fields
    if 'CREATIONDATE' in data_assets_df.columns:
        df_migration_assets['CREATE_DATE'] = data_assets_df['CREATIONDATE']
    else:
        df_migration_assets['CREATE_DATE'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    if 'ACTIVATIONDATE' in data_assets_df.columns:
        df_migration_assets['ACTIVATION_DATE'] = data_assets_df['ACTIVATIONDATE']
        df_migration_assets['STATE_MODIFIED_DATE'] = data_assets_df['ACTIVATIONDATE']
    else:
        df_migration_assets['ACTIVATION_DATE'] = df_migration_assets['CREATE_DATE']
        df_migration_assets['STATE_MODIFIED_DATE'] = df_migration_assets['CREATE_DATE']
    
    # Service profile, account and device plan info
    if 'SERVICE_PROFILE_ID' in data_assets_df.columns:
        df_migration_assets['SERVICE_PLAN_ID'] = data_assets_df['SERVICE_PROFILE_ID']
    
    # These fields would typically be mapped from the customer's business structure
    # For A1 migration, we need to ensure they match existing accounts in the system
    df_migration_assets['ENT_ACCOUNTID'] = data_assets_df['EC_ID']
    # Map SERVICE_PROFILE_ID to DEVICE_PLAN_NAME using the first mapper
    df_migration_assets['DEVICE_PLAN_NAME'] = df_migration_assets['SERVICE_PLAN_ID'].map(service_profile_id_device_plan_name)

    # Map DEVICE_PLAN_NAME to DEVICE_PLAN_ID using the second mapper
    df_migration_assets['DEVICE_PLAN_ID'] = df_migration_assets['DEVICE_PLAN_NAME'].map(device_plan_mapping)

    df_migration_assets.drop(columns=['DEVICE_PLAN_NAME'], inplace=True)

    df_migration_assets['DEVICE_PLAN_DATE'] = df_migration_assets['CREATE_DATE']
    
    # Default country
    df_migration_assets['COUNTRIES_ID'] = 'Austria'  # Should be updated to match countries in the database
    
    # Boolean fields as strings (since the table expects strings)
    df_migration_assets['IN_SESSION'] = '0'
    df_migration_assets['USAGES_NOTIFICATION'] = '0'
    
    # Default counters
    df_migration_assets['TOTAL_DATA_USAGE'] = '0'
    df_migration_assets['TOTAL_DATA_DOWNLOAD'] = '0'
    df_migration_assets['TOTAL_DATA_UPLOAD'] = '0'
    df_migration_assets['DATA_USAGE_THRESHOLD'] = '0'
    
    # Other fields that may be mapped from source data if available
    df_migration_assets['APN'] = None
    df_migration_assets['DATA_USAGE_LIMIT'] = None
    df_migration_assets['DEVICE_ID'] = None
    df_migration_assets['DEVICE_IP_ADDRESS'] = None
    df_migration_assets['DYNAMIC_IMSI'] = None
    df_migration_assets['DONOR_IMSI'] = None
    df_migration_assets['MODEM_ID'] = None
    df_migration_assets['SESSION_START_TIME'] = None
    df_migration_assets['SMS_USAGE_LIMIT'] = None
    df_migration_assets['VOICE_USAGE_LIMIT'] = None
    df_migration_assets['SUBSCRIBER_NAME'] = None
    df_migration_assets['SUBSCRIBER_LAST_NAME'] = None
    df_migration_assets['SUBSCRIBER_GENDER'] = None
    df_migration_assets['SUBSCRIBER_DOB'] = None
    df_migration_assets['ALTERNATE_CONTACT_NUMBER'] = None
    df_migration_assets['SUBSCRIBER_EMAIL'] = None
    df_migration_assets['SUBSCRIBER_ADDRESS'] = None
    df_migration_assets['CUSTOM_PARAM_1'] = None
    df_migration_assets['CUSTOM_PARAM_2'] = None
    df_migration_assets['CUSTOM_PARAM_3'] = None
    df_migration_assets['CUSTOM_PARAM_4'] = None
    df_migration_assets['CUSTOM_PARAM_5'] = None
    df_migration_assets['LOCATION_COVERAGE_ID'] = None
    df_migration_assets['NEXT_LOCATION_COVERAGE_ID'] = None
    df_migration_assets['BILLING_CYCLE'] = '1'  # Default to 1
    df_migration_assets['RATE_PLAN_ID'] = None
    df_migration_assets['NEXT_RATE_PLAN_ID'] = None
    df_migration_assets['MNO_ACCOUNTID'] = None
    df_migration_assets['LAST_KNOWN_LOCATION'] = None
    df_migration_assets['LAST_KNOWN_NETWORK'] = None
    df_migration_assets['BSS_ID'] = None
    df_migration_assets['GOUP_ID'] = None
    df_migration_assets['LOCK_REFERENCE'] = None
    df_migration_assets['SIM_POOL_ID'] = None
    df_migration_assets['WHOLESALE_PLAN_ID'] = None
    df_migration_assets['PROFILE_STATE'] = None
    df_migration_assets['EUICC_ID'] = None
    df_migration_assets['OPERATIONAL_PROFILE_DATA_PLAN'] = None
    df_migration_assets['BOOTSTRAP_PROFILE'] = None
    df_migration_assets['EXT_METADATA'] = None
    
    # Convert date columns
    date_columns = ['CREATE_DATE', 'ACTIVATION_DATE', 'STATE_MODIFIED_DATE', 'DEVICE_PLAN_DATE']
    df_migration_assets = convert_timestamps_to_string(df_migration_assets, date_columns)
    
    # Replace NaN values with None
    df_migration_assets.replace({np.nan: None}, inplace=True)
    
    logger_info.info(f"Main asset data prepared: {len(df_migration_assets)} records")
    return df_migration_assets


def a1_asset_migration():
    """
    Handles the migration of SIM assets for A1.
    
    This function:
    1. Truncates the target tables
    2. Reads asset data from the validation database
    3. Processes and inserts the data into migration tables
    4. Calls the migration procedure
    5. Generates error files for any failures
    
    :return: None
    """
    logger_info.info("--------------A1 SIM Asset Migration Started-------------------")
    print("--------------A1 SIM Asset Migration Started------------------------------")

    try:
        # Truncate target tables
        truncate_mysql_table(aircontrol_db_configs, 'migration_assets_extended', logger_error)
        truncate_mysql_table(aircontrol_db_configs, 'migration_assets', logger_error)

        # Get the maximum ID to use as starting point for new records
        asset_extended_fetch_max_id = "SELECT MAX(id) AS max_id FROM (SELECT id FROM assets UNION SELECT id FROM assets_extended) AS combined_ids;"
        maxid_extended_result = sql_query_fetch(asset_extended_fetch_max_id, aircontrol_db_configs, logger_error)
        maxid_extended = maxid_extended_result[0][0] if maxid_extended_result and maxid_extended_result[0][0] else 0
        maxid_extended = int(maxid_extended) + 1  # Increment by 1 for new IDs
        print(f"Maximum ID: {maxid_extended}")
        
        # Read asset data from validation database
        data_assets_df = read_table_as_df("asset_success", validation_db_configs, logger_info, logger_error)
        
        if data_assets_df.empty:
            logger_error.error("No data found in asset_success table")
            print("No data found in asset_success table")
            return
        
        # Log the source data information
        logger_info.info(f"Source data loaded: {len(data_assets_df)} records")
        logger_info.info(f"Source columns: {', '.join(data_assets_df.columns)}")
        
        # Prepare extended asset data
        data_extended_df = prepare_extended_data(data_assets_df, maxid_extended)
        
        # Insert extended asset data
        logger_info.info(f"Inserting {len(data_extended_df)} records into migration_assets_extended")
        print(f"Inserting {len(data_extended_df)} records into migration_assets_extended")
        
        # Save a copy for validation
        data_extended_df.to_csv(os.path.join(dir_path, f"migration_assets_extended_dump_{current_time_stamp}.csv"), index=False)
        
        dr_error_extended, df_success_extended = insert_batches_df_into_mysql(
            data_extended_df, 
            aircontrol_db_configs, 
            "migration_assets_extended", 
            logger_info, 
            logger_error
        )
        
        if not dr_error_extended.empty:
            logger_error.error(f"Error inserting into migration_assets_extended: {len(dr_error_extended)} records")
            dr_error_extended.to_csv(
                os.path.join(insertion_error_dir, assets_extended_insertion_error_filename), 
                index=False
            )
        
        # Prepare main asset data
        df_migration_assets = prepare_asset_data(data_assets_df, maxid_extended)
        
        # Save a copy for validation
        df_migration_assets.to_csv(os.path.join(dir_path, f"migration_assets_dump_{current_time_stamp}.csv"), index=False)
        
        # Insert main asset data
        logger_info.info(f"Inserting {len(df_migration_assets)} records into migration_assets")
        print(f"Inserting {len(df_migration_assets)} records into migration_assets")
        
        dr_error_asset, df_success_asset = insert_batches_df_into_mysql(
            df_migration_assets, 
            aircontrol_db_configs, 
            "migration_assets", 
            logger_info, 
            logger_error
        )
        
        if not dr_error_asset.empty:
            logger_error.error(f"Error inserting into migration_assets: {len(dr_error_asset)} records")
            dr_error_asset.to_csv(
                os.path.join(insertion_error_dir, assets_insertion_error_filename), 
                index=False
            )
        
        # Call migration procedure
        logger_info.info("Calling migration procedure")
        print("Calling migration procedure")
        
        call_procedure("migration_sim_bulk_insert", aircontrol_db_configs, logger_error, logger_info)
        
        # Generate error files for any failed records
        migration_asset_error = "SELECT * FROM migration_assets_error_history;"
        migration_asset_extended_error = "SELECT * FROM migration_assets_extended_error_history;"
        
        # Get column names from error history tables
        asset_error_columns_query = "SHOW COLUMNS FROM migration_assets_error_history;"
        asset_extended_error_columns_query = "SHOW COLUMNS FROM migration_assets_extended_error_history;"
        
        asset_error_columns_result = sql_query_fetch(asset_error_columns_query, aircontrol_db_configs, logger_error)
        asset_extended_error_columns_result = sql_query_fetch(asset_extended_error_columns_query, aircontrol_db_configs, logger_error)
        
        asset_error_column_names = [row[0] for row in asset_error_columns_result] if asset_error_columns_result else []
        asset_extended_error_column_names = [row[0] for row in asset_extended_error_columns_result] if asset_extended_error_columns_result else []
        
        if asset_error_column_names:
            generate_procedure_error_file(
                migration_asset_error, 
                aircontrol_db_configs, 
                asset_error_column_names,
                procedure_error_dir, 
                asset_error_file_name, 
                logger_error,
                logger_info
            )
        
        if asset_extended_error_column_names:
            generate_procedure_error_file(
                migration_asset_extended_error, 
                aircontrol_db_configs, 
                asset_extended_error_column_names,
                procedure_error_dir, 
                asset_extended_error_file_name, 
                logger_error, 
                logger_info
            )
        
        # Log summary
        logger_info.info(f"Migration completed - Assets: Success={len(df_success_asset)}, Error={len(dr_error_asset)}")
        logger_info.info(f"Migration completed - Extended Assets: Success={len(df_success_extended)}, Error={len(dr_error_extended)}")
        print(f"Migration completed - Assets: Success={len(df_success_asset)}, Error={len(dr_error_asset)}")
        print(f"Migration completed - Extended Assets: Success={len(df_success_extended)}, Error={len(dr_error_extended)}")
        
    except Exception as e:
        logger_info.error(f'Error in A1 asset migration: {e}')
        logger_error.error(f'Error in A1 asset migration: {e}')
        print(f"Error in A1 asset migration: {e}")
    
    logger_info.info("--------------A1 SIM Asset Migration Ended-------------------")
    print("--------------A1 SIM Asset Migration Ended----------------------------")


if __name__ == "__main__":
    print("Number of arguments:", len(sys.argv))
    print("Argument List:", str(sys.argv))
    
    # Default behavior: run asset migration if no specific argument is provided
    if len(sys.argv) == 1:
        a1_asset_migration()
    else:
        # Process command line arguments
        for arg in sys.argv[1:]:
            if arg == "asset":
                print("Running A1 asset migration")
                a1_asset_migration()
