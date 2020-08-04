-- Escolha a opção CTRL + T para o Resultado ser em modo texto
--Sp_HelpUser '12426652187'
Set Nocount ON
Use IPASGO
GO

--Select * from ipasgo.dbo.operadores where nome_operador = '40143155172'

-- Colocaque o NUMG_Operador para gerar o Script de sincronismo da tabela Operadores_Grupos com os papeis(ROLE) do banco
Declare @NUMG_Operador int = 2115
Declare @Nome_Operador Varchar(20) = (Select Nome_Operador from Ipasgo.dbo.Operadores where NUMG_Operador = @NUMG_Operador)

Select 'USE IPASGO
GO'

Select '----------------------------------------- Sincronismo da Base IPASGO -----------------------------------------'
Select 'ALTER ROLE ['+Gru.SIGL_grupo+'] ADD MEMBER ['+Ope.NOME_Operador +']' as Script
--, Ope.NOME_Operador, Ope.NOME_Completo, Gru.DESC_grupo
From IPASGO.dbo.Operadores Ope inner join IPASGO.dbo.Operadores_Grupos OpeGru on Ope.NUMG_Operador = OpeGru.NUMG_operador
                               inner join IPASGO.dbo.Grupos               Gru on OpeGru.NUMG_grupo = Gru.NUMG_grupo
Where Ope.NUMG_operador = @NUMG_Operador

and (SELECT Count(*) 
	 FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
	                                                             INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
	 WHERE DP1.type = 'R'
	 And DP1.name = Gru.SIGL_grupo
	 And DP2.name = Ope.NOME_Operador) = 0
And Gru.DATA_bloqueio IS Null
And Gru.DESC_grupo not like 'Relatórios Ipasgo -%' -- Grupos que somente tem na tabela e não existe role no Banco de Dados
And Gru.SIGL_grupo not like ('%[_]IN[_]%')         -- Grupos que somente tem na tabela e não existe role no Banco de Dados

And Ope.NOME_Operador in (select name from sys.syslogins where name = Ope.NOME_Operador)


--Declare @NUMG_Operador int = 3272
--Declare @Nome_Operador Varchar(20) = (Select Nome_Operador from Ipasgo.dbo.Operadores where NUMG_Operador = @NUMG_Operador)

SELECT 'ALTER ROLE ['+DP1.name+'] DROP MEMBER ['+Dp2.name +']
GO' as Script 
--, DP2.name AS DatabaseUserName   
FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                        INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
And DP2.name = @Nome_Operador
And (
		Select count(*) 
		from ipasgo.dbo.Operadores_Grupos og
		where og.NUMG_operador = @NUMG_Operador
		And   og.Numg_Grupo IN (Select g.Numg_Grupo from Ipasgo.dbo.Grupos g where g.SIGL_grupo = DP1.name)
	 ) = 0 -- esse teste é pra pegar quem não tem o registro inserido na Operadores_Grupos
	 -- Se quiser ver os que ainda tem registros inseridos na operadores cadastro é so testar maior que zero (> 0)
--And Dp1.Name not In ('SIGA - Supervisor')
And Dp1.Name not like 'DES_%'
And Dp2.name in (select name from sys.syslogins where name = Dp2.name)

Select '----------------------------------------- Sincronismo da Base SIGA -----------------------------------------'
Select 'USE SIGA 
GO'

--Declare @NUMG_Operador int = 3272

Select 'ALTER ROLE ['+Gru.SIGL_grupo+'] ADD MEMBER ['+Ope.NOME_Operador +']' as Script
--, Ope.NOME_Operador, Ope.NOME_Completo, Gru.DESC_grupo
From IPASGO.dbo.Operadores Ope inner join IPASGO.dbo.Operadores_Grupos OpeGru on Ope.NUMG_Operador = OpeGru.NUMG_operador
                               inner join IPASGO.dbo.Grupos               Gru on OpeGru.NUMG_grupo = Gru.NUMG_grupo
Where Ope.NUMG_operador = @NUMG_Operador

and (SELECT Count(*) 
	 FROM SIGA.sys.database_role_members AS DRM   INNER JOIN SIGA.sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
	                                                             INNER JOIN SIGA.sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
	 WHERE DP1.type = 'R'
	 And DP1.name = Gru.SIGL_grupo
	 And DP2.name = Ope.NOME_Operador) = 0
And Gru.DATA_bloqueio IS Null
And DESC_grupo not like 'Relatórios Ipasgo -%'
And Gru.SIGL_grupo like 'SIGA%' -- Se for IPASGO tem que comntar essa linha
And Ope.NOME_Operador in (select name from sys.syslogins where name = Ope.NOME_Operador)

--Declare @NUMG_Operador int = 3272
--Declare @Nome_Operador Varchar(20) = (Select Nome_Operador from Ipasgo.dbo.Operadores where NUMG_Operador = @NUMG_Operador)

SELECT 'ALTER ROLE ['+DP1.name+'] DROP MEMBER ['+Dp2.name +']
GO' as Script 
--, DP2.name AS DatabaseUserName   
FROM SIGA.sys.database_role_members AS DRM   INNER JOIN SIGA.sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                             INNER JOIN SIGA.sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
And DP2.name = @Nome_Operador
And (
		Select count(*) 
		from ipasgo.dbo.Operadores_Grupos og
		where og.NUMG_operador = @NUMG_Operador
		And   og.Numg_Grupo IN (Select g.Numg_Grupo from Ipasgo.dbo.Grupos g where g.SIGL_grupo = DP1.name)
	 ) = 0 -- esse teste é pra pegar quem não tem o registro inserido na Operadores_Grupos
	 -- Se quiser ver os que ainda tem registros inseridos na operadores cadastro é so testar maior que zero (> 0)

--And Dp1.Name not In ('SIGA - Supervisor')
And Dp1.Name like 'SIGA%' -- Se for IPASGO tem que comntar essa linha
And Dp1.Name not like 'DES_%'
And Dp2.name in (select name from sys.syslogins where name = Dp2.name)


Select '--------------------------------------------------------------------------------------------------------------'
Select 'USE IPASGO
GO'
