Select job.name
from msdb.dbo.sysjobsteps st
inner join msdb.dbo.sysjobs job on st.job_id = job.job_id
where command like '%up_atAtualizaCotaPrestador%' 