
SELECT DB_NAME(database_id) DatabaseName,
OBJECT_NAME(object_id) ProcedureName,
cached_time, last_execution_time, execution_count,
total_elapsed_time/execution_count AS avg_elapsed_time,
type_desc
FROM sys.dm_exec_procedure_stats
where DB_NAME(database_id)  is not null
and   OBJECT_NAME(object_id) is not null

ORDER BY execution_count desc;
--ORDER BY avg_elapsed_time desc;

/***************************************************************************/
/***************************************************************************/
/* Com plano de execução */

SELECT TOP 10
t.TEXT QueryName,
s.execution_count AS ExecutionCount,
s.max_elapsed_time AS MaxElapsedTime,
ISNULL(s.total_elapsed_time / 1000 / NULLIF(s.execution_count, 0), 0) AS AvgElapsedTime,
s.creation_time AS LogCreatedOn,
ISNULL(s.execution_count / 1000 / NULLIF(DATEDIFF(s, s.creation_time, GETDATE()), 0), 0) AS FrequencyPerSec
,u.query_plan
FROM sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_query_plan( s.plan_handle ) u
CROSS APPLY sys.dm_exec_sql_text( s.plan_handle ) t

ORDER BY MaxElapsedTime DESC

/***************************************************************************/
/***************************************************************************/
/* Coletar o plan_handle para liberar memoria */
SELECT TOP 10 d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  ,
	plan_handle
FROM sys.dm_exec_procedure_stats AS d  
where OBJECT_NAME(object_id, database_id) = 'up_gvRicPreencheResolucao'
ORDER BY [total_worker_time] DESC;


DBCC FREEPROCCACHE (0x05000C009C2A264850D973EC1800000001000000000000000000000000000000000000000000000000000000)

/***************************************************************************/
/***************************************************************************/