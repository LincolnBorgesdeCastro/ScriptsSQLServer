SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), CURRENT_TIMESTAMP), event_time) AS event_time_afterconvert
	,getdate() 'Current_system_time'
	,statement
	,*
FROM fn_get_audit_file('\\catar\Auditorias\ASSISTENCIA\IPASGO\AUDT_PASSWORD*.*', DEFAULT, DEFAULT)
where event_time >= '2020-01-01'



/* Lista de actions */
Select DISTINCT action_id,name,class_desc,parent_class_desc from sys.dm_audit_actions
where action_id = 'VSST'

