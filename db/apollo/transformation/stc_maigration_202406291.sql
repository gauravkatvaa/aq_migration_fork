-- MySQL dump 10.13  Distrib 8.0.34, for Linux (x86_64)
--
-- Host: localhost    Database: stc_migration
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `stc_migration`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `stc_migration` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `stc_migration`;

--
-- Table structure for table `account_level`
--

DROP TABLE IF EXISTS `account_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_level` (
  `SERVICEPROFILEID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BUSINESSUNITID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DISOCUNTEDRATINGELEMENTS` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFNAME` varchar(255) DEFAULT NULL,
  `Account_Level_Discount_Name` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `Account_level_Discount_Price` mediumtext,
  KEY `comp_account_id` (`BUSINESSUNITID`,`DISCOUNTEDPRODUCTTARIFFNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_plan_charges`
--

DROP TABLE IF EXISTS `account_plan_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_plan_charges` (
  `Charge_Type` varchar(512) DEFAULT NULL,
  `STC_Category` varchar(512) DEFAULT NULL,
  `TP_NAME` varchar(512) DEFAULT NULL,
  `AP_NAME` varchar(512) DEFAULT NULL,
  `Zone_Group_Name` varchar(512) DEFAULT NULL,
  `TPCode` varchar(512) DEFAULT NULL,
  `gl_type` varchar(512) DEFAULT NULL,
  `Amount` int DEFAULT NULL,
  `gl_code` varchar(512) DEFAULT NULL,
  `type` varchar(512) DEFAULT NULL,
  `Category` varchar(512) DEFAULT NULL,
  `Frequency` varchar(512) DEFAULT NULL,
  `level` varchar(512) DEFAULT NULL,
  `UOM` varchar(512) DEFAULT NULL,
  `Charge_Application` varchar(512) DEFAULT NULL,
  `Action_Type` varchar(512) DEFAULT NULL,
  `EVENTCLASS` varchar(512) DEFAULT NULL,
  `CS_Name` varchar(512) DEFAULT NULL,
  KEY `idx1_DP_NAME` (`AP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `PARENT_ACCOUNT_ID` bigint DEFAULT NULL,
  `NAME` varchar(1000) DEFAULT NULL,
  `TYPE` int DEFAULT NULL,
  `ACCOUNT_MODEL` varchar(45) DEFAULT NULL,
  `STATE` varchar(100) DEFAULT NULL,
  `BILLING` tinyint DEFAULT '0',
  `BILLING_CONTACT_INFO_ID` bigint DEFAULT NULL,
  `PRIMARY_CONTACT_INFO_ID` bigint DEFAULT NULL,
  `OPERATIONS_CONTACT_INFO_ID` bigint DEFAULT NULL,
  `SIM_ORDER_CONTACT_INFO_ID` bigint DEFAULT NULL,
  `DEVICE_TYPE` varchar(100) DEFAULT NULL,
  `UNIT_TYPE` varchar(100) DEFAULT NULL,
  `SIM_TYPE` varchar(100) DEFAULT NULL,
  `SIM_USAGE` varchar(100) DEFAULT NULL,
  `APPLICATION_TYPE` varchar(100) DEFAULT NULL,
  `APPLICATION_SUMMARY` varchar(100) DEFAULT NULL,
  `DEVICE_VOLUME` bigint DEFAULT NULL,
  `DEVICE_DESCRIPTION` varchar(556) DEFAULT NULL,
  `ACCOUNT_NOTES` varchar(100) DEFAULT NULL,
  `BILLING_ADDRESS` varchar(556) DEFAULT NULL,
  `SHIPPING_ADDRESS` varchar(556) DEFAULT NULL,
  `LOCKED` tinyint(1) NOT NULL,
  `DELETED` tinyint(1) NOT NULL,
  `LOCK_REFERENCE` varchar(50) DEFAULT NULL,
  `NOTIFICATION_UUID` varchar(50) DEFAULT NULL,
  `REDIRECTION_GROUP_ID` bigint DEFAULT NULL,
  `REDIRECTION_URL` varchar(255) DEFAULT NULL,
  `CLASSIFIER` varchar(50) DEFAULT NULL,
  `IS_BSS` tinyint NOT NULL DEFAULT '1',
  `COUNTRIES_ID` bigint DEFAULT NULL,
  `EXTENDED_ID` bigint DEFAULT NULL,
  `IS_ACTIVATE` tinyint DEFAULT '0',
  `BILL_DATE` int DEFAULT NULL,
  `REGION_ID` varchar(512) DEFAULT NULL,
  `BAN_NUMBER` varchar(64) DEFAULT NULL,
  `LEGACY_BAN` varchar(64) DEFAULT NULL,
  `FREQUENCY` varchar(56) DEFAULT NULL,
  `ACCOUNT_TYPE` varchar(56) DEFAULT NULL,
  `CURRENCY_ID` int DEFAULT NULL,
  `EXTERNAL_ID` varchar(56) DEFAULT NULL,
  `IMEI_LOCK` tinyint DEFAULT '0',
  `SERVICE_GRANT` tinyint DEFAULT '0',
  `ACCOUNT_STATE` varchar(100) DEFAULT NULL,
  `SUSPENSION_STATUS` tinyint DEFAULT '0',
  `USER_ACCOUNT_TYPE_ID` int DEFAULT NULL,
  `TERMINATION_STATUS` tinyint DEFAULT '0' COMMENT '5 TERMINATE 4 TO BE TERMINATE',
  `TERMINATION_STATE_STATUS` tinyint DEFAULT '0',
  `TERMINATION_RETENTION_STATUS` tinyint DEFAULT '0',
  `STATE_JSON` json DEFAULT NULL,
  `COS_ID` int DEFAULT NULL,
  `SIM_ACCOUNT_TYPE` tinyint DEFAULT '1' COMMENT '0: SIM 1: Account',
  `IS_ACCOUNT_3RD_PARTY` tinyint DEFAULT '0',
  `TAX_ID` varchar(56) DEFAULT NULL,
  `account_state_reason` varchar(128) DEFAULT NULL,
  `DUNNING_STATUS` tinyint NOT NULL DEFAULT '0',
  `ACCOUNT_STATUS` tinyint NOT NULL DEFAULT '0' COMMENT 'account status bit maintain suspend terminate etc',
  `CONTRACT_NUMBER` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_accounts_BCI_idx` (`BILLING_CONTACT_INFO_ID`),
  KEY `fk_accounts_PCI_idx` (`PRIMARY_CONTACT_INFO_ID`),
  KEY `fk_accounts_OCI_idx` (`OPERATIONS_CONTACT_INFO_ID`),
  KEY `fk_accounts_SOCI_idx` (`SIM_ORDER_CONTACT_INFO_ID`),
  KEY `fk_accounts_CURRENCY_ID` (`CURRENCY_ID`),
  KEY `fk_accounts_COUNTRIES_ID` (`COUNTRIES_ID`),
  KEY `FK_accounts_account_extended_id` (`EXTENDED_ID`),
  KEY `fk_accounts_user_account_type_id` (`USER_ACCOUNT_TYPE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17479 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `acct_att_cdp`
--

DROP TABLE IF EXISTS `acct_att_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acct_att_cdp` (
  `CUSTOMER_ID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_COMM_CHANNEL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_PHONE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACTIVATION_STATUS` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BRANDING_TYPE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `INVOICING_LEVEL_TYPE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIGNATURE_DATE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FR_BILLING` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_FINGER_PRINT` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ONBOARDING_DESTIN_IP_WHITELIST` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACTIVATE_RETRIEVE_SMS` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CREATED_LABEL_NUMBER` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BSP_VERSION` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `COMPANY_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `UNIFIED_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_SIZE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MNO_CODE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BINDING_TIME` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CURRENCY` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OWNING_OPCO` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_LAST_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_PRODUCT_IDS` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LANGUAGE_CODE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_URL_BARRING_POLICY_MODI` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MRC` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PROVISONING_LIMIT_ON` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_CODE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_MANAGED` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_EMAIL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FIRST_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ALTRNATVE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_CHECK_PIN_SMS_AO` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RESTRICTION` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_MOBILE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LEAD_PERSON_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ONBOARDING_SOURCE_IP_WHITELIST` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTRACTING_TARIFF_PLANS` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_STATIC_IP` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VALIDITY_DATE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEGMENT` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BILLING_CYCLE_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_SMS_FORWARDING` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_URL_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_CATEGORY_LOCAL_DATA` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_CATEGORY_VOICE_WITH_INTERN` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IDENTIFICATION_TYPE_CODE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PREFERRED_LANGUAGE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_DELIVE` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `INIT_CUSTOMER_SIZE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OTC` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_CATEGORY_DATA_WITH_INTERNE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BILL_HIERARCHY_FLAG` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_CATEGORY_STC` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `METHOD_OF_PAYMENT` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_LIMIT_MAX` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AUTHORIZED_PERSONS` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TPV_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ROLE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ONBOARDING_ENABLE_URL_BARRING` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FIRST_FILTER_ENABLE` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEFAULT_BUSINESS_UNIT_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTACT_PERSON_OTP_CHANNEL` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTACT_PPERSON_MOBILE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTACT_PERSON_EMAIL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_SALUTATION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FAX` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_BILLING` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_DELIVERY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACTIVATE_PUSH_CDR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_CDR_EXPORT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_DATA_USAGE_PER_MB_CAT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_SIM_REPORT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_TECHNICAL_REPORT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_LAST_PUSHED_ID_1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_TOP_10_DATA_COUNTRIES` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_USAGE_REPORT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_LAST_PUSHED_ID_2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_TOP_10_VOICE_COUNTRIES` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_SERVICE_PROFILE_MIGRATION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_COST_OVERVIEW` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_TOP_10_SMS_COUNTRIES` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_TRIGGER_LOG` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_COST_REPORT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PROJECT_DESCRIPTION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_SMS_USAGE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_USAGE_DISTRIBUTION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_VOLUME_USAGE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_VOICE_USAGE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEBTOR_NUMBER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_LOGIN_1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_PASSWORD_1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_BILLNG` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_DELVRY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REPORT_SERVICE_PROFILE_MIGRATI` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUSH_CDR_PSWD_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `address_details_cdp`
--

DROP TABLE IF EXISTS `address_details_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address_details_cdp` (
  `PARTY_ROLE_ID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `POSTAL_CODE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDRESS_TYPE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STREET` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LOCATION_APARTMENT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CITY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NATIONALITY` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apn_ip_addressess_cdp`
--

DROP TABLE IF EXISTS `apn_ip_addressess_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_ip_addressess_cdp` (
  `ID` int DEFAULT NULL,
  `IP_ADDRESS` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IP_POOL_ID` int DEFAULT NULL,
  `IS_IP_USED` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apn_ip_pools_state_t_cdp`
--

DROP TABLE IF EXISTS `apn_ip_pools_state_t_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_ip_pools_state_t_cdp` (
  `ID` int DEFAULT NULL,
  `APN_ID` int DEFAULT NULL,
  `AVAILABLE_IPS` int DEFAULT NULL,
  `FIRST_AVAILABLE_IP` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apn_sp_cdp`
--

DROP TABLE IF EXISTS `apn_sp_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_sp_cdp` (
  `APN_ID` int DEFAULT NULL,
  `SP_ID` int DEFAULT NULL,
  `APN_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apns_cdp`
--

DROP TABLE IF EXISTS `apns_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apns_cdp` (
  `ID` int DEFAULT NULL,
  `BU_ID` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `CDP_APN_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTEXT_ID` int DEFAULT NULL,
  `CREATED_AT` timestamp NULL DEFAULT NULL,
  `CUSTOMER_ID` int DEFAULT NULL,
  `CUSTOMER_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EQOS_ID` int DEFAULT NULL,
  `IP_VERSION` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_PRIVATE` int DEFAULT NULL,
  `IS_STATIC` int DEFAULT NULL,
  `NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PROFILE_ID` int DEFAULT NULL,
  `REQUEST_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_DELETED` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SPLIT_BILLING` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ROAMING_ENABLED` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CATEGORY` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_TYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STARTING_IP` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENDING_IP` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUBNET` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NO_OF_HOSTS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets_cdp`
--

DROP TABLE IF EXISTS `assets_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets_cdp` (
  `IMSI` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EC_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LASTMODIFDATE` datetime DEFAULT NULL,
  `CREATIONDATE` datetime DEFAULT NULL,
  `IP_ADDRESS` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_STATUS` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDERTX_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SPCHANGECOUNTER` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SPMODIFDATE` datetime DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VOICE_ENABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIMPRODUCT_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACTIVATIONDATE` datetime DEFAULT NULL,
  `RU_FP_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ESIM` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCOLABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_STATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DES_INDEX` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALG_VERSION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `KI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADM` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MNOLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BULABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `APINSTANCE_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HIERARCHYDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NETSTATUSDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXPECTED_IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_STATUS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_METHOD` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_USER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_PASS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RSLRLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RR_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FREE_TEXT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `WSGUIDINGCITEM_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CELL_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENODEB_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFU` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFB` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDITIONAL_INFO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUSPENDEDSTATEREASON_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PREV_CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_FLAG1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_DATE1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_OPT1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IP_ADDRESSINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FIRST_CALL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RAT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_COUNTRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_OPERATOR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REGISTRATION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VIN` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets_cdp_1`
--

DROP TABLE IF EXISTS `assets_cdp_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets_cdp_1` (
  `IMSI` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_ID` int DEFAULT NULL,
  `EC_ID` int DEFAULT NULL,
  `BU_ID` int DEFAULT NULL,
  `LASTMODIFDATE` timestamp NULL DEFAULT NULL,
  `CREATIONDATE` timestamp NULL DEFAULT NULL,
  `IP_ADDRESS` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` int DEFAULT NULL,
  `SIM_STATUS` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDERTX_ID` int DEFAULT NULL,
  `SPCHANGECOUNTER` int DEFAULT NULL,
  `SPMODIFDATE` timestamp NULL DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VOICE_ENABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIMPRODUCT_ID` int DEFAULT NULL,
  `ACTIVATIONDATE` timestamp NULL DEFAULT NULL,
  `RU_FP_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ESIM` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCOLABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_STATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DES_INDEX` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALG_VERSION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `KI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADM` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MNOLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BULABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `APINSTANCE_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HIERARCHYDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NETSTATUSDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXPECTED_IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_STATUS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_METHOD` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_USER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_PASS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RSLRLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RR_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FREE_TEXT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `WSGUIDINGCITEM_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CELL_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENODEB_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFU` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFB` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDITIONAL_INFO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUSPENDEDSTATEREASON_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PREV_CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_FLAG1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_DATE1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_OPT1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IP_ADDRESSINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FIRST_CALL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RAT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_COUNTRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_OPERATOR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REGISTRATION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VIN` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets_cdp_2`
--

DROP TABLE IF EXISTS `assets_cdp_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets_cdp_2` (
  `IMSI` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_ID` int DEFAULT NULL,
  `EC_ID` int DEFAULT NULL,
  `BU_ID` int DEFAULT NULL,
  `LASTMODIFDATE` timestamp NULL DEFAULT NULL,
  `CREATIONDATE` timestamp NULL DEFAULT NULL,
  `IP_ADDRESS` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` int DEFAULT NULL,
  `SIM_STATUS` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDERTX_ID` int DEFAULT NULL,
  `SPCHANGECOUNTER` int DEFAULT NULL,
  `SPMODIFDATE` timestamp NULL DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VOICE_ENABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIMPRODUCT_ID` int DEFAULT NULL,
  `ACTIVATIONDATE` timestamp NULL DEFAULT NULL,
  `RU_FP_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ESIM` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCOLABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_STATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DES_INDEX` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALG_VERSION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `KI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPC` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PIN2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PUK2` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADM` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MNOLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BULABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `APINSTANCE_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HIERARCHYDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NETSTATUSDATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXPECTED_IMEI` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_STATUS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MIGRATION_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_METHOD` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_USER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RADIUS_PASS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RSLRLABEL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RR_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FREE_TEXT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `WSGUIDINGCITEM_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CELL_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENODEB_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFU` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFB` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CFNRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDITIONAL_INFO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUSPENDEDSTATEREASON_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PREV_CC_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_FLAG1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_DATE1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADD_OPT1` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IP_ADDRESSINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FIRST_CALL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RAT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_COUNTRY` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ATT_OPERATOR` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REGISTRATION_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VIN` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `billing_account_cdp`
--

DROP TABLE IF EXISTS `billing_account_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_account_cdp` (
  `CUSTOMER_ID` int NOT NULL,
  `CUSTOMER_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_REFERENCE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUID` int DEFAULT NULL,
  `BILLING_ACCOUNT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EC_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_IS_FINGER_PRINT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ACCOUNT_MANAGER_LAST_NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_OWNING_OPCO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_SIM_PRODUCT_IDS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ACCOUNT_MANAGER_EMAIL` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ACCOUNT_MANAGER_FIRST_NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_DUNNING_DATE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ACCOUNT_MANAGER_MOBILE` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_RESTRICTION` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ACCOUNT_MANAGER_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_BILLING_CYCLE_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_AUTHORIZED_PERSONS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_TPV_ID` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_LIMIT_MAX` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_center_cdp`
--

DROP TABLE IF EXISTS `cost_center_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_center_cdp` (
  `CUSTID_EXT` int DEFAULT NULL,
  `BUID_EXT` int DEFAULT NULL,
  `CCID_EXT` int DEFAULT NULL,
  `CUSTNAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUNAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CCNAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer_details_cdp`
--

DROP TABLE IF EXISTS `customer_details_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_details_cdp` (
  `CUSTOMER_ID` int DEFAULT NULL,
  `CUSTOMER_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_REFERENCE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUNAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ID` int DEFAULT NULL,
  `SERVICE_PROFILE_ID` int DEFAULT NULL,
  `SERVICE_PROFILE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `APN_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDRESS_TYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATIC_IP_VAS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ACCESS_RESTRICTED` int DEFAULT NULL,
  `CONTEXT_ID` int DEFAULT NULL,
  `APN_SERVICE_TYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DATA` int DEFAULT NULL,
  `SMS` int DEFAULT NULL,
  `VOICE_ENABLE` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `DISCOUNTID` varchar(255) DEFAULT NULL,
  `DISCOUNTNAME` varchar(255) DEFAULT NULL,
  `DISCOUNTTARIFFID` varchar(255) DEFAULT NULL,
  `DISCOUNTTARIFFNAME` varchar(255) DEFAULT NULL,
  `RATINGELEMENTNAME` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTID` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTNAME` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFID` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFNAME` varchar(255) DEFAULT NULL,
  `DISOCUNTEDRATINGELEMENTS` varchar(255) DEFAULT NULL,
  `DISCOUNTPERCENTAGEVALUE` varchar(255) DEFAULT NULL,
  `BUSINESSUNITID` varchar(255) DEFAULT NULL,
  `SERVICEPROFILEID` varchar(255) DEFAULT NULL,
  `DATASIZE` varchar(255) DEFAULT NULL,
  `PAYG` varchar(255) DEFAULT NULL,
  `DISCOUNTLEVEL` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dp_apo_bundle_charging_spec_dat`
--

DROP TABLE IF EXISTS `dp_apo_bundle_charging_spec_dat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dp_apo_bundle_charging_spec_dat` (
  `CATALOG_NAME` varchar(512) DEFAULT NULL,
  `TP_NAME` varchar(512) DEFAULT NULL,
  `AP_NAME` varchar(512) DEFAULT NULL,
  `Zone_Group_Name` varchar(512) DEFAULT NULL,
  `TPCode` varchar(512) DEFAULT NULL,
  `gl_type` varchar(512) DEFAULT NULL,
  `GROUP_TYPE` varchar(512) DEFAULT NULL,
  `bundle_type` varchar(512) DEFAULT NULL,
  `DP_NAME` varchar(512) DEFAULT NULL,
  `AOP_NAME` varchar(512) DEFAULT NULL,
  `Amount` varchar(20) DEFAULT NULL,
  `gl_code` varchar(512) DEFAULT NULL,
  `type` varchar(512) DEFAULT NULL,
  `Category` varchar(512) DEFAULT NULL,
  `Frequency` varchar(512) DEFAULT NULL,
  `level` varchar(512) DEFAULT NULL,
  `UOM` varchar(512) DEFAULT NULL,
  `Charge_Application` varchar(512) DEFAULT NULL,
  `Action_Type` varchar(512) DEFAULT NULL,
  `CS_Name` varchar(512) DEFAULT NULL,
  KEY `idx1_DP_NAME` (`DP_NAME`),
  KEY `idx_TP_NAME_1` (`TP_NAME`),
  KEY `idx_AP_NAME` (`AP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dp_child_vas_charges`
--

DROP TABLE IF EXISTS `dp_child_vas_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dp_child_vas_charges` (
  `TP_NAME` varchar(512) DEFAULT NULL,
  `AP_NAME` varchar(512) DEFAULT NULL,
  `Zone_Group_Name` varchar(512) DEFAULT NULL,
  `TPCode` varchar(512) DEFAULT NULL,
  `gl_type` varchar(512) DEFAULT NULL,
  `GROUP_TYPE` varchar(512) DEFAULT NULL,
  `bundle_type` varchar(512) DEFAULT NULL,
  `DP_NAME` varchar(512) DEFAULT NULL,
  `AOP_NAME` varchar(512) DEFAULT NULL,
  `Amount` varchar(512) DEFAULT NULL,
  `gl_code` varchar(512) DEFAULT NULL,
  `type` varchar(512) DEFAULT NULL,
  `Category` varchar(512) DEFAULT NULL,
  `Frequency` varchar(512) DEFAULT NULL,
  `level` varchar(512) DEFAULT NULL,
  `UOM` varchar(512) DEFAULT NULL,
  `Charge_Application` varchar(512) DEFAULT NULL,
  `Action_Type` varchar(512) DEFAULT NULL,
  `CS_Name` varchar(512) DEFAULT NULL,
  `Parent_CS_Name` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dp_generic_vas_susp_charges_dat`
--

DROP TABLE IF EXISTS `dp_generic_vas_susp_charges_dat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dp_generic_vas_susp_charges_dat` (
  `Charge_Type` varchar(512) DEFAULT NULL,
  `STC_Category` varchar(512) DEFAULT NULL,
  `TP_NAME` varchar(512) DEFAULT NULL,
  `AP_NAME` varchar(512) DEFAULT NULL,
  `Zone_Group_Name` varchar(512) DEFAULT NULL,
  `TPCode` varchar(512) DEFAULT NULL,
  `gl_type` varchar(512) DEFAULT NULL,
  `Amount` varchar(512) DEFAULT NULL,
  `gl_code` varchar(512) DEFAULT NULL,
  `type` varchar(512) DEFAULT NULL,
  `Category` varchar(512) DEFAULT NULL,
  `Frequency` varchar(512) DEFAULT NULL,
  `level` varchar(512) DEFAULT NULL,
  `UOM` varchar(512) DEFAULT NULL,
  `Charge_Application` varchar(512) DEFAULT NULL,
  `Action_Type` varchar(512) DEFAULT NULL,
  `EVENTCLASS` varchar(512) DEFAULT NULL,
  `CS_NAME` varchar(512) DEFAULT NULL,
  `DP_NAME` varchar(512) DEFAULT NULL,
  KEY `idx1_DP_NAME_Charge_Type` (`DP_NAME`(100),`Charge_Type`(10),`Amount`(10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imsi_range_cdp`
--

DROP TABLE IF EXISTS `imsi_range_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imsi_range_cdp` (
  `CTX_ID` int DEFAULT NULL,
  `POOL_ID` int DEFAULT NULL,
  `CRMCUSTOMER_ID` int DEFAULT NULL,
  `IMSI_START` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI_END` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_START` bigint DEFAULT NULL,
  `ICCID_END` bigint DEFAULT NULL,
  `IMSI_RANGE_TOTAL_SIM_COUNT` int DEFAULT NULL,
  `RANGE_MIN` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RANGE_MAX` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FREE_SIM_COUNT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imsi_range_cdp_tmp`
--

DROP TABLE IF EXISTS `imsi_range_cdp_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imsi_range_cdp_tmp` (
  `CTX_ID` int DEFAULT NULL,
  `POOL_ID` int DEFAULT NULL,
  `CRMCUSTOMER_ID` int DEFAULT NULL,
  `IMSI_START` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI_END` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_START` bigint DEFAULT NULL,
  `ICCID_END` bigint DEFAULT NULL,
  `IMSI_RANGE_TOTAL_SIM_COUNT` int DEFAULT NULL,
  `RANGE_MIN` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RANGE_MAX` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FREE_SIM_COUNT` bigint DEFAULT NULL,
  `rnk` int DEFAULT NULL,
  KEY `imsi_range_cdp_tmp_01` (`rnk`),
  KEY `imsi_range_cdp_tmp_02` (`CRMCUSTOMER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lable_source`
--

DROP TABLE IF EXISTS `lable_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lable_source` (
  `IMSI` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EC_ID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CREATIONDATE` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTLABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BULABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCOLABEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_user_sim_order`
--

DROP TABLE IF EXISTS `map_user_sim_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `map_user_sim_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordered_by` bigint DEFAULT NULL,
  `status_updated_date` datetime DEFAULT NULL,
  `sim_category_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `final_price` double DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `order_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `order_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'New',
  `quantity` int DEFAULT '0',
  `per_unit_price` double DEFAULT NULL,
  `order_shipping_id` bigint DEFAULT NULL,
  `is_standard` int DEFAULT NULL,
  `is_express` int DEFAULT NULL,
  `order_sim_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `auto_activation` tinyint DEFAULT '0',
  `data_plan_id` bigint DEFAULT NULL,
  `service_plan_id` bigint DEFAULT NULL,
  `REMARKS` varchar(4056) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Store value sim state information',
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_assets`
--

DROP TABLE IF EXISTS `migration_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_assets` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `ACTIVATION_DATE` datetime DEFAULT NULL,
  `APN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DATA_USAGE_LIMIT` bigint DEFAULT NULL,
  `DEVICE_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEVICE_IP_ADDRESS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DYNAMIC_IMSI` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DONOR_IMSI` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMEI` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IN_SESSION` tinyint(1) DEFAULT '0',
  `MODEM_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SESSION_START_TIME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SMS_USAGE_LIMIT` bigint DEFAULT NULL,
  `STATE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VOICE_USAGE_LIMIT` bigint DEFAULT NULL,
  `SUBSCRIBER_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUBSCRIBER_LAST_NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUBSCRIBER_GENDER` tinyint DEFAULT '0',
  `SUBSCRIBER_DOB` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALTERNATE_CONTACT_NUMBER` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUBSCRIBER_EMAIL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUBSCRIBER_ADDRESS` varchar(556) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PLAN_ID` bigint DEFAULT NULL,
  `LOCATION_COVERAGE_ID` bigint DEFAULT NULL,
  `NEXT_LOCATION_COVERAGE_ID` bigint DEFAULT '0',
  `BILLING_CYCLE` bigint DEFAULT NULL,
  `RATE_PLAN_ID` bigint DEFAULT NULL,
  `NEXT_RATE_PLAN_ID` bigint DEFAULT NULL,
  `MNO_ACCOUNTID` bigint DEFAULT NULL,
  `ENT_ACCOUNTID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TOTAL_DATA_USAGE` double DEFAULT '0',
  `TOTAL_DATA_DOWNLOAD` bigint DEFAULT '0',
  `TOTAL_DATA_UPLOAD` bigint DEFAULT '0',
  `DATA_USAGE_THRESHOLD` bigint DEFAULT '0',
  `IP_ADDRESS` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '000.000.000.000',
  `LAST_KNOWN_LOCATION` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LAST_KNOWN_NETWORK` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATE_MODIFIED_DATE` datetime DEFAULT NULL,
  `USAGES_NOTIFICATION` tinyint(1) DEFAULT '0',
  `BSS_ID` bigint DEFAULT NULL,
  `GOUP_ID` bigint DEFAULT NULL,
  `LOCK_REFERENCE` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_POOL_ID` bigint DEFAULT NULL,
  `WHOLESALE_PLAN_ID` bigint DEFAULT NULL,
  `PROFILE_STATE` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EUICC_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPERATIONAL_PROFILE_DATA_PLAN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BOOTSTRAP_PROFILE` int DEFAULT NULL,
  `CURRENT_IMEI` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ASSETS_EXTENDED_ID` bigint DEFAULT NULL,
  `DEVICE_PLAN_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEVICE_PLAN_DATE` timestamp NULL DEFAULT NULL,
  `COUNTRIES_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DONOR_ICCID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'For handling luhn digit concept storing iccid',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_map_user_sim_order`
--

DROP TABLE IF EXISTS `migration_map_user_sim_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_map_user_sim_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordered_by` bigint DEFAULT NULL,
  `status_updated_date` datetime DEFAULT NULL,
  `sim_category_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `final_price` double DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `order_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `order_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'New',
  `quantity` int DEFAULT '0',
  `per_unit_price` double DEFAULT NULL,
  `order_shipping_id` bigint DEFAULT NULL,
  `is_standard` int DEFAULT NULL,
  `is_express` int DEFAULT NULL,
  `order_sim_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `auto_activation` tinyint DEFAULT '0',
  `data_plan_id` bigint DEFAULT NULL,
  `service_plan_id` bigint DEFAULT NULL,
  `REMARKS` varchar(4056) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Store value sim state information',
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_map_user_sim_order_error_history`
--

DROP TABLE IF EXISTS `migration_map_user_sim_order_error_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_map_user_sim_order_error_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordered_by` bigint DEFAULT NULL,
  `status_updated_date` datetime DEFAULT NULL,
  `sim_category_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `final_price` double DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `order_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `order_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'New',
  `quantity` int DEFAULT '0',
  `per_unit_price` double DEFAULT NULL,
  `order_shipping_id` bigint DEFAULT NULL,
  `is_standard` int DEFAULT NULL,
  `is_express` int DEFAULT NULL,
  `order_sim_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `auto_activation` tinyint DEFAULT '0',
  `data_plan_id` bigint DEFAULT NULL,
  `service_plan_id` bigint DEFAULT NULL,
  `REMARKS` varchar(4056) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_1` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_2` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_3` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_4` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOM_PARAM_5` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Store value sim state information',
  `CUSTOM_PARAM_6` int DEFAULT NULL,
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `TERMS_CONDITIONS` tinyint DEFAULT '0',
  `IS_BLANK_SIM` tinyint(1) DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL COMMENT 'to hold order failure case while creating order',
  `awb_number` bigint DEFAULT NULL,
  `isOrderSentInSheet` tinyint DEFAULT NULL,
  `Error_Message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `sim_category_id` (`sim_category_id`),
  KEY `ordered_by` (`ordered_by`),
  KEY `order_shipping` (`order_shipping_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_order_shipping_status`
--

DROP TABLE IF EXISTS `migration_order_shipping_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_order_shipping_status` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ordernumber` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `target_delivery_date` datetime DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country_id` bigint DEFAULT NULL,
  `pincode` int DEFAULT NULL,
  `shipping_to_address1` varchar(556) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_address2` varchar(556) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_vendor_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `shipping_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ordernumber` (`ordernumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_order_shipping_status_error_history`
--

DROP TABLE IF EXISTS `migration_order_shipping_status_error_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_order_shipping_status_error_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `updated_date` datetime DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `target_delivery_date` datetime DEFAULT NULL,
  `extra_metadata` json DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country_id` bigint DEFAULT NULL,
  `pincode` int DEFAULT NULL,
  `shipping_to_address1` varchar(556) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_address2` varchar(556) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_to_phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shipping_vendor_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `shipping_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `error_message` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_sim_event_log`
--

DROP TABLE IF EXISTS `migration_sim_event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_sim_event_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'this table is to capture events for SIM',
  `order_id` bigint DEFAULT NULL COMMENT 'order id of sim',
  `account_id` bigint DEFAULT NULL COMMENT 'account id ',
  `sim_type` int DEFAULT NULL COMMENT 'type of sim',
  `imsi` varchar(20) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `event` varchar(45) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'event name',
  `start_time` datetime DEFAULT NULL COMMENT 'start timr ',
  `triggered_by` varchar(128) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'to whom triggered by',
  `triggered_user_type` int DEFAULT NULL COMMENT 'type of user from which it is triggered',
  `completion_time` datetime DEFAULT NULL COMMENT 'complrtion type',
  `extra_metadata` json DEFAULT NULL COMMENT 'json type column in which extra column vakus are stored',
  `CREATE_DATE` datetime DEFAULT NULL,
  `request_number` varchar(56) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'store request number for penalty exemption',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_sim_provisioned_range_details`
--

DROP TABLE IF EXISTS `migration_sim_provisioned_range_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_sim_provisioned_range_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=10002 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_sim_provisioned_range_details_error_history`
--

DROP TABLE IF EXISTS `migration_sim_provisioned_range_details_error_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_sim_provisioned_range_details_error_history` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_sim_range`
--

DROP TABLE IF EXISTS `migration_sim_range`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_sim_range` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DESCRIPTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `SIM_START` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_TYPE` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SENDER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_TO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  `donor_iccid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_sim_range_error_history`
--

DROP TABLE IF EXISTS `migration_sim_range_error_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_sim_range_error_history` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DESCRIPTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `SIM_START` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_TYPE` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SENDER` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_TO` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN_FROM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN_TO` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  `donor_iccid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Error_Message` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_tag`
--

DROP TABLE IF EXISTS `migration_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_tag` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `color_coding` varchar(32) DEFAULT NULL,
  `NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notification_uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entity_type` bigint NOT NULL DEFAULT '0',
  `create_date` binary(0) DEFAULT NULL,
  `deleted` bigint NOT NULL DEFAULT '0',
  `deleted_date` binary(0) DEFAULT NULL,
  `imsi` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_tag_1`
--

DROP TABLE IF EXISTS `migration_tag_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_tag_1` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notification_uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entity_type` bigint NOT NULL DEFAULT '0',
  `create_date` binary(0) DEFAULT NULL,
  `deleted` bigint NOT NULL DEFAULT '0',
  `deleted_date` binary(0) DEFAULT NULL,
  `imsi` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_tag_error_history`
--

DROP TABLE IF EXISTS `migration_tag_error_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_tag_error_history` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `NAME` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notification_uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entity_type` bigint NOT NULL DEFAULT '0',
  `create_date` binary(0) DEFAULT NULL,
  `deleted` bigint NOT NULL DEFAULT '0',
  `deleted_date` binary(0) DEFAULT NULL,
  `imsi` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Error_Message` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_tracking_history`
--

DROP TABLE IF EXISTS `migration_tracking_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_tracking_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `database_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
  `table_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
  `message_status` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `query_print` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `is_completed` tinyint(1) DEFAULT '0',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_profile_config_cdp`
--

DROP TABLE IF EXISTS `service_profile_config_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profile_config_cdp` (
  `CUST_ID` int DEFAULT NULL,
  `CUSTNAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUID` int DEFAULT NULL,
  `BUNAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SP_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TYPE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TP` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TARIFF_PLAN_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TARIFF_PLAN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUNDLE_ID` int DEFAULT NULL,
  `BUNDLE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VOICE_SIZE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SMS_SIZE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DATA_SIZE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NBIOT_SIZE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICES` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_DATA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_NBIOT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_SMS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_RESTRICTED_SMS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_VOICE_SERVICE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ENABLE_PAYG` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_LOCAL_DATA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_ROAMING_DATA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_LOCAL_NBIOT_DATA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_ROAMING_NBIOT_DATA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_LOCAL_SMS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAYG_ROAMING_SMS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DPName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_event_log`
--

DROP TABLE IF EXISTS `sim_event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_event_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'this table is to capture events for SIM',
  `order_id` bigint DEFAULT NULL COMMENT 'order id of sim',
  `account_id` bigint DEFAULT NULL COMMENT 'account id ',
  `sim_type` int DEFAULT NULL COMMENT 'type of sim',
  `imsi` varchar(20) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL,
  `event` varchar(45) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'event name',
  `start_time` datetime DEFAULT NULL COMMENT 'start timr ',
  `triggered_by` varchar(128) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'to whom triggered by',
  `triggered_user_type` int DEFAULT NULL COMMENT 'type of user from which it is triggered',
  `completion_time` datetime DEFAULT NULL COMMENT 'complrtion type',
  `extra_metadata` json DEFAULT NULL COMMENT 'json type column in which extra column vakus are stored',
  `CREATE_DATE` datetime DEFAULT NULL,
  `request_number` varchar(56) CHARACTER SET armscii8 COLLATE armscii8_bin DEFAULT NULL COMMENT 'store request number for penalty exemption',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6800 DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_level`
--

DROP TABLE IF EXISTS `sim_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_level` (
  `SERVICEPROFILEID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BUSINESSUNITID` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DISOCUNTEDRATINGELEMENTS` varchar(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFNAME` varchar(255) DEFAULT NULL,
  `Device_Level_Discount_Name` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `Device_level_Discount_Price` mediumtext,
  KEY `comp_idx` (`SERVICEPROFILEID`,`BUSINESSUNITID`,`DISCOUNTEDPRODUCTTARIFFNAME`,`DISOCUNTEDRATINGELEMENTS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_order_cdp`
--

DROP TABLE IF EXISTS `sim_order_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_order_cdp` (
  `ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DIC_TRANS_STATUS_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CREATE_BY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_RPODUCUT_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `START_DATE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `END_DATE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRX_TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_OPCO_CUST_ORDER_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CATEGORY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_QUANTITY` int DEFAULT NULL,
  `SIM_ORDER_OPCO_SIM_QUANTITY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EXPECTED_DELIVERY_DATE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CHANG_SERV_PROF_SERVI_PROF_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIV_LOCA_APAR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_PO_BOX` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_NM_DEP` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_AREA` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_CITY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELVERY_COUNTRY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELVRY_POST_COD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_STATE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_STREET` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIV_BUILDING` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_DELIVERY_COMPNY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_1` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_2` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_3` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_4` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_5` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SIM_QUANTI_MN_6` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AWB_NUMBER` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AUTO_ACTIVATION` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MSISDN` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_ASIGNED_MSISDN_RANGE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ESIM` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_BLANK` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_RECIPENT_PHN_NM` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_CUST_SELEC_SIMS_AMNT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_FROM_OPCO_ALGVERSION` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_OPCO_ENCRYPTIONINDEX` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_FROM_OPCO_FIRST_IMSI` bigint DEFAULT NULL,
  `SIM_ORDER_OPCO_FIRST_ICCID` bigint DEFAULT NULL,
  `SIM_ORDER_FROM_OPCO_ORDER_DATE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_FROM_OPCO_ORDER_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_OPCO_REJECTON_REASON` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ORDER_FROM_OPCO_SIM_POOL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRANSACTION_CONTEXT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  KEY `BU_ID_idx` (`BU_ID`,`CUSTOMER_ID`,`ID`),
  KEY `ID_idx` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_orders_ap_fp_status`
--

DROP TABLE IF EXISTS `sim_orders_ap_fp_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_orders_ap_fp_status` (
  `ORDER_ID` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AP_FP_STATUS` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_products_cdp`
--

DROP TABLE IF EXISTS `sim_products_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_products_cdp` (
  `sim_product_id` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_sub_type_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_sub_type_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_sub_type_3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `service_sub_type_4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `packaging_size` int DEFAULT NULL,
  `can_be_ordered` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_provisioned_range_details`
--

DROP TABLE IF EXISTS `sim_provisioned_range_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_provisioned_range_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_range`
--

DROP TABLE IF EXISTS `sim_range`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_range` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256) DEFAULT NULL,
  `DESCRIPTION` text,
  `SIM_START` varchar(64) DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64) DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64) DEFAULT NULL,
  `SIM_TYPE` varchar(64) DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64) DEFAULT NULL,
  `ICCID_FROM` varchar(64) DEFAULT NULL,
  `ICCID_TO` varchar(64) DEFAULT NULL,
  `SENDER` varchar(256) DEFAULT NULL,
  `ALLOCATE_TO` varchar(256) DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64) DEFAULT NULL,
  `IMSI_TO` varchar(64) DEFAULT NULL,
  `MSISDN_FROM` varchar(64) DEFAULT NULL,
  `MSISDN_TO` varchar(64) DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15) DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  `donor_iccid` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_range_1`
--

DROP TABLE IF EXISTS `sim_range_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_range_1` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` bigint DEFAULT NULL,
  `ACCOUNT_ID` bigint DEFAULT NULL,
  `ORDER_ID` bigint DEFAULT NULL,
  `NAME` varchar(256) DEFAULT NULL,
  `DESCRIPTION` text,
  `SIM_START` varchar(64) DEFAULT NULL,
  `SIM_RANGE_FROM` varchar(64) DEFAULT NULL,
  `SIM_RANGE_TO` varchar(64) DEFAULT NULL,
  `SIM_TYPE` varchar(64) DEFAULT NULL,
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(64) DEFAULT NULL,
  `ICCID_FROM` varchar(64) DEFAULT NULL,
  `ICCID_TO` varchar(64) DEFAULT NULL,
  `SENDER` varchar(256) DEFAULT NULL,
  `ALLOCATE_TO` varchar(256) DEFAULT NULL,
  `ALLOCATE_DATE` datetime DEFAULT NULL,
  `RANGE_AVAILABLE` tinyint(1) DEFAULT '0',
  `IS_NEW` tinyint(1) DEFAULT '0',
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  `IMSI_FROM` varchar(64) DEFAULT NULL,
  `IMSI_TO` varchar(64) DEFAULT NULL,
  `MSISDN_FROM` varchar(64) DEFAULT NULL,
  `MSISDN_TO` varchar(64) DEFAULT NULL,
  `ORDER_NUMBER` varchar(200) DEFAULT NULL,
  `ICCID_COUNT` int DEFAULT NULL,
  `IMSI_COUNT` int DEFAULT NULL,
  `MSISDN_COUNT` int DEFAULT NULL,
  `BILLING_ACCOUNT_ID` bigint DEFAULT '0',
  `STATUS` tinyint DEFAULT NULL,
  `TRANSACTION_ID` varchar(15) DEFAULT NULL,
  `EXTRA_METADATA` json DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_simrange_1_idx` (`ACCOUNT_ID`),
  KEY `fk_simrange_2_idx` (`ORDER_ID`),
  KEY `sim_range_billing_account_id` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_range_tmp`
--

DROP TABLE IF EXISTS `sim_range_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_range_tmp` (
  `CREATE_DATE` datetime NOT NULL,
  `BATCH_NUMBER` double DEFAULT NULL,
  `ACCOUNT_ID` int NOT NULL DEFAULT '0',
  `ORDER_ID` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NAME` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `SIM_START` binary(0) DEFAULT NULL,
  `SIM_RANGE_FROM` binary(0) DEFAULT NULL,
  `SIM_RANGE_TO` binary(0) DEFAULT NULL,
  `SIM_TYPE` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `SIM_COUNT` int DEFAULT NULL,
  `SIM_CATEGORY` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ICCID_FROM` bigint DEFAULT NULL,
  `ICCID_TO` bigint DEFAULT NULL,
  `SENDER` binary(0) DEFAULT NULL,
  `ALLOCATE_TO` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_DATE` datetime NOT NULL,
  `RANGE_AVAILABLE` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `IS_NEW` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `DELETED` int NOT NULL DEFAULT '0',
  `DELETED_DATE` binary(0) DEFAULT NULL,
  `IMSI_FROM` bigint DEFAULT NULL,
  `IMSI_TO` bigint DEFAULT NULL,
  `MSISDN_FROM` binary(0) DEFAULT NULL,
  `MSISDN_TO` binary(0) DEFAULT NULL,
  `ORDER_NUMBER` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_COUNT` bigint DEFAULT NULL,
  `IMSI_COUNT` bigint DEFAULT NULL,
  `MSISDN_COUNT` binary(0) DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` binary(0) DEFAULT NULL,
  `TRANSACTION_ID` binary(0) DEFAULT NULL,
  `EXTRA_METADATA` binary(0) DEFAULT NULL,
  `donor_iccid` binary(0) DEFAULT NULL,
  KEY `idx1` (`ICCID_TO`),
  KEY `idx2` (`IMSI_TO`),
  KEY `idx3` (`BILLING_ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_transactions_cdp`
--

DROP TABLE IF EXISTS `sim_transactions_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_transactions_cdp` (
  `ID` int DEFAULT NULL,
  `DIC_TRANS_STATUS_ID` int DEFAULT NULL,
  `CREATE_BY` int DEFAULT NULL,
  `CUSTOMER_ID` int DEFAULT NULL,
  `BU_ID` int DEFAULT NULL,
  `SIM_RPODUCUT_ID` int DEFAULT NULL,
  `START_DATE` datetime DEFAULT NULL,
  `END_DATE` datetime DEFAULT NULL,
  `TRX_TYPE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CHANG_SERV_PROF_SERVI_PROF_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ACTIVATON_SIM_LIFECYCLE_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `MSISDN` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `ICCID` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `AUTHORIZATION_TOKEN` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BUSINESS_UNIT_ID` int DEFAULT NULL,
  `BU_LIST` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `CASE_ID` int DEFAULT NULL,
  `CC_LIST` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `CHANGE_SERVICE_PROFILE_LOCALE` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CHANG_SERV_PROF_SIM_LIFCYCL_ID` int DEFAULT NULL,
  `MOVE_SIM_SOURCE_BU_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MOVE_SIM_TARGET_BU_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MOVE_SIM_TARGET_CC_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NIC_REFERENCE` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_FROM` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_TO` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REJECTION_REASON` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_ACTIVATE_DELIV_RECEPT` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SAVE_AS_SMS_TEMPLATE` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SMS_CONTENT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `SEND_SMS_SMS_DEFINITION` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SMS_TEMPLATE_DESCRIPT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SMS_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SMS_TEMPLATE_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SMS_TYPE` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SEND_SMS_SOURCE_BU_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_ALLOCATION_BU_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_DATA_UPDATE_FREE_TEXT` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_DATA_UPDATE_IMEI` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_DATA_UPDATE_IP` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ESIM` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_BLANK` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_ICCID_FROM` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_ICCID_TO` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_IMSI_FROM` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_IMSI_TO` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_MSISDN_FROM` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_REPLACEMENT_MSISDN_TO` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_SUSPENSION_AUTO_RSUM_ENBL` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SIM_TERMINATION_MIN_CONT_DURA` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SP_LIST` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `SUSPENSION_TYPE` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SWAP_MSISDN_MSISDN_FROM` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SWAP_MSISDN_MSISDN_TO` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TARGET_DATE` datetime DEFAULT NULL,
  `TRANSACTION_CONTEXT` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRIGGER_ID` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRIGGER_SEND_SMS_IMSI` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRIGGER_SEND_SMS_MESSAGE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRIGGER_SEND_SMS_PHONE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_transactions_cdp1`
--

DROP TABLE IF EXISTS `sim_transactions_cdp1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_transactions_cdp1` (
  `IMSI` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID` longtext CHARACTER SET big5 COLLATE big5_chinese_ci,
  `MSISDN` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `TRX_TYPE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SUSPENSION_TYPE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TRANSACTION_CONTEXT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `START_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `triggers_cdp`
--

DROP TABLE IF EXISTS `triggers_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triggers_cdp` (
  `Trigger_ID` int DEFAULT NULL,
  `Name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Trigger` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OpCo_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OpCo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Customer_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Customer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Business_Unit_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Business_Unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Cost_Center_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Cost_Center` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IMSI` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Active` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Visible` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Editable` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_details_cdp`
--

DROP TABLE IF EXISTS `users_details_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_details_cdp` (
  `USER_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CREATE_DATE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_ACTIVE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LOGIN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FIRST_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EMAIL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CREATE_BY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PHONE_NUMBER` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PARTY_ROLE_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OPCO_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUSTOMER_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FAX` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MOBILE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PHONE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PREFERRED_COM_CHANNEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OTP_CHANNEL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OTP_ENABLED` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `USE_API` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ROLE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LOCATION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ROLE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GROUP_ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GROUP_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `white_listing_cdp`
--

DROP TABLE IF EXISTS `white_listing_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `white_listing_cdp` (
  `POLICY_ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUST_ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CUST_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BU_NAME` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HOST_NAME` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ADDRESS` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TYPE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PORT` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PROTOCOL` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'stc_migration'
--

--
-- Dumping routines for database 'stc_migration'
--
/*!50003 DROP FUNCTION IF EXISTS `SplitString` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` FUNCTION `SplitString`(str VARCHAR(255), delim VARCHAR(5), pos INT) RETURNS varchar(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
    RETURN REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(str, delim, pos), delim, -1), '''', '');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `additional_bus_for_static_apns_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `additional_bus_for_static_apns_cdp`()
BEGIN
 
 


  DECLARE done INT DEFAULT FALSE;
    DECLARE bu_part VARCHAR(255);
    DECLARE cdp_apn VARCHAR(255);
    DECLARE pos INT;
    DECLARE bu_parts_cursor CURSOR FOR SELECT LEFT(apns_cdp.BU_ID, LENGTH(apns_cdp.BU_ID) - 5) as BU_ID,id as CDP_APN_ID FROM apns_cdp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 
    DROP TEMPORARY TABLE IF EXISTS temp_apns_cdp;
	 CREATE TEMPORARY TABLE IF NOT EXISTS temp_apns_cdp (BU_ID VARCHAR(255), CDP_APN_ID INT);
 
    OPEN bu_parts_cursor;
 
    read_loop: LOOP
        FETCH bu_parts_cursor INTO bu_part,cdp_apn;
 
        IF done THEN
            LEAVE read_loop;
        END IF;
 
        SET pos := 1;
        WHILE pos <= LENGTH(bu_part) - LENGTH(REPLACE(bu_part, '''', '')) + 1 DO
            INSERT INTO temp_apns_cdp (BU_ID, CDP_APN_ID) VALUES 
                (SplitString(bu_part, '''', pos), cdp_apn);  
            SET pos := pos + 1;
        END WHILE;
    END LOOP;
 
    CLOSE bu_parts_cursor;
 
 
 
 
 SELECT distinct GROUP_CONCAT(distinct BU_ID) INTO @bu_id_list FROM temp_apns_cdp;
SET @bu_id_list_trimmed = TRIM(BOTH ',' FROM @bu_id_list);
SET @bu_id_list_trimmed = replace(@bu_id_list_trimmed,',,',',');
SET @bu_id_list_trimmed =TRIM(BOTH '' FROM @bu_id_list_trimmed);

    DROP TEMPORARY TABLE IF EXISTS temp_billing_account_cdp;
    
    
if(@bu_id_list_trimmed IS NOT NULL and @bu_id_list_trimmed !='')
then

SET @sql = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS temp_billing_account_cdp SELECT BUID,BILLING_ACCOUNT as BILLING_ACCOUNT FROM billing_account_cdp WHERE billing_account_cdp.BUID IN (', @bu_id_list_trimmed, ')');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


WITH RECURSIVE SplitValues AS (
    SELECT
        a.BU_ID,
        SUBSTRING_INDEX(a.BU_ID, ',', 1) AS value,
        SUBSTRING(a.BU_ID, LENGTH(SUBSTRING_INDEX(a.BU_ID, ',', 1)) + 2) AS rest,
        a.CDP_APN_ID
    FROM temp_apns_cdp a
    WHERE a.BU_ID IS NOT NULL
    UNION ALL
    SELECT
        sv.BU_ID,
        SUBSTRING_INDEX(sv.rest, ',', 1) AS value,
        SUBSTRING(sv.rest, LENGTH(SUBSTRING_INDEX(sv.rest, ',', 1)) + 2) AS rest,
        sv.CDP_APN_ID
    FROM SplitValues sv
    WHERE sv.rest <> ''
)
SELECT
   sv.BU_ID,
   sv.CDP_APN_ID AS apnId,
    GROUP_CONCAT(distinct billing_account) AS accountBuId,
    sv.CDP_APN_ID AS CDP_APN_ID
FROM
    SplitValues sv
JOIN
    temp_billing_account_cdp b ON sv.value = b.BUID GROUP BY sv.CDP_APN_ID;
 
 END if;
 
 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `apn_management_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `apn_management_cdp`()
BEGIN
SELECT BuReferenceNumber,
    CustomerReferenceNumber,
    accountId,
    apnName,
    apnId,
    apnType,
    eqosid,
    '' AS apnIp,
    apnCategory,
    addressType,
    mcc,
    mnc,
    hlrApnId,
    hssContextId,
    profile2g3g,
    uplink2g3g,
    uplinkunit2g3g,
    downlink2g3g,
    downlinkunit2g3g,
    profilelte,
    uplinklte,
    uplinkunitlte,
    downllinklte,
    downllinunitklte,
    ipPoolAllocationType,
    CASE WHEN ipPoolAllocationType='dynamic' THEN '[]' ELSE  GROUP_CONCAT(subnet SEPARATOR ' ') END AS subnet,
    '0' AS ipPoolType,
    info,
	 '' AS apnDescription,
    '' AS requestSubType,
    IF(apnCategory=2,'GUI','') AS requestFrom,
	 CASE WHEN ipPoolAllocationType='dynamic' THEN 0 ELSE  COUNT(subnet) END AS subnet_count,
	 apnTypeIpv6,
	 subnetIpv6,
	 apnServiceType,
	apnWlBlcategory,
	 splitBilling,
	 roamingEnabled,
	 radiusAuthenticationEnable,
	radiusAuthType,
	 radiusUsername,
	 radiusPassword,
	 radiusForwardingEnable
	 
	 
	 FROM (
    SELECT SUBSTRING_INDEX(apns_cdp.BU_ID, "'", 1) AS accountId,
    
    apns_cdp.ID AS apnId,
    apns_cdp.NAME AS apnName,
    apns_cdp.TYPE,
    apns_cdp.EQOS_ID AS eqosid,
    apns_cdp.SUBNET AS subnet,
    apns_cdp.IS_STATIC ,
    apns_cdp.IS_PRIVATE,
    apns_cdp.IP_VERSION,
    apns_cdp.CONTEXT_ID AS hssContextId,
    apns_cdp.PROFILE_ID AS hssProfileId,
    apns_cdp.STARTING_IP AS apnIp,
	 CASE WHEN IS_STATIC ='0' THEN 'false' WHEN IS_STATIC='1' THEN 'true' END AS apnType,
	 CASE WHEN IS_PRIVATE ='0' THEN 2 WHEN IS_PRIVATE='1' THEN 1 END AS apnCategory,
	 CASE WHEN IS_PRIVATE ='0' THEN 2 WHEN IS_PRIVATE='1' THEN 1 END AS ipPoolType,
	
	 CASE WHEN IS_STATIC ='0' THEN 'dynamic' WHEN IS_STATIC='1' THEN 'static' END AS ipPoolAllocationType,
	 1 AS  addressType,
    424 AS mcc,
    01 AS mnc,
    '' AS hlrApnId,
    '' AS profile2g3g,
    '' AS uplink2g3g,
    '' AS uplinkunit2g3g,
    '' AS downlink2g3g,
    '' AS downlinkunit2g3g,
    '' AS profilelte,
    '' AS uplinklte,
    '' AS uplinkunitlte,
    '' AS downllinklte,
    '' AS downllinunitklte,
    apns_cdp.NAME AS info,
    billing_account_cdp.BILLING_ACCOUNT AS BuReferenceNumber,
      billing_account_cdp.CUSTOMER_REFERENCE AS CustomerReferenceNumber,
	'' AS apnTypeIpv6,
	'[]' AS subnetIpv6,
	'm2m' AS apnServiceType,
	'' apnWlBlcategory,
	'false' AS splitBilling,
	'true' AS roamingEnabled,
	'true' AS radiusAuthenticationEnable,
	'' AS radiusAuthType,
	'' AS radiusUsername,
	'' AS radiusPassword,
	'false' AS radiusForwardingEnable
	FROM apns_cdp 
	 
	  inner JOIN billing_account_cdp ON  case when apns_cdp.BU_ID='ALL' OR apns_cdp.BU_ID='ALL' then apns_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID ELSE SUBSTRING_INDEX(apns_cdp.BU_ID, "'", 1)=billing_account_cdp.BUID end
	  INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID 
	  UNION all
	  
	   SELECT SUBSTRING_INDEX(apns_cdp.BU_ID, "'", 1) AS accountId,
    
    apns_cdp.ID AS apnId,
    apns_cdp.NAME AS apnName,
    apns_cdp.TYPE,
    apns_cdp.EQOS_ID AS eqosid,
    apns_cdp.SUBNET AS subnet,
    apns_cdp.IS_STATIC ,
    apns_cdp.IS_PRIVATE,
    apns_cdp.IP_VERSION,
    apns_cdp.CONTEXT_ID AS hssContextId,
    apns_cdp.PROFILE_ID AS hssProfileId,
    apns_cdp.STARTING_IP AS apnIp,
	 CASE WHEN IS_STATIC ='0' THEN 'false' WHEN IS_STATIC='1' THEN 'true' END AS apnType,
	 CASE WHEN IS_PRIVATE ='0' THEN 2 WHEN IS_PRIVATE='1' THEN 1 END AS apnCategory,
	 CASE WHEN IS_PRIVATE ='0' THEN 2 WHEN IS_PRIVATE='1' THEN 1 END AS ipPoolType,
	
	 CASE WHEN IS_STATIC ='0' THEN 'dynamic' WHEN IS_STATIC='1' THEN 'static' END AS ipPoolAllocationType,
	 1 AS  addressType,
    424 AS mcc,
    01 AS mnc,
    '' AS hlrApnId,
    '' AS profile2g3g,
    '' AS uplink2g3g,
    '' AS uplinkunit2g3g,
    '' AS downlink2g3g,
    '' AS downlinkunit2g3g,
    '' AS profilelte,
    '' AS uplinklte,
    '' AS uplinkunitlte,
    '' AS downllinklte,
    '' AS downllinunitklte,
    apns_cdp.NAME AS info,
    null AS BuReferenceNumber,
    null AS CustomerReferenceNumber,
	'' AS apnTypeIpv6,
	'[]' AS subnetIpv6,
	'm2m' AS apnServiceType,
	'' apnWlBlcategory,
	'false' AS splitBilling,
	'true' AS roamingEnabled,
	'true' AS radiusAuthenticationEnable,
	'' AS radiusAuthType,
	'' AS radiusUsername,
	'' AS radiusPassword,
	'false' AS radiusForwardingEnable 
	
	FROM apns_cdp WHERE apns_cdp.IS_PRIVATE=0 AND (apns_cdp.BU_ID IS NULL OR apns_cdp.BU_ID ='ALL') AND apns_cdp.CUSTOMER_ID IS null
) apnCreation 
	  GROUP BY apnName;
	  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `assests_details_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `assests_details_cdp`(
	IN `in_country_name` VARCHAR(50),
	IN `in_mno_id` VARCHAR(50)
)
BEGIN
SELECT 
'' AS ID,
assets_cdp.CREATIONDATE AS CREATE_DATE,
if(ACTIVATIONDATE is NULL ,assets_cdp.CREATIONDATE,IF(ACTIVATIONDATE='0001-01-01 00:00:00',NULL,ACTIVATIONDATE)) AS ACTIVATION_DATE,
NULL AS APN,
0 as DATA_USAGE_LIMIT,
NULL AS DEVICE_ID,
NULL AS DEVICE_IP_ADDRESS,
NULL AS DYNAMIC_IMSI,
NULL AS DONOR_IMSI,
assets_cdp.ICCID AS ICCID,
NULL AS IMEI,
assets_cdp.IMSI AS IMSI,
0 AS IN_SESSION,
NULL AS MODEM_ID,
assets_cdp.MSISDN AS MSISDN,
NULL AS SESSION_START_TIME,
0 AS SMS_USAGE_LIMIT,
(CASE assets_cdp.SIM_STATUS 
		WHEN '1' THEN 'Warm' 
		WHEN '2' THEN 'Warm' 
		when 'R' then 'Warm' 
		WHEN '3' THEN 'TestReady' 
		WHEN '4' THEN 'TestReady' 
		WHEN '5' THEN 'TestReady' 
		WHEN 'A' THEN 'Activated' 
		WHEN 'S' THEN 'Suspended' 
		WHEN 'V' THEN 'Suspended' 
		ELSE NULL END) 				AS STATE ,
		
'ACTIVATED' AS `STATUS`,
0 AS VOICE_USAGE_LIMIT,
NULL AS SUBSCRIBER_NAME,
NULL AS SUBSCRIBER_LAST_NAME,
NULL AS SUBSCRIBER_GENDER,
NULL AS SUBSCRIBER_DOB,
NULL AS ALTERNATE_CONTACT_NUMBER,
NULL AS SUBSCRIBER_EMAIL,
NULL AS SUBSCRIBER_ADDRESS,
NULL AS CUSTOM_PARAM_1,
NULL AS CUSTOM_PARAM_2,
NULL AS CUSTOM_PARAM_3,
NULL AS CUSTOM_PARAM_4,
 CASE 
        WHEN sim_transactions_cdp1.TRX_TYPE = 'Administrative suspend of BU sims'
            THEN 'Non Payment'
        WHEN SUSPENSION_TYPE = 'Termination with retention' AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 'Non Payment'
        WHEN SUSPENSION_TYPE = 'Normal Suspension' AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 'Customer Initiate'
        WHEN SUSPENSION_TYPE IS NULL AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 
                CASE 
                    WHEN TRANSACTION_CONTEXT IN ('API', 'MANUAL', 'TRIGGER') 
                        THEN 'Customer Initiate' 
                    ELSE NULL
                END 
    END AS CUSTOM_PARAM_5 ,
NULL AS SERVICE_PLAN_ID,
NULL AS LOCATION_COVERAGE_ID,
NULL AS NEXT_LOCATION_COVERAGE_ID,
1 AS BILLING_CYCLE,
NULL AS RATE_PLAN_ID,
NULL AS NEXT_RATE_PLAN_ID,
in_mno_id AS MNO_ACCOUNTID,
billing_account_cdp.BILLING_ACCOUNT AS  ENT_ACCOUNTID,
0 AS TOTAL_DATA_USAGE,
0 AS TOTAL_DATA_DOWNLOAD,
0 AS TOTAL_DATA_UPLOAD,
0 AS DATA_USAGE_THRESHOLD,
assets_cdp.IP_ADDRESS  AS IP_ADDRESS,
NULL AS LAST_KNOWN_LOCATION,
null as LAST_KNOWN_NETWORK,
IF(assets_cdp.SPMODIFDATE='0001-01-01 00:00:00',NULL,assets_cdp.SPMODIFDATE) AS STATE_MODIFIED_DATE,
0 as USAGES_NOTIFICATION,
NULL AS BSS_ID,
NULL AS GOUP_ID,
NULL AS LOCK_REFERENCE,
NULL AS SIM_POOL_ID,
NULL AS WHOLESALE_PLAN_ID,
NULL AS PROFILE_STATE,
NULL AS EUICC_ID,
NULL AS OPERATIONAL_PROFILE_DATA_PLAN,
NULL AS BOOTSTRAP_PROFILE,
NULL AS CURRENT_IMEI,
'' AS ASSETS_EXTENDED_ID,
concat(service_profile_config_cdp.DPName,'_',billing_account_cdp.BILLING_ACCOUNT) AS DEVICE_PLAN_ID,
IF(assets_cdp.SPMODIFDATE='0001-01-01 00:00:00',NULL,assets_cdp.SPMODIFDATE) AS DEVICE_PLAN_DATE,
in_country_name AS COUNTRIES_ID,
null as DONOR_ICCID
FROM assets_cdp 

left JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID
LEFT join service_profile_config_cdp ON service_profile_config_cdp.SERVICE_PROFILE_ID=assets_cdp.SERVICE_PROFILE_ID 
LEFT JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID 
LEFT JOIN sim_transactions_cdp1 
    ON assets_cdp.imsi=sim_transactions_cdp1.imsi AND  sim_transactions_cdp1.TRX_TYPE IN ('sim suspension', 'Administrative suspend of BU sims') AND assets_cdp.SIM_STATUS IN ('S','V')
GROUP BY assets_cdp.IMSI ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `asset_extended_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `asset_extended_cdp`()
BEGIN
SELECT 
    '' AS ID,
    assets_cdp.CREATIONDATE as  CREATE_DATE ,
    NULL as  voice_template ,
    NULL as  sms_template ,
    NULL as  data_template ,
    case when assets_cdp.IS_ESIM=1 then 3 when assets_cdp.IS_ESIM=0 then 4 end as  sim_type_id ,
    NULL as  ORDER_NUMBER ,
    NULL as  SERVICE_GRANT ,
    NULL as  IMEI_LOCK ,
    NULL as  OLD_PROFILE_STATE ,
    NULL as  CURRENT_PROFILE_STATE ,
    NULL as  custom_param_1 ,
    NULL as  custom_param_2 ,
    NULL as  custom_param_3 ,
    NULL as  custom_param_4 ,
    NULL as  custom_param_5 ,
    NULL as  BULK_SERVICE_NAME ,
    NULL as  FVS_DATA ,
    '830' as  sim_category ,
    NULL as  lock_by_user ,
    NULL as  imei_lock_setup_date ,
    NULL as  imei_lock_disable_date
FROM assets_cdp INNER JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID
 INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID GROUP BY assets_cdp.IMSI;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `csrj_mapping_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `csrj_mapping_cdp`()
BEGIN

select 
distinct service_profile_config_cdp.CUSTNAME as `Customer Name`,
service_profile_config_cdp.BUNAME as `Business Unit Name`,
service_profile_config_cdp.TARIFF_PLAN as `Tariff Plan`,
customer_details_cdp.APN_NAME as `APN`,
service_profile_config_cdp.DPName as `Device Plan`,
'0' as `Service Plan param Voice Outgoing`,
'0' as `Service Plan param Voice Incoming`,
service_profile_config_cdp.ENABLE_VOICE_SERVICE as `Service Plan param Voice`,
NULL as `Service Plan param International Voice`,
0 as `Voice PAYG`,
service_profile_config_cdp.ENABLE_SMS as `Service Plan param SMS`,
IF(service_profile_config_cdp.PAYG_LOCAL_SMS = 1 OR service_profile_config_cdp.PAYG_ROAMING_SMS = 1, 1, 0) as `SMS PAYG`,
service_profile_config_cdp.ENABLE_DATA as `Service Plan param Data`,
IF(service_profile_config_cdp.PAYG_LOCAL_DATA = 1 OR service_profile_config_cdp.PAYG_ROAMING_DATA = 1, 1, 0) as `Data PAYG`,
service_profile_config_cdp.ENABLE_NBIOT as `Service Plan param Nbiot data`,
IF(service_profile_config_cdp.PAYG_LOCAL_NBIOT_DATA = 1 OR service_profile_config_cdp.PAYG_ROAMING_NBIOT_DATA = 1, 1, 0)  as `Nbiot Data PAYG`,
IF(LENGTH(service_profile_config_cdp.PAYG_ROAMING_DATA) = 0 OR service_profile_config_cdp.PAYG_ROAMING_DATA IS NULL ,0.0,service_profile_config_cdp.PAYG_ROAMING_DATA) AS `Service Plan param Is Roaming`,
NULL as `CSR END DATE`,
NULL as `Account Level VAS Charge`,
NULL as `Account Level VAS Charge Amount`,
NULL as `Account Level VAS END DATE`,
NULL as `Device Plan Vas Charge Device Plan`,
NULL as `Device Level Vas Charge`,
NULL as `Device Level VAS Charge Amount`,
NULL as `Device Level VAS Charge END Date`,
NULL as `Addon Plan`,
NULL as `Discount Name`,
NULL as `Discount Price`,
NULL as `Penalties`,
NULL as `Penalties Create Date`,
NULL as `Penalties Amout`,
NULL as `Adjustments`,
NULL as `Adjustments Create Date`,
NULL as `Adjustments Amount` FROM service_profile_config_cdp INNER JOIN customer_details_cdp ON customer_details_cdp.BU_ID=service_profile_config_cdp.BUID AND customer_details_cdp.SERVICE_PROFILE_ID=service_profile_config_cdp.SERVICE_PROFILE_ID WHERE service_profile_config_cdp.`STATUS`='Enabled';


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `csr_mapping_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `csr_mapping_details`()
BEGIN
/*
When calculating discount values within groups, we need an external step to improve the performance 
instead of using subqueries.
*/
DROP TABLE IF  EXISTS sim_level;
CREATE TABLE IF NOT EXISTS `sim_level` (
  `SERVICEPROFILEID` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BUSINESSUNITID` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DISOCUNTEDRATINGELEMENTS` VARCHAR(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFNAME` VARCHAR(255) DEFAULT NULL,
  `Device_Level_Discount_Name` MEDIUMTEXT CHARACTER SET utf8mb3,
  `Device_level_Discount_Price` MEDIUMTEXT,
  KEY `comp_idx` (`SERVICEPROFILEID`,`BUSINESSUNITID`,`DISCOUNTEDPRODUCTTARIFFNAME`,`DISOCUNTEDRATINGELEMENTS`)
) ENGINE=INNODB ;
-- 
INSERT INTO sim_level(SERVICEPROFILEID,BUSINESSUNITID,DISOCUNTEDRATINGELEMENTS,DISCOUNTEDPRODUCTTARIFFNAME,Device_Level_Discount_Name,
Device_level_Discount_Price)
SELECT SERVICEPROFILEID,BUSINESSUNITID,DISOCUNTEDRATINGELEMENTS,DISCOUNTEDPRODUCTTARIFFNAME,GROUP_CONCAT( 
(CASE 
    WHEN DISCOUNTLEVEL = 'SIM level' 
        AND (DISOCUNTEDRATINGELEMENTS LIKE '%Bundle' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Shared' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Ind') THEN 'PLDIS_DP_Billing_DPVASRC'
    WHEN DISCOUNTLEVEL = 'SIM level' 
        AND (DISOCUNTEDRATINGELEMENTS LIKE '%Activation Fee' ) THEN 'PLDIS_DP_Billing_DPVASOTC'             
    ELSE NULL 
END ) 
 SEPARATOR '&&') AS Device_Level_Discount_Name,
GROUP_CONCAT(
(CASE 
    WHEN DISCOUNTLEVEL = 'SIM level' 
        AND (DISOCUNTEDRATINGELEMENTS LIKE '%Bundle' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Shared' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Ind') THEN DISCOUNTPERCENTAGEVALUE
    WHEN DISCOUNTLEVEL = 'SIM level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Activation Fee' ) THEN DISCOUNTPERCENTAGEVALUE           
    ELSE NULL 
END) SEPARATOR '&&') AS Device_level_Discount_Price
 FROM `discount` WHERE DISCOUNTLEVEL = 'SIM level'
 GROUP BY SERVICEPROFILEID,BUSINESSUNITID,DISCOUNTEDPRODUCTTARIFFNAME
 ;
DROP TABLE IF EXISTS  account_level;
CREATE TABLE IF NOT EXISTS `account_level` (
  `SERVICEPROFILEID` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BUSINESSUNITID` VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DISOCUNTEDRATINGELEMENTS` VARCHAR(255) DEFAULT NULL,
  `DISCOUNTEDPRODUCTTARIFFNAME` VARCHAR(255) DEFAULT NULL,
  `Account_Level_Discount_Name` MEDIUMTEXT CHARACTER SET utf8mb3,
  `Account_level_Discount_Price` MEDIUMTEXT,
  KEY `comp_account_id` (`BUSINESSUNITID`,`DISCOUNTEDPRODUCTTARIFFNAME`)
) ENGINE=INNODB ;
INSERT INTO account_level(SERVICEPROFILEID,BUSINESSUNITID,DISOCUNTEDRATINGELEMENTS,DISCOUNTEDPRODUCTTARIFFNAME,Account_Level_Discount_Name,Account_level_Discount_Price)
SELECT SERVICEPROFILEID,BUSINESSUNITID,DISOCUNTEDRATINGELEMENTS,DISCOUNTEDPRODUCTTARIFFNAME,GROUP_CONCAT( (CASE 
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Dedicated APN Fee%' ) THEN 'PLDIS_ACC_Billing_APVASRC'
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Dedicated APN Setup Fee%' ) THEN 'PLDIS_ACC_Billing_APVASOTC'
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Bundle' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Shared' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Ind') THEN 'PLDIS_ACC_Billing_DPVASRC'
   WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Commercial Activation Fee' ) THEN 'PLDIS_ACC_Billing_DPVASOTC'             
    ELSE NULL 
END ) SEPARATOR '&&') AS Account_Level_Discount_Name,
GROUP_CONCAT(
(CASE 
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Dedicated APN Fee%' ) THEN DISCOUNTPERCENTAGEVALUE
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Dedicated APN Setup Fee%' ) THEN DISCOUNTPERCENTAGEVALUE
	WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Bundle' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Shared' 
             OR DISOCUNTEDRATINGELEMENTS LIKE '%Ind') THEN DISCOUNTPERCENTAGEVALUE
   WHEN DISCOUNTLEVEL = 'Account level' AND (DISOCUNTEDRATINGELEMENTS LIKE '%Commercial Activation Fee' ) THEN DISCOUNTPERCENTAGEVALUE             
    ELSE NULL 
END ) SEPARATOR '&&') AS Account_level_Discount_Price
 FROM `discount` WHERE DISCOUNTLEVEL = 'Account level'
 GROUP BY SERVICEPROFILEID,BUSINESSUNITID,DISCOUNTEDPRODUCTTARIFFNAME
 ;
 
 -- 
 -- 
SELECT 
 DISTINCT 
service_profile_config_cdp.DPName AS `Device Plan`,
'0' AS `Service Plan param Voice Outgoing`,
'0' AS `Service Plan param Voice Incoming`,
service_profile_config_cdp.ENABLE_VOICE_SERVICE AS `Service Plan param Voice`,
NULL AS `Service Plan param International Voice`,
0 AS `Voice PAYG`,
service_profile_config_cdp.ENABLE_SMS AS `Service Plan param SMS`,
IF((service_profile_config_cdp.PAYG_LOCAL_SMS = 1 OR service_profile_config_cdp.PAYG_ROAMING_SMS = 1) AND service_profile_config_cdp.ENABLE_PAYG='Enable', 1, 0) AS `SMS PAYG`,
service_profile_config_cdp.ENABLE_DATA AS `Service Plan param Data`,
IF((service_profile_config_cdp.PAYG_LOCAL_DATA = 1 OR service_profile_config_cdp.PAYG_ROAMING_DATA = 1) AND service_profile_config_cdp.ENABLE_PAYG='Enable', 1, 0) AS `Data PAYG`,
service_profile_config_cdp.ENABLE_NBIOT AS `Service Plan param Nbiot data`,
IF((service_profile_config_cdp.PAYG_LOCAL_NBIOT_DATA = 1 OR service_profile_config_cdp.PAYG_ROAMING_NBIOT_DATA = 1) AND service_profile_config_cdp.ENABLE_PAYG='Enable', 1, 0)  AS `Nbiot Data PAYG`,
IF(LENGTH(service_profile_config_cdp.PAYG_ROAMING_DATA) = 0 OR service_profile_config_cdp.PAYG_ROAMING_DATA IS NULL OR service_profile_config_cdp.PAYG_ROAMING_DATA =0.0 ,0,service_profile_config_cdp.PAYG_ROAMING_DATA) AS `Service Plan param Is Roaming`,
NULL AS `CSR END DATE`,
account_plan_charges.CS_Name AS `Account Level VAS Charge`,
account_plan_charges.Amount AS `Account Level VAS Charge Amount`,
NULL AS `Account Level VAS END DATE`,
d1.DP_NAME AS `Device Plan Vas Charge Device Plan`,
d1.CS_NAME  AS `Device Level Vas Charge`,
d1.Amount  AS `Device Level VAS Charge Amount`,
 NULL AS `Device Level VAS Charge END Date`,
(SELECT 
GROUP_CONCAT(dt2.`AOP_NAME` SEPARATOR '&&') FROM 
dp_apo_bundle_charging_spec_dat dt2 WHERE dt2.TP_NAME   =service_profile_config_cdp.TARIFF_PLAN COLLATE utf8mb4_general_ci
)AS `Addon Plan`,
dd.Device_Level_Discount_Name AS Device_Level_Discount_Name,
dd.Device_level_Discount_Price  AS Device_level_Discount_Price,
NULL AS `Discount Price`,
NULL AS `Penalties`,
NULL AS `Penalties Create Date`,
NULL AS `Penalties Amout`,
NULL AS `Adjustments`,
NULL AS `Adjustments Create Date`,
NULL AS `Adjustments Amount`,
dd2.Account_Level_Discount_Name AS `Account Level Discount Name`,
dd2.Account_level_Discount_Price AS Account_level_Discount_Price,
service_profile_config_cdp.SERVICE_PROFILE_ID
FROM service_profile_config_cdp 
INNER JOIN billing_account_cdp ON billing_account_cdp.BUID=service_profile_config_cdp.BUID 		  
LEFT JOIN dp_apo_bundle_charging_spec_dat dt ON dt.DP_NAME   =service_profile_config_cdp.DPName COLLATE utf8mb4_general_ci
LEFT JOIN account_plan_charges ON account_plan_charges.AP_NAME= dt.AP_NAME
LEFT JOIN dp_generic_vas_susp_charges_dat d1 ON d1.DP_NAME=service_profile_config_cdp.DPName COLLATE utf8mb4_general_ci
AND d1.Charge_Type='VAS' AND d1.Amount<>0
LEFT JOIN dp_apo_bundle_charging_spec_dat dt1 ON dt.TP_NAME   =service_profile_config_cdp.TARIFF_PLAN COLLATE utf8mb4_general_ci
LEFT JOIN `sim_level` dd ON dd.BUSINESSUNITID=service_profile_config_cdp.BUID 
AND dd.DISCOUNTEDPRODUCTTARIFFNAME=service_profile_config_cdp.`TARIFF_PLAN` COLLATE utf8mb4_general_ci
AND dd.SERVICEPROFILEID=service_profile_config_cdp.`SERVICE_PROFILE_ID`  COLLATE utf8mb4_general_ci
LEFT JOIN `account_level` dd2 ON dd2.BUSINESSUNITID=service_profile_config_cdp.BUID 
AND dd2.DISCOUNTEDPRODUCTTARIFFNAME=service_profile_config_cdp.`TARIFF_PLAN` COLLATE utf8mb4_general_ci
WHERE service_profile_config_cdp.`STATUS`='Enabled'
;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `csr_mapping_master` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `csr_mapping_master`()
BEGIN
SELECT GROUP_CONCAT( SERVICE_PROFILE_ID SEPARATOR '&&' ) as SERVICE_PROFILE_ID
,`Customer Name`,
 `Business Unit Name`,
`Tariff Plan`,
GROUP_CONCAT( distinct `APN` SEPARATOR '&&') AS `APN LIST`,
GROUP_CONCAT( distinct `Device Plan LIST` SEPARATOR '&&') AS `Device Plan LIST`,
CUSTOMER_REFERENCE,
BILLING_ACCOUNT
 FROM (
SELECT  distinct service_profile_config_cdp.CUSTNAME AS `Customer Name`,
      service_profile_config_cdp.BUNAME AS  `Business Unit Name`,
		 service_profile_config_cdp.TARIFF_PLAN AS `Tariff Plan`,
		 customer_details_cdp.APN_NAME AS `APN`,
		 service_profile_config_cdp.DPName AS `Device Plan LIST`,
		 customer_details_cdp.CUSTOMER_REFERENCE AS CUSTOMER_REFERENCE,
		 billing_account_cdp.BILLING_ACCOUNT AS BILLING_ACCOUNT,
		 service_profile_config_cdp.SERVICE_PROFILE_ID
		  FROM service_profile_config_cdp 
		  INNER JOIN customer_details_cdp ON customer_details_cdp.BU_ID=service_profile_config_cdp.BUID 
		  AND customer_details_cdp.SERVICE_PROFILE_ID=service_profile_config_cdp.SERVICE_PROFILE_ID  
		  
		  INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=customer_details_cdp.CUSTOMER_ID 
		  INNER JOIN billing_account_cdp ON billing_account_cdp.BUID=service_profile_config_cdp.BUID  
		  WHERE service_profile_config_cdp.`STATUS`='Enabled' )csr_master 
          GROUP BY `Customer Name`,`Business Unit Name`,`Tariff Plan`,BILLING_ACCOUNT,CUSTOMER_REFERENCE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_account_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `customer_account_cdp`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS bu_address_details;
CREATE TEMPORARY TABLE bu_address_details
SELECT  
       address_details_cdp.PARTY_ROLE_ID AS PARTY_ROLE_ID, 
        address_details_cdp.NATIONALITY AS country_BU,
        address_details_cdp.POSTAL_CODE AS zipCode_BU,
        address_details_cdp.ADDRESS_TYPE AS addressType_BU,
        address_details_cdp.STREET AS addressLine1_BU,
        address_details_cdp.LOCATION_APARTMENT AS addressLine2_BU,
        address_details_cdp.CITY AS addressLine4_BU 
        FROM address_details_cdp 
        INNER JOIN customer_details_cdp ON  address_details_cdp.PARTY_ROLE_ID=customer_details_cdp.BU_ID;
        
        
SELECT DISTINCT 
        CONCAT('O',LPAD(FLOOR(RAND() * 10000), 4, '0')) AS orderNumber,
		  CONCAT('T',LPAD(FLOOR(RAND() * 10000), 4, '0')) AS taskId,
		  businessUnitName,
		  customerReferenceNumber,
        customerSegmentCode,
        customerType,
        billHierarchyFlag,
        companyName,
        identificationTypeCode,
        identityNumber,
        primaryPhoneNumber,
        country_EC,
        zipCode_EC,
        addressType_EC,
        addressLine1_EC,
      '' AS addressLine2_EC, 
        '' AS addressLine3_EC,
		 '' AS addressLine4_EC,
		 '' AS addressLine5_EC,
       LOWER(customerGenre) AS customerGenre,
        LOWER(category) AS category,
        maxNumberIMSIs,
       buTechContactPersonMobile AS techContactPersonMobile,
		 buTechContactPersonEmail AS techContactPersonEmail,
	
		 leadPersonOrAccManagerID  AS leadPersonOrAccManagerID,
        unifiedID,
        firstName,
        lastName,
        alternateName,
        languageCode,
        billingAccountNumber,
        billingAccountName, 
       'Live' AS  billingAccountStatus,
        billCycle, 
       maxSIMNumber,
       'Y' fingerprintStatus, 
         buTechContactPersonMobile,
        buTechContactPersonEmail, 
       'SA' AS country_BU,
        zipCode_BU, 
        addressType_BU,
        addressLine1_BU,
        addressLine2_BU, 
        addressLine3_BU, 
        addressLine4_BU,
		  '' AS addressLine5_BU,
		  c_localData,
		  c_dataWithInternet,
		  c_voiceWithInternet,
		  c_preferredLanguage 
 FROM (SELECT 
billing_account_cdp.BU_NAME AS billingAccountName,


billing_account_cdp.BU_NAME AS businessUnitName,

billing_account_cdp.BUID AS BU_ID,
acct_att_cdp.CUSTOMER_ID,
acct_att_cdp.ACTIVATION_STATUS AS billingAccountStatus,


        'Y' AS fingerprintStatus,
       
       
         acct_att_cdp.CONTACT_PPERSON_MOBILE AS buTechContactPersonMobile,
        acct_att_cdp.CONTACT_PERSON_EMAIL AS buTechContactPersonEmail,        
        bu_address_details.country_BU,
        bu_address_details.zipCode_BU,
        bu_address_details.addressType_BU,
        bu_address_details.addressLine1_BU,
        bu_address_details.addressLine2_BU,
        bu_address_details.addressLine4_BU,
        MAX(Billing_Account_cdp.BILLING_ACCOUNT) AS billingAccountNumber,
        '' AS addressLine3_BU,
        75 AS billCycle,
        0 AS maxSIMNumber,
      Billing_Account_cdp.CUSTOMER_REFERENCE AS customerReferenceNumber,
       acct_att_cdp.SEGMENT    AS customerSegmentCode,
      'Regular' AS customerType,
      'Y' AS billHierarchyFlag,
       customer_details_cdp.CUSTOMER_NAME  AS companyName,
       
        acct_att_cdp.IDENTIFICATION_TYPE_CODE AS identificationTypeCode,
        acct_att_cdp.COMPANY_ID AS  identityNumber,
        acct_att_cdp.ACCOUNT_MANAGER_PHONE AS primaryPhoneNumber,
        address_details_cdp.NATIONALITY AS  country_EC,
        address_details_cdp.POSTAL_CODE AS  zipCode_EC,
        address_details_cdp.ADDRESS_TYPE AS  addressType_EC,
        address_details_cdp.STREET AS addressLine1_EC,
        acct_att_cdp.CUSTOMER_MANAGED AS  customerGenre,
        acct_att_cdp.CUSTOMER_CATEGORY_STC AS  category,
        CASE WHEN acct_att_cdp.SIM_ORDER_LIMIT_MAX='NA' THEN 0 ELSE acct_att_cdp.SIM_ORDER_LIMIT_MAX END AS  maxNumberIMSIs,
        IFNULL(acct_att_cdp.UNIFIED_ID,'') AS unifiedID,
        '' AS firstName,
        '' AS lastName,
        acct_att_cdp.ACCOUNT_MANAGER_ALTRNATVE_NAME AS alternateName,
       acct_att_cdp.LANGUAGE_CODE AS languageCode,
         IF(acct_att_cdp.SIM_CATEGORY_LOCAL_DATA,'true','false') AS c_localData,
       IF(acct_att_cdp.SIM_CATEGORY_VOICE_WITH_INTERN,'true','false') AS c_voiceWithInternet,
       IF(acct_att_cdp.SIM_CATEGORY_DATA_WITH_INTERNE,'true','false') AS c_dataWithInternet,
       acct_att_cdp.PREFERRED_LANGUAGE AS c_preferredLanguage,
       users_details_cdp.LOGIN  AS leadPersonOrAccManagerID
  FROM Billing_Account_cdp 
INNER JOIN acct_att_cdp ON billing_account_cdp.CUSTOMER_ID=acct_att_cdp.CUSTOMER_ID
INNER JOIN customer_details_cdp ON customer_details_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID 

LEFT JOIN users_details_cdp ON users_details_cdp.USER_ID=(CASE WHEN CUSTOMER_MANAGED='MANAGED' THEN acct_att_cdp.ACCOUNT_MANAGER_ID WHEN acct_att_cdp.CUSTOMER_MANAGED='UNMANAGED' THEN acct_att_cdp.LEAD_PERSON_ID ELSE '' END) 
LEFT JOIN address_details_cdp ON address_details_cdp.PARTY_ROLE_ID=customer_details_cdp.CUSTOMER_ID 
LEFT JOIN bu_address_details ON bu_address_details.PARTY_ROLE_ID=customer_details_cdp.BU_ID 

GROUP BY billing_account,acct_att_cdp.CUSTOMER_ID
)AccountOnboard GROUP BY billingAccountNumber,CUSTOMER_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_account_cdp_bu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `customer_account_cdp_bu`()
BEGIN

DROP TEMPORARY TABLE if exists temp_customer_bu;
CREATE TEMPORARY TABLE temp_customer_bu  
SELECT customer_details_cdp.BU_ID FROM billing_account_cdp INNER JOIN acct_att_cdp ON billing_account_cdp.CUSTOMER_ID=acct_att_cdp.CUSTOMER_ID
INNER JOIN customer_details_cdp ON customer_details_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID AND  customer_details_cdp.BU_ID=billing_account_cdp.BUID
INNER JOIN address_details_cdp ON address_details_cdp.PARTY_ROLE_ID=customer_details_cdp.CUSTOMER_ID GROUP BY acct_att_cdp.CUSTOMER_ID;


DROP TEMPORARY TABLE IF EXISTS bu_address_details;
CREATE TEMPORARY TABLE bu_address_details
SELECT  
       address_details_cdp.PARTY_ROLE_ID AS PARTY_ROLE_ID, 
        address_details_cdp.NATIONALITY AS country_BU,
        address_details_cdp.POSTAL_CODE as zipCode_BU,
        address_details_cdp.ADDRESS_TYPE AS addressType_BU,
        address_details_cdp.STREET AS addressLine1_BU,
        address_details_cdp.LOCATION_APARTMENT AS addressLine2_BU,
        address_details_cdp.CITY as addressLine4_BU FROM address_details_cdp 
		  INNER JOIN customer_details_cdp ON  address_details_cdp.PARTY_ROLE_ID=customer_details_cdp.BU_ID 
		  WHERE customer_details_cdp.BU_ID NOT IN (SELECT BU_ID FROM temp_customer_bu);


SELECT distinct CONCAT('O',LPAD(FLOOR(RAND() * 10000), 4, '0')) as orderNumber,
		  CONCAT('T',LPAD(FLOOR(RAND() * 10000), 4, '0')) as taskId,
		   businessUnitName,
		  customerReferenceNumber,
        customerSegmentCode,
        customerType,
        billHierarchyFlag,
        companyName,
        identificationTypeCode,
        identityNumber,
        primaryPhoneNumber,
        country_EC,
        zipCode_EC,
        addressType_EC,
        addressLine1_EC,
      '' as addressLine2_EC, 
        '' as addressLine3_EC,
		 '' as addressLine4_EC,
		 '' AS addressLine5_EC,
       lower(customerGenre) AS customerGenre,
        lower(category) AS category,
        maxNumberIMSIs,
       buTechContactPersonMobile as techContactPersonMobile,
		 buTechContactPersonEmail as techContactPersonEmail,
		  '' as leadPersonOrAccManagerID,
        unifiedID,
        firstName,
        lastName,
        alternateName,
        languageCode,
        billingAccountNumber,
        billingAccountName, 
       'Live' AS  billingAccountStatus,
        billCycle, 
       maxSIMNumber,
       'Y' fingerprintStatus, 
         buTechContactPersonMobile,
        buTechContactPersonEmail, 
       'SA' as country_BU,
        zipCode_BU, 
        addressType_BU,
        addressLine1_BU,
        addressLine2_BU, 
        addressLine3_BU, 
        addressLine4_BU,
		  '' as addressLine5_BU,
		  c_localData,
		  c_dataWithInternet,
		  c_voiceWithInternet,
		  c_preferredLanguage FROM (SELECT 

billing_account_cdp.BU_NAME AS billingAccountName,

billing_account_cdp.BU_NAME AS businessUnitName,

billing_account_cdp.BUID AS BU_ID,
 acct_att_cdp.CUSTOMER_ID,
acct_att_cdp.ACTIVATION_STATUS AS billingAccountStatus,
        'Y' AS fingerprintStatus,
        acct_att_cdp.ACCOUNT_MANAGER_MOBILE AS buTechContactPersonMobile,
        acct_att_cdp.ACCOUNT_MANAGER_EMAIL AS buTechContactPersonEmail,
       
        address_details_cdp.NATIONALITY AS country_BU,
        address_details_cdp.POSTAL_CODE as zipCode_BU,
        address_details_cdp.ADDRESS_TYPE AS addressType_BU,
        address_details_cdp.STREET AS addressLine1_BU,
        address_details_cdp.LOCATION_APARTMENT AS addressLine2_BU,
        address_details_cdp.CITY as addressLine4_BU,
        max(billing_account_cdp.BILLING_ACCOUNT) AS billingAccountNumber,
        '' AS addressLine3_BU,
        75 AS billCycle,
        0 AS maxSIMNumber,
      billing_account_cdp.CUSTOMER_REFERENCE AS customerReferenceNumber,
       acct_att_cdp.SEGMENT    as customerSegmentCode,
      'Regular' AS customerType,
      'Y' as billHierarchyFlag,
       customer_details_cdp.CUSTOMER_NAME  as companyName,
        
         acct_att_cdp.IDENTIFICATION_TYPE_CODE as identificationTypeCode,
        acct_att_cdp.COMPANY_ID AS  identityNumber,
        acct_att_cdp.ACCOUNT_MANAGER_PHONE as primaryPhoneNumber,
        address_details_cdp.NATIONALITY AS  country_EC,
        address_details_cdp.POSTAL_CODE AS  zipCode_EC,
        address_details_cdp.ADDRESS_TYPE AS  addressType_EC,
        address_details_cdp.STREET as addressLine1_EC,
        acct_att_cdp.CUSTOMER_MANAGED AS  customerGenre,
        acct_att_cdp.CUSTOMER_CATEGORY_STC AS  category,
        case when acct_att_cdp.SIM_ORDER_LIMIT_MAX='NA' then 0 ELSE acct_att_cdp.SIM_ORDER_LIMIT_MAX end AS  maxNumberIMSIs,
       
        ifnull(acct_att_cdp.UNIFIED_ID,'') as unifiedID,
        '' as firstName,
        '' as lastName,
        acct_att_cdp.ACCOUNT_MANAGER_ALTRNATVE_NAME as alternateName,
        acct_att_cdp.LANGUAGE_CODE as languageCode,
        if(acct_att_cdp.SIM_CATEGORY_LOCAL_DATA,'true','false') AS c_localData,
       if(acct_att_cdp.SIM_CATEGORY_VOICE_WITH_INTERN,'true','false') as c_voiceWithInternet,
       if(acct_att_cdp.SIM_CATEGORY_DATA_WITH_INTERNE,'true','false') AS c_dataWithInternet,
       acct_att_cdp.PREFERRED_LANGUAGE AS c_preferredLanguage
  FROM billing_account_cdp INNER JOIN acct_att_cdp ON billing_account_cdp.CUSTOMER_ID=acct_att_cdp.CUSTOMER_ID
INNER JOIN customer_details_cdp ON customer_details_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID 

INNER JOIN address_details_cdp ON address_details_cdp.PARTY_ROLE_ID=customer_details_cdp.CUSTOMER_ID left JOIN bu_address_details ON bu_address_details.PARTY_ROLE_ID=customer_details_cdp.BU_ID WHERE customer_details_cdp.BU_ID NOT IN (SELECT BU_ID FROM temp_customer_bu) GROUP BY acct_att_cdp.CUSTOMER_ID
)AccountOnboard GROUP BY CUSTOMER_ID;






END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Goup_router_bulk_upload_dumm` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `Goup_router_bulk_upload_dumm`()
BEGIN


SELECT assets_cdp.ICCID AS ICCID, assets_cdp.IMSI AS IMSI, assets_cdp.MSISDN AS MSISDN FROM assets_cdp INNER JOIN customer_details_cdp ON customer_details_cdp.BU_ID=assets_cdp.BU_ID INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=customer_details_cdp.CUSTOMER_ID GROUP BY assets_cdp.IMSI;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ip_pooling_22` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `ip_pooling_22`()
SELECT 
	GROUP_CONCAT(DISTINCT BU_ID) AS BU_ID,
APN_ID,
NUMBER_OF_REQUESTED_IPS,
FIRST_AVAILABLE_IP
 FROM (
SELECT  
	GROUP_CONCAT(distinct billing_account_cdp.BILLING_ACCOUNT) AS BU_ID
,	apns_cdp.ID AS APN_ID
,	SUM(apn_ip_pools_state_t_cdp.AVAILABLE_IPS) AS NUMBER_OF_REQUESTED_IPS
,	apn_ip_pools_state_t_cdp.FIRST_AVAILABLE_IP AS FIRST_AVAILABLE_IP
FROM apns_cdp 
inner JOIN apn_ip_pools_state_t_cdp ON apn_ip_pools_state_t_cdp.APN_ID=apns_cdp.CDP_APN_ID
inner JOIN billing_account_cdp ON CASE WHEN apns_cdp.BU_ID='All' THEN  billing_account_cdp.CUSTOMER_ID=apns_cdp.CUSTOMER_ID ELSE billing_account_cdp.BUID=apns_cdp.BU_ID end
WHERE apns_cdp.IS_PRIVATE=0 AND apns_cdp.IS_STATIC=1
AND apns_cdp.BU_ID IS NOT NULL
GROUP BY apns_cdp.BU_ID,apns_cdp.CUSTOMER_ID) temp GROUP BY APN_ID,NUMBER_OF_REQUESTED_IPS,FIRST_AVAILABLE_IP ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ip_white_listing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `ip_white_listing`()
BEGIN
    
DROP TEMPORARY TABLE IF EXISTS  tbl_white_listing_cdp ;
CREATE TEMPORARY TABLE  IF NOT EXISTS tbl_white_listing_cdp
AS
SELECT 
POLICY_ID,CUST_ID,BU_NAME,PORT,
  CONCAT(
    '{"sourceFrom": "', GROUP_CONCAT(DISTINCT CASE WHEN `TYPE` = 'source' THEN IFNULL(`ADDRESS`, 'null') END SEPARATOR ','), '", ',
    '"destinationFrom": "', GROUP_CONCAT(DISTINCT CASE WHEN `TYPE` = 'destination' THEN IFNULL(`ADDRESS`, 'null') END SEPARATOR ','), '", ',
    '"port": "', IFNULL(MAX(`PORT`), 'null'), '", ',
    '"protocol": "', IFNULL(MAX(`PROTOCOL`), 'null'), '"}'
  ) AS `ipWhitelistingMapping`
FROM
  `stc_migration`.`white_listing_cdp`
  GROUP BY POLICY_ID,CUST_ID,BU_NAME,PORT
 ;
 
SELECT
b1.BILLING_ACCOUNT	AS account_id,
b1.`CUSTOMER_REFERENCE` AS customer,
ipWhitelistingMapping,
w1.policy_id AS policy_id
FROM  billing_account_cdp b1
INNER JOIN `tbl_white_listing_cdp` w1 ON b1.`BUID`=w1.`BU_NAME`
GROUP BY w1.`BU_NAME`,POLICY_ID,CUST_ID,PORT
;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lead_person_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `lead_person_cdp`()
BEGIN

select 
    users_details_cdp.USER_ID AS CPDID,
    case when users_details_cdp.MOBILE='NA' then '' ELSE users_details_cdp.MOBILE END  AS primaryPhone,
    case when users_details_cdp.PHONE='NA' then '' ELSE users_details_cdp.PHONE END  AS secondaryPhone,
    users_details_cdp.FIRST_NAME AS firstName,
    users_details_cdp.LAST_NAME AS lastName,
    users_details_cdp.EMAIL AS email,
    users_details_cdp.EMAIL as emailConf,
    case when users_details_cdp.ROLE_NAME='Lead Person' then 'OpCo_LP' ELSE users_details_cdp.ROLE_NAME end as  roleId,
    195 as     countryId,
    40 as     timeZoneId,
    case when users_details_cdp.`STATUS` ='USER_STATUS.ACTIVE' then 'false' when users_details_cdp.`STATUS` ='USER_STATUS.LOCKED' then 'true' ELSE 'false' END AS  `locked`,
    '' as     accountId,
    users_details_cdp.LOGIN as     userName,
    0 as     groupId,
    1 as     userType,
    case when users_details_cdp.ROLE_NAME='Lead Person' then 'LeadPerson' when users_details_cdp.ROLE_NAME='OpCo_AM' then 'AccountManager' end as     userAccountType,
    '' as     supervisorId,
    'false' as     resetPasswordAction,
    '' as reason FROM users_details_cdp WHERE users_details_cdp.ROLE_NAME IN ('OpCo_AM','Lead Person');
    
    
  


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `map_user_sim_order_procedure_bulk_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `map_user_sim_order_procedure_bulk_insert`()
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
truncate table `stc_migration`.`migration_map_user_sim_order_error_history`;
INSERT INTO `stc_migration`.`migration_map_user_sim_order_error_history` (
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
INSERT INTO `stc_migration`.`migration_map_user_sim_order_error_history` (
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
INSERT INTO `stc_migration`.`migration_map_user_sim_order_error_history` (
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
INSERT INTO `stc_migration`.`map_user_sim_order` (
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
  m1.id,		  m1.ordered_by,	  m1.status_updated_date,	  m1.sim_category_id,
  m1.create_date,	  m1.final_price,	  m1.extra_metadata,		  m1.order_number,
  a1.ID,  	  	  m1.order_status,  	  m1.quantity,  		  m1.per_unit_price,
  m1.order_shipping_id,   m1.is_standard, 	  m1.is_express,		  m1.order_sim_category,
  m1.auto_activation,	  m1.data_plan_id,	  m1.service_plan_id,		  m1.REMARKS,
  m1.CUSTOM_PARAM_1,	  m1.CUSTOM_PARAM_2,	  m1.CUSTOM_PARAM_3,		  m1.CUSTOM_PARAM_4,
  m1.CUSTOM_PARAM_5,	  m1.CUSTOM_PARAM_6,	  m1.DELETED,			  m1.DELETED_DATE,
  m1.TERMS_CONDITIONS,	  m1.IS_BLANK_SIM,	  m1.STATUS,			  m1.awb_number,
  m1.isOrderSentInSheet
FROM `migration_map_user_sim_order` m1
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=m1.Billing_account_id
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
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_api_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_api_user`()
BEGIN
SELECT DISTINCT LOGIN,
	FIRST_NAME,
	LAST_NAME,
	EMAIL,
	'False' AS locked,
	"1,72,1,58,1,75,1,90,1,62,1,121,1,122,1,70,1,91,1,60,1,126,1,123,1,78,1,130,1,131,1,175,1,196,1,298,1,8,1,9,1,61,1,116,1,108,1,125,1,129,1,66,1,2,1,74,1,60,1,59,1,79,1,84,1,85,1,86,1,87,1,88,1,89,1,97,1,98,1,92,1,124,1,185,1,186,1,148,1,149,1,150,1,151,1,152,1,153,1,154,1,155,1,156,1,157,1,158,1,159,1,160,1,161,1,162,1,163,1,164,1,165,1,166,1,167,1,168,1,169,1,170,1,171,1,172,1,173,1,194,1,195,1,176,1,178,1,179,1,180,1,181,1,182,1,183,1,184,1,188,1,189,1,115,1,192,1,193,1,280,1,202,1,201,1,203,1,224,1,204,1,206,1,205,1,211,1,223,1,225,1,207,1,281,1,191,1,319,1,314,1,315,1,316,1,305,1,306,1,307,1,308,1,309,1,310,1,311,1,312,1,313,1,317,1,320,1,1,1,1,1" as apiMappingIds,
	'[]' AS states,
	NULL AS reason,
(CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN billing_account_cdp.CUSTOMER_REFERENCE ELSE billing_account_cdp.BILLING_ACCOUNT END) AS accountId
FROM `users_details_cdp`
INNER JOIN billing_account_cdp ON (CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN billing_account_cdp.CUSTOMER_ID ELSE billing_account_cdp.BUID END)=(CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN users_details_cdp.CUSTOMER_ID ELSE users_details_cdp.BU_ID END) 
WHERE USE_API = 1;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_assets_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_assets_cdp`()
BEGIN
SELECT assets_cdp.IMSI,
billing_account_cdp.BILLING_ACCOUNT	as account_id,
		NULL AS event_date,
		if(ACTIVATIONDATE is NULL ,assets_cdp.CREATIONDATE,IF(ACTIVATIONDATE='0001-01-01 00:00:00',NULL,ACTIVATIONDATE)) AS activation_date,
		'' AS device_id,
		'' AS service_Plan_ID,
		assets_cdp.iccid,
		assets_cdp.MSISDN,
		 CASE 
        WHEN sim_transactions_cdp1.TRX_TYPE = 'Administrative suspend of BU sims'
            THEN 'Non Payment'
        WHEN SUSPENSION_TYPE = 'Termination with retention' AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 'Non Payment'
        WHEN SUSPENSION_TYPE = 'Normal Suspension' AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 'Customer Initiate'
        WHEN SUSPENSION_TYPE IS NULL AND sim_transactions_cdp1.TRX_TYPE = 'sim suspension'
            THEN 
                CASE 
                    WHEN TRANSACTION_CONTEXT IN ('API', 'MANUAL', 'TRIGGER') 
                        THEN 'Customer Initiate' 
                    ELSE NULL
                END 
    END 	AS reason,
		(CASE assets_cdp.SIM_STATUS 
		WHEN '1' THEN 'Warm' 
		WHEN '2' THEN 'Warm' 
		WHEN '3' THEN 'TestReady' 
		WHEN '4' THEN 'TestReady' 
		WHEN '5' THEN 'TestReady' 
		WHEN 'A' THEN 'Activated' 
		WHEN 'S' THEN 'Suspended' 
		WHEN 'V' THEN 'Suspended' 
		ELSE NULL END) 				AS STATE 
FROM assets_cdp INNER JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID
INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID
LEFT JOIN sim_transactions_cdp1 
    ON assets_cdp.imsi=sim_transactions_cdp1.imsi AND  sim_transactions_cdp1.TRX_TYPE IN ('sim suspension', 'Administrative suspend of BU sims') AND assets_cdp.SIM_STATUS IN ('S','V') GROUP BY assets_cdp.IMSI;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_device_plan_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_device_plan_cdp`()
BEGIN
SELECT '' as device_plan_id,
       concat(service_profile_config_cdp.DPName,'_',billing_account_cdp.BILLING_ACCOUNT) as NAME,
		 NULL AS `TYPE`,
		 NULL as pool_limit,
		 NULL as frequency, 
		 NULL as template_id,
		 billing_account_cdp.BILLING_ACCOUNT as billing_account_id
		 FROM 
		 billing_account_cdp
		 INNER join service_profile_config_cdp ON service_profile_config_cdp.BUID=billing_account_cdp.BUID
		 INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_map_user_sim_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_map_user_sim_order`(
	IN `in_map_user_sim_id` INT,
	IN `in_order_number_id` int,
	IN `in_order_shipping_id` INT
)
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 AS RETURNED_SQLSTATE  , @p2 AS MESSAGE_TEXT;	
	ROLLBACK;
END;
START TRANSACTION;
   
   
   
  
   
SELECT 
	ROW_NUMBER() OVER () +in_map_user_sim_id 	AS `id`,
	CREATE_BY 					AS ordered_by,	
	IF(END_DATE='' OR END_DATE='null' OR END_DATE IS NULL,NOW(),END_DATE)	AS status_updated_date,
	
	(CASE 	WHEN IS_ESIM=0 THEN '6'
		WHEN IS_ESIM=1 THEN '5'	 END ) AS sim_category_id, 	 
		

IF (start_date= 'null', NULL,STR_TO_DATE(LEFT(start_date,22),'%Y-%m-%d %H:%i:%s')) AS create_date ,
	NULL   						AS final_price,
	NULL  						AS extra_metadata,
	
	ROW_NUMBER() OVER () +in_order_number_id 	as order_number,
	billing_account_cdp.BILLING_ACCOUNT   		AS account_id,
	(CASE 
	WHEN STATUS='Proceeding'		 	THEN 'InProgress'
	WHEN STATUS='PENDING_CANCELLATION'		THEN 'Cancelled'
	WHEN STATUS='Delivered'				THEN 'Delivered'
	WHEN STATUS='Rejected'				THEN 'Declined'
	WHEN STATUS='Closed'				THEN 'Delivered'
	WHEN STATUS='Cancelled'				THEN 'Cancelled'
	WHEN STATUS='Waiting for AP fingerprint' 	THEN 'Completed'
	WHEN STATUS='Accepted'				THEN 'Completed'
	WHEN STATUS='Shipped'				THEN 'Completed'
	ELSE '' END)					 AS order_status,	
	SIM_QUANTITY				 	 AS quantity,
	   '15'						 AS per_unit_price,
	ROW_NUMBER() OVER () + in_order_shipping_id				 AS order_shipping_id, 
	   '1'						 AS is_standard,
	   '0'						 AS is_express,
	(CASE 	
		WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Local Data' THEN '830' 
		WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Voice and Internet' THEN '831' 
		WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Data with Internet' THEN '05X' 	
	ELSE '' END
	) 					 	  AS order_sim_category,
	 '0'						  AS auto_activation,
	  NULL AS data_plan_id,
	  NULL AS service_plan_id,
	  NULL AS REMARKS,
	  sim1.title AS CUSTOM_PARAM_1,
	  NULL AS CUSTOM_PARAM_2,
	  NULL AS CUSTOM_PARAM_3,
	  NULL AS CUSTOM_PARAM_4,
	  NULL AS CUSTOM_PARAM_5,
	  NULL AS CUSTOM_PARAM_6,
	  0  AS DELETED,
	  NULL AS DELETED_DATE,
	  0 AS TERMS_CONDITIONS,
	  0 AS IS_BLANK_SIM,
	  NULL  AS `STATUS`,
	  IF(awb_number='null' OR awb_number='',NULL,awb_number)  AS awb_number,
	  0 AS isOrderSentInSheet 	
FROM sim_order_cdp 
LEFT JOIN billing_account_cdp billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID
AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
LEFT JOIN `migration_order_shipping_status` m2 ON m2.ordernumber=sim_order_cdp.ID
LEFT JOIN (SELECT DISTINCT BU_ID,Ordertx_id,SIMPRODUCT_ID
 FROM assets_cdp ) a2 ON a2.BU_ID=sim_order_cdp.BU_ID
AND  a2.Ordertx_id=sim_order_cdp.ID
LEFT JOIN `sim_products_cdp` sim1 ON sim1.sim_product_id=a2.SIMPRODUCT_ID
;
 
    
    
    
   
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_order_shipping_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_order_shipping_status`( 
    IN in_order_shipping_id INT
    )
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 AS RETURNED_SQLSTATE  , @p2 AS MESSAGE_TEXT;	
	ROLLBACK;
END;
START TRANSACTION;
   
    
SELECT 
  ROW_NUMBER() OVER () +in_order_shipping_id				AS `id`,
  s1.ID							        	as ordernumber,
  IF(END_DATE='' OR END_DATE='null' OR END_DATE=NULL,NOW(),END_DATE) 	AS `updated_date`,
  NULL 									AS `shipped_at`,
  IFNULL(STR_TO_DATE(LEFT(start_date,22),'%d-%b-%y %h.%i.%s'),NOW()) 	AS `create_date`,
  IFNULL(STR_TO_DATE(LEFT(EXPECTED_DELIVERY_DATE,22),'%d-%b-%y %h.%i.%s'),NOW())  AS `target_delivery_date`,
  NULL 									AS `extra_metadata`,
  SIM_ORDER_CUST_DELIVERY_CITY 						AS `city`,
  SIM_ORDER_CUST_DELIVERY_AREA 						AS `state`,
  195 									AS `country_id`,
  SIM_ORDER_CUST_DELVRY_POST_COD 					AS `pincode`,
  SIM_ORDER_CUST_DELIV_LOCA_APAR 					AS `shipping_to_address1`,
  SIM_ORDER_CUST_DELIVERY_PO_BOX 					AS `shipping_to_address2`,
  c1.LOGIN 								AS `shipping_to_name`,
  SIM_ORDER_CUST_RECIPENT_PHN_NM 					AS `shipping_to_mobile`,
  SIM_ORDER_CUST_RECIPENT_PHN_NM					AS `shipping_to_phone`,
  SIM_ORDER_CUST_DELIVERY_COMPNY 					AS `shipping_vendor_details`,
  c1.Email 								AS `shipping_email` 
FROM`sim_order_cdp` s1
LEFT JOIN `users_details_cdp` c1 ON s1.CREATE_BY=c1.USER_ID
;
    
    
    
   
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_sim_event_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_sim_event_log`(
	IN `in_sim_event_log_id` INT,
	IN `in_map_user_sim_id` INT
)
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 AS RETURNED_SQLSTATE  , @p2 AS MESSAGE_TEXT;	
	ROLLBACK;
END;
START TRANSACTION;

SELECT 
ROW_NUMBER() OVER () +in_sim_event_log_id 	AS id,
 order_id,
account_id,
sim_type,
imsi,
`EVENT`,
start_time,
triggered_by,
triggered_user_type,
completion_time,
extra_metadata,
CREATE_DATE,
request_number
from
(
SELECT 
	 ROW_NUMBER() OVER () +in_map_user_sim_id 	AS order_id,

	billing_account_cdp.BILLING_ACCOUNT   		AS account_id,    
	(CASE 	WHEN sim_order_cdp.IS_ESIM=0 THEN '4'
		WHEN sim_order_cdp.IS_ESIM=1 THEN '3'	 END )	 	AS sim_type,
	a2.`imsi`					AS imsi,
	(CASE 
	WHEN a2.sim_status='2' THEN 'InProgress'
	WHEN a2.sim_status='5' THEN 'STATECHANGE'
	WHEN a2.sim_status='A' THEN 'Activation'
	WHEN a2.sim_status='S' THEN 'STATECHANGE'
	WHEN a2.sim_status='S' THEN 'STATECHANGE'
	ELSE '' END) 					AS `event`,
	
	(CASE 
	WHEN a2.sim_status='2' THEN CREATIONDATE
	WHEN a2.sim_status='5' THEN CREATIONDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN CREATIONDATE
	ELSE '' END) 
							AS start_time ,    
        (CASE 
	WHEN a2.sim_status='2' THEN 'gtadmin'
	WHEN a2.sim_status='5' THEN 'gtadmin'
	WHEN a2.sim_status='A' THEN 'KSA_OPCO'
	WHEN a2.sim_status='S' THEN 'gtadmin'
	ELSE '' END)  					AS triggered_by,
		
	(CASE 
	WHEN a2.sim_status='2' THEN 0
	WHEN a2.sim_status='5' THEN 1
	WHEN a2.sim_status='A' THEN 1
	WHEN a2.sim_status='S' THEN 1
	ELSE '' END)  AS triggered_user_type,
	(CASE 
	WHEN a2.sim_status='2' THEN LASTMODIFDATE
	WHEN a2.sim_status='5' THEN LASTMODIFDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN LASTMODIFDATE
	ELSE '' END)  				 AS `completion_time`,
	(CASE 
	WHEN a2.sim_status='2' THEN NULL 
	WHEN a2.sim_status='5' THEN '{"Status": "SUCCESSFUL", "New Value": "TestReady", "Old Value": "Warm"}'
	WHEN a2.sim_status='A' THEN '{"Status": "SUCCESSFUL", "New Value": "Activated", "Old Value": "TestReady"}'
	WHEN a2.sim_status='S' THEN '{"Status": "SUCCESSFUL", "New Value": "Suspended", "Old Value": "Activated"}'
	ELSE '' END) AS	`extra_metadata`,
	CREATIONDATE AS `CREATE_DATE`,
	NULL AS`request_number` 
FROM sim_order_cdp 
LEFT JOIN `billing_account_cdp` billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
LEFT JOIN assets_cdp a2  ON a2.BU_ID=sim_order_cdp.BU_ID AND  a2.Ordertx_id=sim_order_cdp.ID
union
SELECT 
	 ROW_NUMBER() OVER () +in_map_user_sim_id 	AS order_id,
	
	billing_account_cdp.BILLING_ACCOUNT   		AS account_id,    
	(CASE 	WHEN sim_order_cdp.IS_ESIM=0 THEN '4'
		WHEN sim_order_cdp.IS_ESIM=1 THEN '3'	 END )	 	AS sim_type,
	a2.`imsi`					AS imsi,
	(CASE 
	WHEN a3.AP_FP_STATUS='1' THEN 'APverification'	
	ELSE '' END) 					AS `event`,
	
	(CASE 
	WHEN a2.sim_status='2' THEN CREATIONDATE
	WHEN a2.sim_status='5' THEN CREATIONDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN CREATIONDATE
	ELSE '' END) 
							AS start_time ,    
        (CASE 
	WHEN a2.sim_status='2' THEN 'gtadmin'
	WHEN a2.sim_status='5' THEN 'gtadmin'
	WHEN a2.sim_status='A' THEN 'KSA_OPCO'
	WHEN a2.sim_status='S' THEN 'gtadmin'
	ELSE '' END)  					AS triggered_by,
		
	(CASE 
	WHEN a2.sim_status='2' THEN 0
	WHEN a2.sim_status='5' THEN 1
	WHEN a2.sim_status='A' THEN 1
	WHEN a2.sim_status='S' THEN 1
	ELSE '' END)  AS triggered_user_type,
	(CASE 
	WHEN a2.sim_status='2' THEN LASTMODIFDATE
	WHEN a2.sim_status='5' THEN LASTMODIFDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN LASTMODIFDATE
	ELSE '' END)  				 AS `completion_time`,
	(CASE 
	WHEN a2.sim_status='2' THEN NULL 
	WHEN a2.sim_status='5' THEN '{"Status": "SUCCESSFUL", "New Value": "TestReady", "Old Value": "Warm"}'
	WHEN a2.sim_status='A' THEN '{"Status": "SUCCESSFUL", "New Value": "Activated", "Old Value": "TestReady"}'
	WHEN a2.sim_status='S' THEN '{"Status": "SUCCESSFUL", "New Value": "Suspended", "Old Value": "Activated"}'
	ELSE '' END) AS	`extra_metadata`,
	CREATIONDATE AS `CREATE_DATE`,
	NULL AS`request_number` 
FROM sim_order_cdp 
LEFT JOIN `billing_account_cdp` billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
LEFT JOIN assets_cdp a2  ON a2.BU_ID=sim_order_cdp.BU_ID AND  a2.Ordertx_id=sim_order_cdp.ID
left join SIM_Orders_AP_FP_Status a3 on a3.ORDER_ID=sim_order_cdp.SIM_ORDER_OPCO_CUST_ORDER_ID
)t;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_sim_event_log_old` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_sim_event_log_old`( 
    IN in_sim_event_log_id INT
    )
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 AS RETURNED_SQLSTATE  , @p2 AS MESSAGE_TEXT;	
	ROLLBACK;
END;
START TRANSACTION;
SELECT 
	ROW_NUMBER() OVER () +in_sim_event_log_id 	AS id,
	sim_order_cdp.ID   				AS order_id,
	billing_account_cdp.BILLING_ACCOUNT   		AS account_id,    
	(CASE 	WHEN sim_order_cdp.IS_ESIM=0 THEN '4'
		WHEN sim_order_cdp.IS_ESIM=1 THEN '3'	 END )	 	AS sim_type,
	a2.`imsi`					AS imsi,
	(CASE 
	WHEN a2.sim_status='2' THEN 'InProgress'
	WHEN a2.sim_status='5' THEN 'STATECHANGE'
	WHEN a2.sim_status='A' THEN 'Activation'
	WHEN a2.sim_status='S' THEN 'STATECHANGE'
	WHEN a2.sim_status='S' THEN 'STATECHANGE'
	ELSE '' END) 					AS `event`,
	
	(CASE 
	WHEN a2.sim_status='2' THEN CREATIONDATE
	WHEN a2.sim_status='5' THEN CREATIONDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN CREATIONDATE
	ELSE '' END) 
							AS start_time ,    
        (CASE 
	WHEN a2.sim_status='2' THEN 'gtadmin'
	WHEN a2.sim_status='5' THEN 'gtadmin'
	WHEN a2.sim_status='A' THEN 'KSA_OPCO'
	WHEN a2.sim_status='S' THEN 'gtadmin'
	ELSE '' END)  					AS triggered_by,
		
	(CASE 
	WHEN a2.sim_status='2' THEN 0
	WHEN a2.sim_status='5' THEN 1
	WHEN a2.sim_status='A' THEN 1
	WHEN a2.sim_status='S' THEN 1
	ELSE '' END)  AS triggered_user_type,
	(CASE 
	WHEN a2.sim_status='2' THEN LASTMODIFDATE
	WHEN a2.sim_status='5' THEN LASTMODIFDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN LASTMODIFDATE
	ELSE '' END)  				 AS `completion_time`,
	(CASE 
	WHEN a2.sim_status='2' THEN NULL 
	WHEN a2.sim_status='5' THEN '{"Status": "SUCCESSFUL", "New Value": "TestReady", "Old Value": "Warm"}'
	WHEN a2.sim_status='A' THEN '{"Status": "SUCCESSFUL", "New Value": "Activated", "Old Value": "TestReady"}'
	WHEN a2.sim_status='S' THEN '{"Status": "SUCCESSFUL", "New Value": "Suspended", "Old Value": "Activated"}'
	ELSE '' END) AS	`extra_metadata`,
	CREATIONDATE AS `CREATE_DATE`,
	NULL AS`request_number` 
FROM sim_order_cdp 
LEFT JOIN `billing_account_cdp` billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
LEFT JOIN assets_cdp a2  ON a2.BU_ID=sim_order_cdp.BU_ID AND  a2.Ordertx_id=sim_order_cdp.ID
union
SELECT 
	ROW_NUMBER() OVER () +in_sim_event_log_id 	AS id,
	sim_order_cdp.ID   				AS order_id,
	billing_account_cdp.BILLING_ACCOUNT   		AS account_id,    
	(CASE 	WHEN sim_order_cdp.IS_ESIM=0 THEN '4'
		WHEN sim_order_cdp.IS_ESIM=1 THEN '3'	 END )	 	AS sim_type,
	a2.`imsi`					AS imsi,
	(CASE 
	WHEN a3.AP_FP_STATUS='1' THEN 'APverification'	
	ELSE '' END) 					AS `event`,
	
	(CASE 
	WHEN a2.sim_status='2' THEN CREATIONDATE
	WHEN a2.sim_status='5' THEN CREATIONDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN CREATIONDATE
	ELSE '' END) 
							AS start_time ,    
        (CASE 
	WHEN a2.sim_status='2' THEN 'gtadmin'
	WHEN a2.sim_status='5' THEN 'gtadmin'
	WHEN a2.sim_status='A' THEN 'KSA_OPCO'
	WHEN a2.sim_status='S' THEN 'gtadmin'
	ELSE '' END)  					AS triggered_by,
		
	(CASE 
	WHEN a2.sim_status='2' THEN 0
	WHEN a2.sim_status='5' THEN 1
	WHEN a2.sim_status='A' THEN 1
	WHEN a2.sim_status='S' THEN 1
	ELSE '' END)  AS triggered_user_type,
	(CASE 
	WHEN a2.sim_status='2' THEN LASTMODIFDATE
	WHEN a2.sim_status='5' THEN LASTMODIFDATE
	WHEN a2.sim_status='A' THEN NULL
	WHEN a2.sim_status='S' THEN LASTMODIFDATE
	ELSE '' END)  				 AS `completion_time`,
	(CASE 
	WHEN a2.sim_status='2' THEN NULL 
	WHEN a2.sim_status='5' THEN '{"Status": "SUCCESSFUL", "New Value": "TestReady", "Old Value": "Warm"}'
	WHEN a2.sim_status='A' THEN '{"Status": "SUCCESSFUL", "New Value": "Activated", "Old Value": "TestReady"}'
	WHEN a2.sim_status='S' THEN '{"Status": "SUCCESSFUL", "New Value": "Suspended", "Old Value": "Activated"}'
	ELSE '' END) AS	`extra_metadata`,
	CREATIONDATE AS `CREATE_DATE`,
	NULL AS`request_number` 
FROM sim_order_cdp 
LEFT JOIN `billing_account_cdp` billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
LEFT JOIN assets_cdp a2  ON a2.BU_ID=sim_order_cdp.BU_ID AND  a2.Ordertx_id=sim_order_cdp.ID
left join SIM_Orders_AP_FP_Status a3 on a3.ORDER_ID=sim_order_cdp.SIM_ORDER_OPCO_CUST_ORDER_ID;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_sim_provisioned_range_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_sim_provisioned_range_details`(in in_sim_provisioned_range_id int)
BEGIN
SELECT 
 ROW_NUMBER() OVER () +in_sim_provisioned_range_id AS `ID`,
IF(assets_cdp.ACTIVATIONDATE='0001-01-01 00:00:00',NOW(),ACTIVATIONDATE) AS CREATE_DATE,
assets_cdp.ICCID  AS ICCID,
assets_cdp.IMSI   AS IMSI,
assets_cdp.MSISDN AS MSISDN,
assets_cdp.ICCID  AS DONOR_ICCID,
assets_cdp.IMSI   AS  DONOR_IMSI,
assets_cdp.MSISDN AS DONOR_MSISDN,
NULL AS EUICC_ID,
NULL AS  SIM_TYPE,
'Y' AS ALLOCATE_STATUS,
NULL AS RANGE_ID,   
NULL AS EXT_METADATA,
NULL order_number,
billing_account_cdp.BILLING_ACCOUNT	AS account_id
FROM assets_cdp INNER JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID
INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=billing_account_cdp.CUSTOMER_ID 

GROUP BY assets_cdp.IMSI;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_sim_range` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_sim_range`(
	IN `in_sim_range_id` INT,
	IN `in_opco_id` INT,
	IN `in_map_user_sim_id` INT,
	IN `in_order_number` INT
)
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 AS RETURNED_SQLSTATE  , @p2 AS MESSAGE_TEXT;	
	ROLLBACK;
END;
START TRANSACTION;

    
DROP TABLE IF EXISTS imsi_range_cdp_tmp;  
CREATE TABLE imsi_range_cdp_tmp (
  CTX_ID INT DEFAULT NULL,
  POOL_ID INT DEFAULT NULL,
  CRMCUSTOMER_ID INT DEFAULT NULL,
  IMSI_START VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  IMSI_END VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  ICCID_START BIGINT DEFAULT NULL,
  ICCID_END BIGINT DEFAULT NULL,
  IMSI_RANGE_TOTAL_SIM_COUNT INT DEFAULT NULL,
  RANGE_MIN VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  RANGE_MAX VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  FREE_SIM_COUNT BIGINT DEFAULT NULL,
  rnk INT DEFAULT NULL,
  KEY imsi_range_cdp_tmp_01 (rnk),
  KEY imsi_range_cdp_tmp_02 (CRMCUSTOMER_ID)
) ENGINE=INNODB ;
TRUNCATE TABLE `stc_migration`.`imsi_range_cdp_tmp` ;
INSERT INTO `stc_migration`.`imsi_range_cdp_tmp` (
  `CTX_ID`,
  `POOL_ID`,
  `CRMCUSTOMER_ID`,
  `IMSI_START`,
  `IMSI_END`,
  `ICCID_START`,
  `ICCID_END`,
  `IMSI_RANGE_TOTAL_SIM_COUNT`,
  `RANGE_MIN`,
  `RANGE_MAX`,
  `FREE_SIM_COUNT`,
  `rnk`
) 
SELECT 
    `CTX_ID`,
    `POOL_ID`,
    `CRMCUSTOMER_ID`,
    `IMSI_START`,
     IMSI_START +(IMSI_RANGE_TOTAL_SIM_COUNT-free_sim_count)-1 AS `IMSI_END`,
    `ICCID_START`,
    `ICCID_START`+(IMSI_RANGE_TOTAL_SIM_COUNT-free_sim_count)-1 AS `ICCID_END`,
    `IMSI_RANGE_TOTAL_SIM_COUNT`,
    `RANGE_MIN`,
    `RANGE_MIN`+(IMSI_RANGE_TOTAL_SIM_COUNT-free_sim_count) AS RANGE_MAX,
    IMSI_RANGE_TOTAL_SIM_COUNT-free_sim_count AS FREE_SIM_COUNT,
    1 AS rnk
FROM
    `stc_migration`.`imsi_range_cdp`     
UNION ALL
SELECT 
    `CTX_ID`,
    `POOL_ID`,
    `CRMCUSTOMER_ID`,
    `IMSI_END`-free_sim_count+1 AS `IMSI_START`,
    `IMSI_END`,
    ICCID_END-free_sim_count+1 AS `ICCID_START`,
    `ICCID_END`,
    `IMSI_RANGE_TOTAL_SIM_COUNT`,
    `RANGE_MAX`-free_sim_count AS RANGE_MIN,
    `RANGE_MAX`,
    `FREE_SIM_COUNT`,
    2 AS rnk
FROM
    `stc_migration`.`imsi_range_cdp`
 ; 
    
DROP TABLE IF EXISTS sim_range_tmp;
CREATE TABLE IF NOT EXISTS `sim_range_tmp` (
  `CREATE_DATE` DATETIME NOT NULL,
  `BATCH_NUMBER` DOUBLE DEFAULT NULL,
  `ACCOUNT_ID` INT NOT NULL DEFAULT '0',
  `ORDER_ID` VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NAME` VARCHAR(25) CHARACTER SET utf8mb3 DEFAULT NULL,
  `DESCRIPTION` VARCHAR(14) CHARACTER SET utf8mb3 NOT NULL DEFAULT '',
  `SIM_START` BINARY(0) DEFAULT NULL,
  `SIM_RANGE_FROM` BINARY(0) DEFAULT NULL,
  `SIM_RANGE_TO` BINARY(0) DEFAULT NULL,
  `SIM_TYPE` VARCHAR(3) CHARACTER SET utf8mb3 NOT NULL DEFAULT '',
  `SIM_COUNT` INT DEFAULT NULL,
  `SIM_CATEGORY` VARCHAR(8) CHARACTER SET utf8mb3 DEFAULT NULL,
  `ICCID_FROM` BIGINT DEFAULT NULL,
  `ICCID_TO` BIGINT DEFAULT NULL,
  `SENDER` BINARY(0) DEFAULT NULL,
  `ALLOCATE_TO` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ALLOCATE_DATE` DATETIME NOT NULL,
  `RANGE_AVAILABLE` VARCHAR(1) CHARACTER SET utf8mb3 NOT NULL DEFAULT '',
  `IS_NEW` VARCHAR(1) CHARACTER SET utf8mb3 NOT NULL DEFAULT '',
  `DELETED` INT NOT NULL DEFAULT '0',
  `DELETED_DATE` BINARY(0) DEFAULT NULL,
  `IMSI_FROM` BIGINT DEFAULT NULL,
  `IMSI_TO` BIGINT DEFAULT NULL,
  `MSISDN_FROM` BINARY(0) DEFAULT NULL,
  `MSISDN_TO` BINARY(0) DEFAULT NULL,
  `ORDER_NUMBER` VARCHAR(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ICCID_COUNT` BIGINT DEFAULT NULL,
  `IMSI_COUNT` BIGINT DEFAULT NULL,
  `MSISDN_COUNT` BINARY(0) DEFAULT NULL,
  `BILLING_ACCOUNT_ID` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `STATUS` BINARY(0) DEFAULT NULL,
  `TRANSACTION_ID` BINARY(0) DEFAULT NULL,
  `EXTRA_METADATA` BINARY(0) DEFAULT NULL,
  `donor_iccid` BINARY(0) DEFAULT NULL,
  KEY idx1(ICCID_TO),
  KEY idx2(IMSI_TO),
  KEY idx3 (BILLING_ACCOUNT_ID)
) ENGINE=INNODB ;
TRUNCATE TABLE `sim_range_tmp`;
INSERT INTO `sim_range_tmp` (
  `CREATE_DATE`,
  `BATCH_NUMBER`,
  `ACCOUNT_ID`,
  `ORDER_ID`,
  `NAME`,
  `DESCRIPTION`,
  `SIM_START`,
  `SIM_RANGE_FROM`,
  `SIM_RANGE_TO`,
  `SIM_TYPE`,
  `SIM_COUNT`,
  `SIM_CATEGORY`,
  `ICCID_FROM`,
  `ICCID_TO`,
  `SENDER`,
  `ALLOCATE_TO`,
  `ALLOCATE_DATE`,
  `RANGE_AVAILABLE`,
  `IS_NEW`,
  `DELETED`,
  `DELETED_DATE`,
  `IMSI_FROM`,
  `IMSI_TO`,
  `MSISDN_FROM`,
  `MSISDN_TO`,
  `ORDER_NUMBER`,
  `ICCID_COUNT`,
  `IMSI_COUNT`,
  `MSISDN_COUNT`,
  `BILLING_ACCOUNT_ID`,
  `STATUS`,
  `TRANSACTION_ID`,
  `EXTRA_METADATA`,
  `donor_iccid`
) 
SELECT 
	
	NOW() AS `CREATE_DATE`,
	DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')+ROW_NUMBER() OVER() AS `BATCH_NUMBER`, 
	in_opco_id AS `ACCOUNT_ID`, 
	sim_order_cdp.ID AS `ORDER_ID`,
	CONCAT('Pool',ROW_NUMBER() OVER()) AS `NAME`, 
	'migration pool' AS `DESCRIPTION`,
	NULL AS `SIM_START`,
	NULL AS `SIM_RANGE_FROM`,
	NULL AS `SIM_RANGE_TO`, 
	(CASE 	
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Local Data' THEN '830' 
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Voice and Internet' THEN '831' 
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Data with Internet' THEN '05X' 	
	ELSE '' END) AS `SIM_TYPE`, 	
	imsi_range_cdp_tmp.IMSI_RANGE_TOTAL_SIM_COUNT AS `SIM_COUNT`, 
	 (CASE 	WHEN IS_ESIM=0 THEN 'Physical'
		WHEN IS_ESIM=1 THEN 'ESIM'
	 END ) AS `SIM_CATEGORY`, 
	SIM_ORDER_OPCO_FIRST_ICCID AS ICCID_FROM,
	(SIM_ORDER_OPCO_FIRST_ICCID +SIM_QUANTITY)-1  AS ICCID_TO,
	NULL AS `SENDER`, 
	billing_account_cdp.BILLING_ACCOUNT AS `ALLOCATE_TO`,	
	NOW() AS  `ALLOCATE_DATE`,
	'0' AS  `RANGE_AVAILABLE`, 
	'0' AS  `IS_NEW`,
	0 AS  `DELETED`,
	NULL AS 	 `DELETED_DATE`,
	SIM_ORDER_FROM_OPCO_FIRST_IMSI  			AS  `IMSI_FROM`, 
        (SIM_ORDER_FROM_OPCO_FIRST_IMSI+SIM_QUANTITY)-1  	AS  `IMSI_TO`, 
	NULL AS	  `MSISDN_FROM`, 
	NULL AS	  `MSISDN_TO`, 
	sim_order_cdp.ID AS  `ORDER_NUMBER`, 
	sim_order_cdp.SIM_QUANTITY  AS   `ICCID_COUNT`, 
	sim_order_cdp.SIM_QUANTITY  AS   `IMSI_COUNT`,  
	NULL AS 	  `MSISDN_COUNT`, 
	billing_account_cdp.BILLING_ACCOUNT AS 	  `BILLING_ACCOUNT_ID`, 
	NULL AS  `STATUS`, 
	NULL AS  `TRANSACTION_ID`, 
	NULL AS  `EXTRA_METADATA`, 
	NULL AS  `donor_iccid` 		
FROM sim_order_cdp 
INNER JOIN imsi_range_cdp_tmp  ON sim_order_cdp.CUSTOMER_ID=imsi_range_cdp_tmp.CRMCUSTOMER_ID
INNER JOIN billing_account_cdp billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID
AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
WHERE rnk=1
GROUP BY imsi_range_cdp_tmp.CRMCUSTOMER_ID,rnk,SIM_ORDER_OPCO_FIRST_ICCID,SIM_ORDER_FROM_OPCO_FIRST_IMSI
;
 
 
 
 
SELECT 
  ROW_NUMBER() OVER () +in_sim_range_id AS `ID`,
  t1.CREATE_DATE,
  t1.BATCH_NUMBER,
  t1.ACCOUNT_ID,
 ROW_NUMBER() OVER () +in_map_user_sim_id AS ORDER_ID,
  t1.NAME,
  t1.DESCRIPTION,
  t1.SIM_START,
  t1.SIM_RANGE_FROM,
  t1.SIM_RANGE_TO,
  t1.SIM_TYPE,
  t1.SIM_COUNT,
  t1.SIM_CATEGORY,
  t1.ICCID_FROM,
  t1.ICCID_TO,
  t1.SENDER,
  t1.ALLOCATE_TO,
  t1.ALLOCATE_DATE,
  t1.RANGE_AVAILABLE,
  t1.IS_NEW,
  t1.DELETED,
  t1.DELETED_DATE,
  t1.IMSI_FROM,
  t1.IMSI_TO,
  t1.MSISDN_FROM,
  t1.MSISDN_TO,
  t1.ORDER_NUMBER,
  t1.ICCID_COUNT,
  t1.IMSI_COUNT,
  t1.MSISDN_COUNT,
  t1.BILLING_ACCOUNT_ID,
  t1.STATUS,
  t1.TRANSACTION_ID,
  t1.EXTRA_METADATA,
  t1.donor_iccid
FROM
(
SELECT 
  `CREATE_DATE`,
  `BATCH_NUMBER`,
  `ACCOUNT_ID`,
  `ORDER_ID`,
  `NAME`,
  `DESCRIPTION`,
  `SIM_START`,
  `SIM_RANGE_FROM`,
  `SIM_RANGE_TO`,
  `SIM_TYPE`,
  `SIM_COUNT`,
  `SIM_CATEGORY`,
  `ICCID_FROM`,
  `ICCID_TO`,
  `SENDER`,
  `ALLOCATE_TO`,
  `ALLOCATE_DATE`,
  `RANGE_AVAILABLE`,
  `IS_NEW`,
  `DELETED`,
  `DELETED_DATE`,
  `IMSI_FROM`,
  `IMSI_TO`,
  `MSISDN_FROM`,
  `MSISDN_TO`,
  	ROW_NUMBER() OVER () + in_order_number	 AS `ORDER_NUMBER`,
  `ICCID_COUNT`,
  `IMSI_COUNT`,
  `MSISDN_COUNT`,
  `BILLING_ACCOUNT_ID`,
  `STATUS`,
  `TRANSACTION_ID`,
  `EXTRA_METADATA`,
  `donor_iccid` 
FROM
  `stc_migration`.`sim_range_tmp` 
UNION
SELECT 
	NOW() 							AS `CREATE_DATE`,
	DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')+ROW_NUMBER() OVER() 	AS `BATCH_NUMBER`, 
	in_opco_id 						AS `ACCOUNT_ID`, 
	NULL AS `ORDER_ID`,
	CONCAT('Pool',ROW_NUMBER() OVER()) 			AS `NAME`, 
	'migration pool' 				        AS `DESCRIPTION`,
	NULL AS `SIM_START`,
	NULL AS `SIM_RANGE_FROM`,
	NULL AS `SIM_RANGE_TO`, 
	(CASE 	
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Local Data' THEN '830' 
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Voice and Internet' THEN '831' 
	WHEN sim_order_cdp.SIM_ORDER_CATEGORY='M2M Data with Internet' THEN '05X' 	
	ELSE '' END) 						AS `SIM_TYPE`, 
	imsi_range_cdp_tmp.IMSI_RANGE_TOTAL_SIM_COUNT 		AS `SIM_COUNT`, 
	(CASE 	WHEN IS_ESIM=0 THEN 'Physical'
		WHEN IS_ESIM=1 THEN 'ESIM'
	 END )	 						AS `SIM_CATEGORY`, 
	(SELECT MAX(ICCID_TO)+1
	FROM sim_range_tmp 
	WHERE ALLOCATE_TO=billing_account_cdp.BILLING_ACCOUNT) 	AS ICCID_FROM,	
	
	(SELECT MAX(ICCID_TO)+imsi_range_cdp_tmp.FREE_SIM_COUNT
	FROM sim_range_tmp 
	WHERE ALLOCATE_TO=billing_account_cdp.BILLING_ACCOUNT) 	AS ICCID_TO,	
	NULL AS `SENDER`, 
	billing_account_cdp.customer_reference 			AS `ALLOCATE_TO`,	
	NOW() 							AS  `ALLOCATE_DATE`,
	'1' 							AS  `RANGE_AVAILABLE`, 
	'1' 							AS  `IS_NEW`,
	0 							AS  `DELETED`,
	NULL 							AS  `DELETED_DATE`,	
	(SELECT MAX(IMSI_TO)+1
	FROM sim_range_tmp 
	WHERE ALLOCATE_TO=billing_account_cdp.BILLING_ACCOUNT) 	AS IMSI_FROM,	
	
	(SELECT MAX(IMSI_TO)+imsi_range_cdp_tmp.FREE_SIM_COUNT
	FROM sim_range_tmp 
	WHERE ALLOCATE_TO=billing_account_cdp.BILLING_ACCOUNT) 	AS IMSI_TO,
	
	NULL 							AS `MSISDN_FROM`, 
	NULL 							AS `MSISDN_TO`, 
	ROW_NUMBER() OVER () + in_order_number					AS  `ORDER_NUMBER`, 
	imsi_range_cdp_tmp.FREE_SIM_COUNT  AS   `ICCID_COUNT`, 
	imsi_range_cdp_tmp.FREE_SIM_COUNT  AS    `IMSI_COUNT`, 
	
	NULL 							AS   `MSISDN_COUNT`, 
	billing_account_cdp.CUSTOMER_REFERENCE 			AS  `BILLING_ACCOUNT_ID`, 
	NULL AS  `STATUS`, 
	NULL AS  `TRANSACTION_ID`, 
	NULL AS  `EXTRA_METADATA`, 
	NULL AS  `donor_iccid` 
FROM sim_order_cdp 
INNER JOIN imsi_range_cdp_tmp  ON sim_order_cdp.CUSTOMER_ID=imsi_range_cdp_tmp.CRMCUSTOMER_ID
INNER JOIN billing_account_cdp billing_account_cdp ON billing_account_cdp.BUID =sim_order_cdp.BU_ID
AND billing_account_cdp.CUSTOMER_ID=sim_order_cdp.CUSTOMER_ID
WHERE rnk=2
GROUP BY imsi_range_cdp_tmp.CRMCUSTOMER_ID,rnk
) t1;
   
    
    
    
   
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_tag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_tag`(IN id_in INT)
BEGIN
 SELECT 
 ROW_NUMBER() OVER () +id_in AS id,	
 color_coding,
 NAME,
 notification_uuid,
 description,
 entity_type,
 create_date,
 deleted,
 deleted_date,
 imsi
 FROM (   
SELECT   assets_cdp.CUSTLABEL AS NAME,
	 '#ebeef0' AS color_coding,
	 billing_account_cdp.CUSTOMER_REFERENCE AS notification_uuid,
	 assets_cdp.CUSTLABEL AS description,
	 6 AS entity_type,
	 NULL AS create_date,
	 0 AS deleted,
	 NULL AS deleted_date,
	 assets_cdp.IMSI AS imsi 
	 FROM assets_cdp 
	 INNER JOIN billing_account_cdp ON assets_cdp.EC_ID=billing_account_cdp.CUSTOMER_ID  
UNION ALL
SELECT 
	 assets_cdp.BULABEL AS NAME,
	 '#ebeef0' AS color_coding,
	 billing_account_cdp.BILLING_ACCOUNT AS notification_uuid,
	 assets_cdp.CUSTLABEL AS description,
	 6 AS entity_type,
	 NULL AS create_date,
	 0 AS deleted,
	 NULL AS deleted_date,
	 assets_cdp.IMSI AS imsi 
 
FROM assets_cdp 
INNER JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID 
)tag_details 
WHERE NAME!=NULL OR NAME !=''
GROUP BY NAME,notification_uuid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `migration_tag_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_tag_details`()
BEGIN
    
 SELECT * FROM (   
 SELECT assets_cdp.CUSTLABEL AS tag_name,billing_account_cdp.CUSTOMER_REFERENCE AS notification_uuid,assets_cdp.IMSI AS imsi FROM assets_cdp INNER JOIN billing_account_cdp ON assets_cdp.EC_ID=billing_account_cdp.CUSTOMER_ID  
UNION ALL
 SELECT assets_cdp.BULABEL AS tag_name,billing_account_cdp.BILLING_ACCOUNT AS notification_uuid,assets_cdp.IMSI AS imsi FROM assets_cdp 
INNER JOIN billing_account_cdp ON assets_cdp.BU_ID=billing_account_cdp.BUID )tag_details WHERE tag_name!=NULL OR tag_name !='';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sim_products_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `sim_products_cdp`(
	IN `in_opco_id` INT
)
BEGIN

SELECT 
in_opco_id as accountId,
'' AS customer_name,
title AS productName,
service_type AS `service type`,
'GCT' AS `serviceSubType1`,
service_sub_type_2 AS `serviceSubType2`,
service_sub_type_3 AS `serviceSubType3`,
service_sub_type_4 AS `serviceSubType4`,
packaging_size AS `packagingSize`,
lower(can_be_ordered) AS ordered,
'' AS comments,
GROUP_CONCAT(Distinct CUSTOMER_REFERENCE SEPARATOR " ") as customers
 FROM sim_products_cdp 
 
INNER JOIN billing_account_cdp ON
FIND_IN_SET(sim_products_cdp.sim_product_id,billing_account_cdp.BU_SIM_PRODUCT_IDS)>0 GROUP BY sim_products_cdp.sim_product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sim_provisioned_range_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `sim_provisioned_range_details`()
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
INSERT INTO `stc_migration`.`migration_sim_provisioned_range_details_error_history` (
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
  `CREATE_DATE`,	  `ICCID`,
  `IMSI`,		  `MSISDN`,
  `DONOR_ICCID`,	  `DONOR_IMSI`,
  `DONOR_MSISDN`,	  `EUICC_ID`,
  `SIM_TYPE`,		  `ALLOCATE_STATUS`,
  `RANGE_ID`,		  `EXT_METADATA`,
  `order_number`,	  `account_id`,
  'Invalid CREATE_DATE value' AS Error_Message
 FROM migration_sim_range
 WHERE CREATE_DATE IS NULL OR CREATE_DATE=''; 
 
 
 
 
SELECT COUNT(1) INTO @migration_sim_range FROM `migration_sim_provisioned_range_details`;
SELECT COUNT(1) INTO @before_excution FROM `sim_provisioned_range_details`;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO sim_provisioned_range_details (
  CREATE_DATE,	  ICCID,
  IMSI,		  MSISDN,
  DONOR_ICCID,	  DONOR_IMSI,
  DONOR_MSISDN,	  EUICC_ID,
  SIM_TYPE,	  ALLOCATE_STATUS,
  RANGE_ID,	  EXT_METADATA,
  order_number,	  account_id
) 
SELECT 
  m1.CREATE_DATE,	  m1.ICCID,
  m1.IMSI,		  m1.MSISDN,
  m1.DONOR_ICCID,	  m1.DONOR_IMSI,
  m1.DONOR_MSISDN,	  m1.EUICC_ID,
  m1.SIM_TYPE,		  m1.ALLOCATE_STATUS,
  m1.RANGE_ID,		  m1.EXT_METADATA,
  m1.order_number,	  m1.account_id
 FROM migration_sim_provisioned_range_details m1;
 
 UPDATE sim_provisioned_range_details a1 INNER JOIN sim_range a2
 SET 	a1.RANGE_ID=a2.id
 WHERE  a1.ICCID BETWEEN a2.ICCID_FROM AND a2.ICCID_TO
 and a1.RANGE_ID is null;
 
 
 
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
    
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sim_range_procedure_bulk_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `sim_range_procedure_bulk_insert`()
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
truncate table `stc_migration`.`migration_sim_range_error_history`;
INSERT INTO `stc_migration`.`migration_sim_range_error_history` (
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
 
INSERT INTO `stc_migration`.`migration_sim_range_error_history` (
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
 
INSERT INTO `stc_migration`.`migration_sim_range_error_history` (
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
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `stc_migration`.`sim_range` (
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
LEFT JOIN accounts a1 ON   a1.NOTIFICATION_UUID=m1.Billing_account_id
LEFT JOIN accounts a2 ON  a2.NOTIFICATION_UUID=m1.ALLOCATE_TO
LEFT JOIN `map_user_sim_order` u1 ON m1.ORDER_ID=u1.order_number
;
SET FOREIGN_KEY_CHECKS=1;
SELECT COUNT(1) INTO @after_execution FROM sim_range;
SET @ai := (SELECT MAX(id)+1 FROM sim_range);
SET @qry = CONCAT('alter table sim_range auto_increment=',@ai);
PREPARE stmt FROM @qry; EXECUTE stmt;
SELECT COUNT(1) INTO @success_count FROM sim_range WHERE ID IN (SELECT ID FROM migration_sim_range);
SELECT COUNT(1) INTO @failed_count FROM migration_sim_range WHERE ID NOT IN (SELECT ID FROM sim_range);
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) AS before_excution,
CONCAT('after_execution: ',IFNULL(@after_execution,0)) AS after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) AS success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) AS failed_count,
IFNULL(@MESSAGE_TEXT,'') AS Remarks;
ROLLBACK;
COMMIT;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SplitAndInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `SplitAndInsert`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE bu_part VARCHAR(255);
    DECLARE cdp_apn VARCHAR(255);
    DECLARE pos INT;
    DECLARE bu_parts_cursor CURSOR FOR SELECT BU_ID,CDP_APN_ID FROM apns_cdp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_table (split_bu_id VARCHAR(255), CDP_APN_ID INT);

    OPEN bu_parts_cursor;

    read_loop: LOOP
        FETCH bu_parts_cursor INTO bu_part,cdp_apn;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET pos := 1;
        WHILE pos <= LENGTH(bu_part) - LENGTH(REPLACE(bu_part, '''', '')) + 1 DO
            INSERT INTO temp_table (split_bu_id, CDP_APN_ID) VALUES 
                (SplitString(bu_part, '''', pos), cdp_apn);  
            SET pos := pos + 1;
        END WHILE;
    END LOOP;

    CLOSE bu_parts_cursor;

    SELECT * FROM temp_table;

    DROP TEMPORARY TABLE IF EXISTS temp_table;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SplitBuId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `SplitBuId`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE n INT DEFAULT 2;
    DECLARE bu_part VARCHAR(255);
    DECLARE BU_ID VARCHAR(255);
    DECLARE CDP_APN_ID TEXT;

    DECLARE cur CURSOR FOR
        SELECT BU_ID, CDP_APN_ID FROM apns_cdp;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_table (split_bu_id VARCHAR(255), CDP_APN_ID INT);

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO bu_part, CDP_APN_ID;

        IF done THEN
            LEAVE read_loop;
        END IF;

        WHILE n <= LENGTH(bu_part) - LENGTH(REPLACE(bu_part, '''', '')) + 1 DO
            SET @sql = CONCAT('INSERT INTO temp_table VALUES (''', SUBSTRING_INDEX(SUBSTRING_INDEX(bu_part, '''', n), '''', -1), ''', ', CDP_APN_ID, ');');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET n = n + 1;
        END WHILE;

        SET n = 2; 
    END LOOP;

    CLOSE cur;

    SELECT * FROM temp_table;

   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_split` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `sp_split`(IN toSplit text, IN target char(255))
BEGIN
	
	SET @tableName = 'tmpSplit';
	SET @fieldName = 'variable';

	
	SET @sql := CONCAT('DROP TABLE IF EXISTS ', @tableName);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @sql := CONCAT('CREATE TEMPORARY TABLE ', @tableName, ' (', @fieldName, ' VARCHAR(1000))');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @vars := toSplit;
	SET @vars := CONCAT("('", REPLACE(@vars, ",", "'),('"), "')");

	
	SET @sql := CONCAT('INSERT INTO ', @tableName, ' VALUES ', @vars);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	IF target IS NULL THEN
		SET @sql := CONCAT('SELECT TRIM(`', @fieldName, '`) FROM ', @tableName);
	ELSE
		SET @sql := CONCAT('INSERT INTO ', target, ' SELECT TRIM(`', @fieldName, '`) FROM ', @tableName);
	END IF;

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tag_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `tag_details`()
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
LEFT JOIN assets a2   ON   a2.IMSI=a1.ID
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
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_management_cdp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `user_management_cdp`()
BEGIN
SELECT 
  distinct CPDID,
  primaryPhone,
  secondaryPhone,
  email,
  emailConf,
  roleId,
  countryId,
  timeZoneId,
  LOWER(`locked`) AS `locked`,
  accountId,
  userName,
  groupId,
  userType,
  userAccountType,
  supervisorId,
  lower(resetPasswordAction) AS `resetPasswordAction`,
  firstName,
  lastName FROM ( SELECT 
    users_details_cdp.USER_ID AS CPDID,
    users_details_cdp.MOBILE AS primaryPhone,
    users_details_cdp.PHONE AS secondaryPhone,
    users_details_cdp.EMAIL AS email,
    users_details_cdp.EMAIL as emailConf,
    users_details_cdp.`ROLE`,
    
    users_details_cdp.CUSTOMER_ID,
    users_details_cdp.LOGIN AS userName,
    
    users_details_cdp.FIRST_NAME AS firstName,
    users_details_cdp.LAST_NAME AS lastName,
	 (case when users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' then billing_account_cdp.CUSTOMER_REFERENCE ELSE billing_account_cdp.BILLING_ACCOUNT end) AS accountId,
	 195 as countryId,
    40 as timeZoneId,
    0 as groupId,
    '' as supervisorId,
    'false' as resetPasswordAction,
    1 as userType,
    'NormalUser' AS userAccountType,
    
  case when users_details_cdp.ROLE_NAME='EC_Admin' then 'Admin' when users_details_cdp.ROLE_NAME='EC_User' then 'User' when users_details_cdp.ROLE_NAME='EC_CSA' then 'CSA' when users_details_cdp.ROLE_NAME='EC_Viewer' then 'Viewer' when users_details_cdp.ROLE_NAME='EC_Test_Admin' then 'Test_Admin' when users_details_cdp.ROLE_NAME='EC_Test_User' then 'Test_User' when users_details_cdp.ROLE_NAME='OpCo_AM' then 'AccountManager' when users_details_cdp.ROLE_NAME='Lead Person' then 'LeadPerson' when users_details_cdp.ROLE_NAME='BU_Admin' then 'Admin' when users_details_cdp.ROLE_NAME='BU_User' then 'User' END AS roleId,
   case when users_details_cdp.`STATUS` ='USER_STATUS.ACTIVE' then 'false' when users_details_cdp.`STATUS` ='USER_STATUS.LOCKED' then 'true' END AS `locked`
 	 FROM users_details_cdp INNER JOIN billing_account_cdp ON 
	  
	  (case when users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' then billing_account_cdp.CUSTOMER_ID ELSE billing_account_cdp.BUID END)=(case when users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' then users_details_cdp.CUSTOMER_ID ELSE users_details_cdp.BU_ID END) INNER JOIN acct_att_cdp ON acct_att_cdp.CUSTOMER_ID=users_details_cdp.CUSTOMER_ID
	  
	  ) user_details;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-28 12:17:46
