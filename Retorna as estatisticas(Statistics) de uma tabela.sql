/*Retorda as estatisticas das tabelas*/
SELECT DISTINCT st.[NAME]
	,STP.ROWS
	,STP.ROWS_SAMPLED
	,' UPDATE STATISTICS ' + '[' + ss.name + ']' + '.[' + 
	OBJECT_NAME(st.object_id) + ']' + ' ' + '[' + st.name + ']' + ' WITH FULLSCAN'
FROM SYS.STATS AS ST
CROSS APPLY SYS.DM_DB_STATS_PROPERTIES(ST.OBJECT_ID, ST.STATS_ID) AS STP
JOIN SYS.TABLES STA ON st.[object_id] = sta.object_id
JOIN sys.schemas ss ON ss.schema_id = STA.schema_id
WHERE [ROWS] <> ROWS_SAMPLED AND 
STA.NAME IN ('aa_Solicitacoes')
ORDER BY [ROWS] DESC

