-- --------------------------------------------------------
-- Host:                         192.168.1.122
-- Server version:               8.0.32 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.5.0.6677
-- Author						 Sabin Sunny
-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS `start_register_user_batch_call_optimized`;
DELIMITER //
CREATE PROCEDURE start_register_user_batch_call_optimized(
    IN prorationEnabled BOOLEAN,
    IN clientType INT,
    IN imsiList TEXT
)
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
        FROM migration_asset
        WHERE status IS FALSE
        AND FIND_IN_SET(imsi, imsiList)
        ORDER BY imsi;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET continueHandler = 1;
	
    SET @successCount = 0;
    SET @successOut = 0;
    SET @failedCount = 0;

    -- Open the cursor
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

        -- Start Transaction
        START TRANSACTION;

        BEGIN
            SET continueHandler = 0;
            SET @successOut = 0;
            
            -- Call the inner procedure
            CALL register_user_optimized(
                cur_imsi, cur_msisdn, cur_iccid, cur_account_id, cur_device_id, cur_service_plan_id,
                cur_state, prorationEnabled, clientType, @successOut
            );

            -- Check if the inner procedure failed
            IF continueHandler = 1 THEN
                SET @failedCount = @failedCount + 1;
                GET DIAGNOSTICS CONDITION 1 sqlStateVar = RETURNED_SQLSTATE;

                -- Rollback transaction if an unexpected error occurs
                IF sqlStateVar <> '45000' THEN
                    ROLLBACK;
                    LEAVE read_loop;
                ELSE
                    -- Allow continuation for expected error (45000)
                    SET continueHandler = 0;
                END IF;
            ELSE
                -- Commit transaction on success
                SET @successCount = @successCount + @successOut;
                COMMIT;
            END IF;
        END;
    END LOOP;

    -- Close the cursor
    CLOSE cursor_migration_assets;

    -- Return summary
    SELECT @successCount AS success_count, @failedCount  AS failed_count, IFNULL(@MESSAGE_TEXT, '') AS Remarks;
END //

DELIMITER ;
