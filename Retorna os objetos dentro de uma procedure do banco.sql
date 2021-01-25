-- Retorna os objetos dentro de um procedure
;WITH stored_procedures
AS (SELECT
       o.name AS NomeDaProcedure,
       oo.name AS NomeDaTabela,
       ROW_NUMBER() OVER (PARTITION BY o.name, oo.name ORDER BY o.name, oo.name) AS row
FROM sysdepends d
INNER JOIN sysobjects o
       ON o.id = d.id
INNER JOIN sysobjects oo
       ON oo.id = d.depid
WHERE o.xtype = 'P')
SELECT
       NomeDaProcedure,
       NomeDaTabela
FROM stored_procedures
WHERE row = 1
/*Caso queira filtrar por nome da procedure*/
AND NomeDaProcedure = 'sp_atObtemAgendaUsuario'
ORDER BY NomeDaProcedure, NomeDaTabela

GO

Return

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
WHERE --[ROWS] <> ROWS_SAMPLED
--AND 
STA.NAME IN ('receitas')
ORDER BY [ROWS] DESC
