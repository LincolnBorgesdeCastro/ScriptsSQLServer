-- desabilitar o JOB que faz o RESUME
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

-- tirar tabela da replicacao
use distribution
select distinct
      M.article , 
      M.publication_id, 
      S.publication,
      X.publisher_db 
from MSarticles M 
inner join MSpublications  S on M.publication_id =S.publication_id 
inner join MSsubscriptions X on X.publication_id =S.publication_id
where article = 'receitas'
use IPASGO

-- suspender o mirror
ALTER DATABASE IPASGO SET PARTNER SUSPEND

ALTER DATABASE IPASGO SET PARTNER FAILOVER

-- desabilitar a trigger no database que for alterar a tabela
disable trigger tr_SBDConferirReplicacao on database

-- alterar a tabela em questao (Rodando o script ou alteração na mão preferencialmente)


-- habilitar a trigger
enable trigger tr_SBDConferirReplicacao on database

-- habilitar o JOB que faz o RESUME para voltar a sincronizar
exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1

-- recolocar tabela na replicacao


ALTER DATABASE IPASGO SET PARTNER RESUME