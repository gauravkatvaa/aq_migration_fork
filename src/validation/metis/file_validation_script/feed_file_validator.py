

import sys
# # Add the parent directory to sys.path
sys.path.append("..")
from MAXIScsv_to_AQcsv import *

from conf.custom.metis.config import *
import datetime
today = datetime.datetime.now()
current_time_stamp = today.strftime("%Y%m%d%H%M")
dir_path = dirname(abspath(__file__))



logs = {
    "migration_info_logger":f"maxis_validation_info_{current_time_stamp}.log",
    "migration_error_logger":f"maxis_validation_error_{current_time_stamp}.log"
}

logs_path = f'{logs_path}/{validation_log_dir}'

# Create the history directory if it doesn't exist
if not os.path.exists(logs_path):
    os.makedirs(logs_path)

logger_info = logger_(logs_path, logs["migration_info_logger"])
logger_error = logger_(logs_path, logs["migration_error_logger"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()




mistmatched_rows_path = os.path.join(dir_path, 'Mismatched_Rows')
validation_error_path = os.path.join(dir_path, validation_error_dir)

output_file_name_pic = '6_users.csv'
output_file_contact_list = 'contact_list_users.csv'
output_file_name_company = 'eCMP_M2M_Company.csv' 
output_file_name_service = 'eCMP_M2M_Service_Status.csv'
output_file_name_missing_brn_bill_Company='missing_brn_bill_Company.csv.csv'



def append_to_data_value_file(filename, length_of_original_file, valid_records, data_value_file):
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(data_value_file, 'a') as f:
            f.write(f"current time{current_time}:{filename},length_of_original_file:{length_of_original_file},Success:{valid_records}\n")
    except Exception as e:
        print(f"An error occurred while appending to the data value file: {e}")
        logger_error.error(f"An error occurred while appending to the data value file: {e}")


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

    

def fill_missing_values(df, column_to_fill,column_to_fill1):

    try:
        counter = 1
        counter1=1

        for index, value in df[column_to_fill].iteritems():
            # print("two")
            if value=='':
                df.at[index, column_to_fill] = f"{column_to_fill}_{counter}"
                counter += 1
        for index, value in df[column_to_fill1].iteritems():
            # print("two")
            if value == '':
                df.at[index, column_to_fill1] = f"{column_to_fill1}_{counter1}"

                counter1 += 1
        return df

    except Exception as e:
        print(f"An error occurred: {e}")
        logger_error.error(f"An error occurred: {e}")
        return None



def validate_feed_files():
    """
    1) This Method is Used to Validate the feed files coming from client, If any mandatory parameter is missing then it will be
    error out.
    2) If any column data type is mismatch then that should be error out.
    3) Duplicate records are removed based on a unique column.
    4) Multiple file validation is also happening.
    """
    try:

        try:
            ecmp_m2m_company_file_path = glob(os.path.join(input_files_path, f"{m2m_company_file_prefix}*"))[0]
            six_users_file_path = glob(os.path.join(input_files_path, f"{pic_file_prefix}*"))[0]
            contact_list_file_path = glob(os.path.join(input_files_path, f"{contact_list_file_prefix}*"))[0]
            ecmp_m2m_service_file_path = glob(os.path.join(input_files_path, f"{m2m_service_file_prefix}*"))[0]
        except Exception as e:
            print("File Not Found : ",e)
            logger_error.error("File Not Found {}".format(e))

        empty_csv_file(feed_file_validation_data_formate)


        logger_info.info("#################### Company File Validation ##############################")
        ####################################### Company File Validation #################################################################################

        data = pd.read_csv(ecmp_m2m_company_file_path, skipinitialspace=True, keep_default_na=False, dtype=str)
        print('Length of Company Original file : ', len(data))
        total=len(data)
        duplicate_error_company_filename = m2m_company_duplicate_file_name + "_" + current_time_stamp + ".csv"
        company_duplication_error_path = os.path.join(dir_path, validation_error_dir, duplicate_error_company_filename)
        data,missing_brn = M2M_Customer_to_AQ(data, validation_error_path, company_duplication_error_path, logger_info,
                                  logger_error, output_file_name_company)

        print('Length of Company Valid File Data : ', len(data))

        missing_brn = fill_missing_values(missing_brn, 'BRN_NO', 'BILL_COMPANY')
        print('Length of Company Valid File Data : ', len(missing_brn))
        merged_df = pd.concat([data, missing_brn], ignore_index=True)

        # Drop duplicate rows based on the header
        merged_df = merged_df.drop_duplicates()

        # Reset the index if needed
        merged_df = merged_df.reset_index(drop=True)
        sucess = len(merged_df)
        merged_df.to_csv(os.path.join(output_files_path, output_file_name_company), index=False)
        append_to_data_value_file(m2m_company_file_prefix,total ,sucess, feed_file_validation_data_formate)
        logger_info.info('Length of Company Valid Data : {}'.format(len(data)))
        print(
            "######################################### missing_BRN_BIll_company Validation #################################")
        logger_info.info("#################### missing_BRN_BIll_company Validation ##############################")

        sucess = len(missing_brn)
        missing_brn.to_csv(os.path.join(output_files_path, output_file_name_missing_brn_bill_Company), index=False)
        append_to_data_value_file("missing_brn_bill_Company.csv", sucess, sucess, feed_file_validation_data_formate)
        logger_info.info('Length of missing_BRN_BIll_company Validation Valid Data : {}'.format(len(missing_brn)))

        logger_info.info("#################### 6 Users File Validation ##############################")
        ####################################### 6 Users File Validation #################################################################################

        pic_user = pd.read_csv(six_users_file_path,keep_default_na=False,skipinitialspace=True,dtype=str)
        print('Length of Pic Original file : ', len(pic_user))
        total=len(pic_user)
        logger_info.info('Length of Pic  Original file : {}'.format(len(pic_user)))
        pic_user = PIC_USER_TO_AQ(pic_user, validation_error_path,manadatory_column_pic, logger_info, logger_error,output_file_name_pic)
        filtered_brn_company = data['BRN_NO'].unique().tolist()
        error_message = "On This BRN Account Is Not Present in company"
        pic_user = filter_and_drop_mismatched_brn(pic_user, filtered_brn_company, validation_error_path, error_message,
                                                  logger_info, logger_error, output_file_name_pic)
        sucess=len(pic_user)
        pic_user.to_csv(os.path.join(output_files_path, output_file_name_pic), index=False)
        append_to_data_value_file(pic_file_prefix, total, sucess, feed_file_validation_data_formate)
        print('Length of Pic Valid Records File : ', len(pic_user))
        logger_info.info('Length of Pic Valid Records File : {}'.format(len(pic_user)))

        logger_info.info("#################### Contact List File Validation ##############################")
        ####################################### Contact ListFile Validation #################################################################################

        contact_list = pd.read_csv(contact_list_file_path,keep_default_na=False,skipinitialspace=True,dtype=str)
        arranged_contact_list = contact_list.reindex(columns=pic_user.columns)
        arranged_contact_list['org_id'] = '2345'
        arranged_contact_list['login_name'] = contact_list['email']
        arranged_contact_list['last_login'] = ''
        arranged_contact_list['role_name'] = 'CADM'
        arranged_contact_list['disabled'] = 'Y'
        total=len(contact_list)

        arranged_contact_list = PIC_USER_TO_AQ(arranged_contact_list, validation_error_path,manadatory_column_pic, logger_info, logger_error,output_file_contact_list)
        # arranged_contact_list = arranged_contact_list['brn'].unique().tolist()
        sucess=len(arranged_contact_list)
        print('Length of Valid Contact file Records : ', len(arranged_contact_list))
        append_to_data_value_file(contact_list_file_prefix, total, sucess, feed_file_validation_data_formate)
        logger_info.info('Length of Valid Contact file Records : {}'.format(len(arranged_contact_list)))
        ################ PIC BRN VALIDATION ##################################################

        # print("filtered brn unique ",len(filtered_brn_company))
        filtered_brn_pic = pic_user['brn'].unique().tolist()
        m2m_brn_not_in_pic = data[~data['BRN_NO'].isin(filtered_brn_pic)].index
        m2m_unique_brn = data.loc[m2m_brn_not_in_pic, 'BRN_NO'].unique()
        print('BRN NOT IN PIC : ',len(m2m_unique_brn))

        # Filter records from the other file that match mismatched BRN values
        matched_records = arranged_contact_list[arranged_contact_list['brn'].isin(m2m_unique_brn)]
        matched_records.to_csv(os.path.join(output_files_path,output_file_contact_list),index=False)
        print('Length of Matched BRN IN Contact file : ', len(matched_records))
        logger_info.info('Length of Matched BRN IN Contact file : {}'.format(len(matched_records)))

        logger_info.info("#################### Service File Validation ##############################")
        ####################################### Service File Validation #################################################################################

        df_service = pd.read_csv(ecmp_m2m_service_file_path, dtype=str, keep_default_na=False, skipinitialspace=True)
        print('Length of Service Original file : ', len(df_service))
        total=len(df_service)
        logger_info.info("Length of Service Original file : {}".format(len(df_service)))
        duplicate_error_filename = m2m_service_duplicate_file_name + "_" + current_time_stamp + ".csv"
        duplication_error_path = os.path.join(dir_path, validation_error_dir, duplicate_error_filename)
        df_service = M2M_Service_to_AQ(df_service, validation_error_path, duplication_error_path, logger_info, logger_error,output_file_name_service )
        df_service.to_csv(os.path.join(output_files_path,output_file_name_service), index=False)
        print('Length of Service success records : ', len(df_service))
        sucess=len(df_service)
        append_to_data_value_file(m2m_service_file_prefix, total, sucess, feed_file_validation_data_formate)

        logger_info.info("Length Service of success records : {}".format(len(df_service)))


        # move_to_history(current_time_stamp,input_files_path)
    except Exception as e:
        logger_error.error("Error {} during file validation".format(e))


validate_feed_files()

