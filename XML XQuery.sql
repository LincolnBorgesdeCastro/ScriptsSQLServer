--XQuery


IF OBJECT_ID('dbo.mail', 'U') IS NOT NULL
DROP TABLE dbo.mail
GO
DECLARE @xml XML
SELECT @xml = BulkColumn
FROM OPENROWSET(BULK 'D:\users.xml', SINGLE_BLOB) x
SELECT
Email = t.c.value('@Email', 'VARCHAR(255)')
, FullName = t.c.value('@FullName', 'VARCHAR(255)')
, Title = t.c.value('@Title', 'VARCHAR(255)')
, Company = t.c.value('@Company', 'VARCHAR(255)')
, City = t.c.value('@City', 'VARCHAR(255)')
INTO dbo.mail
FROM @xml.nodes('users/user') t(c)