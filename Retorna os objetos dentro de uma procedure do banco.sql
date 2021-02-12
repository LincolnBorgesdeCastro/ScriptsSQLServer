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




