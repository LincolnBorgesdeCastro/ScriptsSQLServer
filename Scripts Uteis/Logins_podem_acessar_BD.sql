SELECT UserName = dp.name, 
       UserType = dp.type_desc, 
       LoginName = sp.name, 
       LoginType = sp.type_desc 
FROM   sys.database_principals dp 
JOIN   sys.server_principals sp 
ON    dp.principal_id = sp.principal_id
--where sp.loginname like 'vfideles'
order by loginname,username
