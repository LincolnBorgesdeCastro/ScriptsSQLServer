use msdb
go

Select SJH.run_status
from msdb..sysjobs as SJ inner join msdb..sysjobhistory as SJH on SJ.job_id = SJH.job_ID
where  SJ.name = 'SBD - Verifica TEMPDB-MSDB'
and SJH.run_date  =  FORMAT(getdate(), 'yyyyMMdd')
and SJH.run_time =  FORMAT(getdate(), 'hhmmss') 


