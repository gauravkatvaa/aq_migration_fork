"""
Created on 02 Feb 2024
@author: amit.k@airlinq.com

Script to convert incoming csv file into the desired format of csv file

1) M2M_Customer_to_AQ :- If any mandatory column value is empty in case of eCMP M2M Company File then this function Drop those particular records(rows)
    -> Second Check will be to check if any column dataType mismatch then drop those records , datatype check is implemented on isNumeric,isAlphaNumeric, checkEnum and checkDateTime
"""

import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.library import *
from src.utils.utils_lib import *
from conf.custom.ares.config import *
import datetime
import time
today = datetime.datetime.now()
from ares_rules import *
curr_date = today.strftime("%Y%m%d")
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))
validation_error_path = os.path.join(dir_path, validation_error_dir)

duplicate_error_ec_filename = ec_duplicate_file_name + "_" + current_time_stamp + ".csv"
company_duplication_error_path = os.path.join(dir_path, validation_error_dir, duplicate_error_ec_filename)

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

# dir_path = dirname(abspath(__file__))

def data_validation(logger_info, logger_error, table_name, entity_name):
    """
    Method to check missing values in a CSV file and convert it into the required format.
    :param logger_info: logger for info messages
    :param logger_error: logger for error messages
    :param table_name: the name of the database table to validate
    :param entity_name: name representing the entity (e.g., lifecycle) for dynamic configuration
    :return: filtered dataframe
    """
    try:
        # Truncate error table
        truncate_mysql_table(validation_db_configs, f'{entity_name}_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        df_entity = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_entity = df_entity.replace('None', '')
        df_entity.to_csv(f"{entity_name}_new.csv", index=False)
        logger_info.info(f"DF {entity_name}: {df_entity}")
        length_of_original_df = len(df_entity)

        for column in df_entity.columns:
            df_entity[column] = df_entity[column].apply(lambda x: str(x).strip())

        df_entity = df_entity.astype(str)
        df_entity["code"] = ''

        try:
            for index, row in df_entity.iterrows():
                error_list = []

                missing_columns = [col for col in lifecycle_required_columns if len(row[col]) == 0]
                error_list.extend(
                    lifecycle_missing_value_mapper[col] for col in missing_columns if col in lifecycle_missing_value_mapper
                )

                for col, check_func, error_message in lifecycle_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error(f"Error: {e}, during table {table_name} validation")

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_entity.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        logger_info.info(f'Length of {entity_name} records validation Error: {len(df_partial_error)}')
        df_partial_error = df_partial_error.astype(str)

        # If df_partial_error is not empty then create file
        if not df_partial_error.empty:
            logger_info.info(f'Table {table_name}, Validation Errors: {df_partial_error}')
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, f'{entity_name}_failure', logger_info, logger_error)
            df_partial_error.to_csv(f'{entity_name}_error.csv', index=False)

        df_entity = df_entity.drop(drop_row_index).reset_index(drop=True)
        df_entity.drop(columns=['code'], inplace=True)

        # Insert into success table
        truncate_mysql_table(validation_db_configs, f'{entity_name}_success', logger_error)
        insert_batches_df_into_mysql(df_entity, validation_db_configs, f'{entity_name}_success', logger_info, logger_error)

        end_time = round((time.time() - start_time), 2)
        logger_info.info(f"Process execution time {end_time} sec")
        insert_into_summary_table(
            metadata_db_configs, 'validation_summary', logger_info, logger_error,
            entity_name, length_of_original_df, len(df_entity), len(df_partial_error), end_time, curr_date
        )

        return df_entity

    except Exception as e:
        logger_error.error(f"Error processing {entity_name} data: {e}")
        raise ValueError(f"Error processing {entity_name} data")


rename_dict = {
    'TRIGGER_ITEM_CONDITION_NUMBER_OF_SERVICE_PROFILE_CHANGES':'TIC_NO_SP_CHANGES',
    'TRIGGER_ITEM_ACTION': 'TIA',
    'TRIGGER_ITEM_CONDITION': 'TIC',
    'TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE': 'TIAA',
}

# def replace_columns_by_prefix(df, rename_dict):
#     # Use regex to match and replace prefixes in column names
#     new_columns = [
#         re.sub(f"^({key})", rename_dict[key], col)  # Replace the prefix if found
#         for col in df.columns
#         for key in rename_dict if col.startswith(key)
#     ] or df.columns  # If no match, keep original columns

#     # Update the DataFrame's columns
#     df.columns = new_columns
#     return df

def replace_columns_by_prefix(df, rename_dict):
    # Create a new list for renamed columns
    new_columns = []

    for col in df.columns:
        # Check for prefixes in rename_dict keys
        replaced = False
        for key in rename_dict:
            if col.startswith(key):
                new_columns.append(rename_dict[key] + col[len(key):])  # Replace prefix with value
                replaced = True
                break
        if not replaced:
            new_columns.append(col)  # Keep original name if no match

    # Update the DataFrame's columns
    df.columns = new_columns
    return df


def rule_trigger_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, 'trigger_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        
        rule_df = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)
        trigger_attribute_df = read_df_oracle(oracle_source_db, 'TRIGGERS_ATTRIBUTES', chunk_size, logger_info, logger_error)

        # Perform two merges separately (one for ACTION_ID and one for CONDITION_ID)
        df_merge_action = pd.merge(rule_df, trigger_attribute_df, left_on='ACTION_ID', right_on='ID', how='inner', suffixes=('', '_action'))
        df_merge_condition = pd.merge(rule_df, trigger_attribute_df, left_on='CONDITION_ID', right_on='ID', how='inner', suffixes=('', '_condition'))

        # Concatenate the results of both merges
        df_rule_trigger = pd.concat([df_merge_action, df_merge_condition], ignore_index=True)

       
        df_rule_trigger = df_rule_trigger.replace('None', '')
        df_rule_trigger = df_rule_trigger.replace('nan', '')
        df_rule_trigger.to_csv("rule_trigger_new.csv", index=False)
        logger_info.info("DF rule_trigger : {}".format(df_rule_trigger))
        length_of_original_df = len(df_rule_trigger)
        print("Length of Original Trigger DF : ",length_of_original_df)
        # df_rule_trigger = drop_duplicates_and_save_duplicates(df_rule_trigger, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_rule_trigger)
        for column in df_rule_trigger.columns:
            df_rule_trigger[column] = df_rule_trigger[column].apply(lambda x: str(x).strip())

        df_rule_trigger = df_rule_trigger.astype(str)
        df_rule_trigger["code"] = ''

        try:

            for index, row in df_rule_trigger.iterrows():
                error_list = []
                # data_type_error_list = []

                missing_columns = [col for col in rule_trigger_required_columns if len(row[col]) == 0]
                if row['LEVEL_TYPE'] == 'TRIGGER_LEVEL.SIM' and len(row['IMSI']) == 0 :
                    error_list.append("120")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_MAIL' and len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_ADDRESS']) == 0 :
                    error_list.append("121")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS' and len(row['TRIGGER_ITEM_ACTION_SEND_SMS_PHONE']) == 0 :
                    error_list.append("122")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.CHANGE_SP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_NEW_SERVICE_PROFILE_CONTEXT']) == 0 :
                    error_list.append("123")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP_NEW_SERVICE_PROFILE_CONTEXT']) == 0 :
                    error_list.append("124")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_EMAIL' and ( len(row['TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_MAIL_DEFINITION']) == 0 \
                or len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_MESSAGE']) == 0  or len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_SUBJECT']) == 0 ):
                    error_list.append("125")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS' and ( len(row['TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_SMS_DEFINITION']) == 0 \
                or len(row['TRIGGER_ITEM_ACTION_SEND_SMS_MESSAGE']) == 0):
                    error_list.append("126")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_SERVICE_PROFILE_IN_NEXT_BILLING_CYCLE']) == 0 :
                    error_list.append("127")

                if row['ACTION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE_FOR _GROUP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP_SERVICE_PROFILE_IN_NEXT_BILLING_CYCLE']) == 0 :
                    error_list.append("128")


                error_list.extend(
                    rule_trigger_missing_value_mapper[col] for col in missing_columns if col in rule_trigger_missing_value_mapper)

                for col, check_func, error_message in rule_trigger_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_rule_trigger = replace_columns_by_prefix(df_rule_trigger, rename_dict)
        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_rule_trigger.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_rule_trigger.iloc[drop_row_index, :]

        df_partial_error = df_rule_trigger.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of rule_trigger records validation Error : ', len(df_partial_error))
        logger_info.info('Length of rule_trigger records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'trigger_failure', logger_info,
                                         logger_error)
            df_partial_error.to_csv('error.csv', index=False)

        df_rule_trigger = df_rule_trigger.drop(drop_row_index)

        df_rule_trigger = df_rule_trigger.reset_index(drop=True)

        ############### Insert into db ###############################
        df_rule_trigger.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'trigger_success', logger_error)
        insert_batches_df_into_mysql(df_rule_trigger, validation_db_configs, 'trigger_success', logger_info, logger_error)
        df_rule_trigger.to_csv('trigger_success.csv', index=False)
        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'rule_trigger', length_of_original_df, len(df_rule_trigger),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_rule_trigger

    except Exception as e:
        logger_error.error("error processing rule_trigger customer data :{}".format(e))
        raise ValueError("error processing rule_trigger customer data")


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    # Access individual arguments


    for arg in sys.argv[1:]:
        
        if arg == "validation":
            data_validation(logger_info, logger_error,'CUSTOMERS','ec')

            data_validation(logger_info, logger_error,'BUSINESS_UNITS','bu')

            data_validation(logger_info, logger_error, 'USERS','user')

            data_validation(logger_info, logger_error, 'COST_CENTER','cc')

            data_validation(logger_info, logger_error, 'DIC_APNS','apn')

            data_validation(logger_info, logger_error, 'NOTIFICATIONS','notifications')

            rule_trigger_validation(logger_info, logger_error, 'TRIGGERS')

            data_validation(logger_info, logger_error, 'SERVICE_PROFILES','service_profile')

            data_validation(logger_info, logger_error, 'LIFE_CYCLES','lifecycle')

            data_validation(logger_info, logger_error, 'SIM_ASSETS','assets')