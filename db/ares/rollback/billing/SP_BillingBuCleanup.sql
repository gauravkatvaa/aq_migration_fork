DROP procedure IF EXISTS `SP_BillingBuCleanup`;

 DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `SP_BillingBuCleanup`(IN p_accountId int(10), IN p_tableSchema varchar(255))
BEGIN 
    DECLARE _accountId int;
    DECLARE _tariffIds varchar(50) default '[]';
    DECLARE _tableName VARCHAR(255);
    DECLARE done int;
   
    DECLARE cur CURSOR FOR SELECT table_name FROM information_schema.columns WHERE column_name = 'account_id' and table_schema=p_tableSchema and TABLE_NAME in (SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE');

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    DECLARE continue handler for sqlexception
    BEGIN
            
            GET DIAGNOSTICS CONDITION 1
            @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
            SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
    
    END;
        DELETE FROM ap_vas_charges where account_plan_id in (select id from account_plan where account_id=p_accountId);
        DELETE FROM account_plan_discount_tiered where account_plan_discount_id in (select id from account_plan_discount where account_plan_id in (select id from account_plan where account_id=p_accountId));
        DELETE FROM account_plan_discount where account_plan_id in (select id from account_plan where account_id=p_accountId);
        DELETE FROM dp_vas_charges where device_id in (select id from device_plan where account_id=p_accountId);
		DELETE FROM device_plan_discount_tiered where device_plan_discount_id in (select id from device_plan_discount where device_plan_id in (select id from device_plan where account_id=p_accountId));
		DELETE FROM device_plan_discount where device_plan_id in (select id from device_plan where account_id=p_accountId);
        DELETE FROM sim_meta_info where last_device_id in (select id from device_plan where account_id=p_accountId);
            OPEN cur;
				read_loop: LOOP
					FETCH cur INTO _tableName;
					IF (done=1) THEN
						SET done=0;
						LEAVE read_loop;
					END IF;
	
					SET @delete_query = CONCAT('DELETE FROM ', _tableName, ' WHERE account_id=',p_accountId);
					select concat(@delete_query);
					PREPARE stmt FROM @delete_query;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
				END LOOP read_loop;

			CLOSE cur;
			DELETE FROM account where id in (p_accountId);
        
        commit;
    END ;;
DELIMITER ;
