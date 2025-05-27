-- =================================== accounts ================================
role_tab_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_to_tab_mapping;"

role_screen_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_to_screen_mapping;",

role_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access;",

whole_sale_rate_plan_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.whole_sale_rate_plan;",

pricing_categories_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.pricing_categories;",

price_model_type_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_to_model_type;",

price_model_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_model_rate_plan;",

zone_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones;",

opco_account_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts WHERE NAME='maxis_opco'",

account_extend_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.account_extended;",

max_account_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts;",
contact_info_id="SELECT IFNULL(MAX(id),0)+1 FROM contact_info;"


whole_sale_to_pricing_categories_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.whole_sale_to_pricing_categories;"

users_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.users; >>670;"

migration_contact_info_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_contact_info;"

user_details_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.user_details;""
account_goup_mappings="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.account_goup_mappings;"



sim_provisioned_range_details_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_range_details;"
sim_provisioned_ranges_level1_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level1; >> 399"
sim_provisioned_ranges_level2_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level2;"
sim_provisioned_ranges_level3_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level3;"
accounttype2_id="SELECT IFNULL(MAX(id),0)  FROM maxis_development.accounts  where type=2;"
accounttype3_id="SELECT IFNULL(MAX(id),0) FROM maxis_development.accounts  where type=3;"
assets_extended_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.assets_extended;"


device_rate_plan_id="select IFNULL(MAX(id),0)+1 from maxis_development.device_rate_plan;"
service_plan_id="select IFNULL(MAX(id),0)+1 from maxis_development.service_plan;"
service_apn_details_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.service_apn_details;"
migration_service_apn_details_id="SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_service_apn_details;"
assets_id="Select ifnull(max(id),0)+1 from maxis_dev.assets;"


`in_goup_account_id` = "SELECT IFNULL(MAX(id),0)+1 FROM maxis_dev_mg.account_goup_mappings;"
`in_goup_user_name`  =" SELECT goup_user_name FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_goup_user_key`  ="SELECT goup_user_key FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_goup_password`  ="SELECT goup_password FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_application_key` ="SELECT application_key FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_goup_url`="SELECT goup_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_auth_token_url`  ="SELECT auth_token_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"
`in_validate_token_url` = "SELECT validate_token_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;"



create table maxis_development.migration_assets_extended like maxis_dev.assets_extended;
create table maxis_development.assets_extended select * from maxis_dev.assets_extended;

 
###mig_server

Please check the server details here:
ip - 10.235.143.32
Username – aqadmin
Password - Ex0cz@Ws#

goup- service -- sp >> call migration_goup_service_procedure(service_plan_id,device_rate_plan_id,migration_service_apn_details_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.service_plan;
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.device_rate_plan;
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_service_apn_details;
 
 
	IN `in_gc_account_id` INT,
	IN `in_gc_service_plan_id` INT,
	IN `in_gc_device_plan_id` INT,
       IN `in_gc_apn_id` INT)






###service

Procedure Format:1

call migration_device_rate_plan_procedure(in_device_plan_id,in_max_zone_id,in_account_id);

select IFNULL(MAX(id),0)+1 from maxis_development.device_rate_plan; -- ex:120
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones; -- ex:100
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; -- ex:550
call migration_device_rate_plan_procedure(120,550,100);(device_rate_plan_id,zone_id,max_account_id)



Procedure Format:2
----------------
call migration_service_apn_details_procedure(in_device_plan_id,in_account_id);

select IFNULL(MAX(id),0)+1 from maxis_development.device_rate_plan; -- ex:120
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; -- ex:550
call migration_service_apn_details_procedure(120,550);(device_rate_plan_id,max_account_id)


Procedure Format:3
---------------

call migration_service_apn_ip_procedure(in_service_plan_id,in_apn_id);

select IFNULL(MAX(id),0)+1 from maxis_development.service_plan; -- ex:120
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.service_apn_details; -- ex:550
call migration_service_apn_ip_procedure(120,550);(service_plan_id,service_apn_details_id)


Procedure Format:4
---------------

call migration_service_plan_info_procedure(in_max_service_plan_id,in_account_id);

SELECT IFNULL(MAX(id),0)+1 from maxis_development.service_plan; -- ex:120
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; -- ex:570


call migration_service_plan_info_procedure(120,570);(service_plan_id,max_account_id)



Procedure Format:5
===============

call migration_service_plan_to_service_type_info_procedure(in_SERVICE_PLAN_TYPE_ID);

SELECT IFNULL(MAX(id),0)+1 from maxis_development.service_plan; -- ex:120
Service Plan Name is required as input

call migration_service_plan_to_service_type_info_procedure(120);(service_plan_id,)












-- ====================================== assets ==================================
-- 1. sim_provisioned_range_details
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_range_details;
CALL migration_sim_provisioned_range_details_procedure(4366); >> 281,497  >>(sim_provisioned_range_details_id)
 

 
 
-- 2. sim_provisioned_ranges_level1
select IFNULL(MAX(id),0)+1 from maxis_development.sim_provisioned_range_details; >> 4367
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level1; >> 399
call migration_sim_provisioned_ranges_level1_procedure(4367,399); >> 204,699  >> 20240310269863  (sim_provisioned_range_details_id,sim_provisioned_ranges_level1_id)
 
-- 2. sim_provisioned_ranges_level2
 
select IFNULL(MAX(id),0)+1 from maxis_development.sim_provisioned_range_details; >> 4367
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level2; >> 399
SELECT ID FROM maxis_development.accounts  where type=2; >> 17
SELECT ID FROM maxis_development.accounts  where TYPE=3; >> 214
call migration_sim_provisioned_ranges_level2_procedure(4367,399,17,214);(sim_provisioned_range_details_id,sim_provisioned_ranges_level2_id,accounttype2_id,accounttype3_id)
 
 
-- 2. sim_provisioned_ranges_level3
 
select IFNULL(MAX(id),0)+1 from maxis_development.sim_provisioned_range_details; >> 4367
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level3; >> 399
SELECT ID FROM maxis_development.accounts  where type=2; >> 17
SELECT ID FROM maxis_development.accounts  where TYPE=3; >> 214
call migration_sim_provisioned_ranges_level3_procedure(4367,399,17,214)
(sim_provisioned_range_details_id,sim_provisioned_ranges_level3_id,accounttype2_id,accounttype3_id)



 
-- 3. sim range to accounts
-- this procedure will aplicable for all sim level account mapping
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.sim_provisioned_ranges_level1;
SELECT ID FROM maxis_development.accounts  where TYPE=3; 
CALL migration_sim_provisioned_ranges_to_account_procedure(399,214) >>204,699(sim_provisioned_ranges_level1_id,accounttype3_id)

-- assets
)
call migration_assests_details_procedure('Malaysia',accounttype2_id,assets_id,assets_extended_id);
 in_country_name : 'Malaysia'
in_mno_id : SELECT ID FROM maxis_dev.accounts  where type=2;
in_max_assets_id=select ifnull(max(id),0)+1 from maxis_dev.assets;
in_max_assets_extended_id=select ifnull(max(id),0)+1 from maxis_dev.assets_extended;

call `migration_assests_details_procedure`(`in_country_name`,`in_mno_id`,`in_max_assets_id`,`in_max_assets_extended_id`)



-- assets_extended
SELECT IFNULL(MAX(id),0)+1 FROM maxis_dev.assets_extended; 
CALL migration_asset_extended_procedure(assets_extended_id);
CALL migration_asset_extended_procedure(4466)


-- account_goup_mappings


PROCEDURE : `migration_account_goup_mappings_procedure`(`in_goup_account_id` ,  `in_goup_user_name` ,  `in_goup_user_key` ,  `in_goup_password` ,  `in_application_key` ,  `in_goup_url` ,  `in_auth_token_url` ,  `in_validate_token_url`  );

,,,,,,,
account_goup_mappings_id =SELECT IFNULL(MAX(id),0)+1 FROM maxis_dev_mg.account_goup_mappings;
goup_user_name_id=SELECT goup_user_name FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
goup_user_key_id= SELECT goup_user_key FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
goup_password_id= SELECT goup_password FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
application_key_id = SELECT application_key FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
goup_url_id= SELECT goup_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
auth_token_url_id = SELECT auth_token_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;
validate_token_url_id : SELECT validate_token_url FROM maxis_dev_mg.account_goup_mappings ORDER BY id DESC LIMIT 1;


-- account_extend
`migration_account_extended_procedure`( IN `in_max_account_extended_id` INT )
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.account_extended; 
CALL migration_account_extended_procedure(7079);(account_extend_id)



-- ========================================== USER Module ===========================================================
-- users  contect_info
PROCEDURE : migration_user_contect_info_procedure(in_contect_info_id);
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_contact_info; (migration_contact_info_id)
CALL migration_user_contect_info_procedure(4729);


-- user 
PROCEDURE `migration_users_procedure`( IN `in_max_user_id` INT, IN `in_max_contect_info_id` INT, IN `in_user_details_id` INT )
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.users; >>670(users_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_contact_info;(migration_contact_info_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.user_details;(user_details_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access;(role_id)
CALL migration_users_procedure(670,29803,671,12343);



-- user details
PROCEDURE `migration_user_details_procedure`(
	IN `in_user_details_id` INT
)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.user_details;
call migration_user_details_procedure(671);(user_details_id)



-- user_extended_accounts
`migration_users_extended_account_procedure`(
	IN `in_max_user_id` INT,
	IN `in_max_contect_info_id` INT,
	IN `in_user_details_id` INT,
	IN `in_role_id` INT
)

SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.users; >>670(users_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.migration_contact_info;(migration_contact_info_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.user_details;(user_details_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access;(role_id)
CALL migration_users_extended_account_procedure(670,29803,671,12343);


###mahi m'am
account  layer 1 sp : migration_accounts_goup_procedure
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (max_account_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones;(zone_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_model_rate_plan;(price_model_id)
























-- contect_info
PROCEDURE : migration_contect_info_procedure(in_contect_info_id);
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.contact_info; 
CALL migration_contect_info_procedure(4729);(contact_info_id)


-- account
PROCEDURE CALL `migration_account_procedure`( IN `in_max_account_id` INT, IN `in_max_contect_info_id` INT, IN `in_max_account_extended_id` INT, IN `in_opco_account_id` INT )
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (max_account_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.contact_info; (contact_info_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.account_extended; (account_extend_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts WHERE NAME='maxis_opco'; (opco_account_id)
SELECT * FROM maxis_development.accounts; 
SELECT COUNT(1) FROM ecmp_m2m_company >>1123857
CALL migration_account_procedure(7077,29803,7079,215);


-- account_extend
`migration_asset_extended_procedure`( IN `in_max_account_extended_id` INT )
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.account_extended; (account_extend_id)
CALL migration_asset_extended_procedure(7079);


-- zone
PROCEDURE FORMAT : `migration_zone_procedure`(in_account_id,in_zone_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (account_extend_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones; (zone_id)
CALL migration_zone_procedure(7077,9695);



-- zone_to_country
PROCEDURE : migration_zone_to_country_procedure(in_zones_id);
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones; (zone_id)
CALL migration_zone_to_country_procedure(9695);




-- price_model_rate_plan
PROCEDURE : migration_price_model_rate_plan_procedure(in_account_id,in_price_model_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (account_extend_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_model_rate_plan; (price_model_id)
CALL migration_price_model_rate_plan_procedure(7077,9672);

-- price_to_model_type
PROCEDURE : migration_price_to_model_type_procedure(in_price_model_id,in_price_model_type_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_model_rate_plan;  (price_model_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_to_model_type; (price_model_type_id)
CALL migration_price_to_model_type_procedure(9672,9672);





-- pricing_categories
PROCEDURE : migration_pricing_categories_procedure(in_pricing_categories_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.pricing_categories; (pricing_categories_id)
CALL migration_pricing_categories_procedure(9499);

-- whole_sale_rate_plan
PROCEDURE: `migration_whole_sale_rate_plan_procedure`( IN `in_account_id` INT, IN `in_whole_sale_rate_plan_id` INT)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (account_extend_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.whole_sale_rate_plan; (whole_sale_rate_plan_id)
CALL migration_whole_sale_rate_plan_procedure(7077,4729);


--role_access
PROCEDURE : migration_role_access_procedure(in_role_id,in_account_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access; (role_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (max_account_id)
CALL migration_role_access_procedure(123,5543)




-- role_to_screen_mapping
PROCEDURE : migration_role_to_screen_mapping_procedure(in_role_screen_id,in_role_id);
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_to_screen_mapping; (role_screen_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access; (role_id)
CALL migration_role_to_screen_mapping_procedure(123123,2144112);

-- role_to_tab_mapping
PROCEDURE : migration_role_to_tab_mapping_procedure(in_role_tab_id,in_role_id);
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_to_tab_mapping; (role_tab_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.role_access; (role_id)
CALL migration_role_to_tab_mapping_procedure(46156,2200);


-- accounts_goup_mapping
PROCEDURE `migration_accounts_goup`( IN `in_gc_account_id` varchar(50), IN `in_gc_zone_id` varchar(50), IN `in_price_model_id` INT )
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.accounts; (max_account_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.zones; (zone_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.price_model_rate_plan; (price_model_id)
CALL migration_accounts_goup(7077,9695,9672);


-- whole_sale_to_pricing_categories
PROCEDURE : migration_whole_sale_to_pricing_categories_procedure(`in_whole_sale_id` , `in_pricing_categories_id`)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.whole_sale_rate_plan; (whole_sale_rate_plan_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.pricing_categories;(pricing_categories_id)
SELECT IFNULL(MAX(id),0)+1 FROM maxis_development.whole_sale_to_pricing_categories;(whole_sale_to_pricing_categories_id)
CALL migration_whole_sale_to_pricing_categories_procedure(4729,9499,1222)

    'Contestinfo.csv': 'migration_contect_info_procedure',
    'AccountExtended.csv': 'migration_account_extended_procedure',
    'Accounts.csv': 'migration_account_procedure',
    'account_goup_mappings.csv': 'migration_account_goup_mappings_procedure',
    'Zones.csv': 'migration_zone_procedure',
    'zone_to_country.csv': 'migration_zone_to_country_procedure',
    'Role_and_Access.csv': 'migration_role_access_procedure',
    'role_to_screen_mapping.csv': 'migration_role_to_screen_mapping_procedure',
    'role_to_tab_mapping.csv': 'migration_role_to_tab_mapping_procedure',
    'price_model_rate_plan.csv':'migration_price_model_rate_plan_procedure',
    #'price_service_type.csv':'/M2M_Company_Files/',
    'price_to_model_type.csv':'migration_price_to_model_type_procedure',
    'pricing_categories.csv':'migration_pricing_categories_procedure',
    'whole_sale_rate_plan.csv':'migration_whole_sale_rate_plan_procedure',
    'whole_sale_to_pricing_categories.csv':'migration_whole_sale_to_pricing_categories_procedure',
    'Users.csv':'/M2M_Company_Files/',
    'USER_DETAILS.csv': '/M2M_Company_Files/',
    'user_configuration_column.csv':'/M2M_Company_Files/',
    'Service_Plan.csv':'/M2M_Service_Files/',
    'service_plan_to_service_type.csv':'/M2M_Service_Files/',
    'device_rate_plan.csv':'/M2M_Service_Files/',
    'service_apn_details.csv':'/M2M_Service_Files/',
    'service_apn_ip.csv':'/M2M_Service_Files/',
    'goup_account_mapping.csv':'/Goup_Company/',
    'router_spdp_apn.csv': '/Router_Asset/',
    'router_assets.csv': '/Router_Asset/',

