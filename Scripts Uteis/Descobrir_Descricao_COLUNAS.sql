
SELECT objtype, objname, name, value
FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', 'sigc_secoes', 'column', default);
GO
