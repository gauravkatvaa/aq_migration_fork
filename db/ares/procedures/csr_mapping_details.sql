DELIMITER $$

DROP PROCEDURE IF EXISTS `csr_mapping_details`$$

CREATE PROCEDURE `csr_mapping_details`()
BEGIN
SELECT
	sp.BUNDLE AS "Device Plan",
	IFNULL(sp.VOICE_OUTGOING_BARRING, '0') AS "Service Plan param Voice Outgoing",
	IFNULL(sp.VOICE_INCOMING_BARRING, '0') AS "Service Plan param Voice Incoming",
	IFNULL(sp.ENABLE_VOICE_SERVICE, 'No') AS "Service Plan param Voice",
	NULL AS "Service Plan param International Voice",
	0 AS "Voice PAYG",
	IFNULL(sp.ENABLE_SMS_MO, 'No') AS "Service Plan param SMS",
	CASE
	WHEN sp.ENABLE_SMS_MO = 'Yes' OR sp.ENABLE_SMS_MT = 'Yes' THEN 1
	ELSE 0
	END AS "SMS PAYG",
	IFNULL(sp.ENABLE_DATA, 'No') AS "Service Plan param Data",
	CASE
	WHEN sp.ENABLE_DATA = 'Yes' THEN 1
	ELSE 0
	END AS "Data PAYG",
	IFNULL(sp.ENABLE_NB_IOT_SERVICE, 'No') AS "Service Plan param Nbiot data",
	CASE
	WHEN sp.ENABLE_NB_IOT_SERVICE = 'Yes' THEN 1
	ELSE 0
	END AS "Nbiot Data PAYG",
	IFNULL(sp.ENABLE_ROAMING_PROFILE, '0') AS "Service Plan param Is Roaming",
	NULL AS "CSR END DATE",
	NULL AS "Account Level VAS Charge",
	NULL AS "Account Level VAS Charge Amount",
	NULL AS "Account Level VAS END DATE",
	NULL AS "Device Plan Vas Charge Device Plan",
	NULL AS "Device Level Vas Charge",
	NULL AS "Device Level VAS Charge Amount",
	NULL AS "Device Level VAS Charge END Date",
	null AS "Addon Plan",
	null AS "Device_Level_Discount_Name",
	null AS "Device_level_Discount_Price",
	NULL AS "Discount Price",
	NULL AS "Penalties",
	NULL AS "Penalties Create Date",
	NULL AS "Penalties Amout",
	NULL AS "Adjustments",
	NULL AS "Adjustments Create Date",
	NULL AS "Adjustments Amount",
	'Monthly Account Fee' AS "Account Level Discount Name",
	IFNULL(ctp.PRICE_PER_UNIT, '0') AS "Account_level_Discount_Price",
	sp.ID AS SERVICE_PROFILE_ID,
	NULL AS "Charge_level_device_plan",
	NULL AS "Charge_level_Discount_Price"
FROM service_profiles_success sp
JOIN life_cycles_success lc ON lc.ID = sp.OWNING_LIFECYCLE_ID
JOIN bu_success bu ON bu.BUCRM_ID = lc.BU_ID
LEFT JOIN validation.combined_tariff_plans ctp ON
(ctp.TARIFF_PLAN COLLATE utf8mb4_0900_ai_ci = sp.NAME COLLATE utf8mb4_0900_ai_ci 
OR ctp.TARIFF_PLAN_ID = sp.ID 
OR ctp.CUSTOMER COLLATE utf8mb4_0900_ai_ci = bu.EC_NAME COLLATE utf8mb4_0900_ai_ci);

END$$

DELIMITER ;