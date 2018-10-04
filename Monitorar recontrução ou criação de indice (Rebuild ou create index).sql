SELECT node_id
          ,physical_operator_name
		  , SUM(row_count) row_count
		  , SUM(estimate_row_count) AS estimate_row_count
		  , CAST(SUM(row_count)*100 AS float)/SUM(estimate_row_count)  percent_completed
FROM sys.dm_exec_query_profiles   
WHERE session_id= (54)
GROUP BY node_id,physical_operator_name  
ORDER BY node_id;