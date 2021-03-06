
CHECKPOINT
GO
DBCC DROPCLEANBUFFERS
GO
DBCC FREEPROCCACHE
GO
DBCC FREESESSIONCACHE
GO
DBCC FREESYSTEMCACHE ('ALL')
GO



/**********************************************************************************************/
-- Limpa cache de um consulta determidada consulta
SELECT plan_handle, creation_time, last_execution_time,
execution_count, qt.text,
CONCAT('DBCC FREEPROCCACHE (',1,convert(varchar(max), qs.plan_handle, 2),')') ClearCache
FROM
sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text (qs.[sql_handle]) AS qt
WHERE DATEDIFF(hour,creation_time, GETDATE()) > 24 -- Change 4 to your hour
order by execution_count desc

/**/
SELECT cp.plan_handle, st.[text]
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
where  st.[text] like '%declare @qpinPrestadorID int,@qpstGrupoProcedimento nvarchar(10)%'

DBCC FREEPROCCACHE(0x0600060083FE8518109F6E060A00000001000000000000000000000000000000000000000000000000000000)


/**********************************************************************************************/

DBCC FREESYSTEMCACHE('SQL Plans')

/**********************************************************************************************/

use tempdb
GO

checkpoint

DBCC SHRINKDATABASE(N'tempdb', 10 )
GO

DBCC SHRINKFILE (N'tempdev' , 0)
GO

DBCC SHRINKFILE (N'templog' , 0)
GO

DBCC FREEPROCCACHE -- clean cache
DBCC DROPCLEANBUFFERS -- clean buffers
DBCC FREESYSTEMCACHE ('ALL') -- clean system cache
DBCC FREESESSIONCACHE -- clean session cache
DBCC SHRINKDATABASE(tempdb, 10); -- shrink tempdb
dbcc shrinkfile ('tempdev') -- shrink db file
dbcc shrinkfile ('templog') -- shrink log file
GO

-- report the new file sizes
SELECT name, size/128 "Tamanho/MB"
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO

/********************************************************************************************/

Select log_reuse_wait_desc, * from sys.databases

/********************************************************************************************/

use CONTAS_PAGAR
Go
checkpoint
use juridiko
Go
checkpoint
use PRESTADORES
Go
checkpoint
use sisipasgo
Go
checkpoint