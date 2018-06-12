
SELECT count(*)
FROM
    log.msdb.dbo.sysjobactivity                 A   WITH(NOLOCK)
    LEFT JOIN log.msdb.dbo.sysjobhistory        B   WITH(NOLOCK)    ON  A.job_history_id = B.instance_id
    JOIN log.msdb.dbo.sysjobs                   C   WITH(NOLOCK)    ON  A.job_id = C.job_id
    JOIN log.msdb.dbo.sysjobsteps               D   WITH(NOLOCK)    ON  A.job_id = D.job_id AND ISNULL(A.last_executed_step_id, 0) + 1 = D.step_id
    JOIN log.msdb.dbo.syscategories             E   WITH(NOLOCK)    ON  C.category_id = E.category_id
WHERE
    A.session_id = ( SELECT TOP 1 session_id FROM msdb.dbo.syssessions	WITH(NOLOCK) ORDER BY agent_start_date DESC ) 
    AND A.start_execution_date IS NOT NULL 
    AND A.stop_execution_date IS NULL
	AND C.name= 'SIFE - Arquivos Layout Processamento'


