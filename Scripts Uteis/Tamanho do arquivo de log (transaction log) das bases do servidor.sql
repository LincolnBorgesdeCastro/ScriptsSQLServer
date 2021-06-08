
SELECT 
DB_ID(dbs.[name]) AS DatabaseID,
dbs.[name] AS dbName, 
dbs.log_reuse_wait_desc,
CONVERT(DECIMAL(18,2), p2.cntr_value/1024.0) AS [Log Size (MB)],
CONVERT(DECIMAL(18,2), p1.cntr_value/1024.0) AS [Log Size Used (MB)]
FROM sys.databases AS dbs WITH (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS p1 WITH (NOLOCK) ON dbs.name = p1.instance_name
INNER JOIN sys.dm_os_performance_counters AS p2 WITH (NOLOCK) ON dbs.name = p2.instance_name
WHERE p1.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND p2.counter_name LIKE N'Log File(s) Size (KB)%'
AND p2.cntr_value > 0 
order by (p2.cntr_value - p1.cntr_value) desc
