--Script que verifica as tabelas sem índices

select * from sysobjects where id not in (
select o.id from sysobjects o inner join sysindexes i on o.id = i.id 
where type = 'u' and indid  >= 1 and indid <255 and i.name not like '_wa%'
and i.name not like 'Statistic_%'
group by o.id ) and type = 'u'
order by 1

-- Com quantidade de linhas 
Select object_name(id)as Tabela,rowcnt as Linhas,dpages*8 as [tamanho KB] from sysindexes 
where indid in (1,0) 
and objectproperty(id,'isusertable')=1 
and id in (select id from sysobjects where id not in (
select o.id from sysobjects o inner join sysindexes i on o.id = i.id 
where type = 'u' and indid  >= 1  and indid <255 and i.name not like '_wa%'
and i.name not like 'Statistic_%' group by o.id ) and type = 'u'
) order by rowcnt desc 