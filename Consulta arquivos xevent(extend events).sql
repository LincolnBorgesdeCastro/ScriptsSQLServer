DECLARE 
    @TimeZone INT = DATEDIFF(HOUR, GETUTCDATE(), GETDATE()),
    @Dt_Ultimo_Registro DATETIME = '2020-07-07 00:00:00'


IF (OBJECT_ID('tempdb..#Eventos') IS NOT NULL) DROP TABLE #Eventos
;WITH CTE AS (
    SELECT CONVERT(XML, event_data) AS event_data
    FROM sys.fn_xe_file_target_read_file(N'\\catar\Auditorias\ASSISTENCIA\DDLChanges_*.xel', NULL, NULL, NULL)
)
SELECT
    DATEADD(HOUR, @TimeZone, CTE.event_data.value('(//event/@timestamp)[1]', 'datetime')) AS Dt_Evento,
    CTE.event_data
INTO
    #Eventos
FROM
    CTE
WHERE
    DATEADD(HOUR, @TimeZone, CTE.event_data.value('(//event/@timestamp)[1]', 'datetime')) > @Dt_Ultimo_Registro

SELECT
    A.Dt_Evento,
    xed.event_data.value('(action[@name="session_id"]/value)[1]', 'int') AS session_id,
    xed.event_data.value('(action[@name="database_name"]/value)[1]', 'varchar(128)') AS [database_name],
    xed.event_data.value('(action[@name="username"]/value)[1]', 'varchar(128)') AS username,
    xed.event_data.value('(action[@name="session_server_principal_name"]/value)[1]', 'varchar(128)') AS session_server_principal_name,
    xed.event_data.value('(action[@name="session_nt_username"]/value)[1]', 'varchar(128)') AS [session_nt_username],
    xed.event_data.value('(action[@name="client_hostname"]/value)[1]', 'varchar(128)') AS [client_hostname],
    xed.event_data.value('(action[@name="client_app_name"]/value)[1]', 'varchar(128)') AS [client_app_name],
    CAST(xed.event_data.value('(//data[@name="duration"]/value)[1]', 'bigint') / 1000000.0 AS NUMERIC(18, 2)) AS duration,
    CAST(xed.event_data.value('(//data[@name="cpu_time"]/value)[1]', 'bigint') / 1000000.0 AS NUMERIC(18, 2)) AS cpu_time,
    xed.event_data.value('(//data[@name="logical_reads"]/value)[1]', 'bigint') AS logical_reads,
    xed.event_data.value('(//data[@name="physical_reads"]/value)[1]', 'bigint') AS physical_reads,
    xed.event_data.value('(//data[@name="writes"]/value)[1]', 'bigint') AS writes,
    xed.event_data.value('(//data[@name="row_count"]/value)[1]', 'bigint') AS row_count,
    TRY_CAST(xed.event_data.value('(//action[@name="sql_text"]/value)[1]', 'varchar(max)') AS XML) AS sql_text,
    TRY_CAST(xed.event_data.value('(//data[@name="batch_text"]/value)[1]', 'varchar(max)') AS XML) AS batch_text,
    xed.event_data.value('(//data[@name="result"]/text)[1]', 'varchar(100)') AS result
FROM
    #Eventos A
    CROSS APPLY A.event_data.nodes('//event') AS xed (event_data)

