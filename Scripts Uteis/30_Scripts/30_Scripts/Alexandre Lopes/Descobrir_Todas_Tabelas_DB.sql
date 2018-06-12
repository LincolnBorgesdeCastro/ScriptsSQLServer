--
-- Script em T-SQL que lista todas as tabelas de um database
-- 
USE DB_Mundo; 
SELECT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName 
FROM sys.tables 
ORDER BY SchemaName, TableName; 
GO
