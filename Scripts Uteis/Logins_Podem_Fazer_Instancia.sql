use ipasgo
SELECT
  dp.class_desc, 
  dp.permission_name, 
  dp.state_desc,
  ObjectName = OBJECT_NAME(major_id), 
  GranteeName = grantee.name, 
  GrantorName = grantor.name
FROM sys.database_permissions dp
JOIN sys.database_principals grantee 
on   dp.grantee_principal_id = grantee.principal_id
JOIN sys.database_principals grantor on dp.grantor_principal_id = grantor.principal_id
--where OBJECT_NAME(major_id) like 'guias%'
where grantee.name like '81084056100'
order by granteename
