/********************************************************************************
* Descrição: Este script cria uma procedure lista todas as tabelas que possuem  *
*  uma determinada								*
*coluna. 									*
*										*
* Exemplo de como executar: EXEC Find_Columns	'au_lname'			*
*										*
* ///// Lista todas as tabelas que possuem a coluna au_lname			*
********************************************************************************/

CREATE PROC Find_Columns(@column_name sysname)
AS

DECLARE @column		sysname

SET @column = '%' + @column_name + '%'

SELECT a.name AS Column_Name, b.name AS Table_Name
FROM dbo.syscolumns a JOIN dbo.sysobjects b ON a.id = b.id
WHERE a.name LIKE @column
AND b.xtype = 'U'
ORDER BY table_name
GO

-- Se preferir também é possível usar o script sem criar uma procedure
-- Basta substituir City pelo nome da coluna a ser pesquisada

DECLARE @column		sysname
SET @column = '%City%'

SELECT a.name AS Column_Name, b.name AS Table_Name
FROM dbo.syscolumns a JOIN dbo.sysobjects b ON a.id = b.id
WHERE a.name LIKE @column
AND b.xtype = 'U'
ORDER BY table_name
GO