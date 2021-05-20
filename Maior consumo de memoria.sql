SELECT top 50 OBJECT_NAME(p.[object_id]) AS [ObjectName] ,
p.index_id ,
COUNT(*) / 128 AS [Buffer size(MB)] ,
COUNT(*) AS [Buffer_count]
FROM sys.allocation_units AS a
INNER JOIN sys.dm_os_buffer_descriptors
 AS b ON a.allocation_unit_id = b.allocation_unit_id
INNER JOIN sys.partitions AS p ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID()
AND p.[object_id] > 100
GROUP BY p.[object_id] ,
p.index_id
ORDER BY buffer_count DESC ;


--CLERKS
-- SQL Server 2012 version
SELECT TOP(10) [type] as [Memory Clerk Name], SUM(pages_kb)/1024 AS [SPA Memory (MB)]
FROM sys.dm_os_memory_clerks
GROUP BY [type]
ORDER BY SUM(pages_kb) DESC;



--DMVs
SELECT total_physical_memory_kb/1024 [Total Physical Memory in MB],
available_physical_memory_kb/1024 [Physical Memory Available in MB],
system_memory_state_desc
FROM sys.dm_os_sys_memory;


SELECT physical_memory_in_use_kb/1024 [Physical Memory Used in MB],
process_physical_memory_low [Physical Memory Low],
process_virtual_memory_low [Virtual Memory Low]
FROM sys.dm_os_process_memory;


SELECT committed_kb/1024 [SQL Server Committed Memory in MB],
committed_target_kb/1024 [SQL Server Target Committed Memory in MB]
FROM sys.dm_os_sys_info;