"""
Created on 02 Feb 2024
@author: amit.k@airlinq.com

Script to convert incoming csv file into the desired format of csv file

1) M2M_Customer_to_AQ :- If any mandatory column value is empty in case of eCMP M2M Company File then this function Drop those particular records(rows)
    -> Second Check will be to check if any column dataType mismatch then drop those records , datatype check is implemented on isNumeric,isAlphaNumeric, checkEnum and checkDateTime
"""

from logging import Logger
import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from src.utils.library import *
from src.utils.utils_lib import *
from conf.custom.ares.config import *
import datetime
import time
from ares_rules import *
from tqdm import tqdm
import cx_Oracle
import pandas as pd

today = datetime.datetime.now()

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

rename_dict = {
    'TRIGGER_ITEM_CONDITION_NUMBER_OF_SERVICE_PROFILE_CHANGES':'TIC_NO_SP_CHANGES',
    'TRIGGER_ITEM_ACTION': 'TIA',
    'TRIGGER_ITEM_CONDITION': 'TIC',
    'TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE': 'TIAA',
}

def enterprise_customer_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'ec_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate oracle and mysql table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_enterprise = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_enterprise = df_enterprise.replace('None','')
        print("DF Enterprise : ",df_enterprise['DEFAULT_BUSINESS_UNIT_ID'])
        # df_enterprise.to_csv("enterprise_new.csv",index=False)
        logger_info.info("DF Enterprise : {}".format(df_enterprise))
        
        length_of_original_df = len(df_enterprise)

        for column in df_enterprise.columns:
            df_enterprise[column] = df_enterprise[column].apply(lambda x: str(x).strip())

        df_enterprise = df_enterprise.astype(str)
        df_enterprise["code"] = ''
        
        # column_error_list = []
        # data_type_mismatch = []
        if table_name == 'CUSTOMERS':
            try:
                
                for index, row in df_enterprise.iterrows():
                    error_list = []
                    # data_type_error_list = []
                    
                    missing_columns = [col for col in ec_required_columns if len(row[col]) == 0]
                    
                    # print("Missing",missing_columns)
                    # Checking for additional condition
                    # if (row['INVOICING_LEVEL_TYPE']=='Customer' and (len(row["ADDRESSBILLING"]) == 0)):
                    #     # error_list.append("Missing value ADDRESSBILLING when INVOICING_LEVEL_TYPE='Customer'")
                    #     error_list.append("107")

                    # error_list.extend(f"Missing value {col}" for col in missing_columns)
                    error_list.extend(ec_missing_value_mapper[col] for col in missing_columns if col in ec_missing_value_mapper)

                    for col, check_func, error_message in ec_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
                    # row["code"] = ', '.join(data_type_error_list)
                    # column_error_list.extend(error_list)
                    # data_type_mismatch.extend(data_type_error_list)
            except Exception as e:
                logger_error.error("Error :{}, during table {} validation ".format(e,table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ",drop_row_index)
        print('dataframe index ',df_enterprise.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_enterprise.iloc[drop_row_index, :]

        df_partial_error = df_enterprise.iloc[drop_row_index, :]

        delete_before(validation_error_dir,dir_path)
        print('Length of Enterprise records validation Error : ', len(df_partial_error))
        logger_info.info('Length of Enterprise records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ',df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name,df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_enterprise = df_enterprise.drop(drop_row_index)
        df_enterprise = df_enterprise.reset_index(drop=True)

        ############### Insert into db ###############################
        df_enterprise.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'ec_success', logger_error)
        insert_batches_df_into_mysql(df_enterprise, validation_db_configs, 'ec_success', logger_info, logger_error)
        
        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs,'validation_summary' ,logger_info, logger_error,'Enterprise Customer', length_of_original_df, len(df_enterprise), len(df_partial_error),
                                  end_time,curr_date)
        
        return df_enterprise

    except Exception as e:
        logger_error.error("error processing enterprise customer data :{}".format(e))
        raise ValueError("error processing enterprise customer data")


def enterprise_customer_validation_v2(df, logger_info, logger_error):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    
    logger_info.info("Starting Enterprise Customer Validation")
    
    df_enterprise = df

    drop_row_index = []        

    logger_info.info("DF Enterprise : {}".format(df_enterprise))
    
    for column in df_enterprise.columns:
        df_enterprise[column] = df_enterprise[column].apply(lambda x: str(x).strip())
    
    df_enterprise = df_enterprise.astype(str)
    df_enterprise["code"] = ''
    
    try:    
        for index, row in df_enterprise.iterrows():
            error_list = []
            missing_columns = [col for col in ec_required_columns if len(row[col]) == 0]

            if (row['INVOICING_LEVEL_TYPE']=='Customer' and (len(row["ADDRESSBILLING"]) == 0)):
                error_list.append("107")

            error_list.extend(ec_missing_value_mapper[col] for col in missing_columns if col in ec_missing_value_mapper)

            for col, check_func, error_message in ec_checks:
                col_value = str(row[col])
                if len(col_value) != 0 and not check_func(col_value):
                    error_list.append(error_message)

            if error_list:
                drop_row_index.append(index)

            row["code"] = ', '.join(error_list)
    
        return df_enterprise, drop_row_index

    except Exception as e:
        logger_error.error("Error :{}, during table {} validation ".format(e,table_name))


def business_unit_validation(logger_info, logger_error,file_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'bu_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate oracle and mysql table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []

        start_time = time.time()
        df_business = read_df_oracle(oracle_source_db, file_name, chunk_size, logger_info, logger_error)
        length_of_original_df = len(df_business)
       
        for column in df_business.columns:
            df_business[column] = df_business[column].apply(lambda x: str(x).strip())

        df_business = df_business.astype(str)
        df_business["code"] = ''
        
        # Checking for cross validation 
        df_business, cross_validation_drop_row_index = cross_check_validation(df_business, cross_validation_column='EC_CRM_ID', logger_info=logger_info, logger_error=logger_error)
        drop_row_index.extend(cross_validation_drop_row_index)

        for index, row in df_business.iterrows():
            if row['code'] == '' or row['code'] == None:
                error_list = []
                missing_columns = [col for col in bu_required_columns if len(row[col]) == 0]
                error_list.extend(bu_missing_value_mapper[col] for col in missing_columns if col in bu_missing_value_mapper)

                for col, check_func, error_message in bu_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)
                
                row["code"] = ', '.join(error_list)

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_business.iloc[drop_row_index, :]

        df_partial_error = df_business.iloc[drop_row_index, :]

        delete_before(validation_error_dir,dir_path)
        print('Length of Business Unit records validation Error : ', len(df_partial_error))
        logger_info.info('Length of Business Unit validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        if not df_partial_error.empty:
            print('Error : ',df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name,df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_business = df_business.drop(drop_row_index)

        df_business = df_business.reset_index(drop=True)

        ############### Insert into db ###############################
        df_business.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'bu_success', logger_error)
        insert_batches_df_into_mysql(df_business, validation_db_configs, 'bu_success', logger_info, logger_error)
        # print("*****************************")
        end_time = (time.time()) - start_time
        print("Process execution time {} ".format(end_time))
        insert_into_summary_table(metadata_db_configs,'validation_summary' ,logger_info, logger_error,'Business Unit', length_of_original_df, len(df_business), len(df_partial_error),
                                  end_time,curr_date)
        return df_business

    except Exception as e:
        print("error processing business unit data :{}".format(e))
        logger_error.error("error processing business unit data :{}".format(e))
        # raise ValueError("error processing business unit data")


def business_unit_validation_v2(df, logger_info, logger_error):
    return


def user_validation(logger_info, logger_error, file_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'users_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate oracle and mysql table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []

        start_time = time.time()
        df_user = read_df_oracle(oracle_source_db, file_name, chunk_size, logger_info, logger_error)
        df_user = df_user.replace('None', '')
        df_user = df_user.replace('nan', '')

        # Here the CRM_BU_ID columns is read like decimle though its integer in the original DF
        # so lets convert here it to int
        df_user['CRM_BU_ID'] = df_user['CRM_BU_ID'].apply(lambda x: int(float(x)) if str(x).replace('.', '', 1).isdigit() else x)
        length_of_original_df = len(df_user)
        # df_user = pd.read_csv('/home/amit/Downloads/users.csv',dtype=str,keep_default_na=False)
        # df_user = drop_duplicates_and_save_duplicates(df_user, duplication_error_path, logger_info, 'ACCOUNT_NO')
        # print('\n duplicate data frame', df_user)
        for column in df_user.columns:
            df_user[column] = df_user[column].apply(lambda x: str(x).strip())

        df_user = df_user.astype(str)
        # df_user['CRM_RESELLER_ID'] = df_user['CRM_RESELLER_ID'].replace(['nan', 'None', ''], None)

        df_user["code"] = ''
        # df_user["Type_Mismatch"] = ''
        print("CRM_RESELLER_ID type",df_user['CRM_RESELLER_ID'])
        print("CRM_CUSTOMER_ID type",df_user['CRM_CUSTOMER_ID'])
        # column_error_list = []
        # data_type_mismatch = []

        # Checking for cross validation 
        df_business, cross_validation_drop_row_index = cross_check_validation(df_user, cross_validation_column='CRM_CUSTOMER_ID', logger_info=logger_info, logger_error=logger_error)
        drop_row_index.extend(cross_validation_drop_row_index)

        for index, row in df_user.iterrows():
            if row['code'] == '' or row['code'] == None:
                error_list = []
                # data_type_error_list = []

                missing_columns = [col for col in user_required_columns if len(row[col]) == 0]

                if len(row['CRM_RESELLER_ID']) == 0 and len(row['CRM_CUSTOMER_ID']) == 0 and len(row['CRM_BU_ID']) == 0:
                    # error_list.append("Missing value CRM_RESELLER_ID,CRM_CUSTOMER_ID,CRM_BU_ID")
                    error_list.append("105")
                
                if ((len(row['CRM_BU_ID']) != 0) and (len(row["CRM_CUSTOMER_ID"]) == 0)):  
                    # error_list.append("Missing value CRM_CUSTOMER_ID when CRM_BU_ID is Present")
                    error_list.append("106")

                error_list.extend(user_missing_value_mapper[col] for col in missing_columns if col in user_missing_value_mapper)


                for col, check_func, error_message in user_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)
                
                row["code"] = ', '.join(error_list)
        
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_user.iloc[drop_row_index, :]

        df_partial_error = df_user.iloc[drop_row_index, :]

        delete_before(validation_error_dir,dir_path)
        print('Length of User Records validation Error : ', len(df_partial_error))
        logger_info.info('Length of User records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ',df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(file_name,df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_user = df_user.drop(drop_row_index)

        df_user = df_user.reset_index(drop=True)

        ############### Insert into db ###############################
        df_user.drop(columns=['code'], inplace=True)
        df_user.to_csv('valid_user.csv',index=False)
        truncate_mysql_table(validation_db_configs, 'users_success', logger_error)
        insert_batches_df_into_mysql(df_user, validation_db_configs, 'users_success', logger_info, logger_error)
        
        # print("*****************************")
        end_time = (time.time()) - start_time
        print("Process execution time {}".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error, 'User',
                                  length_of_original_df, len(df_user), len(df_partial_error),
                                  end_time,curr_date)
        return df_user

    except Exception as e:
        logger_error.error("error processing user data:{}".format(e))
        raise ValueError("error processing user data")


def cost_center_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'cost_centers_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate oracle and mysql table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_cost_center = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_cost_center = df_cost_center.replace('None', '')
        df_cost_center = df_cost_center.replace('nan', '')
        # df_cost_center.to_csv("Cost_Center_new.csv", index=False)
        logger_info.info("DF Cost_Center : {}".format(df_cost_center))
        length_of_original_df = len(df_cost_center)
        # df_cost_center = drop_duplicates_and_save_duplicates(df_cost_center, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_cost_center)
        for column in df_cost_center.columns:
            df_cost_center[column] = df_cost_center[column].apply(lambda x: str(x).strip())

        df_cost_center = df_cost_center.astype(str)
        # print("row data",df_cost_center.dtypes)
        df_cost_center["code"] = ''

        # column_error_list = []
        # data_type_mismatch = []

        try:
            # Checking for cross validation
            df_cost_center, cross_validation_drop_row_index = cross_check_validation(df_cost_center, cross_validation_column='BU_CRM_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)

            for index, row in df_cost_center.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []
                    # data_type_error_list = []

                    missing_columns = [col for col in cost_center_required_columns if len(row[col]) == 0]

                    error_list.extend(
                        cc_missing_value_mapper[col] for col in missing_columns if col in cc_missing_value_mapper)

                    for col, check_func, error_message in cost_center_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
                
        
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_cost_center.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_cost_center.iloc[drop_row_index, :]

        df_partial_error = df_cost_center.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of Cost_Center records validation Error : ', len(df_partial_error))
        logger_info.info('Length of Cost_Center records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_cost_center = df_cost_center.drop(drop_row_index)

        df_cost_center = df_cost_center.reset_index(drop=True)

        ############### Insert into db ###############################
        df_cost_center.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'cost_centers_success', logger_error)
        insert_batches_df_into_mysql(df_cost_center, validation_db_configs, 'cost_centers_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'Cost_Center', length_of_original_df, len(df_cost_center),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_cost_center

    except Exception as e:
        logger_error.error("error processing Cost_Center customer data :{}".format(e))
        raise ValueError("error processing Cost_Center customer data")




# def apn_validation(logger_info, logger_error, table_name):
#     """
#            Method to check missing values in csv file M2M_Customer and converting it into required format
#            :param name : dataframe
#            :param path : column error file path
#            :param logger_info :
#            :param logger_error:
#            :return: filtered dataframe"""
#     try:
#         MYSQL_FAILURE_TABLE_NAME = 'apn_failure'
#         ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

#         ########## Truncating error table
#         truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
#         truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

#         drop_row_index = []
#         start_time = time.time()
#         df_apn = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

#         df_apn = df_apn.replace('None', '')
#         df_apn = df_apn.replace('nan', '')
#         # df_apn.to_csv("apn_new.csv", index=False)
#         logger_info.info("DF apn : {}".format(df_apn))
#         length_of_original_df = len(df_apn)
#         # df_apn = drop_duplicates_and_save_duplicates(df_apn, duplication_error_path,logger_info,'APN')
#         print('\n duplicate data frame', df_apn)
#         for column in df_apn.columns:
#             df_apn[column] = df_apn[column].apply(lambda x: str(x).strip())

#         df_apn = df_apn.astype(str)
#         # print("row data",df_apn.dtypes)
#         df_apn["code"] = ''

#         try:

#             for index, row in df_apn.iterrows():
#                 error_list = []
#                 missing_columns = [col for col in apn_required_columns if len(row[col]) == 0]
                
#                 error_list.extend(
#                     apn_missing_value_mapper[col] for col in missing_columns if col in apn_missing_value_mapper)

#                 for col, check_func, error_message in apn_checks:
#                     col_value = str(row[col])
#                     if len(col_value) != 0 and not check_func(col_value):
#                         error_list.append(error_message)

#                 if error_list:
#                     drop_row_index.append(index)

#                 row["code"] = ', '.join(error_list)
        
#         except Exception as e:
#             logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

#         df_partial_error = pd.DataFrame()
#         print("dropped index ", drop_row_index)
#         print('dataframe index ', df_apn.index)
#         if len(drop_row_index) > 0:
#             df_partial_error = df_apn.iloc[drop_row_index, :]

#         df_partial_error = df_apn.iloc[drop_row_index, :]

#         delete_before(validation_error_dir, dir_path)
#         print('Length of apn records validation Error : ', len(df_partial_error))
#         logger_info.info('Length of apn records validation Error : {}'.format(len(df_partial_error)))
#         df_partial_error = df_partial_error.astype(str)

#         ## If df_partial_error is not empty then make file
#         if not df_partial_error.empty:
#             print('Error : ', df_partial_error)
#             logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
#             insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
#             insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)
        
#         df_apn = df_apn.drop(drop_row_index)

#         df_apn = df_apn.reset_index(drop=True)

#         ############### Insert into db ###############################
#         df_apn.drop(columns=['code'], inplace=True)
#         truncate_mysql_table(validation_db_configs, 'apn_success', logger_error)
#         insert_batches_df_into_mysql(df_apn, validation_db_configs, 'apn_success', logger_info, logger_error)

#         # print("*****************************")
#         end_time = round((time.time() - start_time), 2)
#         print("Process execution time {} sec".format(end_time))
#         insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
#                                   'apn creation', length_of_original_df, len(df_apn),
#                                   len(df_partial_error),
#                                   end_time, curr_date)

#         return df_apn

#     except Exception as e:
#         logger_error.error("error processing apn customer data :{}".format(e))
#         raise ValueError("error processing apn customer data")



def apn_validation(logger_info, logger_error, table_name):
    """
            Method to check missing values in csv file M2M_Customer and converting it into required format
            :param name : dataframe
            :param path : column error file path
            :param logger_info :
            :param logger_error:
            :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'apn_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_apn = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_apn = df_apn.replace('None', '')
        df_apn = df_apn.replace('nan', '')
        # df_apn.to_csv("apn_new.csv", index=False)
        logger_info.info("DF apn : {}".format(df_apn))
        length_of_original_df = len(df_apn)
        # df_apn = drop_duplicates_and_save_duplicates(df_apn, duplication_error_path,logger_info,'APN')
        print('\n duplicate data frame', df_apn)
        for column in df_apn.columns:
            df_apn[column] = df_apn[column].apply(lambda x: str(x).strip())

        df_apn = df_apn.astype(str)
        # print("row data",df_apn.dtypes)
        df_apn["code"] = ''

        try:
            # Check for duplicate values in APN_ID
            duplicate_apn_ids = df_apn[df_apn.duplicated(subset=['APN_ID'], keep=False)].index.tolist()
            for index in duplicate_apn_ids:
                df_apn.at[index, "code"] = '409'
                drop_row_index.append(index)

            for index, row in df_apn.iterrows():
                if index in drop_row_index:
                    continue  # Skip rows already marked as duplicates

                error_list = []
                missing_columns = [col for col in apn_required_columns if len(row[col]) == 0]
                
                error_list.extend(
                    apn_missing_value_mapper[col] for col in missing_columns if col in apn_missing_value_mapper)

                for col, check_func, error_message in apn_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
        
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_apn.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_apn.iloc[drop_row_index, :]

        df_partial_error = df_apn.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of apn records validation Error : ', len(df_partial_error))
        logger_info.info('Length of apn records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)
        
        df_apn = df_apn.drop(drop_row_index)

        df_apn = df_apn.reset_index(drop=True)

        ############### Insert into db ###############################
        df_apn.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'apn_success', logger_error)
        insert_batches_df_into_mysql(df_apn, validation_db_configs, 'apn_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                    'apn creation', length_of_original_df, len(df_apn),
                                    len(df_partial_error),
                                    end_time, curr_date)

        return df_apn

    except Exception as e:
        logger_error.error("error processing apn customer data :{}".format(e))
        raise ValueError("error processing apn customer data")


def fetch_asset_data_in_batches(connection_params, batch_size=50000):
    """
    Fetch records from SIM_ASSETS table in batches of specified size with a progress bar.
    
    Args:
        connection_params: Dictionary containing Oracle connection parameters
        batch_size: Number of records to fetch per batch (default: 1000)
    """
    # Initialize counters and variables for summary
    total_records = 0
    total_validated = 0
    total_errors = 0
    start_process_time = time.time()
    curr_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    MYSQL_FAILURE_TABLE_NAME = 'asset_failure'
    ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

    
    # Truncate success and error tables before starting
    truncate_mysql_table(validation_db_configs, 'asset_success', logger_error)
    truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
    truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)
    
    connection = cx_Oracle.connect(
            f"{connection_params['USER']}/{connection_params['PASSWORD']}@{connection_params['HOST']}:"
            f"{connection_params['PORT']}/{connection_params['DATABASE_SID']}"
    )
    print("Connection established successfully!")
    logger_info.info("Oracle connection established successfully!")
    
    cursor = connection.cursor()
    
    # First, get the total count of records for the progress bar
    print("Counting total records...")
    logger_info.info("Counting total records in SIM_ASSETS table...")
    count_cursor = connection.cursor()
    count_cursor.execute("SELECT COUNT(*) FROM SIM_ASSETS")
    total_records = count_cursor.fetchone()[0]
    count_cursor.close()
    print(f"Total records to process: {total_records:,}")
    logger_info.info(f"Total records to process: {total_records:,}")
    
    start_row = 0
    end_row = batch_size
    batch_number = 1
    total_processed = 0
    total_errors_found = 0
    
    # Initialize progress bar
    pbar = tqdm(total=total_records, desc="Processing records", unit="records")
    
    try:
        while True:
            start_time = time.time()
            
            # Execute the paginated query - Using IMSI, ROWID for ordering
            query = """
                SELECT * FROM (
                    SELECT a.*, ROWNUM rnum
                    FROM (
                        SELECT * FROM SIM_ASSETS
                        ORDER BY IMSI, ROWID  -- Using IMSI with ROWID to ensure deterministic ordering
                    ) a
                    WHERE ROWNUM <= :end_row
                )
                WHERE rnum > :start_row
            """
            
            cursor.execute(query, {'start_row': start_row, 'end_row': end_row})
            
            # Fetch all rows in this batch
            batch_data = cursor.fetchall()
            
            # If no data returned, we've reached the end
            if not batch_data:
                print(f"\nFinished processing all records. Total processed: {total_processed:,}")
                logger_info.info(f"Finished processing all records. Total processed: {total_processed:,}")
                break
            
            # Convert batch data into a DataFrame
            column_names = [desc[0] for desc in cursor.description]
            batch_data = pd.DataFrame(batch_data, columns=column_names)
            
            # Process this batch (replace with your validation logic)
            batch_errors = asset_validation(logger_info, logger_error, batch_data)
            total_errors_found += batch_errors
            
            # Update counters for next batch
            batch_size_actual = len(batch_data)
            total_processed += batch_size_actual
            
            # Update progress bar
            pbar.update(batch_size_actual)
            
            # Add batch info to progress bar description
            pbar.set_description(f"Batch {batch_number} | {total_processed:,}/{total_records:,}")
            
            # Console log for detailed batch information
            elapsed_time = time.time() - start_time
            print(f"\rBatch {batch_number}: Processed {batch_size_actual} records in {elapsed_time:.2f} seconds ({batch_size_actual/elapsed_time:.2f} records/sec)", end="")
            logger_info.info(f"Batch {batch_number}: Processed {batch_size_actual} records in {elapsed_time:.2f} seconds ({batch_size_actual/elapsed_time:.2f} records/sec)")
            
            batch_number += 1
            start_row = end_row
            end_row += batch_size
            
    finally:
        pbar.close()
        cursor.close()
        connection.close()
        
        # Update summary after all processing is done
        total_execution_time = round((time.time() - start_process_time), 2)
        total_validated = total_processed - total_errors_found
        
        # Insert into summary table
        insert_into_summary_table(
            metadata_db_configs, 
            'validation_summary', 
            logger_info, 
            logger_error,
            'asset', 
            total_records, 
            total_validated, 
            total_errors_found,
            total_execution_time, 
            curr_date
        )
        
        logger_info.info(f"Total execution time: {total_execution_time} seconds")
        logger_info.info(f"Total records: {total_records}, Validated: {total_validated}, Errors: {total_errors_found}")
        print(f"\nTotal execution time: {total_execution_time} seconds")
        print(f"Total records: {total_records}, Validated: {total_validated}, Errors: {total_errors_found}")
        print("\nConnection closed.")
        logger_info.info("Oracle connection closed.")


def asset_validation(logger_info, logger_error, dataframe):
    """
    Method to check missing values in csv file M2M_Customer and converting it into required format
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :param dataframe: DataFrame containing the batch data
    :return: Number of error records found
    """
    try:
        MYSQL_FAILURE_TABLE_NAME = 'asset_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        drop_row_index = []
        start_time = time.time()
        df_asset = dataframe
        df_asset = df_asset.replace('None', '')
        df_asset = df_asset.replace('nan', '')
        logger_info.info(f"Processing asset batch with {len(df_asset)} records")
        length_of_original_df = len(df_asset)
        
        for column in df_asset.columns:
            df_asset[column] = df_asset[column].apply(lambda x: str(x).strip())

        df_asset = df_asset.astype(str)
        df_asset["code"] = ''

        df_asset.drop(columns=['RNUM'], inplace=True, errors='ignore')

        try:
            # Checking for cross validation
            df_asset, cross_validation_drop_row_index = cross_check_validation(df_asset, cross_validation_column='EC_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)

            for index, row in df_asset.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []

                    missing_columns = [col for col in asset_required_columns if len(row[col]) == 0]

                    error_list.extend(
                        asset_missing_value_mapper[col] for col in missing_columns if col in asset_missing_value_mapper)

                    for col, check_func, error_message in asset_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error(f"Error: {e}, during table {table_name} validation")

        df_partial_error = pd.DataFrame()
        logger_info.info(f"Dropped index count: {len(drop_row_index)}")

        df_asset.replace({None: '', 'None': '', 'nan': ''}, inplace=True)

        if len(drop_row_index) > 0:
            df_partial_error = df_asset.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        logger_info.info(f'Length of asset records validation Error: {len(df_partial_error)}')
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            logger_info.info(f'Table {table_name}, Validation Errors: {len(df_partial_error)} records')
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_asset = df_asset.drop(drop_row_index)
        df_asset = df_asset.reset_index(drop=True)

        ############### Insert into db ###############################
        df_asset.drop(columns=['code'], inplace=True)
        insert_batches_df_into_mysql(df_asset, validation_db_configs, 'asset_success', logger_info, logger_error)
        
        batch_time = round((time.time() - start_time), 2)
        logger_info.info(f"Batch processing time: {batch_time} seconds")
        
        # Return the number of error records found
        return len(df_partial_error)

    except Exception as e:
        logger_error.error(f"Error processing asset customer data: {e}")
        raise ValueError("Error processing asset customer data")
    

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
    Method to check missing values in TRIGGERS table and validating against TRIGGERS_ATTRIBUTES
    :param logger_info: Logger for information messages
    :param logger_error: Logger for error messages
    :param table_name: Name of the table to validate
    :return: filtered dataframe
    """
    try:
        MYSQL_FAILURE_TABLE_NAME = 'trigger_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]
        
        # Truncating error tables
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        
        # Read source data
        logger_info.info(f"Reading {table_name} table from Oracle")
        rule_df = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)
        
        logger_info.info("Reading TRIGGERS_ATTRIBUTES table from Oracle")
        trigger_attribute_df = read_df_oracle(oracle_source_db, 'TRIGGERS_ATTRIBUTES', chunk_size, logger_info, logger_error)
        
        # Keep track of original dataframe length
        length_of_original_df = len(rule_df)
        logger_info.info(f"Length of Original Trigger DF: {length_of_original_df}")
        
        # IMPORTANT: First merge rule_df with trigger_attribute_df correctly
        # This follows the original logic but properly handles the merges
        df_merge_action = pd.merge(
            rule_df, 
            trigger_attribute_df,
            left_on='ACTION_ID',
            right_on='ID',
            how='left',
            suffixes=('', '_action')
        )
        
        df_merge_condition = pd.merge(
            rule_df,
            trigger_attribute_df,
            left_on='CONDITION_ID',
            right_on='ID',
            how='left',
            suffixes=('', '_condition')
        )
        
        # Concatenate results without duplicating the original rows
        # But first, we need to ensure we're not creating duplicates
        # We'll use the ID column from rule_df as a unique identifier
        
        # Create a dictionary to store attributes from both merges
        action_attributes = {}
        condition_attributes = {}
        
        # Extract action attributes for each rule ID
        for idx, row in df_merge_action.iterrows():
            rule_id = row['ID']
            if rule_id not in action_attributes:
                action_attributes[rule_id] = {}
                
            # Add all columns from trigger_attribute_df
            for col in trigger_attribute_df.columns:
                # Skip the ID column since it would create confusion
                if col == 'ID':
                    continue
                # Get the appropriate column name (may have suffix)
                col_name = col + '_action' if col + '_action' in df_merge_action.columns else col
                if col_name in df_merge_action.columns:
                    action_attributes[rule_id][col] = row[col_name]
        
        # Extract condition attributes for each rule ID
        for idx, row in df_merge_condition.iterrows():
            rule_id = row['ID']
            if rule_id not in condition_attributes:
                condition_attributes[rule_id] = {}
                
            # Add all columns from trigger_attribute_df
            for col in trigger_attribute_df.columns:
                # Skip the ID column
                if col == 'ID':
                    continue
                # Get the appropriate column name (may have suffix)
                col_name = col + '_condition' if col + '_condition' in df_merge_condition.columns else col
                if col_name in df_merge_condition.columns:
                    condition_attributes[rule_id][col] = row[col_name]
        
        # Now create a proper df_rule_trigger with all necessary attributes
        df_rule_trigger = rule_df.copy()
        
        # Add code column for error tracking
        df_rule_trigger["code"] = ''
        
        # Add all attribute columns to df_rule_trigger
        all_attribute_cols = set()
        for attrs in [action_attributes, condition_attributes]:
            for rule_id in attrs:
                for col in attrs[rule_id]:
                    all_attribute_cols.add(col)
        
        # Initialize attribute columns with empty strings
        for col in all_attribute_cols:
            if col not in df_rule_trigger.columns:
                df_rule_trigger[col] = ''
        
        # Fill in attribute values
        for idx, row in df_rule_trigger.iterrows():
            rule_id = row['ID']
            
            # Add action attributes
            if rule_id in action_attributes:
                for col, val in action_attributes[rule_id].items():
                    df_rule_trigger.at[idx, col] = val
            
            # Add condition attributes
            if rule_id in condition_attributes:
                for col, val in condition_attributes[rule_id].items():
                    # Don't overwrite action attributes if they exist
                    if col not in action_attributes.get(rule_id, {}) or pd.isna(df_rule_trigger.at[idx, col]) or df_rule_trigger.at[idx, col] == '':
                        df_rule_trigger.at[idx, col] = val
        
        # Data preprocessing - convert types and clean data
        for column in df_rule_trigger.columns:
            df_rule_trigger[column] = df_rule_trigger[column].astype(str).apply(lambda x: str(x).strip())
        
        # Handle CRMBU_ID conversion correctly
        df_rule_trigger['CRMBU_ID'] = df_rule_trigger['CRMBU_ID'].apply(
            lambda x: int(float(x)) if str(x).replace('.', '', 1).isdigit() else x
        )
        
        # Fill NaN values
        df_rule_trigger.fillna('', inplace=True)
        
        # Export for debugging
        df_rule_trigger.to_csv("rule_trigger_new.csv", index=False)
        logger_info.info(f"Rule trigger dataframe shape: {df_rule_trigger.shape}")
        logger_info.info(f"DF rule_trigger columns: {list(df_rule_trigger.columns)}")
        
        try:
            # Cross validation
            df_rule_trigger, cross_validation_drop_row_index = cross_check_validation(
                df_rule_trigger, 
                cross_validation_column='CRMEC_ID', 
                logger_info=logger_info, 
                logger_error=logger_error
            )
            drop_row_index.extend(cross_validation_drop_row_index)
            
            # Row-by-row validation
            for index, row in df_rule_trigger.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []
                    
                    # Check for missing required columns
                    missing_columns = [col for col in rule_trigger_required_columns if len(str(row[col])) == 0]
                    error_list.extend(
                        rule_trigger_missing_value_mapper[col] for col in missing_columns if col in rule_trigger_missing_value_mapper
                    )
                    
                    # Specific validations based on LEVEL_TYPE
                    if row['LEVEL_TYPE'] == 'TRIGGER_LEVEL.SIM' and len(str(row['IMSI'])) == 0:
                        error_list.append("120")
                    
                    # IMPORTANT: Check if columns exist before validation
                    # Validations for ACTION_TYPE
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_MAIL':
                        if 'T_IAS_MAIL_ADDRESS' not in row or len(str(row['T_IAS_MAIL_ADDRESS'])) == 0:
                            error_list.append("121")
                    
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS':
                        if 'T_IAS_SMS_PHONE' not in row or len(str(row['T_IAS_SMS_PHONE'])) == 0:
                            error_list.append("122")
                    
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.CHANGE_SP':
                        if 'T_IA_CSP_NEW_SP_CONTEXT' not in row or len(str(row['T_IA_CSP_NEW_SP_CONTEXT'])) == 0:
                            error_list.append("123")
                    
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP':
                        if 'T_IA_CSP_4G_NEW_SP_CONTEXT' not in row or len(str(row['T_IA_CSP_4G_NEW_SP_CONTEXT'])) == 0:
                            error_list.append("124")
                    
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_EMAIL':
                        mail_def_missing = 'T_IAA_MAIL_DEFINITION' not in row or len(str(row['T_IAA_MAIL_DEFINITION'])) == 0
                        mail_msg_missing = 'T_IAS_MAIL_MESSAGE' not in row or len(str(row['T_IAS_MAIL_MESSAGE'])) == 0
                        mail_subj_missing = 'T_IAS_MAIL_SUBJECT' not in row or len(str(row['T_IAS_MAIL_SUBJECT'])) == 0
                        
                        if mail_def_missing or mail_msg_missing or mail_subj_missing:
                            error_list.append("125")
                    
                    if row['ACTION_TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS':
                        sms_def_missing = 'T_IAA_SMS_DEFINITION' not in row or len(str(row['T_IAA_SMS_DEFINITION'])) == 0
                        sms_msg_missing = 'TRIGGER_ITEM_ACTION_SEND_SMS_MESSAGE' not in row or len(str(row['TRIGGER_ITEM_ACTION_SEND_SMS_MESSAGE'])) == 0
                        
                        if sms_def_missing or sms_msg_missing:
                            error_list.append("126")
                    
                    # Validations for CONDITION_TYPE
                    if row['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE':
                        if 'T_IA_CSP_SP_IN_NNBC' not in row or len(str(row['T_IA_CSP_SP_IN_NNBC'])) == 0:
                            error_list.append("127")
                    
                    if row['CONDITION_TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE_FOR _GROUP':
                        if 'T_IA_CSP_4G_SP_IN_NBC' not in row or len(str(row['T_IA_CSP_4G_SP_IN_NBC'])) == 0:
                            error_list.append("128")
                    
                    # Check field validations
                    for col, check_func, error_message in rule_trigger_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)
                    
                    # If we found any errors, mark this row for dropping
                    if error_list:
                        drop_row_index.append(index)
                    
                    # Join all error codes
                    row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error(f"Error: {e}, during table {table_name} validation")
            raise
        
        # Apply column renaming if needed
        if 'rename_dict' in globals() or 'rename_dict' in locals():
            df_rule_trigger = replace_columns_by_prefix(df_rule_trigger, rename_dict)
        
        # Clean up data
        df_rule_trigger.replace('None', '', inplace=True)
        df_rule_trigger.replace('nan', '', inplace=True)
        df_rule_trigger.replace('NaT', '', inplace=True)
        
        # Create error dataframe
        logger_info.info(f"Found {len(drop_row_index)} validation errors")
        df_partial_error = pd.DataFrame()
        if drop_row_index:
            df_partial_error = df_rule_trigger.loc[drop_row_index].copy()
        
        # Clean up directories if needed
        if "validation_error_dir" in globals() and "dir_path" in globals():
            delete_before(validation_error_dir, dir_path)
        
        # Log and store error records
        logger_info.info(f'Length of rule_trigger records validation Error: {len(df_partial_error)}')
        
        if not df_partial_error.empty:
            logger_info.info(f'Table {table_name}, Validation Errors: {df_partial_error}')
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)
        
        # Remove error rows from main dataframe
        df_rule_trigger = df_rule_trigger.drop(drop_row_index)
        df_rule_trigger = df_rule_trigger.reset_index(drop=True)
        
        # Drop the code column before inserting into success table
        df_rule_trigger.drop(columns=['code'], inplace=True)
        
        # Insert valid records
        truncate_mysql_table(validation_db_configs, 'trigger_success', logger_error)
        insert_batches_df_into_mysql(df_rule_trigger, validation_db_configs, 'trigger_success', logger_info, logger_error)
        
        # Save valid records to CSV for debugging
        df_rule_trigger.to_csv('trigger_success.csv', index=False)
        
        # Calculate execution time
        end_time = round((time.time() - start_time), 2)
        logger_info.info(f"Process execution time {end_time} sec")
        
        # Update summary table
        insert_into_summary_table(
            metadata_db_configs, 
            'validation_summary', 
            logger_info, 
            logger_error,
            'rule_trigger', 
            length_of_original_df, 
            len(df_rule_trigger),
            len(df_partial_error),
            end_time, 
            curr_date
        )
        
        return df_rule_trigger
    
    except Exception as e:
        logger_error.error(f"Error processing rule_trigger customer data: {e}")
    

def rule_trigger_attribute_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, 'trigger_attribute_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        df_rule_trigger_attr = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_rule_trigger_attr = df_rule_trigger_attr.replace('None', '')
        df_rule_trigger_attr = df_rule_trigger_attr.replace('nan', '')
        df_rule_trigger_attr.to_csv("rule_trigger_new.csv", index=False)
        logger_info.info("DF rule_trigger : {}".format(df_rule_trigger_attr))
        length_of_original_df = len(df_rule_trigger_attr)
        # df_rule_trigger_attr = drop_duplicates_and_save_duplicates(df_rule_trigger_attr, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_rule_trigger_attr)
        for column in df_rule_trigger_attr.columns:
            df_rule_trigger_attr[column] = df_rule_trigger_attr[column].apply(lambda x: str(x).strip())

        df_rule_trigger_attr = df_rule_trigger_attr.astype(str)
        df_rule_trigger_attr["code"] = ''

        try:

            for index, row in df_rule_trigger_attr.iterrows():
                error_list = []
                # data_type_error_list = []

                missing_columns = [col for col in rule_trigger_attr_required_columns if len(row[col]) == 0]
                

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_MAIL' and len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_ADDRESS']) == 0 :
                    error_list.append("121")

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS' and len(row['TRIGGER_ITEM_ACTION_SEND_SMS_PHONE']) == 0 :
                    error_list.append("122")

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION.CHANGE_SP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_NEW_SERVICE_PROFILE_CONTEXT']) == 0 :
                    error_list.append("123")

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP_NEW_SERVICE_PROFILE_CONTEXT']) == 0 :
                    error_list.append("124")

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_EMAIL' and ( len(row['TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_MAIL_DEFINITION']) == 0 \
                or len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_MESSAGE']) == 0  or len(row['TRIGGER_ITEM_ACTION_SEND_MAIL_SUBJECT']) == 0 ):
                    error_list.append("125")

                if row['TYPE'] == 'TRIGGER_ITEM_ACTION.SEND_SMS' and ( len(row['TRIGGER_ITEM_ADDITIONAL_ATTRIBUTE_SMS_DEFINITION']) == 0 \
                or len(row['TRIGGER_ITEM_ACTION_SEND_SMS_MESSAGE']) == 0):
                    error_list.append("126")

                if row['TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_SERVICE_PROFILE_IN_NEXT_BILLING_CYCLE']) == 0 :
                    error_list.append("127")

                if row['TYPE'] == 'TRIGGER_ITEM_CONDITION.SP_CHANGE_FOR _GROUP' and len(row['TRIGGER_ITEM_ACTION_CHANGE_SP_FOR_GROUP_SERVICE_PROFILE_IN_NEXT_BILLING_CYCLE']) == 0 :
                    error_list.append("128")


                error_list.extend(
                    rule_trigger_attr_missing_value_mapper[col] for col in missing_columns if col in rule_trigger_attr_missing_value_mapper)

                for col, check_func, error_message in rule_trigger_attr_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_rule_trigger_attr.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_rule_trigger_attr.iloc[drop_row_index, :]

        df_partial_error = df_rule_trigger_attr.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of rule_trigger records validation Error : ', len(df_partial_error))
        logger_info.info('Length of rule_trigger records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            # sql_query_delete_table(validation_db_configs, 'trigger_attribute_failure', logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'trigger_attribute_failure', logger_info,
                                         logger_error)
            df_partial_error.to_csv('error.csv', index=False)

        df_rule_trigger_attr = df_rule_trigger_attr.drop(drop_row_index)

        df_rule_trigger_attr = df_rule_trigger_attr.reset_index(drop=True)

        ############### Insert into db ###############################
        df_rule_trigger_attr.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'trigger_attribute_success', logger_error)
        insert_batches_df_into_mysql(df_rule_trigger_attr, validation_db_configs, 'trigger_attribute_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'rule_trigger', length_of_original_df, len(df_rule_trigger_attr),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_rule_trigger_attr

    except Exception as e:
        logger_error.error("error processing rule_trigger customer data :{}".format(e))
        raise ValueError("error processing rule_trigger customer data")


def notification_template_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'notifications_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_notification_template = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_notification_template = df_notification_template.replace('None', '')
        df_notification_template = df_notification_template.replace('nan', '')
        df_notification_template.to_csv("notification_template_new.csv", index=False)
        logger_info.info("DF notification_template : {}".format(df_notification_template))
        length_of_original_df = len(df_notification_template)

        # df_notification_template = drop_duplicates_and_save_duplicates(df_notification_template, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_notification_template)
        
        for column in df_notification_template.columns:
            df_notification_template[column] = df_notification_template[column].apply(lambda x: str(x).strip())

        df_notification_template = df_notification_template.astype(str)
        df_notification_template["code"] = ''

        try:
            # check for cross validations
            df_notification_template, cross_validation_drop_row_index = cross_check_validation(df_notification_template, cross_validation_column='CUSTOMER_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)
            
            for index, row in df_notification_template.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []

                    missing_columns = [col for col in notification_template_required_columns if len(row[col]) == 0]
                    if len(row['CUSTOMER_ID']) == 0 and len(row['BU_ID']) == 0 :
                        error_list.append("104")

                    if row['TYPE'] == 'Mail Template' and len(row['SUBJECT']) == 0 :
                        error_list.append("110")

                    if row['TYPE'] == 'Bulk SMS Template' and len(row['SMS_TYPE']) == 0 :
                        error_list.append("111")

                    error_list.extend(
                        notification_template_missing_value_mapper[col] for col in missing_columns if col in notification_template_missing_value_mapper)

                    for col, check_func, error_message in notification_template_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))



        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_notification_template.index)

        if len(drop_row_index) > 0:
            df_partial_error = df_notification_template.iloc[drop_row_index, :]

        df_partial_error = df_notification_template.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of notification_template records validation Error : ', len(df_partial_error))
        logger_info.info('Length of notification_template records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_notification_template = df_notification_template.drop(drop_row_index)

        df_notification_template = df_notification_template.reset_index(drop=True)

        ############### Insert into db ###############################
        df_notification_template.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'notifications_success', logger_error)
        insert_batches_df_into_mysql(df_notification_template, validation_db_configs, 'notifications_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'notification_template', length_of_original_df, len(df_notification_template),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_notification_template

    except Exception as e:
        logger_error.error("error processing notification_template customer data :{}".format(e))
        raise ValueError("error processing notification_template customer data")


def label_creation_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, 'label_creation_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        df_label_creation = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_label_creation = df_label_creation.replace('None', '')
        df_label_creation = df_label_creation.replace('nan', '')
        df_label_creation.to_csv("label_creation_new.csv", index=False)
        logger_info.info("DF label_creation : {}".format(df_label_creation))
        length_of_original_df = len(df_label_creation)
        # df_label_creation = drop_duplicates_and_save_duplicates(df_label_creation, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_label_creation)
        for column in df_label_creation.columns:
            df_label_creation[column] = df_label_creation[column].apply(lambda x: str(x).strip())

        df_label_creation = df_label_creation.astype(str)
        df_label_creation["code"] = ''

        try:

            for index, row in df_label_creation.iterrows():
                error_list = []

                missing_columns = [col for col in label_creation_required_columns if len(row[col]) == 0]

                if len(row['OPCOID'])==0 and len(row['CUSTOMER_ID']) == 0 and len(row['BU_ID']) == 0 :
                    error_list.append("103")

                error_list.extend(
                    label_creation_missing_value_mapper[col] for col in missing_columns if col in label_creation_missing_value_mapper)

                for col, check_func, error_message in label_creation_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_label_creation.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_label_creation.iloc[drop_row_index, :]

        df_partial_error = df_label_creation.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of label_creation records validation Error : ', len(df_partial_error))
        logger_info.info('Length of label_creation records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            # sql_query_delete_table(validation_db_configs, 'label_creation_failure', logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'label_creation_failure', logger_info,
                                         logger_error)
            df_partial_error.to_csv('error.csv', index=False)

        df_label_creation = df_label_creation.drop(drop_row_index)

        df_label_creation = df_label_creation.reset_index(drop=True)

        ############### Insert into db ###############################
        df_label_creation.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'label_creation_success', logger_error)
        insert_batches_df_into_mysql(df_label_creation, validation_db_configs, 'label_creation_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'label_creation', length_of_original_df, len(df_label_creation),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_label_creation

    except Exception as e:
        logger_error.error("error processing label_creation customer data :{}".format(e))
        raise ValueError("error processing label_creation customer data")


def label_assignment_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, 'label_assignment_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        df_label_assignment = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_label_assignment = df_label_assignment.replace('None', '')
        df_label_assignment = df_label_assignment.replace('nan', '')
        df_label_assignment.to_csv("label_assignment_new.csv", index=False)
        logger_info.info("DF label_assignment : {}".format(df_label_assignment))
        length_of_original_df = len(df_label_assignment)
        # df_label_assignment = drop_duplicates_and_save_duplicates(df_label_assignment, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_label_assignment)
        for column in df_label_assignment.columns:
            df_label_assignment[column] = df_label_assignment[column].apply(lambda x: str(x).strip())

        df_label_assignment = df_label_assignment.astype(str)
        df_label_assignment["code"] = ''

        try:

            for index, row in df_label_assignment.iterrows():
                error_list = []

                missing_columns = [col for col in label_assignment_required_columns if len(row[col]) == 0]

                error_list.extend(
                    label_assignment_missing_value_mapper[col] for col in missing_columns if col in label_assignment_missing_value_mapper)

                for col, check_func, error_message in label_assignment_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_label_assignment.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_label_assignment.iloc[drop_row_index, :]

        df_partial_error = df_label_assignment.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of label_assignment records validation Error : ', len(df_partial_error))
        logger_info.info('Length of label_assignment records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            # sql_query_delete_table(validation_db_configs, 'label_assignment_failure', logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'label_assignment_failure', logger_info,
                                         logger_error)
            df_partial_error.to_csv('error.csv', index=False)

        df_label_assignment = df_label_assignment.drop(drop_row_index)

        df_label_assignment = df_label_assignment.reset_index(drop=True)

        ############### Insert into db ###############################
        df_label_assignment.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'label_assignment_success', logger_error)
        insert_batches_df_into_mysql(df_label_assignment, validation_db_configs, 'label_assignment_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'label_assignment', length_of_original_df, len(df_label_assignment),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_label_assignment

    except Exception as e:
        logger_error.error("error processing label_assignment customer data :{}".format(e))
        raise ValueError("error processing label_assignment customer data")
    
    
def service_profiles_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'service_profiles_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_service_profiles = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_service_profiles = df_service_profiles.replace('None', '')
        df_service_profiles = df_service_profiles.replace('nan', '')
        df_service_profiles.to_csv("service_profiles_new.csv", index=False)
        logger_info.info("DF service_profiles : {}".format(df_service_profiles))
        length_of_original_df = len(df_service_profiles)
        # df_service_profiles = drop_duplicates_and_save_duplicates(df_service_profiles, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_service_profiles)
        for column in df_service_profiles.columns:
            df_service_profiles[column] = df_service_profiles[column].apply(lambda x: str(x).strip())

        df_service_profiles = df_service_profiles.astype(str)
        df_service_profiles["code"] = ''

        try:
            # check for cross validations
            df_service_profiles, cross_validation_drop_row_index = cross_check_validation(df_service_profiles, cross_validation_column='OWNING_LIFECYCLE_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)

            for index, row in df_service_profiles.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []

                    missing_columns = [col for col in service_profiles_required_columns if len(row[col]) == 0]

                    error_list.extend(
                        service_profiles_missing_value_mapper[col] for col in missing_columns if col in service_profiles_missing_value_mapper)

                    for col, check_func, error_message in service_profiles_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_service_profiles.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_service_profiles.iloc[drop_row_index, :]

        df_partial_error = df_service_profiles.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of service_profiles records validation Error : ', len(df_partial_error))
        logger_info.info('Length of service_profiles records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_service_profiles = df_service_profiles.drop(drop_row_index)

        df_service_profiles = df_service_profiles.reset_index(drop=True)

        ############### Insert into db ###############################
        df_service_profiles.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'service_profiles_success', logger_error)
        insert_batches_df_into_mysql(df_service_profiles, validation_db_configs, 'service_profiles_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'service_profiles', length_of_original_df, len(df_service_profiles),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_service_profiles

    except Exception as e:
        logger_error.error("error processing service_profiles customer data :{}".format(e))
        raise ValueError("error processing service_profiles customer data")


def life_cycles_validation(logger_info, logger_error, table_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'life_cycles_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        ########## Truncating error table
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_life_cycles = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_life_cycles = df_life_cycles.replace('None', '')
        df_life_cycles = df_life_cycles.replace('nan', '')
        df_life_cycles.to_csv("life_cycles_new.csv", index=False)
        logger_info.info("DF life_cycles : {}".format(df_life_cycles))
        length_of_original_df = len(df_life_cycles)
        # df_life_cycles = drop_duplicates_and_save_duplicates(df_life_cycles, duplication_error_path,logger_info,'ACCOUNT_NO')
        # print('\n duplicate data frame', df_life_cycles)
        for column in df_life_cycles.columns:
            df_life_cycles[column] = df_life_cycles[column].apply(lambda x: str(x).strip())

        df_life_cycles = df_life_cycles.astype(str)
        df_life_cycles["code"] = ''

        try:
            # check for cross validations
            df_life_cycles, cross_validation_drop_row_index = cross_check_validation(df_life_cycles, cross_validation_column='CUSTOMER_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)

            for index, row in df_life_cycles.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []

                    missing_columns = [col for col in life_cycles_required_columns if len(row[col]) == 0]

                    error_list.extend(
                        life_cycles_missing_value_mapper[col] for col in missing_columns if col in life_cycles_missing_value_mapper)

                    for col, check_func, error_message in life_cycles_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
            
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        df_partial_error = pd.DataFrame()
        print("dropped index ", drop_row_index)
        print('dataframe index ', df_life_cycles.index)
        if len(drop_row_index) > 0:
            df_partial_error = df_life_cycles.iloc[drop_row_index, :]

        df_partial_error = df_life_cycles.iloc[drop_row_index, :]

        delete_before(validation_error_dir, dir_path)
        print('Length of life_cycles records validation Error : ', len(df_partial_error))
        logger_info.info('Length of life_cycles records validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        ## If df_partial_error is not empty then make file
        if not df_partial_error.empty:
            print('Error : ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name, df_partial_error))
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)

        df_life_cycles = df_life_cycles.drop(drop_row_index)

        df_life_cycles = df_life_cycles.reset_index(drop=True)

        ############### Insert into db ###############################
        df_life_cycles.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'life_cycles_success', logger_error)
        insert_batches_df_into_mysql(df_life_cycles, validation_db_configs, 'life_cycles_success', logger_info, logger_error)

        # print("*****************************")
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                  'life_cycles', length_of_original_df, len(df_life_cycles),
                                  len(df_partial_error),
                                  end_time, curr_date)

        return df_life_cycles

    except Exception as e:
        logger_error.error("error processing life_cycles customer data :{}".format(e))
        raise ValueError("error processing life_cycles customer data")
    

def report_subscriptions_validation(logger_info, logger_error,file_name):
    """
           Method to check missing values in csv file M2M_Customer and converting it into required format
           :param name : dataframe
           :param path : column error file path
           :param logger_info :
           :param logger_error:
           :return: filtered dataframe"""
    try:
        MYSQL_FAILURE_TABLE_NAME = 'report_subscriptions_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate failure table on mysql and oracle
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []

        start_time = time.time()
        # df_report_subscriptions = read_table_as_df('business_unit',validation_db_configs,logger_info, logger_error)
        df_report_subscriptions = read_df_oracle(oracle_source_db, file_name, chunk_size, logger_info, logger_error)
        df_report_subscriptions.to_csv("report_subscriptions.csv", index=False)
        length_of_original_df = len(df_report_subscriptions)
        print(df_report_subscriptions)
        
        # Drop duplicates based on ID column
        df_report_subscriptions = df_report_subscriptions.drop_duplicates(subset='ID', keep='first').reset_index(drop=True)
        
        for column in df_report_subscriptions.columns:
            df_report_subscriptions[column] = df_report_subscriptions[column].apply(lambda x: str(x).strip())

        df_report_subscriptions = df_report_subscriptions.astype(str)

        df_report_subscriptions["code"] = ''
        # df_report_subscriptions["Type_Mismatch"] = ''


        # column_error_list = []
        # data_type_mismatch = []

        def convert_to_int_or_empty(x):
            try:
                # why checking here 'nan' because above we converted the df astype(str)
                if x and x.lower() != 'nan':
                    return int(float(x))
                else:
                    return ''
            except (ValueError, TypeError):
                return ''

        df_report_subscriptions['REPORT_TYPE'] = df_report_subscriptions['REPORT_TYPE'].apply(convert_to_int_or_empty)

        # check for cross validation
        df_report_subscriptions, cross_validation_drop_row_index = cross_check_validation(df_report_subscriptions, cross_validation_column='CRMEC_ID', logger_info=logger_info, logger_error=logger_error)
        drop_row_index.extend(cross_validation_drop_row_index)

        for index, row in df_report_subscriptions.iterrows():
            if row['code'] == '' or row['code'] == None:                    
                error_list = []
                # data_type_error_list = []
                    
                missing_columns = [col for col in report_subscriptions_required_columns if len(str(row[col])) == 0]

                if row['REPORT_TYPE'] != 17590:
                    # error_list.append("Missing value CRM_RESELLER_ID,CRM_CUSTOMER_ID,CRM_BU_ID")
                    error_list.append("109")

                # error_list.extend(f"Missing value {col}" for col in missing_columns)
                error_list.extend(report_subscriptions_missing_value_mapper[col] for col in missing_columns if col in report_subscriptions_missing_value_mapper)

                
                for col, check_func, error_message in report_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                if error_list:
                    drop_row_index.append(index)


                row["code"] = ', '.join(error_list)
                # row["Type_Mismatch"] = ', '.join(data_type_error_list)
                # column_error_list.extend(error_list)
                # data_type_mismatch.extend(data_type_error_list)

        df_report_subscriptions.replace({'nan': '', 'None': '', 'NaT': ''}, inplace=True)

        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_report_subscriptions.iloc[drop_row_index, :]

        df_partial_error = df_report_subscriptions.iloc[drop_row_index, :]

        delete_before(validation_error_dir,dir_path)
        print('Length ofReports  records validation Error : ', len(df_partial_error))
        logger_info.info('Length ofReports  validation Error : {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        if not df_partial_error.empty:
            print('Error : ',df_partial_error)
            logger_info.info(' Table {}, Validation Errors : {}'.format(table_name,df_partial_error))
            truncate_mysql_table(validation_db_configs, 'report_subscriptions_failure', logger_error)
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)
        
        df_report_subscriptions = df_report_subscriptions.drop(drop_row_index)

        df_report_subscriptions = df_report_subscriptions.reset_index(drop=True)

        ############### Insert into db ###############################
        df_report_subscriptions.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'report_subscriptions_success', logger_error)
        insert_batches_df_into_mysql(df_report_subscriptions, validation_db_configs, 'report_subscriptions_success', logger_info, logger_error)
        # print("*****************************")
        end_time = (time.time()) - start_time
        print("Process execution time {} ".format(end_time))
        insert_into_summary_table(metadata_db_configs,'validation_summary' ,logger_info, logger_error,'Report Subscriptions', length_of_original_df, len(df_report_subscriptions), len(df_partial_error),
                                  end_time,curr_date)
        return df_report_subscriptions

    except Exception as e:
        print("error processingReports  data :{}".format(e))
        logger_error.error("error processingReports  data :{}".format(e))
        # raise ValueError("error processingReports  data")


def ip_pool_validation(logger_info, logger_error, table_name):
    """
    Method to check missing values in IP Pool data and validate required fields
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :param table_name: Name of the table to validate
    :return: filtered dataframe
    """
    try:
        MYSQL_FAILURE_TABLE_NAME = 'ip_pool_failure'
        ORACLE_FAILURE_TABLE_NAME = mysql_table_oracle_table_mapper[MYSQL_FAILURE_TABLE_NAME]

        # Truncate error table from mysql and oracle
        truncate_mysql_table(validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_error)
        truncate_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, logger_info, logger_error)

        drop_row_index = []
        start_time = time.time()
        df_ip_pool = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)

        df_ip_pool = df_ip_pool.replace('None', '')
        df_ip_pool = df_ip_pool.replace('nan', '')
        df_ip_pool.to_csv("ip_pool.csv", index=False)
        logger_info.info("DF IP Pool: {}".format(df_ip_pool))
        length_of_original_df = len(df_ip_pool)

        # Clean data and prepare for validation
        for column in df_ip_pool.columns:
            df_ip_pool[column] = df_ip_pool[column].apply(lambda x: str(x).strip())

        df_ip_pool = df_ip_pool.astype(str)
        df_ip_pool["code"] = ''

        try:
            # check for cross validations
            df_ip_pool, cross_validation_drop_row_index = cross_check_validation(df_ip_pool, cross_validation_column='CUSTOMER_ID', logger_info=logger_info, logger_error=logger_error)
            drop_row_index.extend(cross_validation_drop_row_index)

            for index, row in df_ip_pool.iterrows():
                if row['code'] == '' or row['code'] == None:
                    error_list = []

                    # Check for missing required columns
                    missing_columns = [col for col in ip_pool_required_columns if len(row[col]) == 0]
                    error_list.extend(
                        ip_pool_missing_value_mapper[col] for col in missing_columns if col in ip_pool_missing_value_mapper
                    )

                    # Perform data type and format validations
                    for col, check_func, error_message in ip_pool_checks:
                        col_value = str(row[col])
                        if len(col_value) != 0 and not check_func(col_value):
                            error_list.append(error_message)

                    # If there are any errors, add the row index to the drop list
                    if error_list:
                        drop_row_index.append(index)

                    row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        # Create error dataframe
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = df_ip_pool.iloc[drop_row_index, :]

        df_partial_error = df_ip_pool.iloc[drop_row_index, :]

        # Log validation results
        delete_before(validation_error_dir, dir_path)
        print('Length of IP Pool records validation Error: ', len(df_partial_error))
        logger_info.info('Length of IP Pool records validation Error: {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        df_ip_pool.replace({np.nan: None}, inplace=True)
        df_ip_pool.replace({'': None}, inplace=True)

        # If there are errors, save them to the database
        if not df_partial_error.empty:
            print('Error: ', df_partial_error)
            logger_info.info(' Table {}, Validation Errors: {}'.format(table_name, df_partial_error))
            df_partial_error.to_csv(f'{logs_path}/ip_pool_failure.csv', index=False)
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, MYSQL_FAILURE_TABLE_NAME, logger_info, logger_error)
            insert_into_oracle_table(oracle_source_db, ORACLE_FAILURE_TABLE_NAME, df_partial_error, logger_info, logger_error)

        # Remove error rows from the main dataframe
        df_ip_pool = df_ip_pool.drop(drop_row_index)
        df_ip_pool = df_ip_pool.reset_index(drop=True)

        # Insert successful records into the database
        df_ip_pool.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'ip_pool_success', logger_error)
        insert_batches_df_into_mysql(df_ip_pool, validation_db_configs, 'ip_pool_success', logger_info, logger_error)
        df_ip_pool.to_csv(f'{logs_path}/ip_pool_success.csv', index=False)
        
        # Calculate and log execution time
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                 'IP Pool', length_of_original_df, len(df_ip_pool),
                                 len(df_partial_error),
                                 end_time, curr_date)

    except Exception as e:
        logger_error.error("Error processing IP Pool data: {}".format(e))


def address_validation(logger_info, logger_error, table_name):
    """
    Method to check missing values in Address data and validate required fields
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :param table_name: Name of the table to validate
    :return: filtered dataframe
    """
    try:
        truncate_mysql_table(metadata_db_configs, 'addresses', logger_error)
        
        address_df = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)
        
        address_df = address_df.replace('None', '')
        address_df = address_df.replace('nan', '')
        address_df.to_csv("address.csv", index=False)
        
        logger_info.info("Address DataFrame: {}".format(address_df))
        length_of_original_df = len(address_df)

        # Clean data and prepare for validation
        for column in address_df.columns:
            address_df[column] = address_df[column].apply(lambda x: str(x).strip())

        address_df = address_df.astype(str)

        logger_info.info("Address DataFrame after cleaning: {}".format(address_df))

        logger_info.info(f"Inserting the addresses length({length_of_original_df}) data into the metadata db")

        insert_batches_df_into_mysql(address_df, metadata_db_configs, 'addresses', logger_info, logger_error)
    
    except Exception as e:
        print("Error processing address data: {}".format(e))
        logger_error.error("Error processing address data: {}".format(e))
        

def bu_account_to_tp_mapping_validation(logger_info, logger_error, table_name):
    """
    Method to check missing values in BU_ACCOUNT_TO_TP_MAPPING data and validate required fields
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :param table_name: Name of the table to validate
    :return: filtered dataframe
    """
    try:
        # Truncate error table
        truncate_mysql_table(validation_db_configs, 'bu_account_to_tp_mapping_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        bu_tp_mapping_df = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)
        print(bu_tp_mapping_df.head(5))
        bu_tp_mapping_df = bu_tp_mapping_df.replace('None', '')
        bu_tp_mapping_df = bu_tp_mapping_df.replace('nan', '')
        bu_tp_mapping_df.to_csv("bu_account_to_tp_mapping.csv", index=False)
        logger_info.info("bu account to tp mapping: {}".format(bu_tp_mapping_df))
        length_of_original_df = len(bu_tp_mapping_df)

        # Clean data and prepare for validation
        for column in bu_tp_mapping_df.columns:
            bu_tp_mapping_df[column] = bu_tp_mapping_df[column].apply(lambda x: str(x).strip())

        bu_tp_mapping_df = bu_tp_mapping_df.astype(str)
        bu_tp_mapping_df["code"] = ''

        try:
            for index, row in bu_tp_mapping_df.iterrows():
                error_list = []

                # Check for missing required columns
                missing_columns = [col for col in bu_account_to_tp_required_columns if len(row[col]) == 0]
                error_list.extend(
                    bu_account_to_tp_missing_value_mapper[col] for col in missing_columns if col in bu_account_to_tp_missing_value_mapper
                )
                # Perform data type and format validations
                for col, check_func, error_message in bu_account_to_tp_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                # If there are any errors, add the row index to the drop list
                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        # Create error dataframe
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = bu_tp_mapping_df.iloc[drop_row_index, :]

        df_partial_error = bu_tp_mapping_df.iloc[drop_row_index, :]

        # Log validation results
        delete_before(validation_error_dir, dir_path)
        print('Length of bu tp mapping records validation Error: ', len(df_partial_error))
        logger_info.info('Length of bu tp mapping records validation Error: {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        bu_tp_mapping_df.replace({np.nan: None}, inplace=True)
        bu_tp_mapping_df.replace({'': None}, inplace=True)

        # If there are errors, save them to the database
        if not df_partial_error.empty:
            print('Error: ', df_partial_error)
            print("Table {}, Validation Errors: {}".format(table_name, df_partial_error))
            logger_info.info(' Table {}, Validation Errors: {}'.format(table_name, df_partial_error))
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'bu_account_to_tp_mapping_failure', logger_info, logger_error)
            df_partial_error.to_csv(f'{logs_path}/bu_account_to_tp_mapping_failure.csv', index=False)

        # Remove error rows from the main dataframe
        bu_tp_mapping_df = bu_tp_mapping_df.drop(drop_row_index)
        bu_tp_mapping_df = bu_tp_mapping_df.reset_index(drop=True)

        # Insert successful records into the database
        bu_tp_mapping_df.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, 'bu_account_to_tp_mapping_success', logger_error)
        insert_batches_df_into_mysql(bu_tp_mapping_df, validation_db_configs, 'bu_account_to_tp_mapping_success', logger_info, logger_error)
        bu_tp_mapping_df.to_csv(f'{logs_path}/bu_account_to_tp_mapping_success.csv', index=False)
        
        # Calculate and log execution time
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                 'bu tp mapping', length_of_original_df, len(bu_tp_mapping_df),
                                 len(df_partial_error),
                                 end_time, curr_date)

    except Exception as e:
        logger_error.error("Error processing bu tp mapping data: {}".format(e))


def dic_bill_cycle_validation(logger_info, logger_error, table_name):
    """
    Method to check missing values in dic bill cycle data and validate required fields
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :param table_name: Name of the table to validate
    :return: filtered dataframe
    """
    try:
        # Truncate error table
        truncate_mysql_table(validation_db_configs, 'dic_bill_cycle_failure', logger_error)

        drop_row_index = []
        start_time = time.time()
        dic_bill_cycle_df = read_df_oracle(oracle_source_db, table_name, chunk_size, logger_info, logger_error)
        print(dic_bill_cycle_df.head(5))
        dic_bill_cycle_df = dic_bill_cycle_df.replace('None', '')
        dic_bill_cycle_df = dic_bill_cycle_df.replace('nan', '')
        dic_bill_cycle_df.to_csv("dic_bill_cycle.csv", index=False)
        logger_info.info("dic bill cycle: {}".format(dic_bill_cycle_df))
        length_of_original_df = len(dic_bill_cycle_df)

        # Clean data and prepare for validation
        for column in dic_bill_cycle_df.columns:
            dic_bill_cycle_df[column] = dic_bill_cycle_df[column].apply(lambda x: str(x).strip())

        dic_bill_cycle_df = dic_bill_cycle_df.astype(str)
        dic_bill_cycle_df["code"] = ''

        try:
            for index, row in dic_bill_cycle_df.iterrows():
                error_list = []

                # Check for missing required columns
                missing_columns = [col for col in dic_bill_cycle_required_columns if len(row[col]) == 0]
                error_list.extend(
                    dic_bill_cycle_missing_value_mapper[col] for col in missing_columns if col in dic_bill_cycle_missing_value_mapper
                )
                # Perform data type and format validations
                for col, check_func, error_message in dic_bill_cycle_checks:
                    col_value = str(row[col])
                    if len(col_value) != 0 and not check_func(col_value):
                        error_list.append(error_message)

                # If there are any errors, add the row index to the drop list
                if error_list:
                    drop_row_index.append(index)

                row["code"] = ', '.join(error_list)
                
        except Exception as e:
            logger_error.error("Error :{}, during table {} validation ".format(e, table_name))

        # Create error dataframe
        df_partial_error = pd.DataFrame()
        if len(drop_row_index) > 0:
            df_partial_error = dic_bill_cycle_df.iloc[drop_row_index, :]

        df_partial_error = dic_bill_cycle_df.iloc[drop_row_index, :]

        # Log validation results
        delete_before(validation_error_dir, dir_path)
        print('Length of dic bill cycle records validation Error: ', len(df_partial_error))
        logger_info.info('Length of dic bill cycle records validation Error: {}'.format(len(df_partial_error)))
        df_partial_error = df_partial_error.astype(str)

        dic_bill_cycle_df.replace({np.nan: None}, inplace=True)
        dic_bill_cycle_df.replace({'': None}, inplace=True)

        # If there are errors, save them to the database
        if not df_partial_error.empty:
            print('Error: ', df_partial_error)
            print("Table {}, Validation Errors: {}".format(table_name, df_partial_error))
            logger_info.info(' Table {}, Validation Errors: {}'.format(table_name, df_partial_error))
            insert_batches_df_into_mysql(df_partial_error, validation_db_configs, 'dic_bill_cycle_failure', logger_info, logger_error)
            df_partial_error.to_csv(f'{logs_path}/dic_bill_cycle_failure.csv', index=False)

        # Remove error rows from the main dataframe
        dic_bill_cycle_df = dic_bill_cycle_df.drop(drop_row_index)
        dic_bill_cycle_df = dic_bill_cycle_df.reset_index(drop=True)

        # Insert successful records into the database
        dic_bill_cycle_df.drop(columns=['code'], inplace=True)
        truncate_mysql_table(validation_db_configs, '', logger_error)
        insert_batches_df_into_mysql(dic_bill_cycle_df, validation_db_configs, 'dic_bill_cycle_success', logger_info, logger_error)
        dic_bill_cycle_df.to_csv(f'{logs_path}/dic_bill_cycle_success.csv', index=False)
        
        # Calculate and log execution time
        end_time = round((time.time() - start_time), 2)
        print("Process execution time {} sec".format(end_time))
        insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error,
                                 'dic bill cycle', length_of_original_df, len(dic_bill_cycle_df),
                                 len(df_partial_error),
                                 end_time, curr_date)

    except Exception as e:
        logger_error.error("Error processing dic bill cycle data: {}".format(e))


def combined_tarrif_plan_validation(logger_info: Logger, logger_error: Logger) -> None:
    try:
        COMBINED_TARIFF_PLANS_TABLE_NAME = 'combined_tariff_plans'
        truncate_mysql_table(validation_db_configs, COMBINED_TARIFF_PLANS_TABLE_NAME, logger_error)
        tariff_plans_df = pd.read_csv(f'{input_file_path}/combined_tariff_plans.csv')
        
        tariff_plans_df = tariff_plans_df.astype(str)

        tariff_plans_df.replace({'nan': None}, inplace=True)
        tariff_plans_df.replace({'': None}, inplace=True)
        
        # check for required columns
        missing_columns = [col for col in combined_tariff_plan_required_columns if col not in tariff_plans_df.columns]
        
        if missing_columns:
            logger_error.error(f"Missing columns in combined tariff plan data: {missing_columns}")
            return

        # drop rows of which the column RATING_ELEMENT is not Monthly Account Fee
        # keep the records only which are Monthly Account Fee
        tariff_plans_df = tariff_plans_df[tariff_plans_df['RATING_ELEMENT'] == 'Monthly Account Fee']

        # Another check is PARAMETER_SET column value is '' then we discrd those records
        # keep the records only which are PARAMETER_SET is not ''
        tariff_plans_df = tariff_plans_df[tariff_plans_df['PARAMETER_SET'] != '']

        # Another check is PARAMETER_SET column value is 'others' then we discard those records
        # apply check for x.lower() == 'others'
        tariff_plans_df = tariff_plans_df[tariff_plans_df['PARAMETER_SET'].apply(lambda x: x and x.lower()) != 'others']

        # Drop the rows of PARAMETER_SET Value is None
        tariff_plans_df = tariff_plans_df[tariff_plans_df['PARAMETER_SET'].notnull()]
        
        
        # Another check is we need to apply PRICE_PER_UNIT column this columns might have values like 50 EURO PER MONTH
        # we need to extract the value 50 and replace the value
        # if the value is 0 or 0.0 then we also discard those records
        tariff_plans_df['PRICE_PER_UNIT'] = tariff_plans_df['PRICE_PER_UNIT'].apply(lambda x: x.split(' ')[0] if float(x.split(' ')[0]) != 0.0 else None)
        
        # drop rows for PRICE_PER_UNIT column has None value
        tariff_plans_df = tariff_plans_df[tariff_plans_df['PRICE_PER_UNIT'].notnull()]
        
        # Re doing the indexing of valid records
        tariff_plans_df = tariff_plans_df.reset_index(drop=True)

        # Reaplce NaN with None
        tariff_plans_df.replace({np.nan: None}, inplace=True)
        tariff_plans_df.replace({'': None}, inplace=True)
        tariff_plans_df.replace({'nan': None}, inplace=True)
        
        # Insert the data into the database
        insert_batches_df_into_mysql(tariff_plans_df, validation_db_configs, COMBINED_TARIFF_PLANS_TABLE_NAME, logger_info, logger_error)
        tariff_plans_df.to_csv(f'{logs_path}/combined_tariff_plans_success.csv', index=False)
        print(tariff_plans_df)

    except Exception as e:
        logger_error.error("Error processing combined tariff plan data: {}".format(e))


def cross_check_validation(df, cross_validation_column: str, logger_info: Logger, logger_error: Logger):
    """
    Method to cross check the data in the dataframe against validated reference tables
    :param df: DataFrame to validate
    :param cross_validation_column: Column name to cross check
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    :return: List of row indexes that failed validation
    """
    # Creating a common error code for cross_validation_error
    cross_validation_error_code = '404'
    
    try:
        # Check if the cross validation column is present in the DataFrame
        if cross_validation_column not in df.columns:
            logger_error.error(f"Cross validation column {cross_validation_column} not found in dataframe")
            return []

        # Define column groupings for different entity types
        ec_columns = ['EC_CRM_ID', 'CRM_CUSTOMER_ID', 'CUSTOMER_ID', 'EC_ID', 'CRMEC_ID']
        bu_columns = ['CRM_BU_ID', 'BU_CRM_ID', 'BU_ID', 'CRMBU_ID', 'BUSINESS_UNIT_ID']
        cost_center_columns = ['CRMCC_ID', 'CC_ID', 'COST_CENTER_ID']
        life_cycles_columns = ['OWNING_LIFECYCLE_ID']
        
        # List to store row indexes to be dropped
        drop_row_index = []
        
        # Get values from the cross validation column, excluding empty values
        column_values = [val for val in df[cross_validation_column].unique() if val and val != '' and not pd.isna(val)]
        
        if not column_values:
            logger_info.info(f"No valid values found in column {cross_validation_column} for cross validation")
            return df, drop_row_index
            
        # Determine which reference table to check against based on the column type
        if cross_validation_column in ec_columns:
            try:
                # Fetch validated enterprise customers
                ec_validated_df = read_table_as_df('ec_success', validation_db_configs, logger_info, logger_error)
                
                if ec_validated_df is None or ec_validated_df.empty:
                    logger_error.error("Failed to retrieve validated enterprise customer data")
                    return df, drop_row_index
                
                # Get list of valid EC IDs
                valid_ec_ids = set([str(id_val) for id_val in ec_validated_df['CRM_ID'].tolist() if id_val and str(id_val).strip()])
                
                # Find rows with invalid EC IDs
                for index, row in df.iterrows():
                    ec_id = str(row[cross_validation_column]).strip() if row[cross_validation_column] else ''
                    if ec_id and ec_id not in valid_ec_ids:
                        row['code'] = cross_validation_error_code
                        drop_row_index.append(index)
                        logger_info.info(f"Row {index}: {cross_validation_column} value {ec_id} not found in validated enterprise customers")
                
            except Exception as e:
                logger_error.error(f"Error validating enterprise customer IDs: {e}")
                
        elif cross_validation_column in bu_columns:
            try:
                # Fetch validated business units
                bu_validated_df = read_table_as_df('bu_success', validation_db_configs, logger_info, logger_error)
                
                if bu_validated_df is None or bu_validated_df.empty:
                    logger_error.error("Failed to retrieve validated business unit data")
                    return df, drop_row_index
                
                # Get list of valid BU IDs
                valid_bu_ids = set([str(id_val) for id_val in bu_validated_df['BUCRM_ID'].tolist() if id_val and str(id_val).strip()])
                
                # Find rows with invalid BU IDs
                for index, row in df.iterrows():
                    bu_id = str(row[cross_validation_column]).strip() if row[cross_validation_column] else ''
                    if bu_id and bu_id not in valid_bu_ids:
                        row['code'] = cross_validation_error_code
                        drop_row_index.append(index)
                        logger_info.info(f"Row {index}: {cross_validation_column} value {bu_id} not found in validated business units")
                
            except Exception as e:
                logger_error.error(f"Error validating business unit IDs: {e}")
                
        elif cross_validation_column in cost_center_columns:
            try:
                # Fetch validated cost centers
                cc_validated_df = read_table_as_df('cc_success', validation_db_configs, logger_info, logger_error)
                
                if cc_validated_df is None or cc_validated_df.empty:
                    logger_error.error("Failed to retrieve validated cost center data")
                    return df, drop_row_index
                
                # Get list of valid CC IDs
                valid_cc_ids = set([str(id_val) for id_val in cc_validated_df['CCCRM_ID'].tolist() if id_val and str(id_val).strip()])
                
                # Find rows with invalid CC IDs
                for index, row in df.iterrows():
                    cc_id = str(row[cross_validation_column]).strip() if row[cross_validation_column] else ''
                    if cc_id and cc_id not in valid_cc_ids:
                        row['code'] = cross_validation_error_code
                        drop_row_index.append(index)
                        logger_info.info(f"Row {index}: {cross_validation_column} value {cc_id} not found in validated cost centers")
                
            except Exception as e:
                logger_error.error(f"Error validating cost center IDs: {e}")
                
        elif cross_validation_column in life_cycles_columns:
            try:
                # Fetch validated service profiles
                life_cycle_validated_df = read_table_as_df('life_cycles_success', validation_db_configs, logger_info, logger_error)
                
                if life_cycle_validated_df is None or life_cycle_validated_df.empty:
                    logger_error.error("Failed to retrieve validated service profile data")
                    return df, drop_row_index
                
                # Get list of valid SP IDs
                valid_lifecycle_ids = set([str(id_val) for id_val in life_cycle_validated_df['ID'].tolist() if id_val and str(id_val).strip()])
                
                # Find rows with invalid SP IDs
                for index, row in df.iterrows():
                    sp_id = str(row[cross_validation_column]).strip() if row[cross_validation_column] else ''
                    if sp_id and sp_id not in valid_lifecycle_ids:
                        row['code'] = cross_validation_error_code
                        drop_row_index.append(index)
                        logger_info.info(f"Row {index}: {cross_validation_column} value {sp_id} not found in validated service profiles")
                
            except Exception as e:
                logger_error.error(f"Error validating service profile IDs: {e}")
        
        else:
            logger_info.info(f"No cross-validation logic defined for column {cross_validation_column}")
            
        # Log summary information
        logger_info.info(f"Cross validation completed for column {cross_validation_column}")
        logger_info.info(f"Found {len(drop_row_index)} invalid rows out of {len(df)}")
        
        return df, drop_row_index
        
    except Exception as e:
        logger_error.error(f"Error in cross_check_validation function: {e}")
        return []


def validation(table_mapper: dict, logger_info: Logger, logger_error: Logger):
    """
    Method to validate the data in the files
    :param file_mapper: Dictionary containing the file names and the corresponding validation functions
    :param logger_info: Logger for info messages
    :param logger_error: Logger for error messages
    """


    for input_table_name, _ in table_mapper.items():
        
        try:    
            start_time = time.time()
            updated_df = None
            drop_row_index = None
            mysql_success_table, mysql_failure_table, summary_table_name, cross_validation_check_column = table_mapper[input_table_name]
            oracle_failure_table = mysql_table_oracle_table_mapper[mysql_failure_table]

            # Truncate oracle and mysql table
            truncate_mysql_table(validation_db_configs, mysql_failure_table, logger_error)
            truncate_oracle_table(oracle_source_db, oracle_failure_table, logger_info, logger_error)
            
            # Length of original dataframe
            length_of_original_df = 0


            if input_table_name == 'CUSTOMERS':
                df_enterprice = read_df_oracle(oracle_source_db, 'CUSTOMERS', chunk_size, logger_info, logger_error)
                length_of_original_df = len(df_enterprice)
                print("Length of original df : ", length_of_original_df)
                updated_df, drop_row_index = enterprise_customer_validation_v2(df_enterprice, logger_info, logger_error)

            elif input_table_name == 'BUSINESS_UNITS':
                df_bu = read_df_oracle(oracle_source_db, 'BUSINESS_UNITS', chunk_size, logger_info, logger_error)
                length_of_original_df = len(df_bu)
                print("Length of original df : ", length_of_original_df)
                updated_df, drop_row_index = business_unit_validation_v2(df_bu, logger_info, logger_error)

            if updated_df is None and drop_row_index is None:
                logger_info.info(f"Error processing {input_table_name} data")
                return
            
            df = updated_df
            df_partial_error = pd.DataFrame()
            print("dropped index ",drop_row_index)
            print('dataframe index ',df.index)
            if len(drop_row_index) > 0:
                df_partial_error = df.iloc[drop_row_index, :]

            df_partial_error = df.iloc[drop_row_index, :]

            delete_before(validation_error_dir,dir_path)
            print('Length of Enterprise records validation Error : ', len(df_partial_error))
            logger_info.info('Length of Enterprise records validation Error : {}'.format(len(df_partial_error)))
            df_partial_error = df_partial_error.astype(str)

            ## If df_partial_error is not empty then make file
            if not df_partial_error.empty:
                print('Error : ',df_partial_error)
                logger_info.info(' Table {}, Validation Errors : {}'.format(table_name,df_partial_error))
                insert_into_oracle_table(oracle_source_db, oracle_failure_table, df_partial_error, logger_info, logger_error)
                insert_batches_df_into_mysql(df_partial_error, validation_db_configs, mysql_failure_table, logger_info, logger_error)
                df_partial_error.to_csv(f'{logs_path}/{mysql_failure_table}.csv', index=False)

            df = df.drop(drop_row_index)
            df = df.reset_index(drop=True)

            ############### Insert into success db ###############################
            df.drop(columns=['code'], inplace=True)
            truncate_mysql_table(validation_db_configs, mysql_success_table, logger_error)
            insert_batches_df_into_mysql(df, validation_db_configs, mysql_success_table, logger_info, logger_error)
            
            end_time = round((time.time() - start_time), 2)
            print("Process execution time {} sec".format(end_time))
            insert_into_summary_table(metadata_db_configs, 'validation_summary', logger_info, logger_error, summary_table_name, 
                                    length_of_original_df, len(df), len(df_partial_error),
                                    end_time,curr_date)
            

        except Exception as e:
            logger_error.error(f"Error processing {input_table_name} data: {e}")


if __name__ == "__main__":

    print("Number of arguments:", len(sys.argv[1:]))
    print("Argument List:", str(sys.argv[1:]))
    
    # <ORACLE_INPUT_TABLE_NAME>: (<MYSQL_SUCCESS_TABLE_NAME>, <MYSQL_FAILURE_TABLE_NAME>, <SUMMARY_TABLE_NAME>, <CROSS_VALIDATION_CHECK_COLUMN_NAME>)
    # if CROSS_VALIDATION_CHECK_COLUMN_NAME -> None means we dont want to do cross validation
    # Define the mapping of tables to their corresponding success and failure table
    table_mapper = {
        'CUSTOMERS': ('ec_success', 'ec_failure', 'Enterprise Customer', None),
        'BUSINESS_UNITS': ('bu_success', 'bu_failure', 'Business Unit', 'EC_CRM_ID'),
        'USERS': ('user_success', 'user_failure', 'Users', 'CRM_CUSTOMER_ID'),
        'COST_CENTERS': ('cc_success', 'cc_failure', 'Cost Center', 'BU_CRM_ID'),
        'NOTIFICATIONS': ('notifications_success', 'notifications_failure', 'Notifications', 'CUSTOMER_ID'),
        'TRIGGERS': ('triggers_success', 'triggers_failure', 'Triggers', 'CRMEC_ID'),
        'DIC_APNS': ('apn_success', 'apn_failure', 'APN', None),
        'LIFE_CYCLES': ('life_cycles_success', 'life_cycles_failure', 'Life Cycles', 'CUSTOMER_ID'),
        'SERVICE_PROFILES': ('service_profiles_success', 'service_profiles_failure', 'Service Profiles', 'OWNING_LIFECYCLE_ID'),
        'SIM_ASSETS': ('asset_success', 'asset_failure', 'Assets', 'EC_ID'),
        'REPORTS': ('reports_success', 'reports_failure', 'Reports', 'CRMEC_ID'),
        'IP_POOL': ('ip_pool_success', 'ip_pool_failure', 'IP Pool', 'CUSTOMER_ID'),
    }

    
    # Access individual arguments
    for arg in sys.argv[1:]:
        if arg == "v2":
            validation(table_mapper, logger_info, logger_error)

        if arg == "addresses":
            address_validation(logger_info, logger_error, 'ADDRESSES')
        
        if arg == "customers":
            enterprise_customer_validation(logger_info, logger_error,'CUSTOMERS')

        if arg == 'bu':
            business_unit_validation(logger_info, logger_error,'BUSINESS_UNITS')

        if arg == "apn":
            apn_validation(logger_info, logger_error, 'DIC_APNS')
        
        if arg == 'reports':
            report_subscriptions_validation(logger_info, logger_error, 'REPORTS')

        if arg == "ip_pool":
            ip_pool_validation(logger_info, logger_error, 'IP_POOL')
            
        if arg == "service_profiles":
            service_profiles_validation(logger_info, logger_error, 'SERVICE_PROFILES')
        
        if arg == "tariff_plan":
            combined_tarrif_plan_validation(logger_info, logger_error)
        
        if arg == "users":
            user_validation(logger_info, logger_error, 'USERS')
        
        if arg == "cc":
            cost_center_validation(logger_info, logger_error, 'COST_CENTERS')
        
        if arg == "trigger":
            rule_trigger_validation(logger_info, logger_error, 'TRIGGERS')
        
        if arg == "notifications":
            notification_template_validation(logger_info, logger_error, 'NOTIFICATIONS')

        if arg == "lc":
            life_cycles_validation(logger_info, logger_error, 'LIFE_CYCLES')

        if arg == "asset":
            # depreceated
            asset_validation(logger_info, logger_error, 'SIM_ASSETS')

        if arg == "asset_batch":
            fetch_asset_data_in_batches(oracle_source_db)

        if arg == "abhishek":
            bu_account_to_tp_mapping_validation(logger_info, logger_error, 'BU_ACCOUNT_TO_TP_MAPPING')

            dic_bill_cycle_validation(logger_info, logger_error, 'DIC_BILL_CYCLE')

            dic_bill_cycle_validation(logger_info, logger_error, 'DIC_NEW_OPCO')

        if arg == "validation":
            # The partiular requirement is to truncate the validation summary table 
            # before executing the validation so that we can have the fresh data
            truncate_mysql_table(metadata_db_configs, 'validation_summary', logger_error)

            address_validation(logger_info, logger_error, 'ADDRESSES')

            enterprise_customer_validation(logger_info, logger_error,'CUSTOMERS')

            business_unit_validation(logger_info, logger_error,'BUSINESS_UNITS')

            user_validation(logger_info, logger_error, 'USERS')

            cost_center_validation(logger_info, logger_error, 'COST_CENTERS')

            apn_validation(logger_info, logger_error, 'DIC_APNS')

            notification_template_validation(logger_info, logger_error, 'NOTIFICATIONS')

            rule_trigger_validation(logger_info, logger_error, 'TRIGGERS')

            life_cycles_validation(logger_info, logger_error, 'LIFE_CYCLES')

            service_profiles_validation(logger_info, logger_error, 'SERVICE_PROFILES')
            
            # Since this asset table hai almost millions of rows we are processing this details in batches please comment while testing by dev as its taking 2.5 hours
            fetch_asset_data_in_batches(oracle_source_db)

            report_subscriptions_validation(logger_info, logger_error, 'REPORTS')

            ip_pool_validation(logger_info, logger_error, 'IP_POOL')

            # Uncomment this in future release not needed now else it will throw an error of file not exist
            combined_tarrif_plan_validation(logger_info, logger_error)
