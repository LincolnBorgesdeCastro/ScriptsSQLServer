/************************************************************************************/
--Para Job
exec msdb.dbo.sp_update_job @job_name = "SBD - Backup Log Databases", @enabled = 0

--Para Mirror
USE MASTER
GO
ALTER DATABASE [IPASGO] SET HADR SUSPEND;

--Reindexa
/*
USE IPASGO
GO
DBCC DBREINDEX ('at_ResumoUtilizacoes', PK_at_ResumoUtilizacoes, 80);


select * from sysindexes
*/
-- Habilita Mirror
USE MASTER
GO
ALTER DATABASE [IPASGO] SET HADR RESUME;

--Habilita Job de backup de log
exec msdb.dbo.sp_update_job @job_name = "SBD - Backup Log Databases", @enabled = 1


/************************************************************************************/

/************************************************************************************/
-- desabilitar a trigger
disable trigger tr_SBDConferirReplicacao on database
-- habilitar a trigger
enable trigger tr_SBDConferirReplicacao on database

/************************************************************************************/
--Verifica colunas que faltam indices
SELECT TOP 10 *
FROM sys.dm_db_missing_index_group_stats
ORDER BY avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)DESC;


SELECT migs.group_handle, mid.*
FROM sys.dm_db_missing_index_group_stats AS migs INNER JOIN sys.dm_db_missing_index_groups  AS mig ON (migs.group_handle = mig.index_group_handle)
                                                 INNER JOIN sys.dm_db_missing_index_details AS mid ON (mig.index_handle  = mid.index_handle)
WHERE migs.group_handle in (SELECT TOP 10 group_handle FROM sys.dm_db_missing_index_group_stats ORDER BY avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)DESC);


