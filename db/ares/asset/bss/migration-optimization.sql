

alter table migration_asset add column `executed` bit(1) DEFAULT b'0';
alter table migration_asset add column failure_reason varchar(255) DEFAULT NULL;


DROP PROCEDURE IF EXISTS start_register_user_batch_call;
DELIMITER $$
CREATE PROCEDURE start_register_user_batch_call(IN prorationEnabled BOOLEAN,IN clientType INT)
BEGIN
    DECLARE errorMessage VARCHAR(255);
    SET errorMessage = NULL;
    SELECT 
        'Before Execution: 0' AS before_execution,
        'After Execution: 1' AS after_execution,
        'Success Count: 1' AS success_count,
        'Failed Count: 0' AS failed_count,
        IFNULL(errorMessage, 'No Errors') AS Remarks;
END $$

DELIMITER ;


DROP TABLE IF EXISTS bss_id_generator;

CREATE TABLE bss_id_generator (
    table_name VARCHAR(50) PRIMARY KEY,
    next_id BIGINT NOT NULL
);

INSERT INTO bss_id_generator (table_name, next_id) 
VALUES 
('tuser', (SELECT COALESCE(MAX(id), 0) + 1 FROM tuser)), 
('ttransactionlog', (SELECT COALESCE(MAX(id), 0) + 1 FROM ttransactionlog)), 
('tdata_bucket', (SELECT COALESCE(MAX(id), 0) + 1 FROM tdata_bucket)), 
('tuser_purchase', (SELECT COALESCE(MAX(id), 0) + 1 FROM tuser_purchase));


DROP PROCEDURE IF EXISTS get_next_id_proc;
DELIMITER $$

CREATE PROCEDURE get_next_id_proc(IN tbl_name VARCHAR(255), OUT new_id BIGINT)
BEGIN
    DECLARE curr_id BIGINT;
    
    START TRANSACTION;
        SELECT next_id INTO curr_id FROM bss_id_generator WHERE table_name = tbl_name FOR UPDATE;
        UPDATE bss_id_generator SET next_id = curr_id + 1 WHERE table_name = tbl_name;
    COMMIT;
    
    SET new_id = curr_id;
END $$

DELIMITER ;
