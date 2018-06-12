--https://dbasqlserverbr.com.br/blog/top-10-scripts-de-indices-que-todos-dbas-precisam-saber-sql-server/

DECLARE @Collation VARCHAR(30) = 'SQL_Latin1_General_CP1_CI_AI'
--SET @Collation = CAST((SELECT DATABASEPROPERTYEX('BD','Collation')) AS VARCHAR(30))

-- Gerando as instruções de ALTER
-- Gerar o ALTER <Tabela> e ALTER COLUMN <Coluna>
SELECT 'ALTER ' + TABLE_NAME + ' ALTER COLUMN ' + COLUMN_NAME + ' ' +

-- Definir a sintaxe do tipo de dados
CASE
WHEN DATA_TYPE IN ('Text','NText') THEN DATA_TYPE
WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN DATA_TYPE + '(MAX)'
ELSE DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(4)) + ')'

-- Especificar a collation
END + ' COLLATE ' + @Collation + ' ' +

-- Especificar a nulabilidade
CASE IS_NULLABLE WHEN 'YES' THEN 'NULL' ELSE 'NOT NULL' END
, *


FROM Information_Schema.Columns

-- Filtrar apenas as colunas textuais
WHERE COLLATION_NAME IS NOT NULL
--and table_name = 'guias'
and table_name = 'receitas'
--order by table_name


/**/
SELECT distinct OBJECT_SCHEMA_NAME(BaseT.[object_id],DB_ID()) AS [Schema], 
 BaseT.[name] AS [table_name], I.[name] AS [index_name], AC.[name] AS [column_name], 
 I.[type_desc]
FROM sys.[tables] AS BaseT 
 INNER JOIN sys.[indexes] I ON BaseT.[object_id] = I.[object_id] 
 INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id] 
 INNER JOIN sys.[all_columns] AC ON BaseT.[object_id] = AC.[object_id] AND IC.[column_id] = AC.[column_id] 
WHERE BaseT.[is_ms_shipped] = 0 AND I.[type_desc] <> 'HEAP'
 and COLLATION_NAME IS NOT NULL
ORDER BY BaseT.[name], I.[index_id], IC.[key_ordinal]
