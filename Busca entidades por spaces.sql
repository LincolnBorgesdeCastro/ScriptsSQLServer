
select distinct en.is_active, en.PHYSICAL_TABLE_NAME, en.name --ea.*, en.ss_Key ss_key_Tabela, substring(type, charIndex('*', type) + 1, len(type)) ss_key_FK
from
	osmtd.dbo.ossys_entity en
	inner join osmtd.dbo.ossys_espace e on en.espace_id = e.id
where
	en.espace_id = 351
	and en.IS_ACTIVE = 1
order by en.NAME






