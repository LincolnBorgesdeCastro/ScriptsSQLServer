
use msdb

select name ,* 
from sysjobsteps st
inner join sysjobs jb on st.job_id = jb.job_id
where command like '%COLOMBIA%'