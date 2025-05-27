DELIMITER $$

DROP PROCEDURE IF EXISTS `csr_mapping_master`$$

CREATE DEFINER=`aqadmin`@`%` PROCEDURE `validation`.`csr_mapping_master`()
BEGIN
    -- First, get all the unique service profile, BU, customer combinations
    -- with their associated APN information
    WITH base_data AS (
        SELECT
            sp.ID AS service_profile_id,
            c.EC_NAME AS customer_name,
            bu.BU_NAME AS bu_name,
            sp.TARIFF_PLAN AS tp_name,
            CONCAT('TP_T', c.CRM_ID, 'T') AS tariff_plan,
            apn.APN AS apn,
            sp.BUNDLE AS bundle,
            c.CRM_ID AS crm_id,
            bu.BUCRM_ID AS bucrm_id,
            sp.NAME AS sp_name
        FROM service_profiles_success sp
        JOIN life_cycles_success lc ON lc.ID = sp.OWNING_LIFECYCLE_ID
        JOIN bu_success bu ON bu.BUCRM_ID = lc.BU_ID
        JOIN ec_success c ON c.CRM_ID = bu.EC_CRM_ID
        LEFT JOIN apn_success apn ON 
            -- Join using FIND_IN_SET to handle comma-separated APN_IDs
            FIND_IN_SET(apn.APN_ID, sp.APN_ID)
    )
    
    -- Then aggregate the data by customer/BU, combining all service profiles, APNs, etc.
    SELECT
        GROUP_CONCAT(DISTINCT service_profile_id SEPARATOR '&&') AS SERVICE_PROFILE_ID,
        customer_name AS "Customer Name",
        bu_name AS "Business Unit Name",
        tp_name AS "TP_NAME",
        tariff_plan AS "Tariff Plan",
        GROUP_CONCAT(DISTINCT apn SEPARATOR '&&') AS "APN LIST",
        GROUP_CONCAT(DISTINCT bundle SEPARATOR '&&') AS "Device Plan LIST",
        CAST(crm_id AS CHAR) AS CUSTOMER_REFERENCE,
        CAST(bucrm_id AS CHAR) AS BILLING_ACCOUNT,
        CONCAT('SP_', bucrm_id) AS SP_NAME,
        GROUP_CONCAT(DISTINCT sp_name SEPARATOR '&&') AS "Service Profile Name"
    FROM base_data
    GROUP BY
        customer_name,
        bu_name,
        tariff_plan,
        crm_id,
        bucrm_id;

END$$

DELIMITER ;