-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: transformation
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
-- Current Database: `transformation`
--

/*!40000 DROP DATABASE IF EXISTS `transformation`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `transformation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `transformation`;

--
-- Table structure for table `apn_success`
--

DROP TABLE IF EXISTS `apn_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_success` (
  `apnName` varchar(255) DEFAULT NULL,
  `apnDescription` varchar(255) DEFAULT NULL,
  `apnId` int DEFAULT NULL,
  `apnType` varchar(255) DEFAULT NULL,
  `apnTypeIpv6` varchar(255) DEFAULT NULL,
  `privateShared` varchar(255) DEFAULT NULL,
  `eqosid` varchar(255) DEFAULT NULL,
  `apnIp` varchar(255) DEFAULT NULL,
  `apnCategory` varchar(255) DEFAULT NULL,
  `addressType` varchar(255) DEFAULT NULL,
  `mcc` varchar(3) DEFAULT NULL,
  `mnc` varchar(3) DEFAULT NULL,
  `hlrApnId` varchar(255) DEFAULT NULL,
  `hssContextId` varchar(255) DEFAULT NULL,
  `profile2g3g` varchar(255) DEFAULT NULL,
  `uplink2g3g` varchar(255) DEFAULT NULL,
  `uplinkunit2g3g` varchar(255) DEFAULT NULL,
  `downlink2g3g` varchar(255) DEFAULT NULL,
  `downlinkunit2g3g` varchar(255) DEFAULT NULL,
  `profilelte` varchar(255) DEFAULT NULL,
  `uplinklte` varchar(255) DEFAULT NULL,
  `uplinkunitlte` varchar(255) DEFAULT NULL,
  `downllinklte` varchar(255) DEFAULT NULL,
  `downllinunitklte` varchar(255) DEFAULT NULL,
  `hssProfileId` varchar(255) DEFAULT NULL,
  `ipPoolAllocationType` varchar(255) DEFAULT NULL,
  `subnet` varchar(512) DEFAULT NULL,
  `subnetIpv6` varchar(512) DEFAULT NULL,
  `ipPoolType` varchar(255) DEFAULT NULL,
  `requestSubType` varchar(255) DEFAULT NULL,
  `requestFrom` varchar(255) DEFAULT NULL,
  `info` text,
  `apnServiceType` varchar(255) DEFAULT NULL,
  `apnWlBlcategory` varchar(255) DEFAULT NULL,
  `splitBilling` varchar(255) DEFAULT NULL,
  `roamingEnabled` varchar(25) DEFAULT NULL,
  `radiusAuthenticationEnable` varchar(25) DEFAULT NULL,
  `radiusAuthType` varchar(255) DEFAULT NULL,
  `radiusUsername` varchar(255) DEFAULT NULL,
  `radiusPassword` varchar(255) DEFAULT NULL,
  `radiusForwardingEnable` varchar(25) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `accountId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets_extended_sucess`
--

DROP TABLE IF EXISTS `assets_extended_sucess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets_extended_sucess` (
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
  PRIMARY KEY (`ID`),
  KEY `voice_template` (`voice_template`),
  KEY `sms_template` (`sms_template`),
  KEY `data_template` (`data_template`),
  KEY `FK_assets_extended_sim_type` (`sim_type_id`)
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
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(50) DEFAULT NULL,
  `classifier` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `billingflag` varchar(10) DEFAULT NULL,
  `accountSegment` varchar(50) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(50) DEFAULT NULL,
  `bssPassword` varchar(50) DEFAULT NULL,
  `billingContactName` varchar(100) DEFAULT NULL,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` varchar(100) DEFAULT NULL,
  `billingTelephone` varchar(50) DEFAULT NULL,
  `billingMobile` varchar(50) DEFAULT NULL,
  `primaryContactFirstName` varchar(50) DEFAULT NULL,
  `primaryContactLastName` varchar(50) DEFAULT NULL,
  `primaryContactTelephone` varchar(50) DEFAULT NULL,
  `primaryContactMobile` varchar(50) DEFAULT NULL,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(50) DEFAULT NULL,
  `soContactLastName` varchar(50) DEFAULT NULL,
  `soContactEmail` varchar(100) DEFAULT NULL,
  `soContactTelephone` varchar(50) DEFAULT NULL,
  `soContactMobile` varchar(50) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(50) DEFAULT NULL,
  `modemType` varchar(50) DEFAULT NULL,
  `unitType` varchar(50) DEFAULT NULL,
  `simType` varchar(50) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(50) DEFAULT NULL,
  `goup_user_key` varchar(50) DEFAULT NULL,
  `goup_password` varchar(50) DEFAULT NULL,
  `application_key` varchar(50) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` varchar(10) DEFAULT NULL,
  `accountType` varchar(50) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `regionId` varchar(50) DEFAULT NULL,
  `areaCode` varchar(50) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(100) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(50) DEFAULT NULL,
  `isActivate` varchar(50) DEFAULT NULL,
  `imeiLock` varchar(10) DEFAULT NULL,
  `serviceGrant` varchar(10) DEFAULT NULL,
  `accountState` varchar(50) DEFAULT NULL,
  `suspensionStatus` varchar(10) DEFAULT NULL,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` varchar(10) DEFAULT NULL,
  `terminationRetentionStatus` varchar(10) DEFAULT NULL,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` varchar(10) DEFAULT NULL,
  `isThirdPartyAccount` varchar(10) DEFAULT NULL,
  `associatedAccountIds` text,
  `taxId` varchar(50) DEFAULT NULL,
  `smsrId` varchar(50) DEFAULT NULL,
  `iccidManager` varchar(50) DEFAULT NULL,
  `profileType` varchar(50) DEFAULT NULL,
  `providerId` varchar(50) DEFAULT NULL,
  `enterpriseId` varchar(50) DEFAULT NULL,
  `simManufacturer` varchar(50) DEFAULT NULL,
  `contractNumber` varchar(50) DEFAULT NULL,
  `whiteList` varchar(10) DEFAULT NULL,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(50) DEFAULT NULL,
  `accountCommitments` varchar(255) DEFAULT NULL,
  `primaryContactAddressLine2` varchar(255) DEFAULT NULL,
  `zipCode` varchar(20) DEFAULT NULL,
  `primaryContactCity` varchar(100) DEFAULT NULL,
  `primaryContactState` varchar(100) DEFAULT NULL,
  `extraMetadata` text,
  `salesforceId` varchar(255) DEFAULT NULL,
  `calendarMonth` varchar(10) DEFAULT NULL,
  `billingAddressLine2` varchar(10) DEFAULT NULL,
  `billingZipCode` varchar(50) DEFAULT NULL,
  `billingCity` varchar(10) DEFAULT NULL,
  `billingState` varchar(10) DEFAULT NULL,
  `billingCountry` varchar(10) DEFAULT NULL,
  `primaryContactCountry` varchar(10) DEFAULT NULL,
  `billingItemId` varchar(10) DEFAULT NULL,
  `billingPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `billingSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `errorMessage` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `smsConfiguration` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_success`
--

DROP TABLE IF EXISTS `bu_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_success` (
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(50) DEFAULT NULL,
  `classifier` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `billingflag` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `accountSegment` varchar(50) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(50) DEFAULT NULL,
  `bssPassword` varchar(50) DEFAULT NULL,
  `billingContactName` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingTelephone` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingMobile` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactFirstName` varchar(50) DEFAULT NULL,
  `primaryContactLastName` varchar(50) DEFAULT NULL,
  `primaryContactTelephone` varchar(50) DEFAULT NULL,
  `primaryContactMobile` varchar(50) DEFAULT NULL,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(50) DEFAULT NULL,
  `soContactLastName` varchar(50) DEFAULT NULL,
  `soContactEmail` varchar(100) DEFAULT NULL,
  `soContactTelephone` varchar(50) DEFAULT NULL,
  `soContactMobile` varchar(50) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(50) DEFAULT NULL,
  `modemType` varchar(50) DEFAULT NULL,
  `unitType` varchar(50) DEFAULT NULL,
  `simType` varchar(50) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(50) DEFAULT NULL,
  `goup_user_key` varchar(50) DEFAULT NULL,
  `goup_password` varchar(50) DEFAULT NULL,
  `application_key` varchar(50) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` varchar(10) DEFAULT NULL,
  `accountType` varchar(50) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `regionId` varchar(50) DEFAULT NULL,
  `areaCode` varchar(50) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(100) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(50) DEFAULT NULL,
  `isActivate` varchar(50) DEFAULT NULL,
  `imeiLock` varchar(10) DEFAULT NULL,
  `serviceGrant` varchar(10) DEFAULT NULL,
  `accountState` varchar(50) DEFAULT NULL,
  `suspensionStatus` varchar(10) DEFAULT NULL,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` varchar(10) DEFAULT NULL,
  `terminationRetentionStatus` varchar(10) DEFAULT NULL,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` varchar(10) DEFAULT NULL,
  `isThirdPartyAccount` varchar(10) DEFAULT NULL,
  `associatedAccountIds` text,
  `taxId` varchar(50) DEFAULT NULL,
  `smsrId` varchar(50) DEFAULT NULL,
  `iccidManager` varchar(50) DEFAULT NULL,
  `profileType` varchar(50) DEFAULT NULL,
  `providerId` varchar(50) DEFAULT NULL,
  `enterpriseId` varchar(50) DEFAULT NULL,
  `simManufacturer` varchar(50) DEFAULT NULL,
  `contractNumber` varchar(50) DEFAULT NULL,
  `whiteList` varchar(10) DEFAULT NULL,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(50) DEFAULT NULL,
  `accountCommitments` varchar(255) DEFAULT NULL,
  `primaryContactAddressLine2` varchar(255) DEFAULT NULL,
  `zipCode` varchar(20) DEFAULT NULL,
  `primaryContactCity` varchar(100) DEFAULT NULL,
  `primaryContactState` varchar(100) DEFAULT NULL,
  `extraMetadata` text,
  `salesforceId` varchar(255) DEFAULT NULL,
  `calendarMonth` varchar(10) DEFAULT NULL,
  `billingAddressLine2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingZipCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingCity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingState` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingCountry` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactCountry` varchar(10) DEFAULT NULL,
  `billingItemId` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `billingSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `smsConfiguration` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_success_old`
--

DROP TABLE IF EXISTS `bu_success_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bu_success_old` (
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(50) DEFAULT NULL,
  `classifier` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `billingFlag` varchar(10) DEFAULT NULL,
  `accountSegment` varchar(50) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(50) DEFAULT NULL,
  `bssPassword` varchar(50) DEFAULT NULL,
  `billingContactName` varchar(100) DEFAULT NULL,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` varchar(100) DEFAULT NULL,
  `billingTelephone` varchar(50) DEFAULT NULL,
  `billingMobile` varchar(50) DEFAULT NULL,
  `primaryContactFirstName` varchar(50) DEFAULT NULL,
  `primaryContactLastName` varchar(50) DEFAULT NULL,
  `primaryContactTelephone` varchar(50) DEFAULT NULL,
  `primaryContactMobile` varchar(50) DEFAULT NULL,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(50) DEFAULT NULL,
  `soContactLastName` varchar(50) DEFAULT NULL,
  `soContactEmail` varchar(100) DEFAULT NULL,
  `soContactTelephone` varchar(50) DEFAULT NULL,
  `soContactMobile` varchar(50) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(50) DEFAULT NULL,
  `modemType` varchar(50) DEFAULT NULL,
  `unitType` varchar(50) DEFAULT NULL,
  `simType` varchar(50) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(50) DEFAULT NULL,
  `goup_user_key` varchar(50) DEFAULT NULL,
  `goup_password` varchar(50) DEFAULT NULL,
  `application_key` varchar(50) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` varchar(10) DEFAULT NULL,
  `accountType` varchar(50) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `regionId` varchar(50) DEFAULT NULL,
  `areaCode` varchar(50) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(100) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(50) DEFAULT NULL,
  `isActivate` varchar(50) DEFAULT NULL,
  `imeiLock` varchar(10) DEFAULT NULL,
  `serviceGrant` varchar(10) DEFAULT NULL,
  `accountState` varchar(50) DEFAULT NULL,
  `suspensionStatus` varchar(10) DEFAULT NULL,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` varchar(10) DEFAULT NULL,
  `terminationRetentionStatus` varchar(10) DEFAULT NULL,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` varchar(10) DEFAULT NULL,
  `isThirdPartyAccount` varchar(10) DEFAULT NULL,
  `associatedAccountIds` text,
  `taxId` varchar(50) DEFAULT NULL,
  `smsrId` varchar(50) DEFAULT NULL,
  `iccidManager` varchar(50) DEFAULT NULL,
  `profileType` varchar(50) DEFAULT NULL,
  `providerId` varchar(50) DEFAULT NULL,
  `enterpriseId` varchar(50) DEFAULT NULL,
  `simManufacturer` varchar(50) DEFAULT NULL,
  `contractNumber` varchar(50) DEFAULT NULL,
  `whiteList` varchar(10) DEFAULT NULL,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(50) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_center_failure`
--

DROP TABLE IF EXISTS `cost_center_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_center_failure` (
  `seq_id` int NOT NULL AUTO_INCREMENT,
  `buAccountId` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `comments` text,
  `error_massage` text,
  PRIMARY KEY (`seq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_center_success`
--

DROP TABLE IF EXISTS `cost_center_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_center_success` (
  `seq_id` int NOT NULL AUTO_INCREMENT,
  `buAccountId` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `comments` text,
  PRIMARY KEY (`seq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `ISO_CODE` varchar(16) DEFAULT NULL,
  `NAME` varchar(64) DEFAULT NULL,
  `EXTRA_METADATA` varchar(64) DEFAULT NULL,
  `DELETED` tinyint DEFAULT NULL,
  `COUNTRY_CODE` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `csr_mapping_details`
--

DROP TABLE IF EXISTS `csr_mapping_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `csr_mapping_details` (
  `Device Plan` varchar(255) NOT NULL,
  `Service Plan param Voice Outgoing` varchar(10) DEFAULT NULL,
  `Service Plan param Voice Incoming` varchar(10) DEFAULT NULL,
  `Service Plan param Voice` varchar(10) DEFAULT NULL,
  `Service Plan param International Voice` varchar(10) DEFAULT NULL,
  `Voice PAYG` varchar(10) DEFAULT NULL,
  `Service Plan param SMS` varchar(10) DEFAULT NULL,
  `SMS PAYG` varchar(10) DEFAULT NULL,
  `Service Plan param Data` varchar(10) DEFAULT NULL,
  `Data PAYG` varchar(10) DEFAULT NULL,
  `Service Plan param Nbiot data` varchar(10) DEFAULT NULL,
  `Nbiot Data PAYG` varchar(10) DEFAULT NULL,
  `Service Plan param Is Roaming` varchar(10) DEFAULT NULL,
  `CSR END DATE` varchar(50) DEFAULT NULL,
  `Account Level VAS Charge` varchar(255) DEFAULT NULL,
  `Account Level VAS Charge Amount` varchar(50) DEFAULT NULL,
  `Account Level VAS END DATE` varchar(50) DEFAULT NULL,
  `Device Plan Vas Charge Device Plan` varchar(255) DEFAULT NULL,
  `Device Level Vas Charge` varchar(255) DEFAULT NULL,
  `Device Level VAS Charge Amount` varchar(50) DEFAULT NULL,
  `Device Level VAS Charge END Date` varchar(50) DEFAULT NULL,
  `Addon Plan` text,
  `Device_Level_Discount_Name` text,
  `Device_level_Discount_Price` varchar(255) DEFAULT NULL,
  `Discount Price` varchar(50) DEFAULT NULL,
  `Penalties` varchar(255) DEFAULT NULL,
  `Penalties Create Date` varchar(50) DEFAULT NULL,
  `Penalties Amout` varchar(50) DEFAULT NULL,
  `Adjustments` varchar(255) DEFAULT NULL,
  `Adjustments Create Date` varchar(50) DEFAULT NULL,
  `Adjustments Amount` varchar(50) DEFAULT NULL,
  `Account Level Discount Name` text,
  `Account_level_Discount_Price` varchar(255) DEFAULT NULL,
  `SERVICE_PROFILE_ID` varchar(255) NOT NULL,
  `Charge_level_device_plan` varchar(255) DEFAULT NULL,
  `Charge_level_Discount_Price` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `csr_mapping_master`
--

DROP TABLE IF EXISTS `csr_mapping_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `csr_mapping_master` (
  `SERVICE_PROFILE_ID` text NOT NULL,
  `Customer Name` varchar(255) NOT NULL,
  `Business Unit Name` varchar(255) NOT NULL,
  `Tariff Plan` varchar(255) NOT NULL,
  `APN LIST` text,
  `Device Plan LIST` text NOT NULL,
  `CUSTOMER_REFERENCE` varchar(255) NOT NULL,
  `BILLING_ACCOUNT` varchar(255) NOT NULL,
  `SP_NAME` text NOT NULL,
  `TP_NAME` varchar(255) DEFAULT NULL,
  `Service Profile Name` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CURRENCY` varchar(16) DEFAULT NULL,
  `SYMBOL` varchar(16) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_bill_cycle`
--

DROP TABLE IF EXISTS `dic_bill_cycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_bill_cycle` (
  `ID` int DEFAULT NULL,
  `BCTYPE` varchar(20) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_new_opco`
--

DROP TABLE IF EXISTS `dic_new_opco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_new_opco` (
  `CPARTY_ID` int DEFAULT NULL,
  `CRM_ID` int DEFAULT NULL,
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
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dic_user_roles_lookup`
--

DROP TABLE IF EXISTS `dic_user_roles_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_user_roles_lookup` (
  `LEGACYROLE` varchar(100) DEFAULT NULL,
  `NEWROLE` varchar(100) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_failure`
--

DROP TABLE IF EXISTS `ec_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_failure` (
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(255) DEFAULT NULL,
  `classifier` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `billingflag` varchar(255) DEFAULT NULL,
  `accountSegment` varchar(255) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(255) DEFAULT NULL,
  `bssPassword` varchar(255) DEFAULT NULL,
  `billingContactName` varchar(255) DEFAULT NULL,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` varchar(255) DEFAULT NULL,
  `billingTelephone` varchar(255) DEFAULT NULL,
  `billingMobile` varchar(255) DEFAULT NULL,
  `primaryContactFirstName` varchar(100) DEFAULT NULL,
  `primaryContactLastName` varchar(100) DEFAULT NULL,
  `primaryContactTelephone` varchar(32) DEFAULT NULL,
  `primaryContactMobile` varchar(32) DEFAULT NULL,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(100) DEFAULT NULL,
  `soContactLastName` varchar(100) DEFAULT NULL,
  `soContactEmail` varchar(255) DEFAULT NULL,
  `soContactTelephone` varchar(255) DEFAULT NULL,
  `soContactMobile` varchar(255) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(255) DEFAULT NULL,
  `modemType` varchar(255) DEFAULT NULL,
  `unitType` varchar(255) DEFAULT NULL,
  `simType` varchar(255) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(255) DEFAULT NULL,
  `goup_user_key` varchar(255) DEFAULT NULL,
  `goup_password` varchar(255) DEFAULT NULL,
  `application_key` varchar(255) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` int DEFAULT NULL,
  `accountType` varchar(255) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `regionId` varchar(255) DEFAULT NULL,
  `areaCode` varchar(255) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(255) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(255) DEFAULT NULL,
  `isActivate` varchar(255) DEFAULT NULL,
  `imeiLock` varchar(20) DEFAULT NULL,
  `serviceGrant` varchar(20) DEFAULT NULL,
  `accountState` varchar(255) DEFAULT NULL,
  `suspensionStatus` varchar(20) DEFAULT NULL,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` varchar(20) DEFAULT NULL,
  `terminationRetentionStatus` varchar(20) DEFAULT NULL,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` varchar(20) DEFAULT NULL,
  `isThirdPartyAccount` varchar(20) DEFAULT NULL,
  `associatedAccountIds` text,
  `taxId` varchar(255) DEFAULT NULL,
  `smsrId` varchar(255) DEFAULT NULL,
  `iccidManager` varchar(255) DEFAULT NULL,
  `profileType` varchar(255) DEFAULT NULL,
  `providerId` varchar(255) DEFAULT NULL,
  `enterpriseId` varchar(255) DEFAULT NULL,
  `simManufacturer` varchar(255) DEFAULT NULL,
  `contractNumber` varchar(255) DEFAULT NULL,
  `whiteList` varchar(20) DEFAULT NULL,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(255) DEFAULT NULL,
  `accountCommitments` varchar(255) DEFAULT NULL,
  `primaryContactAddressLine2` varchar(255) DEFAULT NULL,
  `zipCode` varchar(20) DEFAULT NULL,
  `primaryContactCity` varchar(100) DEFAULT NULL,
  `primaryContactState` varchar(100) DEFAULT NULL,
  `extraMetadata` text,
  `salesforceId` varchar(255) DEFAULT NULL,
  `calendarMonth` varchar(10) DEFAULT NULL,
  `billingAddressLine2` varchar(10) DEFAULT NULL,
  `billingZipCode` varchar(50) DEFAULT NULL,
  `billingCity` varchar(10) DEFAULT NULL,
  `billingState` varchar(10) DEFAULT NULL,
  `billingCountry` varchar(10) DEFAULT NULL,
  `primaryContactCountry` varchar(10) DEFAULT NULL,
  `billingPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `billingSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsPrimaryCountryCode` varchar(20) DEFAULT NULL,
  `contactDetailsSecondaryCountryCode` varchar(20) DEFAULT NULL,
  `errorMessage` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_success`
--

DROP TABLE IF EXISTS `ec_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_success` (
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(255) DEFAULT NULL,
  `classifier` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `billingflag` varchar(255) DEFAULT NULL,
  `accountSegment` varchar(255) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(255) DEFAULT NULL,
  `bssPassword` varchar(255) DEFAULT NULL,
  `billingContactName` varchar(255) DEFAULT NULL,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` varchar(255) DEFAULT NULL,
  `billingTelephone` varchar(255) DEFAULT NULL,
  `billingMobile` varchar(255) DEFAULT NULL,
  `primaryContactFirstName` varchar(100) DEFAULT NULL,
  `primaryContactLastName` varchar(100) DEFAULT NULL,
  `primaryContactTelephone` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactMobile` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(100) DEFAULT NULL,
  `soContactLastName` varchar(100) DEFAULT NULL,
  `soContactEmail` varchar(255) DEFAULT NULL,
  `soContactTelephone` varchar(255) DEFAULT NULL,
  `soContactMobile` varchar(255) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(255) DEFAULT NULL,
  `modemType` varchar(255) DEFAULT NULL,
  `unitType` varchar(255) DEFAULT NULL,
  `simType` varchar(255) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(255) DEFAULT NULL,
  `goup_user_key` varchar(255) DEFAULT NULL,
  `goup_password` varchar(255) DEFAULT NULL,
  `application_key` varchar(255) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` int DEFAULT NULL,
  `accountType` varchar(255) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `regionId` varchar(255) DEFAULT NULL,
  `areaCode` varchar(255) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(255) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(255) DEFAULT NULL,
  `isActivate` varchar(255) DEFAULT NULL,
  `imeiLock` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `serviceGrant` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `accountState` varchar(255) DEFAULT NULL,
  `suspensionStatus` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `terminationRetentionStatus` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `isThirdPartyAccount` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `associatedAccountIds` text,
  `taxId` varchar(255) DEFAULT NULL,
  `smsrId` varchar(255) DEFAULT NULL,
  `iccidManager` varchar(255) DEFAULT NULL,
  `profileType` varchar(255) DEFAULT NULL,
  `providerId` varchar(255) DEFAULT NULL,
  `enterpriseId` varchar(255) DEFAULT NULL,
  `simManufacturer` varchar(255) DEFAULT NULL,
  `contractNumber` varchar(255) DEFAULT NULL,
  `whiteList` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(255) DEFAULT NULL,
  `accountCommitments` varchar(255) DEFAULT NULL,
  `primaryContactAddressLine2` varchar(255) DEFAULT NULL,
  `zipCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactCity` varchar(100) DEFAULT NULL,
  `primaryContactState` varchar(100) DEFAULT NULL,
  `extraMetadata` text,
  `salesforceId` varchar(255) DEFAULT NULL,
  `calendarMonth` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingAddressLine2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingZipCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingCity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingState` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingCountry` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `primaryContactCountry` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingPrimaryCountryCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `billingSecondaryCountryCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `contactDetailsPrimaryCountryCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `contactDetailsSecondaryCountryCode` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ec_success_old`
--

DROP TABLE IF EXISTS `ec_success_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ec_success_old` (
  `parentAccountId` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `accountModel` varchar(255) DEFAULT NULL,
  `classifier` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `billingflag` varchar(255) DEFAULT NULL,
  `accountSegment` varchar(255) DEFAULT NULL,
  `redirectionRatingGroupId` int DEFAULT NULL,
  `redirectionUrl` varchar(255) DEFAULT NULL,
  `bssid` varchar(255) DEFAULT NULL,
  `bssUserName` varchar(255) DEFAULT NULL,
  `bssPassword` varchar(255) DEFAULT NULL,
  `billingContactName` varchar(255) DEFAULT NULL,
  `billingAddress` varchar(255) DEFAULT NULL,
  `billingEmail` varchar(255) DEFAULT NULL,
  `billingTelephone` varchar(255) DEFAULT NULL,
  `billingMobile` varchar(255) DEFAULT NULL,
  `primaryContactFirstName` varchar(100) DEFAULT NULL,
  `primaryContactLastName` varchar(100) DEFAULT NULL,
  `primaryContactTelephone` varchar(32) DEFAULT NULL,
  `primaryContactMobile` varchar(32) DEFAULT NULL,
  `primaryContactEmail` varchar(100) DEFAULT NULL,
  `soContactFirstName` varchar(100) DEFAULT NULL,
  `soContactLastName` varchar(100) DEFAULT NULL,
  `soContactEmail` varchar(255) DEFAULT NULL,
  `soContactTelephone` varchar(255) DEFAULT NULL,
  `soContactMobile` varchar(255) DEFAULT NULL,
  `soContactAddress` varchar(255) DEFAULT NULL,
  `sourceNumber` varchar(255) DEFAULT NULL,
  `modemType` varchar(255) DEFAULT NULL,
  `unitType` varchar(255) DEFAULT NULL,
  `simType` varchar(255) DEFAULT NULL,
  `deviceVolume` varchar(255) DEFAULT NULL,
  `deviceDescription` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `bssClientCode` varchar(255) DEFAULT NULL,
  `goup_user_name` varchar(255) DEFAULT NULL,
  `goup_user_key` varchar(255) DEFAULT NULL,
  `goup_password` varchar(255) DEFAULT NULL,
  `application_key` varchar(255) DEFAULT NULL,
  `goup_url` varchar(255) DEFAULT NULL,
  `token_url` varchar(255) DEFAULT NULL,
  `isBss` int DEFAULT NULL,
  `accountType` varchar(255) DEFAULT NULL,
  `billDate` int DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `regionId` varchar(255) DEFAULT NULL,
  `areaCode` varchar(255) DEFAULT NULL,
  `legacyBan` int DEFAULT NULL,
  `billingSecondaryEmail` varchar(255) DEFAULT NULL,
  `primaryContactAddress` varchar(255) DEFAULT NULL,
  `countryId` int DEFAULT NULL,
  `currencyid` varchar(255) DEFAULT NULL,
  `externalId` varchar(255) DEFAULT NULL,
  `isActivate` varchar(255) DEFAULT NULL,
  `imeiLock` varchar(20) DEFAULT NULL,
  `serviceGrant` varchar(20) DEFAULT NULL,
  `accountState` varchar(255) DEFAULT NULL,
  `suspensionStatus` varchar(20) DEFAULT NULL,
  `terminationStatus` int DEFAULT NULL,
  `terminationStateStatus` varchar(20) DEFAULT NULL,
  `terminationRetentionStatus` varchar(20) DEFAULT NULL,
  `maxSimNumber` int DEFAULT NULL,
  `simAccountType` varchar(20) DEFAULT NULL,
  `isThirdPartyAccount` varchar(20) DEFAULT NULL,
  `associatedAccountIds` text,
  `taxId` varchar(255) DEFAULT NULL,
  `smsrId` varchar(255) DEFAULT NULL,
  `iccidManager` varchar(255) DEFAULT NULL,
  `profileType` varchar(255) DEFAULT NULL,
  `providerId` varchar(255) DEFAULT NULL,
  `enterpriseId` varchar(255) DEFAULT NULL,
  `simManufacturer` varchar(255) DEFAULT NULL,
  `contractNumber` varchar(255) DEFAULT NULL,
  `whiteList` varchar(20) DEFAULT NULL,
  `notificationCentreApiUrl` varchar(255) DEFAULT NULL,
  `extendedDetail` varchar(255) DEFAULT NULL,
  `notificationUrlSmsForwarding` varchar(255) DEFAULT NULL,
  `featureSubTypeSmsForwarding` varchar(255) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_pool_success`
--

DROP TABLE IF EXISTS `ip_pool_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_pool_success` (
  `accountId` int DEFAULT NULL,
  `ipPoolName` varchar(4000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rangeStart` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rangeEnd` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requestedIps` int DEFAULT NULL,
  `apnId` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loading_summary`
--

DROP TABLE IF EXISTS `loading_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loading_summary` (
  `entity_type` varchar(255) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failure_count` int DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  `create_date` date DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_assets_cdp`
--

DROP TABLE IF EXISTS `migration_assets_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_assets_cdp` (
  `IMSI` varchar(32) DEFAULT NULL,
  `account_id` varchar(32) DEFAULT NULL,
  `event_date` varchar(32) DEFAULT NULL,
  `ACTIVATION_DATE` varchar(32) DEFAULT NULL,
  `DEVICE_ID` varchar(32) DEFAULT NULL,
  `SERVICE_PLAN_ID` varchar(32) DEFAULT NULL,
  `ICCID` varchar(32) DEFAULT NULL,
  `MSISDN` varchar(32) DEFAULT NULL,
  `reason` varchar(128) DEFAULT NULL,
  `STATE` varchar(32) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11436 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_device_plan_cdp`
--

DROP TABLE IF EXISTS `migration_device_plan_cdp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_device_plan_cdp` (
  `device_plan_id` varchar(32) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `TYPE` varchar(32) DEFAULT NULL,
  `pool_limit` varchar(32) DEFAULT NULL,
  `frequency` varchar(32) DEFAULT NULL,
  `template_id` varchar(32) DEFAULT NULL,
  `billing_account_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_failure`
--

DROP TABLE IF EXISTS `notifications_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_failure` (
  `id` bigint DEFAULT NULL,
  `templateName` varchar(255) DEFAULT NULL,
  `notificationType` varchar(50) DEFAULT NULL,
  `accountId` bigint DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text,
  `description` varchar(500) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `errorMessage` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_success`
--

DROP TABLE IF EXISTS `notifications_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_success` (
  `id` bigint DEFAULT NULL,
  `templateName` varchar(255) DEFAULT NULL,
  `notificationType` varchar(50) DEFAULT NULL,
  `accountId` bigint DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text,
  `description` varchar(500) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parent_id_mapping`
--

DROP TABLE IF EXISTS `parent_id_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parent_id_mapping` (
  `id` varchar(255) DEFAULT NULL,
  `crm_id` varchar(255) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_subscriptions_failure`
--

DROP TABLE IF EXISTS `report_subscriptions_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_subscriptions_failure` (
  `accountId` varchar(255) DEFAULT NULL,
  `isEmailEnable` varchar(50) DEFAULT NULL,
  `emailId` varchar(255) DEFAULT NULL,
  `reportType` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `reportStartDate` date DEFAULT NULL,
  `reportEndDate` date DEFAULT NULL,
  `roleId` varchar(50) DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  `subscriptionType` varchar(50) DEFAULT NULL,
  `subscriptionName` varchar(255) DEFAULT NULL,
  `fromValue` varchar(255) DEFAULT NULL,
  `toValue` varchar(255) DEFAULT NULL,
  `from_plan` varchar(255) DEFAULT NULL,
  `to_plan` varchar(255) DEFAULT NULL,
  `errorMessage` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `reportSubscriptionDetails` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_subscriptions_success`
--

DROP TABLE IF EXISTS `report_subscriptions_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_subscriptions_success` (
  `accountId` varchar(255) DEFAULT NULL,
  `isEmailEnable` varchar(50) DEFAULT NULL,
  `emailId` varchar(255) DEFAULT NULL,
  `reportType` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `reportStartDate` date DEFAULT NULL,
  `reportEndDate` date DEFAULT NULL,
  `roleId` varchar(50) DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  `subscriptionType` varchar(50) DEFAULT NULL,
  `subscriptionName` varchar(255) DEFAULT NULL,
  `fromValue` varchar(255) DEFAULT NULL,
  `toValue` varchar(255) DEFAULT NULL,
  `from_plan` varchar(255) DEFAULT NULL,
  `to_plan` varchar(255) DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `reportSubscriptionDetails` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_failure`
--

DROP TABLE IF EXISTS `role_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_failure` (
  `groupId` int DEFAULT NULL,
  `accountId` int DEFAULT NULL,
  `roleName` varchar(255) DEFAULT NULL,
  `roleDescription` varchar(255) DEFAULT NULL,
  `roleToScreenList` text,
  `roleToTabList` text,
  `errorMessage` varchar(512) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_success`
--

DROP TABLE IF EXISTS `role_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_success` (
  `groupId` int DEFAULT NULL,
  `accountId` int DEFAULT NULL,
  `roleName` varchar(255) DEFAULT NULL,
  `roleDescription` varchar(255) DEFAULT NULL,
  `roleToScreenList` text,
  `roleToTabList` text,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_table_list`
--

DROP TABLE IF EXISTS `role_table_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_table_list` (
  `roleDescription` varchar(255) DEFAULT NULL,
  `roleToScreenList` json DEFAULT NULL,
  `roleToTabList` json DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tab_list`
--

DROP TABLE IF EXISTS `tab_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tab_list` (
  `Static_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template_id_mapping`
--

DROP TABLE IF EXISTS `template_id_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_id_mapping` (
  `id` varchar(100) DEFAULT NULL,
  `template_id` varchar(100) DEFAULT NULL,
  `notificationType` varchar(100) DEFAULT NULL,
  `templateName` varchar(100) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_failure`
--

DROP TABLE IF EXISTS `trigger_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_failure` (
  `rule_name` varchar(100) DEFAULT NULL,
  `accountId` bigint DEFAULT NULL,
  `rule_category_id` varchar(100) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `rule_description` varchar(100) DEFAULT NULL,
  `imsi_from` varchar(100) DEFAULT NULL,
  `all_devices` varchar(100) DEFAULT NULL,
  `in_application_level` varchar(100) DEFAULT NULL,
  `action_type_id` varchar(100) DEFAULT NULL,
  `action_email_id` varchar(100) DEFAULT NULL,
  `action_contact_number` varchar(100) DEFAULT NULL,
  `state_change` varchar(100) DEFAULT NULL,
  `changed_device_plan_id` varchar(100) DEFAULT NULL,
  `webhook_metadata` varchar(100) DEFAULT NULL,
  `in_reset_period` varchar(100) DEFAULT NULL,
  `in_category` varchar(100) DEFAULT NULL,
  `in_rule_access` varchar(100) DEFAULT NULL,
  `in_sim_next_bill_cycle_change` varchar(100) DEFAULT NULL,
  `in_device_update_in_next_bill_cycle` varchar(100) DEFAULT NULL,
  `in_device_next_bill_cycle_change_id` varchar(100) DEFAULT NULL,
  `create_date` varchar(100) DEFAULT NULL,
  `is_active` varchar(100) DEFAULT NULL,
  `CONDITION_TYPE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_C_TP_FA_DATA` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_COND_TP_FA_SMS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_C_TP_FA_VOICE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_POINT_IN_TIME_TIME` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_CT_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_VT_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_SIM_IN_SP_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_SIM_IN_SP_NO_OF_DAYS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_FACTIVITY_NO_DAYS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_SP_CHANGE_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_COOC_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_COOC_CHANGE_TYPE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_MAIL_TEMPLATE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_SMS_TEMPLATE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_MAIL_DEFINITION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_MAIL_MESSAGE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_MAIL_SUBJECT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_SMS_DEFINITION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_SMS_MESSAGE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `errorMessage` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trigger_success`
--

DROP TABLE IF EXISTS `trigger_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trigger_success` (
  `rule_name` varchar(100) DEFAULT NULL,
  `accountId` bigint DEFAULT NULL,
  `rule_category_id` varchar(100) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `rule_description` varchar(100) DEFAULT NULL,
  `imsi_from` varchar(100) DEFAULT NULL,
  `all_devices` varchar(100) DEFAULT NULL,
  `in_application_level` varchar(100) DEFAULT NULL,
  `action_type_id` varchar(100) DEFAULT NULL,
  `action_email_id` varchar(100) DEFAULT NULL,
  `action_contact_number` varchar(100) DEFAULT NULL,
  `state_change` varchar(100) DEFAULT NULL,
  `changed_device_plan_id` varchar(100) DEFAULT NULL,
  `webhook_metadata` varchar(100) DEFAULT NULL,
  `in_reset_period` varchar(100) DEFAULT NULL,
  `in_category` varchar(100) DEFAULT NULL,
  `in_rule_access` varchar(100) DEFAULT NULL,
  `in_sim_next_bill_cycle_change` varchar(100) DEFAULT NULL,
  `in_device_update_in_next_bill_cycle` varchar(100) DEFAULT NULL,
  `in_device_next_bill_cycle_change_id` varchar(100) DEFAULT NULL,
  `create_date` varchar(100) DEFAULT NULL,
  `is_active` varchar(100) DEFAULT NULL,
  `CONDITION_TYPE` varchar(100) DEFAULT NULL,
  `T_IAA_C_TP_FA_DATA` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_COND_TP_FA_SMS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_C_TP_FA_VOICE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_POINT_IN_TIME_TIME` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_CT_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_VT_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_SIM_IN_SP_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_SIM_IN_SP_NO_OF_DAYS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_TP_FACTIVITY_NO_DAYS` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_SP_CHANGE_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_COOC_SP_CONTEXT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IC_COOC_CHANGE_TYPE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_MAIL_TEMPLATE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_SMS_TEMPLATE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_MAIL_DEFINITION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_MAIL_MESSAGE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_MAIL_SUBJECT` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAA_SMS_DEFINITION` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `T_IAS_SMS_MESSAGE` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_failure`
--

DROP TABLE IF EXISTS `user_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_failure` (
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `primaryPhone` varchar(255) DEFAULT NULL,
  `secondaryPhone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emailConf` varchar(255) DEFAULT NULL,
  `roleId` varchar(255) DEFAULT NULL,
  `countryId` varchar(255) DEFAULT NULL,
  `timeZoneId` int DEFAULT NULL,
  `locked` varchar(10) DEFAULT NULL,
  `accountId` int DEFAULT NULL,
  `userName` varchar(255) DEFAULT NULL,
  `groupId` varchar(255) DEFAULT NULL,
  `userType` varchar(255) DEFAULT NULL,
  `userAccountType` varchar(255) DEFAULT NULL,
  `supervisorId` varchar(255) DEFAULT NULL,
  `resetPasswordAction` varchar(10) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `secondaryCountryCode` varchar(10) DEFAULT NULL,
  `countryCode` varchar(10) DEFAULT NULL,
  `errorMessage` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_success`
--

DROP TABLE IF EXISTS `user_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_success` (
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `primaryPhone` varchar(255) DEFAULT NULL,
  `secondaryPhone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emailConf` varchar(255) DEFAULT NULL,
  `roleId` varchar(255) DEFAULT NULL,
  `countryId` varchar(255) DEFAULT NULL,
  `timeZoneId` int DEFAULT NULL,
  `locked` varchar(10) DEFAULT NULL,
  `accountId` int DEFAULT NULL,
  `userName` varchar(255) DEFAULT NULL,
  `groupId` varchar(255) DEFAULT NULL,
  `userType` varchar(255) DEFAULT NULL,
  `userAccountType` varchar(255) DEFAULT NULL,
  `supervisorId` varchar(255) DEFAULT NULL,
  `resetPasswordAction` varchar(10) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `secondaryCountryCode` varchar(10) DEFAULT NULL,
  `countryCode` varchar(10) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_success_old`
--

DROP TABLE IF EXISTS `user_success_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_success_old` (
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `primaryPhone` varchar(255) DEFAULT NULL,
  `secondaryPhone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emailConf` varchar(255) DEFAULT NULL,
  `roleid` varchar(255) DEFAULT NULL,
  `countryid` varchar(255) DEFAULT NULL,
  `timeZoneId` int DEFAULT NULL,
  `locked` varchar(10) DEFAULT NULL,
  `accountId` int DEFAULT NULL,
  `userName` varchar(255) DEFAULT NULL,
  `groupid` varchar(255) DEFAULT NULL,
  `userType` varchar(255) DEFAULT NULL,
  `userAccountType` varchar(255) DEFAULT NULL,
  `supervisorId` varchar(255) DEFAULT NULL,
  `resetPasswordAction` varchar(10) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:33
