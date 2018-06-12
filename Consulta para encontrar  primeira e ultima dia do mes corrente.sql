USE SBD
GO
--Drop FUNCTION fn_RetornaData
Create FUNCTION fn_RetornaData(@Data DATETIME = null, @Opcao INT = 3)
RETURNS  DATE
AS
BEGIN
/*
Opção 1 - Retorna Ultimo dia mês anterior
Opção 2 - Retorna Primeiro dia mês atual
Opção 3 - Retorna hoje - Getdate()
Opção 4 - Retorna ultimo dia mês atual
Opção 5 - Retorna Primeiro dia mês seguinte
*/

Declare @DataRetorno date

select @data = isNull(@data, GETDATE());

if      (@opcao = 1) SELECT @DataRetorno = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Data)),@Data),101)                               
else if (@opcao = 2) SELECT @DataRetorno = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Data)-1),@Data),101) 
else if (@opcao = 3) SELECT @DataRetorno = CONVERT(VARCHAR(25),@Data,101)                             
else if (@opcao = 4) SELECT @DataRetorno = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Data))), DATEADD(mm,1,@Data)),101)  
else if (@opcao = 5) SELECT @DataRetorno = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Data))-1), DATEADD(mm,1,@Data)),101)


Return @DataRetorno 
END

--Select sbd.dbo.fn_RetornaData('2017-10-15',4)

/*
declare @mydate date = getdate()
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),101)                               , 'Last Day of Previous Month'              UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101) AS Date_Value               , 'First Day of Current Month' AS Date_Type UNION 
SELECT CONVERT(VARCHAR(25),@mydate,101)                               AS Date_Value               , 'Today'                      AS Date_Type UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))), DATEADD(mm,1,@mydate)),101)  , 'Last Day of Current Month'               UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1), DATEADD(mm,1,@mydate)),101), 'First Day of Next Month'
*/
