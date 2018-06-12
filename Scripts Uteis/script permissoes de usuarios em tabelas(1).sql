declare @qtde int
declare @i int
declare @tab varchar(80)
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


if object_id('tempdb..#tabelas') > 0 drop table #tabelas
select * into #tabelas 
from sysobjects where xtype = 'u'
set @qtde = @@rowcount

set @cmd = 'alter table #tabelas drop column id'
exec (@cmd)

set @cmd = 'alter table #tabelas add id int identity (1,1)'
exec (@cmd)


set @i = 1

while @i <= @qtde
begin

	select @tab = name from #tabelas where id = @i
	print @tab 

	insert into #permissoes
	exec sp_helprotect @tab

	set @i = @i + 1 
	print @tab
end



select 
per.*
--'grant ' + action + ' on ' + object + ' to [99999999905]'
from #permissoes per
inner join sysusers sys on
per.grantee = sys.name
where sys.islogin = 1
and grantee = 'usr_sipo'