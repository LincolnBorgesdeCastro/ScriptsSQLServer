--Para desabilitar todas as constraints e triggers de todas as tabelas do banco:

exec sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL"
exec sp_msforeachtable "ALTER TABLE ? DISABLE TRIGGER ALL"

--Para habilitar:

exec sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL"
exec sp_msforeachtable "ALTER TABLE ? ENABLE TRIGGER ALL"


--http://www.ericksasse.com.br/como-desabilitar-rapidamente-constraints-e-triggers-de-um-banco-sql-server/

--Documentação do stored_procedure sp_msforeachtable
--http://www.databasejournal.com/features/mssql/article.php/3441031/SQL-Server-Undocumented-Stored-Procedures-spMSforeachtable-and-spMSforeachdb.htm

