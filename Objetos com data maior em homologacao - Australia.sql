USE IPASGO
GO

DECLARE @DESC_Objetos  VARCHAR(MAX)

SET @DESC_Objetos = CHAR(10)

SELECT 
@DESC_Objetos = @DESC_Objetos + 
LEFT(OBJECT_NAME(sm.OBJECT_ID)+ REPLICATE(' ',40), 40) + ' - '  +
          (case o.type            
					 when 'FN' THEN  'Function'
					 when 'IF' THEN  'Function'
					 when 'P'  THEN  'Procedure'	 
					 when 'TF' THEN  'Function'
					 when 'TR' THEN  'Trigger'
					 when 'V'  THEN  'View'
					 when 'X'  THEN  'Ext.Procedure'
					END) + CHAR(10)
FROM IPASGO.sys.sql_modules AS sm INNER JOIN IPASGO.sys.objects AS o ON sm.object_id = o.object_id
                                  LEFT JOIN ASSISTENCIA.IPASGO.sys.objects ass on o.name = ass.name
WHERE o.type IN ('FN','IF','TR','V','P', 'X','TF')
AND   o.modify_date > ass.modify_date
order by o.type, o.name 

IF LEN(@DESC_Objetos) > 1
BEGIN

	SET @DESC_Objetos = 'Objeto(s) database IPASGO: ' + char(10) + @DESC_Objetos + char(10) +
                	    'Atenciosamente,' + char(10) + char(10) + 'Coordena��o de Dados e Informa��es'

	EXEC msdb.dbo.sp_send_dbmail @profile_name  = 'GTI_DBA',
	@recipients    = 'gti_lideres@ipasgo.go.gov.br',
	@body          = @DESC_Objetos,
	@subject       = 'Objetos com data de modifica��o no servidor de homologa��o maior que o de produ��o.'
END
