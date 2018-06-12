/* Gera um script para Executar o dettach dos bancos */

declare @cont int
declare @banco sysname
declare @str varchar (255)
declare @loop int
select @cont=max(dbid) from sysdatabases where dbid > 6
set @loop =7
while @loop <= @cont
begin
set @banco = convert(sysname, db_name(@loop))
set @str = 'sp_detach_db '+@banco+'
go'
print @str
set @loop=@loop+1
END
