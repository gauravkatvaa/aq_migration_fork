DROP procedure IF EXISTS `SIM_MIGRATION_PROCEDURE`;

DELIMITER //
CREATE PROCEDURE SIM_MIGRATION_PROCEDURE()
BEGIN
    declare _imsi varchar(30);
    declare _accountId int(10);
    declare _eventDate datetime;
    declare _activationDate datetime;
    declare _deviceId int(10);
    declare _iccid varchar(30);
    declare _msisdn varchar(30);
    declare _reason varchar(256);
    declare _state varchar(30);
    declare _type varchar(30);
    declare _frequency varchar(30);
    declare p_invoice_date date;
    declare p_status varchar(30);
    declare _invoiceDate datetime;
    declare _renewalDate datetime;

    declare _chargeSubtype varchar(30);
    declare _tariffId int(10);
    declare _proration int(10);
    declare _glCodeId int(10);
    declare _action varchar(30);
    declare _imsiId int(10);
    declare _id int(10);
    declare done int default 0;
    declare _eventRef varchar(40);
    declare _status_code int(10);
    declare _beforeRecords int(10) default 0;
    declare _afterRecords int(10) default 0;
    declare _successfullRecords int(10) default 0;
    declare _discardRecords int(10) default 0;
    declare _poolLimit int(10) default 0;
    declare _totalSim int(10) default 0;
    declare _name varchar(30) default 0;
    declare _isSharedChargeAvailable int(10) default 0;
    declare _accountPlanId int(10) default 0;


    declare c7 cursor for select distinct a.imsi_id as imsi_id, a.id as id, a.imsi as imsi,a.account_id as account_id,a.event_date as event_date,a.activation_date as activation_date,
        a.device_id as device_id,a.iccid as iccid,a.msisdn as msisdn,a.reason as reason,a.state as state,b.type as type,
        b.frequency as frequency, b.pool_limit as pool_limit from migration_assets as a join migration_device_plan as b on a.device_id=b.device_plan_id;
    
    -- declare c8 cursor for select distinct  id, device_plan_id, name, pool_limit, template_id from migration_device_plan;
    declare c8 cursor for select distinct a.id as id, a.device_plan_id as device_plan_id, a.name as name, a.type as _type, a.pool_limit as pool_limit from migration_device_plan a join  migration_assets b on a.device_plan_id=b.device_id;
    declare apCursor cursor for select whole_sale_id from account_plan where account_id=_accountId;
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
        SET _discardRecords=_discardRecords+1;
        SET _status_code=-403;
        insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(_imsi,'FAILED',CONCAT('DUPLICATE IMSI :',_imsi),_id);
    END;

    SET p_invoice_date=date('2024-03-28');
    SET _imsi = '';
    SET _accountId = 0;
    SET _eventDate = '2024-02-28 00:00:00';
    SET _activationDate = '2024-02-28 00:00:00';
    SET _deviceId = 0;
    SET _iccid = '';
    SET _msisdn = '';
    SET _reason = '';
    SET _state = '';
    SET _type = '';
    SET _frequency = 'Monthly';
    

    SET _chargeSubtype = 'RC';
    SET _tariffId = 0;
    SET _proration = 0;
    SET _glCodeId = 0;
    SET _action = 'NONE';
    SET _imsiId = 0;
    SET _id = 0;
    
    select count(*) into _beforeRecords from sim_meta_info;
    select now() as start_time;
    truncate table migration_assets_validation;

    open c7;
    cursorloop:loop
        fetch c7 into _imsiId, _id, _imsi, _accountId, _eventDate, _activationDate, _deviceId, _iccid, _msisdn, _reason, _state, _type, _frequency, _poolLimit;
        IF (done = 1) THEN
        SET done=0;
            SET p_status='SUCCESS';
--            select 'Finished';
            leave cursorloop;
        END IF;
        select next_invoice_date into p_invoice_date from account where id=_accountId;
        SET _invoiceDate = p_invoice_date;
        SET _renewalDate = p_invoice_date;
        
        select quota_frequency into _frequency from device_plan where id=_deviceId;
        -- call validation procedure
        call VALIDATION_ENGINE_PROCEDURE(_imsi, _id , _accountId , _deviceId ,_state, @out_status_code);
        -- call VALIDATION_ENGINE_PROCEDURE(_imsi, _id , _accountId , _deviceId ,@out_status_code);
        select @out_status_code into _status_code;

        IF(_status_code>0) THEN


        -- insert into sim_activation(`imsi`,`account_id`,`action`,`event_date`,`activation_date`,`device_id`,
        --    `iccid`,`msisdn`,`reason`,`service_plan_id`,`state`,`pseudo_state`,`last_action`,`last_event_date`,`last_device_id`,
        --    `last_iccid`,`last_reason`,`last_service_plan_id`,`last_state`,`created_date`,`updated_date`) values(_imsi,_accountId,'SimState',
        --    _eventDate,_activationDate,_deviceId,_iccid,_msisdn,_reason,'1',_state,_state,'SimState',_eventDate,_deviceId,_iccid,_reason,'1',_state,now(),now());

        --    SET _imsiId = (SELECT id FROM sim_activation where sim_activation.imsi=_imsi limit 1);
        insert into sim_meta_info(`id`,`imsi`,`pseudo_state`,`last_action`,`last_event_date`,`last_device_id`,
        `last_iccid`,`last_reason`,`last_service_plan_id`,`last_state`) values(_imsiId,_imsi,_state,'SimState',_eventDate,_deviceId,_iccid,_reason,'1',_state);
        
            SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                            (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);

            IF (_state = 'Suspended') THEN
                SET _action = 'Suspension-CustInitiated';
                call UPDATE_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
            ELSEIF(_state = 'Activated') THEN
                SET _status_code=999; 
                -- for shared dp
                SET _action = 'NONE';
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
                SET _action = 'SIM_Activated';
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
            ELSE 
                IF(_status_code = 999) THEN
                SET _action = 'SharedDP_Assigned';
                call SHARED_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
                -- check for shared dp and apply
                END IF;
            END IF;

            SELECT COUNT(*) into _totalSim from sim_activation where device_id=_deviceId;
            -- select count(*) into _isSharedChargeAvailable from migration_billing_charges where plan_id in (select template_id from migration_device_plan where device_plan_id=_deviceId) and action_type='SharedDP_Assigned';

        
            IF (_type='SharedPlan' and _poolLimit>0 and _totalSim > _poolLimit) THEN
                    SET _action = 'SharedPoolLimitBreached';
                    SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
                
                    call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef);
                    -- check for shared dp and apply
                END IF;

            IF (_frequency = 'Yearly') THEN
                SET _renewalDate = (SELECT DATE_ADD(_invoiceDate, INTERVAL 365 DAY));
            ELSE
                SET _renewalDate = _invoiceDate;
            END IF;

            -- apply AP charges
            IF (_totalSim = 1) THEN 
                    SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
                    -- select id, template_id into _accountPlanId,_templateId from account_plan where account_id=_accountId;
                    -- call AP_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_accountPlanId,_action, _eventRef);
                    -- declare forloop cursor for select id, template_id from account_plan where account_id=_accountId;
                    open apCursor;
                    aploop:loop
                    Fetch apCursor into _accountPlanId ;
                    IF (done = 1) THEN
                        SET done=0;
                        SET p_status='SUCCESS';
                        --            select 'Finished';
                        leave aploop;
                    END IF;
                        SET _action = 'AP_Assigned';
                        
                        call AP_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,NULL,_accountPlanId,_action, _eventRef);
                        SET _action = 'NONE';
                        call AP_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,NULL,_accountPlanId,_action, _eventRef);
                        
                        call update_tariffIds_by_ap(_accountPlanId);

                end loop aploop;
                close apCursor;
                update account set sim_assigned=1 where id=_accountId;
            END IF;


            
           -- SET p_status='SUCCESS';
            IF (_status_code > 0) THEN
                insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(_imsi,'SUCCESS',CONCAT('PROCESSED IMSI:',_imsi),_id);
            END IF;
        ELSE
            -- SELECT CONCAT('FAILED TO PROCESS ASSET ID',_id);
            SET p_status='FAILED';
            SET _discardRecords = _discardRecords+1;
        END IF;
    end loop cursorloop;
    close c7;
-- this needs to move to new procedure 
-- account_id call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,null,_deviceId,_action, _eventRef);
    call SHARED_PLAN_MIGRATION_PROCEDURE(_invoiceDate);
-- upto this line move to shared plan charges procedure
    call APN_MIGRATION_PROCEDURE(_invoiceDate);
    select count(*) into _afterRecords from sim_meta_info;
    SET _successfullRecords=_afterRecords - _beforeRecords;
    select concat('before_execution:',_beforeRecords,',after_execution:',_afterRecords,',failed_count:',_discardRecords,',success_count:',_successfullRecords) AS MESSAGE;
select now() as end_time;
        -- SET p_status='SUCCESS';
END //
DELIMITER ;

