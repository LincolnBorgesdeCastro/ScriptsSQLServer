checkpoint

USE [tempdb]
GO
DBCC SHRINKDATABASE(N'tempdb', 10 )
GO

DBCC SHRINKFILE (N'tempdev' , 0)
GO

DBCC SHRINKFILE (N'templog' , 0)
GO

dbcc freeproccache

dbcc dropcleanbuffers

dbcc freesystemcache('all')


/**********************************************************************************************/

use tempdb
GO

checkpoint

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