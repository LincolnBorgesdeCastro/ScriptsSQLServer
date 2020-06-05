
/**************************************************************************/
/**************************************************************************/
/* Script para encontrar operadores que estão na tabela de Operadores_Grupos e não estão na ROLE do banco de dados */
/**************************************************************************/
/**************************************************************************/

Declare @SIGL_Grupo varchar(128) = 'SAAT - Cancela Guias'
Declare @NUMG_Grupo int = (Select NUMG_Grupo from IPASGO.dbo.grupos where SIGL_grupo = @SIGL_Grupo)

Select 'ALTER ROLE ['+@SIGL_Grupo+'] ADD MEMBER ['+Ope.NOME_Operador +']
GO' as Script , Ope.* 
From IPASGO.dbo.Operadores_Grupos Gope inner join IPASGO.dbo.Operadores Ope on Gope.NUMG_operador = Ope.NUMG_Operador
Where NUMG_grupo = @NUMG_Grupo
and Ope.DATA_Bloqueio IS NULL
and Ope.NOME_Operador not in  (	SELECT DP2.name AS DatabaseUserName   
									FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
									                                                            INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
									WHERE DP1.type = 'R'
									And DP1.name = @SIGL_Grupo
									And DP2.name = Ope.NOME_Operador
								)

And Ope.NOME_Operador in (select name from sys.syslogins where name = Ope.NOME_Operador)


/**************************************************************************/
/**************************************************************************/
--É Membros da ROLE do banco mas não tem na tabela Operadores_Grupos 
/**************************************************************************/
/**************************************************************************/


Declare @SIGL_Grupo varchar(128) = 'SAAT - TROCA DE GUIAS'
Declare @NUMG_Grupo int = (Select NUMG_Grupo from IPASGO.dbo.grupos where SIGL_grupo = @SIGL_Grupo)

SELECT 'ALTER ROLE ['+DP1.name+'] DROP MEMBER ['+Dp2.name +']
GO' as Script , DP2.name AS DatabaseUserName   
FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                        INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
And DP1.name = @SIGL_Grupo
And Dp2.name not in (
						Select Ope.NOME_Operador 
						From IPASGO.dbo.Operadores_Grupos Gope inner join IPASGO.dbo.Operadores Ope on Gope.NUMG_operador = Ope.NUMG_Operador
						                         --   inner join #operadores_grupo tempOpe on Ope.NUMG_Operador = tempOpe.NUMG_Operador  
						Where Gope.NUMG_grupo = @NUMG_Grupo
						And   Ope.Nome_Operador = Dp2.name
						And Ope.DATA_Bloqueio IS NULL
					)
And Dp2.name in (select name from sys.syslogins where name = Dp2.name)


/**************************************************************************/
/**************************************************************************/

/**************************************************************************/
/**************************************************************************/
-- Usuarios dentro de uma role do banco
/**************************************************************************/
/**************************************************************************/
SELECT isnull (REPLACE(DP2.name,'IPASGO\','' ), 'No members') AS DatabaseUserName   
FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                                            INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
And DP1.name = 'SAAT - Cancela Guias';


/**************************************************************************/
/**************************************************************************/
-- Operadores dentro do siga - supervisor
/**************************************************************************/
/**************************************************************************/

select NOME_Operador, NOME_Completo, DATA_Bloqueio, NUMG_Secao, DATA_Inclusao
from ipasgo.dbo.operadores ope 
where NOME_Operador In (SELECT isnull (REPLACE(DP2.name,'IPASGO\','' ), 'No members') AS DatabaseUserName   
									FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
									                                                            INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
									WHERE DP1.type = 'R'
									And DP1.name = 'SIGA - SUPERVISOR')
order by DATA_Inclusao

/**************************************************************************/
/**************************************************************************/
-- Membros do SIGA - SUPERVISOR e seus possiveis operadores 
/**************************************************************************/
/**************************************************************************/

;With cte_Membros As 
(
Select isnull (DP2.name, 'No members') AS DatabaseUserName   
--Select isnull (REPLACE(DP2.name,'IPASGO\','' ), 'No members') AS DatabaseUserName   
									From sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
									                                                            INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
									Where DP1.type = 'R'
									And DP1.name = 'SIGA - SUPERVISOR'
									--And DP2.name = 'santos'
)


Select Mem.DatabaseUserName, ope.NOME_Completo, ope.DATA_Bloqueio, ope.NUMG_Secao, ope.DATA_Inclusao as Data_Inclusao_Operador
From cte_Membros Mem left join ipasgo.dbo.operadores ope on Mem.DatabaseUserName = ope.NOME_Operador

Order by ope.DATA_Inclusao


--Não é Membros do SIGA - SUPERVISOR na base SIGA e pois permissão em algum grupo SIGA na OPERADORES_GRUPO da base IPASGO.
/**************************************************************************/
/**************************************************************************/

Select DISTINCT ope.NOME_Operador
From Operadores_Grupos opegru inner join operadores ope on opegru.NUMG_operador = ope.NUMG_operador 
Where NUMG_grupo IN (105,145,113,118,119,120,121,122,123,126,134,142,205,217,225,230,256,117,270,401,423,424,519,550,592,631,632,211,212)
And ope.DATA_Bloqueio is null
And  ope.NOME_Operador not in (SELECT Rtrim(Ltrim(DP2.name)) AS DatabaseUserName   
FROM SIGA.sys.database_role_members AS DRM   INNER JOIN SIGA.sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                        INNER JOIN SIGA.sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
And DP1.name = 'SIGA - SUPERVISOR')

/**************************************************************************/
/**************************************************************************/
--Pesquisa qual grupo(role) que um usuario esta em todos os bancos
Exec sp_MSforeachdb 'USE ?
If object_id(''tempdb..#tmpRoleMember'') is not null drop table #tmpRoleMember

SELECT ''[?]'' as [Database], DP1.name as [Role_Database], Dp2.name as [User_Database]
into #tmpRoleMember
FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                        INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = ''R''
And DP2.name like ''%86273795134%''
--And DP1.name in (''db_datareader'', ''db_datawriter'', ''db_ddladmin'')

If (Select Count(*) from #tmpRoleMember) > 0 Select * from #tmpRoleMember

'

/**************************************************************************/
/**************************************************************************/
-- Script que pega os registros da Operadores_Grupos e verifica se o Operador comtém a ROLE do banco de dados.
Declare @NUMG_Operador int = 5066

Select 'ALTER ROLE ['+Gru.SIGL_grupo+'] ADD MEMBER ['+Ope.NOME_Operador +']' as Script , Ope.NOME_Operador, Ope.NOME_Completo, Gru.DESC_grupo
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
And DESC_grupo not like 'Relatórios Ipasgo -%'
--And Gru.SIGL_grupo like 'SIGA%' -- Se for IPASGO tem que comntar essa linha
And Ope.NOME_Operador in (select name from sys.syslogins where name = Ope.NOME_Operador)

/**************************************************************************/
