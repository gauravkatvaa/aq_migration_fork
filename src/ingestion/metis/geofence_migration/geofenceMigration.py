import os
import pandas as pd
import shutil
from os.path import dirname, abspath, join
import mysql.connector
from os import listdir
from config import remoteFilePath, meta_db_configs, logs
from datetime import datetime
import random
import string
from payloads import *
from api_initiator import  *
from logger import logger_

from config import remoteFilePathNotificationsHistory, remoteFilePathNotifications
from config import validate_api_user

dir_path = dirname(abspath(__file__))



jdbcMetaDatabase = meta_db_configs["DATABASE"]
host = meta_db_configs["HOST"]
username = meta_db_configs["USER"]
password = meta_db_configs["PASSWORD"]
jdbcPort = meta_db_configs["PORT"]
print(meta_db_configs)

dir_path = dirname(abspath(__file__))

logger_info = logger_(dir_path, logs["logs"])
logger_error = logger_(dir_path, logs["error"])

logger_info = logger_info.get_logger()
logger_error = logger_error.get_logger()

def mysql_connection():
    """
    below function will create my sql session and return connection
    :return:
    """
    try:
        mysql_conn = mysql.connector.connect(host=host, user=username,
                                             database=jdbcMetaDatabase, password=password, port=jdbcPort)

    except Exception as e:
        print("mysql connection account_id_error".format(e))
        exit(0)

    return mysql_conn


def sql_query_fetch(querry, logger_error):
    """
    below function will fetch the detail from database via querry as input argument.
    :param querry: my SQL querry
    :param logger_error:
    :return:
    """
    try:
        print("DB query : ", querry)
        db = mysql_connection()
        cursor = db.cursor()
        cursor.execute(querry)
        data = cursor.fetchall()
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

account_id_querry = "select ENT_ACCOUNTID, ID  from assets where imsi = '%s';"

billing_account_number_querry = "select BILLING_ACCOUNT_NUMBER from account_extended as at inner join accounts ac on ac.EXTENDED_ID = at.id where ac.id = '%s';"

user_id_querry = "select ID from users where USER_NAME = '%s';"







# BAN_AcID_AsID_querry = "select `ac`.`BILLING_ACCOUNT_NUMBER`,`at`.`ENT_ACCOUNTID`, `at`.`id` from account_extended as `ac` \
# inner join accounts as `a` on `a`.`extended_id` = `ac`.`id` \
# inner join assets as `at` on `at`.`ent_accountid` = `a`.`id` \
# where `at`.imsi = '%s';"

def random_number(length_of_digits):
    '''
    param: length_of_digits
    return: return the random digits
    '''
    N = int(length_of_digits)

    randm = ''.join(random.choices(string.digits, k=N))
    randm = str(randm)
    print(randm)
    return str(randm)

def currentDateTime_request_name(accountID, midfix):
    """
    :return: request ID (PY + current date time + random number of 5 digits)
    """
    print("----")
    current_date = datetime.now()
    print(current_date)
    current_date = current_date.strftime("%Y%m%d%H%M%S")
    print(current_date)
    randm = random_number(5)
    name = str(accountID) + "_" +  midfix + "_" + current_date + '_' + randm
    return name



geoFenceProcess = api_call()
try:
    geoFenceProcess = api_call()
    token = geoFenceProcess.auth_user()
    print("gc token \n", token )
    if len(token) == 0:
        #logger_error.error("Authorization error")
        print("Authorization Error")
        exit(0)
    elif len(token) > 0:
        print("token recieved")

except Exception as e:
    print("authorization error")
    #logger_error.error("authorization error")
    exit(0)

try:

    user_id_querry_1 = user_id_querry % (str(validate_api_user["username"]))
    print(user_id_querry)

    usernameID = sql_query_fetch(user_id_querry_1, logger_error)
    usernameID = usernameID[0][0]
    print("user ID : ",  usernameID)
    logger_info.info("user id : {}".format(usernameID))

except Exception as e:
    print("error fetching user id : ",e)
    exit(0)



def brn_email_dict_fun(fileName, df_ban):
    """
    fileName : name of input migration file
    db_ban : input data frame
    return : data frame and dict account id (key) email (value)
    """
    dict_brn_email = {}
    account_email = {}
    for file in listdir(remoteFilePathNotifications['remote_file_path_notifications']):
        if file.endswith(".csv"):
            print(file)
            shutil.copy(os.path.join(remoteFilePathNotifications['remote_file_path_notifications'], file), os.path.join(dir_path, file))
            shutil.move(os.path.join(remoteFilePathNotifications['remote_file_path_notifications'], file), os.path.join(remoteFilePathNotificationsHistory['remote_file_path_notificationsHistory'], file))

            csv_file_path_1 = os.path.join(dir_path, file)

            df_n = pd.DataFrame()
            df_n = pd.read_csv(csv_file_path_1, skipinitialspace=True, keep_default_na=False, dtype=str)
            os.remove(csv_file_path_1)
            df_n = df_n[["brn" , "email", "alert_geo_fence"]]
            for column in df_n.columns:
                df_n[column] = df_n[column].apply(lambda x: str(x).strip())

            print(df_n.columns)

            drop_row = []
            for index, row in df_n.iterrows():
                if len(row["brn"]) == 0 or len(row["email"]) == 0 or row["alert_geo_fence"].upper() != "Y" :
                    drop_row.append(index)

            if len(drop_row) > 0:
                df_n_partial_error = df_n.iloc[drop_row, :]
                df_n_partial_error.to_csv(os.path.join(dir_path, "NAEmailsBRN", (file[:-4] + "NAEmailsBRN.csv")))

            df_n = df_n.drop(drop_row)

            ###
            df_n = df_n.reset_index(drop=True)

            df_n = df_n.groupby(["brn"])[['email']].agg(list).reset_index()

            #df_n = df_n.to_dict()

            print(df_n)

            for index, row in df_n.iterrows():
                dict_brn_email[row["brn"]] = row["email"]

            drop_row_index = []

            print("df_ban",df_ban)
            for index, row in df_ban.iterrows():
               if dict_brn_email.get(row["ban"]) is not None:
                   if account_email.get(row["Account_ID"]) is None:
                       account_email[row["Account_ID"]] = dict_brn_email[row["ban"]]

               else:
                   drop_row_index.append(index)

            print(dict_brn_email)

            if len(drop_row_index) > 0:
                df_ban_partial_error = df_ban.iloc[drop_row_index, :]
                df_ban_partial_error = df_ban_partial_error.reset_index(drop=True)
                df_ban_partial_error.to_csv(os.path.join(dir_path, "ban_email_error", (fileName[:-4] + "ban_email_error.csv")))

            df_ban = df_ban.drop(drop_row_index)

            ###
            df_ban = df_ban.reset_index(drop=True)

    return  account_email, df_ban




for file in listdir(remoteFilePath['remote_file_path']):
    if file.endswith(".csv"):
        print(file)
        shutil.copy(os.path.join(remoteFilePath['remote_file_path'], file),os.path.join(dir_path, file) )
        shutil.move(os.path.join(remoteFilePath['remote_file_path'], file), os.path.join(remoteFilePathHistory['remote_file_path'], file))

        csv_file_path = os.path.join(dir_path, file)
        df = pd.DataFrame()
        df = pd.read_csv(csv_file_path, skipinitialspace=True, keep_default_na=False, dtype=str)
        os.remove(csv_file_path)
        for column in df.columns:
            df[column] = df[column].apply(lambda x: str(x).strip())

        print(df)
        print(df.columns)

        empty_stringImsi_df = df[df["imsi"].isin([""])]
        print("empty_stringImsi_df", empty_stringImsi_df)

        if not empty_stringImsi_df.empty:
            empty_stringImsi_df.to_csv(os.path.join(dir_path, "missing_imsi", (file[:-4] + "missing_imsis.csv")))

        df = df[~df["imsi"].isin([""])]


        print(df)

        duplicates_imsi_df = df[df.duplicated(subset=['imsi', 'lat' , 'lng' , 'radius' ])]
        duplicates_imsi_df = duplicates_imsi_df.reset_index(drop=True)
        print("duplicates_imsi_df", duplicates_imsi_df)

        if not duplicates_imsi_df.empty:
            duplicates_imsi_df.to_csv(os.path.join(dir_path, "duplicate_imsi", (file[:-4] + "duplicate_imsis.csv")))


        print(df)

        df = df.drop_duplicates(subset=['imsi', 'lat' , 'lng' , 'radius'])
        df = df.reset_index(drop=True)

        print(df)


        df["Account_ID"] = ""
        df["entityIds"] = ""
        df["zoneName"] = ""
        df["ban"] = ""

        drop_row_index = []
        for index, row in df.iterrows():
            print(row["imsi"])

            account_id = ""
            assets_id = ""
            ban = ""
            try:
                querry_fetching_error = False
                accountsIDs = None
                account_id_querry_1= None
                account_id_querry_1 = account_id_querry % (str(row["imsi"]))
                accountsIDs = sql_query_fetch(account_id_querry_1,logger_error)
                print(accountsIDs)

                account_id = accountsIDs[0][0]
                assets_id = accountsIDs[0][1]
                billing_account_number_querry_1 = None

                billing_account_number_querry_1 = billing_account_number_querry % (str(account_id))
                ban = sql_query_fetch(billing_account_number_querry_1, logger_error)
                ban = ban[0][0]

                print("Billing Account Anumber : ", ban)
                row["Account_ID"] = account_id
                print("accounts" , account_id)
                row["entityIds"] = assets_id
                print("entityIds : ", assets_id)
                if ban == None :
                    querry_fetching_error = True
                elif ban != None:
                    row["ban"] = ban
                print("ban : ", ban)


            except Exception as e:
                querry_fetching_error = True
                logger_error.error(e)
                print(e)

            if querry_fetching_error:
                drop_row_index.append(index)



        if len(drop_row_index) > 0:
            df_partial_error = df.iloc[drop_row_index, :]
            df_partial_error = df_partial_error.reset_index(drop=True)
            df_partial_error.to_csv(os.path.join(dir_path, "missing_account_details", (file[:-4] + "missing_account_details.csv")))
            print("df_partial_error", df_partial_error)

        df = df.drop(drop_row_index)
        df = df.reset_index(drop=True)


        print("actual df", df)


        dict_imsi = {}

        account_email, df =  brn_email_dict_fun(file, df)
        print(account_email)
        print(df)
        for index, row in df.iterrows():
            dict_imsi[row["imsi"]] = row["entityIds"]

        grouped_df = df.groupby(["Account_ID", 'lat', 'lng', 'radius'])[['imsi']].agg(list).reset_index()
        grouped_df.to_csv(os.path.join(dir_path, "groupedAccountIDZone", (file[:-4] + "groupedAccountIDZone.csv")))
        print(grouped_df.columns)


        grouped_df["Rulename"] = ""
        grouped_df["Zone_ID"] = ""
        grouped_df["Tag_ID"] = ""
        grouped_df["TagName"] = ""
        grouped_df["TagDescription"] = ""

        createTag_success_list = []
        createTag_failure_list = []

        createTagAssign_success_list = []
        createTagAssign_failure_list = []
        createZone_success_list = []
        createZone_failure_list = []
        createRule_success_list = []
        createRule_failure_list = []

        df = pd.DataFrame()

        for index, row in  grouped_df.iterrows():

            try:
                createTagstatus = None
                createTagcontent = None
                createTagAPI_status_success = False
                row["TagName"] = currentDateTime_request_name(row["Account_ID"], "tag")
                row["TagDescription"] = currentDateTime_request_name(row["Account_ID"], "tagDesc")
                payloaddata = row
                payloaddataEncoded= None
                payloaddataEncoded = createTagPayload(row)

                print(payloaddata)
                logger_info.info(payloaddata)

                createTag_status, createTag_content = geoFenceProcess.createTag(payloaddataEncoded, token)
                print(createTag_status)
                print(createTag_content)
                createTag_content_dict = None
                createTag_content_dict = json.loads(createTag_content.decode('utf-8'))


                if createTag_status == 201   \
                    and isinstance(createTag_content_dict["id"], int) and createTag_content_dict["errorCode"] == 0  \
                    and str(createTag_content_dict["errorMessage"]) == "None" \
                    and createTag_content_dict["account"]["errorCode"] == 0  \
                    and str(createTag_content_dict["account"]["errorMessage"]) == "None" :

                    #print(createTag_content_dict)
                    logger_info.info(createTag_content_dict)
                    createTag_json_obj_dict = {}
                    createTag_json_obj_dict = payloaddata.to_dict()
                    createTag_json_obj_dict.update(createTag_content_dict)
                    createTag_success_list.append(createTag_json_obj_dict)
                    row["Tag_ID"] = createTag_content_dict["id"]

                    createTagAPI_status_success = True

                else:
                    logger_error.error(createTag_content_dict)
                    createTag_json_obj_dict = {}
                    createTag_error_dict = {"message": createTag_content_dict}
                    createTag_json_obj_dict = payloaddata.to_dict()

                    createTag_json_obj_dict.update(createTag_error_dict)
                    createTag_failure_list.append(createTag_json_obj_dict)

            except Exception as e:

                createTag_json_obj_dict = {}
                createTag_error_dict = {"message": "error in calling API %s" % e}
                logger_error.error(createTag_error_dict)
                createTag_json_obj_dict = payloaddata.to_dict()
                createTag_json_obj_dict.update(createTag_error_dict)
                createTag_failure_list.append(createTag_json_obj_dict)
                #print(e)

            createTagAPIAssign_status_success = False
            if createTagAPI_status_success == True:
                try :

                   ori_payloadsTagAssign = row
                   no_of_imsi = len(row["imsi"])
                   list_of_entity_id = []
                   for i in range(no_of_imsi):
                       list_of_entity_id.append(dict_imsi[row["imsi"][i]])

                   payloaddataTaassign = None
                   #payloaddataTaassign = bulk_assign_unassignPayload(ori_payloadsTagAssign, list_of_entity_id)
                   createTagAssign_status, createTagAssign_content = geoFenceProcess.assignTag(payloaddataTaassign, token)
                   print("createTagAssign_content : ", createTagAssign_content)
                   if createTagAssign_status == 200 and createTagAssign_content == b'Tags assigned successfully' :
                        print("tag Assign OK-------------------")
                        createTagAssign_json_obj_dict = {}
                        createTagAssign_json_obj_dict = ori_payloadsTagAssign.to_dict()

                        createTagAssign_success_list.append(createTagAssign_json_obj_dict)
                        createTagAPIAssign_status_success = True

                   else :
                       createTagAssignError_json_obj_dict = {}
                       createTagAssignError_json_obj_dict = ori_payloadsTagAssign.to_dict()
                       createTagAssignError_dict = {"message":  createTagAssign_content}
                       createTagAssignError_json_obj_dict.update(createTagAssignError_dict)
                       createTagAssign_failure_list.append(createTagAssignError_json_obj_dict)

                except Exception as e:
                    createTagAssignError_json_obj_dict = {}
                    createTagAssignError_json_obj_dict = ori_payloadsTagAssign.to_dict()
                    createTagAssign_failure_list.append(createTagAssignError_json_obj_dict)
                    print(e)

            createZoneAPI_status_success = False
            if  createTagAPIAssign_status_success == True:
                try:
                    row["zoneName"] =  currentDateTime_request_name(row["Account_ID"], "Zone")
                    payloaddataZone = row
                    payloaddataEncodedZone = None
                    payloaddataEncodedZone = create_lbs_zonePayload(row)

                    print("--------------", payloaddataEncodedZone )
                    print(payloaddata)
                    logger_info.info(payloaddata)
                    createZone_status, createZone_content = geoFenceProcess.createlbsZoneAPI(payloaddataEncodedZone, token)
                    print(createZone_status)
                    print(createZone_content)
                    createZone_content_dict = None
                    createZone_content_dict = json.loads(createZone_content.decode('utf-8'))

                    createZone_status_success = False
                    if createZone_status == 200 \
                            and isinstance(createZone_content_dict["id"], int)  \
                            and createZone_content_dict["account"]["errorCode"] == 0 \
                            and str(createZone_content_dict["account"]["errorMessage"]) == "None" :


                        logger_info.info(createZone_content_dict)
                        createZone_json_obj_dict = {}
                        createZone_json_obj_dict = payloaddata.to_dict()
                        createZone_json_obj_dict.update(createZone_content_dict)
                        createZone_success_list.append(createZone_json_obj_dict)


                        row["Zone_ID"] = createZone_content_dict["id"]
                        createZoneAPI_status_success = True

                    else:
                        logger_error.error(createZone_content_dict)
                        createZone_json_obj_dict = {}
                        createZone_error_dict = {"message": createZone_content_dict}
                        createZone_json_obj_dict = payloaddata.to_dict()

                        createZone_json_obj_dict.update(createZone_error_dict)
                        createZone_failure_list.append(createZone_json_obj_dict)

                except Exception as e:
                    createZone_json_obj_dict = {}
                    createZone_content_dict = {"message": "error in calling API %s" % e}
                    logger_error.error(createZone_content_dict)
                    createZone_json_obj_dict = payloaddata.to_dict()
                    createZone_json_obj_dict.update(createZone_content_dict)
                    createZone_failure_list.append(createZone_json_obj_dict)
                    # print(e)
                if createZoneAPI_status_success == True:
                    try:
                        row["Rulename"] = currentDateTime_request_name(row["Account_ID"], "Rule")
                        email_list = []
                        result_email = ""
                        email_list = account_email[row["Account_ID"]]
                        result_email = ", ".join(email_list)
                        rulePayloadEncoded = None
                        rulePayloadEncoded = rule_engine_payload(row, result_email, usernameID)
                        ruleStatus , ruleContent = geoFenceProcess.createRule(rulePayloadEncoded, token)

                        print(ruleStatus)
                        print(ruleContent)
                        ruleContentDict = json.loads(ruleContent.decode('utf-8'))
                        if  ruleStatus == 200 and ruleContentDict[0]["message"] == "Rule Created Successfully" and \
                                ruleContentDict[0]["Rule_name"] == row["Rulename"] :

                            print("contemt dict ----- Rule engine-----",  ruleContentDict )

                            logger_info.info(createZone_content_dict)
                            createRule_json_obj_dict = {}
                            createRule_json_obj_dict = payloaddata.to_dict()
                            createRule_json_obj_dict.update(ruleContentDict[0])
                            createRule_success_list.append(createRule_json_obj_dict)


                        else:
                            logger_error.error(ruleContentDict)
                            createRule_json_obj_dict = {}
                            createRule_error_dict = {"message": ruleContentDict[0]}
                            createRule_json_obj_dict = payloaddata.to_dict()

                            createRule_json_obj_dict.update( createRule_error_dict)
                            createRule_failure_list.append(createRule_json_obj_dict)

                    except Exception as e:
                        logger_error.error("error in calling API {}".format(e))
                        createRule_json_obj_dict = {}
                        createRule_error_dict = {"message": "error in calling API %s" % e}
                        createRule_json_obj_dict = payloaddata.to_dict()

                        createRule_json_obj_dict.update( createRule_error_dict)
                        createRule_failure_list.append(createRule_json_obj_dict)



        dfcreateTag_success = pd.DataFrame(createTag_success_list)
        dfcreateTag_failure =  pd.DataFrame(createTag_failure_list)

        if not dfcreateTag_success.empty:
            dfcreateTag_success.to_csv(os.path.join(dir_path, "createTag_success", (file[:-4] + "createTag_success.csv")))
            dfcreateTag_success = pd.DataFrame()
        if not  dfcreateTag_failure.empty:
            dfcreateTag_failure.to_csv(os.path.join(dir_path, "createTag_failure", (file[:-4] + "createTag_failure.csv")))
            dfcreateTag_failure.to_csv(os.path.join(error_directory, (file[:-4] + "createTag_failure.csv")),index=False)
            dfcreateTag_failure =  pd.DataFrame()

        dfcreateTagAssign_success = pd.DataFrame(createTagAssign_success_list)
        dfcreateTagAssign_failure = pd.DataFrame(createTagAssign_failure_list)

        if not dfcreateTagAssign_success.empty:
            dfcreateTagAssign_success.to_csv(os.path.join(dir_path, "createTagAssign_success", (file[:-4] + "createTagAssign_success.csv")))
            dfcreateTagAssign_success =pd.DataFrame()

        if not dfcreateTagAssign_failure.empty:
            dfcreateTagAssign_failure.to_csv(os.path.join(dir_path, "createTagAssign_failure", (file[:-4] + "createTagAssign_failure.csv")))
            dfcreateTagAssign_failure.to_csv(os.path.join(error_directory,  (file[:-4] +"createTagAssign_failure.csv")),index=False)

            dfcreateTagAssign_failure = pd.DataFrame()

        dfcreateZone_success = pd.DataFrame(createZone_success_list)
        dfcreateZone_failure = pd.DataFrame(createZone_failure_list)

        if not  dfcreateZone_success.empty:
            dfcreateZone_success.to_csv( os.path.join(dir_path, "createZone_success", (file[:-4] + "createZone_success.csv")))
            dfcreateZone_success = pd.DataFrame()
        if not dfcreateZone_failure.empty:
            dfcreateZone_failure.to_csv(os.path.join(dir_path, "createZone_failure", (file[:-4] + "createZone_failure.csv")))
            dfcreateZone_failure.to_csv(os.path.join(error_directory,  (file[:-4] + "createZone_failure.csv")),index=False)
            dfcreateZone_failure = pd.DataFrame()

        dfcreateRule_failure = pd.DataFrame(createRule_failure_list)
        dfcreateRule_success = pd.DataFrame(createRule_success_list)

        if not dfcreateRule_success.empty:
            dfcreateRule_success.to_csv(os.path.join(dir_path, "createRule_success", (file[:-4] + "createRule_success.csv")))
            dfcreateRule_success = pd.DataFrame()
        if not dfcreateRule_failure.empty:
            dfcreateRule_failure.to_csv(os.path.join(dir_path, "createRule_failure", (file[:-4] + "createRule_failure.csv")))
            dfcreateRule_failure.to_csv(os.path.join(error_directory,  (file[:-4] + "createRule_failure.csv")),index=False)
            dfcreateRule_failure = pd.DataFrame()




