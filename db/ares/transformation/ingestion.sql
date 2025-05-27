-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: ingestion
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
-- Current Database: `ingestion`
--

/*!40000 DROP DATABASE IF EXISTS `ingestion`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ingestion` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ingestion`;

--
-- Table structure for table `apn_failure`
--

DROP TABLE IF EXISTS `apn_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apn_failure` (
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
  `errorMessage` varchar(256) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `accountId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `relationId` varchar(255) DEFAULT NULL,
  `requestId` varchar(100) DEFAULT NULL,
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
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `relationId` varchar(255) DEFAULT NULL,
  `requestId` varchar(100) DEFAULT NULL,
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
  `errorMessage` text,
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
  `relationId` varchar(100) DEFAULT NULL,
  `requestId` text,
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
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `relationId` varchar(100) DEFAULT NULL,
  `requestId` varchar(100) DEFAULT NULL,
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
  `errorMessage` varchar(512) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
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
  `OPCOID` varchar(40) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
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
  `NAME` varchar(2000) DEFAULT NULL,
  `TEXT` varchar(2000) DEFAULT NULL,
  `SUBJECT` varchar(2000) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `CUSTOMER_ID` bigint DEFAULT NULL,
  `BU_ID` bigint DEFAULT NULL,
  `RESELLER_ID` bigint DEFAULT NULL,
  `TEMPLATE_DESCRIPTION` text,
  `SMS_TYPE` varchar(255) DEFAULT NULL,
  `errorMessage` varchar(512) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_success`
--

DROP TABLE IF EXISTS `notifications_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_success` (
  `ID` bigint NOT NULL,
  `NAME` varchar(2000) DEFAULT NULL,
  `TEXT` varchar(2000) DEFAULT NULL,
  `SUBJECT` varchar(2000) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `CUSTOMER_ID` bigint DEFAULT NULL,
  `BU_ID` bigint DEFAULT NULL,
  `RESELLER_ID` bigint DEFAULT NULL,
  `TEMPLATE_DESCRIPTION` text,
  `SMS_TYPE` varchar(255) DEFAULT NULL,
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
  `account_id` varchar(100) DEFAULT NULL,
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
  `account_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `triggers_failure`
--

DROP TABLE IF EXISTS `triggers_failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triggers_failure` (
  `NAME` varchar(256) NOT NULL,
  `DESCRIPTION` text,
  `CRMOPCO_ID` bigint NOT NULL,
  `CRMEC_ID` bigint NOT NULL,
  `CRMBU_ID` bigint DEFAULT NULL,
  `CRMCC_ID` bigint DEFAULT NULL,
  `IMSI` varchar(16) DEFAULT NULL,
  `CREATION_DATE` datetime(6) DEFAULT NULL,
  `ACTIVATION_DATE` datetime(6) DEFAULT NULL,
  `DEACTIVATION_DATE` datetime(6) DEFAULT NULL,
  `ACTIVE` tinyint NOT NULL,
  `VISIBLE` tinyint NOT NULL,
  `EDITABLE` tinyint NOT NULL,
  `ACTION_TYPE` varchar(255) DEFAULT NULL,
  `CONDITION_TYPE` varchar(255) DEFAULT NULL,
  `LEVEL_TYPE` varchar(255) DEFAULT NULL,
  `TRIGGER_TYPE` varchar(255) DEFAULT NULL,
  `ACTION_ID` bigint NOT NULL,
  `CONDITION_ID` bigint NOT NULL,
  `RAISE_COUNT` bigint NOT NULL,
  `LAST_ACTIVE_TRIGGER_ID` bigint DEFAULT NULL,
  `errorMessage` varchar(512) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `triggers_success`
--

DROP TABLE IF EXISTS `triggers_success`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triggers_success` (
  `NAME` varchar(256) NOT NULL,
  `DESCRIPTION` text,
  `CRMOPCO_ID` bigint NOT NULL,
  `CRMEC_ID` bigint NOT NULL,
  `CRMBU_ID` bigint DEFAULT NULL,
  `CRMCC_ID` bigint DEFAULT NULL,
  `IMSI` varchar(16) DEFAULT NULL,
  `CREATION_DATE` datetime(6) DEFAULT NULL,
  `ACTIVATION_DATE` datetime(6) DEFAULT NULL,
  `DEACTIVATION_DATE` datetime(6) DEFAULT NULL,
  `ACTIVE` tinyint NOT NULL,
  `VISIBLE` tinyint NOT NULL,
  `EDITABLE` tinyint NOT NULL,
  `ACTION_TYPE` varchar(255) DEFAULT NULL,
  `CONDITION_TYPE` varchar(255) DEFAULT NULL,
  `LEVEL_TYPE` varchar(255) DEFAULT NULL,
  `TRIGGER_TYPE` varchar(255) DEFAULT NULL,
  `ACTION_ID` bigint NOT NULL,
  `CONDITION_ID` bigint NOT NULL,
  `RAISE_COUNT` bigint NOT NULL,
  `LAST_ACTIVE_TRIGGER_ID` bigint DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
