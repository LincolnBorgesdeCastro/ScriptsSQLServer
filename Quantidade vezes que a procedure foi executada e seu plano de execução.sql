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