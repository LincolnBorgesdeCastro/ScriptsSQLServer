--A consulta a seguir fornece uma visão de alto nível dos lotes ou procedimentos armazenados em cache que mais usam a CPU.

SELECT TOP 50 
      SUM(qs.total_worker_time) AS total_cpu_time, 
      SUM(qs.execution_count) AS total_execution_count,
      COUNT(*) AS  number_of_statements, 
      qs.sql_handle 
FROM sys.dm_exec_query_stats AS qs
GROUP BY qs.sql_handle
ORDER BY SUM(qs.total_worker_time) DESC

--A consulta a seguir mostra o uso agregado da CPU por planos em cache com texto SQL.

SELECT 
      total_cpu_time, 
      total_execution_count,
      number_of_statements,
      s2.text
      --(SELECT SUBSTRING(s2.text, statement_start_offset / 2, ((CASE WHEN statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), s2.text)) * 2) ELSE statement_end_offset END) - statement_start_offset) / 2) ) AS query_text
FROM 
      (SELECT TOP 50 
            SUM(qs.total_worker_time) AS total_cpu_time, 
            SUM(qs.execution_count) AS total_execution_count,
            COUNT(*) AS  number_of_statements, 
            qs.sql_handle --,
            --MIN(statement_start_offset) AS statement_start_offset, 
            --MAX(statement_end_offset) AS statement_end_offset
      FROM 
            sys.dm_exec_query_stats AS qs
      GROUP BY qs.sql_handle
      ORDER BY SUM(qs.total_worker_time) DESC) AS stats
      CROSS APPLY sys.dm_exec_sql_text(stats.sql_handle) AS s2 

--A consulta a seguir mostra as 50 instruções SQL com maior média de consumo da CPU.

SELECT TOP 50
total_worker_time/execution_count AS [Avg CPU Time],
(SELECT SUBSTRING(text,statement_start_offset/2,(CASE WHEN statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset end -statement_start_offset)/2) FROM sys.dm_exec_sql_text(sql_handle)) AS query_text, *
FROM sys.dm_exec_query_stats 
ORDER BY [Avg CPU Time] DESC

--O exemplo a seguir mostra consultas de DMV para localizar compilações/recompilações excessivas.

select * from sys.dm_exec_query_optimizer_info
where 
      counter = 'optimizations'
      or counter = 'elapsed time'

--O exemplo de consulta a seguir fornece os 25 principais procedimentos que foram recompilados. plan_generation_num indica o número de vezes que a consulta foi recompilada.

select top 25
      sql_text.text,
      sql_handle,
      plan_generation_num,
      execution_count,
      dbid,
      objectid 
from sys.dm_exec_query_stats a
      cross apply sys.dm_exec_sql_text(sql_handle) as sql_text
where plan_generation_num > 1
order by plan_generation_num desc

--Um plano de consulta ineficiente pode provocar o aumento de consumo da CPU.

--O exemplo a seguir mostra a consulta está usando a CPU de maneira mais cumulativa.

SELECT 
    highest_cpu_queries.plan_handle, 
    highest_cpu_queries.total_worker_time,
    q.dbid,
    q.objectid,
    q.number,
    q.encrypted,
    q.[text]
from 
    (select top 50 
        qs.plan_handle, 
        qs.total_worker_time
    from 
        sys.dm_exec_query_stats qs
    order by qs.total_worker_time desc) as highest_cpu_queries
    cross apply sys.dm_exec_sql_text(plan_handle) as q
order by highest_cpu_queries.total_worker_time desc

--A consulta a seguir mostra alguns operadores que podem estar usando intensamente a CPU, como %Hash Match%’ e ‘%Sort%’.

select *
from 
      sys.dm_exec_cached_plans
      cross apply sys.dm_exec_query_plan(plan_handle)
where 
      cast(query_plan as nvarchar(max)) like '%Sort%'
      or cast(query_plan as nvarchar(max)) like '%Hash Match%'

--Se você detectou planos de consulta ineficientes e que causam alto consumo da CPU, execute UPDATE STATISTICS nas tabelas envolvidas na consulta e verifique se o problema persiste. Em seguida, colete os dados e reporte o problema ao suporte do PerformancePoint Planning.

--Se o seu sistema tiver compilações e recompilações em excesso, poderá resultar em um problema de desempenho do sistema vinculado à CPU.

--Você pode executar as consultas de DMV a seguir para descobrir compilações/recompilações excessivas.

select * from sys.dm_exec_query_optimizer_info
where 
counter = 'optimizations'
or counter = 'elapsed time'

--O exemplo de consulta a seguir fornece os 25 principais procedimentos que foram recompilados. plan_generation_num indica o número de vezes que a consulta foi recompilada.

select top 25
sql_text.text,
sql_handle,
plan_generation_num,
execution_count,
dbid,
objectid 
from sys.dm_exec_query_stats a
cross apply sys.dm_exec_sql_text(sql_handle) as sql_text
where plan_generation_num > 1
order by plan_generation_num desc

--Se você detectou compilação ou recompilação em excesso, colete o máximo de dados que puder e relate o problema ao suporte do Planning.
--Afunilamentos de memória

--Antes de iniciar a detecção e a investigação da pressão na memória, verifique se você habilitou as opções avançadas no SQL Server. Execute a consulta a seguir no banco de dados mestre para ativar essa opção primeiro.

sp_configure 'show advanced options'
go
sp_configure 'show advanced options', 1
go
reconfigure
go

--Execute a consulta a seguir para verificar primeiro as opções de configuração relacionadas à memória.

sp_configure 'awe_enabled'
go
sp_configure 'min server memory'
go
sp_configure 'max server memory'
go
sp_configure 'min memory per query'
go
sp_configure 'query wait'
go

--Execute a consulta de DMV a seguir para ver informações sobre CPU, agendador de memória e pool de buffers.

select 
cpu_count,
hyperthread_ratio,
scheduler_count,
physical_memory_in_bytes / 1024 / 1024 as physical_memory_mb,
virtual_memory_in_bytes / 1024 / 1024 as virtual_memory_mb,
bpool_committed * 8 / 1024 as bpool_committed_mb,
bpool_commit_target * 8 / 1024 as bpool_target_mb,
bpool_visible * 8 / 1024 as bpool_visible_mb
from sys.dm_os_sys_info

--Afunilamentos de E/S

--Identifique os afunilamentos de E/S examinando as esperas de trava. Execute a consulta de DMV a seguir para localizar estatísticas de espera de trava de E/S.

select wait_type, waiting_tasks_count, wait_time_ms, signal_wait_time_ms, wait_time_ms / waiting_tasks_count
from sys.dm_os_wait_stats  
where wait_type like 'PAGEIOLATCH%'  and waiting_tasks_count > 0
order by wait_type

--Identifique um problema de E/S se waiting_task_counts e wait_time_ms mudarem significativamente em relação ao que você vê normalmente. É importante obter uma linha de base dos contadores de desempenho e das principais saídas de consulta de DMV quando o SQL Server estiver funcionando uniformemente.

--Esses wait_types podem indicar se há um afunilamento no subsistema de E/S.

--Use a consulta de DMV a seguir para localizar solicitações pendentes de E/S. Execute essa consulta periodicamente para verificar a integridade do subsistema de E/S e isolar discos físicos envolvidos nos afunilamentos de E/S.

select 
    database_id, 
    file_id, 
    io_stall,
    io_pending_ms_ticks,
    scheduler_address 
from  sys.dm_io_virtual_file_stats(NULL, NULL)t1,
        sys.dm_io_pending_io_requests as t2
where t1.file_handle = t2.io_handle

--A consulta em geral retorna nada na situação normal. Você precisará investigar mais se essa consulta retornar algumas linhas.

--Você também encontrará consultas ligadas a E/S executando a consulta de DMV a seguir.

select top 5 (total_logical_reads/execution_count) as avg_logical_reads,
                   (total_logical_writes/execution_count) as avg_logical_writes,
           (total_physical_reads/execution_count) as avg_physical_reads,
           Execution_count, statement_start_offset, p.query_plan, q.text
from sys.dm_exec_query_stats
      cross apply sys.dm_exec_query_plan(plan_handle) p
      cross apply sys.dm_exec_sql_text(plan_handle) as q
order by (total_logical_reads + total_logical_writes)/execution_count Desc

--A consulta de DMV a seguir pode ser usada para localizar os lotes/as solicitações que estão gerando a maioria das E/Ss. Uma consulta de DMV como a mostrada a seguir pode ser usada para localizar as cinco principais solicitações que geram a maioria das E/Ss. O ajuste dessas consultas melhorará o desempenho do sistema.

select top 5 
    (total_logical_reads/execution_count) as avg_logical_reads,
    (total_logical_writes/execution_count) as avg_logical_writes,
    (total_physical_reads/execution_count) as avg_phys_reads,
     Execution_count, 
    statement_start_offset as stmt_start_offset, 
    sql_handle, 
    plan_handle
from sys.dm_exec_query_stats  
order by  (total_logical_reads + total_logical_writes) Desc

--Bloqueio

--Execute a consulta a seguir para determinar as sessões de bloqueio.

select blocking_session_id, wait_duration_ms, session_id from 
sys.dm_os_waiting_tasks
where blocking_session_id is not null

--Use esta chamada para descobrir qual SQL é retornado por blocking_session_id. Por exemplo, se blocking_session_id for 87, execute essa consulta para obter o SQL.

dbcc INPUTBUFFER(87)

--A consulta a seguir mostra a análise de esperas de SQL e os 10 recursos mais aguardados.

select top 10 *
from sys.dm_os_wait_stats
--where wait_type not in ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK','SLEEP_SYSTEMTASK','WAITFOR')
order by wait_time_ms desc

--Para descobrir o spid que está bloqueando outro spid, crie o procedimento armazenado a seguir em seu banco de dados e execute-o. Esse procedimento armazenado informa a situação do bloqueio. Digite sp_who para descobrir @spid; @spid é um parâmetro opcional.

create proc dbo.sp_block (@spid bigint=NULL)
as
select 
    t1.resource_type,
    'database'=db_name(resource_database_id),
    'blk object' = t1.resource_associated_entity_id,
    t1.request_mode,
    t1.request_session_id,
    t2.blocking_session_id    
from 
    sys.dm_tran_locks as t1, 
    sys.dm_os_waiting_tasks as t2
where 
    t1.lock_owner_address = t2.resource_address and
    t1.request_session_id = isnull(@spid,t1.request_session_id)

--A seguir há exemplos de uso deste procedimento armazenado.

exec sp_block
exec sp_block @spid = 7

--Consulte Também
--Tarefas
--Recover Planning Server with SQL Server
--Conceitos
--Corruption of a SQL Server Analysis Services database
--
