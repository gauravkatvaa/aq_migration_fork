DELIMITER $$

USE `stc_migration`$$

DROP PROCEDURE IF EXISTS `migration_api_user`$$

CREATE DEFINER=`aqadmin`@`%` PROCEDURE `migration_api_user`()
BEGIN
SELECT DISTINCT LOGIN,
	FIRST_NAME,
	LAST_NAME,
	EMAIL,
	'False' AS locked,
	"1,72,1,58,1,75,1,90,1,62,1,121,1,122,1,70,1,91,1,60,1,126,1,123,1,78,1,130,1,131,1,175,1,196,1,298,1,8,1,9,1,61,1,116,1,108,1,125,1,129,1,66,1,2,1,74,1,60,1,59,1,79,1,84,1,85,1,86,1,87,1,88,1,89,1,97,1,98,1,92,1,124,1,185,1,186,1,148,1,149,1,150,1,151,1,152,1,153,1,154,1,155,1,156,1,157,1,158,1,159,1,160,1,161,1,162,1,163,1,164,1,165,1,166,1,167,1,168,1,169,1,170,1,171,1,172,1,173,1,194,1,195,1,176,1,178,1,179,1,180,1,181,1,182,1,183,1,184,1,188,1,189,1,115,1,192,1,193,1,280,1,202,1,201,1,203,1,224,1,204,1,206,1,205,1,211,1,223,1,225,1,207,1,281,1,191,1,319,1,314,1,315,1,316,1,305,1,306,1,307,1,308,1,309,1,310,1,311,1,312,1,313,1,317,1,320,1,1,1,1,1" AS apiMappingIds,
	'[]' AS states,
	NULL AS reason,
(CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN billing_account_cdp.CUSTOMER_REFERENCE ELSE billing_account_cdp.BILLING_ACCOUNT END) AS accountId
FROM `users_details_cdp`
INNER JOIN billing_account_cdp ON (CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN billing_account_cdp.CUSTOMER_ID ELSE billing_account_cdp.BUID END)=(CASE WHEN users_details_cdp.BU_ID IS NULL OR users_details_cdp.BU_ID='NA' THEN users_details_cdp.CUSTOMER_ID ELSE users_details_cdp.BU_ID END) 
WHERE USE_API = 1;
    END$$

DELIMITER ;