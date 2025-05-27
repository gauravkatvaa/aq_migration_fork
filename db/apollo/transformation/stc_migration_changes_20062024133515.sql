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

-- Dumping structure for procedure stc_migration.assests_details_cdp
DROP PROCEDURE IF EXISTS `assests_details_cdp`;
DELIMITER //
CREATE PROCEDURE `assests_details_cdp`(
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
END//
DELIMITER ;

-- Dumping structure for procedure stc_migration.migration_assets_cdp
DROP PROCEDURE IF EXISTS `migration_assets_cdp`;
DELIMITER //
CREATE PROCEDURE `migration_assets_cdp`()
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
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
