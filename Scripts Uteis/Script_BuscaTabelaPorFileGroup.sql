-- Mostra as tabelas e seus respectivos filegroups

Select 	distinct Object_Name(a.id) as TableName,
	a.Name as IndexName,
	c.groupname,
--	b.Name as FileGroupName,
	b.FileName as LocationFileGroup
from  sysindexes a Join SysFiles b on
	b.groupid = a.groupid
	join sysfilegroups c on 
	c.groupid = b.groupid
where a.id> 99 
order by Object_Name(a.id)


