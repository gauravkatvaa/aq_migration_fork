DROP procedure IF EXISTS `APN_CHARGE_MIGRATION_PROCEDURE`;
DELIMITER //
CREATE PROCEDURE APN_CHARGE_MIGRATION_PROCEDURE(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_accountPlanId int,IN p_action varchar(30),IN p_eventRef varchar(40))
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
    declare _apnId  int default 0;
    declare _apn  varchar(50) default 0;
    declare _deviceId  varchar(50) default 0;

    declare _apnType varchar(30);
       
  --  SELECT template_id, account_plan_id into _planId, _accountPlanId from account_plan where account_id=p_accountId;    
    
    -- call CHARGE_VALIDATION_ENGINE_PROCEDURE(p_imsiId,_planId ,@out_status_code);
    -- select @out_status_code into _status_code;
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            declare c7 cursor for select a.charge_category as charge_subtype,a.charge_spec_id as tariff_id,a.is_proration as proration,
            a.gl_code_id as gl_code_id,a.plan_id as _templateId, a.discount_id as discount_id, a.discount_glcode_id as discount_glcode_id, 
            a.apn_type as _apnType from migration_billing_charges as a join account_plan as b on
            a.plan_id=b.template_id and b.id=p_accountPlanId and a.action_type in (p_action) and a.charge_category='RC';

            declare apnCursor cursor for select apn_id, apn, apn_type, device_id from apn_conf where account_id=p_accountId and apn_type=_apnType;
            
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
            SET _chargeSubtype = 'RC';
            SET _tariffId = 0;
            SET _proration = 0;
            SET _glCodeId = 0;
            SET _templateId = 0;

        
            open c7;
            cursorloop:loop
                fetch c7 into _chargeSubtype,_tariffId,_proration,_glCodeId,_templateId, _discountId, _discountGlcodeId, _apnType;
                IF (done = 1) THEN
                set done=0;
                    SET p_status='SUCCESS';
                    --  select 'Finished';
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

                --
                open apnCursor;
	              apnloop:loop
                    Fetch apnCursor into _apnId, _apn, _apnType, _deviceId;
                        IF (done = 1) THEN
                        SET done=0;
                        SET p_status='SUCCESS';
                        --  select 'Finished';
                            leave apnloop;
                        END IF;             
                      IF((p_action='Private_APN_Assigned') and (_apnType='Private')) THEN
                            SET _alreadyApplied=0;
                            IF (_alreadyApplied=0) THEN
                                -- select charge_ref_ids into _apnChargeRefIds from from apn_conf where device_id=p_deviceId and account_id=p_accountId;
                                select count(*) into _alreadyApplied from apn_conf where account_id=p_accountId and charge_ref_ids like concat('%',_tariffId,'%') and apn_id=_apnId;
                            
                            -- select 'done';

                            END IF;

                            IF (_alreadyApplied=0) THEN
                                insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                                `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                                `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                                `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                                p_eventRef,_startDate,'ACCOUNT',_chargeSubtype,NULL,_tariffId,NULL,0,_startDate,_endDate,
                                'New','OPEN',_glCodeId,NULL, NULL,NULL,'include',p_accountPlanId,NULL);
                            
                                IF (_discountId is not null) THEN
                                
                                        call AP_DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_accountPlanId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId);    
                                END IF;
                                -- GO FOR UPDATE apn_conf, wrt tariff_id and 
                                update apn_conf set charge_ref_ids=json_set(charge_ref_ids, concat('$."',_tariffId,'"'),p_eventRef) where account_id=p_accountId and apn_id=_apnId and device_id=_deviceId;
                            -- select 'done1';
                            END IF;

                        ELSEIF((p_action='Public_APN_Assigned') and (_apnType='Public')) THEN 
                                SET _alreadyApplied=0;
                                IF (_alreadyApplied=0) THEN
                                    -- select charge_ref_ids into _apnChargeRefIds from from apn_conf where device_id=p_deviceId and account_id=p_accountId;
                                    select count(*) into _alreadyApplied from apn_conf where account_id=p_accountId and charge_ref_ids like concat('%',_tariffId,'%') and apn_id=_apnId;
                                
                                -- select 'done';

                                END IF;

                                IF (_alreadyApplied=0) THEN
                                    insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                                    `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                                    `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                                    `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                                    p_eventRef,_startDate,'ACCOUNT',_chargeSubtype,NULL,_tariffId,NULL,0,_startDate,_endDate,
                                    'New','OPEN',_glCodeId,NULL, NULL,NULL,'include',p_accountPlanId,NULL);
                                
                                    IF (_discountId is not null) THEN
                                    
                                            call AP_DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_accountPlanId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId);    
                                    END IF;
                                    -- GO FOR UPDATE apn_conf, wrt tariff_id and 
                                    update apn_conf set charge_ref_ids=json_set(charge_ref_ids, concat('$."',_tariffId,'"'),p_eventRef) where account_id=p_accountId and apn_id=_apnId and device_id=_deviceId;
                                -- select 'done1';
                                END IF;

                        ELSEIF((p_action='Public_APN_Assigned' and _apnType='Any')) THEN 
                                SET _alreadyApplied=0;
                                IF (_alreadyApplied=0) THEN
                                    -- select charge_ref_ids into _apnChargeRefIds from from apn_conf where device_id=p_deviceId and account_id=p_accountId;
                                    select count(*) into _alreadyApplied from apn_conf where account_id=p_accountId and charge_ref_ids like concat('%',_tariffId,'%') and apn_id=_apnId;
                                
                                -- select 'done';

                                END IF;

                                IF (_alreadyApplied=0) THEN
                                    insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                                    `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                                    `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                                    `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                                    p_eventRef,_startDate,'ACCOUNT',_chargeSubtype,NULL,_tariffId,NULL,0,_startDate,_endDate,
                                    'New','OPEN',_glCodeId,NULL, NULL,NULL,'include',p_accountPlanId,NULL);
                                
                                    IF (_discountId is not null) THEN
                                    
                                            call AP_DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_accountPlanId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId);    
                                    END IF;
                                    -- GO FOR UPDATE apn_conf, wrt tariff_id and 
                                    update apn_conf set charge_ref_ids=json_set(charge_ref_ids, concat('$."',_tariffId,'"'),p_eventRef) where account_id=p_accountId and apn_id=_apnId and device_id=_deviceId;
                                -- select 'done1';
                                END IF;

                      END IF;
	              end loop apnloop;                
                  close apnCursor;
            end loop cursorloop;
            
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;

END //
DELIMITER ;
