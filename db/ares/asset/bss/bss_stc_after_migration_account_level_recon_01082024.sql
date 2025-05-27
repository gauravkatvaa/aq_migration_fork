-- Function
DELIMITER $$

DROP FUNCTION IF EXISTS `fn_get_split_str`$$

CREATE  FUNCTION `fn_get_split_str`( 
in_string    LONGTEXT,
in_delimiter VARCHAR(12),
in_position  INT
 ) RETURNS VARCHAR(4098) CHARSET utf8mb3
BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(in_string, in_delimiter, in_position),
LENGTH(SUBSTRING_INDEX(in_string,in_delimiter, in_position -1)) + 1),
in_delimiter, '');
    END$$

DELIMITER ;

-- Stored PROCEDURE

DELIMITER $$

DROP PROCEDURE IF EXISTS `bss_stc_after_migration_account_level_recon`$$

CREATE  PROCEDURE `bss_stc_after_migration_account_level_recon`(
IN `in_accountid` TEXT
)
BEGIN
DECLARE acc_detail,l_string TEXT;
DECLARE A INT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
        SELECT @p1 AS RETURNED_SQLSTATE, @p2 AS MESSAGE_TEXT;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
DROP TABLE IF EXISTS bss_stc_after_migration_account_level_recon;
CREATE TABLE IF NOT EXISTS `bss_stc_after_migration_account_level_recon` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ACCOUNT_ID` BIGINT DEFAULT NULL,
  `tenterprise_account` VARCHAR(10) DEFAULT NULL,
   `tuser_sim_card` VARCHAR(10) DEFAULT NULL,
   `tuser_purchase` VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB ;

Account_loop:LOOP
	SET l_string=fn_get_split_str(in_accountid,',',A);
	IF (l_string ='' OR l_string ='null' OR CHAR_LENGTH(l_string)=0 OR IFNULL(l_string,'NULL')='NULL')   THEN
		LEAVE Account_loop;
	END IF;
-- tenterprise_account
SET @sql = CONCAT('SELECT COUNT(1) into @tenterprise_account_count FROM tenterprise_account WHERE ACCOUNT_ID IN (', l_string, ')');
PREPARE stmt FROM @sql;
EXECUTE stmt;

-- tuser_sim_card
SET @sql = CONCAT('SELECT COUNT(1) into @tuser_sim_card_count FROM tuser_sim_card WHERE account_id IN (', l_string, ')');
PREPARE stmt FROM @sql;
EXECUTE stmt;

-- tuser_purchase 
SET @sql = CONCAT('SELECT COUNT(1) into @tuser_purchase_count FROM tuser_purchase WHERE USER_ID IN (SELECT DISTINCT(USER_ID) FROM tuser_sim_card  WHERE account_id IN (', l_string, '))');
PREPARE stmt FROM @sql;
EXECUTE stmt;

INSERT INTO bss_stc_after_migration_account_level_recon(
	ACCOUNT_ID,		tenterprise_account,
	tuser_sim_card,		tuser_purchase
	)
VALUES	(
	l_string,		@tenterprise_account_count,

	@tuser_sim_card_count,	@tuser_purchase_count
	);

	SET A=A+1;
END LOOP;


END$$

DELIMITER ;