
declare @dbname varchar(100)
declare @sqlstring varchar(3000)
select @dbname = max(name) from master.dbo.sysdatabases
where dbid > 4

Create table #id (DatabaseName varchar(100), TableName varchar(100), WhatIsMissing varchar(100))
while @dbname is not null
begin
 set @sqlstring = 'use  '+ @dbname + ' insert into #id  select ' + char(39) + @dbname +char(39)+ ', o.Table_Name, ''No primary key''
FROM
(select name as Table_Name from sysobjects where xtype = ''U'') o
LEFT OUTER JOIN
(
SELECT Table_Name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = ''PRIMARY KEY'') pk
on pk.Table_Name = o.Table_Name
WHERE pk.Table_Name is null and  o.Table_Name not like ''zz%'''

exec(@sqlstring)



 set @sqlstring = ' insert into #id select ' + char(39) + @dbname +char(39)+ ', o.name, ''No clustered index''
	from sysobjects o
	left outer join (select distinct object_name(id) 
	as TableName from sysindexes where indid = 1) t
	on t.TableName = o.name
	where o.xtype = ''u'' and t.TableName is null'

exec(@sqlstring)


 set @sqlstring = ' insert into #id  select ' + char(39) + @dbname +char(39)+ ', name, ''No index''
	from sysobjects where xtype = ''u'' and 
id not in (select id from sysindexes where name not like ''_WA%'' and indid > 0)'

exec(@sqlstring)


select @dbname = max(name) from master.dbo.sysdatabases
where dbid > 4 and name < @dbname

end


select * from #id

drop table #id





