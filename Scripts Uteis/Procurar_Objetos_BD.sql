
select distinct sys.name from sysobjects sys
inner join syscomments co on co.id = sys.id
where co.text like '%sp_polimed%' and xtype = 'p'
order by sys.name


Para pesquisar em qual job tal proc ou consulta é utizada:

Select job.name
from msdb.dbo.sysjobsteps st
inner join msdb.dbo.sysjobs job on st.job_id = job.job_id
where command 
like '%sp_polimed%'
