--
-- Identificando Permissões
-- 
USE DB_Mundo;
Execute AS LOGIN = 'ipasgo\81084056100'  --<------- Digite aqui o nome do usuario !!
SELECT * FROM fn_my_permissions(NULL, 'Database') ORDER BY subentity_name, permission_name ; 
REVERT;
GO
 

-- Exemplo com os direitos na instancia:

USE DB_Mundo;
EXECUTE AS LOGIN = 'ipasgo\81084056100'; --<------- Digite aqui o nome do usuario !!
SELECT * FROM fn_my_permissions(NULL, 'SERVER'); 
GO 

-- Exemplo com os direitos nas Tabelas:

USE DB_Mundo;
SELECT * FROM fn_my_permissions('dbo.guias', 'OBJECT') 
ORDER BY subentity_name, permission_name ; 
GO 
