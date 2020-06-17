SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), CURRENT_TIMESTAMP), event_time) AS event_time_afterconvert
	,getdate() 'Current_system_time'
	,*
FROM fn_get_audit_file('\\catar\Auditorias\ASSISTENCIA\IPASGO\AUDT_PASSWORD*.*', DEFAULT, DEFAULT)
where event_time >= '2020-01-01'
