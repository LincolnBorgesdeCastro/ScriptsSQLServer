-- This is designed only for 2005 (should work in 2008, not tested there
-- yet.  It should be trivial to run a sp_helptext sp_spaceused in
-- SQL 2000 and modify the code accordingly.
use ipasgo
go
set nocount on

declare @dbsize bigint,
 @logsize bigint,
 @reservedpages bigint,
 @usedpages bigint,
 @pages bigint

select @dbsize = sum(convert(bigint, case when status & 64 = 0 then size else 0 end)),
 @logsize = sum(convert(bigint, case when status & 64 <> 0 then size else 0 end))
 from dbo.sysfiles

select @reservedpages = sum(a.total_pages), @usedpages = sum(a.used_pages),
 @pages = sum(
 case
 when it.internal_type IN (202, 204) then 0
 when a.type <> 1 then a.used_pages
 when p.index_id < 2 then a.data_pages
 else 0
 end
 )
 from sys.partitions p join sys.allocation_units a on p.partition_id = a.container_id
 left join sys.internal_tables it on p.object_id = it.object_id

select db_name(), 
  cast(((@dbsize + @logsize) * 8192/1048576.) as decimal(15, 2)) "DB Size(MB)",
  (case when @dbsize >= @reservedpages then cast(((@dbsize - @reservedpages) * 8192/1048567.) as decimal(15, 2)) else 0 end) "Unalloc. Space(MB)",
  cast((@reservedpages * 8192/1048576.) as decimal(15, 2)) "Reserved(MB)",
  cast((@pages * 8192/1048576.) as decimal(15, 2)) "Data Used(MB)",
  cast(((@usedpages - @pages) * 8192/1048576.) as decimal(15, 2)) "Index Used(MB)",
  cast(((@reservedpages - @usedpages) * 8192/1048576.) as decimal(15, 2)) "Unused(MB)"
go


-- A quick way to monitor server growth is create a table
-- the above columns plus a time stamp and something like:
--
--    insert into DBGrowthTable(dbname, dbsizeMB, unallocMB, reservedMB,
--	  dataMB, unusedDB, getdate())
--        exec sp_msforeachdb 'use ?; INSERT_ENTIRE_SCRIPT_HERE'
--
-- and run it as a job once each night.










