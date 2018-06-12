--1. Create Database with exact name and mdf-ldf files
--2. Stop MSSQLSERVER service, replace created mdf file with original one
--3. Start MSSQLSERVER service, the database will be in Suspend mode
--4. From Query Analyzer (QA) execute script
Use master
Go
sp_configure 'allow updates', 1
Reconfigure with override
Go
--5. From QA execute script
Update sysdatabases set status= 32768 where name = 'eSM_DF'
--6. Restart MSSQLSERVER service, the database will be in Emergency mode
--7. Rebuild Log. From QA execute script
DBCC REBUILD_LOG ('eSM_DF', 'E:\SQL2000\MSSQL$SQL2000\Data\eSM_DF_Log.LDF')
--You got a 
--Message - Warning: The log for database 'eSM_DF' has been rebuilt.
--8. From QA execute script
Use master
Go
sp_configure 'allow updates', 0
Go
--9. Clear from Enterprise Manager on database properties options tab Restrict 
--Access checkbox





