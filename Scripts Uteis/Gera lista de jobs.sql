 -- select    j.name, 
--          Frequencia =    case when s.freq_type = 1 then 'Uma vez' 
--                              when s.freq_type = 4 then 'Diariamente'
--                              when s.freq_type = 8 then 'Semanalmente'
--                              when s.freq_type = 16 then 'Mensalmente' 
--                              when s.freq_type = 32 then 'Mensalmente relativo'
--                              when s.freq_type = 64 then 'When SQL Agent starts' end,
--          --s.freq_interval,
--          Dias =  case when s.freq_interval = 1 then 'Domingo'
--                      when s.freq_interval = 2 then 'Segunda'
--                      when s.freq_interval = 4 then 'Terca'
--                      when s.freq_interval = 8 then 'Quarta'
--                      when s.freq_interval = 16 then 'Quinta'
--                      when s.freq_interval = 32 then 'Sexta'
--                      when s.freq_interval = 64 then 'Sábado' end,
--          s.active_start_date,
--          --s.active_end_date,
--          s.active_start_time,
--          s.active_end_time,
--          s.next_run_date,
--          s.next_run_time
-- 
-- from         sysjobs j
-- inner    join sysjobschedules s on j.job_id = s.job_id
-- where    j.enabled = 1 and s.enabled =1
-- order by j.name
-- 
-- --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



-- CREATE PROCEDURE sp_JobScheduleREPORT
-- 
-- AS

declare @x int, @y int, @z int
declare @counter smallint
declare @days varchar(100), @day varchar(10)
declare @Jname sysname, @freq_interval int, @JID varchar(50)
SET NOCOUNT ON

create table #temp (JID varchar(50), Jname sysname, 
Jdays varchar(100))
--This cursor runs throough all the jobs that have a weekly frequency running on different days
Declare C cursor for select Job_id, name, freq_interval from msdb..sysjobschedules
where freq_type = 8
Open C
Fetch Next from c into @JID, @Jname, @freq_interval
while @@fetch_status = 0
Begin
    set @counter = 0
    set @x = 64
    set @y = @freq_interval
    set @z = @y
    set @days = ''
    set @day = ''

    while @y <> 0
    begin
        select @y = @y - @x
        select @counter = @counter + 1
        If @y < 0 
        Begin
            set @y = @z
            GOTO start
        End


    Select @day = CASE @x
        when 1 Then 'Sunday'
        when 2 Then 'Monday'
        when 4 Then 'Tuesday'
        when 8 Then 'Wednesday'
        when 16 Then 'Thursday'
        when 32 Then 'Friday'
        when 64 Then 'Saturday'
    End

    select @days = @day + ',' + @days
start:
    Select @x = CASE @counter
        When 1 then 32
        When 2 then 16
        When 3 then 8
        When 4 then 4
        When 5 then 2
        When 6 then 1
    End

    set @z = @y
    if @y = 0 break
    end

    Insert into #temp select @jid, @jname, left(@days, len(@days)-1)
Fetch Next from c into @jid, @Jname, @freq_interval

End
close c
deallocate c

--Final query to extract complete information by joining sysjobs, sysjobschedules and #Temp table

select b.name Job_Name, 
-- CASE b.enabled 
-- when 1 then 'Enabled'
-- Else 'Disabled'
-- End as JobEnabled, a.name Schedule_Name, 
-- 
-- CASE a.enabled 
-- when 1 then 'Enabled'
-- Else 'Disabled'
-- End as ScheduleEnabled,

CASE freq_type 
when 1 Then 'Once'
when 4 Then 'Daily'
when 8 then 'Weekly'
when 16 Then 'Monthly' --+ cast(freq_interval as char(2)) + 'th Day'
when 32 Then 'Monthly Relative'
when 64 Then 'Execute When SQL Server Agent Starts'
End as [Job Frequency],

CASE freq_type 
when 32 then CASE freq_relative_interval
when 1 then 'First'
when 2 then 'Second'
when 4 then 'Third'
when 8 then 'Fourth'
when 16 then 'Last'
End
Else ''
End as [Monthly Frequency],

CASE freq_type
when 16 then cast(freq_interval as char(2)) + 'th Day of Month'
when 32 then CASE freq_interval 
when 1 then 'Sunday'
when 2 then 'Monday'
when 3 then 'Tuesday'
when 4 then 'Wednesday'
when 5 then 'Thursday'
when 6 then 'Friday'
when 7 then 'Saturday'
when 8 then 'Day'
when 9 then 'Weekday'
when 10 then 'Weekend day'
End
when 8 then c.Jdays
Else ''
End as [Runs On],
CASE freq_subday_type
when 1 then 'At the specified Time'
when 2 then 'Seconds'
when 4 then 'Minutes'
when 8 then 'Hours'
End as [Interval Type], CASE freq_subday_type 
when 1 then 0
Else freq_subday_interval 
End as [Time Interval],
CASE freq_type 
when 8 then cast(freq_recurrence_factor as char(2)) + ' Week'
when 16 Then cast(freq_recurrence_factor as char(2)) + ' Month'
when 32 Then cast(freq_recurrence_factor as char(2)) + ' Month'
Else ''
End as [Occurs Every],

left(active_start_date,4) + '-' + substring(cast(active_start_date as char),5,2) 
+ '-' + right(active_start_date,2) [Begin Date-Executing Job], 

left(REPLICATE('0', 6-len(active_start_time)) + cast(active_start_time as char(6)),2) + ':' +
substring(REPLICATE('0', 6-len(active_start_time)) + cast(active_start_time as char(6)),3,2) + ':' +
substring(REPLICATE('0', 6-len(active_start_time)) + cast(active_start_time as char(6)),5,2)
[Executing At],

left(active_end_date,4) + '-' + substring(cast(active_end_date as char),5,2) 
+ '-' + right(active_end_date,2) [End Date-Executing Job],

left(REPLICATE('0', 6-len(active_end_time)) + cast(active_end_time as char(6)),2) + ':' +
substring(REPLICATE('0', 6-len(active_end_time)) + cast(active_end_time as char(6)),3,2) + ':' +
substring(REPLICATE('0', 6-len(active_end_time)) + cast(active_end_time as char(6)),5,2)
[End Time-Executing Job]--,

-- b.date_created [Job Created], a.date_created [Schedule Created] 
from msdb..sysjobschedules a RIGHT OUTER JOIN msdb..sysjobs b ON a.job_id = b.job_id
LEFT OUTER JOIN #temp c on a.name = c.jname and a.job_id = c.Jid
-- -- -- -- -- -- -- 
where   a.enabled = 1 and b.enabled =1  


Order by 1

Drop Table #Temp


-- GO
-- SET QUOTED_IDENTIFIER OFF 
-- GO
-- SET ANSI_NULLS ON 
-- GO
