--SQL 2000/2005 Version

set nocount on
go
DECLARE @SqlPort Nvarchar(10)
DECLARE @instance_name Nvarchar(30)
DECLARE @reg_key Nvarchar(500)
Declare @value_name Nvarchar(20)

if left(CAST(SERVERPROPERTY('ProductVersion')AS sysname),1) = '9'
BEGIN


select @instance_name = CAST(SERVERPROPERTY('instancename')AS sysname)

if @instance_name is NULL
BEGIN
set @reg_key = 'SOFTWARE\Microsoft\MSSQLServer\MSSQlServer\SuperSocketNetLib\Tcp'
END
ELSE BEGIN
set @reg_key = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + @instance_name + '\MSSQLServer\SuperSocketNetLib\Tcp'
END

EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE', 
@key=@reg_key, @value_name='TcpPort',
@value=@SqlPort output

select CAST(SERVERPROPERTY('ServerName')AS sysname) as ServerName, @SqlPort as Port

END


if left(CAST(SERVERPROPERTY('ProductVersion')AS sysname),1) = '8'
BEGIN

Create table #Port_2000 (value nvarchar(20),Data nVarchar(10))
insert into #Port_2000 exec master..xp_instance_regread 'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\Supersocketnetlib\tcp', 'tcpPort'
select @SqlPort = Data from #Port_2000
select CAST(SERVERPROPERTY('ServerName')AS sysname) as ServerName, @SqlPort as Port
drop table #Port_2000

END








