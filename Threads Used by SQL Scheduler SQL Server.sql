
SELECT osTask.session_id, osThreads.os_thread_id,
       osTask.scheduler_id, osTask.task_state --, *
FROM sys.dm_os_tasks AS osTask
INNER JOIN sys.dm_os_threads AS osThreads ON osTask.worker_address = osThreads.worker_address
WHERE osTask.session_id IS NOT NULL
ORDER BY osTask.task_state, osTask.session_id;
GO