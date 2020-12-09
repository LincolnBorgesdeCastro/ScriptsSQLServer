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