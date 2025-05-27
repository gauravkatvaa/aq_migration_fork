SET FOREIGN_KEY_CHECKS=0;

-- Dumping structure for table development_goup_router.migration_assets
DROP TABLE IF EXISTS `migration_assets`;
CREATE TABLE IF NOT EXISTS `migration_assets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ICCID` varchar(256) DEFAULT NULL,
  `IMSI` varchar(256) DEFAULT NULL,
  `MSISDN` varchar(256) DEFAULT NULL,
  `UUID` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table development_goup_router.migration_assets_error_history_router
DROP TABLE IF EXISTS `migration_assets_error_history_router`;
CREATE TABLE IF NOT EXISTS `migration_assets_error_history_router` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ICCID` varchar(256) DEFAULT NULL,
  `IMSI` varchar(256) DEFAULT NULL,
  `MSISDN` varchar(256) DEFAULT NULL,
  `Error_Message` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data exporting was unselected.

-- Dumping structure for table development_goup_router.migration_tracking_history
DROP TABLE IF EXISTS `migration_tracking_history`;
CREATE TABLE IF NOT EXISTS `migration_tracking_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `database_name` varchar(128) DEFAULT '0',
  `table_name` varchar(128) DEFAULT '0',
  `message_status` text,
  `query_print` longtext,
  `is_completed` tinyint(1) DEFAULT '0',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  COMMENT='This table is used for mantaine Error_handling history';

-- Data exporting was unselected.

-- Dumping structure for trigger development_goup_router.before_insert_mytable_uuid
DROP TRIGGER IF EXISTS `before_insert_mytable_uuid`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_mytable_uuid` BEFORE INSERT ON `migration_assets` FOR EACH ROW SET new.UUID = uuid()//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;



ALTER TABLE `migration_assets` 
ADD INDEX `comp_idx` (`ICCID` ASC, `IMSI` ASC, `MSISDN` ASC) VISIBLE,
ADD INDEX `ic_idx` (`ICCID` ASC) VISIBLE;
;


ALTER TABLE `sim_home_identifiers` 
ADD INDEX `comp_idx` (`name` ASC, `sim_id` ASC) VISIBLE,
ADD INDEX `name_idx` (`name` ASC) VISIBLE;
;


SET FOREIGN_KEY_CHECKS=1;
