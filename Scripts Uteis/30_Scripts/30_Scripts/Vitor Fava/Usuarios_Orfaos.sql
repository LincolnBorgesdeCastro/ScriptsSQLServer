--Tabela temporaria que ira guardar
CREATE TABLE #temp 
(
	DatabaseName NVARCHAR(50),
	UserName NVARCHAR(50)
)

--create statement to run on each database
DECLARE @sql NVARCHAR(500)
SET @sql='SELECT ''?'' AS DBName
, name AS UserName
FROM [?]..sysusers
WHERE (sid  IS NOT NULL AND sid <> 0x0)
AND suser_sname(sid) IS NULL AND
(issqlrole <> 1) AND 
(isapprole <> 1) AND 
(name <> ''INFORMATION_SCHEMA'') AND 
(name <> ''guest'') AND 
(name <> ''sys'') AND 
(name <> ''dbo'') AND 
(name <> ''system_function_schema'')
ORDER BY name
'
--insert the results from each database to temp table
INSERT INTO #temp
EXEC SP_MSforeachDB @sql

--return results
SELECT * FROM #temp
--DROP TABLE #temp



