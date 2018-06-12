/***********************************/
/***Query to find the failed jobs***/
/***********************************/
use msdb
go
select h.server as [Server],
	j.[name] as [Name],
	h.message as [Message],
	h.run_date as LastRunDate, 
	h.run_time as LastRunTime
from sysjobhistory h
	inner join sysjobs j on h.job_id = j.job_id
		where j.enabled = 1 
		and h.instance_id in
		(select max(h.instance_id)
			from sysjobhistory h group by (h.job_id))
		and h.run_status = 0


