SET DATEFORMAT dmy
SELECT 
 convert(varchar(10),his.server) as Server,
 convert(varchar(30),job.name) AS job_name, 
 CASE his.run_status
 WHEN 0 THEN 'Failed'
 WHEN 1 THEN 'Succeeded'
 ELSE '???'
 END as run_status,
 convert(varchar(4),run_duration/10000) + ':' + convert(varchar(4),run_duration/100%100) + ':' + convert(varchar(4),run_duration%100) as run_duration,
 convert(datetime, convert(varchar(10),run_date%100) + '/' + convert(varchar(10),run_date/100%100) + '/' + convert(varchar(10),run_date/10000) + ' ' + convert(varchar(4),run_time/10000) + ':' + convert(varchar(4),run_time/100%100) + ':' + convert(varchar(4),run_time%100)) as start_date,
 datediff(mi, getdate()-1, convert(datetime, convert(varchar(10),run_date%100) + '/' + convert(varchar(10),run_date/100%100) + '/' + convert(varchar(10),run_date/10000) + ' ' + convert(varchar(4),run_time/10000) + ':' + convert(varchar(4),run_time/100%100) + ':' + convert(varchar(4),run_time%100))) as LeadingMinutes,
 isnull(nullif(convert(int,(run_duration/10000 * 60) + (run_duration/100%100) + (ceiling(run_duration%100/60.0))),0),1) as DurationMinutes,
 REPLICATE(' ', datediff(mi, getdate()-1, convert(datetime, convert(varchar(10),run_date%100) + '/' + convert(varchar(10),run_date/100%100) + '/' + convert(varchar(10),run_date/10000) + ' ' + convert(varchar(4),run_time/10000) + ':' + convert(varchar(4),run_time/100%100) + ':' + convert(varchar(4),run_time%100)))) +
 REPLICATE('x', isnull(nullif(convert(int,(run_duration/10000 * 60) + (run_duration/100%100) + (ceiling(run_duration%100/60.0))),0),1)) as DurationTimeline,
 his.message
FROM
 msdb.dbo.sysjobhistory his
 INNER JOIN msdb.dbo.sysjobs job ON his.job_id = job.job_id
WHERE
 convert(datetime, convert(varchar(10),run_date%100) + '/' + convert(varchar(10),run_date/100%100) + '/' + convert(varchar(10),run_date/10000) + ' ' + convert(varchar(4),run_time/10000) + ':' + convert(varchar(4),run_time/100%100) + ':' + convert(varchar(4),run_time%100)) between getdate()-1 and getdate()
 and step_id = 0
ORDER BY
 his.server,
 his.run_date,
 his.run_time,
 job.name

