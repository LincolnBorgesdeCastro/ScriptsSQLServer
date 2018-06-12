
Create TRIGGER [Deny_DDL_ACCESS] ON DATABASE
  FOR 
    CREATE_TABLE, ALTER_TABLE, DROP_TABLE
   AS
BEGIN

   Declare @Count as int

   ;With cteRoles as (
   Select Roles.name as RoleName 
     From sys.server_role_members rm
       Inner Join sys.server_principals Roles ON rm.role_principal_id = Roles.principal_id
       Inner Join sys.server_principals Logins ON rm.member_principal_id = Logins.principal_id
             Where Logins.sid = suser_sid()    Union
   Select c.name as RoleName 
     From sysmembers a
       Inner Join sysusers c on a.groupuid = c.uid
    Where A.memberuid =  suser_id())
 Select @Count = Count(1) 
   From cteRoles
  Where RoleName in ('sysadmin', 'bulkadmin', 'db_owner')

   IF @Count = 0
      BEGIN
       ROLLBACK TRAN
       PRINT 'YOU ARE NOT ALLOWED TO EDIT TABLES WITH THE DDL'
       RETURN
      END
END
