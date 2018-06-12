use dba

select 
((duration * 0.001) * 0.001) Segundos,
((duration * 0.001) * 0.001) / 60 Minutos,
TextData, 
LoginName, 
StartTime HoraExecucao  

from dbo.MonitoraAssistencia2
order by StartTime desc--, ((duration * 0.001) * 0.001) desc

--select * from MonitoraAssistencia2

Declare @Data_Atual Datetime
Declare @Data_AtualDiff Datetime
Set @Data_Atual = getdate ()--Substring(Convert(Varchar,Dateadd(day,0,Getdate()),121),1,10) + ' 00:00:00'
Set @Data_AtualDiff = (Dateadd(mi,-10,@Data_Atual))
select @Data_Atual
select @Data_AtualDiff

select count (StartTime) as qtde
from MonitoraAssistencia2 
where ((duration * 0.001) * 0.001) > 30 
and StartTime >@Data_AtualDiff and StartTime < @Data_Atual



--and StartTime > '2009-11-12 07:00:00.000'
--and LoginName <> 'ipasgo\810
--group by starttime
--having count (StartTime)> 1
order by StartTime desc-- segundos