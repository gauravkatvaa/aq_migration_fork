DROP procedure IF EXISTS `CHARGE_VALIDATION_ENGINE_PROCEDURE`;

DELIMITER //
CREATE PROCEDURE CHARGE_VALIDATION_ENGINE_PROCEDURE(IN p_id int, IN p_templateId int ,OUT p_status_code int)
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

END //
DELIMITER ;