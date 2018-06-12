set nocount on

IF OBJECT_ID('TEMPDB..#temp ') IS NOT NULL DROP TABLE #temp  
create table #temp (Texto varchar(max))

declare @comando varchar(4000)

declare cur cursor 
for

select 'select '+OBJECT_name(object_id)+'.'+name+' from ' + OBJECT_name(object_id) + ' with(nolock) where ' + name + ' = ''2018-05-22 15:36:26.873'' '
from sys.columns 
where 
OBJECT_name(object_id)   not in ('sysftproperties','sqlagent_jobs','queue_messages_2009058193','sqlagent_jobsteps_logs') and
TYPE_NAME(system_type_id) in ('date','datetime') and
OBJECT_name(object_id)   not like 'sys%' and
OBJECT_name(object_id)   not like 'queue_messages_%'

open cur

fetch cur into @comando 

while @@FETCH_STATUS = 0
begin
   truncate table #temp 

   insert into #temp 
   EXECUTE (@comando)

   if (select count(*) from #temp) > 0 print @comando 


   fetch cur into @comando 
end


close cur
deallocate cur