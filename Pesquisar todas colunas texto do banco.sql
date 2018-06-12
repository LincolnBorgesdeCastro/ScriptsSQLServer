select  'select * from ' + OBJECT_name(object_id) + ' where ' + name + ' like ''%kiribati%'' '
from sys.columns 
where 
--name like '%desc%' and 
OBJECT_name(object_id)   not in ('sysftproperties','sqlagent_jobs') and
TYPE_NAME(system_type_id) in ('varchar','nchar','char','ntext','nvarchar') and
OBJECT_name(object_id)   not like 'sys%'
