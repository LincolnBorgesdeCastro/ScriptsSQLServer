------------------------------------------------------------------------------------------
-- Usuarios que pertencem ao grupo siga - supervisor do banco SIGA
------------------------------------------------------------------------------------------
use siga
go
if object_id ('tempdb..#siga_usr') > 0 drop table #siga_usr
create table #siga_usr (id int identity, role varchar (50), membro varchar(100), membersid varbinary(800))

insert into #siga_usr (role, membro, membersid)
EXEC sp_helprolemember 'siga - supervisor'

------------------------------------------------------------------------------------------
-- Usuarios que pertencem ao grupo siga - supervisor do banco IPASGO
------------------------------------------------------------------------------------------
use ipasgo
go
if object_id ('tempdb..#ipasgo_usr') > 0 drop table #ipasgo_usr
create table #ipasgo_usr (id int identity, role varchar (50), membro varchar(100), membersid varbinary(800))

insert into #ipasgo_usr (role, membro, membersid)
EXEC sp_helprolemember 'siga - supervisor'


------------------------------------------------------------------------------------------
-- Usuarios que existem no SIGA que nao existem no IPASGO do grupo siga - supervisor
------------------------------------------------------------------------------------------
select * 
from #siga_usr t1 
left join #ipasgo_usr t2 on t1.membro = t2.membro
where t2.membro is null


------------------------------------------------------------------------------------------
-- Usuarios que existem no IPASGO que nao existem no SIGA do grupo siga - supervisor
------------------------------------------------------------------------------------------
select * 
from #siga_usr t1 
right join #ipasgo_usr t2 on t1.membro = t2.membro
where t1.membro is null

------------------------------------------------------------------------------------------
-- Usuarios que existem no siga que nao existem no ipasgo do grupo siga - supervisor
------------------------------------------------------------------------------------------
declare @user varchar(100)
declare @cont int
declare @fim int

set @cont = 1
select @fim = count(*) from #siga_usr

while @cont <= @fim
begin
	select @user = membro from #siga_usr where ID = @CONT
	EXEC sp_ADDrolemember 'siga - supervisor', @user
	set @cont = @cont + 1
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- select * from #temp2
-- declare 
-- sp_addrolemember 'siga - supervisor', '01379594197'

-- select * from #siga_usr order by membro
-- select * from #ipasgo_usr order by membro

