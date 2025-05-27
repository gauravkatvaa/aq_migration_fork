DROP procedure IF EXISTS `CHARGE_MIGRATION_PROCEDURE`;
DELIMITER //
CREATE PROCEDURE CHARGE_MIGRATION_PROCEDURE(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_deviceId int,IN p_action varchar(30),IN p_eventRef varchar(40))
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
    
        SET _planId = (SELECT template_id FROM migration_device_plan where migration_device_plan.device_plan_id=p_deviceId limit 1);
    -- call CHARGE_VALIDATION_ENGINE_PROCEDURE(p_imsiId,_planId ,@out_status_code);
    -- select @out_status_code into _status_code;
    SET _status_code=1;    

    IF(_status_code>0) THEN
        BEGIN
            declare c7 cursor for select a.charge_category as charge_subtype,a.charge_spec_id as tariff_id, a.parent_csid as parent_csid, a.is_proration as proration,
            a.gl_code_id as gl_code_id,a.plan_id as _templateId, a.discount_id as discount_id, a.discount_glcode_id as discount_glcode_id from migration_billing_charges as a join migration_device_plan as b on
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
                fetch c7 into _chargeSubtype,_tariffId,_parentCsid,_proration,_glCodeId,_templateId, _discountId, _discountGlcodeId;
                IF (done = 1) THEN
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

                IF (p_action = 'Suspension-CustInitiated') THEN
                    IF (_parentCsid is not NULL && _parentCsid != 0) THEN
                        SET _aggregationExcluderKey=p_imsiId;
                    END IF;
                END IF;
                IF (p_frequency='monthly') THEN
                    SET p_frequency='Monthly';
                END IF;
                    insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                    `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                    `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,`discount_start_date`,
                    `discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                    p_eventRef,_startDate,'SIM',_chargeSubtype,p_imsiId,_tariffId,p_deviceId,0,_startDate,_endDate,
                    'New','OPEN',_glCodeId,_startDate, _endDate,_glCodeId,_aggregationExcluderKey,NULL,NULL);
                
                IF (_discountId is not null) THEN 
                        call DISCOUNT_MIGRATION_PROCEDURE(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,p_imsiId,p_deviceId,p_action, p_eventRef, _chargeSubtype, _discountId,_discountGlcodeId, _tariffId);
                END IF;

            end loop cursorloop;
            close c7;
        END;
    ELSE
        SELECT CONCAT('FAILED TO PROCESS FOR ASSETS: ',p_imsiId);
        SET p_status='FAILED';
    END IF;

END //
DELIMITER ;
