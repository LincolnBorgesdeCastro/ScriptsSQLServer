
DECLARE @StartDate DATE, @EndDate DATE
SELECT @StartDate = '2021-11-01', @EndDate = '2021-12-01'; 

WITH ListDates(AllDates) AS
(   SELECT @StartDate AS DATE
    UNION ALL
    SELECT DATEADD(DAY,1,AllDates)
    FROM ListDates 
    WHERE AllDates < @EndDate)
SELECT AllDates
FROM ListDates
GO
