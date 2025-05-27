"""
This Script call the procedure gcontrol_account_organization_mapping which will copy the new entry of account in
accounts table to organization table.
"""

# from mysql.connector import MySQLConnection, Error
import mysql.connector 
from config import maxis_dev_config
from logger import logger_
from os.path import dirname, abspath
from const_config import *
dir_path = dirname(abspath(__file__))
logger_info = logger_(dir_path, logs["m2m_company_logs"])
logger_error = logger_(dir_path, logs["m2m_company_error"])
logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

hostname = maxis_dev_config["host"]
username = maxis_dev_config["user"]
password = maxis_dev_config["password"]
database = maxis_dev_config["database"]
procedure_name = maxis_dev_config["procedure_name"]

print('Hostname : ',hostname)

def mysql_connection():
    '''
    return: This will create mysql connection
    '''
    try:
        mysql_conn = mysql.connector.connect(host=hostname, user=username,
                                             password=password, database=database)

        return mysql_conn

    except Exception as e:
        print("mysql connection error {}".format(e))
        return None




if __name__ == '__main__':
    call_find_all_sp()
