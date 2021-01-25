

--Listar 10 consultas que mais utilizam I/O
SELECT TOP 10
DB_NAME(st.dbid) AS database_name,
creation_time,
last_execution_time,
total_logical_reads AS [LogicalReads] ,
total_logical_writes AS [LogicalWrites] ,
execution_count,
total_logical_reads+total_logical_writes AS [AggIO],
(total_logical_reads+total_logical_writes)/(execution_count+0.0) AS [AvgIO],
st.TEXT,
st.objectid AS OBJECT_ID
FROM
sys.dm_exec_query_stats qs
CROSS APPLY
sys.dm_exec_sql_text(sql_handle) st
WHERE
total_logical_reads+total_logical_writes > 0
AND
sql_handle IS NOT NULL
ORDER BY
[AggIO] DESC