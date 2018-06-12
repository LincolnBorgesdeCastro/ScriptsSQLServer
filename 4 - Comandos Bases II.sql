dbcc freeproccache
dbcc freesystemcache('all')
dbcc dropcleanbuffers
checkpoint

--Usuarios que estao ocupando espaço no tempDB
;with tab(session_id, host_name, login_name, totalalocadomb, text, connect_time )
as(
SELECT a.session_id,
b.host_name,
b.login_name,
( user_objects_alloc_page_count + internal_objects_alloc_page_count ) * 1.0 / 128 AS totalalocadomb,
d.TEXT,
connect_time
FROM sys.dm_db_session_space_usage a
JOIN sys.dm_exec_sessions b ON a.session_id = b.session_id
JOIN sys.dm_exec_connections c ON c.session_id = b.session_id
CROSS APPLY sys.Dm_exec_sql_text(c.most_recent_sql_handle) AS d
WHERE a.session_id > 50
--AND ( user_objects_alloc_page_count + internal_objects_alloc_page_count ) * 1.0 / 128 > 0.1
and status <> 'runnable'
and a.session_id <> @@SPID
)
select * from tab
union all
select null,null,null,sum(totalalocadomb),null,null 
from tab
order by 4,6

kill 91
DBCC SHRINKFILE (N'tempdev' , 0, NOTRUNCATE)
DBCC SHRINKFILE (N'tempdev' , 0, TRUNCATEONLY)
DBCC SHRINKDATABASE (N'tempdb', 0)

kill 53

-- espaço do TEMPDB
USE tempdb;
SELECT  
name,
size/128.0 as size,
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files

kill 
/****************************************************************************************************************/

--Verificar sessões abertas que estão abertas há mais de XX horas sem executar nada.

SELECT  * 
from sys.dm_db_session_space_usage sp inner join sys.dm_exec_sessions se on sp.session_id = se.session_id
WHERE sp.session_id > 50 
AND se.last_request_end_time < DATEADD (HH,-4, GETDATE()) 
--and login_name not in ('IPASGO\81084056199')
order by login_time desc

kill 59
kill 82

/************************************************************************************************/

SELECT  s.session_id,
@@ServerName,
DB_NAME (p.dbid) AS [Database],
p.open_tran,
s.host_name,
s.login_name,
s.status,
est.text
FROM 
sys.dm_exec_sessions s
INNER JOIN sys.sysprocesses p on s.session_id = p.spid
OUTER APPLY sys.dm_exec_sql_texT(p.sql_handle) as est
WHERE s.session_id > 50 
	AND s.is_user_process = 1
	AND s.last_request_end_time < DATEADD (HH,-24, GETDATE()) 

--KILL 55
kill 107
kill 118
kill 135
/************************************************************************************************/

/************************************************************************************************/
-- espaço do TEMPDB
USE tempdb;
SELECT  
name,
size/128.0 as size,
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files

CHECKPOINT
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
DBCC FREESYSTEMCACHE('ALL')

/************************************************************************************************/

--Querys utilizando o TempDB
Select top 10
t1.session_id,
t1.request_id,
t3.hostname,
t3.loginame,
t3.program_name,
db_name (t3.dbid) as dbname,
t1.task_alloc  * (8.0/1024.0) as Alocado_MB, --qtd de paginas
t1.task_dealloc  * (8.0/1024.0)as Desalocado_MB, --qtd de paginas

    (SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
     FROM sys.dm_exec_sql_text(t2.sql_handle)) AS query_text,
(SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle)) as query_plan, t3.status

from      (Select session_id, request_id,
sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc,
sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
       from sys.dm_db_task_space_usage
       group by session_id, request_id) as t1,
       sys.dm_exec_requests as t2,
       sys.sysprocesses as t3
where
t3.loginame NOT IN ('', 'IPASGO\86273795134') and
t1.session_id = t2.session_id and
(t1.request_id = t2.request_id) and
t1.session_id = t3.spid and
      t1.session_id > 50
--and t3.status <> 'runnable'
and t1.session_id <> @@SPID
order by t1.task_alloc DESC


KILL 56

/****************************************************************************************************************/

--Script de verificação de qual causa o LOG não esta sendo truncado

select log_reuse_wait , log_reuse_wait_desc, * 
from  sys.databases
where name in ('IPASGO','SIGA')


select * from sys.dm_exec_sessions  where session_id = 93

select * from  sys.dm_tran_database_transactions
select * from  sys.dm_tran_active_transactions
select * from sys.dm_tran_active_snapshot_database_transactions


--select size, max_size, growth, * from sys.database_files


--Processo que estao consumindo mais log
SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
qs.last_execution_time,
qp.query_plan,
ec.session_id
FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
                                CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
                                inner join sys.dm_exec_connections ec on qs.plan_handle = ec.most_recent_session_id 

ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time

/****************************************************************************************************************/

/* Consumindo o temp DB no momento */

SELECT
st.dbid AS QueryExecutionContextDBID,
DB_NAME(st.dbid) AS QueryExecContextDBNAME,
st.objectid AS ModuleObjectId,
SUBSTRING(st.TEXT,
dmv_er.statement_start_offset/2 + 1,
(CASE WHEN dmv_er.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX),st.TEXT)) * 2
ELSE dmv_er.statement_end_offset
END - dmv_er.statement_start_offset)/2) AS Query_Text,
dmv_tsu.session_id ,
dmv_tsu.request_id,
dmv_tsu.exec_context_id,
(dmv_tsu.user_objects_alloc_page_count - dmv_tsu.user_objects_dealloc_page_count) AS OutStanding_user_objects_page_counts,
(dmv_tsu.internal_objects_alloc_page_count - dmv_tsu.internal_objects_dealloc_page_count) AS OutStanding_internal_objects_page_counts,
dmv_er.start_time,
dmv_er.command,
dmv_er.open_transaction_count,
dmv_er.percent_complete,
dmv_er.estimated_completion_time,
dmv_er.cpu_time,
dmv_er.total_elapsed_time,
dmv_er.reads,dmv_er.writes,
dmv_er.logical_reads,
dmv_er.granted_query_memory,
dmv_es.HOST_NAME,
dmv_es.login_name,
dmv_es.program_name
FROM sys.dm_db_task_space_usage dmv_tsu
INNER JOIN sys.dm_exec_requests dmv_er
ON (dmv_tsu.session_id = dmv_er.session_id AND dmv_tsu.request_id = dmv_er.request_id)
INNER JOIN sys.dm_exec_sessions dmv_es
ON (dmv_tsu.session_id = dmv_es.session_id)
CROSS APPLY sys.dm_exec_sql_text(dmv_er.sql_handle) st
WHERE (dmv_tsu.internal_objects_alloc_page_count + dmv_tsu.user_objects_alloc_page_count) > 0
ORDER BY (dmv_tsu.user_objects_alloc_page_count - dmv_tsu.user_objects_dealloc_page_count) + (dmv_tsu.internal_objects_alloc_page_count - dmv_tsu.internal_objects_dealloc_page_count) DESC


/************************************************************************************************/

DBCC OPENTRAN
select * from sysprocesses where open_tran <> 0 and dbid = 2 --Busca inclusive transações aninhadas
select * from sys.dm_exec_sessions where open_transaction_count > 0 and database_id = 2


/************************************************************************************************/
/*Script para descobrir o nome dos logins/usuario de um servidor */

with usr (CPF)
as
(Select NOME_operador as CPF
From ASSISTENCIA.ipasgo.dbo.operadores 

intersect

select (select name 
        from sys.sql_logins 
        where principal_id = grantee_principal_id) as CPF
 from sys.server_permissions
 where permission_name = 'IMPERSONATE'
) 
Select op.NOME_COMPLETO , op.NOME_Operador
From usr inner join ASSISTENCIA.ipasgo.dbo.operadores op on  op.NOME_operador = usr.CPF
order by 1


--USERS
with usr (CPF)
as
(Select NOME_operador as CPF
From ASSISTENCIA.ipasgo.dbo.operadores 

intersect

select name
from sys.database_principals

) 
Select op.NOME_COMPLETO , op.NOME_Operador
From usr inner join ASSISTENCIA.ipasgo.dbo.operadores op on  op.NOME_operador = usr.CPF
order by 1
/************************************************************************************************/

/*Script que demostra todo objetos negados(DENY) do database*/
SELECT USER_NAME(P.GRANTEE_PRINCIPAL_ID) AS PRINCIPAL_NAME,
DP.PRINCIPAL_ID,
DP.TYPE_DESC AS PRINCIPAL_TYPE_DESC,
P.CLASS_DESC,
OBJECT_NAME(P.MAJOR_ID) AS OBJECT_NAME,
P.PERMISSION_NAME,
P.STATE_DESC AS PERMISSION_STATE_DESC
FROM SYS.DATABASE_PERMISSIONS P
INNER JOIN SYS.DATABASE_PRINCIPALS DP
ON P.GRANTEE_PRINCIPAL_ID = DP.PRINCIPAL_ID
WHERE P.STATE_DESC = 'DENY'
and grantor_principal_id = user_id ('USR_SIMM')  

REVOKE IMPERSONATE ON USER::USR_SCSS FROM [86273795134]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [82175012115]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [97835340178]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [68483449234]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [02098310145]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [00142788120]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [53280075149]
REVOKE IMPERSONATE ON USER::USR_SCSS FROM [97935204187]



/************************************************************************************************/
/* Pesquisar historico JOB */
USE msdb
Go

SELECT
      j.name as [Nome do Job],
      h.step_name [Nome do Passo],--um job pode ter diversos passos
      CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 111) as [Data da Execução],
      STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') as [Hora Execução],
      h.run_duration [Tempo de execução em segundos],
      case h.run_status when 0 then 'Falha'
            when 1 then 'Sucesso'
            when 2 then 'Retry'
            when 3 then 'Cancelado pelo usuário'
            when 4 then 'Em execução'
      end as [Status final da execução],
      h.message as [Mensagem da execução]
FROM
      sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id

Where j.name = 'SIGA - Processa Atendimentos SifeWeb'
and   CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) >= '2014-10-02 00:00:00.000'
and   CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) <  '2014-10-03 00:00:00.001'
--and h.run_status <> 1
ORDER BY
      j.name,
      h.run_date,
      h.run_time
GO

/************************************************************************************************/
--Quantidade de conexoes por database
SELECT DB_NAME(dbid) AS DBName,
COUNT(dbid) AS NumberOfConnections,
loginame
FROM    sys.sysprocesses
GROUP BY dbid, loginame
ORDER BY DB_NAME(dbid),2 DESC
/************************************************************************************************/

-- esperando algum recurso a mais de X tempo
SELECT s.original_login_name, s.program_name, t.wait_type, t.wait_duration_ms
FROM sys.dm_os_waiting_tasks t JOIN sys.dm_exec_sessions s
ON t.session_id = s.session_id
WHERE s.is_user_process = 1
AND t.wait_duration_ms > 2000

/************************************************************************************************/
-- Query executando
Select * from sys.dm_exec_sessions 
where 
--nt_user_name like '%81084056199%' and
database_id = 2

/************************************************************************************************/
-- porcentagem de uso de CPU

WITH DB_CPU_Stats AS (SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName], SUM(total_worker_time) AS [CPU_Time_Ms]
 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID]
FROM sys.dm_exec_plan_attributes(qs.plan_handle)
WHERE attribute = N'dbid') AS F_DB
GROUP BY DatabaseID)
SELECT ROW_NUMBER() OVER(ORDER BY [CPU_Time_Ms] DESC) AS [row_num],
DatabaseName, [CPU_Time_Ms],
CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUPercent]
FROM DB_CPU_Stats
WHERE DatabaseID > 4 -- Banco de dados de sistema
AND DatabaseID <> 32767 -- ResourceDB
ORDER BY row_num OPTION (RECOMPILE);

/************************************************************************************************/
-- Consulta relatorios que envia emails por assinaturas
SELECT c.*
FROM [REPORTSERVER].[dbo].[Subscriptions]  s inner join dbo.Catalog c on s.Report_OID = c.itemID
/************************************************************************************************/

/*Verificar no log quem deletou algo*/
SELECT * FROM fn_dblog(NULL, NULL) WHERE [Transaction Name] = 'DROPOBJ'

SELECT [Current LSN], [Operation], [Context], [Transaction ID], [AllocUnitName], [Page ID], [Transaction Name], [Parent Transaction ID], [Description] 
FROM fn_dblog(NULL, NULL)

/************************************************************************************************/