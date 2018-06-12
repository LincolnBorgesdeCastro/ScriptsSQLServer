/* Script para gerar uma script de atachar os bancos já na ordem de seus IDs*/

declare @cont int
declare @banco sysname
declare @str varchar (255)
select @cont=max(dbid) from master..sysdatabases
declare @loop int
set @loop = 7
while @loop <= @cont
begin
set @banco = convert(sysname, db_name(@loop))
set @str = 'select "sp_attach_db '+@banco+',"""+RTRIM(filename)+"""," +(select """"+RTRIM(filename)+"""" from '+@banco+'..sysfiles where fileid = 2) from '+@banco+'..sysfiles where fileid = 1'
exec (@str)
PRINT 'GO'
set @loop=@loop+1
END
