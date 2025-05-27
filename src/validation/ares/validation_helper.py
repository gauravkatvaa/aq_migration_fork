"""
file: validation_helper.py
author: Gaurav
description: contains helper functions for validation

This file majorly communicates with the MYSQL (migration db) with input ORACLE db

Major functionality includes:
    - fill_up_the_latest_error_codes_table in ORACLE DB (client Input data)
    - get_latest_error_codes from MYSQL DB (migration data)
"""


from logging import Logger
import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.library import *
from src.utils.utils_lib import *
from conf.custom.ares.config import *
import datetime

today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")

logs = {
    "migration_info_logger":f"a1_validation_info_{current_time_stamp}.log",
    "migration_error_logger":f"a1_validation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{validation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()


def migrate_error_codes_table_data_to_oracle():
    """
    This function will migrate the error_codes table data from MYSQL to ORACLE
    """

    for mapper in mysql_oracle_error_codes_tables_mapper:
        mysql_table, oracle_table = mapper, mysql_oracle_error_codes_tables_mapper[mapper]

        # create table in oracle
        try:
            oracle_connection = cx_Oracle.connect(
                    f"{oracle_source_db['USER']}/{oracle_source_db['PASSWORD']}@{oracle_source_db['HOST']}:"
                    f"{oracle_source_db['PORT']}/{oracle_source_db['DATABASE_SID']}"
                )
            
            oracle_cursor = oracle_connection.cursor()
            
            query = f"CREATE TABLE {oracle_table} (CODE VARCHAR(100) NULL, message VARCHAR(1000) NULL)"

            oracle_cursor.execute(query)
        
        except Exception as e:
            print(f'Table already exists: {oracle_table}')
            logger_error.error(f"Table already exists {oracle_table}")

        error_code_df = read_table_as_df(mysql_table, validation_db_configs, logger_info, logger_error)

        if error_code_df.empty:
            logger_error.error('Error Codes table is empty')
            return
                
        truncate_oracle_table(oracle_source_db, oracle_table, logger_info, logger_error)
        insert_into_oracle_table(oracle_source_db, oracle_table, error_code_df, logger_info, logger_error)


def create_rejection_tables_as_mysql_into_oracle(connection_params):
    """
    This function will create the rejection tables in ORACLE based on MySQL table structures
    
    Args:
        connection_params (dict): Oracle database connection parameters
    """
    # Mapper for MySQL failure tables to Oracle validation reject tables
    for mysql_table, oracle_table in mysql_table_oracle_table_mapper.items():
        try:
            # Connect to Oracle database
            connection = cx_Oracle.connect(
                f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
                f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
            )
            cursor = connection.cursor()
            
            # Get the structure of the MySQL failure table
            mysql_structure = get_mysql_table_structure(mysql_table, validation_db_configs, logger_info, logger_error)
            
            if not mysql_structure:
                logger_error.error(f"Could not get structure for MySQL table: {mysql_table}")
                continue
            
            # Drop the Oracle rejection table if it exists
            try:
                cursor.execute(f"DROP TABLE {oracle_table}")
                connection.commit()
                logger_info.info(f"Dropped existing rejection table: {oracle_table}")
            except cx_Oracle.DatabaseError as e:
                # ORA-00942: table or view does not exist - safe to ignore
                if e.args[0].code != 942:
                    logger_error.error(f"Error dropping table {oracle_table}: {e}")
            
            # Generate CREATE TABLE statement for Oracle
            create_table_sql = generate_oracle_create_table_sql(oracle_table, mysql_structure)
            
            # Create the rejection table
            cursor.execute(create_table_sql)
            connection.commit()
            print(f"Created rejection table: {oracle_table} in Oracle")
            logger_info.info(f"Created rejection table: {oracle_table} in Oracle")
            
        except cx_Oracle.DatabaseError as e:
            logger_error.error(f"Oracle database error: {e}")
        except Exception as e:
            logger_error.error(f"Error creating rejection table for {mysql_table}: {e}")
        finally:
            if 'connection' in locals() and connection:
                try:
                    cursor.close()
                except:
                    pass
                try:
                    connection.close()
                except:
                    pass
    
    logger_info.info("Completed creating rejection tables in Oracle")


def get_mysql_table_structure(table_name, db_config, logger_info, logger_error):
    """
    Get the structure of a MySQL table
    
    Args:
        table_name (str): Name of the MySQL table
        db_config (dict): MySQL database connection parameters
        logger_info (Logger): Logger for information messages
        logger_error (Logger): Logger for error messages
        
    Returns:
        list: List of dictionaries containing column information
    """
    try:
        mysql_connection = mysql.connector.connect(
            host=db_config["HOST"],
            user=db_config["USER"],
            password=db_config["PASSWORD"],
            database=db_config["DATABASE"],
            port=db_config["PORT"]
        )
        
        cursor = mysql_connection.cursor(dictionary=True)
        cursor.execute(f"DESCRIBE {table_name}")
        columns = cursor.fetchall()
        
        logger_info.info(f"Retrieved structure for MySQL table: {table_name}")
        return columns
    
    except mysql.connector.Error as e:
        logger_error.error(f"MySQL error getting table structure for {table_name}: {e}")
        return None
    except Exception as e:
        logger_error.error(f"General error getting table structure for {table_name}: {e}")
        return None
    finally:
        if 'mysql_connection' in locals() and mysql_connection.is_connected():
            cursor.close()
            mysql_connection.close()


def generate_oracle_create_table_sql(table_name, mysql_columns):
    """
    Generate Oracle CREATE TABLE SQL statement based on MySQL table structure
    Simplified to handle mainly STRING and INT data types
    
    Args:
        table_name (str): Name of the Oracle table to create
        mysql_columns (list): List of dictionaries containing MySQL column information
        
    Returns:
        str: CREATE TABLE SQL statement for Oracle
    """
    # Simplified type mapping focused on strings and integers
    type_mapping = {
        'int': 'NUMBER',
        'integer': 'NUMBER',
        'bigint': 'NUMBER',
        'tinyint': 'NUMBER',
        'smallint': 'NUMBER',
        'float': 'NUMBER',
        'double': 'NUMBER',
        'decimal': 'NUMBER',
        'varchar': 'VARCHAR2',
        'char': 'VARCHAR2',
        'text': 'VARCHAR2(4000)',
        'datetime': 'VARCHAR2(50)',
        'timestamp': 'VARCHAR2(50)',
        'date': 'VARCHAR2(50)',
        'time': 'VARCHAR2(50)'
    }
    
    column_defs = []
    
    for column in mysql_columns:
        col_name = column['Field']
        col_type = column['Type'].lower()
        
        # Ensure col_type is a string, not bytes
        if isinstance(col_type, bytes):
            col_type = col_type.decode('utf-8')
        
        # Extract just the base type (ignore size)
        base_type = col_type.split('(')[0]
        
        # Map to Oracle type, defaulting to VARCHAR2
        if base_type in ['int', 'integer', 'bigint', 'tinyint', 'smallint', 'float', 'double', 'decimal']:
            oracle_type = 'NUMBER'
        else:
            # Default everything else to VARCHAR2(4000)
            oracle_type = 'VARCHAR2(4000)'
        
        # All columns are nullable by default
        nullable = "DEFAULT NULL"
        
        # Add column definition
        column_defs.append(f"{col_name} {oracle_type} {nullable}")
    
    # Create the final SQL statement
    create_table_sql = f"CREATE TABLE {table_name} (\n  " + ",\n  ".join(column_defs) + "\n)"
    
    return create_table_sql

 
def create_validation_success_failure_tables_from_oracle(mapper):
    """
    Create MySQL validation tables (success and failure) based on Oracle table schema
    
    Args:
        mapper (dict): Dictionary mapping Oracle table names to MySQL success/failure table tuples
    """
    try:
        logger_info.info(f"Starting creation of validation tables from Oracle schema")
        
        for oracle_table, (success_table, failure_table) in mapper.items():
            try:
                # Read the Oracle table into a DataFrame
                df = read_df_oracle(oracle_source_db, oracle_table, chunk_size, logger_info, logger_error)
                
                if df.empty:
                    logger_error.error(f"No data found for Oracle table: {oracle_table}")
                    continue
                
                # Connect to MySQL to create tables
                mysql_connection = mysql.connector.connect(
                    host=validation_db_configs["HOST"],
                    user=validation_db_configs["USER"],
                    password=validation_db_configs["PASSWORD"],
                    database=validation_db_configs["DATABASE"],
                    port=validation_db_configs["PORT"]
                )
                mysql_cursor = mysql_connection.cursor()
                
                # Create success table
                success_columns = []
                
                for column_name in df.columns:
                    mysql_type = _map_oracle_to_mysql_type(column_name)
                    success_columns.append(f"`{column_name}` {mysql_type} NULL")
                
                # Add MySQL table options
                table_options = "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;"
                
                success_sql = f"CREATE TABLE IF NOT EXISTS `{success_table}` (\n  " + \
                             ",\n  ".join(success_columns) + \
                             "\n) " + table_options
                
                mysql_cursor.execute(f"DROP TABLE IF EXISTS `{success_table}`")
                mysql_cursor.execute(success_sql)
                
                # Create failure table (with extra CODE column)
                failure_columns = success_columns.copy()
                failure_columns.append("`CODE` VARCHAR(100) NULL")
                
                failure_sql = f"CREATE TABLE IF NOT EXISTS `{failure_table}` (\n  " + \
                              ",\n  ".join(failure_columns) + \
                              "\n) " + table_options
                
                mysql_cursor.execute(f"DROP TABLE IF EXISTS `{failure_table}`")
                mysql_cursor.execute(failure_sql)
                
                mysql_connection.commit()
                logger_info.info(f"Successfully created tables {success_table} and {failure_table} from Oracle table {oracle_table}")
                
            except mysql.connector.Error as e:
                logger_error.error(f"MySQL error for table {oracle_table}: {e}")
            except Exception as e:
                logger_error.error(f"General error processing {oracle_table}: {str(e)}")
            finally:
                if 'mysql_cursor' in locals():
                    mysql_cursor.close()
                if 'mysql_connection' in locals() and mysql_connection.is_connected():
                    mysql_connection.close()
        
        logger_info.info("Validation tables creation completed")
    
    except Exception as e:
        logger_error.error(f"Error in create_validation_success_failure_tables_from_oracle: {str(e)}")


def _map_oracle_to_mysql_type(column_name):
    """
    Map Oracle column names to MySQL data types using simplified logic:
    - If column name contains 'ID', use INT
    - If column name contains 'DATE', use DATETIME
    - Otherwise use VARCHAR(200)
    """
    column_name = column_name.upper()
    
    known_bigint_id_columns = ['CRM_ID', 'EC_CRM_ID', 'BU_CRM_ID']

    if column_name in known_bigint_id_columns:
        return "BIGINT"
    
    # Default type for all other columns
    return "VARCHAR(100)"


if __name__ == '__main__':
    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "error_codes":
            migrate_error_codes_table_data_to_oracle()
        
        if arg == "rejection_tables":
            create_rejection_tables_as_mysql_into_oracle(connection_params=oracle_source_db)

        if arg == "create_validation_tables":
            create_validation_success_failure_tables_from_oracle(mapper=oracle_mysql_success_failure_table_mapper)
