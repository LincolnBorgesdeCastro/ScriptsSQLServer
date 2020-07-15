
Declare @NOME_Operador varchar(200) = 'operadores'
Declare @Script varchar(8000)

-- Permissões nos DATABASES
Select @Script = 'USE ?

if (SELECT  count(*)
    FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id  
											INNER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id  
		WHERE DP1.type = ''R''

     And Dp2.name = '''+@NOME_Operador+''') > 0


SELECT ''?'' as Banco, DP1.name as [Role_Database], Dp2.name as [User_Database]
		FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id  
												INNER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id  
		WHERE DP1.type = ''R''

And Dp2.name = '''+@NOME_Operador+''' '

Exec sp_MSforeachdb @Script

-- Permissões no Servidor
SELECT  DP1.name as [Role_Server], Dp2.name as [Login]
		FROM sys.server_role_members AS DRM INNER JOIN sys.server_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id  
											INNER JOIN sys.server_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id  
		WHERE DP1.type = 'R'

And Dp2.name = @NOME_Operador


--alter server role [securityadmin] drop  member operadores
--alter role [db_securityadmin] drop  member operadores

--alter server role [securityadmin] add  member operadores
--alter role [db_securityadmin] add  member operadores
