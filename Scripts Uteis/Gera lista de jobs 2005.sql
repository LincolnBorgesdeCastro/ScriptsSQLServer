--USE msdb
--GO
--CREATE FUNCTION [dbo].[udf_schedule_description] (@freq_type INT ,
-- @freq_interval INT ,
-- @freq_subday_type INT ,
-- @freq_subday_interval INT ,
-- @freq_relative_interval INT ,
-- @freq_recurrence_factor INT ,
-- @active_start_date INT ,
-- @active_end_date INT,
-- @active_start_time INT ,
-- @active_end_time INT ) 
--RETURNS NVARCHAR(255) AS 
--BEGIN
--DECLARE @schedule_description NVARCHAR(255)
--DECLARE @loop INT
--DECLARE @idle_cpu_percent INT
--DECLARE @idle_cpu_duration INT
--
--IF (@freq_type = 0x1) -- OneTime
-- BEGIN
-- SELECT @schedule_description = N'Once on ' + CONVERT(NVARCHAR, @active_start_date) + N' at ' + CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2))
-- RETURN @schedule_description
-- END
--IF (@freq_type = 0x4) -- Daily
-- BEGIN
-- SELECT @schedule_description = N'Every day '
-- END
--IF (@freq_type = 0x8) -- Weekly
-- BEGIN
-- SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' week(s) on '
-- SELECT @loop = 1
-- WHILE (@loop <= 7)
-- BEGIN
-- IF (@freq_interval & POWER(2, @loop - 1) = POWER(2, @loop - 1))
-- SELECT @schedule_description = @schedule_description + DATENAME(dw, N'1996120' + CONVERT(NVARCHAR, @loop)) + N', '
-- SELECT @loop = @loop + 1
-- END
-- IF (RIGHT(@schedule_description, 2) = N', ')
-- SELECT @schedule_description = SUBSTRING(@schedule_description, 1, (DATALENGTH(@schedule_description) / 2) - 2) + N' '
-- END
--IF (@freq_type = 0x10) -- Monthly
-- BEGIN
-- SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' months(s) on day ' + CONVERT(NVARCHAR, @freq_interval) + N' of that month '
-- END
--IF (@freq_type = 0x20) -- Monthly Relative
-- BEGIN
-- SELECT @schedule_description = N'Every ' + CONVERT(NVARCHAR, @freq_recurrence_factor) + N' months(s) on the '
-- SELECT @schedule_description = @schedule_description +
-- CASE @freq_relative_interval
-- WHEN 0x01 THEN N'first '
-- WHEN 0x02 THEN N'second '
-- WHEN 0x04 THEN N'third '
-- WHEN 0x08 THEN N'fourth '
-- WHEN 0x10 THEN N'last '
-- END +
-- CASE
-- WHEN (@freq_interval > 00)
-- AND (@freq_interval < 08) THEN DATENAME(dw, N'1996120' + CONVERT(NVARCHAR, @freq_interval))
-- WHEN (@freq_interval = 08) THEN N'day'
-- WHEN (@freq_interval = 09) THEN N'week day'
-- WHEN (@freq_interval = 10) THEN N'weekend day'
-- END + N' of that month '
-- END
--IF (@freq_type = 0x40) -- AutoStart
-- BEGIN
-- SELECT @schedule_description = FORMATMESSAGE(14579)
-- RETURN @schedule_description
-- END
--IF (@freq_type = 0x80) -- OnIdle
-- BEGIN
-- EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE',
-- N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent',
-- N'IdleCPUPercent',
-- @idle_cpu_percent OUTPUT,
-- N'no_output'
-- EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE',
-- N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent',
-- N'IdleCPUDuration',
-- @idle_cpu_duration OUTPUT,
-- N'no_output'
-- SELECT @schedule_description = FORMATMESSAGE(14578, ISNULL(@idle_cpu_percent, 10), ISNULL(@idle_cpu_duration, 600))
-- RETURN @schedule_description
-- END
---- Subday stuff
-- SELECT @schedule_description = @schedule_description +
-- CASE @freq_subday_type
-- WHEN 0x1 THEN N'at ' + CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2))
-- WHEN 0x2 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' second(s)'
-- WHEN 0x4 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' minute(s)'
-- WHEN 0x8 THEN N'every ' + CONVERT(NVARCHAR, @freq_subday_interval) + N' hour(s)'
-- END
-- IF (@freq_subday_type IN (0x2, 0x4, 0x8))
-- SELECT @schedule_description = @schedule_description + N' between ' +
-- CONVERT(NVARCHAR, cast((@active_start_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_start_time % 10000) / 100 as varchar(10)),2) ) + N' and ' + CONVERT(NVARCHAR, cast((@active_end_time / 10000) as varchar(10)) + ':' + right('00' + cast((@active_end_time % 10000) / 100 as varchar(10)),2) )
--
--RETURN @schedule_description
--END





SELECT dbo.sysjobs.name, CAST(dbo.sysschedules.active_start_time / 10000 AS VARCHAR(10))   
+ ':' + RIGHT('00' + CAST(dbo.sysschedules.active_start_time % 10000 / 100 AS VARCHAR(10)), 2) AS active_start_time,   
dbo.udf_schedule_description(dbo.sysschedules.freq_type, dbo.sysschedules.freq_interval,  
dbo.sysschedules.freq_subday_type, dbo.sysschedules.freq_subday_interval, dbo.sysschedules.freq_relative_interval,  
dbo.sysschedules.freq_recurrence_factor, dbo.sysschedules.active_start_date, dbo.sysschedules.active_end_date,  
dbo.sysschedules.active_start_time, dbo.sysschedules.active_end_time) AS ScheduleDscr, dbo.sysjobs.enabled  
FROM dbo.sysjobs INNER JOIN  
dbo.sysjobschedules ON dbo.sysjobs.job_id = dbo.sysjobschedules.job_id INNER JOIN  
dbo.sysschedules ON dbo.sysjobschedules.schedule_id = dbo.sysschedules.schedule_id 
where dbo.sysjobs.enabled  = 1
order by active_start_time