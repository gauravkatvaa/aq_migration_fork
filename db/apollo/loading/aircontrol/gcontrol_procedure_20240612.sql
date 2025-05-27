SET FOREIGN_KEY_CHECKS=0;

DROP PROCEDURE IF EXISTS migration_sim_bulk_insert;
DELIMITER //
CREATE PROCEDURE `migration_sim_bulk_insert`()
BEGIN

/*
-- *************************************************************************
-- Procedure: migration_sim_bulk_insert_test
-- Author: manish saini
-- Date: 2024-02-22
-- Description: Procedure for automated sim_bulk_insert
-- *************************************************************************

selectg max(id) from assets_extended;  105=a
selectg max(ASSETS_EXTENDED_ID) from assets; 100=b
selectg max(id) from assets; 200=c
assets_extended id= 106
assets id =201
IP: 192.168.1.122
db name : stc_dev_p2

IFNULL(CREATE_DATE,NOW())
IFNULL(ACTIVATION_DATE,NOW())
IFNULL(BILLING_CYCLE,1)
MNO_ACCOUNTID= (SELECT ID FROM accounts WHERE TYPE=3 AND NAME='KSA_OPCO' AND DELETED=0)
IFNULL(STATE_MODIFIED_DATE,NOW())
IFNULL(DEVICE_PLAN_DATE,NOW())

NULL =ICCID = F
NULL =IMSI = F
NULL =MSISDN = F
NULL =STATE = F
NULL =COUNTRIES_ID=F
NULL =DEVICE_PLAN_ID = F
NULL= ENT_ACCOUNTID=F

select a.id,a.plan_name,c.NOTIFICATION_UUID from device_rate_plan as a inner join device_plan_to_service_apn_mapping as b on b.DEVICE_PLAN_ID_ID=a.ID inner join accounts as c on a.account_id=c.id where a.status=0 order
by a.id desc limit 10;


Rollback query
delete from assets_apn_allocation where ASSETS_ID>552;
delete from assets where id>552;
alter table assets AUTO_INCREMENT=552;
-- truncate table migration_assets_extended ;
delete from assets_extended where id>552;
alter table assets_extended AUTO_INCREMENT=552;
delete from service_apn_account_mapping where ACCOUNT_ID=15772;
delete from apn_ip_mapping where ASSETS_ID>552;


select * from temp_migration_apn_ip_account_list;
select * from service_apn_account_mapping order by id desc limit 10;

select * from apn_ip_mapping order by id desc limit 10



LOAD DATA INFILE '/var/lib/mysql-files/asset_dummy_240605.csv'
INTO TABLE migration_assets
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/var/lib/mysql-files/asset_extended_dummy_240605.csv'
INTO TABLE migration_assets_extended
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


*/

DECLARE EXIT handler FOR SQLEXCEPTION
BEGIN

GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;

SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");

SELECT COUNT(1) INTO @before_excution FROM assets;
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) as before_excution,
CONCAT('after_execution: ',IFNULL(@before_excution,0)) as after_execution,
CONCAT('success_count: ',0) as success_count,
CONCAT('failed_count: ',0) as failed_count,
IFNULL(@MESSAGE_TEXT,'') as Remarks;

PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;

SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
 SET SESSION group_concat_max_len = 10000000000;
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");

prepare stmt_1 from @delete_history;
execute stmt_1;
deallocate prepare stmt_1;



SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");


prepare stmt_1 from @Update_history;
execute stmt_1;
deallocate prepare stmt_1;


SELECT count(1) INTO @ftotal_count from migration_assets;
SELECT COUNT(1) INTO @before_excution FROM assets;

START TRANSACTION;


TRUNCATE TABLE migration_assets_error_history;
TRUNCATE TABLE migration_assets_extended_error_history;


-- select 'section 1';

INSERT INTO migration_assets_extended_error_history (`CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,`Error_Message`)
SELECT `CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,'invalid sim_type_id value' from migration_assets_extended WHERE ((sim_type_id NOT in (3,4) OR sim_type_id IS NULL));



INSERT INTO migration_assets_extended_error_history(`CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,`Error_Message`)
SELECT `CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,'invalid sim_category value' from migration_assets_extended WHERE ((sim_category NOT in ('831','830','05X') OR sim_category IS NULL));


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid countries value' FROM migration_assets AS a LEFT JOIN countries AS c ON TRIM(a.COUNTRIES_ID)=c.NAME WHERE (c.NAME IS NULL OR c.NAME='');


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid device plan and account id is not mapping to device plan' FROM migration_assets AS a LEFT JOIN accounts AS b ON TRIM(a.ENT_ACCOUNTID)=b.NOTIFICATION_UUID LEFT JOIN countries AS c ON TRIM(a.COUNTRIES_ID)=c.NAME LEFT JOIN device_rate_plan AS d ON TRIM(a.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID WHERE (d.PLAN_NAME IS NULL OR d.PLAN_NAME='');


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid account value' FROM migration_assets AS a LEFT JOIN accounts AS b ON TRIM(a.ENT_ACCOUNTID)=b.NOTIFICATION_UUID WHERE (b.NAME IS NULL OR b.NAME='');

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE IMSI IN (SELECT DISTINCT IMSI FROM ASSETS) ;

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE ICCID IN (SELECT DISTINCT ICCID FROM ASSETS) ;

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE MSISDN IN (SELECT DISTINCT MSISDN FROM ASSETS) ;


-- select 'section 1 end';

SET FOREIGN_KEY_CHECKS=0;
/*
select 'section migration_assets_extended duplicate sim_type_id check';
DELETE FROM  migration_assets_extended WHERE ((sim_type_id NOT in (3,4) OR sim_type_id IS NULL));
select 'section migration_assets_extended duplicate sim_category check';
DELETE FROM  migration_assets_extended WHERE ((sim_category NOT in ('831','830','05X') OR sim_category IS NULL));
*/


DROP TEMPORARY TABLE IF EXISTS `temp_assets_duplicate`;
CREATE temporary TABLE `temp_assets_duplicate` (`id` int);

-- select 'section duplicate imsi check';
INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE imsi IN (SELECT imsi FROM assets);
-- select 'section duplicate MSISDN check';
INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE MSISDN  IN (SELECT MSISDN FROM assets);
-- select 'section duplicate ICCID check';
INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE ICCID  IN (SELECT ICCID FROM assets);

--   select 'section duplicate record delete';
DELETE FROM migration_assets WHERE ID IN (SELECT id FROM temp_assets_duplicate);

COMMIT;

/*
DELETE FROM migration_assets WHERE (ICCID IS NULL OR ICCID='');
DELETE FROM migration_assets WHERE (IMSI IS NULL OR IMSI='');
DELETE FROM migration_assets WHERE (MSISDN IS NULL OR MSISDN='');
DELETE FROM migration_assets WHERE (STATE IS NULL OR STATE='');
DELETE FROM migration_assets WHERE (COUNTRIES_ID IS NULL OR COUNTRIES_ID='');
DELETE FROM migration_assets WHERE (DEVICE_PLAN_ID IS NULL OR DEVICE_PLAN_ID='');
DELETE FROM migration_assets WHERE (ENT_ACCOUNTID IS NULL OR ENT_ACCOUNTID='');
*/

SET FOREIGN_KEY_CHECKS=1;

-- select 'section 2';

SELECT count(1) into @migrationassets from migration_assets WHERE ID NOT IN (SELECT ID FROM assets);
SELECT count(1) into @migrationassetsextended from migration_assets_extended WHERE migration_assets_extended.ID IN (SELECT migration_assets.ASSETS_EXTENDED_ID FROM migration_assets);


IF(@migrationassetsextended>0 AND @migrationassets>0)
THEN

-- SELECT "insert_assets_extended start"; 
SET FOREIGN_KEY_CHECKS=0;
SET @insert_assets_extended = CONCAT("INSERT INTO assets_extended(ID, `CREATE_DATE`, `voice_template`, `sms_template`, `data_template`, `sim_type_id`, `ORDER_NUMBER`, `SERVICE_GRANT`, `IMEI_LOCK`, `OLD_PROFILE_STATE`, `CURRENT_PROFILE_STATE`, `custom_param_1`, `custom_param_2`, `custom_param_3`, `custom_param_4`, `custom_param_5`, `BULK_SERVICE_NAME`, `FVS_DATA`, `sim_category`) SELECT ID,`CREATE_DATE`, `voice_template`, `sms_template`, `data_template`, `sim_type_id`, `ORDER_NUMBER`, `SERVICE_GRANT`, `IMEI_LOCK`, `OLD_PROFILE_STATE`, `CURRENT_PROFILE_STATE`, `custom_param_1`, `custom_param_2`, `custom_param_3`, `custom_param_4`, `custom_param_5`, `BULK_SERVICE_NAME`, `FVS_DATA`, `sim_category` FROM migration_assets_extended  WHERE ID IN (SELECT migration_assets.ASSETS_EXTENDED_ID FROM migration_assets);");

PREPARE stmt_1 FROM @insert_assets_extended;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

-- SELECT "assets insert start"; 

SET @insert_assets = CONCAT("INSERT INTO assets(ID,`CREATE_DATE`, `ACTIVATION_DATE`, `APN`, `DATA_USAGE_LIMIT`, `DEVICE_ID`, `DEVICE_IP_ADDRESS`, `DYNAMIC_IMSI`, `DONOR_IMSI`, `ICCID`, `IMEI`, `IMSI`, `IN_SESSION`, `MODEM_ID`, `MSISDN`, `SESSION_START_TIME`, `SMS_USAGE_LIMIT`, `STATE`, `STATUS`, `VOICE_USAGE_LIMIT`, `SUBSCRIBER_NAME`, `SUBSCRIBER_LAST_NAME`, `SUBSCRIBER_GENDER`, `SUBSCRIBER_DOB`, `ALTERNATE_CONTACT_NUMBER`, `SUBSCRIBER_EMAIL`, `SUBSCRIBER_ADDRESS`, `CUSTOM_PARAM_1`, `CUSTOM_PARAM_2`, `CUSTOM_PARAM_3`, `CUSTOM_PARAM_4`, `CUSTOM_PARAM_5`, `SERVICE_PLAN_ID`, `LOCATION_COVERAGE_ID`, `NEXT_LOCATION_COVERAGE_ID`, `BILLING_CYCLE`, `RATE_PLAN_ID`, `NEXT_RATE_PLAN_ID`, `MNO_ACCOUNTID`, `ENT_ACCOUNTID`, `TOTAL_DATA_USAGE`, `TOTAL_DATA_DOWNLOAD`, `TOTAL_DATA_UPLOAD`, `DATA_USAGE_THRESHOLD`, `IP_ADDRESS`, `LAST_KNOWN_LOCATION`, `LAST_KNOWN_NETWORK`, `STATE_MODIFIED_DATE`, `USAGES_NOTIFICATION`, `BSS_ID`, `GOUP_ID`, `LOCK_REFERENCE`, `SIM_POOL_ID`, `WHOLESALE_PLAN_ID`, `PROFILE_STATE`, `EUICC_ID`, `OPERATIONAL_PROFILE_DATA_PLAN`, `BOOTSTRAP_PROFILE`, `CURRENT_IMEI`, `ASSETS_EXTENDED_ID`, `DEVICE_PLAN_ID`, `DEVICE_PLAN_DATE`, `COUNTRIES_ID`, `DONOR_ICCID`) SELECT assets.ID, IFNULL(`assets`.`CREATE_DATE`,NOW()), `assets`.`ACTIVATION_DATE`, `assets`.`APN`, `assets`.`DATA_USAGE_LIMIT`, `assets`.`DEVICE_ID`, `assets`.`DEVICE_IP_ADDRESS`, `assets`.`DYNAMIC_IMSI`, `assets`.`DONOR_IMSI`, `assets`.`ICCID`, `assets`.`IMEI`, `assets`.`IMSI`, IFNULL(`assets`.`IN_SESSION`,0), `assets`.`MODEM_ID`, `assets`.`MSISDN`, `assets`.`SESSION_START_TIME`, `assets`.`SMS_USAGE_LIMIT`, IFNULL(`assets`.`STATE`,'Activated'), IFNULL(`assets`.`STATUS`,'Activated'), `assets`.`VOICE_USAGE_LIMIT`, `assets`.`SUBSCRIBER_NAME`, `assets`.`SUBSCRIBER_LAST_NAME`, IFNULL(`assets`.`SUBSCRIBER_GENDER`,0), `assets`.`SUBSCRIBER_DOB`, `assets`.`ALTERNATE_CONTACT_NUMBER`, `assets`.`SUBSCRIBER_EMAIL`, `assets`.`SUBSCRIBER_ADDRESS`, `assets`.`CUSTOM_PARAM_1`, `assets`.`CUSTOM_PARAM_2`, `assets`.`CUSTOM_PARAM_3`, `assets`.`CUSTOM_PARAM_4`, `assets`.`CUSTOM_PARAM_5`, e.SERVICE_PLAN_ID, `assets`.`LOCATION_COVERAGE_ID`, IFNULL(`assets`.`NEXT_LOCATION_COVERAGE_ID`,0), IFNULL(`assets`.`BILLING_CYCLE`,1), `assets`.`RATE_PLAN_ID`, `assets`.`NEXT_RATE_PLAN_ID`, (SELECT ID FROM accounts WHERE TYPE=3 AND NAME='KSA_OPCO' AND DELETED=0), `b`.`id`, IFNULL(`assets`.`TOTAL_DATA_USAGE`,0), IFNULL(`assets`.`TOTAL_DATA_DOWNLOAD`,0), IFNULL(`assets`.`TOTAL_DATA_UPLOAD`,0), IFNULL(`assets`.`DATA_USAGE_THRESHOLD`,0), `assets`.`IP_ADDRESS`, `assets`.`LAST_KNOWN_LOCATION`, `assets`.`LAST_KNOWN_NETWORK`, IFNULL(`assets`.`STATE_MODIFIED_DATE`,NOW()), IFNULL(`assets`.`USAGES_NOTIFICATION`,0), `assets`.`BSS_ID`, `assets`.`GOUP_ID`, `assets`.`LOCK_REFERENCE`, `assets`.`SIM_POOL_ID`, `assets`.`WHOLESALE_PLAN_ID`, `assets`.`PROFILE_STATE`, `assets`.`EUICC_ID`, `assets`.`OPERATIONAL_PROFILE_DATA_PLAN`, `assets`.`BOOTSTRAP_PROFILE`, `assets`.`CURRENT_IMEI`, `assets`.`ASSETS_EXTENDED_ID`, `d`.`id`, IFNULL(`assets`.`DEVICE_PLAN_DATE`,NOW()), `c`.`ID`, `assets`.`DONOR_ICCID` FROM migration_assets AS assets INNER JOIN accounts AS b ON TRIM(assets.ENT_ACCOUNTID)=b.NOTIFICATION_UUID AND b.DELETED=0 INNER JOIN countries AS c ON TRIM(assets.COUNTRIES_ID)=c.NAME LEFT JOIN device_rate_plan AS d ON TRIM(assets.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID AND d.DELETED=0 LEFT JOIN device_service_plan_mapping as e on e.DEVICE_PLAN_ID=d.id WHERE assets.ID NOT IN (SELECT ID FROM assets);");

PREPARE stmt_1 FROM @insert_assets;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

COMMIT;
SET FOREIGN_KEY_CHECKS=1;

SET @delete_assets_extended = CONCAT("DELETE FROM assets_extended WHERE ID NOT IN (SELECT ASSETS_EXTENDED_ID FROM assets);");

PREPARE stmt_1 FROM @delete_assets_extended;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;

SELECT count(1) INTO @success_count from assets WHERE ID IN (SELECT ID FROM migration_assets);

ELSEIF(@migrationassets=0 AND @migrationassetsextended=0) THEN

SELECT 'No Records Found in migration_assets and migration_assets_extended table' INTO @MESSAGE_TEXT;

SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status,is_completed) SELECT 
DATABASE(),'failure',now(),'",@MESSAGE_TEXT,"',1;");

PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
END IF;

SELECT count(1) INTO @failed_count from migration_assets WHERE ID NOT IN (SELECT ID FROM assets);
SELECT COUNT(1) INTO @after_execution FROM assets;


IF(@after_execution>@before_excution) THEN
SET FOREIGN_KEY_CHECKS=0;

-- SELECT "asstes ,account ,device plan,apn name and ip mapping start"; 

DROP TEMPORARY TABLE IF EXISTS temp_migration_apn_ip_account_list;
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_migration_apn_ip_account_list` (
   id bigint NOT NULL AUTO_INCREMENT,
   account_id bigint DEFAULT NULL,
   apn_id bigint DEFAULT NULL,
   ip_id bigint DEFAULT NULL,
   create_date datetime DEFAULT NULL,
   asset_id  bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO temp_migration_apn_ip_account_list(account_id,apn_id,ip_id,create_date,asset_id)
SELECT distinct b.id as account_id,f.apn_id,f.ID as ip_id,NOW() as create_date,assets.ID as asset_id FROM migration_assets assets INNER JOIN accounts AS b ON TRIM(assets.ENT_ACCOUNTID)=b.NOTIFICATION_UUID AND b.DELETED=0 INNER JOIN device_rate_plan AS d ON TRIM(assets.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID AND d.DELETED=0 INNER JOIN device_plan_to_service_apn_mapping as e on e.DEVICE_PLAN_ID_ID=d.ID INNER JOIN Service_Apn_ip as f on assets.IP_ADDRESS=f.APN_IP;

INSERT INTO service_apn_account_mapping(ACCOUNT_ID,APN_ID,CREATE_DATE)
SELECT distinct account_id,apn_id,create_date FROM temp_migration_apn_ip_account_list WHERE (account_id NOT IN (SELECT ACCOUNT_ID FROM service_apn_account_mapping) AND apn_id NOT IN (SELECT APN_ID FROM service_apn_account_mapping));

INSERT INTO apn_ip_mapping(APN_ID,IP_ID,CREATE_DATE,ASSETS_ID)
SELECT distinct apn_id,ip_id,create_date,asset_id FROM temp_migration_apn_ip_account_list WHERE 
asset_id NOT IN (SELECT DISTINCT ASSETS_ID FROM apn_ip_mapping);

INSERT INTO assets_apn_allocation(ASSETS_ID,APN_ID,CREATE_DATE)
SELECT distinct asset_id,apn_id,create_date FROM temp_migration_apn_ip_account_list WHERE asset_id NOT IN (SELECT DISTINCT ASSETS_ID FROM assets_apn_allocation);

COMMIT;

SET @getsapndet_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct apn_id),0) INTO @sapndet_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getsapndet_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

COMMIT;

SET @updsapndet_list = CONCAT("UPDATE service_apn_details as sad SET sad.status='IN_USE' WHERE sad.ID IN (",@sapndet_list,")  AND (sad.status='NOT_IN_USE' OR sad.status IS NULL);");

PREPARE stmt_1 FROM @updsapndet_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @getspi_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct ip_id),0) INTO @spi_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getspi_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @updgetspi_list = CONCAT("UPDATE Service_Apn_ip as sp SET sp.isUse=1 WHERE sp.ID IN (",@spi_list,")  AND (sp.isUse=0 OR sp.isUse IS NULL)");

PREPARE stmt_1 FROM @updgetspi_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @getdp_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct account_id),0) INTO @dp_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getdp_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @upddp_list = CONCAT("UPDATE device_rate_plan as dp SET dp.STATUS=1 WHERE dp.account_id IN (",@dp_list,") AND (dp.STATUS=0 OR dp.STATUS IS NULL);");

PREPARE stmt_1 FROM @upddp_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET FOREIGN_KEY_CHECKS=1;


SET @ai := (select max(id)+1 from assets);
set @qry = concat('alter table assets auto_increment=',@ai);
prepare stmt from @qry; execute stmt;

SET @aiex := (select max(id)+1 from assets_extended);
set @qryex = concat('alter table assets_extended auto_increment=',@aiex);
prepare stmt from @qryex; execute stmt;

COMMIT;

DELETE n1 FROM service_apn_account_mapping n1, service_apn_account_mapping n2 WHERE n1.id < n2.id AND n1.ACCOUNT_ID = n2.ACCOUNT_ID AND n1.APN_ID = n2.APN_ID ;

END IF;

SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) as before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) as after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) as success_count,
CONCAT('failed_count: ',(IFNULL(@ftotal_count,0)-IFNULL(@success_count,0))) as failed_count,
IFNULL(@MESSAGE_TEXT,'') as Remarks;


END//
DELIMITER ;


-- Dumping structure for procedure cmp_stc_staging.gcontrol_accounts_deletion_v1
DROP PROCEDURE IF EXISTS `gcontrol_accounts_deletion_v1`;
DELIMITER //
CREATE PROCEDURE `gcontrol_accounts_deletion_v1`(
IN `in_accountid` VARCHAR(255)
)
BEGIN











IF (SELECT count(1) FROM accounts WHERE id=in_accountid)>0 THEN



DROP TEMPORARY TABLE IF EXISTS T1;
CREATE TEMPORARY TABLE IF NOT EXISTS T1 
WITH RECURSIVE T1 AS 
(SELECT id, PARENT_ACCOUNT_ID AS parent_id,type
FROM accounts WHERE id = in_accountid 
UNION ALL 
SELECT A.id, A.PARENT_ACCOUNT_ID,A.type
FROM accounts A JOIN T1 ON A.id = T1.parent_id)
SELECT T1.id,T1.type FROM T1 WHERE T1.type in (4,5,6);

SET FOREIGN_KEY_CHECKS=0;
DELETE FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1));
DELETE FROM device_service_plan_mapping WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1));
select now() as time1;
DELETE FROM device_plan_to_service_apn_mapping  WHERE DEVICE_PLAN_ID_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1));
select 'device plan deleted';
select now() as time2;
DELETE FROM apn_ip_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM apn_request WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM assets_apn_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM device_plan_to_service_apn_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
select now() as time3;
select 'service apn deleted';
DELETE FROM service_apn_account_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM service_apn_account_allocation_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
select now() as time4;
DELETE FROM service_apn_account_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM service_apn_ip WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM service_apn_ip_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));
DELETE FROM service_apn_ip_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id IN (SELECT id FROM T1));

select now() as time5;

DELETE FROM apn_ip_mapping WHERE ASSETS_ID in (SELECT id FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1));
DELETE FROM assets_apn_allocation WHERE ASSETS_ID in (SELECT id FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1));
select 'assets apn mapping remove deleted';
DELETE FROM role_to_screen_mapping WHERE role_id IN (SELECT ID FROM role_access WHERE account_id IN (SELECT id FROM T1));
DELETE FROM role_to_tab_mapping WHERE role_id IN (SELECT ID FROM role_access WHERE account_id IN (SELECT id FROM T1));

select now() as time6;

DELETE FROM download_center_details WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM notification_system_history WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM notification_trigger_history WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
select now() as time7;
DELETE FROM subscription  WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM temp_token_manager WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM terms_conditions  WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM user_configuration_column WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM user_extended_accounts WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM user_hierarchy WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM user_settings WHERE user_id IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
select now() as time8;

DELETE FROM rule_engine_imsi_filter WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
DELETE FROM rule_engine_imsi_rule WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
DELETE FROM rule_engine_rule_action WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
DELETE FROM rule_engine_rule_trigger WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
DELETE FROM rule_engine_tag_rule WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
DELETE FROM rule_to_device_plan_mapping WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1));
select 'rule engine deleted';
select now() as time9;

DELETE FROM extended_audit_log           WHERE ASSET_ID IN (SELECT ID FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1));
DELETE FROM retention_user_asset_mapping WHERE ASSET_ID IN (SELECT ID FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1));
select now() as time10;
DELETE FROM order_shipping_status WHERE ID IN (SELECT order_shipping_id FROM map_user_sim_order WHERE account_id IN (SELECT id FROM T1));
DELETE FROM smsa_order_sent_history WHERE order_number IN (SELECT order_number FROM map_user_sim_order WHERE account_id IN (SELECT id FROM T1));
select now() as time11;
DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID
IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1)));
DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM price_model_to_pricing_categories WHERE PRICE_MODEL_ID IN(SELECT ID FROM price_model_rate_plan WHERE account_id IN (SELECT id FROM T1)));
DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM whole_sale_to_pricing_categories WHERE WHOLE_SALE_ID IN (SELECT ID FROM whole_sale_rate_plan WHERE account_id IN (SELECT id FROM T1)));
select now() as time12;
DELETE FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1));
DELETE FROM price_model_to_pricing_categories WHERE PRICE_MODEL_ID IN(SELECT ID FROM price_model_rate_plan WHERE account_id IN (SELECT id FROM T1));
DELETE FROM whole_sale_to_pricing_categories WHERE WHOLE_SALE_ID IN (SELECT ID FROM whole_sale_rate_plan WHERE account_id IN (SELECT id FROM T1));
select now() as time13;
DELETE FROM map_sim_order_pricing WHERE ID IN (SELECT id FROM map_user_sim_order WHERE account_id IN (SELECT id FROM T1));


select now() as time14;

DELETE FROM account_screen_mapping WHERE account_id IN (SELECT id FROM T1);
DELETE FROM account_state_transition_account_mapping WHERE account_id IN (SELECT id FROM T1);
DELETE FROM account_to_node_mpping WHERE account_id IN (SELECT id FROM T1);
DELETE FROM accounts_to_associated_accounts_mapping WHERE account_id IN (SELECT id FROM T1);
select 'role and screen mapping deleted';
select now() as time15;
DELETE FROM api_billing WHERE account_id IN (SELECT id FROM T1);
DELETE FROM api_charge_calculation WHERE account_id IN (SELECT id FROM T1);
DELETE FROM api_user_transaction WHERE account_id IN (SELECT id FROM T1);
DELETE FROM auditlog WHERE account_id IN (SELECT id FROM T1);
DELETE FROM auditlog_api_transaction WHERE account_id IN (SELECT id FROM T1);
DELETE FROM auditlog_end_points WHERE account_id IN (SELECT id FROM T1);
DELETE FROM catalog WHERE account_id IN (SELECT id FROM T1);

DELETE FROM csr_charges_details WHERE account_id IN (SELECT id FROM T1);
DELETE FROM csr_order_txn_history WHERE account_id IN (SELECT id FROM T1);
DELETE FROM csr_tariff_plan_mapping WHERE account_id IN (SELECT id FROM T1);
select now() as time16;
DELETE FROM group_to_accounts WHERE account_id IN (SELECT id FROM T1);
DELETE FROM ip_whitelisting WHERE account_id IN (SELECT id FROM T1);
select 'CSR and auditlog deleted';
select now() as time17;

DELETE FROM lbs_zones WHERE account_id IN (SELECT id FROM T1);
DELETE FROM map_user_sim_order WHERE account_id IN (SELECT id FROM T1);
DELETE FROM notification_system_template WHERE account_id IN (SELECT id FROM T1);
DELETE FROM notification_trigger_template WHERE account_id IN (SELECT id FROM T1);

select 'lbs zone deleted';


DELETE FROM penalty_exemption WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_apn_account_allocation WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_apn_account_allocation_mapping WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_apn_account_mapping WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_coverage WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_event_log WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_pool WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_details WHERE account_id IN (SELECT id FROM T1);
select now() as time18;
select 'sim event log and service_apn_account_allocation deleted';
DELETE FROM sim_provisioned_range_to_account_level1 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level10 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level2 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level3 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level4 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level5 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level6 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level7 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level8 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_range_to_account_level9 WHERE account_id IN (SELECT id FROM T1);
select '11';
DELETE FROM sim_provisioned_ranges_level1 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level10 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level2 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level3 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level4 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level5 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level6 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level7 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level8 WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_provisioned_ranges_level9 WHERE account_id IN (SELECT id FROM T1);
select 'sim_provisioned_ranges deleted';
DELETE FROM sim_range WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_range_msisdn WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_status_change_report WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_whitelisting_history WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sim_whitelisting_status WHERE account_id IN (SELECT id FROM T1);
DELETE FROM sms_action_history WHERE account_id IN (SELECT id FROM T1);
DELETE FROM subscription WHERE account_id IN (SELECT id FROM T1);
DELETE FROM tag  WHERE account_id IN (SELECT id FROM T1);
select 'tag and sim range deleted';

select '2';
DELETE FROM tag_entity WHERE account_id IN (SELECT id FROM T1);
DELETE FROM terms_conditions WHERE account_id IN (SELECT id FROM T1);
DELETE FROM user_extended_accounts WHERE account_id IN (SELECT id FROM T1);
DELETE FROM vas_charges_details WHERE account_id IN (SELECT id FROM T1);
DELETE FROM whole_sale_invoice WHERE account_id IN (SELECT id FROM T1);
DELETE FROM whole_sale_plan_to_account WHERE account_id IN (SELECT id FROM T1);
DELETE FROM wl_bl_sim WHERE account_id IN (SELECT id FROM T1);
select '3';
DELETE FROM wl_bl_template WHERE account_id IN (SELECT id FROM T1);
DELETE FROM zones WHERE account_id IN (SELECT id FROM T1);

select 'tab and zone deleted';
DELETE FROM service_apn_details WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_plan WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1));
DELETE FROM price_model_rate_plan WHERE account_id IN (SELECT id FROM T1);
DELETE FROM retail_rate_plan WHERE account_id IN (SELECT id FROM T1);
DELETE FROM rule_engine_rule WHERE account_id IN (SELECT id FROM T1);
DELETE FROM whole_sale_rate_plan WHERE account_id IN (SELECT id FROM T1);
select 'service plan and account plan deleted';
DELETE FROM data_plan WHERE account_id IN (SELECT id FROM T1);
DELETE FROM device_rate_plan WHERE account_id IN (SELECT id FROM T1);
DELETE FROM api_users WHERE account_id IN (SELECT id FROM T1);
DELETE FROM role_access WHERE account_id IN (SELECT id FROM T1);
DELETE FROM service_plan WHERE account_id IN (SELECT id FROM T1);
select 'api_users and api_users deleted';
DELETE FROM contact_info WHERE ID IN (SELECT CONTACT_INFO_ID FROM users WHERE account_id IN (SELECT id FROM T1));


DELETE FROM contact_info WHERE ID IN (SELECT a.CONTACT_INFO_ID from users as a inner join stc_migration.users_details_cdp as u on a.user_name=u.LOGIN WHERE u.ROLE_NAME in ('Lead Person','OpCo_AM'));

DELETE FROm user_details WHERE ID IN (SELECT a.USER_DETAILS_ID from users as a inner join stc_migration.users_details_cdp as u on a.user_name=u.LOGIN WHERE u.ROLE_NAME in ('Lead Person','OpCo_AM'));
DELETE a from users as a inner join stc_migration.users_details_cdp as u on a.user_name=u.LOGIN WHERE u.ROLE_NAME in ('Lead Person','OpCo_AM');

select 'User Lead Person,OpCo_AM deleted';

DELETE FROM product_type_to_customer_accounts_mapping WHERE PRODUCT_TYPE_ID IN (select a.id from order_product_defination as a inner join stc_migration.sim_products_cdp as b on a.PRODUCT_NAME=b.title);
DELETE a from order_product_defination as a inner join stc_migration.sim_products_cdp as b on a.PRODUCT_NAME=b.title;

select 'product type deleted';


DELETE FROM contact_info WHERE ID IN (SELECT BILLING_CONTACT_INFO_ID FROM accounts WHERE id IN (SELECT id FROM T1));
DELETE FROM contact_info WHERE ID IN (SELECT PRIMARY_CONTACT_INFO_ID FROM accounts WHERE id IN (SELECT id FROM T1));
DELETE FROM contact_info WHERE ID IN (SELECT OPERATIONS_CONTACT_INFO_ID FROM accounts WHERE id IN (SELECT id FROM T1));
DELETE FROM contact_info WHERE ID IN (SELECT SIM_ORDER_CONTACT_INFO_ID FROM accounts WHERE id IN (SELECT id FROM T1));
DELETE FROM account_extended WHERE ID IN (SELECT EXTENDED_ID FROM accounts WHERE id IN (SELECT id FROM T1));
select '7';

DELETE FROm user_details WHERE ID IN (SELECT USER_DETAILS_ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROm user_configuration_column WHERE USER_ID IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROm api_user_mapping WHERE API_USER_ID IN (SELECT ID FROM users WHERE account_id IN (SELECT id FROM T1));
DELETE FROM users WHERE account_id IN (SELECT id FROM T1);
DELETE FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1);   

select 'users and assets deleted';


DELETE FROM assets_extended WHERE ID IN (SELECT ASSETS_EXTENDED_ID FROM assets WHERE ENT_ACCOUNTID IN (SELECT id FROM T1));
DELETE FROM accounts WHERE id IN (SELECT id FROM T1);
DELETE FROM organization_organization WHERE id IN (SELECT id FROM T1);
select 'accounts deleted';

SET FOREIGN_KEY_CHECKS=1;

ELSE
  
  
  SELECT 'Account id NOT FOUND' ;
  
END IF;
  
END//
DELIMITER ;
-- Dumping structure for procedure cmp_stc_staging.map_user_sim_order_procedure_bulk_insert
DROP PROCEDURE IF EXISTS `map_user_sim_order_procedure_bulk_insert`;
DELIMITER //
CREATE PROCEDURE `map_user_sim_order_procedure_bulk_insert`()
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;
truncate table `cmp_stc_staging`.`migration_map_user_sim_order_error_history`;
INSERT INTO `cmp_stc_staging`.`migration_map_user_sim_order_error_history` (
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  `Error_Message`
) 
SELECT
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  'Invalid order_shipping_id value ' as `Error_Message`
FROM migration_map_user_sim_order
WHERE order_shipping_id IS NULL OR order_shipping_id='';
INSERT INTO `cmp_stc_staging`.`migration_map_user_sim_order_error_history` (
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  `Error_Message`
) 
SELECT
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  'Invalid sim_category_id value ' AS `Error_Message`
FROM migration_map_user_sim_order
WHERE sim_category_id IS NULL OR sim_category_id='';
INSERT INTO `cmp_stc_staging`.`migration_map_user_sim_order_error_history` (
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  `Error_Message`
) 
SELECT
  `ordered_by`,	  `status_updated_date`,  `sim_category_id`,	  	`create_date`,
  `final_price`,  `extra_metadata`,  	   `order_number`,  		`account_id`,
  `order_status`, `quantity`,  		   `per_unit_price`,  		`order_shipping_id`,
  `is_standard`,  `is_express`,  	   `order_sim_category`,  	`auto_activation`,
  `data_plan_id`,  `service_plan_id`,      `REMARKS`,  			`CUSTOM_PARAM_1`,  `CUSTOM_PARAM_2`,
  `CUSTOM_PARAM_3`,  `CUSTOM_PARAM_4`,     `CUSTOM_PARAM_5`,  		`CUSTOM_PARAM_6`,
  `DELETED`,  `DELETED_DATE`,  `TERMS_CONDITIONS`,  `IS_BLANK_SIM`,
  `STATUS`,  `awb_number`,  `isOrderSentInSheet`,  'Invalid ordered_by value ' AS `Error_Message`
FROM migration_map_user_sim_order
WHERE ordered_by IS NULL OR ordered_by='';
 
 
 
 
SELECT COUNT(1) INTO @migration_map_user FROM `migration_map_user_sim_order`;
SELECT COUNT(1) INTO @before_excution FROM `map_user_sim_order`;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `cmp_stc_staging`.`map_user_sim_order` (
  `id`,			  `ordered_by`,		  `status_updated_date`,	  `sim_category_id`,
  `create_date`,	  `final_price`,	  `extra_metadata`,		  `order_number`,
  `account_id`,  	  `order_status`,  	  `quantity`,  			  `per_unit_price`,
  `order_shipping_id`,    `is_standard`, 	  `is_express`,			  `order_sim_category`,
  `auto_activation`,	  `data_plan_id`,	  `service_plan_id`,		  `REMARKS`,
  `CUSTOM_PARAM_1`,	  `CUSTOM_PARAM_2`,	  `CUSTOM_PARAM_3`,		  `CUSTOM_PARAM_4`,
  `CUSTOM_PARAM_5`,	  `CUSTOM_PARAM_6`,	  `DELETED`,			  `DELETED_DATE`,
  `TERMS_CONDITIONS`,	  `IS_BLANK_SIM`,	  `STATUS`,			  `awb_number`,
  `isOrderSentInSheet`
) 
SELECT 
  m1.id,   
(SELECT id FROM `users` WHERE USER_NAME=u1.login) AS ordered_by ,	  m1.status_updated_date,	  m1.sim_category_id,
  m1.create_date,	  m1.final_price,	  m1.extra_metadata,		  m1.order_number,
  a1.ID,  	  	  m1.order_status,  	  m1.quantity,  		  m1.per_unit_price,
  order_shipping_id AS order_shipping_id,   m1.is_standard, 	  m1.is_express,		  m1.order_sim_category,
  m1.auto_activation,	  m1.data_plan_id,	  m1.service_plan_id,		  m1.REMARKS,
  (SELECT od1.ID FROM order_product_defination od1 
WHERE  od1.Product_name=m1.CUSTOM_PARAM_1) AS CUSTOM_PARAM_1,	
  m1.CUSTOM_PARAM_2,	  m1.CUSTOM_PARAM_3,		  m1.CUSTOM_PARAM_4,
  m1.CUSTOM_PARAM_5,	  m1.CUSTOM_PARAM_6,	  m1.DELETED,			  m1.DELETED_DATE,
  m1.TERMS_CONDITIONS,	  m1.IS_BLANK_SIM,	  m1.STATUS,			  m1.awb_number,
  m1.isOrderSentInSheet
FROM `migration_map_user_sim_order` m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=CAST(m1.account_id AS CHAR)
LEFT JOIN `users_details_cdp` u1 ON u1.USER_ID=m1.ordered_by
;
SET FOREIGN_KEY_CHECKS=1;
SELECT COUNT(1) INTO @after_execution FROM map_user_sim_order;
SET @ai := (SELECT MAX(id)+1 FROM map_user_sim_order);
SET @qry = CONCAT('alter table map_user_sim_order auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM map_user_sim_order WHERE ID IN (SELECT ID FROM migration_map_user_sim_order);
SELECT COUNT(1) INTO @failed_count FROM migration_map_user_sim_order WHERE ID NOT IN (SELECT ID FROM map_user_sim_order);
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END//
DELIMITER ;

-- Data exporting was unselected.

-- Dumping structure for procedure cmp_stc_staging.migration_sim_bulk_insert
DROP PROCEDURE IF EXISTS `migration_sim_bulk_insert`;
DELIMITER //
CREATE PROCEDURE `migration_sim_bulk_insert`()
BEGIN



DECLARE EXIT handler FOR SQLEXCEPTION
BEGIN

GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;

SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");

SELECT COUNT(1) INTO @before_excution FROM assets;
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) as before_excution,
CONCAT('after_execution: ',IFNULL(@before_excution,0)) as after_execution,
CONCAT('success_count: ',0) as success_count,
CONCAT('failed_count: ',0) as failed_count,
IFNULL(@MESSAGE_TEXT,'') as Remarks;

PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;

SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
 SET SESSION group_concat_max_len = 10000000000;
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");

prepare stmt_1 from @delete_history;
execute stmt_1;
deallocate prepare stmt_1;



SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");


prepare stmt_1 from @Update_history;
execute stmt_1;
deallocate prepare stmt_1;


SELECT count(1) INTO @ftotal_count from migration_assets;
SELECT COUNT(1) INTO @before_excution FROM assets;

START TRANSACTION;


TRUNCATE TABLE migration_assets_error_history;
TRUNCATE TABLE migration_assets_extended_error_history;




INSERT INTO migration_assets_extended_error_history (`CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,`Error_Message`)
SELECT `CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,'invalid sim_type_id value' from migration_assets_extended WHERE ((sim_type_id NOT in (3,4) OR sim_type_id IS NULL));



INSERT INTO migration_assets_extended_error_history(`CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,`Error_Message`)
SELECT `CREATE_DATE`,`voice_template`,`sms_template`,`data_template`,`sim_type_id`,`ORDER_NUMBER`,`SERVICE_GRANT`,`IMEI_LOCK`,`OLD_PROFILE_STATE`,`CURRENT_PROFILE_STATE`,`custom_param_1`,`custom_param_2`,`custom_param_3`,`custom_param_4`,`custom_param_5`,`BULK_SERVICE_NAME`,`FVS_DATA`,`sim_category`,`lock_by_user`,`imei_lock_setup_date`,`imei_lock_disable_date`,'invalid sim_category value' from migration_assets_extended WHERE ((sim_category NOT in ('831','830','05X') OR sim_category IS NULL));


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid countries value' FROM migration_assets AS a LEFT JOIN countries AS c ON TRIM(a.COUNTRIES_ID)=c.NAME WHERE (c.NAME IS NULL OR c.NAME='');


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid device plan and account id is not mapping to device plan' FROM migration_assets AS a LEFT JOIN accounts AS b ON TRIM(a.ENT_ACCOUNTID)=b.NOTIFICATION_UUID LEFT JOIN countries AS c ON TRIM(a.COUNTRIES_ID)=c.NAME LEFT JOIN device_rate_plan AS d ON TRIM(a.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID WHERE (d.PLAN_NAME IS NULL OR d.PLAN_NAME='');


INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'invalid account value' FROM migration_assets AS a LEFT JOIN accounts AS b ON TRIM(a.ENT_ACCOUNTID)=b.NOTIFICATION_UUID WHERE (b.NAME IS NULL OR b.NAME='');

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE IMSI IN (SELECT DISTINCT IMSI FROM ASSETS) ;

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE ICCID IN (SELECT DISTINCT ICCID FROM ASSETS) ;

INSERT INTO migration_assets_error_history(`CREATE_DATE`,`ACTIVATION_DATE`,`APN`,`DATA_USAGE_LIMIT`,`DEVICE_ID`,`DEVICE_IP_ADDRESS`,`DYNAMIC_IMSI`,`DONOR_IMSI`,`ICCID`,`IMEI`,`IMSI`,`IN_SESSION`,`MODEM_ID`,`MSISDN`,`SESSION_START_TIME`,`SMS_USAGE_LIMIT`,`STATE`,`STATUS`,`VOICE_USAGE_LIMIT`,`SUBSCRIBER_NAME`,`SUBSCRIBER_LAST_NAME`,`SUBSCRIBER_GENDER`,`SUBSCRIBER_DOB`,`ALTERNATE_CONTACT_NUMBER`,`SUBSCRIBER_EMAIL`,`SUBSCRIBER_ADDRESS`,`CUSTOM_PARAM_1`,`CUSTOM_PARAM_2`,`CUSTOM_PARAM_3`,`CUSTOM_PARAM_4`,`CUSTOM_PARAM_5`,`SERVICE_PLAN_ID`,`LOCATION_COVERAGE_ID`,`NEXT_LOCATION_COVERAGE_ID`,`BILLING_CYCLE`,`RATE_PLAN_ID`,`NEXT_RATE_PLAN_ID`,`MNO_ACCOUNTID`,`ENT_ACCOUNTID`,`TOTAL_DATA_USAGE`,`TOTAL_DATA_DOWNLOAD`,`TOTAL_DATA_UPLOAD`,`DATA_USAGE_THRESHOLD`,`IP_ADDRESS`,`LAST_KNOWN_LOCATION`,`LAST_KNOWN_NETWORK`,`STATE_MODIFIED_DATE`,`USAGES_NOTIFICATION`,`BSS_ID`,`GOUP_ID`,`LOCK_REFERENCE`,`SIM_POOL_ID`,`WHOLESALE_PLAN_ID`,`PROFILE_STATE`,`EUICC_ID`,`OPERATIONAL_PROFILE_DATA_PLAN`,`BOOTSTRAP_PROFILE`,`CURRENT_IMEI`,`ASSETS_EXTENDED_ID`,`DEVICE_PLAN_ID`,`DEVICE_PLAN_DATE`,`COUNTRIES_ID`,`DONOR_ICCID`,`Error_Message`) 
SELECT DISTINCT a.`CREATE_DATE`,a.`ACTIVATION_DATE`,a.`APN`,a.`DATA_USAGE_LIMIT`,a.`DEVICE_ID`,a.`DEVICE_IP_ADDRESS`,a.`DYNAMIC_IMSI`,a.`DONOR_IMSI`,a.`ICCID`,a.`IMEI`,a.`IMSI`,a.`IN_SESSION`,a.`MODEM_ID`,a.`MSISDN`,a.`SESSION_START_TIME`,a.`SMS_USAGE_LIMIT`,a.`STATE`,a.`STATUS`,a.`VOICE_USAGE_LIMIT`,a.`SUBSCRIBER_NAME`,a.`SUBSCRIBER_LAST_NAME`,a.`SUBSCRIBER_GENDER`,a.`SUBSCRIBER_DOB`,a.`ALTERNATE_CONTACT_NUMBER`,a.`SUBSCRIBER_EMAIL`,a.`SUBSCRIBER_ADDRESS`,a.`CUSTOM_PARAM_1`,a.`CUSTOM_PARAM_2`,a.`CUSTOM_PARAM_3`,a.`CUSTOM_PARAM_4`,a.`CUSTOM_PARAM_5`,a.`SERVICE_PLAN_ID`,a.`LOCATION_COVERAGE_ID`,a.`NEXT_LOCATION_COVERAGE_ID`,a.`BILLING_CYCLE`,a.`RATE_PLAN_ID`,a.`NEXT_RATE_PLAN_ID`,a.`MNO_ACCOUNTID`,a.`ENT_ACCOUNTID`,a.`TOTAL_DATA_USAGE`,a.`TOTAL_DATA_DOWNLOAD`,a.`TOTAL_DATA_UPLOAD`,a.`DATA_USAGE_THRESHOLD`,a.`IP_ADDRESS`,a.`LAST_KNOWN_LOCATION`,a.`LAST_KNOWN_NETWORK`,a.`STATE_MODIFIED_DATE`,a.`USAGES_NOTIFICATION`,a.`BSS_ID`,a.`GOUP_ID`,a.`LOCK_REFERENCE`,a.`SIM_POOL_ID`,a.`WHOLESALE_PLAN_ID`,a.`PROFILE_STATE`,a.`EUICC_ID`,a.`OPERATIONAL_PROFILE_DATA_PLAN`,a.`BOOTSTRAP_PROFILE`,a.`CURRENT_IMEI`,a.`ASSETS_EXTENDED_ID`,a.`DEVICE_PLAN_ID`,a.`DEVICE_PLAN_DATE`,a.`COUNTRIES_ID`,a.`DONOR_ICCID`,'Existing Duplicate records failed' from migration_assets a WHERE MSISDN IN (SELECT DISTINCT MSISDN FROM ASSETS) ;




SET FOREIGN_KEY_CHECKS=0;



DROP TEMPORARY TABLE IF EXISTS `temp_assets_duplicate`;
CREATE temporary TABLE `temp_assets_duplicate` (`id` int);


INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE imsi IN (SELECT imsi FROM assets);

INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE MSISDN  IN (SELECT MSISDN FROM assets);

INSERT INTO temp_assets_duplicate(id) SELECT DISTINCT id
FROM migration_assets WHERE ICCID  IN (SELECT ICCID FROM assets);


DELETE FROM migration_assets WHERE ID IN (SELECT id FROM temp_assets_duplicate);

COMMIT;



SET FOREIGN_KEY_CHECKS=1;



SELECT count(1) into @migrationassets from migration_assets WHERE ID NOT IN (SELECT ID FROM assets);
SELECT count(1) into @migrationassetsextended from migration_assets_extended WHERE migration_assets_extended.ID IN (SELECT migration_assets.ASSETS_EXTENDED_ID FROM migration_assets);


IF(@migrationassetsextended>0 AND @migrationassets>0)
THEN


SET FOREIGN_KEY_CHECKS=0;
SET @insert_assets_extended = CONCAT("INSERT INTO assets_extended(ID, `CREATE_DATE`, `voice_template`, `sms_template`, `data_template`, `sim_type_id`, `ORDER_NUMBER`, `SERVICE_GRANT`, `IMEI_LOCK`, `OLD_PROFILE_STATE`, `CURRENT_PROFILE_STATE`, `custom_param_1`, `custom_param_2`, `custom_param_3`, `custom_param_4`, `custom_param_5`, `BULK_SERVICE_NAME`, `FVS_DATA`, `sim_category`) SELECT ID,`CREATE_DATE`, `voice_template`, `sms_template`, `data_template`, `sim_type_id`, `ORDER_NUMBER`, `SERVICE_GRANT`, `IMEI_LOCK`, `OLD_PROFILE_STATE`, `CURRENT_PROFILE_STATE`, `custom_param_1`, `custom_param_2`, `custom_param_3`, `custom_param_4`, `custom_param_5`, `BULK_SERVICE_NAME`, `FVS_DATA`, `sim_category` FROM migration_assets_extended  WHERE ID IN (SELECT migration_assets.ASSETS_EXTENDED_ID FROM migration_assets);");

PREPARE stmt_1 FROM @insert_assets_extended;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;



SET @insert_assets = CONCAT("INSERT INTO assets(ID,`CREATE_DATE`, `ACTIVATION_DATE`, `APN`, `DATA_USAGE_LIMIT`, `DEVICE_ID`, `DEVICE_IP_ADDRESS`, `DYNAMIC_IMSI`, `DONOR_IMSI`, `ICCID`, `IMEI`, `IMSI`, `IN_SESSION`, `MODEM_ID`, `MSISDN`, `SESSION_START_TIME`, `SMS_USAGE_LIMIT`, `STATE`, `STATUS`, `VOICE_USAGE_LIMIT`, `SUBSCRIBER_NAME`, `SUBSCRIBER_LAST_NAME`, `SUBSCRIBER_GENDER`, `SUBSCRIBER_DOB`, `ALTERNATE_CONTACT_NUMBER`, `SUBSCRIBER_EMAIL`, `SUBSCRIBER_ADDRESS`, `CUSTOM_PARAM_1`, `CUSTOM_PARAM_2`, `CUSTOM_PARAM_3`, `CUSTOM_PARAM_4`, `CUSTOM_PARAM_5`, `SERVICE_PLAN_ID`, `LOCATION_COVERAGE_ID`, `NEXT_LOCATION_COVERAGE_ID`, `BILLING_CYCLE`, `RATE_PLAN_ID`, `NEXT_RATE_PLAN_ID`, `MNO_ACCOUNTID`, `ENT_ACCOUNTID`, `TOTAL_DATA_USAGE`, `TOTAL_DATA_DOWNLOAD`, `TOTAL_DATA_UPLOAD`, `DATA_USAGE_THRESHOLD`, `IP_ADDRESS`, `LAST_KNOWN_LOCATION`, `LAST_KNOWN_NETWORK`, `STATE_MODIFIED_DATE`, `USAGES_NOTIFICATION`, `BSS_ID`, `GOUP_ID`, `LOCK_REFERENCE`, `SIM_POOL_ID`, `WHOLESALE_PLAN_ID`, `PROFILE_STATE`, `EUICC_ID`, `OPERATIONAL_PROFILE_DATA_PLAN`, `BOOTSTRAP_PROFILE`, `CURRENT_IMEI`, `ASSETS_EXTENDED_ID`, `DEVICE_PLAN_ID`, `DEVICE_PLAN_DATE`, `COUNTRIES_ID`, `DONOR_ICCID`) SELECT assets.ID, IFNULL(`assets`.`CREATE_DATE`,NOW()), `assets`.`ACTIVATION_DATE`, `assets`.`APN`, `assets`.`DATA_USAGE_LIMIT`, `assets`.`DEVICE_ID`, `assets`.`DEVICE_IP_ADDRESS`, `assets`.`DYNAMIC_IMSI`, `assets`.`DONOR_IMSI`, `assets`.`ICCID`, `assets`.`IMEI`, `assets`.`IMSI`, IFNULL(`assets`.`IN_SESSION`,0), `assets`.`MODEM_ID`, `assets`.`MSISDN`, `assets`.`SESSION_START_TIME`, `assets`.`SMS_USAGE_LIMIT`, IFNULL(`assets`.`STATE`,'Activated'), IFNULL(`assets`.`STATUS`,'Activated'), `assets`.`VOICE_USAGE_LIMIT`, `assets`.`SUBSCRIBER_NAME`, `assets`.`SUBSCRIBER_LAST_NAME`, IFNULL(`assets`.`SUBSCRIBER_GENDER`,0), `assets`.`SUBSCRIBER_DOB`, `assets`.`ALTERNATE_CONTACT_NUMBER`, `assets`.`SUBSCRIBER_EMAIL`, `assets`.`SUBSCRIBER_ADDRESS`, `assets`.`CUSTOM_PARAM_1`, `assets`.`CUSTOM_PARAM_2`, `assets`.`CUSTOM_PARAM_3`, `assets`.`CUSTOM_PARAM_4`, `assets`.`CUSTOM_PARAM_5`, e.SERVICE_PLAN_ID, `assets`.`LOCATION_COVERAGE_ID`, IFNULL(`assets`.`NEXT_LOCATION_COVERAGE_ID`,0), IFNULL(`assets`.`BILLING_CYCLE`,1), `assets`.`RATE_PLAN_ID`, `assets`.`NEXT_RATE_PLAN_ID`, (SELECT ID FROM accounts WHERE TYPE=3 AND NAME='KSA_OPCO' AND DELETED=0), `b`.`id`, IFNULL(`assets`.`TOTAL_DATA_USAGE`,0), IFNULL(`assets`.`TOTAL_DATA_DOWNLOAD`,0), IFNULL(`assets`.`TOTAL_DATA_UPLOAD`,0), IFNULL(`assets`.`DATA_USAGE_THRESHOLD`,0), `assets`.`IP_ADDRESS`, `assets`.`LAST_KNOWN_LOCATION`, `assets`.`LAST_KNOWN_NETWORK`, IFNULL(`assets`.`STATE_MODIFIED_DATE`,NOW()), IFNULL(`assets`.`USAGES_NOTIFICATION`,0), `assets`.`BSS_ID`, `assets`.`GOUP_ID`, `assets`.`LOCK_REFERENCE`, `assets`.`SIM_POOL_ID`, `assets`.`WHOLESALE_PLAN_ID`, `assets`.`PROFILE_STATE`, `assets`.`EUICC_ID`, `assets`.`OPERATIONAL_PROFILE_DATA_PLAN`, `assets`.`BOOTSTRAP_PROFILE`, `assets`.`CURRENT_IMEI`, `assets`.`ASSETS_EXTENDED_ID`, `d`.`id`, IFNULL(`assets`.`DEVICE_PLAN_DATE`,NOW()), `c`.`ID`, `assets`.`DONOR_ICCID` FROM migration_assets AS assets INNER JOIN accounts AS b ON TRIM(assets.ENT_ACCOUNTID)=b.NOTIFICATION_UUID AND b.DELETED=0 INNER JOIN countries AS c ON TRIM(assets.COUNTRIES_ID)=c.NAME LEFT JOIN device_rate_plan AS d ON TRIM(assets.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID AND d.DELETED=0 LEFT JOIN device_service_plan_mapping as e on e.DEVICE_PLAN_ID=d.id WHERE assets.ID NOT IN (SELECT ID FROM assets);");

PREPARE stmt_1 FROM @insert_assets;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

COMMIT;
SET FOREIGN_KEY_CHECKS=1;

SET @delete_assets_extended = CONCAT("DELETE FROM assets_extended WHERE ID NOT IN (SELECT ASSETS_EXTENDED_ID FROM assets);");

PREPARE stmt_1 FROM @delete_assets_extended;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;

SELECT count(1) INTO @success_count from assets WHERE ID IN (SELECT ID FROM migration_assets);

ELSEIF(@migrationassets=0 AND @migrationassetsextended=0) THEN

SELECT 'No Records Found in migration_assets and migration_assets_extended table' INTO @MESSAGE_TEXT;

SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status,is_completed) SELECT 
DATABASE(),'failure',now(),'",@MESSAGE_TEXT,"',1;");

PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
END IF;

SELECT count(1) INTO @failed_count from migration_assets WHERE ID NOT IN (SELECT ID FROM assets);
SELECT COUNT(1) INTO @after_execution FROM assets;


IF(@after_execution>@before_excution) THEN
SET FOREIGN_KEY_CHECKS=0;



DROP TEMPORARY TABLE IF EXISTS temp_migration_apn_ip_account_list;
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_migration_apn_ip_account_list` (
   id bigint NOT NULL AUTO_INCREMENT,
   account_id bigint DEFAULT NULL,
   apn_id bigint DEFAULT NULL,
   ip_id bigint DEFAULT NULL,
   create_date datetime DEFAULT NULL,
   asset_id  bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO temp_migration_apn_ip_account_list(account_id,apn_id,ip_id,create_date,asset_id)
SELECT distinct b.id as account_id,f.apn_id,f.ID as ip_id,NOW() as create_date,assets.ID as asset_id FROM migration_assets assets INNER JOIN accounts AS b ON TRIM(assets.ENT_ACCOUNTID)=b.NOTIFICATION_UUID AND b.DELETED=0 INNER JOIN device_rate_plan AS d ON TRIM(assets.DEVICE_PLAN_ID)=d.PLAN_NAME AND d.ACCOUNT_ID=b.ID AND d.DELETED=0 INNER JOIN device_plan_to_service_apn_mapping as e on e.DEVICE_PLAN_ID_ID=d.ID INNER JOIN Service_Apn_ip as f on assets.IP_ADDRESS=f.APN_IP;

INSERT INTO service_apn_account_mapping(ACCOUNT_ID,APN_ID,CREATE_DATE)
SELECT distinct account_id,apn_id,create_date FROM temp_migration_apn_ip_account_list WHERE (account_id NOT IN (SELECT ACCOUNT_ID FROM service_apn_account_mapping) AND apn_id NOT IN (SELECT APN_ID FROM service_apn_account_mapping));

INSERT INTO apn_ip_mapping(APN_ID,IP_ID,CREATE_DATE,ASSETS_ID)
SELECT distinct apn_id,ip_id,create_date,asset_id FROM temp_migration_apn_ip_account_list WHERE 
asset_id NOT IN (SELECT DISTINCT ASSETS_ID FROM apn_ip_mapping);

INSERT INTO assets_apn_allocation(ASSETS_ID,APN_ID,CREATE_DATE)
SELECT distinct asset_id,apn_id,create_date FROM temp_migration_apn_ip_account_list WHERE asset_id NOT IN (SELECT DISTINCT ASSETS_ID FROM assets_apn_allocation);

COMMIT;

SET @getsapndet_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct apn_id),0) INTO @sapndet_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getsapndet_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

COMMIT;

SET @updsapndet_list = CONCAT("UPDATE service_apn_details as sad SET sad.status='IN_USE' WHERE sad.ID IN (",@sapndet_list,")  AND (sad.status='NOT_IN_USE' OR sad.status IS NULL);");

PREPARE stmt_1 FROM @updsapndet_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @getspi_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct ip_id),0) INTO @spi_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getspi_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @updgetspi_list = CONCAT("UPDATE Service_Apn_ip as sp SET sp.isUse=1 WHERE sp.ID IN (",@spi_list,")  AND (sp.isUse=0 OR sp.isUse IS NULL)");

PREPARE stmt_1 FROM @updgetspi_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @getdp_list = CONCAT("SELECT IFNULL(GROUP_CONCAT(distinct account_id),0) INTO @dp_list FROM temp_migration_apn_ip_account_list");

PREPARE stmt_1 FROM @getdp_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET @upddp_list = CONCAT("UPDATE device_rate_plan as dp SET dp.STATUS=1 WHERE dp.account_id IN (",@dp_list,") AND (dp.STATUS=0 OR dp.STATUS IS NULL);");

PREPARE stmt_1 FROM @upddp_list;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;

SET FOREIGN_KEY_CHECKS=1;


SET @ai := (select max(id)+1 from assets);
set @qry = concat('alter table assets auto_increment=',@ai);
prepare stmt from @qry; execute stmt;

SET @aiex := (select max(id)+1 from assets_extended);
set @qryex = concat('alter table assets_extended auto_increment=',@aiex);
prepare stmt from @qryex; execute stmt;

COMMIT;

DELETE n1 FROM service_apn_account_mapping n1, service_apn_account_mapping n2 WHERE n1.id < n2.id AND n1.ACCOUNT_ID = n2.ACCOUNT_ID AND n1.APN_ID = n2.APN_ID ;

END IF;

SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) as before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) as after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) as success_count,
CONCAT('failed_count: ',(IFNULL(@ftotal_count,0)-IFNULL(@success_count,0))) as failed_count,
IFNULL(@MESSAGE_TEXT,'') as Remarks;


END//
DELIMITER ;

-- Data exporting was unselected.

-- Dumping structure for procedure cmp_stc_staging.order_shipping_status_bulk_insert
DROP PROCEDURE IF EXISTS `order_shipping_status_bulk_insert`;
DELIMITER //
CREATE PROCEDURE `order_shipping_status_bulk_insert`()
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;
 
 
SELECT COUNT(1) INTO @migration_sim_range FROM `migration_order_shipping_status`;
SELECT COUNT(1) INTO @before_excution FROM `order_shipping_status`;
INSERT INTO `cmp_stc_staging`.`order_shipping_status` (
   ID,
  `updated_date`,  	`shipped_at`,  		`create_date`,  		`target_delivery_date`,
  `extra_metadata`,  	`city`,			`state`,	 		`country_id`,
  `pincode`,  		`shipping_to_address1`, `shipping_to_address2`,  	`shipping_to_name`,
  `shipping_to_mobile`, `shipping_to_phone`,  	`shipping_vendor_details`,  	`shipping_email`
) 
SELECT 
   ID,
  `updated_date`,  	`shipped_at`,  		`create_date`,  		`target_delivery_date`,
  `extra_metadata`,  	`city`,			`state`,	 		`country_id`,
  `pincode`,  		`shipping_to_address1`, `shipping_to_address2`,  	`shipping_to_name`,
  `shipping_to_mobile`, `shipping_to_phone`,  	`shipping_vendor_details`,  	`shipping_email`
 FROM migration_order_shipping_status
;
SELECT COUNT(1) INTO @after_execution FROM order_shipping_status;
SET @ai := (SELECT MAX(id)+1 FROM order_shipping_status);
SET @qry = CONCAT('alter table order_shipping_status auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM order_shipping_status WHERE ID IN (SELECT ID FROM migration_order_shipping_status);
SELECT COUNT(1) INTO @failed_count FROM migration_order_shipping_status WHERE ID NOT IN (SELECT ID FROM order_shipping_status);
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END//
DELIMITER ;

-- Dumping structure for procedure cmp_stc_staging.sim_event_log_bulk_insert
DROP PROCEDURE IF EXISTS `sim_event_log_bulk_insert`;
DELIMITER //
CREATE PROCEDURE `sim_event_log_bulk_insert`()
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;
truncate table `cmp_stc_staging`.`migration_sim_event_log_error_history`;
INSERT INTO `cmp_stc_staging`.`migration_sim_event_log_error_history` (
  `order_id`,		  `account_id`,	  	`sim_type`,	 		 `imsi`,	  	`event`,
  `start_time`,		  `triggered_by`, 	`triggered_user_type`,	  	`completion_time`,	`extra_metadata`,
  `CREATE_DATE`,	  `request_number`,  	`Error_Message`
) 
SELECT
  `order_id`,		  `account_id`,	  	`sim_type`,	 		 `imsi`,	  	`event`,
  `start_time`,		  `triggered_by`, 	`triggered_user_type`,	  	`completion_time`,	`extra_metadata`,
  `CREATE_DATE`,	  `request_number`,  	'Invalid OrderID value'
FROM migration_sim_event_log
WHERE order_id IS NULL OR order_id='';
INSERT INTO `cmp_stc_staging`.`migration_sim_event_log_error_history` (
  `order_id`,		  `account_id`,	  	`sim_type`,	 		 `imsi`,	  	`event`,
  `start_time`,		  `triggered_by`, 	`triggered_user_type`,	  	`completion_time`,	`extra_metadata`,
  `CREATE_DATE`,	  `request_number`,  	`Error_Message`
) 
SELECT
  `order_id`,		  `account_id`,	  	`sim_type`,	 		 `imsi`,	  	`event`,
  `start_time`,		  `triggered_by`, 	`triggered_user_type`,	  	`completion_time`,	`extra_metadata`,
  `CREATE_DATE`,	  `request_number`,  	'Invalid account_id value'
FROM migration_sim_event_log
WHERE account_id IS NULL OR account_id='';
 
SELECT COUNT(1) INTO @migration_sim_range FROM `migration_sim_event_log`;
SELECT COUNT(1) INTO @before_excution FROM `sim_event_log`;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `cmp_stc_staging`.`sim_event_log` (
  `id`,			  	`order_id`,		   `account_id`,		`sim_type`,
  `imsi`,		  	`event`,		   `start_time`,		`triggered_by`,
  `triggered_user_type`,  	`completion_time`,	   `extra_metadata`,	  	`CREATE_DATE`,
  `request_number`
) 
SELECT 
  m1.`id`,		    m1.order_id  AS `order_id`,	    a1.ID AS `account_id`,	  m1.`sim_type`,
  m1.`imsi`,		    	m1.`event`,		    m1.`start_time`,		  m1.`triggered_by`,
  m1.`triggered_user_type`,  	m1.`completion_time`,  	    m1.`extra_metadata`,	  m1.`CREATE_DATE`,
  m1.`request_number` 
FROM
  `cmp_stc_staging`.`migration_sim_event_log` m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=CAST(m1.account_id AS CHAR)
LEFT JOIN `map_user_sim_order` u1 ON u1.order_number =CAST(m1.ORDER_ID AS CHAR)
;
SET FOREIGN_KEY_CHECKS=1;
SELECT COUNT(1) INTO @after_execution FROM sim_event_log;
SET @ai := (SELECT MAX(id)+1 FROM sim_event_log);
SET @qry = CONCAT('alter table sim_event_log auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM sim_event_log WHERE ID IN (SELECT ID FROM migration_sim_event_log);
SELECT COUNT(1) INTO @failed_count FROM migration_sim_event_log WHERE ID NOT IN (SELECT ID FROM sim_event_log);
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END//
DELIMITER ;

-- Dumping structure for procedure cmp_stc_staging.sim_provisioned_range_details
DROP PROCEDURE IF EXISTS `sim_provisioned_range_details`;
DELIMITER //
CREATE PROCEDURE `sim_provisioned_range_details`()
BEGIN
    
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;
TRUNCATE TABLE `stc_migration`.`migration_sim_provisioned_range_details_error_history`;
INSERT INTO `stc_migration`.`migration_sim_provisioned_range_details_error_history` (`ID`,
  `CREATE_DATE`,	  `ICCID`,
  `IMSI`,		  `MSISDN`,
  `DONOR_ICCID`,	  `DONOR_IMSI`,
  `DONOR_MSISDN`,	  `EUICC_ID`,
  `SIM_TYPE`,		  `ALLOCATE_STATUS`,
  `RANGE_ID`,		  `EXT_METADATA`,
  `order_number`,	  `account_id`,
  `Error_Message`
) 
 SELECT 
  `ID`,`CREATE_DATE`,	  `ICCID`,
  `IMSI`,		  `MSISDN`,
  `DONOR_ICCID`,	  `DONOR_IMSI`,
  `DONOR_MSISDN`,	  `EUICC_ID`,
  `SIM_TYPE`,		  `ALLOCATE_STATUS`,
  `RANGE_ID`,		  `EXT_METADATA`,
  `order_number`,	  `account_id`,
  'Invalid CREATE_DATE value' AS Error_Message
 FROM migration_sim_provisioned_range_details
 WHERE CREATE_DATE IS NULL ;
 
 
 
 
SELECT COUNT(1) INTO @migration_sim_range FROM `migration_sim_provisioned_range_details`;
SELECT COUNT(1) INTO @before_excution FROM `sim_provisioned_range_details`;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO sim_provisioned_range_details (`ID`,
  CREATE_DATE,	  ICCID,
  IMSI,		  MSISDN,
  DONOR_ICCID,	  DONOR_IMSI,
  DONOR_MSISDN,	  EUICC_ID,
  SIM_TYPE,	  ALLOCATE_STATUS,
  RANGE_ID,	  EXT_METADATA,
  order_number,	  account_id
) 
SELECT m1.`ID`,
  m1.CREATE_DATE,	  m1.ICCID,
  m1.IMSI,		  m1.MSISDN,
  m1.DONOR_ICCID,	  m1.DONOR_IMSI,
  m1.DONOR_MSISDN,	  m1.EUICC_ID,
  m1.SIM_TYPE,		  m1.ALLOCATE_STATUS,
  m1.RANGE_ID,		  m1.EXT_METADATA,
  m1.order_number,	  a1.id
 FROM migration_sim_provisioned_range_details m1 
 LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=CAST(m1.account_id AS CHAR);
 UPDATE sim_provisioned_range_details a1 INNER JOIN sim_range a2
 SET 	a1.RANGE_ID=a2.id
 WHERE  a1.ICCID BETWEEN a2.ICCID_FROM AND a2.ICCID_TO
 AND a1.RANGE_ID IS NULL;
 
 
 
SET FOREIGN_KEY_CHECKS=1;
SELECT COUNT(1) INTO @after_execution FROM sim_provisioned_range_details;
SET @ai := (SELECT MAX(id)+1 FROM sim_provisioned_range_details);
SET @qry = CONCAT('alter table sim_provisioned_range_details auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM sim_provisioned_range_details WHERE ID IN (SELECT ID FROM migration_sim_provisioned_range_details);
SELECT COUNT(1) INTO @failed_count FROM migration_sim_provisioned_range_details WHERE ID NOT IN (SELECT ID FROM sim_provisioned_range_details);
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    
    END//
DELIMITER ;

-- Dumping structure for procedure cmp_stc_staging.sim_range_procedure_bulk_insert
DROP PROCEDURE IF EXISTS `sim_range_procedure_bulk_insert`;
DELIMITER //
CREATE PROCEDURE `sim_range_procedure_bulk_insert`()
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;


truncate table `cmp_stc_staging`.`migration_sim_range_error_history`;
INSERT INTO `cmp_stc_staging`.`migration_sim_range_error_history` (
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	`Error_Message`
) 
SELECT 
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	'Invalid ACCOUNT_ID value' as Error_Message
 FROM migration_sim_range
 WHERE ACCOUNT_ID IS NULL OR ACCOUNT_ID='';
 
INSERT INTO `cmp_stc_staging`.`migration_sim_range_error_history` (
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	`Error_Message`
) 
SELECT 
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	'Invalid ORDER_ID value' as Error_Message
 FROM `migration_sim_range`
 WHERE ORDER_ID IS NULL OR ORDER_ID='';
 
INSERT INTO `cmp_stc_staging`.`migration_sim_range_error_history` (
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	`Error_Message`
) 
SELECT 
  		  	  `CREATE_DATE`,  	`BATCH_NUMBER`,	  	`ACCOUNT_ID`,
  `ORDER_ID`,		  `NAME`,	  	`DESCRIPTION`,	  	`SIM_START`,
  `SIM_RANGE_FROM`,	  `SIM_RANGE_TO`,	`SIM_TYPE`,		`SIM_COUNT`,
  `SIM_CATEGORY`,	  `ICCID_FROM`,		`ICCID_TO`,		`SENDER`,
  `ALLOCATE_TO`,	  `ALLOCATE_DATE`,	`RANGE_AVAILABLE`,	`IS_NEW`,
  `DELETED`,		  `DELETED_DATE`,	`IMSI_FROM`,		`IMSI_TO`,
  `MSISDN_FROM`,	  `MSISDN_TO`,		`ORDER_NUMBER`,	  	`ICCID_COUNT`,
  `IMSI_COUNT`,		  `MSISDN_COUNT`,	`BILLING_ACCOUNT_ID`,	`STATUS`,
  `TRANSACTION_ID`,	  `EXTRA_METADATA`,	`donor_iccid`,	  	'Invalid BILLING_ACCOUNT_ID value' as Error_Message
 FROM `migration_sim_range`
 WHERE BILLING_ACCOUNT_ID IS NULL OR BILLING_ACCOUNT_ID='';
 
 
 
SELECT COUNT(1) INTO @migration_sim_range FROM `migration_sim_range`;
SELECT COUNT(1) INTO @before_excution FROM `sim_range`;
select max(ID) into @max_sim_id
from sim_range;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `cmp_stc_staging`.`sim_range` (
  `ID`,			  	`CREATE_DATE`,  	`BATCH_NUMBER`,	  		`ACCOUNT_ID`,
  `ORDER_ID`,  		  	`NAME`,  	   	`DESCRIPTION`,	  		`SIM_START`,
  `SIM_RANGE_FROM`,  		`SIM_RANGE_TO`,  	`SIM_TYPE`,  			`SIM_COUNT`,
  `SIM_CATEGORY`,  		`ICCID_FROM`,  		`ICCID_TO`,  			`SENDER`,
  `ALLOCATE_TO`,  		`ALLOCATE_DATE`,  	`RANGE_AVAILABLE`,  		`IS_NEW`,
  `DELETED`,  			`DELETED_DATE`,  	`IMSI_FROM`,  			`IMSI_TO`,
  `MSISDN_FROM`,  		`MSISDN_TO`,  		`ORDER_NUMBER`,  		`ICCID_COUNT`,
  `IMSI_COUNT`,  		`MSISDN_COUNT`,  	`BILLING_ACCOUNT_ID`,   	`STATUS`,
  `TRANSACTION_ID`,  		`EXTRA_METADATA`
) 
SELECT 
  m1.ID,			m1.CREATE_DATE,  	m1.BATCH_NUMBER,		m1.ACCOUNT_ID,
  u1.ID as ORDER_ID,  		m1.NAME,  	   	m1.DESCRIPTION,	  		m1.SIM_START,
  m1.SIM_RANGE_FROM,  		m1.SIM_RANGE_TO,  	m1.SIM_TYPE,  			m1.SIM_COUNT,
  m1.SIM_CATEGORY,  		m1.ICCID_FROM,  	m1.ICCID_TO,  			m1.SENDER,
  a1.ID AS ALLOCATE_TO,  	m1.ALLOCATE_DATE,  	m1.RANGE_AVAILABLE,  		m1.IS_NEW,
  m1.DELETED,  			m1.DELETED_DATE,  	m1.IMSI_FROM,  			m1.IMSI_TO,
  m1.MSISDN_FROM,  		m1.MSISDN_TO,  		m1.ORDER_NUMBER,  		m1.ICCID_COUNT,
  m1.IMSI_COUNT,  		m1.MSISDN_COUNT,  	a1.ID AS Billing_account_id,  	m1.STATUS,
  m1.TRANSACTION_ID,  		m1.EXTRA_METADATA
FROM migration_sim_range m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=cast(m1.Billing_account_id as char)
LEFT JOIN accounts a2 ON  a2.NOTIFICATION_UUID=CAST(m1.ALLOCATE_TO AS CHAR)
LEFT JOIN `map_user_sim_order` u1 ON u1.order_number =CAST(m1.ORDER_ID AS CHAR)
;
 
SET @parent_id=(SELECT id FROM accounts WHERE NAME='KSA_OPCO' limit 1);   
SELECT id into @id_account_extended
FROM account_extended
 WHERE id=(SELECT EXTENDED_ID FROM accounts WHERE id=(SELECT BILLING_ACCOUNT_ID FROM sim_range WHERE id=@max_sim_id)
);

/*UPDATE accounts a1
INNER JOIN account_extended a2 ON a1.EXTENDED_ID = a2.id
INNER JOIN sim_range a3 ON a3.BILLING_ACCOUNT_ID = a1.id 
SET a2.CUSTOM_PARAM_1 = (
    SELECT CONCAT('[', GROUP_CONCAT(
        '{"batchNumber":"', a3.BATCH_NUMBER, '", ',
        '"iccidFrom":"', a3.ICCID_FROM, '", ',
        '"iccidTo":"', a3.ICCID_TO, '", ',
        '"imsiFrom":"', a3.IMSI_FROM, '", ',
        '"imsiTo":"', a3.IMSI_TO, '", ',
        '"iccidCount":"', a3.ICCID_COUNT, '", ',
        '"imsiCount":"', a3.IMSI_COUNT, '"}'
    ), ']')
    FROM sim_range a3
    WHERE a3.BILLING_ACCOUNT_ID = a1.id
) 
WHERE a2.CUSTOM_PARAM_1 IS NULL
AND a1.parent_account_id = @parent_id
AND a2.id > @id_account_extended; */

update accounts a1
INNER JOIN account_extended a2 ON a1.EXTENDED_ID = a2.id
INNER JOIN sim_range a3 ON a3.BILLING_ACCOUNT_ID = a1.id 
left join sim_range a4 on a4.BILLING_ACCOUNT_ID = a1.id
set a2.CUSTOM_PARAM_1=CONCAT('[', GROUP_CONCAT( '{"batchNumber":"', a4.BATCH_NUMBER, '", ', '"iccidFrom":"', a4.ICCID_FROM, '", ', '"iccidTo":"', a4.ICCID_TO, '", ', '"imsiFrom":"', a4.IMSI_FROM, '", ', '"imsiTo":"', a4.IMSI_TO, '", ', '"iccidCount":"', a4.ICCID_COUNT, '", ', '"imsiCount":"', a4.IMSI_COUNT, '"}' ), ']') 
WHERE a2.CUSTOM_PARAM_1 IS NULL AND a1.parent_account_id = @parent_id
AND a2.id > @id_account_extended ;

SET FOREIGN_KEY_CHECKS=1;

SELECT COUNT(1) INTO @after_execution FROM sim_range;

SET @ai := (SELECT MAX(id)+1 FROM sim_range);
SET @sql = CONCAT('ALTER TABLE sim_range AUTO_INCREMENT=', @ai);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
SELECT COUNT(1) INTO @success_count FROM sim_range WHERE ID IN (SELECT ID FROM migration_sim_range);
SELECT COUNT(1) INTO @failed_count FROM migration_sim_range WHERE ID NOT IN (SELECT ID FROM sim_range);
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
	CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
	CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END//
DELIMITER ;

-- Dumping structure for procedure cmp_stc_staging.tag_details
DROP PROCEDURE IF EXISTS `tag_details`;
DELIMITER //
CREATE PROCEDURE `tag_details`()
BEGIN
    
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT DATABASE(), CONCAT(@p1 , @p2) INTO @database, @MESSAGE_TEXT;
SET @error_history = CONCAT("INSERT INTO migration_tracking_history(database_name,query_print,create_date, message_status) SELECT '",@database,"',0, now() ,'",@MESSAGE_TEXT,"';");
SELECT COUNT(1) INTO @before_excution FROM service_plan;
	SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@before_excution,0)) AS after_execution,
	CONCAT('success_count: ',0) AS success_count,
	CONCAT('failed_count: ',0) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks;
	
PREPARE stmt_1 FROM @error_history;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
  ROLLBACK; 
END ;
SET @cntsimtype=NULL;
SET @cntsimcategory=NULL;
SET @cnticcid=NULL;
SET @cntimsi=NULL;
SET @cntmsisdn=NULL;
SET @cntstate=NULL;
SET @cntcountriesid=NULL;
SET @cntdeviceplanid=NULL;
SET @cntentaccountid=NULL;
SET @migrationassetsextended=NULL;
SET @migrationassets=NULL;
SET @before_excution=0;
SET @after_execution=0;
SET @success_count=0;
SET @failed_count_ex=0;
SET @failed_count=0;
SET @MESSAGE_TEXT='';
SET @delete_history='';
SET @Update_history='';
SET @insert_assets_extended='';
SET @insert_assets='';
SET @success_history='';
SET @delete_history = CONCAT("DELETE FROM migration_tracking_history WHERE  create_date < DATE_SUB(DATE(NOW()) ,INTERVAL 15 DAY);");
PREPARE stmt_1 FROM @delete_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
SET @Update_history = CONCAT("Update migration_tracking_history set is_completed=0;");
PREPARE stmt_1 FROM @Update_history;
EXECUTE stmt_1;
DEALLOCATE PREPARE stmt_1;
START TRANSACTION;
TRUNCATE TABLE `migration_tag_error_history`;
INSERT INTO `migration_tag_error_history` (
  `id`,			  `NAME`,
  `notification_uuid`,    `description`,
  `entity_type`,	  `create_date`,
  `deleted`,		  `deleted_date`,
  `imsi`,		  `Error_Message`
) 
SELECT 
  `id`,			  `NAME`,
  `notification_uuid`,    `description`,
  `entity_type`,	  `create_date`,
  `deleted`,		  `deleted_date`,
  `imsi`,		  'Invalid notification_uuid value' AS Error_Message
FROM `migration_tag`
WHERE notification_uuid IS NULL AND notification_uuid='';
INSERT INTO `migration_tag_error_history` (
  `id`,			  `NAME`,
  `notification_uuid`,    `description`,
  `entity_type`,	  `create_date`,
  `deleted`,		  `deleted_date`,
  `imsi`,		  `Error_Message`
) 
SELECT 
  `id`,			  `NAME`,
  `notification_uuid`,    `description`,
  `entity_type`,	  `create_date`,
  `deleted`,		  `deleted_date`,
  `imsi`,		  'Invalid imsi value' AS Error_Message
FROM `migration_tag`
WHERE imsi IS NULL OR imsi='';
SELECT COUNT(1) INTO @migration_tag FROM `migration_tag`;
SELECT COUNT(1) INTO @before_excution_tag FROM `tag`;
INSERT INTO `tag` (
  `id`,			  `name`,
  `color_coding`,	  `account_id`,
  `description`,	  `entity_type`,
  `create_date`,	  `deleted`,
  `deleted_date`
) 
SELECT 
  m1.`id`,			m1.`name`,
  m1.`color_coding`,	 	a1.ID AS account_id,
  m1.`description`,	  	m1.`entity_type`,
  m1.`create_date`,	  	m1.`deleted`,
  m1.`deleted_date`
FROM `migration_tag` m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=m1.notification_uuid 
;
SELECT COUNT(1) INTO @before_excution_tag_entity FROM `tag_entity`;
INSERT INTO `cmp_stc_staging`.`tag_entity` (
  `entity_type`,	  	`account_id`,
  `tag_id`,		  	`entity_id`,
  `ext_metadata`,	 	`create_date`
) 
SELECT
m1.`entity_type`,		a1.ID AS account_id,
m1.`id` AS tag_id,		a2.ID AS entity_id,
NULL AS ext_metadata,   	m1.create_date
FROM `migration_tag` m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=m1.notification_uuid 
LEFT JOIN assets a2   ON   a2.IMSI=m1.imsi
;
SELECT COUNT(1) INTO @after_execution_tag FROM tag;
SELECT COUNT(1) INTO @after_execution_tag_entity FROM tag_entity;
SET @ai := (SELECT IFNULL(MAX(id),0)+1 FROM tag);
SET @qry = CONCAT('alter table tag auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM tag WHERE ID IN (SELECT ID FROM migration_tag);
SELECT COUNT(1) INTO @failed_count FROM migration_tag WHERE ID NOT IN (SELECT ID FROM tag);
SELECT  CONCAT('before_excution: ',IFNULL(@before_excution_tag,0)) AS before_excution,
	CONCAT('after_execution: ',IFNULL(@after_execution_tag,0)) AS after_execution,
	CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
	CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
	IFNULL(@MESSAGE_TEXT,'') AS Remarks
;
SELECT CONCAT('before_excution: ',IFNULL(@before_excution_tag_entity,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution_tag_entity,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END//
DELIMITER ;

SET FOREIGN_KEY_CHECKS=1;