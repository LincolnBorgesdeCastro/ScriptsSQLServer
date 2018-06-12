SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), CURRENT_TIMESTAMP), event_time) AS event_time_afterconvert
	,getdate() 'Current_system_time'
	,*
FROM fn_get_audit_file('...\*', DEFAULT, DEFAULT)