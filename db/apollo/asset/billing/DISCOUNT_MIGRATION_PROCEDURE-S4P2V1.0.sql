DROP procedure IF EXISTS `DISCOUNT_MIGRATION_PROCEDURE`;
DELIMITER //
CREATE PROCEDURE DISCOUNT_MIGRATION_PROCEDURE(IN p_accountId int,IN p_invoiceDate date,IN p_renewalDate date,
IN p_frequency varchar(30),IN p_imsiId varchar(30),IN p_deviceId int,IN p_action varchar(30),IN p_eventRef varchar(40),
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
    


    --  SET _planId = (SELECT template_id FROM migration_device_plan where migration_device_plan.device_plan_id=p_deviceId limit 1);
    -- call CHARGE_VALIDATION_ENGINE_PROCEDURE(p_imsiId,_planId ,@out_status_code);
    -- select @out_status_code into _status_code;
    SET _status_code=1;    

    IF (_status_code>0) THEN
        BEGIN
            declare c7 cursor for select charge_spec_id , discount_type ,type,gl_code , price , start_date, end_date from device_plan_discount where device_plan_id=p_deviceId and charge_spec_id=p_tariffId;

            
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
                    --  select 'Finished';
                        leave cursorloop;
                END IF;             

                IF (_chargeSubtype = 'OTC') THEN
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
                        `discount_start_date`,`discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                        p_eventRef,_startDate,'DISCOUNT',_chargeSubtype,p_imsiId,_tariffId,p_deviceId,0,_startDate,_endDate,
                        'New','OPEN',_glCodeId,_discountId,_discountGlcodeId,_price,0.0,NULL,
                        _vasStartDate, _vasEndDate,_discountGlcodeId,'include',NULL,NULL);
                    ELSE
                        insert into billing_charges(`account_id`,`invoice_date`,`renewal_date`,`frequency`,
                        `event_ref`,`event_date`,`charge_type`,`charge_subtype`,`imsi_id`,`tariff_id`,`device_id`,`proration`,
                        `charge_period_start`,`charge_period_end`,`charge_status`,`record_status`,`gl_code_id`,
                        `discount_id`,`discount_charge_ref`,
                        `gl_code_ref`,`discount_override_percent`,`discount_override`,`discount_tier`,
                        `discount_start_date`,`discount_end_date`,`gl_code_ref`,`aggregation_excluder_key`,`account_plan_id`,`addon_plan_id`) values(p_accountId,p_invoiceDate,p_renewalDate,p_frequency,
                        p_eventRef,_startDate,'DISCOUNT',_chargeSubtype,p_imsiId,_tariffId,p_deviceId,0,_startDate,_endDate,
                        'New','OPEN',_glCodeId,_discountId,0.0,_price,NULL,
                        _vasStartDate, _vasEndDate,_discountGlcodeId,'include',NULL,NULL);
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
