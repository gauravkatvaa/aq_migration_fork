drop table if exists migration_asset;
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
    status bit(1) default 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
CREATE INDEX idx_imsi ON migration_asset (imsi);