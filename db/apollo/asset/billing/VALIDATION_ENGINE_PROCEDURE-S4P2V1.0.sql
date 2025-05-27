DROP procedure IF EXISTS `VALIDATION_ENGINE_PROCEDURE`;

DELIMITER //
CREATE PROCEDURE VALIDATION_ENGINE_PROCEDURE(IN p_imsi varchar(50),IN p_id int, IN p_accountId int, IN p_deviceId int ,IN p_simState varchar(30),OUT p_status_code int)
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
       -- SET _accountStatus=-10;
        SET _status=-10;
        SET _remark=CONCAT('ACCOUNT:',p_accountId,' NOT EXIST');
        SET _result='FAILED';
    ELSEIF ( _deviceExist =0 ) THEN
        SET _status=-20;
        SET _remark=CONCAT('DEVICE ID:',p_deviceId,' NOT EXIST');
        SET _result='FAILED';
    ELSE
        SET _status=30;
        -- SET _remark=CONCAT(BOTH ACCOUNT:',p_accountId,' AND DEVICE ID:',p_deviceId,' EXIST');
        -- SET _result='SUCCESS';
    END IF;
    SET p_status_code=_status;

    IF (_status<0) THEN 
        insert into migration_assets_validation (`imsi`,`status`,`remarks`,`assets_id`)  values(p_imsi,_result,_remark,p_id);
    END IF;

END //
DELIMITER ;