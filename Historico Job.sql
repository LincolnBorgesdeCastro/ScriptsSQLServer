
USE msdb
Go

SELECT h.step_id,
      j.name as [Nome do Job],
      h.step_name [Nome do Passo],--um job pode ter diversos passos
	  h.run_date,
      run_duration,
      CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) as [Data da Execução],
      STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') as [Hora Execução],
      STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(h.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':')  as [Tempo de execução],
      case h.run_status when 0 then 'Falha'
            when 1 then 'Sucesso'
            when 2 then 'Retry'
            when 3 then 'Cancelado pelo usuário'
            when 4 then 'Em execução'
      end as [Status final da execução],
      h.message as [Mensagem da execução]
	  
FROM
      sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id

Where j.name = 'SIFE - Arquivos Layout Processamento'

and   CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) >= '2018-03-28'
and   CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 121) <= '2018-03-28'

and h.run_time >= 120000 --and  h.run_time  <= 235600

--and h.run_status <> 1  
--and h.step_name = '(Job outcome)'
ORDER BY
     7 desc
GO

/************************************************************************************************************/

Use msdb
GO

SELECT *

FROM msdb.dbo.Sysjobhistory A JOIN msdb.dbo.Sysjobs B ON A.Job_Id = B.Job_Id

WHERE  --msdb.dbo.agent_datetime(run_date, run_time)  BETWEEN '01/01/2016 23:54:00' and '01/01/2016 23:56:00' 

A.Run_Date = '20160101' and A.run_time >= 235400 and  A.run_time  <= 235600
and B.name = 'IPASGO - Processa Retorno Arrecadacao'
--and run_status <> 1
ORDER BY B.name, A.run_date, A.run_time


/* Historico das ultimas 24 horas dos jobs */
SELECT 
    j.name as JobName, 
    LastRunDateTime = 
    CONVERT(DATETIME, CONVERT(CHAR(8), run_date, 112) + ' ' 
    + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), run_time), 6), 5, 0, ':'), 3, 0, ':'), 121)
FROM 
    msdb..sysjobs j
INNER JOIN
    msdb..sysjobhistory jh ON j.job_id = jh.job_id
WHERE
    CONVERT(DATETIME, CONVERT(CHAR(8), run_date, 112) + ' ' 
    + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), run_time), 6), 5, 0, ':'), 3, 0, ':'), 121) > DATEADD(HOUR, -24, GETDATE())

/********************************************************************************************************************************************/

SET NOCOUNT ON;

SELECT sj.name,
       sh.run_date,
       sh.step_name,
       STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(sh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time',
       STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(sh.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)  '
FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobhistory sh
ON sj.job_id = sh.job_id
Where sj.name = 'SIFE - Arquivos Layout Processamento'

and   CONVERT(CHAR(10), CAST(STR(sh.run_date,8, 0) AS dateTIME), 121) >= '2018-03-28'
and   CONVERT(CHAR(10), CAST(STR(sh.run_date,8, 0) AS dateTIME), 121) <= '2018-03-28'

and sh.run_time >= 120000 --and  h.run_time  <= 235600

/********************************************************************************************************************************************/
/********************************************************************************************************************************************/

