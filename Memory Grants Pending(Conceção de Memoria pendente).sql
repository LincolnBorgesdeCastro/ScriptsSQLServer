
SELECT @@SERVERNAME AS [Server Name],
cntr_value AS [Memory Grants Pending]
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] LIKE N'%Memory Manager%'
AND counter_name = N'Memory Grants Pending'



SELECT mg.session_id
,mg.granted_memory_kb
,mg.requested_memory_kb
,mg.ideal_memory_kb
,mg.request_time
,mg.grant_time
,mg.query_cost
,mg.dop
,st.[TEXT]
,qp.query_plan
FROM sys.dm_exec_query_memory_grants AS mg
CROSS APPLY sys.dm_exec_sql_text(mg.plan_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY mg.required_memory_kb DESC;