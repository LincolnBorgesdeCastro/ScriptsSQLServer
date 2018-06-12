declare @qtde int
declare @i int
declare @role varchar(80)
declare @cmd varchar(200)



if object_id('tempdb..#permissoes') > 0 drop table #permissoes
create table #permissoes (
		owner varchar(100),
		object varchar(100),
		grantee varchar(100),
		grantor varchar(100),
		protecttype varchar(100),
		action varchar(100),
		cols varchar(100)
)


if object_id('tempdb..#roles') > 0 drop table #roles
select * into #roles  
from sysusers where issqlrole = 1

set @cmd = 'alter table #roles drop column uid'
exec (@cmd)

set @cmd = 'alter table #roles add uid int identity (1,1)'
exec (@cmd)


set @qtde = @@rowcount

set @i = 1

while @i <= @qtde
begin

	select @role = name from #roles where uid = @i
	print @role 

	insert into #permissoes
	exec sp_helprotect null, @role

	set @i = @i + 1 
end



if object_id('tempdb..#grants') > 0 drop table #grants
select 	object,
			grantee,
			case when protecttype = 'grant' and action = 'select' then 1 else 0 end as sel,
			case when protecttype = 'grant' and action = 'insert' then 1 else 0 end as ins,
			case when protecttype = 'grant' and action = 'update' then 1 else 0 end as up,
			case when protecttype = 'grant' and action = 'delete' then 1 else 0 end as del
into #grants
from #permissoes


select 	object,	
			grantee,
			sum (sel) sel,
			sum (ins) ins,
			sum (up) up,
			sum (del) del
from #grants
where sel <> 0 or ins <> 0 or up <> 0 or del <> 0
group by object, grantee
order by object