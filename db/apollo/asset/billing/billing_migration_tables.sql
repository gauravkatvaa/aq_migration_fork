DROP TABLE IF EXISTS `migration_assets`;
CREATE TABLE `migration_assets` (
  `imsi_id` bigint NOT NULL,
  `imsi` varchar(50) NOT NULL,
  `account_id` int NOT NULL,
  `event_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `device_id` int NOT NULL,
  `iccid` varchar(50) NOT NULL,
  `msisdn` varchar(50) NOT NULL,
  `reason` varchar(256) DEFAULT NULL,
  `state` varchar(50) NOT NULL DEFAULT 'Activated',
  `id` bigint NOT NULL AUTO_INCREMENT,
  `service_plan_id` bigint DEFAULT '0',
  PRIMARY KEY (`id`)
)

DROP TABLE IF EXISTS `migration_assets_validation`;
CREATE TABLE `migration_assets_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `imsi` varchar(50) NOT NULL,
  `status` varchar(30) NOT NULL,
  `remarks` varchar(500) DEFAULT NULL,
  `assets_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
)


DROP TABLE IF EXISTS `migration_billing_charges`;
CREATE TABLE `migration_billing_charges` (
  `plan_id` bigint NOT NULL,
  `charge_spec_id` bigint NOT NULL,
  `charge_category` varchar(50) NOT NULL,
  `gl_code_id` bigint NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `is_proration` tinyint(1) NOT NULL,
  `parent_csid` bigint(20) NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `discount_id` int DEFAULT NULL,
  `discount_glcode_id` int DEFAULT NULL,
  `apn_type` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
)

DROP TABLE IF EXISTS `migration_device_plan`;
CREATE TABLE `migration_device_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `device_plan_id` bigint DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'SimPlan',
  `pool_limit` int NOT NULL DEFAULT '0',
  `frequency` varchar(20) DEFAULT 'Monthly',
  `template_id` bigint NOT NULL,
  `billing_account_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
)
