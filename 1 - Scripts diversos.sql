/* Verifica bloqueio */
Exec SBD.dbo.up_SBDVerificaProcessosBloqueios

dbcc inputbuffer (106)
WITH NO_INFOMSGS
/*
 sp_recompile 'up_saBuscaCaminhoImagensOdonto'
 
 Exec SBD.dbo.sp_BlitzWho 

 Exec SBD.dbo.sp_whoisactive
-- Exec sbd.dbo.stpLock_Raiz

@get_plans = 1       -- this gives you the execution plans for running queries.
,@get_locks = 1       -- gives you an XML snippet you can click on to see what table, row, object, etc locks each query owns. Useful when you’re trying to figure out why one query is blocking others.
,@get_task_info = 2  -- if a query has gone parallel and you’re troubleshooting CXPACKET waits, you can figure out what each task in the query is waiting on.

 sp_who2 'active'

*/

exec sbd.dbo.up_SBDInputbuffer 333

-- Kill 1511
checkpoint

/*
ipasgo.dbo.up_opOperadores_Logins '86273795134'

use IPASGO select * from operadores where nome_operador IN ('00953825183')
use IPASGO select * from log_operadores where nome_operador IN ('05225035191')
use IPASGO select * from [dbo].[gv_OrigensResponsaveis] where NUMR_CPF IN ('05225035191')
use IPASGO select * from rh_colaboradores where NUMR_CPF IN ('86115430178')
/************************************************************************************/
exit;
--dbcc opentran

/* Verificar enfileramento */
sp_who2 'active'
/************************************************************************************/
--      sp_recompile 'up_atBuscaRestricoesProcFicha'
/************************************************************************************/
-- desabilitar a trigger
disable trigger tr_SBDConferirReplicacao on database;
disable trigger tr_SBDAlertaProducao on database;

-- habilitar a trigger
enable trigger tr_SBDConferirReplicacao on database;
enable trigger tr_SBDAlertaProducao     on database;
/************************************************************************************/
--Verifica tabela em replicação
use distribution
select distinct
      M.article , 
      M.publication_id, 
      S.publication,
      X.publisher_db 
from MSarticles M 
inner join MSpublications  S on M.publication_id =S.publication_id 
inner join MSsubscriptions X on X.publication_id =S.publication_id
where M.article = 'sa_ArquivosPrestadores'

/************************************************************************************/

/* Verificar os processos que estao rodando */
Select spid,blocked,waittime,dbid,cpu,login_time,open_
,status,hostname,program_name,hostprocess,cmd,nt_domain,loginame
from Sys.SysProcesses
Where spid > 50 
--and program_name LIKE '%Quest Diagnostic Server%'
--and Status<>'sleeping' 
and loginame <> 'IPASGO\86273795134'
and Status='runnable' 
order by cpu desc  --login_time

/************************************************************************************/
Select spid,blocked,waittime,dbid,cpu,login_time,open_tran,status,hostname,program_name,hostprocess,cmd,nt_domain,loginame
from Sys.SysProcesses
Where spid = 269
/************************************************************************************/

 SELECT  c.session_id
			 , c.auth_scheme
			 , c.node_affinity
			 , s.login_name
			 , db_name(s.database_id) AS database_name
			 , CASE s.transaction_isolation_level
			 WHEN 0 THEN 'Unspecified'
			 WHEN 1 THEN 'Read Uncomitted'
			 WHEN 2 THEN 'Read Committed'
			 WHEN 3 THEN 'Repeatable'
			 WHEN 4 THEN 'Serializable'
			 WHEN 5 THEN 'Snapshot'
			 END AS transaction_isolation_level
			 , s.status
			 , c.most_recent_sql_handle
 FROM sys.dm_exec_connections c INNER JOIN sys.dm_exec_sessions s ON c.session_id = s.session_id
 where db_name(s.database_id) = 'IPASGO'

/************************************************************************************/
IPASGO\81084056199    

/********************************************************************************************************/
/* Adicionar usuario ao grupo de permissão */
exec sp_addrolemember 'db_datareader','84315229172'      

/*Informações sobre o usuario */
sp_helpuser '86273795134'

sp_change_users_login UPDATE_ONE , '93176554168', '93176554168'

/********* Consultas do mirroriong *********/
select * from sys.database_mirroring_endpoints

select * from sys.database_mirroring_witnesses 

select    db.name, mir.* 
from    sys.databases db inner join sys.database_mirroring mir on mir.database_id = db.database_id 
where    mirroring_guid is not null 

/* As maiores tabelas do banco */
Select object_name(id),rowcnt,dpages*8 as [tamanho KB] from sysindexes 
where indid in (1,0) and objectproperty(id,'isusertable')=1 
order by rowcnt desc 

/*******************************************************************************************************/
GRANT EXECUTE on dbo.up_cfBuscaSaldoDiarias to [SGF - Supervisao de Conciliacao]

/*******************************************************************************************************/
/**********************************Renomear objeto******************************************************/
EXEC sp_rename N'NomeAtual', N'NomeNovo', N'TipoObjeto';
/*******************************************************************************************************/
/*cofiguração para versionamento de registro no sql server, para evitar deadlocks*/

ALTER DATABASE IPASGO SET READ_COMMITTED_SNAPSHOT  ON WITH ROLLBACK IMMEDIATE;

ALTER DATABASE IPASGO SET ALLOW_SNAPSHOT_ISOLATION ON;
/*******************************************************************************************************/
/*************SETAR O VALOR DO IDENTITY**********************************************************************/
DBCC CHECKIDENT ('rh_ColaboradoresHorarios') -- seta para o ultimo usado

DBCC CHECKIDENT ('rh_ColaboradoresHorarios', NORESEED) -- visualiza

DBCC CHECKIDENT ('rh_ColaboradoresHorarios', RESEED, 3) -- volta para o valor estipulado ex. 30
/*******************************************************************************************************/

select * from cr_LOGCobrancas

update pmso_LOGCampanhas set numg_log = numg_log + 3



select * from dbo.pmso_LOGCampanhas

/*Pegar indice pelo Object_ID*/

select * FROM
sys.partitions
where hobt_id = 72057604301455360

SELECT *
from sys.indexes
where object_id = 1774290472
and index_id = 5

/*******************************************************************************************************/
--Gerar comando para exclusão de foreing key
select 'ALTER TABLE ' + s.name + ' drop constraint ' + f.name + ';'--char(13) + 'go' 
from sys.foreign_keys f join sysobjects s on f.parent_object_id = s.id
where f.name like 'FK_od%'
and   s.name like 'Excluir%'

/*******************************************************************************************************/

--Para Job
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

--Para Mirror
ALTER DATABASE IPASGO SET PARTNER SUSPEND

--Reindexa
DBCC DBREINDEX ('aa_Solicitacoes', PK_aa_Solicitacoes, 80);

-- Habilita Mirror
ALTER DATABASE IPASGO SET PARTNER RESUME

-- Habilita Job
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1
/************************************************************************************/
/*Cria um campo sequencial por um campo que se repete*/
select row_number() over(partition by id order by id) as numero , id from #teste
/************************************************************************************/
backup log VMWARE  with no_log
/************************************************************************************/
/*****************Manutençao no SIGA ***********************************************/

/*
USE [SIGA]
GO
checkpoint
GO
--backup log SIGA with no_log
*/

GO
DBCC SHRINKFILE (N'SIGA_Log' , 0)
GO
/************************************************************************************/
SELECT db.name, m.mirroring_role_desc , m.mirroring_connection_ut
FROM sys.database_mirroring m 
JOIN sys.databases db
ON db.database_id = m.database_id
WHERE db.name = N'IPASGO'; 
GO
--ALTER DATABASE IPASGO SET PARTNER TIMEOUT 50
/************************************************************************************/
--grant ALTER ANY LOGIN to [USER]
--grant ALTER ANY ROLE to [ROLE]  
/************************************************************************************/
/*Mostra a quantidade de conexoes por IP*/
SELECT  EC.CLIENT_NET_ADDRESS ,
		ES.[PROGRAM_NAME] ,
		ES.[HOST_NAME] ,
		ES.LOGIN_NAME ,
		COUNT(EC.SESSION_ID) AS [CONNECTION COUNT]
FROM SYS.DM_EXEC_SESSIONS AS ES INNER JOIN SYS.DM_EXEC_CONNECTIONS AS EC ON ES.SESSION_ID = EC.SESSION_ID
GROUP BY EC.CLIENT_NET_ADDRESS ,
ES.[PROGRAM_NAME] ,
ES.[HOST_NAME] ,
ES.LOGIN_NAME
ORDER BY EC.CLIENT_NET_ADDRESS, ES.[PROGRAM_NAME]

/************************************************************************************/

USE [master]
GO
--DROP DATABASE IPASGO_SNP

CREATE DATABASE [IPASGO_SNP] ON
 (NAME = N'ipasgo_Data', FILENAME = N'e:\Snapshots\Ipasgo_SNP.SNP') 
,(NAME = N'ipasgo_Data2', FILENAME = N'e:\Snapshots\Ipasgo2_SNP.SNP')
,(NAME = N'ipasgo_Index', FILENAME = N'e:\Snapshots\IpasgoIx_SNP.SNP') AS SNAPSHOT OF [IPASGO]

/****************************************************************************************************************/
/****************************************************************************************************************/

--Script de verificação de qual causa o LOG não esta sendo truncado

select log_reuse_wait , log_reuse_wait_desc, * 
from  sys.databases
where name in ('IPASGO','SIGA')

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

FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
inner join sys.dm_exec_connections ec on qs.plan_handle = ec.most_recent_session_id 

ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time

/****************************************************************************************************************/
--Retorna as permissoes DCL de um usuario
select *                     
from sys.database_permissions                     
where grantor_principal_id = user_id ('USR_SCSA');   

select * 
from sys.database_principals
where principal_id in (select grantee_principal_id                     
					   from sys.database_permissions                     
					   where grantor_principal_id = user_id ('USR_SCSA')
)


/************************************************************************************************************/
--Rota do mirror
--tracert mirror.segplan.ipasgo.go.gov.br
/************************************************************************************************************/

Descobrir permissoes em nivel de servidor
SELECT  
  [srvprin].[name] [server_principal], 
  [srvprin].[type_desc] [principal_type], 
  [srvperm].[permission_name], 
  [srvperm].[state_desc]  
FROM [sys].[server_permissions] srvperm 
  INNER JOIN [sys].[server_principals] srvprin 
    ON [srvperm].[grantee_principal_id] = [srvprin].[principal_id] 
WHERE [srvprin].[type] IN ('S', 'U', 'G') 
AND permission_name not in ('CONNECT SQL')
AND permission_name = 'ALTER ANY LOGIN'
ORDER BY [server_principal], [permission_name];

/************************************************************************************************************/
--Consultar todas conexões
select  log_reuse_wait_desc,* from sys.databases

select * from sys.dm_exec_sessions
where database_id = 13


/************************************************************************************************************/
--sp_removedbreplication 'IPASGO'
/************************************************************************************************************/
TOAD DBA SUIT SQL SERVER
---https://support.software.dell.com/download-install-detail/6054161

/************************************************************************************************************/
-- Descobrir se é primario ou secundario AlwaysOn
select role_desc 
from sys.dm_hadr_availability_replica_states 
where is_local=1 
and role=1;
/************************************************************************************************************/

*/
/************************************************************************************************************/
-- Quantidade de memoria por database
SELECT DB_NAME(database_id),
COUNT (1) * 8 / 1024 AS MBUsed
FROM sys.dm_os_buffer_descriptors
GROUP BY database_id
ORDER BY COUNT (*) * 8 / 1024 DESC
GO
/************************************************************************************************************/

select top 4 * from RH_Ponto where NUMG_colaborador = 4485 order by DATA_acao desc

/************************************************************************************************************/
/*-- Leitura no transaction log
Checkpoint
Select convert(numeric(18,2), sum("Log Record Length") / 1024. /1024.) 
from ::fn_dblog(null,null)
*/
/************************************************************************************************************/
--dbo.up_opOperadores_Logins '86273795134'
/************************************************************************************************************/

/************************************************************************************************************/
-- Pressão da CPU detectada pelo usu das Estatisticas
/************************************************************************************************************/
SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2))
AS [%signal (cpu) waits],
CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2))
AS [%resource waits] 
FROM sys.dm_os_wait_stats OPTION (RECOMPILE);

/************************************************************************************************************/
--fn_dump_dblog  -- Le o arquivo de backup de log e retorna em resultset
/************************************************************************************************************/
--Exec SBD.dbo.up_SBDTentativasFrustadasLogin --'2020-07-17 00:00:00.000', '2020-07-18 00:00:00.000', 2
/************************************************************************************************************/
/*
USE IPASGO -- Consultas demoradas com alto consumo

SELECT TOP(50) qs.execution_count AS [Execution Count],
(qs.total_logical_reads)/1000.0 AS [Total Logical Reads in ms],
(qs.total_logical_reads/qs.execution_count)/1000.0 AS [Avg Logical Reads in ms],
(qs.total_worker_time)/1000.0 AS [Total Worker Time in ms],
(qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time in ms],
(qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time in ms],
(qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time in ms],
qs.creation_time AS [Creation Time]
,t.text AS [Complete Query Text], qp.query_plan AS [Query Plan]
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE t.dbid = DB_ID()
--ORDER BY qs.execution_count DESC OPTION (RECOMPILE);-- for frequently ran query
-- ORDER BY [Avg Logical Reads in ms] DESC OPTION (RECOMPILE);-- for High Disk Reading query
 ORDER BY [Avg Worker Time in ms] DESC OPTION (RECOMPILE);-- for High CPU query
-- ORDER BY [Avg Elapsed Time in ms] DESC OPTION (RECOMPILE);-- for Long Running query
*/

/************************************************************************************************************/
-- Consumo de memoria da query em execução
SELECT session_id,
  ((t1.requested_memory_kb)/1024.00) MemoryRequestedMB
  , CASE WHEN t1.grant_time IS NULL THEN 'Waiting' ELSE 'Granted' END AS RequestStatus
  , t1.timeout_sec SecondsToTerminate
  , t2.[text] QueryText
FROM sys.dm_exec_query_memory_grants t1
  CROSS APPLY sys.dm_exec_sql_text(t1.sql_handle) t2
order by 2 desc
/************************************************************************************************************/
  
/************************************************************************************************************/

/*

   update statistics    with fullscan

*/
/************************************************************************************************************/