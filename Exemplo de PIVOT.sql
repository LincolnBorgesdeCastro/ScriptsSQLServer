

DECLARE @ColunasPivot VARCHAR(8000)
DECLARE @GrupoPivot NVARCHAR(MAX)
DECLARE @NUMG_Processo  int

SET @NUMG_Processo = 1947217

SELECT @ColunasPivot = COALESCE(@ColunasPivot + ',[' + (right('00'+ (convert(varchar,bo.numr_mes)),2) + '/' + right('0000' + (convert(varchar,bo.numr_ano)),4)) + ']',
                                                '[' + (right('00'+ (convert(varchar,bo.numr_mes)),2) + '/' + right('0000' + (convert(varchar,bo.numr_ano)),4)) + ']')
FROM pg_Bordero bo
where Convert(date, convert(varchar, bo.numr_ano) + '-' + convert(varchar, bo.numr_mes) + '-' + '01', 121) >= Convert(date,DATEADD(mm,-10,GETDATE()),103)

and   numg_processo = @NUMG_Processo
GROUP BY (right('00'+ (convert(varchar,bo.numr_mes)),2) + '/' + right('0000' + (convert(varchar,bo.numr_ano)),4))
 

--select @ColunasPivot

SET @GrupoPivot = N'SELECT * 
                    FROM (SELECT (right(''00''+ (convert(varchar,numr_mes)),2) + ''/'' + right(''0000'' + (convert(varchar,numr_ano)),4)) as Referencia, VALR_Bruto
					      FROM dbo.pg_Bordero where numg_processo = ' + convert(varchar,@NUMG_Processo) + '
                          AND  Convert(date, convert(varchar, numr_ano) + ''-'' + convert(varchar, numr_mes) + ''-'' + ''01'', 121) >= Convert(date,DATEADD(mm,-10,GETDATE()),103)						  
						  
						  ) AS P PIVOT
                    (SUM(VALR_Bruto) 
                     FOR Referencia IN (' + @ColunasPivot + ')) AS Pvt'
 
EXECUTE(@GrupoPivot)


