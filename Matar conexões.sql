DECLARE	@spid INT
DECLARE cr CURSOR FOR
SELECT spid
FROM master..sysprocesses
WHERE dbid = db_id('SERP')
OPEN cr
FETCH NEXT FROM cr INTO @spid
WHILE @@fetch_status = 0
BEGIN
EXEC('kill '+@spid)
FETCH NEXT FROM cr INTO @spid
END
CLOSE cr
DEALLOCATE cr


/**************************************************************/

CREATE TABLE #TmpWho
(spid INT, ecid INT, status VARCHAR(150), loginame VARCHAR(150),
hostname VARCHAR(150), blk INT, dbname VARCHAR(150), cmd VARCHAR(150))
INSERT INTO #TmpWho
EXEC sp_who
DECLARE @spid INT
DECLARE @tString VARCHAR(15)
DECLARE @getspid CURSOR
SET @getspid =   CURSOR FOR
SELECT spid
FROM #TmpWho
WHERE dbname = 'mydb'OPEN @getspid
FETCH NEXT FROM @getspid INTO @spid
WHILE @@FETCH_STATUS = 0
BEGIN
SET @tString = 'KILL ' + CAST(@spid AS VARCHAR(5))
EXEC(@tString)
FETCH NEXT FROM @getspid INTO @spid
END
CLOSE @getspid
DEALLOCATE @getspid
DROP TABLE #TmpWho
GO