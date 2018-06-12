/*
SELECT 
OBJECT_NAME ( i.OBJECT_ID ) AS TableName , 
i.name AS IndexName , 
i.index_id AS IndexID , 
8 * SUM (a.used_pages) /1024 AS 'Indexsize(MB)' 
, 'ALTER INDEX ' + i.name + N' ON ' +  OBJECT_NAME ( i.OBJECT_ID ) + N' REBUILD'
FROM sys.indexes AS i 
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id 
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id 
--AND OBJECT_NAME (i.OBJECT_ID) in ('Guias')
GROUP BY i.OBJECT_ID , i.index_id , i.name 
having (8 * SUM (a.used_pages) /1024 ) > 0
ORDER BY 4 

*/
/*
USE [SIGA]
GO

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

COMMIT

DBCC SHRINKFILE (N'SIGA_Data' , 115000)
GO
*/
/******************************************************************************************************************/
/************************ Reconstrução dos indices **********************************************************************/
/******************************************************************************************************************/
declare @command varchar(4000)
declare cur cursor 
for 
SELECT 
--OBJECT_NAME ( i.OBJECT_ID ) AS TableName , 
--i.name AS IndexName , 
--i.index_id AS IndexID , 
--8 * SUM (a.used_pages) /1024 AS 'Indexsize(MB)' ,
 'ALTER INDEX ' + i.name + N' ON ' +  OBJECT_NAME ( i.OBJECT_ID ) + N' REBUILD'
FROM sys.indexes AS i 
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id 
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id 
where OBJECT_NAME ( i.OBJECT_ID ) not in ('sysrscols', 'sysschobjs','syscolpars','sysobjvalues','sysmultiobjrefs')

GROUP BY i.OBJECT_ID , i.index_id , i.name 
having (8 * SUM (a.used_pages) /1024 ) > 0
ORDER BY (8 * SUM (a.used_pages) /1024)

open cur

fetch cur into @command

while @@FETCH_STATUS = 0
begin    
   if @command is not null EXEC (@command);
   PRINT N'Executed: ' + @command;

   fetch cur into @command
end

close cur
deallocate cur

