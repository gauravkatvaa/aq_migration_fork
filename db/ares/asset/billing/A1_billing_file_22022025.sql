DROP TABLE IF EXISTS `migration_device_plan`;

CREATE TABLE `migration_device_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `device_plan_id` bigint DEFAULT NULL,
  `name` varchar(264) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'SimPlan',
  `pool_limit` int NOT NULL DEFAULT '0',
  `frequency` varchar(20) DEFAULT 'Monthly',
  `template_id` bigint NOT NULL,
  `billing_account_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `migration_billing_charges`;

 CREATE TABLE `migration_billing_charges` (
  `plan_id` bigint NOT NULL,
  `charge_spec_id` bigint NOT NULL,
  `charge_category` varchar(50) NOT NULL,
  `gl_code_id` bigint NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `is_proration` tinyint(1) NOT NULL,
  `parent_csid` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `discount_id` int DEFAULT NULL,
  `discount_glcode_id` int DEFAULT NULL,
  `apn_type` varchar(30) DEFAULT NULL,
  `service_category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `migration_assets_validation`;
CREATE TABLE `migration_assets_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `imsi` varchar(50) NOT NULL,
  `status` varchar(30) NOT NULL,
  `remarks` varchar(500) DEFAULT NULL,
  `assets_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ;

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
  `url_barring_applied` tinyint(1) DEFAULT '0',
  `static_ip_applied` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ;

DROP TABLE IF EXISTS `migration_service_apn_details`;
CREATE TABLE `migration_service_apn_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `DEVICE_ID` varchar(255) NOT NULL,
  `APN_NAME` varchar(255) NOT NULL,
  `APN_ID` varchar(255) NOT NULL,
  `APN_TYPE` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);
-- 
DROP procedure IF EXISTS `AP_CHARGE_MIGRATION_PROCEDURE`;

DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `AP_CHARGE_MIGRATION_PROCEDURE`(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_accountPlanId int,IN p_action varchar(30),IN p_eventRef varchar(40),IN p_eventType varchar(50) ,IN p_chargeHandler int)
BEGIN
    declare _chargeSubtype varchar(30);
    declare _tariffId int(10);
    declare _proration int(10);
    declare _glCodeId int(10);
    declare _templateId int(10);
    declare _action varchar(30);
    declare done int default 0;
    declare _endDate date;
    declare _startDate date;
    declare _status_code int(10);
    declare p_status varchar(30);
    declare _planId int default 0;
    declare _count int default 0;
    declare _aggregationExcluderKey varchar(30) default 'include';
    
    declare _discountId int default 0;
    declare _discountGlcodeId int default 0;
    declare _alreadyApplied  int default 0;
                    
    

    declare _apnType varchar(30);
    declare _serviceCategory varchar(20);
  
    
    
    
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            declare c7 cursor for select a.charge_category as charge_subtype,a.charge_spec_id as tariff_id,a.is_proration as proration,
            a.gl_code_id as gl_code_id,a.plan_id as _templateId, a.discount_id as discount_id, a.discount_glcode_id as discount_glcode_id, 
            a.apn_type as _apnType, a.service_category as _serviceCategory from migration_billing_charges as a join account_plan as b on
            a.plan_id=b.template_id and b.id=p_accountPlanId and a.action_type in (p_action) and a.charge_category='RC';

            
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
            SET _chargeSubtype = 'RC';
            SET _tariffId = 0;
            SET _proration = 0;
            SET _glCodeId = 0;
            SET _templateId = 0;

        
            open c7;
            cursorloop:loop
                fetch c7 into _chargeSubtype,_tariffId,_proration,_glCodeId,_templateId, _discountId, _discountGlcodeId, _apnType,_serviceCategory;
                IF (done = 1) THEN
                    SET p_status='SUCCESS';
                    
                        leave cursorloop;
                END IF;             

                IF (_chargeSubtype = 'OTC') THEN
                    SET _endDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                ELSE
                    SET _endDate = NULL;
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                END IF;

                IF (p_frequency='monthly') THEN
                    SET p_frequency='Monthly';
                END IF;

                    SET _alreadyApplied=0;
                    IF (_alreadyApplied=0) THEN
                    
                        
                         select count(*) into _alreadyApplied from account_plan where account_id=p_accountId and tariff_ids like concat('%',_tariffId,'%');
                      
                    END IF;

                    IF (_alreadyApplied=0) THEN
                        insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                        `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                        `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                        `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`,`event_type`,`charge_handler`,`service_category`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                        p_eventRef,_startDate,'ACCOUNT',_chargeSubtype,NULL,_tariffId,NULL,0,_startDate,_endDate,
                        'New','OPEN',_glCodeId,NULL, NULL,NULL,'include',p_accountPlanId,NULL, p_eventType, p_chargeHandler,_serviceCategory);
                    
                        -- IF (_discountId is not null) THEN
                            --    call AP_DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_accountPlanId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId); 
                        -- END IF;
                        
                        
                       
                    END IF;

	            
            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;
END ;;
DELIMITER ;



-- AP_DISCOUNT_MIGRATION_PROCEDURE starts
/* DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `AP_DISCOUNT_MIGRATION_PROCEDURE`(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_accountPlanId int,IN p_action varchar(30),IN p_eventRef varchar(40),
IN p_chargeSubtype varchar(30), IN p_discountId int, IN p_discountGlcodeId int,  IN p_tariffId int)
BEGIN
    declare _chargeSubtype varchar(30);
    declare _tariffId int(10);
    declare _proration int(10);
    declare _glCodeId int(10);
    declare _templateId int(10);
    declare _action varchar(30);
    declare done int default 0;
    declare _endDate date;
    declare _startDate date;
    declare _status_code int(10);
    declare p_status varchar(30);
    declare _planId int default 0;
    declare _count int default 0;
    declare _aggregationExcluderKey varchar(30) default 'include';

    declare _discountId int default 0;
    declare _discountGlcodeId int default 0;
    declare _discountType varchar(30);
    declare _type varchar(30);
    declare _price decimal(65,6) default 0.0;
    declare _vasEndDate date;
    declare _vasStartDate date;
    


    
    
    
    SET _status_code=1;    
        

    IF (_status_code>0) THEN
        BEGIN
            declare c7 cursor for select charge_spec_id , discount_type ,type,gl_code , price , start_date, end_date from account_plan_discount where account_plan_id=p_accountPlanId and charge_spec_id=p_tariffId;

            
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
            SET _chargeSubtype = p_chargeSubtype;
            SET _tariffId = 0;
            SET _proration = 0;
            SET _glCodeId = 0;
            SET _templateId = 0;
            SET _discountId = p_discountId;
            SET _discountGlcodeId = p_discountGlcodeId;

        
            open c7;
            cursorloop:loop
                fetch c7 into _tariffId,_discountType,_type,_discountGlcodeId,_price, _vasStartDate, _vasEndDate;
            
                IF (done = 1) THEN
                    SET p_status='SUCCESS';
                    
                        leave cursorloop;
                END IF;             

                IF (p_chargeSubtype = 'OTC') THEN
                    SET _vasStartDate = (select LEAST(_vasStartDate,p_invoiceDate));
                    SET _vasEndDate = (select LEAST(_vasStartDate,p_invoiceDate));
                    SET _endDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                ELSE
   
                    SET _vasStartDate = (select LEAST(_vasStartDate,p_invoiceDate));
                    SET _vasEndDate = NULL;
                    SET _endDate = NULL;
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                END IF;
                IF (p_frequency='monthly') THEN
                    SET p_frequency='Monthly';
                END IF;

                IF (p_action = 'Suspension-CustInitiated') THEN
                    SET _aggregationExcluderKey=p_imsiId;
                END IF;
                
                IF (_type='PERCENT') THEN 
                        insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                        `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                        `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,
                        `discount_id`,`discount_charge_ref`,
                        `discount_override_percent`,`discount_override`,`discount_tier`,
                        `discount_start_date`,`discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`)
                         values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                        p_eventRef,_startDate,'DISCOUNT',_chargeSubtype,p_imsiId,_tariffId,NULL,0,_startDate,_endDate,
                        'New','OPEN',_glCodeId,_discountId,_discountGlcodeId,_price,0.0,NULL,
                        _vasStartDate, _vasEndDate,_glCodeId,'include',p_accountPlanId,NULL);
                   ELSE
                        insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                        `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                        `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,
                        `discount_id`,`discount_charge_ref`,
                        `discount_override_percent`,`discount_override`,`discount_tier`,
                        `discount_start_date`,`discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`)
                         values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                        p_eventRef,_startDate,'DISCOUNT',_chargeSubtype,p_imsiId,_tariffId,NULL,0,_startDate,_endDate,
                        'New','OPEN',_glCodeId,_discountId,_discountGlcodeId,0.0,_price,NULL,
                        _vasStartDate, _vasEndDate,_glCodeId,'include',p_accountPlanId,NULL);
                END IF;
            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;

END ;;
DELIMITER ;
 */

-- 

DROP procedure IF EXISTS `CHARGE_MIGRATION_PROCEDURE`;

DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `CHARGE_MIGRATION_PROCEDURE`(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_deviceId int,IN p_action varchar(30),IN p_eventRef varchar(40),IN p_eventType varchar(50) ,IN p_chargeHandler int)
BEGIN
    declare _chargeSubtype varchar(30);
    declare _tariffId int(10);
    declare _parentCsid int(10);
    declare _proration int(10);
    declare _glCodeId int(10);
    declare _templateId int(10);
    declare _action varchar(30);
    declare done int default 0;
    declare _endDate date;
    declare _startDate date;
    declare _status_code int(10);
    declare p_status varchar(30);
    declare _planId int default 0;
    declare _count int default 0;
    declare _aggregationExcluderKey varchar(30) default 'include';

    declare _discountId int default 0;
    declare _discountGlcodeId int default 0;
    declare _serviceCategory varchar(20);
    
        SET _planId = (SELECT template_id FROM migration_device_plan where migration_device_plan.device_plan_id=p_deviceId limit 1);
    
    
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            declare c7 cursor for select a.charge_category as charge_subtype,a.charge_spec_id as tariff_id, a.parent_csid as parent_csid, a.is_proration as proration,
            a.gl_code_id as gl_code_id,a.plan_id as _templateId, a.discount_id as discount_id, a.discount_glcode_id as discount_glcode_id, a.service_category as _serviceCategory from migration_billing_charges as a join migration_device_plan as b on
            a.plan_id=b.template_id and b.device_plan_id=p_deviceId and a.action_type in (p_action) and a.charge_category="RC";

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
            SET _chargeSubtype = 'RC';
            SET _tariffId = 0;
            SET _proration = 0;
            SET _glCodeId = 0;
            SET _templateId = 0;
            SET _parentCsid=0;
            
            open c7;
            cursorloop:loop
                fetch c7 into _chargeSubtype,_tariffId,_parentCsid,_proration,_glCodeId,_templateId, _discountId, _discountGlcodeId, _serviceCategory;
                IF (done = 1) THEN
                    SET p_status='SUCCESS';
                    
                        leave cursorloop;
                END IF;             

                IF (_chargeSubtype = 'OTC') THEN
                    SET _endDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                ELSE
                    SET _endDate = NULL;
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                END IF;

                IF (p_action = 'Suspension-CustInitiated') THEN
                    IF (_parentCsid is not NULL && _parentCsid != 0) THEN
                        SET _aggregationExcluderKey=p_imsiId;
                    END IF;
                END IF;
                IF (p_frequency='monthly' or p_frequency is null or p_frequency='') THEN
                    SET p_frequency='Monthly';
                END IF;
               -- select p_renewalDate;
                -- select concat('invoice_date',p_accountId,p_action,'p_invoiceDate',p_invoiceDate);

                    insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                    `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                    `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                    `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`,`event_type`,`charge_handler`,`service_category` ) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                    p_eventRef,_startDate,'SIM',_chargeSubtype,p_imsiId,_tariffId,p_deviceId,0,_startDate,_endDate,
                    'New','OPEN',_glCodeId,_startDate, _endDate,_glCodeId,_aggregationExcluderKey,NULL,NULL,p_eventType,p_chargeHandler,_serviceCategory);
                
                -- IF (_discountId is not null) THEN 
               --         call DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_deviceId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId);
                -- END IF;

            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;

END ;;
DELIMITER ;

 
 -- 
 DROP procedure IF EXISTS `SHARED_PLAN_MIGRATION_PROCEDURE`;
 DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `SHARED_PLAN_MIGRATION_PROCEDURE`()
BEGIN
    declare _imsi varchar(30);
    declare _accountId int(10);
    declare _type varchar(30);
    declare _frequency varchar(30);
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
    declare _eventType varchar(50);
    declare _chargeHandler int(10);

    declare c8 cursor for select distinct a.id as id, a.device_plan_id as device_plan_id, a.type as _type, a.pool_limit as pool_limit from migration_device_plan a join  migration_assets b on a.device_plan_id=b.device_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE continue handler for sqlexception
    BEGIN
            
            GET DIAGNOSTICS CONDITION 1
            @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
            SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
        SET p_status='FAILED';
       
       
        insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(_imsi,'FAILED :S_DP',CONCAT('SPLAN :',_deviceId),_id);
    END;

   
    SET _imsi = '';
    SET _accountId = 0;

    SET _frequency = 'Monthly';
    

    SET _action = 'NONE';
    SET _imsiId = 0;
    SET _id = 0;
    open c8;
    cursorloop8:loop    
    
    fetch c8 into _id, _deviceId,  _type, _poolLimit;
        
        IF (done = 1) THEN
            SET p_status='SUCCESS';

             
            leave cursorloop8;
        END IF;
        
        select quota_frequency,account_id  into _frequency,   _accountId  from device_plan where id=_deviceId;
        select next_invoice_date into _invoiceDate from account where id=_accountId;
        SELECT COUNT(*) into _totalSim from sim_meta_info where last_device_id=_deviceId;
        
        
        SET _renewalDate = _invoiceDate;
        
        -- select concat('invoice date',_invoice_date,'account_id',_accountId);

        IF(_totalSim>0 and _type='SharedPlan') THEN    
            IF (_frequency = 'Yearly') THEN
                SET _renewalDate = (SELECT DATE_ADD(_invoiceDate, INTERVAL 365 DAY));
            ELSE
                SET _renewalDate = _invoiceDate;
            END IF;

            SET _action = 'SharedDP_Assigned';
            SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
                SET _eventType ="ActiveSim";
                SET _chargeHandler=0;
             -- select concat('invoice date',_invoiceDate,'account_id',_accountId,'action',_action);
             call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,null,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
            -- call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,null,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
                        
        END IF;
    end loop cursorloop8;
    close c8;


        
END ;;
DELIMITER ;


-- 
DROP procedure IF EXISTS `SIM_MIGRATION_PROCEDURE`;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `SIM_MIGRATION_PROCEDURE`()
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
    declare _eventType varchar(50);
    declare _chargeHandler int(10);


    declare c7 cursor for select distinct a.imsi_id as imsi_id, a.id as id, a.imsi as imsi,a.account_id as account_id,a.event_date as event_date,a.activation_date as activation_date,
        a.device_id as device_id,a.iccid as iccid,a.msisdn as msisdn,a.reason as reason,a.state as state,b.type as type,
        b.frequency as frequency, b.pool_limit as pool_limit from migration_assets as a join migration_device_plan as b on a.device_id=b.device_plan_id;
    
    
    declare c8 cursor for select distinct a.id as id, a.device_plan_id as device_plan_id, a.name as name, a.type as _type, a.pool_limit as pool_limit from migration_device_plan a join  migration_assets b on a.device_plan_id=b.device_id;
    declare apCursor cursor for select whole_sale_id from account_plan where account_id=_accountId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE continue handler for sqlexception
    BEGIN
            
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
    SET _eventType = null;
    SET _chargeHandler = 0;
    
    select count(*) into _beforeRecords from sim_meta_info;
    select now() as start_time;
    truncate table migration_assets_validation;

    open c7;
    cursorloop:loop
        fetch c7 into _imsiId, _id, _imsi, _accountId, _eventDate, _activationDate, _deviceId, _iccid, _msisdn, _reason, _state, _type, _frequency, _poolLimit;
        IF (done = 1) THEN
            SET done=0;
            SET p_status='SUCCESS';
            leave cursorloop;
        END IF;
        select next_invoice_date into p_invoice_date from account where id=_accountId;
        SET _invoiceDate = p_invoice_date;
        SET _renewalDate = p_invoice_date;
        
        select quota_frequency into _frequency from device_plan where id=_deviceId;
        
        call VALIDATION_ENGINE_PROCEDURE(_imsi, _id , _accountId , _deviceId ,_state, @out_status_code);
        
        select @out_status_code into _status_code;

        IF(_status_code>0) THEN

            insert into sim_meta_info(`id`,`imsi`,`pseudo_state`,`last_action`,`last_event_date`,`last_device_id`,
                `last_iccid`,`last_reason`,`last_service_plan_id`,`last_state`) values(_imsiId,_imsi,_state,'SimState',_eventDate,_deviceId,_iccid,_reason,'1',_state);
        
            SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                            (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
            
            -- set for A1 in case of making suspension as Activated and ignoring suspension charges
            IF (_state = 'Suspended') THEN
                SET _state = 'Activated';
            END IF;

            
            IF (_state = 'Suspended') THEN
                SET _action = 'Suspension-CustInitiated';
                SET _eventType ="SuspendSim";
                SET _chargeHandler=0;
                call UPDATE_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
            ELSEIF(_state = 'Activated') THEN
                SET _status_code=999; 
                
                SET _action = 'NONE';
                SET _eventType ="ActiveSim";
                SET _chargeHandler=0;
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
                SET _action = 'SIM_Activated';
                SET _eventType ="ActiveSim";
                SET _chargeHandler=0;
                call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
                -- static ip and url barring
                SET _action = 'StaticIP';
                SET _eventType ="StaticIP";
                SET _chargeHandler=0;
                -- procedure call not required in A1
                -- call FIND_AND_APPLY_STATIC_IP_CHARGES(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
            ELSE 
                IF(_status_code = 999) THEN
                 SET _action = 'SharedDP_Assigned';
                END IF;
            END IF;

            SELECT COUNT(*) into _totalSim from sim_meta_info where last_device_id=_deviceId;
            
            IF (_type='SharedPlan' and _poolLimit>0 and _totalSim > _poolLimit) THEN
                    SET _action = 'SharedPoolLimitBreached';
                    SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
                    SET _eventType ="ActiveSim";
                    SET _chargeHandler=0;
                    call CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,_imsiId,_deviceId,_action, _eventRef,_eventType,_chargeHandler);
                    
            END IF;

            IF (_frequency = 'Yearly') THEN
                SET _renewalDate = (SELECT DATE_ADD(_invoiceDate, INTERVAL 365 DAY));
            ELSE
                SET _renewalDate = _invoiceDate;
            END IF;

            
            IF (_totalSim = 1) THEN 
                    SET _eventRef = (select conv( concat(substring(uid,16,3), substring(uid,10,4), substring(uid,1,8)),16,10) div 10000 -
                (141427 * 24 * 60 * 60 * 1000) as current_mills from (select uuid() uid) as alias);
                    
                    open apCursor;
                    aploop:loop
                    Fetch apCursor into _accountPlanId ;
                    IF (done = 1) THEN
                        SET done=0;
                        SET p_status='SUCCESS';
                        
                        leave aploop;
                    END IF;
                        SET _action = 'AP_Assigned';
                        SET _eventType ="AP";
                        SET _chargeHandler=0;
                        call AP_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,NULL,_accountPlanId,_action, _eventRef,_eventType,_chargeHandler);
                        SET _action = 'NONE';
                        call AP_CHARGE_MIGRATION_PROCEDURE(_accountId,_invoiceDate,_renewalDate,_frequency,NULL,_accountPlanId,_action, _eventRef,_eventType,_chargeHandler);
                        
                        call update_tariffIds_by_ap(_accountPlanId);

                end loop aploop;
                close apCursor;
                update account set sim_assigned=1 where id=_accountId;
            END IF;

            IF (_status_code > 0) THEN
                insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(_imsi,'SUCCESS',CONCAT('PROCESSED IMSI:',_imsi),_id);
            END IF;
            
        ELSE
            SET p_status='FAILED';
            SET _discardRecords = _discardRecords+1;
            ITERATE cursorloop;
        END IF;
    end loop cursorloop;
    close c7;


    call SHARED_PLAN_MIGRATION_PROCEDURE();


    select count(*) into _afterRecords from sim_meta_info;
    SET _successfullRecords=_afterRecords - _beforeRecords;
    select concat('before_execution:',_beforeRecords,',after_execution:',_afterRecords,',failed_count:',_discardRecords,',success_count:',_successfullRecords) AS MESSAGE;
select now() as end_time;
        
END ;;
DELIMITER ;

--

DROP procedure IF EXISTS `update_tariffIds_by_ap`;

DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `update_tariffIds_by_ap`(IN p_accountPlanId int(10))
BEGIN 
    DECLARE _accountPlanId int;
    DECLARE _tariffIds varchar(50) default '[]';
    DECLARE done int;
   
    DECLARE cur_ap_data cursor for SELECT id FROM account_plan where id =p_accountPlanId ;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
        Open cur_ap_data; 
            reading_ap_data:LOOP 
                Fetch cur_ap_data INTO _accountPlanId; 
                    
                IF done = 1 THEN 
                    SELECT 'FINISHED';
                    LEAVE reading_ap_data; 
                END IF;
                IF _accountPlanId is not null Then 
                   SET _tariffIds=(select concat('[',group_concat(distinct(tariff_id)),']') from billing_charges where account_plan_id=_accountPlanId);
                   IF (_tariffIds is null) then
                      SET  _tariffIds='[]';
                   END IF;
                update account_plan set tariff_ids=_tariffIds where id=_accountPlanId;
                END IF; 
                
            END LOOP;
            commit;
    END ;;
DELIMITER ;

 --
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

 --
 DROP procedure IF EXISTS `UPDATE_CHARGE_MIGRATION_PROCEDURE`;
 --
 DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `UPDATE_CHARGE_MIGRATION_PROCEDURE`(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_deviceId int,IN p_action varchar(30), IN p_eventRef varchar(40), IN p_eventType varchar(50), IN p_chargeHandler int)
BEGIN
    declare _chargeSubtype varchar(30);
    declare _tariffId int(10);
    declare _proration int(10);
    declare _glCodeId int(10);
    declare _templateId int(10);
    declare _action varchar(30);
    declare done int default 0;
    declare _endDate date;
    declare _startDate date;
    declare _status_code int(10);
    declare p_status varchar(30);
    declare _planId int default 0;

    SET _planId = (SELECT template_id FROM migration_device_plan where migration_device_plan.device_plan_id=p_deviceId limit 1);
    
    
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            declare c7 cursor for select a.charge_category as charge_subtype,a.charge_spec_id as tariff_id,a.is_proration as proration,
            a.gl_code_id as gl_code_id,a.plan_id as _templateId from migration_billing_charges as a join migration_device_plan as b on
            a.plan_id=b.template_id and b.device_plan_id=p_deviceId and a.action_type in ('NONE','SIM_ACTIVATED') and a.charge_category="RC";

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
            SET _chargeSubtype = 'RC';
            SET _tariffId = 0;
            SET _proration = 0;
            SET _glCodeId = 0;
            SET _templateId = 0;

            open c7;
            cursorloop:loop
                fetch c7 into _chargeSubtype,_tariffId,_proration,_glCodeId,_templateId;
                IF (done = 1) THEN
                SET p_status='SUCCESS';
                  
                    leave cursorloop;
                END IF;

                
                IF (_chargeSubtype = 'OTC') THEN
                    SET _endDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                ELSE
                    SET _endDate = NULL;
                    SET _startDate = (SELECT DATE_SUB(p_invoiceDate, INTERVAL 1 MONTH));
                END IF;
                update billing_charges set `record_status`='CLOSE' ,`event_type`=p_eventType ,`charge_period_end`=date(now()) where `charge_subtype`=_chargeSubtype and `tariff_id`=_tariffId and `proration`=_proration and `gl_code_id`=_glCodeId and imsi_id=p_imsiId;
                
            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;

END ;;
DELIMITER ;

--
DROP procedure IF EXISTS `VALIDATION_ENGINE_PROCEDURE`;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `VALIDATION_ENGINE_PROCEDURE`(IN p_imsi varchar(50),IN p_id int, IN p_accountId int, IN p_deviceId int ,IN p_simState varchar(30),OUT p_status_code int)
BEGIN

    DECLARE _accountExist INT(10) DEFAULT 0;
    DECLARE _deviceExist INT(10) DEFAULT 0;
    DECLARE _accountStatus INT(10) ;
    DECLARE _deviceStatus INT(10) ;
    DECLARE _remark varchar(500) DEFAULT 'default';
    DECLARE _status INT(10) DEFAULT 0;
    DECLARE _result varchar(30);


    SET _status=0;
    
    select count(*) into _accountExist from account where id=p_accountId;
    select count(*) into _deviceExist from device_plan where id =p_deviceId;

    IF(p_simState is null or p_simState='') THEN
	SET _status=-30;
	SET _remark=CONCAT('EMPTY STATE ACCOUNT:',p_accountId,' AND DEVICE ID:',p_deviceId,' NOT EXIST');
	SET _result='FAILED';    
    ELSEIF(_accountExist=0 and _deviceExist=0) THEN
        SET _status=-30;
        SET _remark=CONCAT('BOTH ACCOUNT:',p_accountId,' AND DEVICE ID:',p_deviceId,' NOT EXIST');
        SET _result='FAILED';
    ELSEIF (_accountExist =0 ) THEN
       
        SET _status=-10;
        SET _remark=CONCAT('ACCOUNT:',p_accountId,' NOT EXIST');
        SET _result='FAILED';
    ELSEIF ( _deviceExist =0 ) THEN
        SET _status=-20;
        SET _remark=CONCAT('DEVICE ID:',p_deviceId,' NOT EXIST');
        SET _result='FAILED';
    ELSE
        SET _status=30;
        
        
    END IF;
    SET p_status_code=_status;

    IF (_status<0) THEN 
        insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(p_imsi,_result,_remark,p_id);
    END IF;

END ;;
DELIMITER ;

-- 


 -- CHARGE_VALIDATION_ENGINE_PROCEDURE starts 
DROP procedure IF EXISTS `CHARGE_VALIDATION_ENGINE_PROCEDURE`;
 DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `CHARGE_VALIDATION_ENGINE_PROCEDURE`(IN p_id int, IN p_templateId int ,OUT p_status_code int)
BEGIN

    DECLARE _planExist INT(10) DEFAULT 0;
    DECLARE _deviceExist INT(10) DEFAULT 0;
    DECLARE _accountStatus INT(10) ;
    DECLARE _deviceStatus INT(10) ;
    DECLARE _remark varchar(500) DEFAULT 'default';
    DECLARE _status INT(10) DEFAULT 0;
    DECLARE _result varchar(30);


    SET _status=0;
    
    select count(*) into _planExist from migration_billing_charges where migration_billing_charges.plan_id=p_templateId;
    

    IF(_planExist=0) THEN
        SET _status=-30;
        SET _remark=CONCAT('STATUS CODE:',_status, ' ASSET:',p_id,' CHRGE NOT EXIST FOR PLAN:', p_templateId);
        SET _result='SUCCESS';
    ELSE
        SET _status=30;
        SET _remark=CONCAT('STATUS CODE',_status, ' ASSET: ',p_id,' CHARGE EXIST FOR PLAN:TEMPLATE:',p_templateId);
        SET _result='SUCCESS';
    END IF;
    SET p_status_code=_status;

END ;;
DELIMITER ;

DROP procedure IF EXISTS `FIND_AND_APPLY_STATIC_IP_CHARGES`;
DELIMITER ;;
CREATE DEFINER=`aqadmin`@`%` PROCEDURE `FIND_AND_APPLY_STATIC_IP_CHARGES`(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_devicePlanId int,IN p_action varchar(30),IN p_eventRef varchar(40),IN p_eventType varchar(50) ,IN p_chargeHandler int)
BEGIN
    declare _chargeSubtype varchar(30);
    declare _action varchar(30);
    declare done int default 0;
    declare _status_code int(10);
    declare p_status varchar(30);
    declare _count int default 0;
    
    declare _static_ip_charge int default 0;
    declare _url_barring_charge int default 0;
    declare _apnId  int default 0;
    declare _eventType varchar(50);
    declare _chargeHandler int(10);
    declare _apnType varchar(30);
    declare _serviceCategory varchar(20);
    declare _staticIpApplied boolean;
    declare _urlBarringApplied boolean;
    
    
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            
            declare c7 cursor for select apn_id as _apnId from apn_conf where device_id in (p_devicePlanId);

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
                       
            SET _eventType = null;
            SET _chargeHandler = 0;        
        
            open c7;
            cursorloop:loop
                fetch c7 into _apnId;
                IF (done = 1) THEN
                    SET p_status='SUCCESS';
                        leave cursorloop;
                END IF;             

      

                    -- check apn conf for static ip
                    SET _static_ip_charge=0;
                    IF (_static_ip_charge=0) THEN
                        select count(*) into _static_ip_charge from migration_service_apn_details where apn_id=_apnId and apn_type=1;
                    END IF;

                    SET _url_barring_charge=0;
                    IF (_url_barring_charge=0) THEN
                        select count(*) into _url_barring_charge from migration_service_apn_details where apn_id=_apnId and APN_NAME='m2mlight';
                    END IF;

                    select static_ip_applied into _staticIpApplied from migration_assets where imsi_id=p_imsiId;

                    IF (_static_ip_charge>0 and _staticIpApplied is false) THEN
                        SET _action = 'StaticIP';
                        SET _eventType ="StaticIP";
                        SET _chargeHandler=0;
                        call CHARGE_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_devicePlanId,_action, p_eventRef,_eventType,_chargeHandler);
                        update migration_assets set static_ip_applied=1 where imsi_id=p_imsiId;
                    END IF;

                    select url_barring_applied into _urlBarringApplied from migration_assets where imsi_id=p_imsiId;

                    IF (_url_barring_charge>0 and _urlBarringApplied is false) THEN
                        SET _action = 'UrlBarring';
                        SET _eventType ="UrlBarring";
                        SET _chargeHandler=0;
                        call CHARGE_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_deviceId,_action, p_eventRef,_eventType,_chargeHandler);
                        update migration_assets set url_barring_applied=1 where imsi_id=p_imsiId;
                    END IF;
                    
            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;
END ;;
DELIMITER ;
