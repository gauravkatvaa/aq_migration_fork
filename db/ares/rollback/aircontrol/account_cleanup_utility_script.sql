DROP PROCEDURE IF EXISTS `gcontrol_accounts_deletion`;
DELIMITER //
CREATE PROCEDURE `gcontrol_accounts_deletion`(
IN `in_accountid` VARCHAR(255)
)
BEGIN

/*
-- *************************************************************************
-- Procedure: gcontrol_accounts_deletion
--    Author: Manish Saini
--      Date: 06/06/2024
-- Description: Remove all accounts from backend
Procedure is deleting account id from aircontrol all tables

Migration Rollback Strategy Discussion


call gcontrol_accounts_deletion(15790);

select id,plan_name,account_id from device_rate_plan order by id desc limit 1;
update accounts set NOTIFICATION_UUID='10009798772002' where id=15798;
 update device_rate_plan set plan_name='DP 1004 BMW APPriv DPTest' where id=424957;
 

-- *************************************************************************
*/

-- localizing variable


-- SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME='account_id' AND TABLE_SCHEMA='cmp_master_stc';
-- SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'zone_id' AND TABLE_SCHEMA='cmp_master_stc';

-- IF account id found
IF (SELECT count(1) FROM accounts WHERE id=in_accountid)>0 THEN


SET FOREIGN_KEY_CHECKS=0;
DELETE FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);
DELETE FROM device_service_plan_mapping WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);
-- DELETE FROM rule_to_device_plan_mapping WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);
DELETE FROM device_plan_to_service_apn_mapping  WHERE DEVICE_PLAN_ID_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);

-- according apn_id delete record
DELETE FROM apn_ip_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM apn_request WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM assets_apn_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM device_plan_to_service_apn_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
-- DELETE FROM radius_details WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_account_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_account_allocation_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_account_mapping WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_ip WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_ip_allocation WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);
DELETE FROM service_apn_ip_allocation_pre_prod WHERE APN_ID IN (SELECT ID FROM service_apn_details WHERE account_id=in_accountid);



DELETE FROM apn_ip_mapping WHERE ASSETS_ID in (SELECT id FROM assets WHERE ENT_ACCOUNTID=in_accountid);
DELETE FROM assets_apn_allocation WHERE ASSETS_ID in (SELECT id FROM assets WHERE ENT_ACCOUNTID=in_accountid);
-- screen id delete 
DELETE FROM role_to_screen_mapping WHERE role_id IN (SELECT ID FROM role_access WHERE account_id=in_accountid);
DELETE FROM role_to_tab_mapping WHERE role_id IN (SELECT ID FROM role_access WHERE account_id=in_accountid);

-- user_id delete
-- DELETE FROM bulk_upload_file_registration  WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM download_center_details       WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM notification_system_history   WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM notification_trigger_history  WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
-- DELETE FROM retention_user_asset_mapping  WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM subscription                  WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM temp_token_manager            WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM terms_conditions              WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM user_configuration_column     WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM user_extended_accounts        WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM user_hierarchy                WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM user_settings                 WHERE user_id IN (SELECT ID FROM users WHERE account_id=in_accountid);

-- rule_id according delete 
DELETE FROM rule_engine_imsi_filter    WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);
DELETE FROM rule_engine_imsi_rule       WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);
DELETE FROM rule_engine_rule_action    WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);
DELETE FROM rule_engine_rule_trigger   WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);
DELETE FROM rule_engine_tag_rule       WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);
DELETE FROM rule_to_device_plan_mapping WHERE rule_id IN (SELECT ID FROM rule_engine_rule WHERE account_id=in_accountid);

-- asset_id delete 
-- DELETE FROM cost_center_asset_mapping    WHERE ASSET_ID IN (SELECT ID FROM assets WHERE ENT_ACCOUNTID=in_accountid);
DELETE FROM extended_audit_log           WHERE ASSET_ID IN (SELECT ID FROM assets WHERE ENT_ACCOUNTID=in_accountid);
DELETE FROM retention_user_asset_mapping WHERE ASSET_ID IN (SELECT ID FROM assets WHERE ENT_ACCOUNTID=in_accountid);

DELETE FROM order_shipping_status WHERE ID IN (SELECT order_shipping_id FROM map_user_sim_order WHERE account_id=in_accountid);
DELETE FROM smsa_order_sent_history WHERE order_number IN (SELECT order_number FROM map_user_sim_order WHERE account_id=in_accountid);

DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID
IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid));
DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM price_model_to_pricing_categories WHERE PRICE_MODEL_ID IN(SELECT ID FROM price_model_rate_plan WHERE account_id=in_accountid));
DELETE FROM  pricing_categories WHERE id in (SELECT pricing_categories_id FROM whole_sale_to_pricing_categories WHERE WHOLE_SALE_ID IN (SELECT ID FROM whole_sale_rate_plan WHERE account_id=in_accountid));

DELETE FROM device_plan_to_pricing_categories WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);
DELETE FROM price_model_to_pricing_categories WHERE PRICE_MODEL_ID IN(SELECT ID FROM price_model_rate_plan WHERE account_id=in_accountid);
DELETE FROM whole_sale_to_pricing_categories WHERE WHOLE_SALE_ID IN (SELECT ID FROM whole_sale_rate_plan WHERE account_id=in_accountid);

DELETE FROM map_sim_order_pricing WHERE ID IN (SELECT id FROM map_user_sim_order WHERE account_id=in_accountid);

-- DELETE FROM csr_tariff_plan_mapping WHERE id in (SELECT csr_id FROM accounts_to_pricing_categories WHERE account_id=in_accountid);

-- DELETE FROM account_commitment WHERE account_id=in_accountid;
DELETE FROM account_screen_mapping WHERE account_id=in_accountid;
DELETE FROM account_state_transition_account_mapping WHERE account_id=in_accountid;
DELETE FROM account_to_node_mpping WHERE account_id=in_accountid;
DELETE FROM accounts_to_associated_accounts_mapping WHERE account_id=in_accountid;
-- DELETE FROM accounts_to_pricing_categories WHERE account_id=in_accountid;

DELETE FROM api_billing WHERE account_id=in_accountid;
DELETE FROM api_charge_calculation WHERE account_id=in_accountid;
DELETE FROM api_user_transaction WHERE account_id=in_accountid;
DELETE FROM auditlog WHERE account_id=in_accountid;
DELETE FROM auditlog_api_transaction WHERE account_id=in_accountid;
DELETE FROM auditlog_end_points WHERE account_id=in_accountid;
DELETE FROM catalog WHERE account_id=in_accountid;
DELETE FROM cost_center_asset_mapping WHERE account_id=in_accountid;
DELETE FROM csr_charges_details WHERE account_id=in_accountid;
DELETE FROM csr_order_txn_history WHERE account_id=in_accountid;
DELETE FROM csr_tariff_plan_mapping WHERE account_id=in_accountid;
-- DELETE FROM edit_device_plan_request WHERE account_id=in_accountid;
DELETE FROM group_to_accounts WHERE account_id=in_accountid;
DELETE FROM ip_whitelisting WHERE account_id=in_accountid;
-- DELETE FROM lbs_sim_list WHERE account_id=in_accountid;
-- DELETE FROM lbs_zone_filter WHERE account_id=in_accountid;
-- DELETE FROM lbs_zone_notification_history WHERE account_id=in_accountid;
DELETE FROM lbs_zones WHERE account_id=in_accountid;
DELETE FROM map_user_sim_order WHERE account_id=in_accountid;
DELETE FROM notification_system_template WHERE account_id=in_accountid;
DELETE FROM notification_trigger_template WHERE account_id=in_accountid;
DELETE FROM order_product_defination WHERE account_id=in_accountid;
DELETE FROM penalty_exemption WHERE account_id=in_accountid;
DELETE FROM service_apn_account_allocation WHERE account_id=in_accountid;
DELETE FROM service_apn_account_allocation_mapping WHERE account_id=in_accountid;
DELETE FROM service_apn_account_mapping WHERE account_id=in_accountid;
DELETE FROM service_coverage WHERE account_id=in_accountid;
DELETE FROM sim_event_log WHERE account_id=in_accountid;
DELETE FROM sim_pool WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_details WHERE account_id=in_accountid;

select '12';
DELETE FROM sim_provisioned_range_to_account_level1 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level10 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level2 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level3 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level4 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level5 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level6 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level7 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level8 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_range_to_account_level9 WHERE account_id=in_accountid;
select '11';
DELETE FROM sim_provisioned_ranges_level1 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level10 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level2 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level3 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level4 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level5 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level6 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level7 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level8 WHERE account_id=in_accountid;
DELETE FROM sim_provisioned_ranges_level9 WHERE account_id=in_accountid;

select '1';
DELETE FROM sim_range WHERE account_id=in_accountid;
DELETE FROM sim_range_msisdn WHERE account_id=in_accountid;
DELETE FROM sim_status_change_report WHERE account_id=in_accountid;
DELETE FROM sim_whitelisting_history WHERE account_id=in_accountid;
DELETE FROM sim_whitelisting_status WHERE account_id=in_accountid;
DELETE FROM sms_action_history WHERE account_id=in_accountid;
DELETE FROM subscription WHERE account_id=in_accountid;
DELETE FROM tag  WHERE account_id=in_accountid;
select '2';
DELETE FROM tag_entity WHERE account_id=in_accountid;
DELETE FROM terms_conditions WHERE account_id=in_accountid;
DELETE FROM user_extended_accounts WHERE account_id=in_accountid;
DELETE FROM vas_charges_details WHERE account_id=in_accountid;
DELETE FROM whole_sale_invoice WHERE account_id=in_accountid;
DELETE FROM whole_sale_plan_to_account WHERE account_id=in_accountid;
DELETE FROM wl_bl_sim WHERE account_id=in_accountid;
select '3';
DELETE FROM wl_bl_template WHERE account_id=in_accountid;
DELETE FROM zones WHERE account_id=in_accountid;

select '4';
DELETE FROM service_apn_details WHERE account_id=in_accountid;
DELETE FROM service_plan WHERE DEVICE_PLAN_ID IN (SELECT ID FROM device_rate_plan WHERE account_id=in_accountid);
DELETE FROM price_model_rate_plan WHERE account_id=in_accountid;
DELETE FROM retail_rate_plan WHERE account_id=in_accountid;
DELETE FROM rule_engine_rule WHERE account_id=in_accountid;
DELETE FROM whole_sale_rate_plan WHERE account_id=in_accountid;
select '5';
DELETE FROM data_plan WHERE account_id=in_accountid;
DELETE FROM device_rate_plan WHERE account_id=in_accountid;
DELETE FROM api_users WHERE account_id=in_accountid;
DELETE FROM role_access WHERE account_id=in_accountid;
DELETE FROM service_plan WHERE account_id=in_accountid;
select '6';
DELETE FROM contact_info WHERE ID IN (SELECT CONTACT_INFO_ID FROM users WHERE account_id=in_accountid);
DELETE FROM contact_info WHERE ID IN (SELECT CONTACT_INFO_ID FROM users WHERE account_id IN (SELECT lead_person_acc_manager_id FROM account_extended WHERE lead_person_acc_manager_id=in_accountid));
--   >>> lead_person_acc_manager_id
DELETE FROM contact_info WHERE ID IN (SELECT BILLING_CONTACT_INFO_ID FROM accounts WHERE id=in_accountid);
DELETE FROM contact_info WHERE ID IN (SELECT PRIMARY_CONTACT_INFO_ID FROM accounts WHERE id=in_accountid);
DELETE FROM contact_info WHERE ID IN (SELECT OPERATIONS_CONTACT_INFO_ID FROM accounts WHERE id=in_accountid);
DELETE FROM contact_info WHERE ID IN (SELECT SIM_ORDER_CONTACT_INFO_ID FROM accounts WHERE id=in_accountid);
DELETE FROM account_extended WHERE ID IN (SELECT EXTENDED_ID FROM accounts WHERE id=in_accountid);
select '7';
DELETE FROM assets_extended WHERE ID IN (SELECT ASSETS_EXTENDED_ID FROM assets WHERE ENT_ACCOUNTID=in_accountid);
DELETE FROm user_details WHERE ID IN (SELECT USER_DETAILS_ID FROM users WHERE account_id=in_accountid);
DELETE FROm user_configuration_column WHERE USER_ID IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROm api_user_mapping WHERE API_USER_ID IN (SELECT ID FROM users WHERE account_id=in_accountid);
DELETE FROM users WHERE account_id=in_accountid;
DELETE FROM assets WHERE ENT_ACCOUNTID=in_accountid;   
DELETE FROM accounts WHERE id=in_accountid;
DELETE FROM organization_organization WHERE id=in_accountid;

SET FOREIGN_KEY_CHECKS=1;
-- print msg that data is not found
ELSE
  
  -- when no data found in table 
  SELECT 'Account id NOT FOUND' ;
  
END IF;
  
END//
DELIMITER ;