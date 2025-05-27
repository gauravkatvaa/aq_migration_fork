SET FOREIGN_KEY_CHECKS=0;


DROP PROCEDURE IF EXISTS `insert_sim_data_new`;
DELIMITER //
CREATE PROCEDURE `insert_sim_data_new`()
    COMMENT 'This procedure is used to insert bulk data of sim inventory of a single wso2 appilication.'
BEGIN
/*
    ----------------------------------------------------------------------------------------------------------------
        Description :  This procedure is used to insert bulk data of sim inventory of a single wso2 appilication.
        Created On  :  22/02/2024
        Created By  :  Mahi kumawat
    ----------------------------------------------------------------------------------------------------------------
        Inputs    :   
                      
        Output    :   Inserting the bulk sim inventory  
    -----------------------------------------------------------------------------------------------------------------
*/
-- Declaring the variables 
    DECLARE v_sim_uid VARCHAR(256);
    DECLARE v_sim_id_exists INT;
      -- Define label for the procedure
  --  insert_sim_data: BEGIN

START TRANSACTION;
-- error insert in error history TABLE
-- TRUNCATE TABLE migration_assets_error_history_router;
SELECT COUNT(1) INTO @before_excution FROM sim_map;
SELECT IFNULL(MAX(id),0) INTO @last_id_sim_map FROM sim_map;
SELECT IFNULL(MAX(id),0) INTO @last_id_sim_home_identifiers FROM sim_home_identifiers;
SELECT IFNULL(MAX(id),0) INTO @last_id_sim_donor_identfiers FROM sim_donor_identfiers;
 
 -- SELECT 'section 1';
SELECT COUNT(1) into @duplicate_count
FROM migration_assets ma
INNER JOIN sim_home_identifiers shi_iccid ON ma.ICCID = shi_iccid.sim_id AND shi_iccid.NAME='iccid'
INNER JOIN sim_home_identifiers shi_imsi ON ma.IMSI = shi_imsi.sim_id AND shi_imsi.NAME='imsi'
INNER JOIN sim_home_identifiers shi_msisdn ON ma.MSISDN = shi_msisdn.sim_id AND shi_msisdn.NAME='msisdn'
;
/* Changed count(*) to count(1) */
 -- SELECT 'section 2';
 SET @new_record_count := (
    SELECT COUNT(1)
FROM
  --  migration_assets where iccid not in (SELECT iccid FROM migration_assets_error_history_router));   
     migration_assets where iccid not in (SELECT sim_id FROM sim_home_identifiers));  
  -- Execute code block when both duplicate records and new records are found
IF (@duplicate_count > 0 AND @new_record_count > 0) THEN  
--  SELECT 'section 3';
                            
INSERT INTO migration_assets_error_history_router (`ICCID`, `IMSI`, `MSISDN`, `Error_Message`)
    SELECT DISTINCT
        ma.`ICCID` AS ICCID,
        ma.`IMSI` AS IMSI,
        ma.`MSISDN` AS MSISDN,
        'Duplicate value found in sim_home_identifiers table' AS Error_Message
FROM
    migration_assets ma
INNER JOIN sim_home_identifiers shi_iccid ON ma.ICCID = shi_iccid.sim_id AND shi_iccid.NAME='iccid'
INNER JOIN sim_home_identifiers shi_imsi ON ma.IMSI = shi_imsi.sim_id AND shi_imsi.NAME='imsi'
INNER JOIN sim_home_identifiers shi_msisdn ON ma.MSISDN = shi_msisdn.sim_id AND shi_msisdn.NAME='msisdn'
;                        
                            
--  SELECT 'section 4';
-- select @sim_home_identifiers;
SET @sim_home_identifiers = CONCAT("INSERT INTO sim_home_identifiers (name, sim_identfier_bin, sim_id, sim_identifier_value)
SELECT
    'iccid' AS name,
    NULL AS sim_identfier_bin,
    ma.ICCID AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.ICCID = maehr.ICCID
WHERE
    maehr.ICCID IS NULL 
        
    
UNION ALL
SELECT
    'imsi' AS name,
    NULL AS sim_identfier_bin,
    ma.IMSI AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.IMSI = maehr.IMSI
WHERE
    maehr.IMSI IS NULL 
    
    
UNION ALL
        
SELECT
    'msisdn' AS name,
    NULL AS sim_identfier_bin,
    ma.msisdn AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.ICCID = maehr.ICCID
WHERE
    maehr.ICCID IS NULL 
    ;");
PREPARE stmt_1 FROM @sim_home_identifiers;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
--  SELECT 'section 5';  
  
-- select @sim_donor_identfiers; 
SET @sim_donor_identfiers = CONCAT("INSERT INTO sim_donor_identfiers (name, sim_identfier_bin, sim_id, sim_identifier_value)
SELECT
    'iccid' AS name,
    NULL AS sim_identfier_bin,
    ma.iccid AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL 
 UNION ALL
SELECT
    'imsi' AS name,
    NULL AS sim_identfier_bin,
    ma.IMSI AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL 
UNION ALL
SELECT
    'msisdn' AS name,
    NULL AS sim_identfier_bin,
    ma.msisdn AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL ;
    ;");
PREPARE stmt_1 FROM @sim_donor_identfiers;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
--  SELECT 'section 6';
    -- Insert into sim_map
-- select @sim_map;
SET @sim_map = CONCAT("
    INSERT INTO sim_map (sim_identfier, sim_identfier_bin, wso2_appilication_id, sim_uid, file_id)
    SELECT
        UUID AS sim_identfier,
        NULL AS sim_identfier_bin,
        '27' AS wso2_appilication_id,
        CONCAT(111, '-', IFNULL((SELECT MAX(id) + 1 FROM (SELECT * FROM sim_map WHERE file_id = 111) AS subquery), 1)) AS sim_uid,
        '111' AS file_id
        
 FROM migration_assets ma
LEFT JOIN migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE maehr.iccid IS NULL ;        
        
        
");
PREPARE stmt_1 FROM @sim_map;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
SELECT ' Both duplicate records and new records are found and inserted into the respective tables  ' INTO @MESSAGE_TEXT;
END IF;
 IF (@duplicate_count > 0 AND @new_record_count = 0) THEN    -- Execute code block when only duplicate records are found and no new records
 
INSERT INTO migration_assets_error_history_router (`ICCID`, `IMSI`, `MSISDN`, `Error_Message`)
    SELECT distinct
        ma.`ICCID` AS ICCID,
        ma.`IMSI` AS IMSI,
        ma.`MSISDN` AS MSISDN,
        'Duplicate value found in sim_home_identifiers table' AS Error_Message
FROM
    migration_assets ma
INNER JOIN sim_home_identifiers shi_iccid ON ma.ICCID = shi_iccid.sim_id and shi_iccid.name='icicd'
INNER JOIN sim_home_identifiers shi_imsi ON ma.IMSI = shi_imsi.sim_id AND shi_imsi.name='imsi'
INNER JOIN sim_home_identifiers shi_msisdn ON ma.MSISDN = shi_msisdn.sim_id AND shi_msisdn.name='msisdn'
;
 
SELECT ' Duplicate records are found ' INTO @MESSAGE_TEXT;
END IF; 
IF (@duplicate_count = 0 AND @new_record_count > 0) THEN    -- Execute code block when no duplicate records are found and new records are present
-- select @sim_home_identifiers;
--  SELECT 'section 7';
SET @sim_home_identifiers = CONCAT("INSERT INTO sim_home_identifiers (name, sim_identfier_bin, sim_id, sim_identifier_value)
SELECT
    'iccid' AS name,
    NULL AS sim_identfier_bin,
    ma.iccid AS sim_id,
    ma.UUID  AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL   
    
UNION ALL
SELECT
    'imsi' AS name,
    NULL AS sim_identfier_bin,
    ma.IMSI AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL 
    
        UNION ALL
        
SELECT
    'msisdn' AS name,
    NULL AS sim_identfier_bin,
    ma.msisdn AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL 
    
    ;");
PREPARE stmt_1 FROM @sim_home_identifiers;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
-- select @sim_donor_identfiers ;
--  SELECT 'section 8';
SET @sim_donor_identfiers = CONCAT("INSERT INTO sim_donor_identfiers (name, sim_identfier_bin, sim_id, sim_identifier_value)
SELECT
    'iccid' AS name,
    NULL AS sim_identfier_bin,
    ma.iccid AS sim_id,
    ma.UUID  AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL   
    
UNION ALL
SELECT
    'imsi' AS name,
    NULL AS sim_identfier_bin,
    ma.IMSI AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL 
    
        UNION ALL
        
SELECT
    'msisdn' AS name,
    NULL AS sim_identfier_bin,
    ma.msisdn AS sim_id,
    ma.UUID AS sim_identifier_value
FROM
    migration_assets ma
LEFT JOIN
    migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE
    maehr.iccid IS NULL ;");
PREPARE stmt_1 FROM @sim_donor_identfiers;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
    -- Insert into sim_map
-- Select @sim_map;
--  SELECT 'section 9';
SET @sim_map = CONCAT("
    INSERT INTO sim_map (sim_identfier, sim_identfier_bin, wso2_appilication_id, sim_uid, file_id)
    SELECT
        UUID AS sim_identfier,
        NULL AS sim_identfier_bin,
        '27' AS wso2_appilication_id,
        CONCAT(111, '-', IFNULL((SELECT MAX(id) + 1 FROM (SELECT * FROM sim_map WHERE file_id = 111) AS subquery), 1)) AS sim_uid,
        '111' AS file_id
 FROM migration_assets ma
LEFT JOIN migration_assets_error_history_router maehr ON ma.iccid = maehr.iccid
WHERE maehr.iccid IS NULL ;  
");
PREPARE stmt_1 FROM @sim_map;
EXECUTE stmt_1;
DEALLOCATE   PREPARE stmt_1;
SELECT 'No duplicate records are found and new records are inserted successfully' INTO @MESSAGE_TEXT;
END IF;
 --  Select 'inventory uploaded successfully' as msg ;
COMMIT;
-- SELECT count(1) as 'inventory uploaded successfully- success_count' from sim_map WHERE ID IN (SELECT ID FROM migration_assets);
SELECT count(1) INTO @success_count FROM sim_home_identifiers where name = 'iccid' and sim_id in (SELECT iccid FROM migration_assets where iccid not in (SELECT iccid FROM migration_assets_error_history_router));   
SELECT COUNT(1) INTO @after_execution FROM sim_map;
SELECT count(1) INTO @failed_count from  migration_assets_error_history_router ;
SELECT CONCAT('before_excution: ',IFNULL(@before_excution,0)) as before_excution,
CONCAT('after_excution: ',IFNULL(@after_execution,0)) as after_execution,
CONCAT('success_count: ',IFNULL(@success_count,0)) as success_count,
CONCAT('failed_count: ',IFNULL(@failed_count,0)) as failed_count,
CONCAT('last_id_sim_map: ',IFNULL(@last_id_sim_map,0)) AS last_id_sim_map,
CONCAT('last_id_sim_home_identifiers: ',IFNULL(@last_id_sim_home_identifiers,0)) AS last_id_sim_home_identifiers,
CONCAT('last_id_sim_donor_identfiers: ',IFNULL(@last_id_sim_donor_identfiers,0)) AS last_id_sim_donor_identfiers,
IFNULL(@MESSAGE_TEXT,' ') as Remarks;
ROLLBACK; 
END//
DELIMITER ;



DROP PROCEDURE IF EXISTS `router_assets_deletion`;
DELIMITER //
CREATE PROCEDURE `router_assets_deletion`(
IN `in_imsiid` longtext
)
BEGIN


 -- DECLARE tsimidentifier longtext;

SET SESSION group_concat_max_len = 10000000000 ;

DROP TEMPORARY TABLE IF EXISTS `temp_sim_identifier_value`;
CREATE temporary TABLE `temp_sim_identifier_value` (sim_ide varchar(256)) ;
set @querytifier = concat("INSERT INTO temp_sim_identifier_value(sim_ide) SELECT sim_identifier_value FROM sim_home_identifiers WHERE sim_id in (" , in_imsiid , ")");

    PREPARE stmt FROM @querytifier;
    EXECUTE stmt ;

delete from sim_map where file_id=111;
 
    set @querysim_home = concat("DELETE from sim_home_identifiers 
where sim_identifier_value in (select sim_ide from temp_sim_identifier_value)");

    PREPARE stmt FROM @querysim_home;
    EXECUTE stmt ;
    

   set @querysim_donor = concat("DELETE from sim_donor_identfiers 
where sim_identifier_value in (select sim_ide from temp_sim_identifier_value)");

    PREPARE stmt FROM @querysim_donor;
    EXECUTE stmt ;
    

END//
DELIMITER ;

SET FOREIGN_KEY_CHECKS=1;