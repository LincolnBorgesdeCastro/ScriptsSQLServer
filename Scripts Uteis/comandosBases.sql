--Descobrir bloqueios

exec master.dbo.up_SBDVerificaProcessosBloqueios

dbcc inputbuffer (64)

//*****************************************************************//

--Descobrir o JOB e o passo do JOB que tal procedure faz parte
use msdb
select name ,* 
from sysjobsteps st
inner join sysjobs jb on st.job_id = jb.job_id
where command like '%up_gvExcluiFilhoTermoAntigo%'

//*****************************************************************//

--Descobrir em qual replicação tal tabela faz parte
use distribution
select distinct
      M.article , 
      M.publication_id, 
      S.publication,
      X.publisher_db 
from MSarticles M 
inner join MSpublications  S on M.publication_id =S.publication_id 
inner join MSsubscriptions X on X.publication_id =S.publication_id
where article = 'Acordos_Usuarios'

//*****************************************************************//

-- espaço em disco

exec master..xp_fixeddrives
DBCC SQLPERF (LOGSPACE)

//*****************************************************************//

--Checar inconsistência da tabela

DBCC CHECKTABLE ('gv_clientes')

-- Checar insconsistencia do Database

DBCC checkdb ('ipasgo')

-- cria tabela de log
up_dbaCriaTblLog 'gv_HistoricoSituacoesCadCliente', 'dbo'


-- informacoes sobre tabelas

sp_spaceused gv_LogDadosAssistenciais2006 
sp_spaceused sa_LogTratamentosAtosProfissionais

---"CONFIRMAR" a transação. Vc força o SQL a gravar as transações no disco

CHECKPOINT       

-- Alterar Identity da tabela
DBCC CHECKIDENT ('LOG_crDependentesMandado') -- seta para o ultimo usado
DBCC CHECKIDENT ('LOG_crMandadoSeguranca', NORESEED) -- visualiza
DBCC CHECKIDENT ('LOG_crMandadoSeguranca', RESEED, 82) -- volta para o valor estipulado ex. 30
select max(NUMG_GuiaAlta) from at_guiasaltas -- Ultimo Identity da tabela


-- reindexar
DBCC DBREINDEX ('Guias', idxNUMG_matricula,80)


-- ranking tamanho tabelas
select substring(object_name(id),1,30)nome,rowcnt,dpages*8 as tamanho from sysindexes
where indid in (1,0) and objectproperty(id,'isusertable')=1  
order by tamanho desc

--Descobrir informações físicas do database, como localização dos arquivos, etc
sp_helpdb siga

