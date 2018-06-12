if object_id ('tempdb..#grupos') <> 0 drop table #grupos
create table #grupos (rolename varchar(500), roleid varchar(100), isapprole varchar(200))

insert into #grupos
exec sp_helprole


if object_id ('tempdb..#permissoes') > 0 drop table #permissoes
create table #permissoes (
owner varchar(50),
object varchar (100),
grantee varchar (100),
grantor varchar (100),
protecttype varchar (100),
action varchar (100),
coluna varchar (100)
)


declare @rolename varchar (100)

--update #grupos set rolename = '[' + ltrim(rtrim(rolename)) + ']'


declare cur cursor for
select rolename  
from #grupos

open cur
fetch next from cur into @rolename

while @@fetch_status = 0 
begin

	insert into #permissoes
	exec sp_helprotect null, @rolename


  print @rolename
  fetch next from cur into @rolename
end

close cur
deallocate cur


if object_id ('tempdb..#temp') > 0 drop table #temp
select 	per.object Objeto, 
			per.grantee Grupo,
			case when action = 'select' then 1 end as Selecao,
			case when action = 'insert' then 1 end as Insercao,
			case when action = 'update' then 1 end as Atualizacao,
			case when action = 'delete' then 1 end as Delecao
into #temp
from #permissoes per
inner join sysobjects sys on
per.object = sys.name
where xtype = 'u' and protecttype <> 'deny'
order by grantee, object 


select 	objeto, 	
			grupo, 
			sum(selecao) as selecao,
			sum(insercao) as insercao,
			sum(atualizacao) as atualizacao,
			sum(delecao) as delecao
from #temp
group by grupo, objeto
order by grupo, objeto