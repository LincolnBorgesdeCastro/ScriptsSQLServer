

SELECT SCHEMA_NAME(SCHEMA_ID) SchemaName, name ProcedureName,
last_execution_time LastExecuted,
last_elapsed_time LastElapsedTime,
execution_count ExecutionCount,
cached_time CachedTime
FROM sys.dm_exec_procedure_stats ps JOIN
sys.objects o ON ps.object_id = o.object_id
WHERE ps.database_id = DB_ID()
--And cached_time < '2019-11-20'

--Order by last_execution_time
Order by execution_count desc
