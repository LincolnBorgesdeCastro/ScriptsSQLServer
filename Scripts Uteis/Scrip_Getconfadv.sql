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
EXEC master..xp_readerrorlog 2
GO
EXEC master..xp_readerrorlog 3
GO
EXEC master..xp_readerrorlog 4
GO
EXEC master..xp_readerrorlog 5
GO
EXEC master..xp_readerrorlog 6
GO
PRINT 'This may take a few moments...'
PRINT 'Start time: ' + CONVERT (varchar, GETDATE(), 109)
PRINT ''
GO
IF OBJECT_ID ('tempdb..#sp_tmpregread') IS NOT NULL DROP PROC dbo.#sp_tmpregread 
IF OBJECT_ID ('tempdb..#sp_tmpregenumvalues') IS NOT NULL DROP PROC dbo.#sp_tmpregenumvalues 
GO
-- Create temporary stored procedures in tempdb 
CREATE PROCEDURE dbo.#sp_tmpregread 
  @hive varchar (60), @key nvarchar (2000), @value nvarchar (2000), @data nvarchar (4000) = NULL OUTPUT 
AS
DECLARE @sql70or80xp sysname
DECLARE @sqlcmd nvarchar (4000)
IF CHARINDEX ('7.00.', @@VERSION) = 0
  SET @sql70or80xp = 'master..xp_instance_regread'
ELSE
  SET @sql70or80xp = 'master..xp_regread'
SET @sqlcmd = N'EXEC ' + @sql70or80xp + N' @P1, @P2, @P3' 
EXEC sp_executesql @sqlcmd, 
  N'@P1 varchar (40), @P2 nvarchar (2000), @P3 nvarchar (2000)', 
  @hive, @key, @value 
PRINT ''
GO
CREATE PROCEDURE dbo.#sp_tmpregenumvalues 
  @hive varchar (60), @key nvarchar (2000)
AS
DECLARE @sql70or80xp sysname
DECLARE @sqlcmd nvarchar (4000)
IF CHARINDEX ('7.00.', @@VERSION) = 0
  SET @sql70or80xp = 'master..xp_instance_regenumvalues'
ELSE
  SET @sql70or80xp = 'master..xp_regenumvalues'
SET @sqlcmd = N'EXEC ' + @sql70or80xp + N' @P1, @P2' 
EXEC sp_executesql @sqlcmd, 
  N'@P1 varchar (40), @P2 nvarchar (2000)', 
  @hive, @key
GO
SET NOCOUNT ON
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
PRINT '==== Active Trace Flags'
DBCC TRACESTATUS(-1)
GO
PRINT ''
PRINT '==== sp_helpsort'
EXEC sp_helpsort
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
PRINT '==== sp_helpextendedproc'
EXEC sp_helpextendedproc
GO
PRINT ''
PRINT '==== ::fn_virtualservernodes()'
SELECT * FROM ::fn_virtualservernodes()
GO
PRINT ''
PRINT '==== sysdevices'
SELECT * from master..sysdevices
GO
PRINT '==== sysdatabases'
SELECT * from master..sysdatabases
GO
IF (CHARINDEX('6.5', @@VERSION) = 1) OR (CHARINDEX('6.0', @@VERSION) = 1)
BEGIN
  PRINT '==== sysusages'
  SELECT * from master..sysusages
END
GO
PRINT ''
PRINT '==== Registry Information'
waitfor delay '00:00:02'
PRINT '======== SQL CurentVersion (HKLM\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion', 'CurrentVersion'
GO
PRINT '======== SQL commandline args (HKLM\SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\Parameters)'
EXEC dbo.#sp_tmpregenumvalues  'HKEY_LOCAL_MACHINE', 
  'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\Parameters'
GO
PRINT '======== Initial SQL installation path (HKLM\SOFTWARE\Microsoft\MSSQLServer\Setup\SQLPath)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'SOFTWARE\Microsoft\MSSQLServer\Setup', 'SQLPath'
GO
PRINT '======== Default netlib and server aliases (HKLM\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo)'
EXEC dbo.#sp_tmpregenumvalues  'HKEY_LOCAL_MACHINE', 
  'Software\Microsoft\MSSQLServer\Client\ConnectTo'
GO
PRINT '======== NT ProductType and ProductSuite (Ent ed, Trm srv, etc - HKLM\System\CurrentControlSet\Control\ProductOptions)'
EXEC dbo.#sp_tmpregenumvalues  'HKEY_LOCAL_MACHINE', 
  'System\CurrentControlSet\Control\ProductOptions'
GO
PRINT '======== NT SystemRoot (HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRoot)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'Software\Microsoft\Windows NT\CurrentVersion', 'SystemRoot'
GO
PRINT '======== NT CurrentVersion (HKLM\Software\Microsoft\Windows NT\CurrentVersion\CurrentVersion)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'Software\Microsoft\Windows NT\CurrentVersion', 'CurrentVersion'
GO
PRINT '======== NT ANSI code page (HKLM\System\CurrentControlSet\Control\Nls\CodePage)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'System\CurrentControlSet\Control\Nls\CodePage', 'ACP'
GO
PRINT '======== NT OEM code page (HKLM\System\CurrentControlSet\Control\Nls\CodePage)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'System\CurrentControlSet\Control\Nls\CodePage', 'OEMCP'
GO
PRINT '======== DB-Lib settings (HKLM\SOFTWARE\Microsoft\MSSQLServer\Client\DB-Lib)'
EXEC dbo.#sp_tmpregenumvalues  'HKEY_LOCAL_MACHINE', 
  'SOFTWARE\Microsoft\MSSQLServer\Client\DB-Lib' 
GO
PRINT '======== MDAC version information (HKLM\Software\Microsoft\DataAccess)'
EXEC dbo.#sp_tmpregenumvalues  'HKEY_LOCAL_MACHINE', 
  'Software\Microsoft\DataAccess'
GO
PRINT '======== Server time bias (ActiveTimeBias, includes daylight savings -- minutes)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'SYSTEM\CurrentControlSet\Control\TimeZoneInformation', 'ActiveTimeBias'
PRINT '======== Server time bias (Bias, ignores daylight savings -- minutes)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE', 
  'SYSTEM\CurrentControlSet\Control\TimeZoneInformation', 'Bias'
GO
PRINT '======== SQL license info'
PRINT '(7.0)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE',
  'SYSTEM\CurrentControlSet\Services\LicenseInfo\MSSQL7.00', 'ConcurrentLimit'
PRINT '(6.5)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE',
  'SYSTEM\CurrentControlSet\Services\LicenseInfo\MSSQL6.50', 'ConcurrentLimit'
PRINT '(8.0)'
EXEC dbo.#sp_tmpregread 'HKEY_LOCAL_MACHINE',
  'SOFTWARE\Microsoft\Microsoft SQL Server\80\MSSQLLicenseInfo\MSSQL8.00',
   'ConcurrentLimit'
GO
PRINT ''
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
PRINT '==== Check for hypothetical indexes (error expected on 6.5)'
GO
EXEC master..sp_MSforeachdb @command1 = 'PRINT ''==== Hypothetical indexes in ?''', 
  @command2 = 'SELECT CASE WHEN i.name LIKE ''hind_c_%'' 
    THEN ''drop index ['' ELSE ''drop statistics ['' END
    + o.name + ''].['' + i.name + '']'' 
    FROM ?.dbo.sysindexes i INNER JOIN ?.dbo.sysobjects o ON i.id = o.id
    WHERE i.name LIKE ''hind_%'' 
    AND ((i.status & 0x40 = 0x40) OR (i.status & (0x4000+0x2000) = 0))'
GO
PRINT ''
PRINT '==== sp_helpserver'
EXEC master..sp_helpserver
GO
PRINT ''
PRINT '==== Linked server properties (error expected on SQL 6.5)'
PRINT ''
PRINT '======== sp_helplinkedservers'
EXEC master..sp_linkedservers
PRINT ''
PRINT '======== sp_helplinkedsrvlogin'
EXEC master..sp_helplinkedsrvlogin
PRINT ''
PRINT '======== xp_enum_oledb_providers'
EXEC master..xp_enum_oledb_providers
PRINT ''
PRINT '======== OLEDB provider SQL registry properties'
DECLARE @sql70or80xp sysname
IF CHARINDEX ('7.00.', @@VERSION) = 0
  SET @sql70or80xp = 'master..xp_instance_'
ELSE
  SET @sql70or80xp = 'master..xp_'
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE name like '#providers%') DROP TABLE #providers 
CREATE TABLE #providers
  (prov_name varchar(255), parse_name varchar(255), prov_descr text)
INSERT INTO #providers 
EXEC master..xp_enum_oledb_providers
DECLARE @prov_name varchar(255)
DECLARE @regpath varchar(4000)
DECLARE curs INSENSITIVE CURSOR 
FOR SELECT prov_name FROM #providers
FOR READ ONLY
OPEN curs
FETCH NEXT FROM curs INTO @prov_name
WHILE (@@FETCH_STATUS = 0)
BEGIN
  PRINT ''
  PRINT '======== Registry properties for provider ' + @prov_name
  SET @regpath = 'Software\Microsoft\MSSQLServer\Providers\' + @prov_name
  EXEC ('EXEC ' + @sql70or80xp + 'regenumvalues ''HKEY_LOCAL_MACHINE'', ''' + @regpath + '''')
  FETCH NEXT FROM curs INTO @prov_name
END
CLOSE curs
DEALLOCATE curs
GO
PRINT ''
PRINT '==== PINNED TABLES'
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
      SELECT @cmd = 'Checking database ' + @dbname + ' for pinned tables'
      PRINT @cmd
      SELECT @cmd = 'if exists (select * from ' + @dbname
      SELECT @cmd = @cmd + '.dbo.sysobjects where (type = ''S'' OR type = ''U'') and sysstat & 0x200 = 512)'
      SELECT @cmd = @cmd + 'select name, id, uid from ' + @dbname
      SELECT @cmd = @cmd + '.dbo.sysobjects where (type = ''S'' OR type = ''U'') and sysstat & 0x200 = 512 '
      SELECT @cmd = @cmd + 'else print ''None found.'''
      EXEC(@cmd)
      FETCH db_cursor INTO @dbname
    END
    CLOSE db_cursor
  END
  DEALLOCATE db_cursor
END
GO
PRINT ''
PRINT '==== sp_lock'
EXEC sp_lock
GO
PRINT ''
PRINT '==== sysprocesses'
SELECT * FROM master.dbo.sysprocesses
GO
SET NOCOUNT ON
IF OBJECT_ID ('tempdb..#inputbuffers') IS NOT NULL DROP TABLE #inputbuffers
CREATE TABLE #inputbuffers (EventType varchar (30), Parameters varchar (20), EventInfo ntext)
PRINT ''
PRINT '==== DBCC INPUTBUFFER (n)'
DECLARE @spid int
DECLARE @cmd varchar(255)
DECLARE spid_curs INSENSITIVE CURSOR  FOR 
  SELECT CONVERT (int, spid) AS spid 
  FROM master..sysprocesses WHERE spid > 6
OPEN spid_curs
FETCH NEXT FROM spid_curs INTO @spid
WHILE (@@fetch_status <> -1)
BEGIN
  IF (@@fetch_status <> -2)
  BEGIN
    PRINT ''
    SET @cmd = 'DBCC INPUTBUFFER (' + CONVERT (varchar, @spid) + ')'
    PRINT '======== ' + @cmd
    TRUNCATE TABLE #inputbuffers 
    INSERT INTO #inputbuffers 
    EXEC (@cmd)
    SELECT * FROM #inputbuffers 
  END
  FETCH NEXT FROM spid_curs INTO @spid
END
CLOSE spid_curs
DEALLOCATE spid_curs
GO
PRINT ''
PRINT '==== DBCC PSS(n)'
DECLARE @spid int
DECLARE @cmd varchar(255)
DECLARE spid_curs INSENSITIVE CURSOR  FOR 
  SELECT CONVERT (int, spid) AS spid 
  FROM master..sysprocesses WHERE spid > 6
OPEN spid_curs
FETCH NEXT FROM spid_curs INTO @spid
WHILE (@@fetch_status <> -1)
BEGIN
  IF (@@fetch_status <> -2)
  BEGIN
    PRINT ''
    SET @cmd = 'DBCC PSS (0, ' + CONVERT (varchar, @spid) + ')'
    PRINT '======== ' + @cmd
     EXEC (@cmd)
  END
  FETCH NEXT FROM spid_curs INTO @spid
END
CLOSE spid_curs
DEALLOCATE spid_curs
GO
PRINT ''
PRINT '==== DBCC OPENTRAN (<database>)'
DBCC TRACEON (3604)
GO
PRINT ''
DECLARE @dbname sysname
DECLARE @tmpstr varchar(255)  
-- Note: won't work for 7.0 db's with Unicode names, 
-- but nvarchar won't work on 6.5.
DECLARE db_cursor cursor FOR 
SELECT name FROM master..sysdatabases 
WHERE status&32 + status&64 + status&128 + status&256 + status&512 = 0
  AND name NOT IN ('master', 'model', 'msdb', 'pubs', 'Northwind')  
OPEN db_cursor 
FETCH NEXT FROM db_cursor INTO @dbname
WHILE (@@fetch_status <> -1)
BEGIN
  IF (@@fetch_status <> -2)
  BEGIN 
    SELECT @tmpstr = 'DBCC OPENTRAN (' + @dbname + ')'
    PRINT @tmpstr
    EXEC (@tmpstr)
    PRINT ''
  END
  FETCH NEXT FROM db_cursor INTO @dbname
END
CLOSE db_cursor 
DEALLOCATE db_cursor 
GO
PRINT ''
PRINT '==== DBCC SQLPERF (THREADS)'
DBCC SQLPERF (THREADS)
PRINT ''
PRINT '==== DBCC SQLPERF (NETSTATS)'
DBCC SQLPERF (NETSTATS)
PRINT ''
PRINT '==== DBCC SQLPERF (IOSTATS)'
DBCC SQLPERF (IOSTATS)
IF (CHARINDEX('6.50', @@VERSION) = 0)
BEGIN
  PRINT ''
  PRINT '==== syscacheobjects'
  SELECT * FROM master.dbo.syscacheobjects
  PRINT ''
  PRINT '==== DBCC MEMORYSTATUS'
  DBCC MEMORYSTATUS
  PRINT ''
  PRINT '==== DBCC SQLPERF (UMSSTATS)'
  DBCC SQLPERF (UMSSTATS)
  PRINT ''
  PRINT '==== DBCC SQLPERF (WAITSTATS)'
  DBCC SQLPERF (WAITSTATS)
  PRINT ''
  PRINT '==== DBCC SQLPERF (LRUSTATS)'
  DBCC SQLPERF (LRUSTATS)
  PRINT ''
  PRINT '==== sysperfinfo snapshot #1'
  PRINT CONVERT (varchar, GETDATE(), 109)
  SELECT * FROM master.dbo.sysperfinfo
  WAITFOR DELAY '0:0:10'
  PRINT '==== sysperfinfo snapshot #2'
  PRINT CONVERT (varchar, GETDATE(), 109)
  SELECT * FROM master.dbo.sysperfinfo
END
GO
PRINT ''
PRINT '==== NET START'
EXEC master..xp_cmdshell 'NET START'
GO
DECLARE @IsFullTextInstalled int
PRINT ''
PRINT '==== Full-text information'
PRINT '======== FULLTEXTSERVICEPROPERTY (IsFulltextInstalled)'
SET @IsFullTextInstalled = FULLTEXTSERVICEPROPERTY ('IsFulltextInstalled')
PRINT CASE @IsFullTextInstalled 
    WHEN 1 THEN '1 - Yes' 
    WHEN 0 THEN '0 - No' 
    ELSE 'Unknown'
  END
IF (@IsFullTextInstalled = 1)
BEGIN
  PRINT '======== FULLTEXTSERVICEPROPERTY (ResourceUsage)'
  PRINT CASE FULLTEXTSERVICEPROPERTY ('ResourceUsage')
      WHEN 0 THEN '0 - MSSearch not running'
      WHEN 1 THEN '1 - Background'
      WHEN 2 THEN '2 - Low'
      WHEN 3 THEN '3 - Normal'
      WHEN 4 THEN '4 - High'
      WHEN 5 THEN '5 - Highest'
      ELSE CONVERT (varchar, FULLTEXTSERVICEPROPERTY ('ResourceUsage'))
    END
  PRINT '======== FULLTEXTSERVICEPROPERTY (ConnectTimeout)'
  PRINT CONVERT (varchar, FULLTEXTSERVICEPROPERTY ('ConnectTimeout')) + ' sec'
  PRINT ''
  DECLARE @dbname varchar(31)
  DECLARE @cmd varchar(8000)
  DECLARE db_cursor CURSOR FOR
  SELECT name FROM master.dbo.sysdatabases WHERE DATABASEPROPERTY (name, 'IsFulltextEnabled') = 1
  FOR READ ONLY
  IF 0 = @@ERROR
  BEGIN
    OPEN db_cursor
    IF 0 = @@ERROR
    BEGIN
      FETCH db_cursor INTO @dbname
      WHILE @@FETCH_STATUS <> -1 AND 0 = @@ERROR
      BEGIN
        SELECT @cmd = '
USE ' + + @dbname + '
PRINT ''============ sp_help_fulltext_catalogs''
EXEC sp_help_fulltext_catalogs
PRINT ''============ sp_help_fulltext_tables''
EXEC sp_help_fulltext_tables
PRINT ''============ sp_help_fulltext_columns''
EXEC sp_help_fulltext_columns
PRINT ''============ Catalog properties''
SELECT name, FULLTEXTCATALOGPROPERTY (''ftdata1'', ''ItemCount'') AS ItemCount, 
  CONVERT (varchar, FULLTEXTCATALOGPROPERTY (''ftdata1'', ''IndexSize'')) + ''MB'' AS IndexSize, 
  FULLTEXTCATALOGPROPERTY (''ftdata1'', ''UniqueKeyCount'') AS [Unique word count] 
FROM sysfulltextcatalogs 
USE master'
        PRINT '======== Full text information for db [' + @dbname + ']'
        EXEC(@cmd)
        FETCH db_cursor INTO @dbname
      END
      CLOSE db_cursor
    END
    DEALLOCATE db_cursor
  END
END
GO
PRINT ''
PRINT '==== GETDATE()'
PRINT CONVERT (varchar, GETDATE(), 109)
