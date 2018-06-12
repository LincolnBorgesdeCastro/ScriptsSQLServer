
-- Sessoes
Select u.UserName
     , CONVERT(DATETIME, SWITCHOFFSET (CONVERT(datetimeoffset, s.StartDate), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as StartDate
     , CONVERT(DATETIME, SWITCHOFFSET (CONVERT(datetimeoffset, s.EndDate)  , DATENAME(TzOffset, SYSDATETIMEOFFSET()))) as EndDate
from MonitorData.Session s inner join MonitorData.[User] u on s.UserId = u.id
where u.UserName in ('11150459620')
and StartDate >= '2016-11-26 00:00:00.000' --and EndDate <= '2016-12-25 23:59:59.999'
order by u.UserName, StartDate

--select * from MonitorData.[User]

     ,  --Convertendo para a data e hora sem UTC
/**********************************************************************************************/
-- Conexões 

SELECT top 10 *-- distinct ClientName, ClientAddress-- , CreatedDate
FROM [XENAPP76].[MonitorData].[Connection]
where 
CreatedDate >= getdate() - 7
and ClientAddress LIKE '10.250.%'
--order by CreatedDate
