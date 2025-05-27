-- --------------------------------------------------------
-- Host:                         10.226.72.110
-- Server version:               8.0.34 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for procedure stc_migration.apn_management_cdp
DROP PROCEDURE IF EXISTS `apn_management_cdp`;
DELIMITER //
CREATE PROCEDURE `apn_management_cdp`()
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
	  
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
