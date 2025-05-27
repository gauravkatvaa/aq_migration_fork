DROP PROCEDURE IF EXISTS  removeAccountDetails;

DELIMITER //

CREATE PROCEDURE removeAccountDetails(IN acntId INT)
BEGIN
	
	delete from tservice_plan where ACCOUNT_ID = acntId;
	delete from tuser_purchase where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from tuser where id in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from tdata_bucket where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from tsim_card_pool_data_cap where SIM_CARD_POOL_ID in (select DISTINCT(data_id) from tdevice_plan where planType not in ('SimPlan') and data_id is not null and accountId = acntId);
	delete from tenterprise_purchase where SIM_CARD_POOL_ID in (select DISTINCT(data_id) from tdevice_plan where planType not in ('SimPlan') and data_id is not null and accountId = acntId);
	delete from tsim_card_pool where ID in (select DISTINCT(data_id) from tdevice_plan where planType not in ('SimPlan') and data_id is not null and accountId = acntId);
	delete from tsim_card_pool_data_cap where SIM_CARD_POOL_ID in (select DISTINCT(sms_id) from tdevice_plan where planType in ('RollingPoolPlan') and sms_id is not null and accountId = acntId);
	delete from tenterprise_purchase where SIM_CARD_POOL_ID in (select DISTINCT(sms_id) from tdevice_plan where planType in ('RollingPoolPlan') and sms_id is not null and accountId = acntId);
	delete from tsim_card_pool where ID in (select DISTINCT(sms_id) from tdevice_plan where planType in ('RollingPoolPlan') and sms_id is not null and accountId = acntId);
	delete from tcdr_user_monetary_data where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from tcdr_user_data where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  ttransactionlog where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  tuser_data_notification where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  tuser_ocs_data where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  tuser_ocs_session_status where imsi in (select DISTINCT(IMSI) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  tuser_purchase_consumption_notification_entry where USER_ID in (select DISTINCT(USER_ID) from tuser_sim_card where ACCOUNT_ID = acntId);
	delete from  price_model_zone_service where pm_id in (select id from price_model where account_id = acntId);
	delete from  price_model where account_id = acntId ; 
	delete from  tdevice_plan_quota where ACCOUNT_ID = acntId;
	delete from  tdevice_plan where accountId = acntId;
	delete from  tuser_sim_card where ACCOUNT_ID = acntId;
	delete from  tenterprise_account where ACCOUNT_ID = acntId;
	-- update migration_asset set status=b'0' where account_id = acntId;
    
END //
DELIMITER ;