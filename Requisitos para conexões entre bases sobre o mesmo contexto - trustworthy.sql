
-- As bases devem estar com o comando de confiabilidade
ALTER DATABASE XXXX SET trustworthy ON

-- As bases devem ter o mesmo owner
EXEC dbo.sp_changedbowner @loginame = N'IPASGO\81084056199'

-- As bases devem tem o usuario guest com permissão de conexão ou o procedimento deve estar com o execute as owner.
-- Quando não se quer usar execute as owner nas procedures ou triggers devera obrigatoriamente liberar conexão para o guest

grant connect to guest 
ou 
execute as owner

