-- Query Starts with the line "Use master" and continues to the end of this document.
USE master
GO
PRINT ''
PRINT '==== sp_configure (show advanced)'
EXEC sp_configure 'show advanced', 1
RECONFIGURE WITH OVERRIDE
GO
EXEC sp_configure
GO
PRINT 'Errorlogs
---------'
EXEC master..xp_readerrorlog 
GO
EXEC master..xp_readerrorlog 1
GO
PRINT ''
PRINT ''
PRINT '==== SELECT @@version'
PRINT @@VERSION
GO
PRINT ''
PRINT '==== Current login (SUSER_SNAME)'
PRINT SUSER_SNAME ()
GO
PRINT ''
PRINT '==== SQL Server name (@@SERVERNAME)'
PRINT @@SERVERNAME
GO
PRINT ''
PRINT '==== Host (client) machine name (HOST_NAME)'
PRINT HOST_NAME()
GO
PRINT ''
PRINT '==== @@LANGUAGE'
PRINT @@LANGUAGE
GO
PRINT ''
PRINT '==== Get Collate'
select serverproperty('Collation')
GO
PRINT ''
PRINT '==== xp_msver'
EXEC master..xp_msver
GO
PRINT ''
PRINT '==== sp_helpdb'
EXEC sp_helpdb
GO
PRINT ''
PRINT '==== sysdevices'
SELECT * from master..sysdevices
GO
PRINT '==== sysdatabases'
SELECT * from master..sysdatabases
GO
PRINT '==== Get Db options'
DECLARE @dbname varchar(31)
DECLARE @cmd varchar(255)
DECLARE db_cursor CURSOR FOR
SELECT name FROM master.dbo.sysdatabases
FOR READ ONLY
IF 0 = @@ERROR
BEGIN
  OPEN db_cursor
  IF 0 = @@ERROR
  BEGIN
    FETCH db_cursor INTO @dbname
    WHILE @@FETCH_STATUS <> -1 AND 0 = @@ERROR
    BEGIN
      SELECT @cmd = '==== sp_dboption '+ @dbname 
      PRINT @cmd
      SELECT @cmd = 'exec master.dbo.sp_dboption ''' + @dbname + ''''
      EXEC(@cmd)
      FETCH db_cursor INTO @dbname
    END
    CLOSE db_cursor
  END
  DEALLOCATE db_cursor
END
GO
PRINT '==== sp_helpfile for each db (error expected on 6.5)'
GO
EXEC master..sp_MSforeachdb @command1 = 'PRINT ''==== sp_helpfile ?''', 
  @command2 = 'use ? exec sp_helpfile'
GO
PRINT ''
PRINT '==== GETDATE()'
PRINT CONVERT (varchar, GETDATE(), 109)
