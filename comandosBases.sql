
return

 
-- verificar bloqueio nos servidores
exec MASTER.dbo.up_SBDInputbuffer 199         

exec SBD.dbo.up_SBDInputbuffer 147
exec SBD.dbo.up_SBDInputbuffer 154

dbcc inputbuffer (177)



select count(*) from AE_PROCATENDIMENTOSTEMP

--Exec dbo.up_saExtratoFaturasLayout 278, 12,2014

select * from pr_prestadores where numg_prestador = 278

exec master.dbo.up_SBDVerificaProcessosBloqueios-- 'd'

exec sbd.dbo.up_SBDVerificaProcessosBloqueios

kill 208
FETCH API_CURSOR000000000025BA27


--up_rhBuscaColabExpectativaFerias -- rodrigo ajudou

select * from ipasgo.dbo.operadores where NOME_operador like'14800795533%'

select * from assistencia.ipasgo.dbo.operadores where nome_completo like '%teste%'

-- verifica se a procedure ou comando está em algum JOB
use msdb
select name ,* 
from sysjobsteps st
inner join sysjobs jb on st.job_id = jb.job_id
where command like '%up_saBaixaAtendimentosLayout%'


-- todos jobs de uma equipe
select *
from msdb.dbo.sysjobs 
where category_id = 113 order by name


-- verifica se o texto está em alguma procedure
select distinct sys.name, xtype from sysobjects  sys 
inner join syscomments co on co.id = sys.id
where  co.text like '%sa[_]%' --and co.text like '%dbo.Procedimentos%'
and xtype = 'p' 
and co.text not like '%sp_MS%' AND co.text not like '%up_sy%'

cr_ReceitasAlteradas
select * from at_resultadoReceitas

up_crExcluiDivida


Select distinct 
  sys.name,
	case xtype 
	 when 'C'  THEN 'CHECK constraint'
	 when 'D'  THEN  'Default or DEFAULT constraint'
	 when 'F'  THEN  'FOREIGN KEY constraint'
	 when 'L'  THEN  'Log'
	 when 'FN' THEN  'Scalar function'
	 when 'IF' THEN  'Inlined table-function'
	 when 'P'  THEN  'Stored procedure'
	 when 'PK' THEN  'PRIMARY KEY constraint (type is K)'
	 when 'RF' THEN  'Replication filter stored procedure '
	 when 'S'  THEN  'System table'
	 when 'TF' THEN  'Table function'
	 when 'TR' THEN  'Trigger'
	 when 'U'  THEN  'User table'
	 when 'UQ' THEN  'UNIQUE constraint (type is K)'
	 when 'V'  THEN  'View'
	 when 'X'  THEN  'Extended stored procedure'
	END AS Tipo

from sysobjects sys inner join syscomments co on co.id = sys.id
where lower(co.text) like '%contasapagar@ipasog.go.gov.br%' 
--and xtype = 'p'
order by sys.name



select o.name 'nome tabela', c.name 'nome coluna', ic.*
from dw.sys.indexes i
inner join dw.sys.objects o on i.object_id = o.object_id
inner join dw.sys.index_columns ic on i.object_id = ic.object_id and i.index_id = ic.index_id
inner join dw.sys.columns c on ic.object_id = c.object_id and ic.index_column_id = c.column_id
where o.object_id = 2036254359 and i.index_id = 18




--exec up_syPrsNumSolicitAtendidasGeralGTI

select * from sysobjects where xtype = 'u'

--QueryProcessing

--clean
--warnnig
--error


use msdb
select jb.name ,* 
from sysjobhistory st
inner join sysjobs jb on st.job_id = jb.job_id
where run_date = 20140709 
and run_time > 80000 -- horario inicio
and run_time < 90000 -- horario inicio
and jb.name like '%gera%' -- se quiser saber pelo nome do job
order by run_time, jb.name



SELECT top 1 * FROM LOG.log.DBO.log_receitas order by numg_receita



select l.name, j.name
from master.dbo.syslogins l
	inner join msdb.dbo.sysjobs j on l.sid = j.owner_sid

where l.name <> 'IPASGO\81084056199' AND l.name <> 'SA'




USE [master]
RESTORE DATABASE [SERP] FROM  DISK = N'\\catar\Backup_BD\SQL_BKP\EGITO\bkp_SERP_Full_27-05-2015.bak' WITH  FILE = 1,  
MOVE N'SERP_Data' TO N'g:\Dados\SERP_Data.mdf',  
MOVE N'SERP_log' TO N'g:\Logs\SERP_Log.ldf',  NOUNLOAD,  STATS = 5

GO


-- quantidade de tabelas das bases do servidor
sp_msforeachdb 'select "?" as ''Banco'',count(t.name) as ''qtTab'' from ?.sys.tables t where t.type = ''U''' 


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



select * into dbo.sa_FaturasProducao
from assistencia.siga.dbo.sa_Faturas

grant select on sa_FaturasProducao to [69957177168]



select * into dbo.sa_FaturasIrlanda
from irlanda.siga.dbo.sa_Faturas

grant select on sa_FaturasIrlanda to [69957177168]





-- habilitar o JOB que faz o RESUME para voltar a sincronizar
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1

-- recolocar tabela na replicacao

ALTER DATABASE IPASGO SET PARTNER RESUME
--*************************************************************************


RESTORE DATABASE CONTAS_PAGAR WITH RECOVERY


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
where article = 'sa_procedimentosvalores'


select * into dbo.cr_ReceitasNaoGeradas from assistencia.ipasgo.dbo.cr_ReceitasNaoGeradas
select * into dbo.sv_DepProcessoExclusao from assistencia.ipasgo.dbo.sv_DepProcessoExclusao



-- vira o mirror
ALTER DATABASE IPASGO SET PARTNER FAILOVER


-- altera somente a coluna da tabela sem ter que recriar a mesma
ALTER TABLE dbo.doc_exy ALTER COLUMN column_a DECIMAL (5, 2) ;




-- os dois abaixo tem o mesmo efeito
SELECT numg_pessoa FROM gv_pessoas
EXCEPT 
SELECT numg_pessoa FROM gv_clientes;

SELECT pes.numg_pessoa FROM gv_pessoas pes
left join gv_clientes cli on pes.numg_pessoa = cli.numg_pessoa 
where cli.numg_pessoa is null



backup log IPASGO  with no_log

DBCC SHRINKFILE (N'VMWARE_log' , 0)


-- saber o que está prendendo o log
select log_reuse_wait , log_reuse_wait_desc, * 
from  sys.databases

DBCC SHRINKFILE (N'ipasgo_log' , 0)

--informa qual query esta alocando espaço no tempdb
 SELECT A.session_id
,B.host_name
, B.Login_Name 
, (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 as TotalalocadoMB
, D.Text 
FROM sys.dm_db_session_space_usage A JOIN sys.dm_exec_sessions B  ON A.session_id = B.session_id 
JOIN sys.dm_exec_connections C ON C.session_id = B.session_id 
		CROSS APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) As D 
WHERE A.session_id > 50 
and (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 > 100 
ORDER BY totalalocadoMB desc 


BACKUP LOG IPASGO WITH TRUNCATE_ONLY
GO 



-- espaço em disco
exec master..xp_fixeddrives

DBCC SHRINKFILE (N'DBReports_Log' , 0)

DBCC SHRINKFILE (N'IPASGO_Log' , 0)

DBCC SQLPERF (LOGSPACE)

DBCC CHECKTABLE ('gv_LogDadosAssistenciais2006')




-- informacoes sobre tabelas
exec sp_spaceused sa_LogTratamentosAtosProcedimentos
exec sp_spaceused sa_LogTratamentosAtosProcedimentos2
exec sp_spaceused pg_ProcessosDevolucao
exec sp_spaceused receitas


exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

ALTER DATABASE IPASGO SET PARTNER SUSPEND                                                                                                                                                                                                                                         

DBCC DBREINDEX ('Receitas', IX_Receitas12, 80)

ALTER DATABASE IPASGO SET PARTNER RESUME

exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1



CHECKPOINT   




DBCC CHECKIDENT ('aa_mensagens') -- seta para o ultimo usado

DBCC CHECKIDENT ('cf_LOGEmpenhos', RESEED) -- visualiza
DBCC CHECKIDENT ('Secoes', NORESEED)

DBCC CHECKIDENT ('po_galpoes', RESEED, 0) -- volta para o valor estipulado ex. 30

DBCC CHECKDB 'IPASGO'

EXECUTE msdb.dbo.sysmail_configure_sp 'MaxFileSize', '10484760'


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


select datepart(d, eomonth('2012-02-05')) [ultimo dia mes]
select datepart(d, eomonth('2013-02-05')) [ultimo dia mes]



 SELECT SERVERPROPERTY('servername') As "Nome do Servidor",

SERVERPROPERTY('productversion') As Versão,

SERVERPROPERTY ('productlevel') As "Service Pack", 

SERVERPROPERTY ('edition') As Edição,

@@Version As "Sistema Operacional"




TCP://WITNESS_SEFAZ.ipasgo.go.gov.br:5022

TCP://WITNESS.SEGPLAN.IPASGO.GO.GOV.BR:5022

--- mudar timeout do MIRRORING
ALTER DATABASE IPASGO SET PARTNER TIMEOUT 120

-- consultar timeout
select db.name, mi.mirroring_state_desc, mi.mirroring_role_desc, mi.mirroring_connection_timeout
from sys.databases db
	inner join sys.database_mirroring mi on db.database_id = mi.database_id
where mirroring_state is not null





-- 
select distinct col.name
from sys.sysobjects sys 
	INNER join sys.syscolumns col ON sys.id = col.id
where  sys.xtype = 'u'
and sys.name = 'receitas'

select * from sys.syscolumns

select  sys.name
from sys.sysobjects sys 
	INNER join sys.syscolumns col ON sys.id = col.id
	inner join dbo.sbde_EstatisticasCrescimentoTabelas e ON sys.name = replace(replace(replace(replace(e.NOME_Tabela,'dbo',''),'[',''),']',''),'.','')
	inner join dbo.sbdi_BasesDados b on e.numg_baseDado = b.numg_baseDado
where  sys.xtype = 'u'
and col.name = 'NUMG_divida'
and sys.name NOT LIKE '%LOG%'
and b.DATA_Referencia = '2015-07-01'
ORDER by NUMR_TamanhoTabela desc


exec msdb.dbo.sp_start_job 'SIGA - Processa Comparação Padrão'


sp_removedbreplication 

sp_restoredbreplication 



--set language portuguese
--set language english


-- mudar arquivo de lugar
ALTER DATABASE FINANCEIRO SET OFFLINE;

ALTER DATABASE FINANCEIRO MODIFY FILE ( NAME = FINANCEIRO_log, FILENAME = 'E:\BD\DATA\FINANCEIRO_Log.ldf' );

ALTER DATABASE FINANCEIRO SET ONLINE




-- mudar arquivo de lugar -- ALTEREI SEM PARAR A BASE
ALTER DATABASE tempdb MODIFY FILE ( NAME = tempdev, FILENAME = 'I:\Dados\tempdb.mdf' );
ALTER DATABASE tempdb MODIFY FILE ( NAME = templog, FILENAME = 'I:\Logs\templog.ldf' );




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
FROM sys.fn_get_audit_file ('\\Catar\Auditorias\ASSISTENCIA\IPASGO\AUDT_IPASGO_F66E04C1-3716-48E7-AFCB-094437C69E93_0_130741760451040000.sqlaudit',default,default)
order by event_time desc

-- power shell
Import-Module FailoverClusters
clear-clusternode





 SELECT ROW_NUMBER() OVER(ORDER BY data_ocorrencia) AS Row, 
    numg_receita, numg_pessoa, numg_tiporeceita, data_ocorrencia, valr_receita 
FROM ipasgo.dbo.receitas
WHERE numg_pessoa = 568997


Use Master
Go
Select @@servername

--sp_linkedservers
select * from master.dbo.sysservers

Use Master
EXEC Sp_dropserver 'EGITO2'
Go
EXEC Sp_addserver 'EGITO', 'local'
Go


sp_helpserver
--Se acusar um nome diferente, vc deve executar as rotinas abaixos:


exec sp_AddRemoteLogin 'ASSISTENCIA','distributor_admin'--,'NORTE'

sp_get_distributor

USE [master]
GO
CREATE LOGIN [distributor_admin] WITH PASSWORD=N'1CDINF2scbd', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [distributor_admin]
GO

sp_adddistributor 'ASSISTENCIA',10,'1CDINF2scbd'

sp_adddistributiondb 'distribution', 'e:\Dados\', null, 5, 'f:\Logs\', null, 0, 0, 72, 48,1,'distributor_admin','1CDINF2scbd',1

sp_adddistpublisher 'ASSISTENCIA', 'distribution',1,'distributor_admin','1CDINF2scbd', '\\norte.ipasgo.go.gov.br\k$\Replicacao',
'false',0,0,'MSSQLSERVER'



--EXEC master.dbo.sp_serveroption @server=N'ASSISTENCIA', @optname=N'dist', @optvalue=N'true'

sp_dropdistributor 0,0
sp_dropdistpublisher 'ASSISTENCIA', 0,0

-- adicionei o login
exec sp_AddRemoteLogin 'ASSISTENCIA','distributor_admin'
sp_adddistributor 'ASSISTENCIA',10,'1CDINF2scbd'

sp_helpdistributiondb
sp_helpdistributiondb
sp_changedistpublisher 'ASSISTENCIA', 'security_mode', 0
sp_changedistpublisher  
sp_changereplicationserverpasswords 


sp_helprotect 'SP_PASSWORD'




ALTER DATABASE SERP SET TRUSTWORTHY ON


SYS.sp_MSrepl_check_server


SELECT migs.group_handle, mid.*
FROM sys.dm_db_missing_index_group_stats AS migs 
INNER JOIN sys.dm_db_missing_index_groups  AS mig ON (migs.group_handle = mig.index_group_handle)
INNER JOIN sys.dm_db_missing_index_details AS mid ON (mig.index_handle  = mid.index_handle)
WHERE migs.group_handle in (SELECT TOP 20 group_handle 
							FROM sys.dm_db_missing_index_group_stats 
							ORDER BY avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)DESC);



							ALTER DATABASE MSDB SET NEW_BROKER


-- soma da linha corrente para traz
select NUMR_TipoAtendimento, valr_pago, numr_mes,
	sum(valr_pago) over(partition by numr_tipoAtendimento order by numr_mes rows between unbounded preceding and current row) valor_pagoAcumulado
from siga.dbo.sa_faturas
where numg_prestador = 2
and numr_ano = 2013
and NUMR_TipoAtendimento in (3, 8)



-- pesquisar permissoes
with usr (CPF)
as
(Select NOME_operador as CPF
From ASSISTENCIA.ipasgo.dbo.operadores 

intersect

select (select name 
        from sys.sql_logins 
        where principal_id = grantee_principal_id) as CPF
 from sys.server_permissions
 where permission_name = 'ALTER ANY LOGIN'


) 
Select op.NOME_COMPLETO , op.NOME_Operador
From usr inner join ASSISTENCIA.ipasgo.dbo.operadores op on  op.NOME_operador = usr.CPF
order by 1


-- DNE
http://www.corporativo.correios.com.br/edne/
Codigo Administrativo: 11079053
S#nh@: 01246693



select g.name, r1.replica_server_name, l.routing_priority, r2.replica_server_name, r2.read_only_routing_url 
from sys.availability_read_only_routing_lists as l
join sys.availability_replicas as r1 on l.replica_id = r1.replica_id
join sys.availability_replicas as r2 on l.read_only_replica_id = r2.replica_id
join sys.availability_groups as g on r1.group_id = g.group_id
order by g.name,r1.replica_server_name, routing_priority



ALTER AVAILABILITY GROUP [gd_Homologa2]
 MODIFY REPLICA ON N'AUSTRALIA' WITH (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://AUSTRALIA.ipasgo.go.gov.br:1433'));

ALTER AVAILABILITY GROUP [gd_Homologa2]
 MODIFY REPLICA ON N'INDONESIA' WITH (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://INDONESIA.ipasgo.go.gov.br:1433'));


 ALTER AVAILABILITY GROUP [gd_Homologa2]
 MODIFY REPLICA ON N'AUSTRALIA' WITH  (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('INDONESIA', 'AUSTRALIA')));

 ALTER AVAILABILITY GROUP [gd_Homologa2]
 MODIFY REPLICA ON N'INDONESIA' WITH  (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('AUSTRALIA', 'INDONESIA')));