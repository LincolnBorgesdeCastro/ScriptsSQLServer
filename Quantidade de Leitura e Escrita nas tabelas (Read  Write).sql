
SELECT OBJECT_SCHEMA_NAME(s.object_id) AS SchemaName,
OBJECT_NAME(s.object_id) AS TableName,
SUM(s.user_seeks + s.user_scans + s.user_lookups) AS Reads,
SUM(s.user_updates) AS Writes
FROM sys.dm_db_index_usage_stats AS s
WHERE objectproperty(s.object_id,'IsUserTable') = 1
AND s.database_id = db_ID()
GROUP BY OBJECT_SCHEMA_NAME(s.object_id), OBJECT_NAME(s.object_id)
ORDER BY Reads DESC, Writes DESC
