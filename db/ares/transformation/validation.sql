-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Current Database: `validation`
--

/*!40000 DROP DATABASE IF EXISTS `validation`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `validation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `validation`;

--
-- Table structure for table `apn_error_codes`
--

DROP TABLE IF EXISTS `apn_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_error_codes` (
  `code` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apn_failure`
--

DROP TABLE IF EXISTS `apn_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_failure` (
  `CUSTOMER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PDP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_POOL` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ASSIGNMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `apn_success`
--

DROP TABLE IF EXISTS `apn_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_success` (
  `CUSTOMER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PDP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_POOL` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ASSIGNMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_error_codes`
--

DROP TABLE IF EXISTS `asset_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_error_codes` (
  `code` varchar(3) NOT NULL,
  `message` text,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_failure`
--

DROP TABLE IF EXISTS `asset_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_failure` (
  `IMSI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ICCID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MSISDN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CC_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SESSION_STATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DES_INDEX` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALG_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `KI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PIN1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PIN2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUK1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUK2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ADM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MNOLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCOLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTLABEL` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `BULABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APINSTANCE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LASTMODIFDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATIONDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HIERARCHYDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NETSTATUSDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IMEI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EXPECTED_IMEI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIM_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIGRATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIGRATION_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SESSION_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_METHOD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_USER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_PASS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RSLRLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FREE_TEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `WSGUIDINGCITEM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ORDERTX_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SPCHANGECOUNTER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SPMODIFDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESSINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CELL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFU` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFB` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFNR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFNRY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENODEB_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEVICE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TRIGGER_CONDITION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVE_SUBSCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IPPROTOCOL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IPV6ADDRESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RATTYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVEFROM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SAPNUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_success`
--

DROP TABLE IF EXISTS `asset_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_success` (
  `IMSI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ICCID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MSISDN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CC_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SESSION_STATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DES_INDEX` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALG_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `KI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PIN1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PIN2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUK1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUK2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ADM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MNOLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCOLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTLABEL` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `BULABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APINSTANCE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LASTMODIFDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATIONDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HIERARCHYDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NETSTATUSDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IMEI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EXPECTED_IMEI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIM_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIGRATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIGRATION_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SESSION_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_METHOD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_USER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_PASS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RSLRLABEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FREE_TEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `WSGUIDINGCITEM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ORDERTX_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SPCHANGECOUNTER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SPMODIFDATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IP_ADDRESSINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CELL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFU` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFB` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFNR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CFNRY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENODEB_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEVICE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TRIGGER_CONDITION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVE_SUBSCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IPPROTOCOL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IPV6ADDRESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RATTYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVEFROM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SAPNUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_account_to_tp_mapping_error_codes`
--

DROP TABLE IF EXISTS `bu_account_to_tp_mapping_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_account_to_tp_mapping_error_codes` (
  `CODE` varchar(20) DEFAULT NULL,
  `MESSAGE` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_account_to_tp_mapping_failure`
--

DROP TABLE IF EXISTS `bu_account_to_tp_mapping_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_account_to_tp_mapping_failure` (
  `EXTERNALACCNUMBER` varchar(50) DEFAULT NULL,
  `TARIFFPLAN_ID` bigint NOT NULL,
  `CONTRACTEDFROM` date NOT NULL,
  `CONTRACTEDTO` date DEFAULT NULL,
  `CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_account_to_tp_mapping_success`
--

DROP TABLE IF EXISTS `bu_account_to_tp_mapping_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_account_to_tp_mapping_success` (
  `EXTERNALACCNUMBER` varchar(50) DEFAULT NULL,
  `TARIFFPLAN_ID` bigint NOT NULL,
  `CONTRACTEDFROM` date NOT NULL,
  `CONTRACTEDTO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_error_codes`
--

DROP TABLE IF EXISTS `bu_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_failure`
--

DROP TABLE IF EXISTS `bu_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_failure` (
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUCRM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUBSS_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_CRM_ID` bigint DEFAULT NULL,
  `EC_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_FORWARDING_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `METHOD_OF_PAYMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INVOICING_LEVEL_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_FORWARDING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_CHECK_PIN_SMS_AO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CURRENCY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BSP_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_CONFIRMATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_SALUTATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_COMM_CHAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VALIDITY_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_CUSTOMER_DATA_FOR_BU_INFO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_A_4_DELIVERY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_A_4_BILLING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID_WHO_CHANGE_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_HTTP_END_POINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_EXTERNAL_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIGNATURE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE_IP_TO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE_IP_FROM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROJECT_DESCRIPTION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `PREFERRED_LANGUAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OTP_ENABLED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LAST_OTP_CHANGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LANGUAGE_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IBAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_USER_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_USER_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_REDUCED_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_REDUCED_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_CSA_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_CSA_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_ADMIN_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_ADMIN_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `DEBTOR_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_LABEL_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TPV_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STRING_VALUE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SALESFORCE_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REFERENCE_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_OPCO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEFAULT_IP_POOL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BILLING_CYCLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BINDING_TIME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BIC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BANK_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_URL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ROLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_PHONE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_LAST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FIRST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FAX` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_EMAIL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_STREET_NO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_STREET` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_STATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_PC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_D` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_CITY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCESS_TO_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_success`
--

DROP TABLE IF EXISTS `bu_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_success` (
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUCRM_ID` bigint DEFAULT NULL,
  `BUBSS_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_CRM_ID` bigint DEFAULT NULL,
  `EC_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_FORWARDING_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `METHOD_OF_PAYMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INVOICING_LEVEL_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_FORWARDING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_CHECK_PIN_SMS_AO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CURRENCY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BSP_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_CONFIRMATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_SALUTATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_COMM_CHAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VALIDITY_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_CUSTOMER_DATA_FOR_BU_INFO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_A_4_DELIVERY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_A_4_BILLING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID_WHO_CHANGE_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_HTTP_END_POINT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SMS_FORWARDING_EXTERNAL_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIGNATURE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE_IP_TO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RANGE_IP_FROM` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROJECT_DESCRIPTION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `PREFERRED_LANGUAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OTP_ENABLED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LAST_OTP_CHANGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LANGUAGE_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IBAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_USER_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_USER_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_REDUCED_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_REDUCED_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_CSA_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_CSA_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_ADMIN_T_CONDITIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `EC_ADMIN_T_ACTIONS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `DEBTOR_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATED_LABEL_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TPV_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STRING_VALUE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SALESFORCE_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REFERENCE_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_OPCO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEFAULT_IP_POOL_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BILLING_CYCLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BINDING_TIME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BIC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BANK_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `API_SMS_DELIVERY_URL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ROLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_PHONE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_LAST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FIRST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_FAX` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_EMAIL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_STREET_NO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_STREET` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_STATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_PC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_A_D` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_CITY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCESS_TO_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `combined_tariff_plans`
--

DROP TABLE IF EXISTS `combined_tariff_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `combined_tariff_plans` (
  `CUSTOMER` varchar(255) DEFAULT NULL,
  `TARIFF_PLAN` varchar(255) DEFAULT NULL,
  `TARIFF_PLAN_ID` int DEFAULT NULL,
  `PRODUCT` varchar(255) DEFAULT NULL,
  `PRODUCT_ID` int DEFAULT NULL,
  `IS_USED` varchar(10) DEFAULT NULL,
  `RATING_ELEMENT` varchar(255) DEFAULT NULL,
  `RATING_ELEMENT_ID` int DEFAULT NULL,
  `LIVE_CYCLE` varchar(255) DEFAULT NULL,
  `LIVE_CYCLE_ID` int DEFAULT NULL,
  `SERVICE_PROFILE` varchar(255) DEFAULT NULL,
  `SERVICE_PROFILE_ID` int DEFAULT NULL,
  `POOL` varchar(255) DEFAULT NULL,
  `POOL_SIZE` varchar(50) DEFAULT NULL,
  `POOL_LIMIT` varchar(50) DEFAULT NULL,
  `VALID_FROM` datetime DEFAULT NULL,
  `VALID_TO` datetime DEFAULT NULL,
  `PARAMETER_SET` varchar(255) DEFAULT NULL,
  `PARAMETER_SET_ID` int DEFAULT NULL,
  `RATING_NAME` varchar(255) DEFAULT NULL,
  `RATING_NAME_ID` int DEFAULT NULL,
  `PRICE_PER_UNIT` varchar(50) DEFAULT NULL,
  `UNIT` varchar(50) DEFAULT NULL,
  `INITIAL_SEGMENT` int DEFAULT NULL,
  `SEGMENT` int DEFAULT NULL,
  `RECURRING_TYPE` varchar(50) DEFAULT NULL,
  `PRICING_IN_BUCKET` varchar(50) DEFAULT NULL,
  `FREQUENCY` varchar(50) DEFAULT NULL,
  `RULE_NAMES` varchar(255) DEFAULT NULL,
  `RULES` varchar(255) DEFAULT NULL,
  `CLASSIFICATION_TABLE` varchar(255) DEFAULT NULL,
  `CLASSIFICATION_TABLE_ID` int DEFAULT NULL,
  `COUNTRYZONES` varchar(255) DEFAULT NULL,
  `OFFER_DFROM` datetime DEFAULT NULL,
  `OFFER_DTO` datetime DEFAULT NULL,
  `MIN_CONTRACT_DURATION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_centers_error_codes`
--

DROP TABLE IF EXISTS `cost_centers_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_centers_error_codes` (
  `code` varchar(3) NOT NULL,
  `message` text,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_centers_failure`
--

DROP TABLE IF EXISTS `cost_centers_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_centers_failure` (
  `ROLENAME` text COLLATE utf8mb4_unicode_ci,
  `STATUSNAME` text COLLATE utf8mb4_unicode_ci,
  `CC_NAME` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CCCRM_ID` bigint NOT NULL,
  `CCBSS_ID` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_CRM_ID` double NOT NULL,
  `BU_NAME` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMENTS` text COLLATE utf8mb4_unicode_ci,
  `ADDRESSBILLING` text COLLATE utf8mb4_unicode_ci,
  `COMPANYADDRESS` text COLLATE utf8mb4_unicode_ci,
  `DELIVERYADDRESS` text COLLATE utf8mb4_unicode_ci,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_centers_success`
--

DROP TABLE IF EXISTS `cost_centers_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_centers_success` (
  `ROLENAME` text COLLATE utf8mb4_unicode_ci,
  `STATUSNAME` text COLLATE utf8mb4_unicode_ci,
  `CC_NAME` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CCCRM_ID` bigint NOT NULL,
  `CCBSS_ID` decimal(38,0) DEFAULT NULL,
  `BU_CRM_ID` double NOT NULL,
  `BU_NAME` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMENTS` text COLLATE utf8mb4_unicode_ci,
  `ADDRESSBILLING` text COLLATE utf8mb4_unicode_ci,
  `COMPANYADDRESS` text COLLATE utf8mb4_unicode_ci,
  `DELIVERYADDRESS` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_bill_cycle_error_codes`
--

DROP TABLE IF EXISTS `dic_bill_cycle_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_bill_cycle_error_codes` (
  `CODE` varchar(20) DEFAULT NULL,
  `MESSAGE` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_bill_cycle_failure`
--

DROP TABLE IF EXISTS `dic_bill_cycle_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_bill_cycle_failure` (
  `ID` bigint DEFAULT NULL,
  `BCTYPE` varchar(20) DEFAULT NULL,
  `CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_bill_cycle_success`
--

DROP TABLE IF EXISTS `dic_bill_cycle_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_bill_cycle_success` (
  `ID` bigint DEFAULT NULL,
  `BCTYPE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_new_opco_error_codes`
--

DROP TABLE IF EXISTS `dic_new_opco_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_new_opco_error_codes` (
  `CODE` varchar(20) DEFAULT NULL,
  `MESSAGE` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_new_opco_failure`
--

DROP TABLE IF EXISTS `dic_new_opco_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_new_opco_failure` (
  `CPARTY_ID` bigint DEFAULT NULL,
  `CRM_ID` bigint DEFAULT NULL,
  `COMPANYNAME` varchar(128) DEFAULT NULL,
  `FULLNAME` varchar(128) DEFAULT NULL,
  `BILLING_OPCO` varchar(26) DEFAULT NULL,
  `OLD_OPCO` varchar(128) DEFAULT NULL,
  `CUSTOMER_TYPE` varchar(128) DEFAULT NULL,
  `CUSTOMER_STATUS` varchar(128) DEFAULT NULL,
  `IS_CHANGE` varchar(10) DEFAULT NULL,
  `IS_BILLABLE` varchar(10) DEFAULT NULL,
  `VALID` varchar(128) DEFAULT NULL,
  `CURRENCY` varchar(128) DEFAULT NULL,
  `CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_new_opco_success`
--

DROP TABLE IF EXISTS `dic_new_opco_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_new_opco_success` (
  `CPARTY_ID` bigint DEFAULT NULL,
  `CRM_ID` bigint DEFAULT NULL,
  `COMPANYNAME` varchar(128) DEFAULT NULL,
  `FULLNAME` varchar(128) DEFAULT NULL,
  `BILLING_OPCO` varchar(26) DEFAULT NULL,
  `OLD_OPCO` varchar(128) DEFAULT NULL,
  `CUSTOMER_TYPE` varchar(128) DEFAULT NULL,
  `CUSTOMER_STATUS` varchar(128) DEFAULT NULL,
  `IS_CHANGE` varchar(10) DEFAULT NULL,
  `IS_BILLABLE` varchar(10) DEFAULT NULL,
  `VALID` varchar(128) DEFAULT NULL,
  `CURRENCY` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_error_codes`
--

DROP TABLE IF EXISTS `ec_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_failure`
--

DROP TABLE IF EXISTS `ec_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_failure` (
  `MAIN_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_ID` bigint DEFAULT NULL,
  `BSS_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO_CRM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESELLER_CRM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SEGMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `METHOD_OF_PAYMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INVOICING_LEVEL_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BSP_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BRANDING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BRANDING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_SALUTATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ROLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_COMMUNIC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VAT_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VALIDITY_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_DEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_BILL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID_WHO_CHANGE_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIGNATURE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SALESFORCE_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_VOLUME_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_VOICE_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_USAGE_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_USAGE_DISTRIBUTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_T_LOG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_VOICE_COUNTRI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_SMS_COUNTRIES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_DATA_COUNTRI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TECHNICAL_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SMS_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SIM_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SERVICE_PROFILE_MIGRAT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_DATA_USAGE_PER_MB_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_COST_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_COST_OVERVIEW` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_CDR_EXPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORTS_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_URL_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_LOGIN_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_PSWD_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_URL_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_LOGIN_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_PSWD_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATE_PUSH_CDR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCESS_TO_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMITMENT_MINIMAL_VALUE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMITMENT_DUE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEFAULT_BUSINESS_UNIT_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FRAME_CONTRACT_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PREFERRED_LANGUAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LANGUAGE_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_success`
--

DROP TABLE IF EXISTS `ec_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_success` (
  `MAIN_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EC_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_ID` bigint DEFAULT NULL,
  `BSS_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OPCO_CRM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESELLER_CRM_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SEGMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `METHOD_OF_PAYMENT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INVOICING_LEVEL_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BSP_VERSION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BRANDING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BRANDING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_SALUTATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ROLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_COMMUNIC` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCOUNT_MANAGER_ADDRESS_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VAT_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VALIDITY_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_DEL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_COMPANY_ADDRESS_FOR_BILL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ID_WHO_CHANGE_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SIGNATURE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SALESFORCE_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_VOLUME_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_VOICE_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_USAGE_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_USAGE_DISTRIBUTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_T_LOG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_VOICE_COUNTRI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_SMS_COUNTRIES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TOP_10_DATA_COUNTRI` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_TECHNICAL_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SMS_USAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SIM_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_SERVICE_PROFILE_MIGRAT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_DATA_USAGE_PER_MB_C` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_COST_REPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_COST_OVERVIEW` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORT_CDR_EXPORT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REPORTS_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_URL_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_LOGIN_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_PSWD_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_URL_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_LOGIN_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PUSH_CDR_PSWD_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVATE_PUSH_CDR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACCESS_TO_OTP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMITMENT_MINIMAL_VALUE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMITMENT_DUE_DATE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEFAULT_BUSINESS_UNIT_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FRAME_CONTRACT_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PREFERRED_LANGUAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LANGUAGE_AVAILABLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_pool_error_codes`
--

DROP TABLE IF EXISTS `ip_pool_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_pool_error_codes` (
  `CODE` int NOT NULL,
  `message` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_pool_failure`
--

DROP TABLE IF EXISTS `ip_pool_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_pool_failure` (
  `ID` bigint NOT NULL,
  `NAME` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `RANGE_START` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RANGE_END` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OPCO_ID` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESELLER_ID` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMER_ID` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_pool_success`
--

DROP TABLE IF EXISTS `ip_pool_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_pool_success` (
  `ID` bigint NOT NULL,
  `NAME` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `RANGE_START` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RANGE_END` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OPCO_ID` bigint DEFAULT NULL,
  `RESELLER_ID` bigint DEFAULT NULL,
  `CUSTOMER_ID` bigint DEFAULT NULL,
  `BU_ID` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labels_error_codes`
--

DROP TABLE IF EXISTS `labels_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `labels_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labels_failure`
--

DROP TABLE IF EXISTS `labels_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `labels_failure` (
  `ID` bigint NOT NULL,
  `NAME` varchar(2000) DEFAULT NULL,
  `TEXT` varchar(2000) DEFAULT NULL,
  `SUBJECT` varchar(2000) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `CUSTOMER_ID` bigint DEFAULT NULL,
  `BU_ID` bigint DEFAULT NULL,
  `RESELLER_ID` bigint DEFAULT NULL,
  `LABEL_LEVEL` bigint DEFAULT NULL,
  `OPCOID` varchar(40) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labels_success`
--

DROP TABLE IF EXISTS `labels_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `labels_success` (
  `ID` bigint NOT NULL,
  `NAME` varchar(2000) DEFAULT NULL,
  `TEXT` varchar(2000) DEFAULT NULL,
  `SUBJECT` varchar(2000) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `CUSTOMER_ID` bigint DEFAULT NULL,
  `BU_ID` bigint DEFAULT NULL,
  `RESELLER_ID` bigint DEFAULT NULL,
  `LABEL_LEVEL` bigint DEFAULT NULL,
  `OPCOID` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `life_cycles_error_codes`
--

DROP TABLE IF EXISTS `life_cycles_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `life_cycles_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `life_cycles_failure`
--

DROP TABLE IF EXISTS `life_cycles_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `life_cycles_failure` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_FLAG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IS_DELETED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVE_SP_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMER_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_LIFECYCLE_TEMPLATE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SP_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VERSION_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `life_cycles_success`
--

DROP TABLE IF EXISTS `life_cycles_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `life_cycles_success` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_FLAG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IS_DELETED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ACTIVE_SP_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CUSTOMER_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_LIFECYCLE_TEMPLATE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SP_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VERSION_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_error_codes`
--

DROP TABLE IF EXISTS `notifications_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_failure`
--

DROP TABLE IF EXISTS `notifications_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_failure` (
  `ID` bigint NOT NULL,
  `NAME` text COLLATE utf8mb4_unicode_ci,
  `TEXT` text COLLATE utf8mb4_unicode_ci,
  `SUBJECT` text COLLATE utf8mb4_unicode_ci,
  `TYPE` text COLLATE utf8mb4_unicode_ci,
  `CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TEMPLATE_DESCRIPTION` text COLLATE utf8mb4_unicode_ci,
  `SMS_TYPE` text COLLATE utf8mb4_unicode_ci,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_success`
--

DROP TABLE IF EXISTS `notifications_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_success` (
  `ID` bigint NOT NULL,
  `NAME` text COLLATE utf8mb4_unicode_ci,
  `TEXT` text COLLATE utf8mb4_unicode_ci,
  `SUBJECT` text COLLATE utf8mb4_unicode_ci,
  `TYPE` text COLLATE utf8mb4_unicode_ci,
  `CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TEMPLATE_DESCRIPTION` text COLLATE utf8mb4_unicode_ci,
  `SMS_TYPE` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_subscriptions_error_codes`
--

DROP TABLE IF EXISTS `report_subscriptions_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_subscriptions_error_codes` (
  `CODE` int NOT NULL,
  `MESSAGE` text,
  PRIMARY KEY (`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_subscriptions_failure`
--

DROP TABLE IF EXISTS `report_subscriptions_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_subscriptions_failure` (
  `ID` bigint NOT NULL,
  `REPORT_DEF_NAME` text COLLATE utf8mb4_unicode_ci,
  `NAME` text COLLATE utf8mb4_unicode_ci,
  `REPORT_TYPE_NAME` text COLLATE utf8mb4_unicode_ci,
  `STATUS_NAME` text COLLATE utf8mb4_unicode_ci,
  `GENERATED_DATE` text COLLATE utf8mb4_unicode_ci,
  `REPORT_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FILE_TYPE` text COLLATE utf8mb4_unicode_ci,
  `GENERATION_STATUS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRMEC_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRMOPCO_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRMBU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRMRESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MAIL_NOTIFICATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RECEPIENTS` text COLLATE utf8mb4_unicode_ci,
  `AGGREGATION_LEVEL` text COLLATE utf8mb4_unicode_ci,
  `DFROM` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DTO` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SELECTED_LEVEL` text COLLATE utf8mb4_unicode_ci,
  `CODE` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_subscriptions_success`
--

DROP TABLE IF EXISTS `report_subscriptions_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_subscriptions_success` (
  `ID` bigint NOT NULL,
  `REPORT_DEF_NAME` text COLLATE utf8mb4_unicode_ci,
  `NAME` text COLLATE utf8mb4_unicode_ci,
  `REPORT_TYPE_NAME` text COLLATE utf8mb4_unicode_ci,
  `STATUS_NAME` text COLLATE utf8mb4_unicode_ci,
  `GENERATED_DATE` datetime DEFAULT NULL,
  `REPORT_TYPE` bigint DEFAULT NULL,
  `FILE_TYPE` text COLLATE utf8mb4_unicode_ci,
  `GENERATION_STATUS` bigint DEFAULT NULL,
  `CRMEC_ID` bigint DEFAULT NULL,
  `CRMOPCO_ID` bigint DEFAULT NULL,
  `CRMBU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRMRESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MAIL_NOTIFICATION` smallint DEFAULT NULL,
  `RECEPIENTS` text COLLATE utf8mb4_unicode_ci,
  `AGGREGATION_LEVEL` text COLLATE utf8mb4_unicode_ci,
  `DFROM` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DTO` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SELECTED_LEVEL` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_profiles_error_codes`
--

DROP TABLE IF EXISTS `service_profiles_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profiles_error_codes` (
  `CODE` int NOT NULL,
  `MESSAGE` varchar(255) NOT NULL,
  PRIMARY KEY (`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_profiles_failure`
--

DROP TABLE IF EXISTS `service_profiles_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profiles_failure` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPENAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLED_FLAG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIC_TYPE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_LIFECYCLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_SELECTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_AUTO_TRIG_TRAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROFILE_AA_IS_DELETED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_VARIANT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_VARIANT_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_SP_TEMP_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROFILE_AA_VERSION_NU` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_VOICE_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_WAITING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_DATA` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIAMETER_GRANTED_SERVICE_UNITS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DATA_BANDWITH` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIREWALL_POLICY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MT_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MO_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_SELECTION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIREWALL_POLICY_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIAMETER_GSU_T` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TP_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DATA_BANDWITH_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_AUTO_TRIG_TRANS_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_OUTGOING_BARRING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_VOICE_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_INCOMING_BARRING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_WAITING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_OUTGOING_BARRING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_INCOMING_BARRING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIP_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIR_MODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_4_HLR_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_4_SOR_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIR_MODE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_profiles_success`
--

DROP TABLE IF EXISTS `service_profiles_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profiles_success` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPENAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLED_FLAG` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIC_TYPE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_LIFECYCLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_SELECTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_AUTO_TRIG_TRAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MO` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROFILE_AA_IS_DELETED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_VARIANT` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_VARIANT_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OWNING_SP_TEMP_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PROFILE_AA_VERSION_NU` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_VOICE_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_WAITING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_DATA` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIAMETER_GRANTED_SERVICE_UNITS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DATA_BANDWITH` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIREWALL_POLICY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MT_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_SMS_MO_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PERCENTAGE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TARIFF_PLAN_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TYPE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_SELECTION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIREWALL_POLICY_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_SIZE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DIAMETER_GSU_T` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WHOLESALE_TP_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BUNDLE_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DATA_BANDWITH_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ALLOW_AUTO_TRIG_TRANS_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USE_STATIC_IP_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_NAME_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_OUTGOING_BARRING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIR_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_VOICE_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_INCOMING_BARRING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_WAITING_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_OUTGOING_BARRING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_INCOMING_BARRING` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_ENABLE_CLIP_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIR_MODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `APN_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_4_HLR_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ROAMING_PROFILE_4_SOR_ID_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VOICE_CLIR_MODE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_2G_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_3G_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NR_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sim_assets`
--

DROP TABLE IF EXISTS `sim_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sim_assets` (
  `IMSI` varchar(30) DEFAULT NULL,
  `ICCID` varchar(22) DEFAULT NULL,
  `MSISDN` varchar(15) DEFAULT NULL,
  `OPCO_ID` varchar(32) DEFAULT NULL,
  `EC_ID` varchar(32) DEFAULT NULL,
  `BU_ID` varchar(32) DEFAULT NULL,
  `CC_ID` varchar(32) DEFAULT NULL,
  `SESSION_STATE` varchar(12) DEFAULT NULL,
  `DES_INDEX` varchar(3) DEFAULT NULL,
  `ALG_VERSION` varchar(3) DEFAULT NULL,
  `ACC` varchar(4) DEFAULT NULL,
  `KI` varchar(32) DEFAULT NULL,
  `OPC` varchar(32) DEFAULT NULL,
  `PIN1` varchar(4) DEFAULT NULL,
  `PIN2` varchar(4) DEFAULT NULL,
  `PUK1` varchar(8) DEFAULT NULL,
  `PUK2` varchar(8) DEFAULT NULL,
  `ADM` varchar(16) DEFAULT NULL,
  `MNOLABEL` varchar(256) DEFAULT NULL,
  `OPCOLABEL` varchar(256) DEFAULT NULL,
  `CUSTLABEL` varchar(256) DEFAULT NULL,
  `BULABEL` varchar(256) DEFAULT NULL,
  `APINSTANCE_ID` varchar(128) DEFAULT NULL,
  `LASTMODIFDATE` varchar(20) DEFAULT NULL,
  `CREATIONDATE` varchar(20) DEFAULT NULL,
  `HIERARCHYDATE` varchar(20) DEFAULT NULL,
  `NETSTATUSDATE` varchar(20) DEFAULT NULL,
  `IMEI` varchar(16) DEFAULT NULL,
  `IP_ADDRESS` varchar(39) DEFAULT NULL,
  `EXPECTED_IMEI` varchar(16) DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(128) DEFAULT NULL,
  `SIM_STATUS` varchar(1) DEFAULT NULL,
  `MIGRATION_STATUS` varchar(15) DEFAULT NULL,
  `MIGRATION_DATE` varchar(20) DEFAULT NULL,
  `SESSION_ID` varchar(100) DEFAULT NULL,
  `RADIUS_METHOD` varchar(10) DEFAULT NULL,
  `RADIUS_USER` varchar(50) DEFAULT NULL,
  `RADIUS_PASS` varchar(50) DEFAULT NULL,
  `RSLRLABEL` varchar(4000) DEFAULT NULL,
  `RR_ID` varchar(256) DEFAULT NULL,
  `FREE_TEXT` varchar(256) DEFAULT NULL,
  `WSGUIDINGCITEM_ID` varchar(256) DEFAULT NULL,
  `ASSIGNED_IP_ADDR` varchar(39) DEFAULT NULL,
  `ASSIGNED_IP_POOL_ID` varchar(256) DEFAULT NULL,
  `ORDERTX_ID` varchar(256) DEFAULT NULL,
  `SPCHANGECOUNTER` varchar(256) DEFAULT NULL,
  `SPMODIFDATE` varchar(20) DEFAULT NULL,
  `IP_ADDRESSINT` varchar(128) DEFAULT NULL,
  `CUSTOMERORDER_ID` varchar(50) DEFAULT NULL,
  `CELL_ID` varchar(50) DEFAULT NULL,
  `ASSIGNED_IP_ADDRINT` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE` varchar(30) DEFAULT NULL,
  `CFU` varchar(30) DEFAULT NULL,
  `CFB` varchar(30) DEFAULT NULL,
  `CFNR` varchar(30) DEFAULT NULL,
  `CFNRY` varchar(30) DEFAULT NULL,
  `ENODEB_ID` varchar(50) DEFAULT NULL,
  `DEVICE_ID` varchar(100) DEFAULT NULL,
  `TRIGGER_CONDITION` varchar(100) DEFAULT NULL,
  `EID` varchar(32) DEFAULT NULL,
  `ACTIVE_SUBSCRIPTION` varchar(128) DEFAULT NULL,
  `RANGE` varchar(255) DEFAULT NULL,
  `IPPROTOCOL` varchar(12) DEFAULT NULL,
  `IPV6ADDRESS` varchar(100) DEFAULT NULL,
  `RATTYPE` varchar(12) DEFAULT NULL,
  `ACTIVATION_CODE` varchar(256) DEFAULT NULL,
  `ACTIVEFROM` varchar(128) DEFAULT NULL,
  `SAPNUMBER` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_failure`
--

DROP TABLE IF EXISTS `trigger_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_failure` (
  `ID` varchar(100) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `DESCRIPTION` text,
  `CRMOPCO_ID` varchar(100) DEFAULT NULL,
  `CRMEC_ID` varchar(100) DEFAULT NULL,
  `CRMBU_ID` varchar(100) DEFAULT NULL,
  `CRMCC_ID` varchar(100) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `CREATION_DATE` varchar(100) DEFAULT NULL,
  `ACTIVATION_DATE` varchar(100) DEFAULT NULL,
  `DEACTIVATION_DATE` varchar(100) DEFAULT NULL,
  `ACTIVE` varchar(100) DEFAULT NULL,
  `VISIBLE` varchar(100) DEFAULT NULL,
  `EDITABLE` varchar(100) DEFAULT NULL,
  `ACTION_TYPE` varchar(100) DEFAULT NULL,
  `CONDITION_TYPE` varchar(100) DEFAULT NULL,
  `LEVEL_TYPE` varchar(100) DEFAULT NULL,
  `T_TYPE` varchar(100) DEFAULT NULL,
  `ACTION_ID` varchar(100) DEFAULT NULL,
  `CONDITION_ID` varchar(100) DEFAULT NULL,
  `RAISE_COUNT` varchar(100) DEFAULT NULL,
  `LAST_ACTIVE_TRIGGER_ID` varchar(100) DEFAULT NULL,
  `CREATED_BY` varchar(100) DEFAULT NULL,
  `TYPE` varchar(100) DEFAULT NULL,
  `T_IA_CSP_NEW_SP_CONTEXT` text,
  `T_IA_CSP_SP_IN_NNBC` varchar(100) DEFAULT NULL,
  `T_IAA_COND_TP_FA_SMS` varchar(100) DEFAULT NULL,
  `T_IC_TP_FACTIVITY_NO_DAYS` varchar(100) DEFAULT NULL,
  `T_IC_VT_DATA_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAS_MAIL_ADDRESS` text,
  `T_IAS_MAIL_MESSAGE` text,
  `T_IAS_MAIL_SUBJECT` text,
  `T_IC_VT_SP_CONTEXT` text,
  `T_IC_VT_SMS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_TP_SP_CONTEXT` text,
  `T_IC_TP_DAYS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_TP_FA_SP_CONTEXT` text,
  `T_IAA_CVT_DATA_VOLUME_VALUE` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_NO_OF_DAYS` varchar(100) DEFAULT NULL,
  `T_IAA_SM_AGGREGATE_DAILY` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_SP_CONTEXT` text,
  `T_IC_SP_CHANGE_SP_CONTEXT` text,
  `T_IAA_C_TP_FA_ROAMING` varchar(100) DEFAULT NULL,
  `T_IAA_C_TP_FA_DATA` varchar(100) DEFAULT NULL,
  `T_IAA_C_TP_FA_VOICE` varchar(100) DEFAULT NULL,
  `T_IAA_MAIL_TEMPLATE` text,
  `T_IC_VT_TOTAL_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_VT_PERCENTAGE` varchar(100) DEFAULT NULL,
  `T_IC_POINT_IN_TIME_TIME` varchar(100) DEFAULT NULL,
  `T_IC_POINT_IN_TIME_DATE` varchar(100) DEFAULT NULL,
  `T_IC_CT_CURRENCY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAS_SMS_STO_RAISING_TRIGGER` text,
  `T_IC_CT_SP_CONTEXT` text,
  `T_IC_COOC_SP_CONTEXT` text,
  `T_IAUSER_NOTIFIED` varchar(100) DEFAULT NULL,
  `T_IAANAME` varchar(100) DEFAULT NULL,
  `T_IAADESCRIPTION` text,
  `T_IC_IPO_SP_CONTEXT` text,
  `T_IC_IPO_INACTIVITY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAA_CHARGING_BU_FOR_SEND_SMS` varchar(100) DEFAULT NULL,
  `T_IAS_SMS_MESSAGE` text,
  `T_IAS_SMS_PHONE` varchar(100) DEFAULT NULL,
  `T_IC_IP_INACTIVITY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_IP_SP_CONTEXT` text,
  `T_IC_TP_SIM_IN_SP_CONDITION` text,
  `T_IC_NO_OF_SP_CHANGES` varchar(100) DEFAULT NULL,
  `T_IC_VT_SECONDS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IA_CSP_4G_SP_CONTEXT` text,
  `T_IA_CSP_4G_NEW_SP_CONTEXT` text,
  `T_IA_CSP_4G_SP_IN_NBC` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_NUMBER_OF_SESSIONS` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_SP_CONTEXT` text,
  `T_IAS_SIM_4G_SP_CONTEXT` text,
  `T_IC_SL_SP_CONTEXT` text,
  `T_IC_SL_DURATION` varchar(100) DEFAULT NULL,
  `T_IAA_SMS_TEMPLATE` text,
  `T_IA_CSP_SWITCH` varchar(100) DEFAULT NULL,
  `T_IC_TP_FA_START_CONDITION` text,
  `T_IC_VT_COUNTER` varchar(100) DEFAULT NULL,
  `T_IAA_MAIL_DEFINITION` text,
  `T_IC_TP_START_CONDITION` text,
  `T_IAA_CVT_DATA_VOLUME_UNIT` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_COUNTER_TYPE` varchar(100) DEFAULT NULL,
  `T_IC_CT_COUNTER` varchar(100) DEFAULT NULL,
  `T_IC_COOC_CHANGE_TYPE` varchar(100) DEFAULT NULL,
  `T_IC_IPO_UNIT` varchar(100) DEFAULT NULL,
  `T_IAA_SMS_DEFINITION` text,
  `T_IC_IP_UNIT` varchar(100) DEFAULT NULL,
  `T_IC_NO_SP_CCOUNTER` varchar(100) DEFAULT NULL,
  `T_IA_CSP_4G_SWITCH` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_COUNTER` varchar(100) DEFAULT NULL,
  `CODE` varchar(100) DEFAULT NULL,
  `ID_condition` varchar(100) DEFAULT NULL,
  `ID_action` varchar(100) DEFAULT NULL,
  `T_IC_NO_OF_SP_CHANGES_` varchar(100) DEFAULT NULL,
  `T_IAAUSER_NOTIFIED` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_T_CONDITION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_success`
--

DROP TABLE IF EXISTS `trigger_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_success` (
  `ID` varchar(100) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `DESCRIPTION` text,
  `CRMOPCO_ID` varchar(100) DEFAULT NULL,
  `CRMEC_ID` varchar(100) DEFAULT NULL,
  `CRMBU_ID` varchar(100) DEFAULT NULL,
  `CRMCC_ID` varchar(100) DEFAULT NULL,
  `IMSI` varchar(20) DEFAULT NULL,
  `CREATION_DATE` varchar(100) DEFAULT NULL,
  `ACTIVATION_DATE` varchar(100) DEFAULT NULL,
  `DEACTIVATION_DATE` varchar(100) DEFAULT NULL,
  `ACTIVE` varchar(100) DEFAULT NULL,
  `VISIBLE` varchar(100) DEFAULT NULL,
  `EDITABLE` varchar(100) DEFAULT NULL,
  `ACTION_TYPE` varchar(100) DEFAULT NULL,
  `CONDITION_TYPE` varchar(100) DEFAULT NULL,
  `LEVEL_TYPE` varchar(100) DEFAULT NULL,
  `T_TYPE` varchar(100) DEFAULT NULL,
  `ACTION_ID` varchar(100) DEFAULT NULL,
  `CONDITION_ID` varchar(100) DEFAULT NULL,
  `RAISE_COUNT` varchar(100) DEFAULT NULL,
  `LAST_ACTIVE_TRIGGER_ID` varchar(100) DEFAULT NULL,
  `CREATED_BY` varchar(100) DEFAULT NULL,
  `TYPE` varchar(100) DEFAULT NULL,
  `T_IA_CSP_NEW_SP_CONTEXT` text,
  `T_IA_CSP_SP_IN_NNBC` varchar(100) DEFAULT NULL,
  `T_IAA_COND_TP_FA_SMS` varchar(100) DEFAULT NULL,
  `T_IC_TP_FACTIVITY_NO_DAYS` varchar(100) DEFAULT NULL,
  `T_IC_VT_DATA_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAS_MAIL_ADDRESS` text,
  `T_IAS_MAIL_MESSAGE` text,
  `T_IAS_MAIL_SUBJECT` text,
  `T_IC_VT_SP_CONTEXT` text,
  `T_IC_VT_SMS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_TP_SP_CONTEXT` text,
  `T_IC_TP_DAYS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_TP_FA_SP_CONTEXT` text,
  `T_IAA_CVT_DATA_VOLUME_VALUE` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_NO_OF_DAYS` varchar(100) DEFAULT NULL,
  `T_IAA_SM_AGGREGATE_DAILY` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_SP_CONTEXT` text,
  `T_IC_SP_CHANGE_SP_CONTEXT` text,
  `T_IAA_C_TP_FA_ROAMING` varchar(100) DEFAULT NULL,
  `T_IAA_C_TP_FA_DATA` varchar(100) DEFAULT NULL,
  `T_IAA_C_TP_FA_VOICE` varchar(100) DEFAULT NULL,
  `T_IAA_MAIL_TEMPLATE` text,
  `T_IC_VT_TOTAL_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_VT_PERCENTAGE` varchar(100) DEFAULT NULL,
  `T_IC_POINT_IN_TIME_TIME` varchar(100) DEFAULT NULL,
  `T_IC_POINT_IN_TIME_DATE` varchar(100) DEFAULT NULL,
  `T_IC_CT_CURRENCY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAS_SMS_STO_RAISING_TRIGGER` text,
  `T_IC_CT_SP_CONTEXT` text,
  `T_IC_COOC_SP_CONTEXT` text,
  `T_IAUSER_NOTIFIED` varchar(100) DEFAULT NULL,
  `T_IAANAME` varchar(100) DEFAULT NULL,
  `T_IAADESCRIPTION` text,
  `T_IC_IPO_SP_CONTEXT` text,
  `T_IC_IPO_INACTIVITY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IAA_CHARGING_BU_FOR_SEND_SMS` varchar(100) DEFAULT NULL,
  `T_IAS_SMS_MESSAGE` text,
  `T_IAS_SMS_PHONE` varchar(100) DEFAULT NULL,
  `T_IC_IP_INACTIVITY_VOLUME` varchar(100) DEFAULT NULL,
  `T_IC_IP_SP_CONTEXT` text,
  `T_IC_TP_SIM_IN_SP_CONDITION` text,
  `T_IC_NO_OF_SP_CHANGES` varchar(100) DEFAULT NULL,
  `T_IC_VT_SECONDS_VOLUME` varchar(100) DEFAULT NULL,
  `T_IA_CSP_4G_SP_CONTEXT` text,
  `T_IA_CSP_4G_NEW_SP_CONTEXT` text,
  `T_IA_CSP_4G_SP_IN_NBC` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_NUMBER_OF_SESSIONS` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_SP_CONTEXT` text,
  `T_IAS_SIM_4G_SP_CONTEXT` text,
  `T_IC_SL_SP_CONTEXT` text,
  `T_IC_SL_DURATION` varchar(100) DEFAULT NULL,
  `T_IAA_SMS_TEMPLATE` text,
  `T_IA_CSP_SWITCH` varchar(100) DEFAULT NULL,
  `T_IC_TP_FA_START_CONDITION` text,
  `T_IC_VT_COUNTER` varchar(100) DEFAULT NULL,
  `T_IAA_MAIL_DEFINITION` text,
  `T_IC_TP_START_CONDITION` text,
  `T_IAA_CVT_DATA_VOLUME_UNIT` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_COUNTER_TYPE` varchar(100) DEFAULT NULL,
  `T_IC_CT_COUNTER` varchar(100) DEFAULT NULL,
  `T_IC_COOC_CHANGE_TYPE` varchar(100) DEFAULT NULL,
  `T_IC_IPO_UNIT` varchar(100) DEFAULT NULL,
  `T_IAA_SMS_DEFINITION` text,
  `T_IC_IP_UNIT` varchar(100) DEFAULT NULL,
  `T_IC_NO_SP_CCOUNTER` varchar(100) DEFAULT NULL,
  `T_IA_CSP_4G_SWITCH` varchar(100) DEFAULT NULL,
  `T_IC_NO_S_COUNTER` varchar(100) DEFAULT NULL,
  `ID_condition` varchar(100) DEFAULT NULL,
  `ID_action` varchar(100) DEFAULT NULL,
  `T_IC_NO_OF_SP_CHANGES_` varchar(100) DEFAULT NULL,
  `T_IAAUSER_NOTIFIED` varchar(100) DEFAULT NULL,
  `T_IC_TP_SIM_IN_SP_T_CONDITION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `triggers_error_codes`
--

DROP TABLE IF EXISTS `triggers_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triggers_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_error_codes`
--

DROP TABLE IF EXISTS `users_error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_error_codes` (
  `CODE` int DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_failure`
--

DROP TABLE IF EXISTS `users_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_failure` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USERTYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USERCATEGORY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIRST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LAST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PHONE_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EMAIL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIDDLE_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_OPCO_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_RESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_AA_INFO_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_AA_INFO_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_BOA_VIEW` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_DISP_MAINT_MESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_ENABLE_GET_ALL_CUST` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_ATTR_HIERARCHY` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_MOBILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_OTP_ENABLED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_ROLES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_SHOW_HELP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_USE_API` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_success`
--

DROP TABLE IF EXISTS `users_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_success` (
  `ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USERTYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USERCATEGORY` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LOGIN` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FIRST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LAST_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PHONE_NUMBER` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EMAIL` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MIDDLE_NAME` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_OPCO_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_RESELLER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_CUSTOMER_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CRM_BU_ID` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_AA_INFO_1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_AA_INFO_2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_BOA_VIEW` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_DISP_MAINT_MESS` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_ENABLE_GET_ALL_CUST` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_ADDITIONAL_ATTR_HIERARCHY` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_MOBILE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_OTP_ENABLED` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_ROLES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_SHOW_HELP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `USER_AA_USE_API` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `apn_error_codes`
--

LOCK TABLES `apn_error_codes` WRITE;
/*!40000 ALTER TABLE `apn_error_codes` DISABLE KEYS */;
INSERT INTO `apn_error_codes` VALUES (101,'APN is required'),(102,'APN_ID is required'),(103,'IP_ASSIGNMENT is required'),(104,'IPvX is required'),(105,'APN must be alphanumeric'),(106,'APN ID must be numeric'),(107,'IP Assignment must be dynamic or static'),(108,'IP Version must be IPv4, IPv6, or IPv4 and IPv6'),(109,'Invalid IP Pool format'),(409,'Duplicate value in APN_ID column found ');
/*!40000 ALTER TABLE `apn_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `asset_error_codes`
--

LOCK TABLES `asset_error_codes` WRITE;
/*!40000 ALTER TABLE `asset_error_codes` DISABLE KEYS */;
INSERT INTO `asset_error_codes` VALUES ('101','Creation Date is required'),('102','Active From Date is required'),('103','ICCID is required'),('104','IMEI is required'),('105','IMSI is required'),('106','MSISDN is required'),('107','SIM Status is required'),('108','OPCO ID is required'),('109','Business Unit ID is required'),('110','Expected IMEI is required'),('111','ICCID must be numeric'),('112','IMEI must be numeric'),('113','IMSI must be numeric'),('114','MSISDN must be numeric'),('115','Invalid SIM Status must be in [A, S, 4, 5]'),('116','OPCO ID must be numeric'),('117','Business Unit ID must be numeric'),('118','Expected IMEI must be numeric'),('123','Invalid IP Address format for IP_ADDRESS column'),('124','Invalid IP Address format for ASSIGNED_IP_ADDR column'),('125','FREE_TEXT exceeds 50 characters'),('404','Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `asset_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `bu_account_to_tp_mapping_error_codes`
--

LOCK TABLES `bu_account_to_tp_mapping_error_codes` WRITE;
/*!40000 ALTER TABLE `bu_account_to_tp_mapping_error_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `bu_account_to_tp_mapping_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `bu_error_codes`
--

LOCK TABLES `bu_error_codes` WRITE;
/*!40000 ALTER TABLE `bu_error_codes` DISABLE KEYS */;
INSERT INTO `bu_error_codes` VALUES (101,'Business Unit CRM ID is required'),(102,'Enterprise Customer CRM ID is required'),(103,'Business Unit Name is required'),(105,'Billing Cycle ID is required'),(107,'Currency is required'),(108,'Activation Status is required'),(109,'Business Unit CRM ID must be numeric'),(110,'Enterprise Customer CRM ID must be numeric'),(111,'Business Unit Name must be within 50 characters'),(112,'Currency must be USD, EUR, or CHF'),(113,'Billing Cycle ID must be alphanumeric'),(115,'Activation Status must be Live or Test'),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `bu_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `cost_centers_error_codes`
--

LOCK TABLES `cost_centers_error_codes` WRITE;
/*!40000 ALTER TABLE `cost_centers_error_codes` DISABLE KEYS */;
INSERT INTO `cost_centers_error_codes` VALUES ('101','Status Name is required'),('102','Cost Center Name is required'),('103','Cost Center CRM ID is required'),('106','Invalid Cost Center Status'),('404','Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `cost_centers_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `dic_bill_cycle_error_codes`
--

LOCK TABLES `dic_bill_cycle_error_codes` WRITE;
/*!40000 ALTER TABLE `dic_bill_cycle_error_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `dic_bill_cycle_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `dic_new_opco_error_codes`
--

LOCK TABLES `dic_new_opco_error_codes` WRITE;
/*!40000 ALTER TABLE `dic_new_opco_error_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `dic_new_opco_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `ec_error_codes`
--

LOCK TABLES `ec_error_codes` WRITE;
/*!40000 ALTER TABLE `ec_error_codes` DISABLE KEYS */;
INSERT INTO `ec_error_codes` VALUES (101,'Enterprise Customer Name is required'),(102,'CRM ID is required'),(103,'OPCO CRM ID is required'),(105,'Activation Status is required'),(106,'Company Address is required'),(107,'Missing value ADDRESSBILLING when INVOICING_LEVEL_TYPE is Customer'),(108,'CRM ID must be numeric'),(109,'OPCO CRM ID must be alphanumeric'),(111,'Address Billing must be alphanumeric'),(112,'Company Address must be alphanumeric'),(113,'Activation Status must be Live or Test'),(114,'Enterprise Customer Name must be within 50 characters');
/*!40000 ALTER TABLE `ec_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `ip_pool_error_codes`
--

LOCK TABLES `ip_pool_error_codes` WRITE;
/*!40000 ALTER TABLE `ip_pool_error_codes` DISABLE KEYS */;
INSERT INTO `ip_pool_error_codes` VALUES (101,'IP Pool ID is missing'),(102,'BU_ID is missing'),(103,'IP Range start is missing'),(104,'IP Range end is missing'),(105,'BU_ID must be numeric'),(106,'RANGE_START must be a valid IP address'),(107,'RANGE_END must be a valid IP address'),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `ip_pool_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `labels_error_codes`
--

LOCK TABLES `labels_error_codes` WRITE;
/*!40000 ALTER TABLE `labels_error_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `labels_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `life_cycles_error_codes`
--

LOCK TABLES `life_cycles_error_codes` WRITE;
/*!40000 ALTER TABLE `life_cycles_error_codes` DISABLE KEYS */;
INSERT INTO `life_cycles_error_codes` VALUES (101,'ID Column is missing'),(102,'BU_ID Column is missing'),(103,'Name Column is missing'),(104,'ID Columns must be numeric'),(105,'Type Column allowed type only SIM Lifecycle'),(106,'ENABLE_FLAG value must be Enabled or Disabled'),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `life_cycles_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `notifications_error_codes`
--

LOCK TABLES `notifications_error_codes` WRITE;
/*!40000 ALTER TABLE `notifications_error_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `report_subscriptions_error_codes`
--

LOCK TABLES `report_subscriptions_error_codes` WRITE;
/*!40000 ALTER TABLE `report_subscriptions_error_codes` DISABLE KEYS */;
INSERT INTO `report_subscriptions_error_codes` VALUES (101,'Report Definition Name is required'),(102,'Report Name is required'),(103,'Report Type is required'),(104,'File Type is required'),(105,'CRMEC_ID is required'),(106,'Mail Notification is required'),(107,'Aggregation Level is required'),(108,'Recipients are required'),(109,'REPORT_TYPE must be 17590'),(110,'CRMEC_ID should be numeric'),(111,'RECEPIENTS length must not exceed 50 chars'),(112,'AGGREGATION_LEVEL value must be Business Unit or Customer'),(113,'MAIL NOTIFICATION must be alphanumeric'),(115,'REPORT_DEF_NAME must be Usage per IMSI, Sim Report, CDR Export'),(119,'MAIL NOTIFICATION should be numeric');
/*!40000 ALTER TABLE `report_subscriptions_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `service_profiles_error_codes`
--

LOCK TABLES `service_profiles_error_codes` WRITE;
/*!40000 ALTER TABLE `service_profiles_error_codes` DISABLE KEYS */;
INSERT INTO `service_profiles_error_codes` VALUES (101,'ID column is missing'),(102,'OWNING_LIFECYCLE_ID column is missing'),(103,'ID must be numeric'),(104,'TYPE must be Sleep, Live or Test'),(105,'ENABLED_FLAG must be Enables or Disabled'),(106,'BUNDLE column value is required '),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `service_profiles_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `triggers_error_codes`
--

LOCK TABLES `triggers_error_codes` WRITE;
/*!40000 ALTER TABLE `triggers_error_codes` DISABLE KEYS */;
INSERT INTO `triggers_error_codes` VALUES (101,'Trigger Name is required'),(102,'CRMEC_ID is required'),(103,'CONDITION_TYPE is required'),(104,'CREATED_BY is required'),(105,'ACTIVATION_DATE is required'),(107,'LEVEL_TYPE is required'),(108,'ACTION_TYPE is required'),(109,'TRIGGER_TYPE is required'),(110,'Active status is required'),(111,'Name length must not exceed 50 characters'),(112,'CRMEC_ID must be numeric'),(113,'CONDITION_TYPE must be \n            TRIGGER_ITEM_CONDITION.VOLUME_THRESHOLD\',\n            \'TRIGGER_ITEM_CONDITION.COST_THRESHOLD\', \n            TRIGGER_ITEM_CONDITION.POINT_IN_TIME\',\n            \'TRIGGER_ITEM_CONDITION.INACTIVITY_PERIOD\',\n            \'TRIGGER_ITEM_CONDITION.SP_CHANGE\',\n            \'TRIGGER_ITEM_CONDITION.TIME_PERIOD\',\n            \'17697\',\'17242\',\'17696\',\'17241\',\'18711\',\'17695\',\'17694'),(115,'DESCRIPTION length must not exceed 50 characters'),(116,'LEVEL_TYPE must be\n            TRIGGER_LEVEL.BU\',\n            \'TRIGGER_LEVEL.EC\',\n            \'TRIGGER_LEVEL.SIM\',\n            \'TRIGGER_LEVEL.CC'),(117,'ACTION_TYPE must be TRIGGER_ITEM_ACTION.SUSPEND_SIM , TRIGGER_ITEM_ACTION.SEND_MAIL, TRIGGER_ITEM_ACTION.CHANGE_SP \'TRIGGER_ITEM_ACTION.SUSPEND_SIM\',\'TRIGGER_ITEM_ACTION.SEND_MAIL\', \'TRIGGER_ITEM_ACTION.CHANGE_SP\',\'TRIGGER_ITEM_ACTION.SEND_SMS\',\'TRIGGER_ITEM_ACTION.CHANGE_SP_FOR_GROUP\',\'17455\''),(118,'TRIGGER_TYPE must be \'TRIGGER_TYPE.SIM_LIFECYCLE\',\'TRIGGER_TYPE.FRAUD_PREVENTION\',\'TRIGGER_TYPE.COST_CONTROL\',\'TRIGGER_TYPE.OTHERS\''),(119,'ACTIVE must be 0 or 1'),(120,'Missing IMSI for SIM Level Trigger'),(121,'Missing Email Address for Send Mail Action'),(122,'Missing Phone Number for Send SMS Action'),(123,'Missing New Service Profile for Change Service Profile Action'),(124,'Missing New Service Profile for Group Service Profile Change'),(125,'Incomplete Email Notification Details'),(126,'Incomplete SMS Notification Details'),(127,'Missing Service Profile for Next Billing Cycle'),(128,'Missing Group Service Profile for Next Billing Cycle'),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `triggers_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: validation
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Dumping data for table `users_error_codes`
--

LOCK TABLES `users_error_codes` WRITE;
/*!40000 ALTER TABLE `users_error_codes` DISABLE KEYS */;
INSERT INTO `users_error_codes` VALUES (101,'First Name is required'),(102,'Last Name is required'),(103,'Phone Number is required'),(104,'Email is required'),(105,'Missing value CRM_RESELLER_ID, CRM_CUSTOMER_ID or CRM_BU_ID'),(106,'Missing value CRM_CUSTOMER_ID when CRM_BU_ID is Present'),(107,'Login is required'),(108,'First Name must be alphanumeric'),(109,'Last Name must be alphanumeric'),(110,'Phone number must contain + sign and must be a valid phone number'),(111,'Invalid Email format'),(112,'CRM Reseller ID must be numeric'),(113,'CRM Customer ID must be numeric'),(114,'CRM Business Unit ID must be numeric'),(115,'Login must be alphanumeric'),(404,'Parent Account EC Not validated, so discarding out this record also ');
/*!40000 ALTER TABLE `users_error_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:32
