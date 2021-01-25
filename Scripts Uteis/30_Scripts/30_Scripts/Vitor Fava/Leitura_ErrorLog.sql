--Procedures para leitura dos arquivos de
--log da Instância de SQL
sp_enumerrorlogs 
sp_readerrorlog 1


--Utilizando as duas stored procedures para fazer uma busca nos arquivos
--de LOG do SQL SERVER
DECLARE @TSQL  NVARCHAR(2000)
DECLARE @lC    INT


CREATE TABLE #TempLog (
      LogDate     DATETIME,
      ProcessInfo NVARCHAR(50),
      [Text] NVARCHAR(MAX))


CREATE TABLE #logF (
      ArchiveNumber     INT,
      LogDate           DATETIME,
      LogSize           INT
)

INSERT INTO #logF  
EXEC sp_enumerrorlogs
SELECT @lC = MIN(ArchiveNumber) FROM #logF


WHILE @lC IS NOT NULL
BEGIN
      INSERT INTO #TempLog
      EXEC sp_readerrorlog @lC
      SELECT @lC = MIN(ArchiveNumber) FROM #logF
      WHERE ArchiveNumber > @lC
END


--Failed login counts. Useful for security audits.
SELECT Text,COUNT(Text) Number_Of_Attempts
FROM #TempLog where
 Text like '%failed%' and ProcessInfo = 'LOGON'
 Group by Text

--Find Last Successful login. Useful to know before deleting "obsolete" accounts.
SELECT Distinct MAX(logdate) last_login,Text
FROM #TempLog
where ProcessInfo = 'LOGON'and Text like '%SUCCEEDED%'
and Text not like '%NT AUTHORITY%'
Group by Text

DROP TABLE #TempLog
DROP TABLE #logF

/*
--Análise de erros críticos no SQL Server Error Log
if object_id('tempdb..#errorLog') is not null DROP TABLE #errorLog; -- this is new syntax in SQL 2016 and later

CREATE TABLE #errorLog (LogDate DATETIME, ProcessInfo VARCHAR(64), [Text] VARCHAR(MAX));

INSERT INTO #errorLog
EXEC sp_readerrorlog 6 -- specify the log number or use nothing for active error log

SELECT *
FROM #errorLog a
WHERE EXISTS (SELECT *
FROM #errorLog b
WHERE [Text] like 'Error:%'
AND a.LogDate = b.LogDate
AND a.ProcessInfo = b.ProcessInfo)
*/
