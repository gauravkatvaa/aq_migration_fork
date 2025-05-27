-- --------------------------------------------------------
-- Host:                         192.168.1.122
-- Server version:               8.0.32 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.5.0.6677
-- Author						 Sabin Sunny
-- --------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `start_register_user_batch_call`;
CREATE PROCEDURE start_register_user_batch_call(
 IN prorationEnabled BOOLEAN,
 IN clientType INT)
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur_imsi VARCHAR(255);
    DECLARE cur_msisdn VARCHAR(255);
    DECLARE cur_iccid VARCHAR(255);
    DECLARE cur_account_id BIGINT;
    DECLARE cur_device_id BIGINT;
    DECLARE cur_service_plan_id BIGINT;
    DECLARE cur_event_date DATE;
    DECLARE cur_activation_date DATE;
    DECLARE cur_reason VARCHAR(255);
    DECLARE cur_state VARCHAR(255);
    DECLARE cur_status BIT;
	DECLARE continueHandler INT DEFAULT 0;
	DECLARE sqlStateVar VARCHAR(5);
    
    DECLARE cursor_migration_assets CURSOR FOR
        SELECT imsi, msisdn, iccid, account_id, device_plan_id, service_plan_id, event_date, activation_date, reason, state, status
        FROM migration_asset where status is false;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Declare a continue handler for a specific SQLSTATE code
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET continueHandler = 1;
    -- Open the cursor
    
	SET @beforeExecution = (select count(*) as count from tuser_sim_card);
    SET @successCount = 0;
    SET @successOut = 0;
    SET @failedCount = 0;
    OPEN cursor_migration_assets;

    -- Start iterating through the query result
    read_loop: LOOP
        -- Fetch data into variables
        FETCH cursor_migration_assets INTO
            cur_imsi, cur_msisdn, cur_iccid, cur_account_id, cur_device_id, cur_service_plan_id,
            cur_event_date, cur_activation_date, cur_reason, cur_state, cur_status;

        -- Check if there are no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Process the fetched data
			 BEGIN
             GET DIAGNOSTICS CONDITION 1 sqlStateVar = RETURNED_SQLSTATE;
				-- Call the inner procedure
			SET continueHandler =0;
			SET @successOut = 0;
			CALL register_user(cur_imsi, cur_msisdn,cur_iccid,cur_account_id,cur_device_id,cur_service_plan_id,cur_state,prorationEnabled,clientType,@successOut);
			 IF continueHandler = 1 THEN
				 SET @failedCount = @failedCount + 1;
				 IF sqlStateVar <> '45000' THEN
					LEAVE read_loop;
				 ELSE 
					SET continueHandler =0;
				 END IF;
			END IF;
            SET @successCount= @successCount + @successOut;
        END;
    END LOOP;

    -- Close the cursor
    CLOSE cursor_migration_assets;
    SET @afterExecution = (select count(*) as count from tuser_sim_card);
    SELECT CONCAT('before_excution: ',IFNULL(@beforeExecution,0)) as before_excution,
	CONCAT('after_execution: ',IFNULL(@afterExecution,0)) as after_execution,
	CONCAT('success_count: ',IFNULL(@successCount,0)) as success_count,
	CONCAT('failed_count: ',IFNULL(@failedCount,0)) as failed_count,
	IFNULL(@MESSAGE_TEXT,'') as Remarks;
END //

DELIMITER ;