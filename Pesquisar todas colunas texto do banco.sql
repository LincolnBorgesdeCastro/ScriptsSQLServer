
/*Pesquisar todas colula que possui um determinado texto no nome do campo*/

SELECT c.name, s.name + '.' + o.name
FROM sys.columns c
   INNER JOIN sys.objects  o ON c.object_id=o.object_id
   INNER JOIN sys.schemas  s ON o.schema_id=s.schema_id
WHERE c.name LIKE '%mail%' AND o.type = 'U'



/******************************************************************************************************************/


select  'select * from ' + OBJECT_name(object_id) + ' where ' + name + ' like ''%kiribati%'' '
from sys.columns 
where 
--name like '%desc%' and 
OBJECT_name(object_id)   not in ('sysftproperties','sqlagent_jobs') and
TYPE_NAME(system_type_id) in ('varchar','nchar','char','ntext','nvarchar') and
OBJECT_name(object_id)   not like 'sys%'
