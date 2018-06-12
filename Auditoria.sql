SELECT session_id
      ,event_time
      ,server_instance_name
	  ,database_name
	  ,schema_name
      ,object_name
	  ,class_type
	  ,action_id
	  ,statement
--select * 
FROM sys.fn_get_audit_file ('E:\Auditorias\*.sqlaudit',default,default)
order by event_time



SELECT 
event_time 'horario', 
database_name + '.' + schema_name + '.' + object_name 'objeto', 
statement, 
server_principal_name 'login', 
session_server_principal_name 'user' 
FROM sys.fn_get_audit_file (N'\\irlanda\Alwayson\*',default,default) 
--WHERE action_id = 'SL';




SELECT 
event_time 'horario', 
database_name + '.' + schema_name + '.' + object_name 'objeto', 
statement, 
server_principal_name 'login', 
session_server_principal_name 'user' 
FROM sys.fn_get_audit_file (N'E:\Auditorias\*',default,default) 
WHERE action_id = 'SL';

