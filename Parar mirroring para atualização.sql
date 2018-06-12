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
