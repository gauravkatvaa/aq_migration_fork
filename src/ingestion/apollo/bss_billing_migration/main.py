"""

"""

import pandas as pd
from mySqlFunctions import *
from logger import logger_
from config import *


def insert_filter_success_entries_to_db(data_from_db, internal_account_api_call, response_merged_df):
    '''

    :param data_from_db: Getting Pool Usage Data from db
    :param internal_account_api_call: Internal Account No on which 200 success response recieved Get_POOL_Usage_Detail
    :param response_merged_df: Merged Dataframe of Internal Account No and Response from api
    :return: Filter the records based on INTERNAL_ACCOUNT_NO values which recieved 200 status code on Get_POOL_Usage_Detail
    api calling after this Concatenating two dataframes the original df fetched from db and response_merged_df recieved on 200 status code
    after this iterating through the concat_df and inserting the records into db
    '''

    filtered_df = data_from_db[data_from_db['INTERNAL_ACCOUNT_NO'] == internal_account_api_call]
    concat_df = pd.concat([filtered_df, response_merged_df], axis=1)
    db = mysql_connection()
    for index, row in concat_df.iterrows():
        asset_id = None
        current_time = datetime.now()
        current_time = current_time.strftime("%Y-%m-%d %H:%M:%S")

        try:
            sql_query_insert_cmp = None
            value = None
            sql_query_insert_cmp = "INSERT INTO sim_pool_plan_status (create_date, account_id, gc_accountid,rate_plan, \
                                                total_allocated_pool, total_usage, remaining_pool) \
                                                 VALUES (%s, %s, %s, %s, \
                                                           %s, %s, %s)"

            value = (current_time,
                     str(row['account_id']),
                     str(row['GC_ACCOUNT_ID']),
                     str(row['PLAN_NAME']),
                     str(row['allocated']),
                     str(row['consumed']),
                     str(row['remaining_pool']))

            sql_query_insert(db, sql_query_insert_cmp, value, logger_error)
            print("Data Inserted Into Db Account Id {}".format(row['account_id']))
            logger_info.info(
                "account_id {} gc_account_id {} plan_name {} allocated {} inserted in sim_pool_plan_status table".format(
                    row['account_id'], row['GC_ACCOUNT_ID'],
                    row['PLAN_NAME'], row['allocated']))
        except Exception as e:
            logger_error.error("Error {}".format(e))
            # drop_row_index.append(index)
    db.commit()
    db.close()
    # filtered_df.drop(columns=['EXT_ACCOUNT_NO', 'BILL_DATE', 'PLAN_ID'], inplace=True)
    return concat_df


def sql_query_fetch(querry, logger_error):
    '''

    :param querry: select query to fetch the pool usage details
    :param logger_error: error logs
    :return: Fetching the data by using query ,execute and return data.
    '''
    try:
        db = mysql_connection()
        cursor = db.cursor()
        cursor.execute(querry)
        data = cursor.fetchall()
        #print(data)
        cursor.close()
        db.close()
        return data

    except Exception as e:
        logger_error.error("Error : {} ".format(e))
        return None
    finally:
        if db.is_connected():
            db.close()
            cursor.close()
            print("MySQL connection is closed")


def get_maxid_from_tables():
    max_id_extended = f'select max(id) from {table_name_2};'
    extended_id_from_assets = f'select max(ASSETS_EXTENDED_ID) from {table_name_1};'
    max_id_from_assets = f'select max(id) from {table_name_1};'






def read_data_from_file(file_path):
    df = pd.read_csv(file_path)
