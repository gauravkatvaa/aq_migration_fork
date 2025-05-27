load data 
into table sds_imsi_cos_entries
append
fields terminated by ","
(
sic_cos_id,
sic_imsi,
sic_rec_status,
sic_rec_changed_by,
sic_pattern_length constant 0
)