SELECT 'ALTER TABLE ['+USER_NAME(o.uid)+'].['+o.[name]+'] ALTER COLUMN ['+c.[name]+'] '+
CASE
WHEN c.prec IS NULL THEN t.[name]
ELSE t.[name]+'('+CONVERT(varchar(5),c.prec)+')'
END+' COLLATE '+t.collation+
CASE
WHEN c.isnullable = 1 THEN + ' NULL'
ELSE + ' NOT NULL'
END
FROM syscolumns c
JOIN sysobjects o ON (c.id = o.id)
JOIN systypes t ON (c.xusertype = t.xusertype)
WHERE c.collation IS NOT NULL
AND o.type = 'U'
AND c.collation <> t.collation
ORDER BY o.[name]