--Listing 1
------------
--drop table DimDate
if object_id('DimDate') IS NOT NULL
drop table DimDate
create table DimDate(
DateKey int NOT NULL
,DayOfMonth tinyint NULL
,MonthOfYear tinyint NULL
,[Year] smallint NULL
,[DayOfWeek] varchar(15) NULL
,WeekOfYear tinyint NULL
,[DayOfYear] smallint NULL
,[MonthName] varchar(20) NULL
,[Quarter] tinyint NULL
,QuarterName varchar(20) NULL
,IsLastDayOfMonth char(1) NULL
,IsHoliday char(1) NULL
,HolidayName varchar(50) NULL
,HolidayDescription varchar(150) NULL
)

GO
--Listing 2
----------
declare @startDate as datetime,@enddate as datetime
--initialize
set @startDate = '01/01/2007'
set @enddate = '01/01/2029'

while @startDate<@enddate
begin
insert into DimDate(
DateKey
,[DayOfMonth]
,MonthOfYear
,[Year]
,[DayOfWeek]
,WeekOfYear
,[DayOfYear]
,[MonthName]
,[Quarter]
,QuarterName)
select cast(convert(varchar(8),@startdate,112) as int)
,day(@startdate)
,Month(@startdate)
,Year(@startdate)
,datename(weekday,@startdate) as WeekDay
,datename(week,@startdate) as Week
,datename(dayOfYear,@startdate) as dayOfYear
,datename(month,@startdate) as MonthName
,datename(quarter,@startdate) as Quarter
,CASE datename(quarter,@startdate)
WHEN 1 THEN 'First Quarter'
WHEN 2 THEN 'Second Quarter'
WHEN 3 THEN 'Third Quarter'
WHEN 4 THEN 'Fourth Quarter'
END AS QuarterName

set @startDate = @startDate +1
end
GO

--Listing 3
------------

CREATE FUNCTION fnGetLastDayOfMonth
-- Input parameters
(
@Anydate datetime
)
RETURNS datetime AS
/********************************************************************
Returns the last day of the month (extracted from the date passed)
*********************************************************************/
BEGIN
-- add one month to the datepassed
SET @Anydate = DATEADD(m,1,@Anydate)
RETURN DATEADD(d,-datepart(d,@Anydate),@Anydate)
END

GO
--Update the column IsLastDayOfMonth
UPDATE
DimDate
SET
IsLastDayOfMonth = CASE WHEN dbo.fnGetLastDayOfMonth(cast(DateKey as varchar(10)))= Cast(Cast(DateKey as varchar(10)) as datetime) THEN 'Y'
ELSE 'N' END

GO
select * from DimDate



