

import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from validator import *
from src.utils.library import *
from conf.custom.apollo.config import *
import datetime
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))



logs = {
    "migration_info_logger":f"stc_validation_info_{current_time_stamp}.log",
    "migration_error_logger":f"stc_validation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{validation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()


def empty_csv_file(file_name):
    try:
        current_directory = os.getcwd()
        file_path = os.path.join(current_directory, file_name)
        with open(file_path, 'w') as f:
            f.write('')
        print("data_from_file delete")
        return True
    except Exception as e:
        print(f"An error occurred while emptying the file: {str(e)}")
        logger_error.error(f"An error occurred while emptying the file: {str(e)}")
        return False


def move_to_history(current_date,directory_path):
    """
    Method to move processed file to history
    :param current_date: Migration date time eg  202402260000
    :param source_file: Path of file to be moved
    :return: None
    """

    # Define the source file and history directory
    history_directory = f'{history_files_path}/{current_date}'

    # Create the history directory if it doesn't exist
    if not os.path.exists(history_directory):
        os.makedirs(history_directory)

    # Move the file to the history directory
    

    file_list = os.listdir(directory_path)

    # Iterate through the files
    for file_name in file_list:
        if file_name.endswith(".csv"):
            try:
                destination_file = os.path.join(history_directory, os.path.basename(file_name))
                os.rename(directory_path, destination_file)
                print(f"File moved to history {destination_file}")
                logger_info.info(f"File moved to history {destination_file}")
            except Exception as e:
                print("Error : {} deleting previous csv file", e)
                exit(0)



def validate_feed_files():
    """
    1) This Method is Used to Validate the feed files coming from client, If any mandatory parameter is missing then it will be
    error out.
    2) If any column data type is mismatch then that should be error out.
    3) Duplicate records are removed based on a unique column.
    4) Multiple file validation is also happening.
    """
    try:
        logger_info.info("#################### Feed File Validation Started ##############################")

        public_subnet_df = pd.read_csv(public_subnet_file_path, keep_default_na=False,dtype=str)

        private_subnet_df = pd.read_csv(private_subnet_file_path, keep_default_na=False, dtype=str)

        apn_cdp_df = pd.read_csv(f'{feed_file_path}/new_apns_cdp.csv',keep_default_na=False,dtype=str)

        public_subnet_df = public_subnet_df.drop_duplicates(subset='STARTING_IP', keep='first')
        private_subnet_df = private_subnet_df.drop_duplicates(subset='STARTING_IP', keep='first')

        public_subnet_dict = public_subnet_df.set_index('STARTING_IP').to_dict('index')

        # Convert private_subnet_df to a dictionary with STARTING_IP as the key
        private_subnet_dict = private_subnet_df.set_index('STARTING_IP').to_dict('index')

        # Combine both dictionaries
        combined_subnet_dict = {**public_subnet_dict, **private_subnet_dict}

        for ip in combined_subnet_dict:
            if 'SUBNET' in combined_subnet_dict[ip]:
                combined_subnet_dict[ip]['SUBNET'] = combined_subnet_dict[ip]['SUBNET'].replace('\n', ' ')

        # Function to fill SUBNET and NO_OF_HOSTS in df_final
        def fill_subnet_info(row):
            ip = row['STARTING_IP']
            if ip in combined_subnet_dict:
                row['SUBNET'] = combined_subnet_dict[ip]['SUBNET']
                row['NO_OF_HOSTS'] = combined_subnet_dict[ip]['NO_OF_HOSTS']
                if ip in public_subnet_dict:
                    row['CUSTOMER_ID'] = public_subnet_dict[ip]['CUSTOMER_ID']
                    row['BU_LIST'] = public_subnet_dict[ip]['BU']
            return row

        # Apply the function to df_final
        df_final = apn_cdp_df.apply(fill_subnet_info, axis=1)

        print(df_final)
        df_final.to_csv(f'{feed_file_path}/apns_cdp.csv',index=False)
        empty_csv_file(Reconsilation_file_name)

        feed_file_name_list = ['Billing_Account_cdp','assets_cdp','address_details_cdp','acct_att_cdp','users_details_cdp','apns_cdp',
                               'APN_IP_Addressess_cdp','APN-ip-pools-state-t_cdp','APN_SP_cdp','SIM_Order_cdp','sim_products_cdp',
                               'IMSI_Range_cdp','Service_Profile_Config_cdp','customer_details_cdp','cost_center_cdp','TriggersDetails','Discount',
                                'white_listing_cdp','sim_orders_ap_fp_status','sim_transactions'
                               ] #'Entitlement_data_load','zonegroup_load_data','zone_product_pricing_load_data','temp_discount_data',

        # feed_file_name_list = ['Billing_Account_cdp','apns_cdp','acct_att_cdp']

        for file_name in feed_file_name_list:
            if os.path.exists(f'{feed_file_path}/{file_name}.csv') or os.path.exists(f'{feed_file_path}/{file_name}.xlsx'):
                if file_name=='Billing_Account_cdp':
                    bu_id_list,customer_id_list,opco_id_list=partial_validation(feed_file_path,error_record_file_path, f'{file_name}_duplicates', logger_info, logger_error,
                               file_name)
                    print(bu_id_list)
                    print(customer_id_list)           

                else:
                    validate_feed_file(feed_file_path,error_record_file_path, f'{file_name}_duplicates', logger_info, logger_error,
                                file_name,bu_id_list,customer_id_list,opco_id_list)
            else:
                print("File {}.csv Not Exist at path {}".format(file_name,feed_file_path))
                logger_info.info("File {}.csv Not Exist at path {}".format(file_name,feed_file_path))

        

        logger_info.info("#################### Feed File Validation Completed ##############################")
    except Exception as e:
        logger_error.error("Error {} during file validation".format(e))


validate_feed_files()

