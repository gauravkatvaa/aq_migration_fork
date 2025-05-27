DELIMITER //
drop procedure if exists `update_tariffIds_by_ap` //
CREATE PROCEDURE `update_tariffIds_by_ap`(IN p_accountPlanId int(10)) 
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
    END //
DELIMITER ;
