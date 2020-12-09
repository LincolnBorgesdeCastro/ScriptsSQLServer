Declare @Dias int = -1                      -- Quantos dias antes até a data atual que deseja consultar
Declare @Caminho Varchar(200)               -- Caminho onde esta o arquivos para consultar
Declare @Server  Varchar(100) --= 'ROMENIA' -- Servidor que gerou o arquivo de auditoria

If @Server is Null set @Server = @@SERVERNAME

Set @Caminho  = '\\catar\Auditorias\'+ SBD.dbo.fn_ServerName() +'\Audit_DCL_NORTE*.sqlaudit'

SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), CURRENT_TIMESTAMP), event_time) AS event_time_afterconvert
	,getdate() 'Current_system_time'
	,statement
	,class_type
	,*
FROM fn_get_audit_file(@Caminho, DEFAULT, DEFAULT) 
Where event_time >= DATEADD(DAY, @Dias, Cast(GETDATE() as date)) 
Order by 1 desc


/*

/* Lista de actions */
Select DISTINCT action_id,name,class_desc,parent_class_desc from sys.dm_audit_actions
where action_id = 'VSST'

Consulta ID de Action
Select SBD.dbo.GetInt_action_id('A')

Consulta ID de Class Type
Select SBD.dbo.GetInt_class_type('A')

*/
