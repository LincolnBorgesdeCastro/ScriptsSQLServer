USE OSLFT
GO

Select count(*) from [OSLFT].DBO.[OSLTM_SERVEREVENTEXECUTED] --with (nolock)
                                 
Select count(*) from [OSLFT].DBO.[OSLTM_WEBSCREENCLIENTEXECUTED]  --with (nolock)

-- Estava dando um alto IO por que a tabela estava enorme mesmo sem dados nenhum. Rodei o truncate e resolveu.

--TRUNCATE table [OSLTM_SERVEREVENTEXECUTED]
--TRUNCATE table [OSLTM_WEBSCREENCLIENTEXECUTED]

sp_spaceused 'OSLTM_SERVEREVENTEXECUTED', true

OSLTM_SERVEREVENTEXECUTED	0                   	17264 KB	14624 KB	48 KB	2592 KB
OSLTM_SERVEREVENTEXECUTED	0                   	 3312 KB	 2960 KB	48 KB	 304 KB

/************************************************************************************************************/

select counter_name ,cntr_value,cast((cntr_value/1024.0)/1024.0 as numeric(8,2)) as Gb
from sys.dm_os_performance_counters
where counter_name like '%server_memory%';

SELECT cntr_value AS 'Page Life Expectancy'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Page life expectancy'


SELECT  type, SUM(pages_kb)/1024. AS [SPA Mem, MB]
FROM sys.dm_os_memory_clerks
GROUP BY type
HAVING  SUM(pages_kb)  > 40000 -- Só os maiores consumidores de memória
ORDER BY SUM(pages_kb) DESC

SELECT  SUM(pages_kb)/1024. AS [SPA Mem, KB],SUM(pages_kb)/1024. AS [MPA Mem, KB] FROM sys.dm_os_memory_clerks


SELECT DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)] 
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4 -- exclude system databases
AND database_id <> 32767 -- exclude ResourceDB
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC;


/***************************************************************/
--CREATE PROCEDURE 
[dbo].[stpLimpa_Memory_Cache] AS
BEGIN
	DECLARE @USERSTORE_TOKENPERM numeric(15,2), @CACHESTORE_SQLCP numeric(15,2)

	set @CACHESTORE_SQLCP = (SELECT  SUM(pages_kb)/1024.
	FROM sys.dm_os_memory_clerks
	WHERE type = 'CACHESTORE_SQLCP')

	set @USERSTORE_TOKENPERM = (SELECT SUM(pages_kb)/1024.
	FROM sys.dm_os_memory_clerks
	WHERE type = 'USERSTORE_TOKENPERM')

	IF @USERSTORE_TOKENPERM > 30
	begin
		--insert into Log_Limpeza_Cache(Dt_Limpeza,Tipo_Cache,Tamanho_MB)
		--select getdate(), 'USERSTORE_TOKENPERM', @USERSTORE_TOKENPERM
		DBCC FREESYSTEMCACHE('TokenAndPermUserStore')
	end

	IF @CACHESTORE_SQLCP > 60
	begin
		--insert into Log_Limpeza_Cache(Dt_Limpeza,Tipo_Cache,Tamanho_MB)
		--select getdate(), 'CACHESTORE_SQLCP', @CACHESTORE_SQLCP

		DBCC FREESYSTEMCACHE('SQL Plans')
	end

END

CHECKPOINT