DROP procedure IF EXISTS `SHARED_PLAN_MIGRATION_PROCEDURE`;

DELIMITER //
CREATE PROCEDURE SHARED_PLAN_MIGRATION_PROCEDURE(IN p_invoiceDate date)
BEGIN
    declare _imsi varchar(30);
    declare _accountId int(10);
    declare _type varchar(30);
    declare _frequency varchar(30);
    declare p_invoice_date date;
    declare p_status varchar(30);
    declare _invoiceDate datetime;
    declare _renewalDate datetime;
    declare _deviceId int(10);
    
    declare _tariffId int(10);
    declare _action varchar(30);
    declare _imsiId int(10);
    declare _id int(10);
    declare done int default 0;
    declare _eventRef varchar(40);
    declare _poolLimit int(10) default 0;
    declare _totalSim int(10) default 0;
    declare _name varchar(50) default 0;
    declare _isSharedChargeAvailable int(10) default 0;



    
    -- declare c8 cursor for select distinct  id, device_plan_id, name, pool_limit, template_id from migration_device_plan;
    declare c8 cursor for select distinct a.id as id, a.device_plan_id as device_plan_id, a.name as name, a.type as _type, a.pool_limit as pool_limit from migration_device_plan a join  migration_assets b on a.device_plan_id=b.device_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE continue handler for sqlexception
    BEGIN
            -- ERROR
            -- ------------------------------------------------------------------------------------
            -- select "error message '%s' and errorno '%d'"------- this part in not working
            -- ------------------------------------------------------------------------------------
            GET DIAGNOSTICS CONDITION 1
            @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
            SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
        SET p_status='FAILED';
       -- SET _discardRecords=_discardRecords+1;
       -- SET _status_code=-403;
        insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(_imsi,'FAILED :S_DP',CONCAT('SPLAN :',_deviceId),_id);
    END;

   -- SET p_invoice_date=date('2024-03-28');
    SET _imsi = '';
    SET _accountId = 0;
--    SET _deviceId = 0;
    SET _frequency = 'Monthly';
    SET _invoiceDate = p_invoice_date;
    SET _renewalDate = p_invoice_date;

    SET _action = 'NONE';
    SET _imsiId = 0;
    SET _id = 0;
    
    -- select count(*) into _beforeRecords from sim_activation;
    -- truncate table migration_assets_validation;

    

    open c8;
    cursorloop8:loop    
    
    fetch c8 into _id, _deviceId, _name, _type, _poolLimit;
        
        IF (done = 1) THEN
            SET p_status='SUCCESS';
--            select 'Finished';
             -- select 'open c18';
            leave cursorloop8;
        END IF;
        select account_id , quota_frequency into  _accountId, _frequency from device_plan where id=_deviceId;
        SELECT COUNT(*) into _totalSim from sim_activation where device_id=_deviceId;
        -- select count(*) into _isSharedChargeAvailable from migration_billing_charges where plan_id in (select template_id from migration_device_plan where device_plan_id=_deviceId) and action_type='SharedDP_Assigned';
        IF(_totalSim>0 and _type='SharedPlan') THEN    
            IF (_frequency = 'Yearly') THEN
                SET _renewalDate = (SELECT DATE_ADD(_invoiceDate, INTERVAL 365 DAY));
            ELSE
                SET _renewalDate = _invoiceDate;
            END IF;

            SET _action = 'SharedDP_Assigned';
            SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
            call CHARGE_MIGRATION_PROCEDURE(_accountId,p_invoiceDate,_renewalDate,_frequency,null,_deviceId,_action, _eventRef);
                        
        END IF;
    end loop cursorloop8;
    close c8;


        -- SET p_status='SUCCESS';
END //
DELIMITER ;
