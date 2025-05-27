load data 
into table sds_subscriber_cos_entries
append
fields terminated by ","
(
sce_cos_id,
sce_entry_type,
sce_range_from,
sce_range_to,
sce_rec_status,
sce_rec_changed_by
)