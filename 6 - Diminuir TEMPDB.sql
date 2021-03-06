USE [tempdb]
GO

CHECKPOINT
GO
DBCC DROPCLEANBUFFERS
GO
DBCC FREEPROCCACHE
GO
DBCC FREESESSIONCACHE
GO
DBCC FREESYSTEMCACHE ('ALL') WITH MARK_IN_USE_FOR_REMOVAL;  
GO

--COMMIT

USE [tempdb]
GO
DBCC SHRINKDATABASE(N'tempdb')
GO
DBCC SHRINKDATABASE(N'tempdb' , NOTRUNCATE)
GO
DBCC SHRINKDATABASE(N'tempdb' , TRUNCATEONLY)
GO

USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 256)
GO
DBCC SHRINKFILE (N'tempdev1' , 256)
GO
DBCC SHRINKFILE (N'tempdev2' , 256)
GO
DBCC SHRINKFILE (N'tempdev3' , 256)
GO

DBCC SHRINKFILE (N'tempdev4' , 256)
GO
DBCC SHRINKFILE (N'tempdev5' , 256)
GO
DBCC SHRINKFILE (N'tempdev6' , 256)
GO
DBCC SHRINKFILE (N'tempdev7' , 256)
GO
DBCC SHRINKFILE (N'templog' , 256)
GO

/****************************************************************************************************************/
/****************************************************************************************************************/

Use TempDB
GO
--Usuarios que estao ocupando espaço no tempDB
SELECT A.session_id
,B.host_name
, b.status
, B.Login_Name 
, (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 as TotalalocadoMB
, D.Text 
,B.last_request_end_time
,B.open_transaction_count
FROM sys.dm_db_session_space_usage A JOIN sys.dm_exec_sessions B  ON A.session_id = B.session_id 
                                     JOIN sys.dm_exec_connections C ON C.session_id = B.session_id 
																		 CROSS APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) As D 
WHERE A.session_id > 50 
and (user_objects_alloc_page_count + internal_objects_alloc_page_count) * 1.0 / 128 > 0 
ORDER BY totalalocadoMB desc 

--kill 143

/****************************************************************************************************************/
-- Tamanho dos arquivos do TempDB
USE TEMPDB
GO
SP_HELPDB TEMPDB
GO

SELECT name AS FileName,
    size*1.0/128 AS FileSizeInMB,
    CASE max_size
        WHEN 0 THEN 'Autogrowth is off.'
        WHEN -1 THEN 'Autogrowth is on.'
        ELSE 'Log file grows to a maximum size of 2 TB.'
    END,
    growth AS 'GrowthValue',
    'GrowthIncrement' =
        CASE
            WHEN growth = 0 THEN 'Size is fixed.'
            WHEN growth > 0 AND is_percent_growth = 0
                THEN 'Growth value is in 8-KB pages.'
            ELSE 'Growth value is a percentage.'
        END
FROM tempdb.sys.database_files
Order By size*1.0/128 desc
GO

/****************************************************************************************************************/


/****************************************************************************************************************/
/****************************************************************************************************************/
dbcc loginfo

dbcc opentran

Select log_reuse_wait_desc, * from sys.databases

--EXEC sp_removedbreplication 'SIGA'


USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 256MB )
GO

USE TempDB
GO

Select (size*8)/1024 as FileSizeMB, size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB , * from sys.database_files

DBCC SHRINKFILE (N'tempdev' , 0)

Select log_reuse_wait_desc, * from sys.databases



USE TempDB
GO

SELECT SUM(unallocated_extent_page_count) AS [free_pages]
     ,(SUM(unallocated_extent_page_count) * 1.0 / 128) AS [free_space_MB]
     ,SUM(version_store_reserved_page_count) AS [version_pages_used]
     ,(SUM(version_store_reserved_page_count) * 1.0 / 128) AS [version_space_MB]
     ,SUM(internal_object_reserved_page_count) AS [internal_object_pages_used]
     ,(SUM(internal_object_reserved_page_count) * 1.0 / 128) AS [internal_object_space_MB]
     ,SUM(user_object_reserved_page_count) AS [user object pages used]
     ,(SUM(user_object_reserved_page_count) * 1.0 / 128) AS [user_object_space_MB]
FROM sys.dm_db_file_space_usage;

GO

/****************************************************************************************************************************************************************************************************************/
/****************************************************************************************************************************************************************************************************************/
-- espaço do TEMPDB
USE tempdb;
SELECT  
name,
size/128.0 as size,
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
DBCC FREESYSTEMCACHE('ALL')
checkpoint

DBCC SHRINKFILE (N'tempdev' , 0, NOTRUNCATE)
DBCC SHRINKFILE (N'tempdev' , 0, TRUNCATEONLY)
DBCC SHRINKDATABASE (N'tempdb')

/****************************************************************************************************************************************************************************************************************/

--Querys utilizando o TempDB
select top 10
t1.session_id,
t1.request_id,
t3.hostname,
t3.loginame,
t3.program_name,
db_name (t3.dbid) as dbname,
t1.task_alloc  * (8.0/1024.0) as Alocado_MB, --qtd de paginas
t1.task_dealloc  * (8.0/1024.0)as Desalocado_MB, --qtd de paginas

    (SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
     FROM sys.dm_exec_sql_text(t2.sql_handle)) AS query_text,
(SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle)) as query_plan

from      (Select session_id, request_id,
sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc,
sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
       from sys.dm_db_task_space_usage
       group by session_id, request_id) as t1,
       sys.dm_exec_requests as t2,
       sys.sysprocesses as t3
where
t3.loginame <> '' and
t1.session_id = t2.session_id and
(t1.request_id = t2.request_id) and
t1.session_id = t3.spid and
      t1.session_id > 50
order by t1.task_alloc DESC


/****************************************************************************************************************/
/****************************************************************************************************************/

SELECT R1.session_id, R1.request_id, R1.Task_request_internal_objects_alloc_page_count, R1.Task_request_internal_objects_dealloc_page_count,
R1.Task_request_user_objects_alloc_page_count,R1.Task_request_user_objects_dealloc_page_count,R3.Session_request_internal_objects_alloc_page_count ,
R3.Session_request_internal_objects_dealloc_page_count,R3.Session_request_user_objects_alloc_page_count,R3.Session_request_user_objects_dealloc_page_count,
R2.sql_handle, RL2.text as SQLText, R2.statement_start_offset, R2.statement_end_offset, R2.plan_handle 
FROM (SELECT session_id, request_id,
      SUM(internal_objects_alloc_page_count) AS Task_request_internal_objects_alloc_page_count, SUM(internal_objects_dealloc_page_count)AS
      Task_request_internal_objects_dealloc_page_count,SUM(user_objects_alloc_page_count) AS Task_request_user_objects_alloc_page_count,
      SUM(user_objects_dealloc_page_count)AS Task_request_user_objects_dealloc_page_count FROM sys.dm_db_task_space_usage
      GROUP BY session_id, request_id) R1 INNER JOIN (SELECT session_id, SUM(internal_objects_alloc_page_count) AS Session_request_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count)AS Session_request_internal_objects_dealloc_page_count,SUM(user_objects_alloc_page_count) AS Session_request_user_objects_alloc_page_count,
      SUM(user_objects_dealloc_page_count)AS Session_request_user_objects_dealloc_page_count 
	  FROM sys.dm_db_Session_space_usage
      GROUP BY session_id) R3 on R1.session_id = R3.session_id
      left outer JOIN sys.dm_exec_requests R2 ON R1.session_id = R2.session_id and R1.request_id = R2.request_id
      OUTER APPLY sys.dm_exec_sql_text(R2.sql_handle) AS RL2
Where
Task_request_internal_objects_alloc_page_count >0 or
Task_request_internal_objects_dealloc_page_count>0 or
Task_request_user_objects_alloc_page_count >0 or
Task_request_user_objects_dealloc_page_count >0 or
Session_request_internal_objects_alloc_page_count >0 or
Session_request_internal_objects_dealloc_page_count >0 or
Session_request_user_objects_alloc_page_count >0 or
Session_request_user_objects_dealloc_page_count >0

/****************************************************************************************************************************************************************************************************************/
/****************************************************************************************************************************************************************************************************************/


SELECT database_transaction_log_bytes_reserved,session_id
FROM sys.dm_tran_database_transactions AS tdt
INNER JOIN sys.dm_tran_session_transactions AS tst
ON tdt.transaction_id = tst.transaction_id
WHERE database_id = 2; -- ID TempDB

/****************************************************************************************************************************************************************************************************************/
/****************************************************************************************************************************************************************************************************************/
SELECT * FROM sys.sysprocesses

SELECT * FROM sys.databases
/****************************************************************************************************************************************************************************************************************/
/****************************************************************************************************************************************************************************************************************/
USE [tempdb]
GO

DBCC SHRINKFILE ('tempdev8' , emptyfile) 
GO

ALTER DATABASE [tempdb]  REMOVE FILE [tempdev8]
GO
/**/

DBCC TRACEON (3604)
DBCC PAGE(2,9,1353736) --dbid=2, fileid=9, pageid=1353736


/*************************************************************************************************************************************************/
sp_who2
/*************************************************************************************************************************************************/
select * 
from sys.dm_tran_active_transactions s1 inner join sys.dm_tran_database_transactions s2 on s1.transaction_id = s2.transaction_id
where transaction_begin_time < '2019-06-06 00:00:00'


SELECT conn.session_id, host_name, program_name,
    nt_domain, login_name, connect_time, last_request_end_time 
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id
   order by last_request_end_time 


select loginame, session_id, database_id, 
    user_objects_alloc_page_count,
    user_objects_dealloc_page_count, 
    internal_objects_alloc_page_count,
    internal_objects_dealloc_page_count,
    waittime,lastwaittype,
    login_time, last_batch, status, cmd, sql_handle
from sys.dm_db_task_space_usage s1 inner join sys.sysprocesses s2
on s1.session_id = s2.spid
where session_id >= 50
and s2.open_tran > 0
/*************************************************************************************************************************************************/
kill 
/*************************************************************************************************************************************************/

SELECT TSU.session_id,
SUM(internal_objects_alloc_page_count) * 1.0 / 128 AS [internal object MB],
SUM(internal_objects_dealloc_page_count) * 1.0 / 128 AS [internal object dealloc MB],
EST.text
FROM sys.dm_db_task_space_usage TSU WITH (NOLOCK)
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
ON TSU.session_id = ERQ.session_id
AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
WHERE EST.text IS NOT NULL AND TSU.session_id <> @@SPID
GROUP BY TSU.session_id, EST.text
ORDER BY [internal object MB] DESC;


/*************************************************************************************************************************************************/
SELECT (total_log_size_in_bytes - used_log_space_in_bytes)/1024./1024. AS [free log space in MB]  
FROM sys.dm_db_log_space_usage;  
/*************************************************************************************************************************************************/

/*************************************************************************************************************************************************/

SELECT 
    A.session_id,
    A.login_time,
    A.host_name,
    A.program_name,
    A.login_name,
    A.status,
    A.cpu_time,
    A.memory_usage,
    A.last_request_start_time,
    A.last_request_end_time,
    A.transaction_isolation_level,
    A.lock_timeout,
    A.deadlock_priority,
    A.row_count,
    C.text
FROM 
    sys.dm_exec_sessions            A    WITH(NOLOCK)
    JOIN sys.dm_exec_connections        B    WITH(NOLOCK)    ON    A.session_id = B.session_id
    CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle)    C
WHERE 
    EXISTS (SELECT * FROM sys.dm_tran_session_transactions AS t WITH(NOLOCK) WHERE t.session_id = A.session_id)
    AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests AS r WITH(NOLOCK) WHERE r.session_id = A.session_id)

/*************************************************************************************************************************************************/

SELECT
    A.session_id,
    A.transaction_id,
    C.name AS database_name,
    B.database_transaction_begin_time,
    (CASE B.database_transaction_type
        WHEN 1 THEN 'Read/write transaction'
        WHEN 2 THEN 'Read-only transaction'
        WHEN 3 THEN 'System transaction'
    END) AS database_transaction_type,
    (CASE B.database_transaction_state
        WHEN 1 THEN 'The transaction has not been initialized.'
        WHEN 3 THEN 'The transaction has been initialized but has not generated any log records.'
        WHEN 4 THEN 'The transaction has generated log records.'
        WHEN 5 THEN 'The transaction has been prepared.'
        WHEN 10 THEN 'The transaction has been committed.'
        WHEN 11 THEN 'The transaction has been rolled back.'
        WHEN 12 THEN 'The transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted.'
    END) AS database_transaction_state,
    B.database_transaction_log_record_count
FROM
    sys.dm_tran_session_transactions A
    JOIN sys.dm_tran_database_transactions B ON A.transaction_id = B.transaction_id
    JOIN sys.databases C ON B.database_id = C.database_id 

/*************************************************************************************************************************************************/

SELECT
    A.session_id,
    A.transaction_id,
    C.name AS database_name,
    B.database_transaction_begin_time,
    (CASE B.database_transaction_type
        WHEN 1 THEN 'Read/write transaction'
        WHEN 2 THEN 'Read-only transaction'
        WHEN 3 THEN 'System transaction'
    END) AS database_transaction_type,
    (CASE B.database_transaction_state
        WHEN 1 THEN 'The transaction has not been initialized.'
        WHEN 3 THEN 'The transaction has been initialized but has not generated any log records.'
        WHEN 4 THEN 'The transaction has generated log records.'
        WHEN 5 THEN 'The transaction has been prepared.'
        WHEN 10 THEN 'The transaction has been committed.'
        WHEN 11 THEN 'The transaction has been rolled back.'
        WHEN 12 THEN 'The transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted.'
    END) AS database_transaction_state,
    B.database_transaction_log_record_count
FROM
    (sys.dm_tran_session_transactions A
    right JOIN sys.dm_tran_database_transactions B  ON A.transaction_id = B.transaction_id)
    inner JOIN sys.databases C ON B.database_id = C.database_id 


/*************************************************************************************************************************************************/


 -- Determining the amount of free space in tempdb
SELECT SUM(unallocated_extent_page_count) AS [free pages],
  (SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by the version store
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
  (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by internal objects
SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
  (SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by user objects
SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
  (SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;
/**********************************************************************************************************/
-- Obtaining the space consumed by internal objects in all currently running tasks in each session
SELECT session_id,
  SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
  SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count
FROM sys.dm_db_task_space_usage
GROUP BY session_id;

-- Obtaining the space consumed by internal objects in the current session for both running and completed tasks
SELECT R2.session_id,
  R1.internal_objects_alloc_page_count
  + SUM(R2.internal_objects_alloc_page_count) AS session_internal_objects_alloc_page_count,
  R1.internal_objects_dealloc_page_count
  + SUM(R2.internal_objects_dealloc_page_count) AS session_internal_objects_dealloc_page_count
FROM sys.dm_db_session_space_usage AS R1
INNER JOIN sys.dm_db_task_space_usage AS R2 ON R1.session_id = R2.session_id
GROUP BY R2.session_id, R1.internal_objects_alloc_page_count,
  R1.internal_objects_dealloc_page_count;;

