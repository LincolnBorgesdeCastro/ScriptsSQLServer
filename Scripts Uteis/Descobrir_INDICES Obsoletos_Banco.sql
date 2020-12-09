Select
 'drop index ' + stats.table_name + '.' + i.name as DropIndexStatement,
 stats.table_name as TableName,
 i.name as IndexName,
 i.type_desc as IndexType,
 stats.seeks + stats.scans + stats.lookups as TotalAccesses,
 stats.seeks as Seeks,
 stats.scans as Scans,
 stats.lookups as Lookups
 from  (select  i.object_id,
        object_name(i.object_id) as table_name,
        i.index_id,
        sum(i.user_seeks) as seeks,
        sum(i.user_scans) as scans,
        sum(i.user_lookups) as lookups
        from sys.tables t  inner join sys.dm_db_index_usage_stats i on t.object_id = i.object_id
        group by
        i.object_id,
        i.index_id ) 
		as stats inner join sys.indexes i on stats.object_id = i.object_id
                                         and stats.index_id = i.index_id
 where stats.seeks + stats.scans + stats.lookups = 0 --Finds indexes not being used
 and i.type_desc = 'NONCLUSTERED' --Only NONCLUSTERED indexes
 and i.is_primary_key = 0 --Not a Primary Key
 and i.is_unique = 0 --Not a unique index
 and stats.table_name not like 'sys%'
 ORDER BY (stats.seeks + stats.scans + stats.lookups) ASC
 --order by stats.table_name, i.name

 /**********************************************************************************************************************************/

SELECT TOP 100
o.name AS ObjectName
, i.name AS IndexName
, i.index_id AS IndexID
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(s.name) + '.'
+ QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id 
AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = 'nonclustered'
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
And dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups = 0
--ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
ORDER BY p.TableRows DESC
GO
