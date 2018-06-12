--This script pulls all data and log files 
--associated with any user db's

BEGIN
CREATE TABLE #FILEINFO
(DatabaseName VARCHAR(100),  
PhysicalFileName NVARCHAR(520),  
FileSizeMB INT,
Growth VARCHAR(100)) 

DECLARE @command VARCHAR(5000)  
SELECT @command = 'Use [' + '?' + '] select ' + '''' + '?' + '''' + ' AS DatabaseName,  
sysfiles.filename AS PhysicalFileName,
CAST(sysfiles.size/128.0 AS int) AS FileSize,
CASE 
	WHEN status & 0x100000 = 0 
		THEN convert(varchar,ceiling((growth * 8192.0)/(1024.0*1024.0))) + '' MB''
	ELSE STR(growth) + '' %''
END growth
FROM dbo.sysfiles'  

INSERT #FILEINFO EXEC sp_MSForEachDB @command  

SELECT * FROM #FILEINFO
order by DatabaseName, PhysicalFileName

DROP TABLE #FILEINFO

END
GO