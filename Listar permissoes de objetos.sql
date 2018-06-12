Select object_name(major_id) as object,
       user_name(grantee_principal_id) as grantee,
       user_name(grantor_principal_id) as grantor,
       permission_name,
       state_desc
from  sys.database_permissions
WHERE state_desc = 'DENY'
and   object_name(major_id) = 'Usuarios'


SELECT * 
FROM master.sys.database_permissions dp JOIN sys.system_objects so ON dp.major_id = so.object_id
--WHERE dp.class = 1 
--AND so.parent_object_id = 0
--and state_desc = 'DENY'
