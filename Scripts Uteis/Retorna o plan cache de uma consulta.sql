/*Script que retorna o plan cache de uma consulta */

/*Para o 2019 pode descomentar  sys.dm_exec_query_plan_stats*/

SELECT *
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
--CROSS APPLY sys.dm_exec_query_plan_stats(plan_handle) AS qps 
where st.text like 'Select s%'
GO


