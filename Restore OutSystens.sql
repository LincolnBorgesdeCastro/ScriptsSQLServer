

update ossys_espace set zone_id=null;
delete from ossys_zone_server;
delete from ossys_zone; 

delete from ossys_server;update ossys_dbcatalog set password = ' ',username =' ' where name <> '(Main)';if exists (select * from information_schema.columns where table_name = 'ossys_PlatformSvcs_Observer')
delete from ossys_PlatformSvcs_Observer;
if exists (select * from information_schema.columns where table_name = 'ossys_cloudservices_observer')
delete from ossys_cloudservices_observer



update ossys_Site_Property_Shared set property_value='' where site_property_definition_id in (
select site_property_definition_id
from ossys_Site_Property_Shared
inner join ossys_Site_Property_Definition on site_property_definition_id = ossys_Site_Property_Definition.id
where ss_key = '1aaec1be-d60f-43d4-ba32-391f4c3080a6' or
ss_key = '441f6eef-9c7f-4bb4-b3dd-7220272269ad'
);



