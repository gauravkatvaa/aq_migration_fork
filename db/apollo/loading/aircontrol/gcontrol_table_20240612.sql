SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `migration_assets` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ACTIVATION_DATE` datetime DEFAULT NULL,
  `APN` varchar(255) DEFAULT NULL,
  `DATA_USAGE_LIMIT` bigint DEFAULT NULL,
  `DEVICE_ID` varchar(255) DEFAULT NULL,
  `DEVICE_IP_ADDRESS` varchar(255) DEFAULT NULL,
  `DYNAMIC_IMSI` varchar(255) DEFAULT NULL,
  `DONOR_IMSI` varchar(255) DEFAULT NULL,
  `ICCID` varchar(25) DEFAULT NULL,
  `IMEI` varchar(20) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `IN_SESSION` tinyint(1) DEFAULT '0',
  `MODEM_ID` varchar(255) DEFAULT NULL,
  `MSISDN` varchar(20) DEFAULT NULL,
  `SESSION_START_TIME` varchar(255) DEFAULT NULL,
  `SMS_USAGE_LIMIT` bigint DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `VOICE_USAGE_LIMIT` bigint DEFAULT NULL,
  `SUBSCRIBER_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_LAST_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_GENDER` tinyint DEFAULT 0,
  `SUBSCRIBER_DOB` varchar(50) DEFAULT NULL,
  `ALTERNATE_CONTACT_NUMBER` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_EMAIL` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_ADDRESS` varchar(556) DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(255) DEFAULT NULL,
  `SERVICE_PLAN_ID` bigint DEFAULT NULL,
  `LOCATION_COVERAGE_ID` bigint DEFAULT NULL,
  `NEXT_LOCATION_COVERAGE_ID` bigint DEFAULT '0',
  `BILLING_CYCLE` bigint DEFAULT NULL,
  `RATE_PLAN_ID` bigint DEFAULT NULL,
  `NEXT_RATE_PLAN_ID` bigint DEFAULT NULL,
  `MNO_ACCOUNTID` bigint DEFAULT NULL,
  `ENT_ACCOUNTID` varchar(255) DEFAULT NULL,
  `TOTAL_DATA_USAGE` double DEFAULT '0',
  `TOTAL_DATA_DOWNLOAD` bigint DEFAULT '0',
  `TOTAL_DATA_UPLOAD` bigint DEFAULT '0',
  `DATA_USAGE_THRESHOLD` bigint DEFAULT '0',
  `IP_ADDRESS` varchar(20) NOT NULL DEFAULT '000.000.000.000',
  `LAST_KNOWN_LOCATION` varchar(100) DEFAULT NULL,
  `LAST_KNOWN_NETWORK` varchar(100) DEFAULT NULL,
  `STATE_MODIFIED_DATE` datetime DEFAULT NULL,
  `USAGES_NOTIFICATION` tinyint(1) DEFAULT '0',
  `BSS_ID` bigint DEFAULT NULL,
  `GOUP_ID` bigint DEFAULT NULL,
  `LOCK_REFERENCE` varchar(25) DEFAULT NULL,
  `SIM_POOL_ID` bigint DEFAULT NULL,
  `WHOLESALE_PLAN_ID` bigint DEFAULT NULL,
  `PROFILE_STATE` varchar(25) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `OPERATIONAL_PROFILE_DATA_PLAN` varchar(255) DEFAULT NULL,
  `BOOTSTRAP_PROFILE` int DEFAULT NULL,
  `CURRENT_IMEI` varchar(20) DEFAULT NULL,
  `ASSETS_EXTENDED_ID` bigint DEFAULT NULL,
  `DEVICE_PLAN_ID` varchar(255) DEFAULT NULL,
  `DEVICE_PLAN_DATE` timestamp NULL DEFAULT NULL,
  `COUNTRIES_ID` varchar(255) DEFAULT NULL,
  `DONOR_ICCID` varchar(255) DEFAULT NULL COMMENT 'For handling luhn digit concept storing iccid',
   PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `migration_assets_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ACTIVATION_DATE` datetime DEFAULT NULL,
  `APN` varchar(255) DEFAULT NULL,
  `DATA_USAGE_LIMIT` bigint DEFAULT NULL,
  `DEVICE_ID` varchar(255) DEFAULT NULL,
  `DEVICE_IP_ADDRESS` varchar(255) DEFAULT NULL,
  `DYNAMIC_IMSI` varchar(255) DEFAULT NULL,
  `DONOR_IMSI` varchar(255) DEFAULT NULL,
  `ICCID` varchar(25) DEFAULT NULL,
  `IMEI` varchar(20) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `IN_SESSION` tinyint(1) DEFAULT '0',
  `MODEM_ID` varchar(255) DEFAULT NULL,
  `MSISDN` varchar(20) DEFAULT NULL,
  `SESSION_START_TIME` varchar(255) DEFAULT NULL,
  `SMS_USAGE_LIMIT` bigint DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `VOICE_USAGE_LIMIT` bigint DEFAULT NULL,
  `SUBSCRIBER_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_LAST_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_GENDER` tinyint DEFAULT 0,
  `SUBSCRIBER_DOB` varchar(50) DEFAULT NULL,
  `ALTERNATE_CONTACT_NUMBER` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_EMAIL` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_ADDRESS` varchar(556) DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(255) DEFAULT NULL,
  `SERVICE_PLAN_ID` bigint DEFAULT NULL,
  `LOCATION_COVERAGE_ID` bigint DEFAULT NULL,
  `NEXT_LOCATION_COVERAGE_ID` bigint DEFAULT '0',
  `BILLING_CYCLE` bigint DEFAULT NULL,
  `RATE_PLAN_ID` bigint DEFAULT NULL,
  `NEXT_RATE_PLAN_ID` bigint DEFAULT NULL,
  `MNO_ACCOUNTID` bigint DEFAULT NULL,
  `ENT_ACCOUNTID` varchar(255) DEFAULT NULL,
  `TOTAL_DATA_USAGE` double DEFAULT '0',
  `TOTAL_DATA_DOWNLOAD` bigint DEFAULT '0',
  `TOTAL_DATA_UPLOAD` bigint DEFAULT '0',
  `DATA_USAGE_THRESHOLD` bigint DEFAULT '0',
  `IP_ADDRESS` varchar(20) NOT NULL DEFAULT '000.000.000.000',
  `LAST_KNOWN_LOCATION` varchar(100) DEFAULT NULL,
  `LAST_KNOWN_NETWORK` varchar(100) DEFAULT NULL,
  `STATE_MODIFIED_DATE` datetime DEFAULT NULL,
  `USAGES_NOTIFICATION` tinyint(1) DEFAULT '0',
  `BSS_ID` bigint DEFAULT NULL,
  `GOUP_ID` bigint DEFAULT NULL,
  `LOCK_REFERENCE` varchar(25) DEFAULT NULL,
  `SIM_POOL_ID` bigint DEFAULT NULL,
  `WHOLESALE_PLAN_ID` bigint DEFAULT NULL,
  `PROFILE_STATE` varchar(25) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `OPERATIONAL_PROFILE_DATA_PLAN` varchar(255) DEFAULT NULL,
  `BOOTSTRAP_PROFILE` int DEFAULT NULL,
  `CURRENT_IMEI` varchar(20) DEFAULT NULL,
  `ASSETS_EXTENDED_ID` bigint DEFAULT NULL,
  `DEVICE_PLAN_ID` varchar(255) DEFAULT NULL,
  `DEVICE_PLAN_DATE` timestamp NULL DEFAULT NULL,
  `COUNTRIES_ID` varchar(255) DEFAULT NULL,
  `DONOR_ICCID` varchar(255) DEFAULT NULL COMMENT 'For handling luhn digit storing iccid',
  `Error_Message` text DEFAULT NULL ,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ;



CREATE TABLE IF NOT EXISTS `migration_assets_extended` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `voice_template` int DEFAULT NULL,
  `sms_template` int DEFAULT NULL,
  `data_template` int DEFAULT NULL,
  `sim_type_id` int DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `SERVICE_GRANT` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `IMEI_LOCK` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `OLD_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `CURRENT_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `custom_param_1` varchar(96) DEFAULT NULL,
  `custom_param_2` varchar(96) DEFAULT NULL,
  `custom_param_3` varchar(96) DEFAULT NULL,
  `custom_param_4` varchar(96) DEFAULT NULL,
  `custom_param_5` varchar(96) DEFAULT NULL,
  `BULK_SERVICE_NAME` json DEFAULT NULL,
  `FVS_DATA` json DEFAULT NULL COMMENT 'To Store FVS JSON DATA',
  `sim_category` varchar(56) DEFAULT NULL COMMENT 'stores value sim_category(830,831,05X)',
  `lock_by_user` varchar(256) DEFAULT NULL,
  `imei_lock_setup_date` datetime DEFAULT NULL,
  `imei_lock_disable_date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB; 

CREATE TABLE IF NOT EXISTS `migration_assets_extended_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `voice_template` int DEFAULT NULL,
  `sms_template` int DEFAULT NULL,
  `data_template` int DEFAULT NULL,
  `sim_type_id` int DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `SERVICE_GRANT` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `IMEI_LOCK` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `OLD_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `CURRENT_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `custom_param_1` varchar(96) DEFAULT NULL,
  `custom_param_2` varchar(96) DEFAULT NULL,
  `custom_param_3` varchar(96) DEFAULT NULL,
  `custom_param_4` varchar(96) DEFAULT NULL,
  `custom_param_5` varchar(96) DEFAULT NULL,
  `BULK_SERVICE_NAME` json DEFAULT NULL,
  `FVS_DATA` json DEFAULT NULL COMMENT 'To Store FVS JSON DATA',
  `sim_category` varchar(56) DEFAULT NULL COMMENT 'stores value sim_category(830,831,05X)',
  `lock_by_user` varchar(256) DEFAULT NULL,
  `imei_lock_setup_date` datetime DEFAULT NULL,
  `imei_lock_disable_date` datetime DEFAULT NULL,
  `Error_Message` text DEFAULT NULL ,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB; 

CREATE TABLE IF NOT EXISTS `migration_tracking_history` (
   `id` int NOT NULL AUTO_INCREMENT,
   `database_name` varchar(128) DEFAULT '0',
   `table_name` varchar(128) DEFAULT '0',
   `message_status` text DEFAULT NULL,
   `query_print` text DEFAULT NULL,
    is_completed tinyint(1) DEFAULT 0,
   `create_date` datetime DEFAULT now(),
   PRIMARY KEY (`id`)
 ) ENGINE=InnoDB COMMENT='This table is used for mantaine Error_handling history';
 
 
 
 ALTER TABLE migration_assets MODIFY COLUMN NEXT_LOCATION_COVERAGE_ID bigint DEFAULT 0;
 ALTER TABLE migration_assets_error_history MODIFY COLUMN NEXT_LOCATION_COVERAGE_ID bigint DEFAULT 0;
 
 
 
-- Dumping structure for table cmp_stc_staging.migration_assets
DROP TABLE IF EXISTS `migration_assets`;
CREATE TABLE IF NOT EXISTS `migration_assets` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ACTIVATION_DATE` datetime DEFAULT NULL,
  `APN` varchar(255) DEFAULT NULL,
  `DATA_USAGE_LIMIT` bigint DEFAULT NULL,
  `DEVICE_ID` varchar(255) DEFAULT NULL,
  `DEVICE_IP_ADDRESS` varchar(255) DEFAULT NULL,
  `DYNAMIC_IMSI` varchar(255) DEFAULT NULL,
  `DONOR_IMSI` varchar(255) DEFAULT NULL,
  `ICCID` varchar(25) DEFAULT NULL,
  `IMEI` varchar(20) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `IN_SESSION` tinyint(1) DEFAULT '0',
  `MODEM_ID` varchar(255) DEFAULT NULL,
  `MSISDN` varchar(20) DEFAULT NULL,
  `SESSION_START_TIME` varchar(255) DEFAULT NULL,
  `SMS_USAGE_LIMIT` bigint DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `VOICE_USAGE_LIMIT` bigint DEFAULT NULL,
  `SUBSCRIBER_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_LAST_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_GENDER` tinyint DEFAULT '0',
  `SUBSCRIBER_DOB` varchar(50) DEFAULT NULL,
  `ALTERNATE_CONTACT_NUMBER` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_EMAIL` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_ADDRESS` varchar(556) DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(255) DEFAULT NULL,
  `SERVICE_PLAN_ID` bigint DEFAULT NULL,
  `LOCATION_COVERAGE_ID` bigint DEFAULT NULL,
  `NEXT_LOCATION_COVERAGE_ID` bigint DEFAULT '0',
  `BILLING_CYCLE` bigint DEFAULT NULL,
  `RATE_PLAN_ID` bigint DEFAULT NULL,
  `NEXT_RATE_PLAN_ID` bigint DEFAULT NULL,
  `MNO_ACCOUNTID` bigint DEFAULT NULL,
  `ENT_ACCOUNTID` varchar(255) DEFAULT NULL,
  `TOTAL_DATA_USAGE` double DEFAULT '0',
  `TOTAL_DATA_DOWNLOAD` bigint DEFAULT '0',
  `TOTAL_DATA_UPLOAD` bigint DEFAULT '0',
  `DATA_USAGE_THRESHOLD` bigint DEFAULT '0',
  `IP_ADDRESS` varchar(20) NOT NULL DEFAULT '000.000.000.000',
  `LAST_KNOWN_LOCATION` varchar(100) DEFAULT NULL,
  `LAST_KNOWN_NETWORK` varchar(100) DEFAULT NULL,
  `STATE_MODIFIED_DATE` datetime DEFAULT NULL,
  `USAGES_NOTIFICATION` tinyint(1) DEFAULT '0',
  `BSS_ID` bigint DEFAULT NULL,
  `GOUP_ID` bigint DEFAULT NULL,
  `LOCK_REFERENCE` varchar(25) DEFAULT NULL,
  `SIM_POOL_ID` bigint DEFAULT NULL,
  `WHOLESALE_PLAN_ID` bigint DEFAULT NULL,
  `PROFILE_STATE` varchar(25) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `OPERATIONAL_PROFILE_DATA_PLAN` varchar(255) DEFAULT NULL,
  `BOOTSTRAP_PROFILE` int DEFAULT NULL,
  `CURRENT_IMEI` varchar(20) DEFAULT NULL,
  `ASSETS_EXTENDED_ID` bigint DEFAULT NULL,
  `DEVICE_PLAN_ID` varchar(255) DEFAULT NULL,
  `DEVICE_PLAN_DATE` timestamp NULL DEFAULT NULL,
  `COUNTRIES_ID` varchar(255) DEFAULT NULL,
  `DONOR_ICCID` varchar(255) DEFAULT NULL COMMENT 'For handling luhn digit concept storing iccid',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_assets_error_history
DROP TABLE IF EXISTS `migration_assets_error_history`;
CREATE TABLE IF NOT EXISTS `migration_assets_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ACTIVATION_DATE` datetime DEFAULT NULL,
  `APN` varchar(255) DEFAULT NULL,
  `DATA_USAGE_LIMIT` bigint DEFAULT NULL,
  `DEVICE_ID` varchar(255) DEFAULT NULL,
  `DEVICE_IP_ADDRESS` varchar(255) DEFAULT NULL,
  `DYNAMIC_IMSI` varchar(255) DEFAULT NULL,
  `DONOR_IMSI` varchar(255) DEFAULT NULL,
  `ICCID` varchar(25) DEFAULT NULL,
  `IMEI` varchar(20) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `IN_SESSION` tinyint(1) DEFAULT '0',
  `MODEM_ID` varchar(255) DEFAULT NULL,
  `MSISDN` varchar(20) DEFAULT NULL,
  `SESSION_START_TIME` varchar(255) DEFAULT NULL,
  `SMS_USAGE_LIMIT` bigint DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `VOICE_USAGE_LIMIT` bigint DEFAULT NULL,
  `SUBSCRIBER_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_LAST_NAME` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_GENDER` tinyint DEFAULT '0',
  `SUBSCRIBER_DOB` varchar(50) DEFAULT NULL,
  `ALTERNATE_CONTACT_NUMBER` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_EMAIL` varchar(50) DEFAULT NULL,
  `SUBSCRIBER_ADDRESS` varchar(556) DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(255) DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(255) DEFAULT NULL,
  `SERVICE_PLAN_ID` bigint DEFAULT NULL,
  `LOCATION_COVERAGE_ID` bigint DEFAULT NULL,
  `NEXT_LOCATION_COVERAGE_ID` bigint DEFAULT '0',
  `BILLING_CYCLE` bigint DEFAULT NULL,
  `RATE_PLAN_ID` bigint DEFAULT NULL,
  `NEXT_RATE_PLAN_ID` bigint DEFAULT NULL,
  `MNO_ACCOUNTID` bigint DEFAULT NULL,
  `ENT_ACCOUNTID` varchar(255) DEFAULT NULL,
  `TOTAL_DATA_USAGE` double DEFAULT '0',
  `TOTAL_DATA_DOWNLOAD` bigint DEFAULT '0',
  `TOTAL_DATA_UPLOAD` bigint DEFAULT '0',
  `DATA_USAGE_THRESHOLD` bigint DEFAULT '0',
  `IP_ADDRESS` varchar(20) NOT NULL DEFAULT '000.000.000.000',
  `LAST_KNOWN_LOCATION` varchar(100) DEFAULT NULL,
  `LAST_KNOWN_NETWORK` varchar(100) DEFAULT NULL,
  `STATE_MODIFIED_DATE` datetime DEFAULT NULL,
  `USAGES_NOTIFICATION` tinyint(1) DEFAULT '0',
  `BSS_ID` bigint DEFAULT NULL,
  `GOUP_ID` bigint DEFAULT NULL,
  `LOCK_REFERENCE` varchar(25) DEFAULT NULL,
  `SIM_POOL_ID` bigint DEFAULT NULL,
  `WHOLESALE_PLAN_ID` bigint DEFAULT NULL,
  `PROFILE_STATE` varchar(25) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `OPERATIONAL_PROFILE_DATA_PLAN` varchar(255) DEFAULT NULL,
  `BOOTSTRAP_PROFILE` int DEFAULT NULL,
  `CURRENT_IMEI` varchar(20) DEFAULT NULL,
  `ASSETS_EXTENDED_ID` bigint DEFAULT NULL,
  `DEVICE_PLAN_ID` varchar(255) DEFAULT NULL,
  `DEVICE_PLAN_DATE` timestamp NULL DEFAULT NULL,
  `COUNTRIES_ID` varchar(255) DEFAULT NULL,
  `DONOR_ICCID` varchar(255) DEFAULT NULL COMMENT 'For handling luhn digit storing iccid',
  `Error_Message` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_assets_extended
DROP TABLE IF EXISTS `migration_assets_extended`;
CREATE TABLE IF NOT EXISTS `migration_assets_extended` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `voice_template` int DEFAULT NULL,
  `sms_template` int DEFAULT NULL,
  `data_template` int DEFAULT NULL,
  `sim_type_id` int DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `SERVICE_GRANT` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `IMEI_LOCK` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `OLD_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `CURRENT_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `custom_param_1` varchar(96) DEFAULT NULL,
  `custom_param_2` varchar(96) DEFAULT NULL,
  `custom_param_3` varchar(96) DEFAULT NULL,
  `custom_param_4` varchar(96) DEFAULT NULL,
  `custom_param_5` varchar(96) DEFAULT NULL,
  `BULK_SERVICE_NAME` json DEFAULT NULL,
  `FVS_DATA` json DEFAULT NULL COMMENT 'To Store FVS JSON DATA',
  `sim_category` varchar(56) DEFAULT NULL COMMENT 'stores value sim_category(830,831,05X)',
  `lock_by_user` varchar(256) DEFAULT NULL,
  `imei_lock_setup_date` datetime DEFAULT NULL,
  `imei_lock_disable_date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_assets_extended_error_history
DROP TABLE IF EXISTS `migration_assets_extended_error_history`;
CREATE TABLE IF NOT EXISTS `migration_assets_extended_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `voice_template` int DEFAULT NULL,
  `sms_template` int DEFAULT NULL,
  `data_template` int DEFAULT NULL,
  `sim_type_id` int DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `SERVICE_GRANT` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `IMEI_LOCK` tinyint DEFAULT '0' COMMENT '0 is No and 1 is Yes',
  `OLD_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `CURRENT_PROFILE_STATE` varchar(56) DEFAULT NULL,
  `custom_param_1` varchar(96) DEFAULT NULL,
  `custom_param_2` varchar(96) DEFAULT NULL,
  `custom_param_3` varchar(96) DEFAULT NULL,
  `custom_param_4` varchar(96) DEFAULT NULL,
  `custom_param_5` varchar(96) DEFAULT NULL,
  `BULK_SERVICE_NAME` json DEFAULT NULL,
  `FVS_DATA` json DEFAULT NULL COMMENT 'To Store FVS JSON DATA',
  `sim_category` varchar(56) DEFAULT NULL COMMENT 'stores value sim_category(830,831,05X)',
  `lock_by_user` varchar(256) DEFAULT NULL,
  `imei_lock_setup_date` datetime DEFAULT NULL,
  `imei_lock_disable_date` datetime DEFAULT NULL,
  `Error_Message` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_map_user_sim_order
DROP TABLE IF EXISTS `migration_map_user_sim_order`;
CREATE TABLE IF NOT EXISTS `migration_map_user_sim_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordered_by` bigint DEFAULT NULL,
  `status_updated_date` datetime DEFAULT NULL,
  `sim_category_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `final_price` double DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `order_number` varchar(200)  DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `order_status` varchar(100)  DEFAULT 'New',
  `quantity` int DEFAULT '0',
  `per_unit_price` double DEFAULT NULL,
  `order_shipping_id` bigint DEFAULT NULL,
  `is_standard` int DEFAULT NULL,
  `is_express` int DEFAULT NULL,
  `order_sim_category` varchar(50)  DEFAULT NULL,
  `auto_activation` tinyint DEFAULT '0',
  `data_plan_id` bigint DEFAULT NULL,
  `service_plan_id` bigint DEFAULT NULL,
  `REMARKS` varchar(4056)  DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(56)  DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(56)  DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(256)  DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(256)  DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(56)  DEFAULT NULL COMMENT 'Store value sim state information',
  `CUSTOM_PARAM_6` int DEFAULT NULL,
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `TERMS_CONDITIONS` tinyint DEFAULT '0',
  `IS_BLANK_SIM` tinyint(1) DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL COMMENT 'to hold order failure case while creating order',
  `awb_number` bigint DEFAULT NULL,
  `isOrderSentInSheet` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sim_category_id` (`sim_category_id`),
  KEY `ordered_by` (`ordered_by`),
  KEY `order_shipping` (`order_shipping_id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_map_user_sim_order_error_history
DROP TABLE IF EXISTS `migration_map_user_sim_order_error_history`;
CREATE TABLE IF NOT EXISTS `migration_map_user_sim_order_error_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordered_by` bigint DEFAULT NULL,
  `status_updated_date` datetime DEFAULT NULL,
  `sim_category_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `final_price` double DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `order_number` varchar(200)  DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `order_status` varchar(100)  DEFAULT 'New',
  `quantity` int DEFAULT '0',
  `per_unit_price` double DEFAULT NULL,
  `order_shipping_id` bigint DEFAULT NULL,
  `is_standard` int DEFAULT NULL,
  `is_express` int DEFAULT NULL,
  `order_sim_category` varchar(50)  DEFAULT NULL,
  `auto_activation` tinyint DEFAULT '0',
  `data_plan_id` bigint DEFAULT NULL,
  `service_plan_id` bigint DEFAULT NULL,
  `REMARKS` varchar(4056)  DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(56)  DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(56)  DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(256)  DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(256)  DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(56)  DEFAULT NULL COMMENT 'Store value sim state information',
  `CUSTOM_PARAM_6` int DEFAULT NULL,
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `TERMS_CONDITIONS` tinyint DEFAULT '0',
  `IS_BLANK_SIM` tinyint(1) DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL COMMENT 'to hold order failure case while creating order',
  `awb_number` bigint DEFAULT NULL,
  `isOrderSentInSheet` tinyint DEFAULT NULL,
  `Error_Message` text ,
  PRIMARY KEY (`id`),
  KEY `sim_category_id` (`sim_category_id`),
  KEY `ordered_by` (`ordered_by`),
  KEY `order_shipping` (`order_shipping_id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.
-- Dumping structure for table cmp_stc_staging.migration_order_shipping_status
DROP TABLE IF EXISTS `migration_order_shipping_status`;
CREATE TABLE IF NOT EXISTS `migration_order_shipping_status` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordernumber` varchar(32)  DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `target_delivery_date` datetime DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `city` varchar(255)  DEFAULT NULL,
  `state` varchar(255)  DEFAULT NULL,
  `country_id` bigint DEFAULT NULL,
  `pincode` int DEFAULT NULL,
  `shipping_to_address1` varchar(556)  DEFAULT NULL,
  `shipping_to_address2` varchar(556)  DEFAULT NULL,
  `shipping_to_name` varchar(255)  DEFAULT NULL,
  `shipping_to_mobile` varchar(100)  DEFAULT NULL,
  `shipping_to_phone` varchar(100)  DEFAULT NULL,
  `shipping_vendor_details` text ,
  `shipping_email` varchar(255)  DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ordernumber` (`ordernumber`)
) ENGINE=InnoDB;



-- Dumping structure for table cmp_stc_staging.migration_sim_event_log
DROP TABLE IF EXISTS `migration_sim_event_log`;
CREATE TABLE IF NOT EXISTS `migration_sim_event_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'this table is to capture events for SIM',
  `order_id` bigint DEFAULT NULL COMMENT 'order id of sim',
  `account_id` bigint DEFAULT NULL COMMENT 'account id ',
  `sim_type` int DEFAULT NULL COMMENT 'type of sim',
  `imsi` varchar(20)  DEFAULT NULL,
  `event` varchar(45)  DEFAULT NULL COMMENT 'event name',
  `start_time` datetime DEFAULT NULL COMMENT 'start timr ',
  `triggered_by` varchar(128)  DEFAULT NULL COMMENT 'to whom triggered by',
  `triggered_user_type` int DEFAULT NULL COMMENT 'type of user from which it is triggered',
  `completion_time` datetime DEFAULT NULL COMMENT 'complrtion type',
  `extra_metadata` json DEFAULT NULL COMMENT 'json type column in which extra column vakus are stored',
  `CREATE_DATE` datetime DEFAULT NULL,
  `request_number` varchar(56)  DEFAULT NULL COMMENT 'store request number for penalty exemption',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.


-- Dumping structure for table cmp_stc_staging.migration_sim_event_log_error_history
DROP TABLE IF EXISTS `migration_sim_event_log_error_history`;
CREATE TABLE IF NOT EXISTS `migration_sim_event_log_error_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'this table is to capture events for SIM',
  `order_id` bigint DEFAULT NULL COMMENT 'order id of sim',
  `account_id` bigint DEFAULT NULL COMMENT 'account id ',
  `sim_type` int DEFAULT NULL COMMENT 'type of sim',
  `imsi` varchar(20)  DEFAULT NULL,
  `event` varchar(45)  DEFAULT NULL COMMENT 'event name',
  `start_time` datetime DEFAULT NULL COMMENT 'start timr ',
  `triggered_by` varchar(128)  DEFAULT NULL COMMENT 'to whom triggered by',
  `triggered_user_type` int DEFAULT NULL COMMENT 'type of user from which it is triggered',
  `completion_time` datetime DEFAULT NULL COMMENT 'complrtion type',
  `extra_metadata` json DEFAULT NULL COMMENT 'json type column in which extra column vakus are stored',
  `CREATE_DATE` datetime DEFAULT NULL,
  `request_number` varchar(56)  DEFAULT NULL COMMENT 'store request number for penalty exemption',
  `Error_Message` varchar(1024)  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_sim_provisioned_range_details
DROP TABLE IF EXISTS `migration_sim_provisioned_range_details`;
CREATE TABLE IF NOT EXISTS `migration_sim_provisioned_range_details` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ICCID` varchar(32) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `MSISDN` varchar(15) DEFAULT NULL,
  `DONOR_ICCID` varchar(32) DEFAULT NULL,
  `DONOR_IMSI` varchar(15) DEFAULT NULL,
  `DONOR_MSISDN` varchar(15) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `SIM_TYPE` tinyint DEFAULT NULL,
  `ALLOCATE_STATUS` char(1) DEFAULT NULL COMMENT 'A- ASSIGN , U- UNASSIGN ,N- NEW>> ALLOCATE_STATUS',
  `RANGE_ID` int DEFAULT NULL COMMENT 'table sim_range used primary key',
  `EXT_METADATA` json DEFAULT NULL,
  `order_number` varchar(50) DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ICCID_UNIQUE` (`ICCID`),
  UNIQUE KEY `IMSI_UNIQUE` (`IMSI`),
  UNIQUE KEY `DONOR_IMSI_UNIQUE` (`DONOR_ICCID`),
  UNIQUE KEY `EUICC_ID_UNIQUE` (`EUICC_ID`)
) ENGINE=InnoDB  ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_sim_provisioned_range_details_error_history
DROP TABLE IF EXISTS `migration_sim_provisioned_range_details_error_history`;
CREATE TABLE IF NOT EXISTS `migration_sim_provisioned_range_details_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ICCID` varchar(32) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `MSISDN` varchar(15) DEFAULT NULL,
  `DONOR_ICCID` varchar(32) DEFAULT NULL,
  `DONOR_IMSI` varchar(15) DEFAULT NULL,
  `DONOR_MSISDN` varchar(15) DEFAULT NULL,
  `EUICC_ID` varchar(255) DEFAULT NULL,
  `SIM_TYPE` tinyint DEFAULT NULL,
  `ALLOCATE_STATUS` char(1) DEFAULT NULL COMMENT 'A- ASSIGN , U- UNASSIGN ,N- NEW>> ALLOCATE_STATUS',
  `RANGE_ID` int DEFAULT NULL COMMENT 'table sim_range used primary key',
  `EXT_METADATA` json DEFAULT NULL,
  `order_number` varchar(50) DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `Error_Message` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ICCID_UNIQUE` (`ICCID`),
  UNIQUE KEY `IMSI_UNIQUE` (`IMSI`),
  UNIQUE KEY `DONOR_IMSI_UNIQUE` (`DONOR_ICCID`),
  UNIQUE KEY `EUICC_ID_UNIQUE` (`EUICC_ID`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_sim_range
DROP TABLE IF EXISTS `migration_sim_range`;
CREATE TABLE IF NOT EXISTS `migration_sim_range` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256)  DEFAULT NULL,
  `DESCRIPTION` text ,
  `SIM_START` varchar(64)  DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64)  DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64)  DEFAULT NULL,
  `SIM_TYPE` varchar(64)  DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64)  DEFAULT NULL,
  `ICCID_FROM` varchar(64)  DEFAULT NULL,
  `ICCID_TO` varchar(64)  DEFAULT NULL,
  `SENDER` varchar(256)  DEFAULT NULL,
  `ALLOCATE_TO` varchar(256)  DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64)  DEFAULT NULL,
  `IMSI_TO` varchar(64)  DEFAULT NULL,
  `MSISDN_FROM` varchar(64)  DEFAULT NULL,
  `MSISDN_TO` varchar(64)  DEFAULT NULL,
  `ORDER_NUMBER` varchar(200)  DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15)  DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  `donor_iccid` varchar(32)  DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_sim_range_error_history
DROP TABLE IF EXISTS `migration_sim_range_error_history`;
CREATE TABLE IF NOT EXISTS `migration_sim_range_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256)  DEFAULT NULL,
  `DESCRIPTION` text ,
  `SIM_START` varchar(64)  DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64)  DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64)  DEFAULT NULL,
  `SIM_TYPE` varchar(64)  DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64)  DEFAULT NULL,
  `ICCID_FROM` varchar(64)  DEFAULT NULL,
  `ICCID_TO` varchar(64)  DEFAULT NULL,
  `SENDER` varchar(256)  DEFAULT NULL,
  `ALLOCATE_TO` varchar(256)  DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64)  DEFAULT NULL,
  `IMSI_TO` varchar(64)  DEFAULT NULL,
  `MSISDN_FROM` varchar(64)  DEFAULT NULL,
  `MSISDN_TO` varchar(64)  DEFAULT NULL,
  `ORDER_NUMBER` varchar(200)  DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15)  DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  `donor_iccid` varchar(32)  DEFAULT NULL,
  `Error_Message` varchar(1024)  DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_tag
DROP TABLE IF EXISTS `migration_tag`;
CREATE TABLE IF NOT EXISTS `migration_tag` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `color_coding` varchar(32) DEFAULT NULL,
  `NAME` varchar(256)  DEFAULT NULL,
  `notification_uuid` varchar(255)  DEFAULT NULL,
  `description` varchar(256)  DEFAULT NULL,
  `entity_type` bigint NOT NULL DEFAULT '0',
  `create_date` binary(0) DEFAULT NULL,
  `deleted` bigint NOT NULL DEFAULT '0',
  `deleted_date` binary(0) DEFAULT NULL,
  `imsi` varchar(25)  DEFAULT NULL
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_tag_error_history
DROP TABLE IF EXISTS `migration_tag_error_history`;
CREATE TABLE IF NOT EXISTS `migration_tag_error_history` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `NAME` varchar(256)  DEFAULT NULL,
  `notification_uuid` varchar(255)  DEFAULT NULL,
  `description` varchar(256)  DEFAULT NULL,
  `entity_type` bigint NOT NULL DEFAULT '0',
  `create_date` binary(0) DEFAULT NULL,
  `deleted` bigint NOT NULL DEFAULT '0',
  `deleted_date` binary(0) DEFAULT NULL,
  `imsi` varchar(25)  DEFAULT NULL,
  `Error_Message` varchar(1024)  DEFAULT NULL
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table cmp_stc_staging.migration_tracking_history
DROP TABLE IF EXISTS `migration_tracking_history`;
CREATE TABLE IF NOT EXISTS `migration_tracking_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `database_name` varchar(128) DEFAULT '0',
  `table_name` varchar(128) DEFAULT '0',
  `message_status` text,
  `query_print` text,
  `is_completed` tinyint(1) DEFAULT '0',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='This table is used for mantaine Error_handling history';


 
 SET FOREIGN_KEY_CHECKS=1;