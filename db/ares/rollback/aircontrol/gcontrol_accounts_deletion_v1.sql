DELIMITER $$

DROP PROCEDURE IF EXISTS `gcontrol_accounts_deletion_v1_remove_account`$$

CREATE  PROCEDURE `gcontrol_accounts_deletion_v1_remove_account`(  IN `in_accountid` TEXT)
BEGIN
    
    DROP TEMPORARY TABLE IF EXISTS tbl_remove_account;
    
    CREATE TEMPORARY TABLE `tbl_remove_account` (
      `id` BIGINT DEFAULT NULL,
      `type` INT DEFAULT NULL,
      KEY idx_1(id)
    ) ENGINE=INNODB;
    
    
SET @sql = CONCAT(
    "INSERT INTO tbl_remove_account (id)
     WITH RECURSIVE account_hierarchy AS (
         SELECT id, PARENT_ACCOUNT_ID AS parent_id, type
         FROM accounts
         WHERE id IN (", in_accountid, ")
         UNION ALL
         SELECT A.id, A.PARENT_ACCOUNT_ID, A.type
         FROM accounts A
         JOIN account_hierarchy AH ON A.PARENT_ACCOUNT_ID = AH.id
     )
     SELECT distinct id
     FROM account_hierarchy
     WHERE type IN (4, 5, 6)"
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
 
 
	
IF (SELECT COUNT(1) FROM accounts WHERE id IN(SELECT id FROM tbl_remove_account))>0 THEN
SET FOREIGN_KEY_CHECKS=0;
DELETE dp2pc
FROM device_plan_to_pricing_categories dp2pc
JOIN device_rate_plan drp ON dp2pc.DEVICE_PLAN_ID = drp.ID
JOIN tbl_remove_account tra ON drp.account_id = tra.id;
DELETE dspm
FROM device_service_plan_mapping dspm
JOIN device_rate_plan drp ON dspm.DEVICE_PLAN_ID = drp.ID
JOIN tbl_remove_account tra ON drp.account_id = tra.id;
SELECT NOW() AS time1;
DELETE dpsam
FROM device_plan_to_service_apn_mapping dpsam
JOIN device_rate_plan drp ON dpsam.DEVICE_PLAN_ID_ID = drp.ID
JOIN tbl_remove_account tra ON drp.account_id = tra.id;
SELECT 'device plan deleted';
SELECT NOW() AS time2;
DELETE apn_ip
FROM apn_ip_mapping apn_ip
JOIN service_apn_details sad ON apn_ip.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE apn_req
FROM apn_request apn_req
JOIN service_apn_details sad ON apn_req.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE aaa
FROM assets_apn_allocation aaa
JOIN service_apn_details sad ON aaa.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE dpsam
FROM device_plan_to_service_apn_mapping dpsam
JOIN service_apn_details sad ON dpsam.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
SELECT NOW() AS time3;
SELECT 'service apn deleted';
DELETE saaa
FROM service_apn_account_allocation saaa
JOIN service_apn_details sad ON saaa.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE saafm
FROM service_apn_account_allocation_mapping saafm
JOIN service_apn_details sad ON saafm.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
SELECT NOW() AS time4;
DELETE saam
FROM service_apn_account_mapping saam
JOIN service_apn_details sad ON saam.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE saip
FROM service_apn_ip saip
JOIN service_apn_details sad ON saip.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE saipa
FROM service_apn_ip_allocation saipa
JOIN service_apn_details sad ON saipa.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
DELETE saipa
FROM service_apn_ip_allocation saipa
JOIN service_apn_details sad ON saipa.APN_ID = sad.ID
JOIN tbl_remove_account tra ON sad.account_id = tra.id;
SELECT NOW() AS time5;
SELECT 'assets apn mapping remove deleted';
DELETE rtsm
FROM role_to_screen_mapping rtsm
JOIN role_access ra ON rtsm.role_id = ra.ID
JOIN tbl_remove_account tra ON ra.account_id = tra.id;
DELETE rttm
FROM role_to_tab_mapping rttm
JOIN role_access ra ON rttm.role_id = ra.ID
JOIN tbl_remove_account tra ON ra.account_id = tra.id;
SELECT NOW() AS time6;
DELETE dcd
FROM download_center_details dcd
JOIN users u ON dcd.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE nsh
FROM notification_system_history nsh
JOIN users u ON nsh.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE nth
FROM notification_trigger_history nth
JOIN users u ON nth.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
SELECT NOW() AS time7;
DELETE sub
FROM subscription sub
JOIN users u ON sub.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE ttm
FROM temp_token_manager ttm
JOIN users u ON ttm.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE tc
FROM terms_conditions tc
JOIN users u ON tc.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE ucc
FROM user_configuration_column ucc
JOIN users u ON ucc.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE uea
FROM user_extended_accounts uea
JOIN users u ON uea.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE uh
FROM user_hierarchy uh
JOIN users u ON uh.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE us
FROM user_settings us
JOIN users u ON us.user_id = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
SELECT NOW() AS time8;
DELETE reif
FROM rule_engine_imsi_filter reif
JOIN rule_engine_rule rer ON reif.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
DELETE reir
FROM rule_engine_imsi_rule reir
JOIN rule_engine_rule rer ON reir.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
DELETE rera
FROM rule_engine_rule_action rera
JOIN rule_engine_rule rer ON rera.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
DELETE rert
FROM rule_engine_rule_trigger rert
JOIN rule_engine_rule rer ON rert.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
DELETE rettr
FROM rule_engine_tag_rule rettr
JOIN rule_engine_rule rer ON rettr.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
DELETE rtdpm
FROM rule_to_device_plan_mapping rtdpm
JOIN rule_engine_rule rer ON rtdpm.rule_id = rer.ID
JOIN tbl_remove_account tra ON rer.account_id = tra.id;
SELECT 'rule engine deleted';
SELECT NOW() AS time9;
DELETE rua
FROM retention_user_asset_mapping rua
JOIN assets a ON rua.ASSET_ID = a.ID
JOIN tbl_remove_account tra ON a.ENT_ACCOUNTID = tra.id;
SELECT NOW() AS time10;
DELETE oss
FROM order_shipping_status oss
JOIN map_user_sim_order muso ON oss.ID = muso.order_shipping_id
JOIN tbl_remove_account tra ON muso.account_id = tra.id;
DELETE sohs
FROM smsa_order_sent_history sohs
JOIN map_user_sim_order muso ON sohs.order_number = muso.order_number
JOIN tbl_remove_account tra ON muso.account_id = tra.id;
SELECT NOW() AS time11;
DELETE pc
FROM pricing_categories pc
JOIN device_plan_to_pricing_categories dp2pc ON pc.id = dp2pc.pricing_categories_id
JOIN device_rate_plan drp ON dp2pc.DEVICE_PLAN_ID = drp.ID
JOIN tbl_remove_account tra ON drp.account_id = tra.id;
DELETE pc
FROM pricing_categories pc
JOIN price_model_to_pricing_categories pm2pc ON pc.id = pm2pc.pricing_categories_id
JOIN price_model_rate_plan pmrp ON pm2pc.PRICE_MODEL_ID = pmrp.ID
JOIN tbl_remove_account tra ON pmrp.account_id = tra.id;
DELETE pc
FROM pricing_categories pc
JOIN whole_sale_to_pricing_categories wst2pc ON pc.id = wst2pc.pricing_categories_id
JOIN whole_sale_rate_plan wsrp ON wst2pc.WHOLE_SALE_ID = wsrp.ID
JOIN tbl_remove_account tra ON wsrp.account_id = tra.id;
SELECT NOW() AS time12;
SELECT NOW() AS time13;
DELETE msop
FROM map_sim_order_pricing msop
JOIN map_user_sim_order muso ON msop.ID = muso.id
JOIN tbl_remove_account tra ON muso.account_id = tra.id;
SELECT NOW() AS time14;
DELETE asm
FROM account_screen_mapping asm
JOIN tbl_remove_account tra ON asm.account_id = tra.id;
DELETE astam
FROM account_state_transition_account_mapping astam
JOIN tbl_remove_account tra ON astam.account_id = tra.id;
DELETE atnm
FROM account_to_node_mpping atnm
JOIN tbl_remove_account tra ON atnm.account_id = tra.id;
DELETE a2aam
FROM accounts_to_associated_accounts_mapping a2aam
JOIN tbl_remove_account tra ON a2aam.account_id = tra.id;
SELECT 'role and screen mapping deleted';
SELECT NOW() AS time15;
DELETE ab
FROM api_billing ab
JOIN tbl_remove_account tra ON ab.account_id = tra.id;
DELETE acc
FROM api_charge_calculation acc
JOIN tbl_remove_account tra ON acc.account_id = tra.id;
DELETE aut
FROM api_user_transaction aut
JOIN tbl_remove_account tra ON aut.account_id = tra.id;
DELETE AT
FROM auditlog_api_transaction AT
JOIN tbl_remove_account tra ON at.account_id = tra.id;
DELETE aep
FROM auditlog_end_points aep
JOIN tbl_remove_account tra ON aep.account_id = tra.id;
DELETE c
FROM catalog c
JOIN tbl_remove_account tra ON c.account_id = tra.id;
DELETE ccd
FROM csr_charges_details ccd
JOIN tbl_remove_account tra ON ccd.account_id = tra.id;
DELETE COT
FROM csr_order_txn_history COT
JOIN tbl_remove_account tra ON cot.account_id = tra.id;
DELETE ctp
FROM csr_tariff_plan_mapping ctp
JOIN tbl_remove_account tra ON ctp.account_id = tra.id;
SELECT NOW() AS time16;
DELETE gta
FROM group_to_accounts gta
JOIN tbl_remove_account tra ON gta.account_id = tra.id;
	DELETE iwm
	FROM ip_whitelisting_mapping iwm
	JOIN ip_whitelisting iw ON iwm.ip_whitelisting_id=iw.id
	JOIN tbl_remove_account tra ON iw.account_id = tra.id;
	
	
	DELETE iwh
	FROM `ip_whitelisting_history` iwh
	JOIN ip_whitelisting iw ON iwh.ip_whitelisting_id=iw.id
	JOIN tbl_remove_account tra ON iw.account_id = tra.id;
	DELETE iw
	FROM ip_whitelisting iw
	JOIN tbl_remove_account tra ON iw.account_id = tra.id;
SELECT 'CSR and auditlog deleted';
SELECT NOW() AS time17;
DELETE lz
FROM lbs_zones lz
JOIN tbl_remove_account tra ON lz.account_id = tra.id;
DELETE sc
FROM system_configuration sc
JOIN map_user_sim_order muso ON sc.param_value = muso.order_number
JOIN tbl_remove_account tra ON muso.account_id = tra.id
WHERE sc.param_name = 'sim.order.number';
DELETE muso
FROM map_user_sim_order muso
JOIN tbl_remove_account tra ON muso.account_id = tra.id;
DELETE nst
FROM notification_system_template nst
JOIN tbl_remove_account tra ON nst.account_id = tra.id;
DELETE ntt
FROM notification_trigger_template ntt
JOIN tbl_remove_account tra ON ntt.account_id = tra.id;
SELECT 'lbs zone deleted';
DELETE pe
FROM penalty_exemption pe
JOIN tbl_remove_account tra ON pe.account_id = tra.id;
DELETE saaa
FROM service_apn_account_allocation saaa
JOIN tbl_remove_account tra ON saaa.account_id = tra.id;
DELETE saam
FROM service_apn_account_allocation_mapping saam
JOIN tbl_remove_account tra ON saam.account_id = tra.id;
DELETE saamap
FROM service_apn_account_mapping saamap
JOIN tbl_remove_account tra ON saamap.account_id = tra.id;
DELETE sc
FROM service_coverage sc
JOIN tbl_remove_account tra ON sc.account_id = tra.id;
DELETE sel
FROM sim_event_log sel
JOIN tbl_remove_account tra ON sel.account_id = tra.id;
DELETE sp
FROM sim_pool sp
JOIN tbl_remove_account tra ON sp.account_id = tra.id;
DELETE sprd
FROM sim_provisioned_range_details sprd
JOIN tbl_remove_account tra ON sprd.account_id = tra.id;
SELECT NOW() AS time18;
SELECT 'sim event log and service_apn_account_allocation deleted';
DELETE FROM sim_provisioned_range_to_account_level1 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level10 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level2 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level3 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level4 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level5 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level6 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level7 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level8 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_range_to_account_level9 WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT '11';
DELETE FROM sim_provisioned_ranges_level1 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level10 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level2 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level3 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level4 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level5 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level6 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level7 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level8 WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_provisioned_ranges_level9 WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT 'sim_provisioned_ranges deleted';
DELETE FROM sim_range WHERE ALLOCATE_TO IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_range_msisdn WHERE billing_account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_status_change_report WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_whitelisting_history WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sim_whitelisting_status WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM sms_action_history WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM subscription WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM tag  WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT 'tag and sim range deleted';
SELECT '2';
DELETE FROM tag_entity WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM terms_conditions WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM user_extended_accounts WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM vas_charges_details WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM whole_sale_invoice WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM whole_sale_plan_to_account WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM wl_bl_sim WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT '3';
DELETE FROM wl_bl_template WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM zones WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT 'tab and zone deleted';
DELETE FROM service_apn_details WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM service_plan WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id IN (SELECT id FROM tbl_remove_account));
DELETE FROM price_model_rate_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM retail_rate_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM rule_engine_rule WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM whole_sale_rate_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT 'service plan and account plan deleted';
DELETE FROM data_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM device_rate_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM api_users WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM role_access WHERE account_id IN (SELECT id FROM tbl_remove_account);
DELETE FROM service_plan WHERE account_id IN (SELECT id FROM tbl_remove_account);
SELECT 'api_users and api_users deleted';
DELETE FROM contact_info WHERE ID IN (SELECT CONTACT_INFO_ID FROM users WHERE account_id IN (SELECT id FROM tbl_remove_account));
 
SELECT 'User Lead Person,OpCo_AM deleted,OpCo_Retention';
SELECT 'product type deleted';
DELETE ci
FROM contact_info ci
JOIN accounts a ON ci.ID = a.BILLING_CONTACT_INFO_ID
JOIN tbl_remove_account tra ON a.id = tra.id;
DELETE ci
FROM contact_info ci
JOIN accounts a ON ci.ID = a.PRIMARY_CONTACT_INFO_ID
JOIN tbl_remove_account tra ON a.id = tra.id;
DELETE ci
FROM contact_info ci
JOIN accounts a ON ci.ID = a.OPERATIONS_CONTACT_INFO_ID
JOIN tbl_remove_account tra ON a.id = tra.id;
DELETE ci
FROM contact_info ci
JOIN accounts a ON ci.ID = a.SIM_ORDER_CONTACT_INFO_ID
JOIN tbl_remove_account tra ON a.id = tra.id;
DELETE ae
FROM account_extended ae
JOIN accounts a ON ae.ID = a.EXTENDED_ID
JOIN tbl_remove_account tra ON a.id = tra.id;
SELECT '7';
DELETE ud
FROM user_details ud
JOIN users u ON ud.ID = u.USER_DETAILS_ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE ucc
FROM user_configuration_column ucc
JOIN users u ON ucc.USER_ID = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE aum
FROM api_user_mapping aum
JOIN users u ON aum.API_USER_ID = u.ID
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE u
FROM users u
JOIN tbl_remove_account tra ON u.account_id = tra.id;
DELETE a
FROM assets a
JOIN tbl_remove_account tra ON a.ENT_ACCOUNTID = tra.id;
DELETE ba
FROM blank_asset ba
JOIN tbl_remove_account tra ON ba.ENT_ACCOUNTID = tra.id;
SELECT 'users and assets deleted';
DELETE ae
FROM assets_extended ae
JOIN assets a ON ae.ID = a.ASSETS_EXTENDED_ID
JOIN tbl_remove_account tra ON a.ENT_ACCOUNTID = tra.id;
DELETE FROM accounts WHERE id IN (SELECT id FROM tbl_remove_account);
DELETE FROM organization_organization WHERE id IN (SELECT id FROM tbl_remove_account);
DELETE FROM account_goup_mappings WHERE ACCOUNT_ID IN (SELECT id FROM tbl_remove_account);
SELECT 'accounts deleted';
SET FOREIGN_KEY_CHECKS=1;
ELSE
  
  
  SELECT 'Account id NOT FOUND' ;
  
END IF;
    END$$

DELIMITER ;