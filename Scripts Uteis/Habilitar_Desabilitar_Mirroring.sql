exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

ALTER DATABASE IPASGO SET PARTNER SUSPEND


ALTER DATABASE IPASGO SET PARTNER RESUME

exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1