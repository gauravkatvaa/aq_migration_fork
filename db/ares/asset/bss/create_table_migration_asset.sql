DROP TABLE IF EXISTS migration_asset;

CREATE TABLE migration_asset (
    imsi VARCHAR(255),
    msisdn VARCHAR(255),
    iccid VARCHAR(255),
    account_id BIGINT,
    device_plan_id BIGINT,
    service_plan_id BIGINT,
    event_date DATE,
    activation_date DATE,
    reason VARCHAR(255),
    state VARCHAR(255),
    status BIT(1) DEFAULT 0
);


CREATE INDEX idx_imsi ON migration_asset (imsi);

-- other table indexes
ALTER TABLE tdevice_plan_quota ADD INDEX I_tdevice_plan_quota01(DEVICE_PLAN_ID, ACCOUNT_ID);
ALTER TABLE tdevice_plan_quota ADD INDEX I_tdevice_plan01(ACCOUNT_ID);
ALTER TABLE tservice_plan ADD INDEX I_tservice_plan01(account_id);
ALTER TABLE tenterprise_account ADD INDEX I_tenterprise_account01(parent_account_id);
ALTER TABLE taccount ADD INDEX I_taccount01(client_type);
ALTER TABLE `tpool_data_bucket` DROP INDEX `idx_pool_bucket`, ADD INDEX `idx_pool_bucket` (`TYPE_ENTRY_ID`, `DATA_BUCKET_TYPE`, `ACTIVE`);
