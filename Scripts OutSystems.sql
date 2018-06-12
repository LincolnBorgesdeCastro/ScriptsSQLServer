--Descobrir entidade

select * from osmtd.dbo.ossys_Entity
where PHYSICAL_TABLE_NAME = 'OSUSR_3MB_ENVIONOTIFICACAO'


-- Descobrir Space
select * from OSMTD.dbo.ossys_Espace 
where ID = 104
