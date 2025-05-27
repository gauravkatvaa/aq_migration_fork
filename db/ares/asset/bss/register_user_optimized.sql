-- --------------------------------------------------------
-- Host:                         192.168.1.122
-- Server version:               8.0.32 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             12.5.0.6677
-- Author						 Sabin Sunny
-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS `register_user_optimized`;
DELIMITER //
CREATE PROCEDURE `register_user_optimized`(
    IN imsiParam varchar(30),
    IN msisdnParam varchar(30),
    IN iccIdParam varchar(50),
    IN accountIdParam BIGINT,
    IN devicePlanIdParam BIGINT,
    IN servicePlanIdParam BIGINT,
    IN userStatusParam VARCHAR(20),
    IN proration BOOLEAN,
    IN clientType INT,
    OUT successCount INT
)
BEGIN

	DECLARE planCount INT;
    DECLARE accountCount INT;
    DECLARE serviceCount INT;
    
       -- Default values
    DECLARE imsi varchar(30) DEFAULT imsiParam;
    DECLARE msisdn varchar(30) DEFAULT msisdnParam;
    DECLARE iccid varchar(50) DEFAULT iccIdParam;
    DECLARE accountId BIGINT DEFAULT accountIdParam;
	DECLARE devicePlanId BIGINT DEFAULT devicePlanIdParam;
    DECLARE servicePlanId BIGINT DEFAULT servicePlanIdParam;
	DECLARE userStatus VARCHAR(20) DEFAULT userStatusParam;
	DECLARE prorationEnabled BOOLEAN DEFAULT proration;
    DECLARE clientTypeValue BOOLEAN DEFAULT clientType;
    
      -- Declare variables for cursor
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur_id INT;
    DECLARE cur_account_id INT;
    DECLARE cur_device_plan_id INT;
    DECLARE cur_client VARCHAR(255);
    DECLARE cur_volume BIGINT;
    DECLARE cur_volume_unit VARCHAR(255);
    DECLARE cur_product_type VARCHAR(255);
    DECLARE cur_entitlement_name VARCHAR(255);
    DECLARE cur_service_type VARCHAR(255);
    DECLARE cur_zone_group_id INT;
    DECLARE cur_zone_id INT;

    -- Declare cursor
    DECLARE entittlements CURSOR FOR
        SELECT
            ID, ACCOUNT_ID, DEVICE_PLAN_ID, CLIENT, VOLUME, VOLUME_UNIT,
            PRODUCT_TYPE, ENTITLEMENT_NAME, SERVICE_TYPE, ZONE_GROUP_ID, ZONE_ID
        FROM tdevice_plan_quota where DEVICE_PLAN_ID = devicePlanIdParam and ACCOUNT_ID=accountIdParam and pool_bundle is false;

    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET @user_purchase_id =1;
    SET @transaction_id = 1;
	SET @data_bucket_id = 1;
	SET @type_entry_id=1;
	SET @rating_group_id = 171;
    SET @data_id=101;
    SET @volume=15728640;
	SET @dp_active=0;
    SET @free_account=1;
    SET @rollingConceptionOrder=0;
    SET @zoneGroupId=0;
    SET @zone_id=0;
    SET @dataValue=0;
    SET @plan_type='SimPlan';
    SET @proration=0;
	SET @smsValue=0;
    SET @sms_id=0;
    SET @validity_Term='monthly';
    SET @next_renewal='2024-03-27 23:59:59';
    SET @proration_enabled=prorationEnabled;
	SET successCount = 0;
	SET @billingDate = 28;
	SET @day_of_current_month =  (SELECT DAY(NOW()) AS day_of_current);
	SET @length_of_month = (SELECT DAY(LAST_DAY(NOW())) AS length_of_current_month);
	SET @no_of_days=0;
    
    register_user_block: BEGIN
    
	IF (LOWER(userStatus) !='activated' and LOWER(userStatus) !='suspended' and LOWER(userStatus) !='warm' and LOWER(userStatus) !='testready') THEN
    update migration_asset asset set asset.status=b'0',asset.failure_reason='Invalid user status' where asset.imsi=imsi;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid user status',
            MYSQL_ERRNO = 20001;
             LEAVE register_user_block;
    END IF; 
    -- Inventory upload start
      -- Insert the new values into the tsim_card table
        INSERT INTO tsim_card ( IMSI, MSISDN, ICCID, RETAILER_ID, CLIENT_TYPE, USER_TYPE, PROVIDER_ID, REDIRECTION_CONFIG_ID, CONFIRMED, SIM_CARD_POOL_ID, ALLOCATED_CUSTOMER, BATCH_NAME, MANUFACTURER, SIM_TYPE, SIM_TYPE_INFO)
        VALUES (imsi, msisdn, iccid, NULL, clientTypeValue, 4, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL);
-- Inventory upload end
	IF LOWER(userStatus) = 'warm' OR LOWER(userStatus) = 'testready' THEN
	SET successCount = 1;
    UPDATE migration_asset AS asset
    SET asset.status = b'1',asset.failure_reason='SUCCESS'
    WHERE asset.imsi = imsi;
	END IF;

IF LOWER(userStatus) != 'warm' AND LOWER(userStatus) != 'testready' THEN

	SELECT COUNT(1) INTO accountCount FROM tenterprise_account WHERE account_id = accountIdParam;
    SELECT COUNT(1) INTO planCount FROM tdevice_plan WHERE planId = devicePlanIdParam and accountId=accountIdParam;
    SELECT COUNT(1) INTO serviceCount from tservice_plan where SERVICE_PLAN_ID =servicePlanIdParam and account_id=accountIdParam;
    
     IF accountCount = 0 THEN
		update migration_asset asset set asset.status=b'0',asset.failure_reason='No Account found for the given input' where asset.imsi=imsi;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No Account found for the given input',
            MYSQL_ERRNO = 20001;
            LEAVE register_user_block;
     END IF;   
	
     IF planCount=0 THEN
     update migration_asset asset set asset.status=b'0',asset.failure_reason='No Device Plan found for the given input' where asset.imsi=imsi;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No Device Plan found for the given input',
            MYSQL_ERRNO = 20001;
             LEAVE register_user_block;
	END IF;
	IF serviceCount=0 THEN
    update migration_asset asset set asset.status=b'0',asset.failure_reason='No Service Plan found for the given input' where asset.imsi=imsi;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No Service Plan found for the given input',
            MYSQL_ERRNO = 20001;
             LEAVE register_user_block;
    END IF; 

	SELECT CASE
        WHEN dataUnit = 'MB' THEN ROUND(datavalue, 0) * 1024 * 1024
        WHEN dataUnit = 'KB' THEN ROUND(datavalue, 0) * 1024
        WHEN dataUnit = 'GB' THEN ROUND(datavalue, 0) * 1024 * 1024 * 1024
        ELSE datavalue
    END AS  dataValue, plantype AS plan_type, client ,data_id,active, zone_group_id AS zoneGroupId,PRORATION as proration,sms,sms_id,validityTerm
	INTO @dataValue, @plan_type , clientTypeValue,@data_id,@dp_active, @zoneGroupId,@proration,@smsValue,@sms_id,@validity_Term
	FROM tdevice_plan
	WHERE planId = devicePlanId;
   
   -- Billing date calculation logic start
    
    SET @currentAccountId = accountId;

	-- Start the recursive query
	WITH RECURSIVE ParentAccounts AS (
  SELECT account_id, billing_date, parent_account_id
  FROM tenterprise_account
  WHERE account_id = @currentAccountId
  
  UNION ALL
  
  SELECT ea.account_id, ea.billing_date, ea.parent_account_id
  FROM tenterprise_account ea
  JOIN ParentAccounts pa ON ea.account_id = pa.parent_account_id
  WHERE pa.parent_account_id IS NOT NULL 
    AND pa.parent_account_id != 0
    AND (pa.billing_date IS NULL OR pa.billing_date = '0')
)
SELECT billing_date as account_bill_date into @billingDate
FROM ParentAccounts
WHERE billing_date IS NOT NULL AND billing_date != '0'
LIMIT 1;
    -- Billing date calculation logic end
    
    -- expiry date logic start
   IF @day_of_current_month >= @billingDate THEN
    SET @no_of_days = (
        SELECT (@length_of_month - @day_of_current_month + @billingDate) AS result
    );
ELSE
    SET @no_of_days = (
        SELECT (@billingDate - @day_of_current_month) AS result
    );
    SET @length_of_month = (
        SELECT DAY(LAST_DAY(NOW() - INTERVAL 1 MONTH)) AS length_of_previous_month
    );
END IF;
    
    if LOWER(@validity_Term) = 'monthly' then
		SET @next_renewal=(select CONCAT(DATE_FORMAT(DATE_ADD(NOW(), INTERVAL (@no_of_days-1)  DAY),'%Y-%m-%d'), ' 23:59:59') AS new_date_and_time);
    else
		SET @next_renewal=(select CONCAT(DATE_FORMAT(DATE_ADD(NOW(), INTERVAL (select days-1 from tvalidity_term where EXTERNALCODE=LOWER(@validity_Term)) DAY),'%Y-%m-%d'), ' 23:59:59') AS new_date_and_time);
	end if;
    
    -- expiry date logic end
    SET @volume=@dataValue;

    select id INTO @free_account from taccount where client_type=clientTypeValue limit 1;
        -- Generate LASTNAME and EMAIL values using CONCAT
        SET @lastname = CONCAT('', imsi);
        SET @email = CONCAT(imsi, '@globetouch.com');
-- User Registration start
        -- Insert data into tuser table
		SET @simStatus=3;
		 IF LOWER(userStatus) ='suspended' THEN
			SET @simStatus=6;
		END IF;
		 CALL get_next_id_proc('tuser', @user_id);
        INSERT INTO tuser (ID,
            FIRSTNAME, LASTNAME, PASSWORD,
            EMAIL, EMAIL_VERIFIED, ADDRESS, STREETNO,
            CITY, ZIP, STATE, COUNTRY, GENDER,
            BIRTHDAY, PERSONALID, VERIFIED,
            MARKETING, CURRENT_TOKEN, EXPIRED_TOKEN,
            EXPIRATION, STOPPED, REGISTERED,
            ACCOUNT_ID, PAYMENT_RETRY_COUNT,
            PAYMENT_REFUSE_DATE, TIME_ZONE,
            PAYMENT_REFUSED, SERVER_GROUP,
            REJECTION_NOTE_CONFIRMED, REJECTION_NOTE,
            SIM_SWAP, VERIFICATION_EMAIL_SEND_COUNT,
            VERIFICATION_EMAIL_SEND_DATE, MACHINE,
            NOTIFICATION_UUID, COUNTRY_ISO_CODE,
            TEMP_PASSWORD, CONTACT_MSISDN,
            ACTIVE_SESSION, UPDATED, USER_TYPE,
            CURRENCY, CLIENT_TYPE, NON_LOADABLE,
            REGISTRATION_COUNTRY_ISO_CODE,
            CONSUMED_USER_PURCHASE_ACTIVATION_ENABLED,
            UPDATE_USER_DATA, USER_IDENTIFIER,
            LANGUAGE, CONTINUOS_DATA_CONSUMPTION_ENABLED
        ) VALUES (
            @user_id,'', @lastname, 'd24b29eeedde2f7fb73724270f0d2396',
            @email, 0, '', '',
            '', '', '', '',0,
            NULL, '',3, 0,
            NULL,NULL, NULL,
 	    0,NOW(),
	    @free_account,0,
            NOW(),NULL, 0,
            'HP',0,NULL,
            0, 0,
            NOW(),1,
            NULL, NULL,
             0,NULL,0,NOW(),4,NULL,
            clientTypeValue,0,NULL, 0, 0,'defaults589ddc5486d24083a641cd5a7437af6c',
            NULL, 0
        );
		-- Retrieve the last inserted ID
		--  SET @user_id=(SELECT MAX(id) FROM tuser);
          
             -- Generate a hash for the PASSWORD field
        SET @hashedPassword = SHA1(CONCAT('d24b29eeedde2f7fb73724270f0d2396', @user_id));

		  -- Insert data into tuser_sim_card table
        INSERT INTO tuser_sim_card (
            USER_ID, IMSI, MSISDN, IMEI, ICCID, DEVICE, SIM,
            NETWORK, VISITNETWORK, CURRENT_NETWORK, OCS_NOTIFIED,
            SIM_SWAP, CURRENT_NETWORK_MCC_MNC, DEVICE_TOKEN,
            ACTIVE_NETWORK_MCC_MNC, NETWORK_MCC_MNC, CDR_UPDATE_TIME,
            UPDATED, CLIENT_TYPE, USER_TYPE, OCS_DESTINATION_SITE,
            ACTIVE_ALIAS_ID, RATING_GROUP_ID, NON_LOADABLE,
            EXTERNAL_RETAILER_ENABLED, EXTERNAL_RETAILER_ID,
            REDIRECTION_CONFIG_ID, OCS_DATA_SESSION_UPDATE_TIME,
            EXTERNAL_PROVIDER_ID, INITIAL_OCS_DATA_SESSION_TIMESTAMP,
            DATA_RESOLUTION_TYPE, DATA_INDEX, ACCOUNT_ID,
            DEVICE_PLAN_ID, SERVICE_PLAN_ID, DEVICE_PLAN_ACTIVATED,
            STATUS_UPDATE_TIME, NEXT_RENEWAL_DATE,SIM_STATE
        ) VALUES (
            @user_id, imsi, msisdn, NULL, iccid, NULL,
            @simStatus=3, 'GBRHU', NULL, 'GBRHU', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, clientTypeValue,
            4, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, accountId,devicePlanId, servicePlanId, false, now(), @next_renewal,1
        );


		SET @unique_uuid := REPLACE(UUID(), '-', '');

        -- Set other constant values
        SET @notification_email_override := 0;
        SET @updated := NOW();
        SET @user_type := 4;
        SET @non_loadable := 0;
        SET @default_push_notification_delivery_type := 3;

        INSERT INTO tuser_data_notification (USER_ID, NO_DATA_NOTIF, LOW_DATA_NOTIF, NOTIFICATION_UUID, NOTIFICATION_EMAIL,
            NOTIFICATION_EMAIL_OVERRIDE, LOW_DATA_NOTIFICATION_ENABLED, NO_DATA_NOTIFICATION_ENABLED,
            UPDATED, CLIENT_TYPE, USER_TYPE, NON_LOADABLE, EXTERNAL_RETAILER_ENABLED,
            EXTERNAL_RETAILER_ID, DEFAULT_PUSH_NOTIFICATION_DELIVERY_TYPE
        ) VALUES ( @user_id, 0, 0, @unique_uuid, '', 0,
            1,1, @updated, clientTypeValue, @user_type,
            @non_loadable, 0,0, @default_push_notification_delivery_type
        );
        
		INSERT INTO tuser_ocs_data (`USER_ID`, `IMSI`, `MSISDN`, `ALLOCATED_DATA_BUCKET_ID`, `ALLOCATED_DATA_BUCKET_UUID`, `UPDATED`, `NON_LOADABLE`) VALUES
            (@user_id,imsi,msisdn,NULL, NULL, now(), 0);


-- User Registration END

-- User purchase start

    -- Open the cursor
    OPEN entittlements;

    -- Start iterating through the records
    read_loop: LOOP
        -- Fetch data into variables
        FETCH entittlements INTO
            cur_id, cur_account_id, cur_device_plan_id, cur_client, cur_volume, cur_volume_unit,
            cur_product_type, cur_entitlement_name, cur_service_type, cur_zone_group_id, cur_zone_id;

        -- Check if there are no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Process the fetched data 
            SET @data_bucket_volume=cur_volume;
             if (@proration =1 and LOWER(@validity_Term)='monthly' and @proration_enabled = 1 and @length_of_month > @no_of_days) then
              SET @data_bucket_volume= ( SELECT ROUND(@data_bucket_volume * @no_of_days/@length_of_month ) AS result);
             end if;
          
           CALL get_next_id_proc('ttransactionlog', @transaction_id);
           CALL get_next_id_proc('tdata_bucket', @data_bucket_id);
           CALL get_next_id_proc('tuser_purchase', @user_purchase_id);
			SET @user_purchase_type=12;
            SET @databucket_type=9;
            SET @databucket_data_type=5;
		    if cur_product_type ='SMS' then
				SET @user_purchase_type=15;
				SET @databucket_type=10;
				SET @databucket_data_type=7;
			end if;
			if cur_product_type ='VOICE' then
				SET @user_purchase_type=16;
				SET @databucket_type=11;
				SET @databucket_data_type=8;
			end if;
            
		  INSERT INTO ttransactionlog (ID,`USER_ID`, `DT`, `AMOUNT`, `EXTERNAL_ID`, `CARD`, `VOLUME`, `START_VOLUME`, `TYPE`, `DESCRIPTION`, `CORPORATE_USER_ID`, `CORPORATE_USER_PURCHASE_ID`, `PAID`, `PURCHASE_TITLE`, `COUNTRY_ISO_CODES`, `NETWORKS`, `USER_PAYMENT_UID`, `PSP_REFERENCE`, `PURCHASE_EXPIRATION_DATE`, `USER_PURCHASE_ID`, `CURRENCY_TYPE`, `USER_CURRENCY`, `THROTTLING_VOLUME`, `CUSTOM_VOLUME`, `CUSTOM_EXPIRATION_DATE`, `FREE_DATA`, `FIRST_PURCHASE`, `NETWORK_MCC_MNC`, `CUSTOM_THROTTLING_VOLUME`, `VAT`, `BASE_PRICE`, `VOLUME_UNIT`, `VALIDITY_TERM`, `VALIDITY_TERM_UNIT`, `ADMIN_DATA`, `TRANSACTION_UUID`, `EXTERNAL_RETAILER_ID`, `RATING_GROUP_ID`, `VALIDITY_START_DATE`, `USER_PURCHASE_TYPE`, `EXTERNAL_PURCHASE`, `PURCHASE_REMOVAL_DATE`, `REFUND_AMOUNT`, `CLIENT_TYPE`, `TYPE_ENTRY_ID`, `EXTERNAL_PROVIDER_ID`, `ENTERPRISE_ID`, `REFUND_TYPE`, `ACTIVATION_DATE`, `CONSUMPTION_START_DATE`, `CONSUMPTION_END_DATE`, `CONSUMED_VOLUME`, `CONSUMED_THROTTLING_VOLUME`)
          VALUES (@transaction_id,@user_id, now(), 0.000, @unique_uuid, NULL, @data_bucket_volume, @data_bucket_volume, 0, cur_entitlement_name, 0, 0, 0, cur_entitlement_name, 'SA', '42004;42001;42005;42006;42003;42007', 'client_1_type', NULL, NULL,  @user_purchase_id, 16, NULL, 0, NULL, NULL, 0, 0, NULL, NULL, 0.000, 0.000, 1, 30, 2, 0, @unique_uuid, NULL, NULL, NULL, 12, 1, NULL, NULL, clientTypeValue, 7, NULL, 43, NULL, NULL, NULL, NULL, NULL, NULL);
			

            INSERT INTO tdata_bucket (
                ID,USER_ID, TYPE_ENTRY_ID, VOLUME, START_VOLUME, EXPIRATION_DATE,
                NETWORK_GROUP_ID, DATA_BUCKET_TYPE, ACTIVE, TRANSACTION_ID, PRIORITY,
                RATING_GROUP_DEFINED, DATA_BUCKET_DATA_TYPE, USER_PURCHASE_ID, CAPPED,
                USER_PURCHASE_TYPE, VALIDITY_START_DATE, CONSUMPTION_ORDER, CLIENT_TYPE,
                UUID, EXPIRED, NBIOT, zone_group_id, zone_id, DEVICE_PLAN,SERVICE_TYPE
            ) VALUES (
			    @data_bucket_id,
                @user_id,
                cur_id,
                @data_bucket_volume,@data_bucket_volume,
                @next_renewal,
                1, @databucket_type, 1, @transaction_id, 2,
                0,
                1, @user_purchase_id, 0,
                 @user_purchase_type,
                now(), 0, clientTypeValue,
                CONCAT('defaults', MD5(RAND())), 0,
                0,
                cur_zone_group_id, cur_zone_id, true,cur_service_type
            );
           INSERT INTO tuser_purchase (
                ID,USER_ID, TYPE_ENTRY_ID, USER_PURCHASE_TYPE, EXPIRATION_DATE, RECURRING,
                PAYMENT_RETRY_COUNT, PAYMENT_REFUSE_DATE, TYPE, VOLUME, DATA_BUCKET_ID,
                PURCHASE_BUNDLE_ID, PURCHASE_BUNDLE_TYPE, MASTER_BUNDLE_ID, ACTIVE,
                TRANSACTION_ID, ENTERPRISE_ID, CREATED, ACTIVATION_DATE,
                PRIMARY_USER_PURCHASE_ID, RECURRING_COUNTER, SELECTED_NETWORK_GROUP_ID,
                THROTTLING_DATA_BUCKET_ID, RESET_VALIDITY_TERM_ENABLED, RESET_DATE,
                CAPPED, EXPIRED_NOTIF, ACTIVATION_NOTIF, SUSPENDED,
                ACTIVATION_EXPIRATION_DATE, ACTIVATION_NOTIFICATION_DATE,
                ROAMING_PARTNER_REMOVAL_NOTIF, VALIDITY_START_DATE, CONSUMPTION_ORDER,
                CONSUMPTION_NOTIF, ALLOWANCE_VOLUME, ALLOWANCE_TERM, ALLOWANCE_TERM_UNIT,
                NETWORK_GROUP_ID, UUID, CLIENT_TYPE, NETWORK_CHANGE_ACTIVATION_ENABLED,
                CAP_ID, ENTERPRISE_PURCHASE_ID, DATA_CAP_TYPE, DEVICE_PLAN
            ) VALUES (
                @user_purchase_id,
				@user_id,
                cur_id,
                @user_purchase_type,
                @next_renewal, 0, 0, NULL,
                @databucket_data_type,
                NULL, @data_bucket_id,
                NULL, NULL, NULL, 1,
                @transaction_id,
                NULL, now(), now(),
                NULL, 0, NULL, NULL, 0, NULL,
                0, 0, 0, 0, now(),
                NULL, 0, now(), 0, 0,
                NULL, NULL, NULL, NULL, "c997539113cb4e34b5d864ad5a61f51a", clientTypeValue, 0,
                0, NULL, NULL, true
            );

    END LOOP;
    -- Close the cursor
    CLOSE entittlements;
			SET @volume=@dataValue;
             if (@proration =1 and LOWER(@validity_Term)='monthly' and @proration_enabled =1 and @length_of_month > @no_of_days) then
              SET @volume= (SELECT ROUND(@volume * @no_of_days/@length_of_month ) AS result);
             end if;
			if @plan_type ='RollingPoolPlan' then
				select max(CONSUMPTION_ORDER)  INTO @rollingConceptionOrder from tpool_data_bucket where DATA_BUCKET_TYPE=9 and TYPE_ENTRY_ID=@data_id;
				SET @rollingConceptionOrder=@rollingConceptionOrder+1;
				 CALL get_next_id_proc('tuser_purchase', @user_purchase_id);
				INSERT INTO `tuser_purchase` (`ID`,`USER_ID`, `TYPE_ENTRY_ID`, `USER_PURCHASE_TYPE`, `EXPIRATION_DATE`, `RECURRING`, `PAYMENT_RETRY_COUNT`, `PAYMENT_REFUSE_DATE`, `TYPE`, `VOLUME`, `DATA_BUCKET_ID`, `PURCHASE_BUNDLE_ID`, `PURCHASE_BUNDLE_TYPE`, `MASTER_BUNDLE_ID`, `ACTIVE`, `TRANSACTION_ID`, `ENTERPRISE_ID`, `CREATED`, `ACTIVATION_DATE`, `PRIMARY_USER_PURCHASE_ID`, `RECURRING_COUNTER`, `SELECTED_NETWORK_GROUP_ID`, `THROTTLING_DATA_BUCKET_ID`, `RESET_VALIDITY_TERM_ENABLED`, `RESET_DATE`, `CAPPED`, `EXPIRED_NOTIF`, `ACTIVATION_NOTIF`, `SUSPENDED`, `ACTIVATION_EXPIRATION_DATE`, `ACTIVATION_NOTIFICATION_DATE`, `ROAMING_PARTNER_REMOVAL_NOTIF`, `VALIDITY_START_DATE`, `CONSUMPTION_ORDER`, `CONSUMPTION_NOTIF`, `ALLOWANCE_VOLUME`, `ALLOWANCE_TERM`, `ALLOWANCE_TERM_UNIT`, `NETWORK_GROUP_ID`, `UUID`, `CLIENT_TYPE`, `NETWORK_CHANGE_ACTIVATION_ENABLED`, `CAP_ID`, `ENTERPRISE_PURCHASE_ID`, `DATA_CAP_TYPE`, `DEVICE_PLAN`)  SELECT @user_purchase_id,@user_id,@data_id , 13, @next_renewal, 0, 0, NULL, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, now(), now(), NULL, 0, NULL, NULL, 0, NULL, 0, 0, 0, 0,  now(), NULL, 0,  now(), 0, 0, NULL, NULL, NULL, NULL, @unique_uuid, clientTypeValue, 0, tsim_card_pool_data_cap.id, NULL, NULL, 1 FROM tdevice_plan inner JOIN tsim_card_pool_data_cap ON tsim_card_pool_data_cap.SIM_CARD_POOL_ID=data_id where planId=devicePlanId;
				INSERT INTO tpool_data_bucket (ACTIVE, CAPPED, CLIENT_TYPE, CONSUMPTION_ORDER, EXPIRATION_DATE, START_VOLUME, DATA_BUCKET_TYPE, TYPE_ENTRY_ID, USER_ID, UUID, VALIDITY_START_DATE, VOLUME) VALUES (1, 1, clientTypeValue, @rollingConceptionOrder, @next_renewal, @volume, 9, @data_id, @user_id, CONCAT('defaults', MD5(RAND())), now(), @volume);
				
				 START TRANSACTION;
					SELECT id into @lock_variable FROM tsim_card_pool_data_cap WHERE SIM_CARD_POOL_ID = @data_id FOR UPDATE;
					update tsim_card_pool_data_cap  set AVL_VOLUME=AVL_VOLUME+@volume, CAP=CAP+@volume ,volume=volume+@volume ,EXPIRATION_DATE=@next_renewal  where SIM_CARD_POOL_ID = @data_id ;
				COMMIT;
				
				
				if  @smsValue !=null AND @smsValue !=0 and @sms_id!=null and @sms_id !=0 then
					SET @volume=@smsValue;
					if (@proration =1 and LOWER(@validity_Term)='monthly' and @proration_enabled = 1 and @length_of_month > @no_of_days) then
					SET @volume= ( SELECT ROUND(@volume * @no_of_days/ @length_of_month) AS result);
					end if;
                    select max(CONSUMPTION_ORDER)  INTO @rollingConceptionOrder from tpool_data_bucket where DATA_BUCKET_TYPE=10 and TYPE_ENTRY_ID=@sms_id;
					SET @rollingConceptionOrder=@rollingConceptionOrder+1;
					 CALL get_next_id_proc('tuser_purchase', @user_purchase_id);
					INSERT INTO `tuser_purchase` (`ID`,`USER_ID`, `TYPE_ENTRY_ID`, `USER_PURCHASE_TYPE`, `EXPIRATION_DATE`, `RECURRING`, `PAYMENT_RETRY_COUNT`, `PAYMENT_REFUSE_DATE`, `TYPE`, `VOLUME`, `DATA_BUCKET_ID`, `PURCHASE_BUNDLE_ID`, `PURCHASE_BUNDLE_TYPE`, `MASTER_BUNDLE_ID`, `ACTIVE`, `TRANSACTION_ID`, `ENTERPRISE_ID`, `CREATED`, `ACTIVATION_DATE`, `PRIMARY_USER_PURCHASE_ID`, `RECURRING_COUNTER`, `SELECTED_NETWORK_GROUP_ID`, `THROTTLING_DATA_BUCKET_ID`, `RESET_VALIDITY_TERM_ENABLED`, `RESET_DATE`, `CAPPED`, `EXPIRED_NOTIF`, `ACTIVATION_NOTIF`, `SUSPENDED`, `ACTIVATION_EXPIRATION_DATE`, `ACTIVATION_NOTIFICATION_DATE`, `ROAMING_PARTNER_REMOVAL_NOTIF`, `VALIDITY_START_DATE`, `CONSUMPTION_ORDER`, `CONSUMPTION_NOTIF`, `ALLOWANCE_VOLUME`, `ALLOWANCE_TERM`, `ALLOWANCE_TERM_UNIT`, `NETWORK_GROUP_ID`, `UUID`, `CLIENT_TYPE`, `NETWORK_CHANGE_ACTIVATION_ENABLED`, `CAP_ID`, `ENTERPRISE_PURCHASE_ID`, `DATA_CAP_TYPE`, `DEVICE_PLAN`)  SELECT @user_purchase_id,@user_id,@data_id , 13, @next_renewal, 0, 0, NULL, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, now(), now(), NULL, 0, NULL, NULL, 0, NULL, 0, 0, 0, 0,  now(), NULL, 0,  now(), 0, 0, NULL, NULL, NULL, NULL, @unique_uuid, clientTypeValue, 0, tsim_card_pool_data_cap.id, NULL, NULL, 1 FROM tdevice_plan inner JOIN tsim_card_pool_data_cap ON tsim_card_pool_data_cap.SIM_CARD_POOL_ID=sms_id where planId=devicePlanId;
					INSERT INTO tpool_data_bucket (ACTIVE, CAPPED, CLIENT_TYPE, CONSUMPTION_ORDER, EXPIRATION_DATE, START_VOLUME, DATA_BUCKET_TYPE, TYPE_ENTRY_ID, USER_ID, UUID, VALIDITY_START_DATE, VOLUME) VALUES (1, 1, clientTypeValue, @rollingConceptionOrder, @next_renewal, @volume, 10, @sms_id, @user_id, CONCAT('defaults', MD5(RAND())), now(), @volume);
					START TRANSACTION;
						SELECT id into @lock_variable FROM tsim_card_pool_data_cap WHERE SIM_CARD_POOL_ID = @sms_id FOR UPDATE;
						update tsim_card_pool_data_cap  set AVL_VOLUME=AVL_VOLUME+@volume, CAP=CAP+@volume ,volume=volume+@volume ,EXPIRATION_DATE=@next_renewal  where SIM_CARD_POOL_ID = @sms_id ;
					COMMIT;
					
					END if;
            END if;
            
            if @plan_type ='PoolPlan' then
				CALL get_next_id_proc('tuser_purchase', @user_purchase_id);
				INSERT INTO `tuser_purchase` (`ID`,`USER_ID`, `TYPE_ENTRY_ID`, `USER_PURCHASE_TYPE`, `EXPIRATION_DATE`, `RECURRING`, `PAYMENT_RETRY_COUNT`, `PAYMENT_REFUSE_DATE`, `TYPE`, `VOLUME`, `DATA_BUCKET_ID`, `PURCHASE_BUNDLE_ID`, `PURCHASE_BUNDLE_TYPE`, `MASTER_BUNDLE_ID`, `ACTIVE`, `TRANSACTION_ID`, `ENTERPRISE_ID`, `CREATED`, `ACTIVATION_DATE`, `PRIMARY_USER_PURCHASE_ID`, `RECURRING_COUNTER`, `SELECTED_NETWORK_GROUP_ID`, `THROTTLING_DATA_BUCKET_ID`, `RESET_VALIDITY_TERM_ENABLED`, `RESET_DATE`, `CAPPED`, `EXPIRED_NOTIF`, `ACTIVATION_NOTIF`, `SUSPENDED`, `ACTIVATION_EXPIRATION_DATE`, `ACTIVATION_NOTIFICATION_DATE`, `ROAMING_PARTNER_REMOVAL_NOTIF`, `VALIDITY_START_DATE`, `CONSUMPTION_ORDER`, `CONSUMPTION_NOTIF`, `ALLOWANCE_VOLUME`, `ALLOWANCE_TERM`, `ALLOWANCE_TERM_UNIT`, `NETWORK_GROUP_ID`, `UUID`, `CLIENT_TYPE`, `NETWORK_CHANGE_ACTIVATION_ENABLED`, `CAP_ID`, `ENTERPRISE_PURCHASE_ID`, `DATA_CAP_TYPE`, `DEVICE_PLAN`)  SELECT @user_purchase_id,@user_id,tdevice_plan.data_id , 13, @next_renewal, 0, 0, NULL, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL,  now(),  now(), NULL, 0, NULL, NULL, 0, NULL, 0, 0, 0, 0,  now(), NULL, 0,  now(), 0, 0, NULL, NULL, NULL, NULL, @unique_uuid, clientTypeValue, 0, tsim_card_pool_data_cap.id, NULL, NULL, 1 FROM tdevice_plan inner JOIN tsim_card_pool_data_cap ON tsim_card_pool_data_cap.SIM_CARD_POOL_ID=data_id where planId=devicePlanId;
				START TRANSACTION;
					SELECT id into @lock_variable FROM tsim_card_pool_data_cap WHERE SIM_CARD_POOL_ID = @data_id FOR UPDATE;
					update tsim_card_pool_data_cap  set AVL_VOLUME=AVL_VOLUME+@volume, CAP=CAP+@volume ,volume=volume+@volume ,EXPIRATION_DATE=@next_renewal  where SIM_CARD_POOL_ID = @data_id ;
				COMMIT;
				end if;

            if @plan_type ='SharedPlan' then
			 CALL get_next_id_proc('tuser_purchase', @user_purchase_id);
				INSERT INTO `tuser_purchase` (`ID`,`USER_ID`, `TYPE_ENTRY_ID`, `USER_PURCHASE_TYPE`, `EXPIRATION_DATE`, `RECURRING`, `PAYMENT_RETRY_COUNT`, `PAYMENT_REFUSE_DATE`, `TYPE`, `VOLUME`, `DATA_BUCKET_ID`, `PURCHASE_BUNDLE_ID`, `PURCHASE_BUNDLE_TYPE`, `MASTER_BUNDLE_ID`, `ACTIVE`, `TRANSACTION_ID`, `ENTERPRISE_ID`, `CREATED`, `ACTIVATION_DATE`, `PRIMARY_USER_PURCHASE_ID`, `RECURRING_COUNTER`, `SELECTED_NETWORK_GROUP_ID`, `THROTTLING_DATA_BUCKET_ID`, `RESET_VALIDITY_TERM_ENABLED`, `RESET_DATE`, `CAPPED`, `EXPIRED_NOTIF`, `ACTIVATION_NOTIF`, `SUSPENDED`, `ACTIVATION_EXPIRATION_DATE`, `ACTIVATION_NOTIFICATION_DATE`, `ROAMING_PARTNER_REMOVAL_NOTIF`, `VALIDITY_START_DATE`, `CONSUMPTION_ORDER`, `CONSUMPTION_NOTIF`, `ALLOWANCE_VOLUME`, `ALLOWANCE_TERM`, `ALLOWANCE_TERM_UNIT`, `NETWORK_GROUP_ID`, `UUID`, `CLIENT_TYPE`, `NETWORK_CHANGE_ACTIVATION_ENABLED`, `CAP_ID`, `ENTERPRISE_PURCHASE_ID`, `DATA_CAP_TYPE`, `DEVICE_PLAN`)  SELECT @user_purchase_id,@user_id,tdevice_plan.data_id , 13, @next_renewal, 0, 0, NULL, 2, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL,  now(),  now(), NULL, 0, NULL, NULL, 0, NULL, 0, 0, 0, 0,  now(), NULL, 0,  now(), 0, 0, NULL, NULL, NULL, NULL, @unique_uuid, clientTypeValue, 0, tsim_card_pool_data_cap.id, NULL, NULL, 1 FROM tdevice_plan inner JOIN tsim_card_pool_data_cap ON tsim_card_pool_data_cap.SIM_CARD_POOL_ID=data_id where planId=devicePlanId;
				if  @dp_active=0 then
					START TRANSACTION;
						SELECT id into @lock_variable FROM tsim_card_pool_data_cap WHERE SIM_CARD_POOL_ID = @data_id FOR UPDATE;
						update tsim_card_pool_data_cap  set AVL_VOLUME=@dataValue, CAP=@dataValue,volume=@dataValue ,EXPIRATION_DATE=@next_renewal where SIM_CARD_POOL_ID = @data_id;
					COMMIT;
				END if;
			end if;

-- User purchase end
	if  @dp_active=0 then
		UPDATE tdevice_plan SET ACTIVE = 1 WHERE planId=devicePlanId;
	END if;
    update migration_asset asset set asset.status=b'1',asset.failure_reason='SUCCESS' where asset.imsi=imsi; 
	END IF;
	COMMIT;
    SET successCount = 1;
    END register_user_block;
END//
DELIMITER ;

