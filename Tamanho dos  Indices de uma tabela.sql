SELECT 
OBJECT_NAME ( i.OBJECT_ID ) AS TableName , 
i.name AS IndexName , 
i.index_id AS IndexID , 
8 * SUM (a.used_pages) /1024 AS 'Indexsize(MB)' 
FROM sys.indexes AS i 
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id 
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id 
WHERE OBJECT_NAME (i.OBJECT_ID) in ('Guias')
GROUP BY i.OBJECT_ID , i.index_id , i.name 
ORDER BY OBJECT_NAME (i.OBJECT_ID), i.index_id


/*
SELECT i.name AS IndexName
, SUM(page_count * 8) AS IndexSizeKB 
FROM sys.dm_db_index_physical_stats( db_id(), object_id('dbo.TableName'), NULL, NULL, 'DETAILED') AS s 
JOIN sys.indexes AS i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id 
GROUP BY i.name 
ORDER BY i.name


https://dbasqlserverbr.com.br/blog/top-10-scripts-de-indices-que-todos-dbas-precisam-saber-sql-server/
*/


