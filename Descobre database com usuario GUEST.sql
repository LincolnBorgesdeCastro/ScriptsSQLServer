USE master;
GO

declare @name sysname 
declare @cmd varchar(4000)

DECLARE databases_cursor CURSOR FOR
SELECT name FROM sys.databases where state in (0) and name not in ('master', 'tempdb')
order by name

create table #guest_users (
    database_name sysname, principal_name sysname, permission_name nvarchar(128), state_desc nvarchar(6)
)

OPEN databases_cursor;

FETCH NEXT FROM databases_cursor into @name;

WHILE @@FETCH_STATUS = 0
BEGIN
set @cmd = 'use ' + @name + '; 
insert into #guest_users
SELECT ''' + @name + ''' as database_name, name, permission_name, state_desc
 FROM sys.database_principals dpr
 INNER JOIN sys.database_permissions dpe
 ON dpr.principal_id = dpe.grantee_principal_id
 WHERE name = ''guest'' AND permission_name = ''CONNECT''
' 
exec (@cmd)
   FETCH NEXT FROM databases_cursor into @name;
END

select * from #guest_users order by database_name asc

drop table #guest_users

CLOSE databases_cursor;
DEALLOCATE databases_cursor;
GO
