SELECT spid, status, blocked, open_tran, program_name, 
        waitresource, waittype, waittime, cmd, lastwaittype, 
        cpu, physical_io,memusage, 
        last_batch=convert(VARCHAR(26), last_batch,121),
        login_time=convert(VARCHAR(26), login_time,121),
        net_address,net_library, 
        dbid, ecid, kpid, hostname, hostprocess, loginame, 
        nt_domain, nt_username, uid, sid,
        sql_handle, stmt_start, stmt_end
    FROM master.dbo.sysprocesses
    WHERE 
        (kpid<>0 OR waittype<>0x0000 OR open_tran<>0) AND (spid>50)

--and status = 'runnable                      '
order by cpu desc

/************************************************************************************************/

dbcc inputbuffer (256)
WITH NO_INFOMSGS

kill 650
/************************************************************************************************/

exec sbd.dbo.up_SBDInputbuffer 650

/************************************************************************************************/


DECLARE @handle VARBINARY(64) = 0x010002000CBFA002B0E25A111100000000000000
DECLARE @start  INT = 100
DECLARE @end    INT = -1
DECLARE @len    INT
                        
SELECT SUBSTRING(text,@start/2,
            CASE WHEN @end > 0    
                THEN  (@end - @start)/2
                ELSE  LEN([text]) 
            END) 
FROM sys.dm_exec_sql_text(@handle)



select
(physical_memory_in_use_kb/1024)Memory_usedby_Sqlserver_MB,
(locked_page_allocations_kb/1024 )Locked_pages_used_Sqlserver_MB,
(total_virtual_address_space_kb/1024 )Total_VAS_in_MB,
process_physical_memory_low,
process_virtual_memory_low
from sys. dm_os_process_memory

select SUM(virtual_memory_reserved_kb)/1024 as VAS_In_MB 
 from
 sys. dm_os_memory_clerks
where type not like '%bufferpool%'

/************************************************************************************************/

SELECT TOP 20
GETDATE() AS 'Collection Date',
qs.execution_count AS 'Execution Count',
SUBSTRING(qt.text,qs.statement_start_offset/2 +1,
(CASE WHEN qs.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
ELSE qs.statement_end_offset END -
qs.statement_start_offset
)/2
) AS 'Query Text',
DB_NAME(qt.dbid) AS 'DB Name',
qs.total_worker_time AS 'Total CPU Time',
qs.total_worker_time/qs.execution_count AS 'Avg CPU Time (ms)',
qs.total_physical_reads AS 'Total Physical Reads',
qs.total_physical_reads/qs.execution_count AS 'Avg Physical Reads',
qs.total_logical_reads AS 'Total Logical Reads',
qs.total_logical_reads/qs.execution_count AS 'Avg Logical Reads',
qs.total_logical_writes AS 'Total Logical Writes',
qs.total_logical_writes/qs.execution_count AS 'Avg Logical Writes',
qs.total_elapsed_time AS 'Total Duration',
qs.total_elapsed_time/qs.execution_count AS 'Avg Duration (ms)',
qp.query_plan AS 'Plan'
FROM sys.dm_exec_query_stats AS qs CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
                                   CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE
qs.execution_count > 50 OR
qs.total_worker_time/qs.execution_count > 100 OR
qs.total_physical_reads/qs.execution_count > 1000 OR
qs.total_logical_reads/qs.execution_count > 1000 OR
qs.total_logical_writes/qs.execution_count > 1000 OR
qs.total_elapsed_time/qs.execution_count > 1000
ORDER BY
qs.execution_count DESC,
qs.total_elapsed_time/qs.execution_count DESC,
qs.total_worker_time/qs.execution_count DESC,
qs.total_physical_reads/qs.execution_count DESC,
qs.total_logical_reads/qs.execution_count DESC,
qs.total_logical_writes/qs.execution_count DESC

/************************************************************************************************/
