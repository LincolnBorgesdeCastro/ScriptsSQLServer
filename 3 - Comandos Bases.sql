/************************************************************************************************/
--Verificar quem esta no Desenv_Ipasgo
--drop table #Permissoes
create table #Permissoes (grupo varchar(100), usuario varchar(20), member varchar(500))
insert #Permissoes
exec sp_helprolemember 'Desenv_Ipasgo'

select distinct o.* 
from #Permissoes r
inner join ipasgo.dbo.operadores o on r.usuario = o.nome_operador 
/************************************************************************************************/
sp_addrolemember 'Desenv_ipasgo', '72170271104'

sp_droprolemember 'Desenv_ipasgo', '72170271104'
/************************************************************************************************/

-- verificar bloqueio nos servidores
exec MASTER.dbo.up_SBDInputbuffer 153         

exec SBD.dbo.up_SBDInputbuffer 54

dbcc inputbuffer (54)

exec master.dbo.up_SBDVerificaProcessosBloqueios-- 'd'

exec sbd.dbo.up_SBDVerificaProcessosBloqueios

PT6JVBR8764T9FT6FVJ2H48PV -- OperadorAdmin ?

select * from assistencia.ipasgo.dbo.operadores where NOME_operador like'016167%'
select * from assistencia.ipasgo.dbo.operadores where nome_completo like '%teste%'

-- verifica se a procedure ou comando está em algum JOB
use msdb
select name ,* 
from sysjobsteps st
inner join sysjobs jb on st.job_id = jb.job_id
where command like '%sp_tablespace%'


-- verifica se o texto está em alguma procedure
select distinct sys.name, xtype from sysobjects  sys 
inner join syscomments co on co.id = sys.id
where  co.text like '%sp_tablespace%' 
and xtype = 'p'



-- quantidade de tabelas das bases do servidor
sp_msforeachdb 'select "?" as ''Banco'',count(t.name) as ''qtTab'' from ?.sys.tables t where t.type = ''U''' 

sp_msforeachdb 'ALTER DATABASE ? SET OFFLINE WITH ROLLBACK IMMEDIATE' 

EXEC sp_MSforeachdb 'IF ''?'' NOT IN (''master'', ''model'',''tempdb'',''msdb'')
BEGIN
    PRINT ''ALTER DATABASE [?] SET OFFLINE WITH ROLLBACK IMMEDIATE;'';
END';

-- ROTEIRO PARA ALTERAR TABELA EM PRODUCAO, BASE IPASGO
--*************************************************************************
-- desabilitar o JOB que faz o RESUME
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

-- tirar tabela da replicacao

-- suspender o mirror
ALTER DATABASE IPASGO SET PARTNER SUSPEND

-- desabilitar a trigger
disable trigger tr_SBDConferirReplicacao on database

-- alterar a tabela em questao

-- habilitar a trigger
enable trigger tr_SBDConferirReplicacao on database

-- habilitar o JOB que faz o RESUME para voltar a sincronizar
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1

-- recolocar tabela na replicacao

ALTER DATABASE IPASGO SET PARTNER RESUME
--*************************************************************************

-- verifica se a tabela está em replicacao
use distribution
select distinct
      M.article , 
      M.publication_id, 
      S.publication,
      X.publisher_db 
from MSarticles M 
inner join MSpublications  S on M.publication_id =S.publication_id 
inner join MSsubscriptions X on X.publication_id =S.publication_id
where article = 'sa_ArquivosFaturasLayout'


-- vira o mirror
ALTER DATABASE IPASGO SET PARTNER FAILOVER


-- altera somente a coluna da tabela sem ter que recriar a mesma
ALTER TABLE dbo.doc_exy ALTER COLUMN column_a DECIMAL (5, 2) ;

--Liberar memoria da seção
DBCC FREESESSIONCACHE;

-- os dois abaixo tem o mesmo efeito
SELECT numg_pessoa FROM gv_pessoas
EXCEPT 
SELECT numg_pessoa FROM gv_clientes;

SELECT pes.numg_pessoa FROM gv_pessoas pes
left join gv_clientes cli on pes.numg_pessoa = cli.numg_pessoa 
where cli.numg_pessoa is null



backup log vmware  with no_log

DBCC SHRINKFILE (N'VMWARE_log' , 0)

BACKUP LOG IPASGO WITH TRUNCATE_ONLY
GO 



-- espaço em disco
exec master..xp_fixeddrives

DBCC SHRINKFILE (N'DBReports_Log' , 0)

DBCC SHRINKFILE (N'IPASGO_Log' , 0)

DBCC SQLPERF (LOGSPACE)

DBCC CHECKTABLE ('gv_LogDadosAssistenciais2006')



--exec fabrica.dbo.up_SBDCriaTabelaLog 'pg_Formalidades', 'dbo', 1

-- cria tabela de log
exec dbo.up_SBDCriaTabelaLogTrigger 'pg_Formalidades', 'dbo', 0, 1




-- informacoes sobre tabelas
exec sp_spaceused sa_LogTratamentosAtosProcedimentos
exec sp_spaceused sa_LogTratamentosAtosProcedimentos2
exec sp_spaceused LOG_aaSolicitacoes3
exec sp_spaceused br_BancoRecursoImagem



exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

ALTER DATABASE IPASGO SET PARTNER SUSPEND                                                                                                                                                                                                                                         

DBCC DBREINDEX ('Receitas', IX_Receitas12, 80)

ALTER DATABASE IPASGO SET PARTNER RESUME

exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1



CHECKPOINT   



DBCC CHECKIDENT ('aa_mensagens') -- seta para o ultimo usado

DBCC CHECKIDENT ('Receitas_LOGGuiasCanceladas', NORESEED) -- visualiza

DBCC CHECKIDENT ('Receitas_LOGGuiasCanceladas', RESEED, 123) -- volta para o valor estipulado ex. 30



EXECUTE msdb.dbo.sysmail_configure_sp
    'MaxFileSize', '10484760'



-- reindexar
DBCC DBREINDEX ('DMAS_FatAtendimentos', IX_DMAS_FatAtendimentos3,80)


-- espaço log
exec ('dbcc sqlperf (logspace)')


-- ranking tamanho tabelas
select substring(object_name(id),1,30)nome,rowcnt,dpages*8 as tamanho from sysindexes
where indid in (1,0) and objectproperty(id,'isusertable')=1  
order by tamanho desc


ALTER DATABASE siga SET Offline
ALTER DATABASE siga MODIFY FILE ( NAME = siga_log, FILENAME = 'g:\db\log\siga_log.ldf')

ALTER DATABASE siga SET ONLINE

sp_helpdb siga


--sqlservr  -m -T4022 -T3659 -q"SQL_Latin1_General_CP1_CI_AS"


--backup log ipasgo with truncate only

sysmail_start_sp

dbcc opentran


exec master..xp_fixeddrives





--SELECT name 
--    FROM tempdb..sysobjects 
-- 
--SELECT OBJECT_NAME(id), rowcnt 
--    FROM tempdb..sysindexes 
--    WHERE OBJECT_NAME(id) LIKE ''#%''
--    ORDER BY rowcnt DESC
--
--DBCC OPENTRAN (''TEMPDB'')
--
--SP_WHO2
--
--DBCC INPUTBUFFER ( )
--
--BACKUP LOG TEMPDB WITH NO_LOG

 SELECT SERVERPROPERTY('servername') As "Nome do Servidor",

SERVERPROPERTY('productversion') As Versão,

SERVERPROPERTY ('productlevel') As "Service Pack", 

SERVERPROPERTY ('edition') As Edição,

@@Version As "Sistema Operacional"




TCP://WITNESS_SEFAZ.ipasgo.go.gov.br:5022

TCP://WITNESS.SEGPLAN.IPASGO.GO.GOV.BR:5022

--- mudar timeout do MIRRORING
ALTER DATABASE IPASGO SET PARTNER TIMEOUT 50

-- consultar timeout
select db.name, mi.mirroring_state_desc, mi.mirroring_role_desc, mi.mirroring_connection_timeout
from sys.databases db
	inner join sys.database_mirroring mi on db.database_id = mi.database_id
where mirroring_state is not null





-- 
select distinct sys.name
from sys.sysobjects sys 
	INNER join sys.syscolumns col ON sys.id = col.id
where  sys.xtype = 'u'
and col.name = 'NUMG_Pessoa'



select  sys.name
from sys.sysobjects sys 
	INNER join sys.syscolumns col ON sys.id = col.id
	inner join dbo.sbde_EstatisticasCrescimentoTabelas e ON sys.name = replace(replace(replace(replace(e.NOME_Tabela,'dbo',''),'[',''),']',''),'.','')
	inner join dbo.sbdi_BasesDados b on e.numg_baseDado = b.numg_baseDado
where  sys.xtype = 'u'
and col.name = 'NUMG_guia'
and sys.name NOT LIKE '%LOG%'
and b.DATA_Referencia = '2012-02-01'
ORDER by NUMR_TamanhoTabela desc


exec msdb.dbo.sp_start_job 'SIGA - Processa Comparação Padrão'


sp_removedbreplication 

sp_restoredbreplication 





-- mudar arquivo de lugar
ALTER DATABASE FINANCEIRO SET OFFLINE;

ALTER DATABASE FINANCEIRO MODIFY FILE ( NAME = FINANCEIRO_log, FILENAME = 'E:\BD\DATA\FINANCEIRO_Log.ldf' );

ALTER DATABASE FINANCEIRO SET ONLINE




-- mudar arquivo de lugar -- ALTEREI SEM PARAR A BASE
ALTER DATABASE MSDB MODIFY FILE ( NAME = MSDBData, FILENAME = 'E:\DB\MSDBData.mdf' );
ALTER DATABASE MSDB MODIFY FILE ( NAME = MSDBLog, FILENAME = 'F:\DB\MSDBLog.ldf' );




SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'FINANCEIRO');


http://technet.microsoft.com/pt-br/sqlserver/hh456285


SELECT session_id
      ,event_time
      ,server_instance_name
	  ,database_name
	  ,schema_name
      ,object_name
	  ,class_type
	  ,action_id
	  ,statement
	  ,sequence_number
--select * 
FROM sys.fn_get_audit_file ('H:\Auditoria\auditoria*.sqlaudit',default,default)
order by event_time


-- Reads from a file that is named \\serverName\Audit\HIPPA_AUDIT.sqlaudit 
SELECT * FROM sys.fn_get_audit_file ('\\bddesenv\c$\Auditoria SQL Server\*.sqlaudit',default,default);
GO

ALTER DATABASE SERP SET trustworthy ON


/*Comando para testar quanto tempo o processo esta demorando*/
SELECT  ACT.spid
       ,DB.name AS DataBaseName
       ,ACT.hostname
       ,ACT.program_name
       ,RTRIM(LTRIM(ACT.loginame))
			 ,ACT.login_time
			 ,DATEDIFF(mi, getdate(), ACT.login_time)
       ,EST.text AS SQLStatement
FROM sys.sysprocesses AS ACT     
     INNER JOIN sys.databases AS DB ON ACT.dbid = DB.database_id
     CROSS APPLY sys.dm_exec_sql_text(ACT.sql_handle) AS EST
WHERE  ACT.spid > 50
AND  EST.text LIKE '%up_SBDExecutaSelect%' 
AND  ACT.login_time < dateadd(mi,-2,getdate())
and ACT.loginame NOT IN ('IPASGO\81084056199', 'IPASGO\86273795134', '86273795134')


SELECT  ACT.spid
       ,DB.name AS DataBaseName
       ,ACT.hostname
       ,ACT.program_name
       ,RTRIM(LTRIM(ACT.loginame)) as loginame
			 ,ACT.login_time
			 ,sum(qs.total_elapsed_time) / 60000 AS "Duração(Min)"

FROM sys.sysprocesses AS ACT     
     INNER JOIN sys.databases AS DB ON ACT.dbid = DB.database_id		 
		 inner join sys.dm_exec_query_stats qs on ACT.sql_handle = qs.sql_handle
     CROSS APPLY sys.dm_exec_sql_text(ACT.sql_handle) AS EST		 
WHERE  ACT.spid > 50
AND qs.total_elapsed_time >= 1 * 60000
AND  EST.text LIKE '%up_SBDExecutaSelect%' 
--AND  ACT.login_time < dateadd(mi,-2,getdate())
and ACT.loginame NOT IN ('IPASGO\81084056199', 'IPASGO\86273795134', '86273795134')
and ACT.status = 'runnable'
group by ACT.spid, DB.name, ACT.hostname ,ACT.program_name ,RTRIM(LTRIM(ACT.loginame)) ,ACT.login_time


SELECT  ACT.spid, SUM(ISNULL(qs.total_worker_time,0)) as Tempo
FROM sys.sysprocesses AS ACT 
     CROSS APPLY sys.dm_exec_sql_text(ACT.sql_handle) AS EST		 
	 left join sys.dm_exec_query_stats qs on ACT.sql_handle = qs.sql_handle
WHERE  ACT.spid > 50
AND  EST.text LIKE '%up_SBDExecutaSelect%'
AND  qs.total_worker_time / 60000 > 1
AND  ACT.loginame NOT IN ('IPASGO\81084056199', 'IPASGO\86273795134', '86273795134')
GROUP BY ACT.spid

select g.NUMG_guia as ID from Guias g
union
select g.NUMG_Receita as ID from Receitas g

--up_SBDExecutaSelect




/* Força o fail over no alwayson */
ALTER AVAILABILITY GROUP [gd_IPASGO] FORCE_FAILOVER_ALLOW_DATA_LOSS



/*Script que descobre os grupos que um determinado usuario é dono */
Select DBPrincipal_2.name as role, DBPrincipal_1.name as owner 
From sys.database_principals as DBPrincipal_1 inner join sys.database_principals as DBPrincipal_2 
On DBPrincipal_1.principal_id = DBPrincipal_2.owning_principal_id 
Where DBPrincipal_1.name = '39609839134'

/*Consultando historico de JOBs */
SELECT B.name, A.Step_Id, A.Message, A.Run_Date, run_time
FROM msdb.dbo.Sysjobhistory A
JOIN msdb.dbo.Sysjobs B ON A.Job_Id = B.Job_Id
WHERE A.Run_Date = '20140711'
and A.run_time >= 92100 and A.run_time <= 92200
ORDER BY run_time

/******************** Script Execução JOBs *******************************************/

use msdb
select jb.name ,*
from sysjobhistory st
inner join sysjobs jb on st.job_id = jb.job_id
where run_date = 20140709
and run_time > 80000 -- horario inicio
and run_time < 90000 -- horario termino
and jb.name like '%gera%' -- se quiser saber pelo nome do job
order by run_time, jb.name



/*Permissoes para criar e alterar procedure e demais objetos*/
--Romenia
USE IPASGO
GO
GRANT ALTER ON SCHEMA :: DBO TO [DES_crEquipe]
GRANT ALTER ON SCHEMA :: DBO TO [DES_pmsoEquipe]
GRANT ALTER ON SCHEMA :: DBO TO [DES_agEquipe]
GRANT ALTER ON SCHEMA :: DBO TO [DES_atEquipe]
USE SIGA
GO
GRANT ALTER ON SCHEMA :: DBO TO [DES_saEquipe]


/*Ver o enviao de log para a segplan */
select log_send_queue_size, * from sys.dm_hadr_database_replica_states 
where  database_id = 12


/**************************DATABASE E-MAIL *****************************************************/

--Profiles
SELECT * FROM msdb.dbo.sysmail_profile
 
--Accounts
SELECT * FROM msdb.dbo.sysmail_account
 
--Profile Accounts
select * from msdb.dbo.sysmail_profileaccount
 
--Principal Profile
select * from msdb.dbo.sysmail_principalprofile
 
--Mail Server
SELECT * FROM msdb.dbo.sysmail_server
SELECT * FROM msdb.dbo.sysmail_servertype
SELECT * FROM msdb.dbo.sysmail_configuration
 
--Email Sent Status
SELECT * FROM msdb.dbo.sysmail_allitems
SELECT * FROM msdb.dbo.sysmail_sentitems
SELECT * FROM msdb.dbo.sysmail_unsentitems
SELECT * FROM msdb.dbo.sysmail_faileditems
 
--Email Status
SELECT SUBSTRING(fail.subject,1,25) AS 'Subject',
       fail.mailitem_id,
       LOG.description
FROM msdb.dbo.sysmail_event_log LOG
join msdb.dbo.sysmail_faileditems fail
ON fail.mailitem_id = LOG.mailitem_id
WHERE event_type = 'error'
 
--Mail Queues
EXEC msdb.dbo.sysmail_help_queue_sp
 
--DB Mail Status
EXEC msdb.dbo.sysmail_help_status_sp


-- Consumo de memoria por databases
SELECT
[DatabaseName] = CASE [database_id] WHEN 32767
THEN 'Resource DB'
ELSE DB_NAME([database_id]) END,
COUNT_BIG(*) [Pages in Buffer],
COUNT_BIG(*)/128 [Buffer Size in MB]
FROM sys.dm_os_buffer_descriptors
GROUP BY [database_id]
ORDER BY [Pages in Buffer] DESC;


-- Quanto cada objeto do banco esta usando da memoria
SELECT obj.name [Object Name], o.type_desc [Object Type],
i.name [Index Name], i.type_desc [Index Type],
COUNT(*) AS [Cached Pages Count],
COUNT(*)/128 AS [Cached Pages In MB]
FROM sys.dm_os_buffer_descriptors AS bd
INNER JOIN
(
SELECT object_name(object_id) AS name, object_id
,index_id ,allocation_unit_id
FROM sys.allocation_units AS au
INNER JOIN sys.partitions AS p
ON au.container_id = p.hobt_id
AND (au.type = 1 OR au.type = 3)
UNION ALL
SELECT object_name(object_id) AS name, object_id
,index_id, allocation_unit_id
FROM sys.allocation_units AS au
INNER JOIN sys.partitions AS p
ON au.container_id = p.partition_id
AND au.type = 2
) AS obj
ON bd.allocation_unit_id = obj.allocation_unit_id
INNER JOIN sys.indexes i ON obj.[object_id] = i.[object_id]
INNER JOIN sys.objects o ON obj.[object_id] = o.[object_id]
WHERE database_id = DB_ID()
GROUP BY obj.name, i.type_desc, o.type_desc,i.name
ORDER BY [Cached Pages In MB] DESC;

--




