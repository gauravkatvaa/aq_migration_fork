create or replace procedure remove_migrated_cos (
	in_cos_id	in number,
	out_status	out number,
	out_message	out varchar2
)
as
begin
	declare
		l_count number :=0 ;
	begin
		out_status := 0;
		select count(*) into l_count from ocs_feature_provisioning where ofp_cos_id = in_cos_id and ofp_rec_status != 2;
		if l_count > 0 then 
			delete from ocs_feature_provisioning where ofp_cos_id = in_cos_id and ofp_rec_status = 2;
			update ocs_feature_provisioning
			set 	ofp_rec_status = 2, 
					ofp_rec_changed_at = systimestamp, 
					ofp_rec_changed_by = 'migration-script'
			where 	ofp_cos_id = in_cos_id and 
					ofp_rec_status != 2;
		end if;
		
		select count(*) into l_count from ocs_imei_wl_recoord where oiwr_cos = in_cos_id and oiwr_rec_status != 2;
		if l_count > 0 then
			delete from ocs_imei_wl_recoord where oiwr_cos = in_cos_id and oiwr_rec_status = 2;
			update ocs_imei_wl_recoord
			set 	oiwr_rec_status = 2, 
					oiwr_rec_changed_at = systimestamp,
					oiwr_rec_changed_by = 'migration-script'
			where 	oiwr_cos = in_cos_id and 
					oiwr_rec_status != 2;
		end if;
		
		select count(*) into l_count from account_sim_mapping where asm_cos_id = in_cos_id and asm_rec_status != 2;
		if l_count > 0 then
			delete from account_sim_mapping where asm_cos_id = in_cos_id and asm_rec_status = 2;
			update account_sim_mapping
			set 	asm_rec_status = 2,
					asm_rec_modified_at = systimestamp,
					asm_rec_created_by = 'migration-script'
			where 	asm_cos_id = in_cos_id and 
					asm_rec_status != 2;
		end if;
		
		
		select count(*) into l_count from ocs_account_service_mapping where oasm_cos_id = in_cos_id and oasm_rec_status != 2;
		if l_count > 0 then
			delete from ocs_account_service_mapping where oasm_cos_id = in_cos_id and oasm_rec_status = 2;
			update ocs_account_service_mapping
			set 	oasm_rec_status = 2,
					oasm_rec_modified_at = systimestamp,
					oasm_created_by = 'migration-script'
			where 	oasm_cos_id = in_cos_id and 
					oasm_rec_status != 2;
		end if;
		
		select count(*) into l_count from ocs_account_service_entries where oase_cos_id = in_cos_id and oase_rec_status != 2;
		if l_count > 0 then
			delete from ocs_account_service_entries where oase_cos_id = in_cos_id and oase_rec_status = 2;
			update ocs_account_service_entries
			set 	oase_rec_status = 2,
					oase_rec_modified_at = systimestamp,
					oase_created_by = 'migration-script'
			where 	oase_cos_id = in_cos_id and 
					oase_rec_status != 2;
		end if;
		
		
		select count(*) into l_count from sds_subscriber_cos_master where scm_cos_id = in_cos_id and scm_rec_status != 2;
		if l_count > 0 then
			delete from sds_subscriber_cos_master where scm_cos_id = in_cos_id and scm_rec_status = 2;
			update sds_subscriber_cos_master 
			set 	scm_rec_status = 2, 
					scm_rec_changed_at = systimestamp,
					scm_rec_changed_by = 'migration-script'
			where 	scm_cos_id = in_cos_id and 
					scm_rec_status != 2;
		end if;
		
		select count(*) into l_count from sds_subscriber_cos_entries where sce_cos_id = in_cos_id and sce_rec_status != 2;
		if l_count > 0 then
			delete from sds_subscriber_cos_entries where sce_cos_id = in_cos_id and sce_rec_status = 2;
			update sds_subscriber_cos_entries 
			set 	sce_rec_status = 2,
					sce_rec_changed_at = systimestamp,
					sce_rec_changed_by = 'migration-script'
			where 	sce_cos_id = in_cos_id and 
					sce_rec_status != 2;
		end if;
		
		select count(*) into l_count from sds_imsi_cos_entries where sic_cos_id = in_cos_id and sic_rec_status != 2;
		if l_count > 0 then
			delete from sds_imsi_cos_entries where sic_cos_id = in_cos_id and sic_rec_status = 2;
			update sds_imsi_cos_entries 
			set 	sic_rec_status = 2,
					sic_rec_changed_at = systimestamp,
					sic_rec_changed_by = 'migration-script'
			where 	sic_cos_id = in_cos_id and 
					sic_rec_status != 2;
		end if;
		
		select count(*) into l_count from sds_msisdn_cos_entries where smc_cos_id = in_cos_id and smc_rec_status != 2;
		if l_count > 0 then
			delete from sds_msisdn_cos_entries where smc_cos_id = in_cos_id and smc_rec_status = 2;
			update sds_msisdn_cos_entries 
			set		smc_rec_status = 2,
					smc_rec_changed_at = systimestamp,
					smc_rec_changed_by = 'migration-script'
			where 	smc_cos_id = in_cos_id and 
					smc_rec_status != 2;
		end if;
		
	end;
exception
	when others then
	begin
		rollback ;
            out_status := 2 ;
            out_message := SUBSTR(SQLERRM, 1, 170) ;
            Insert Into ocs_checkpoint(Message, Attime) Values('remove_migrated_cos : ' || out_message, Sysdate) ;
            commit;
	end;	
end remove_migrated_cos;
/

