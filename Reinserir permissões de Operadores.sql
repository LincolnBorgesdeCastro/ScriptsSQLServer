-- Esse script gera o script de readequação dos grupos de um operador de acordo com os dados que estão inseridos na tabela Operadores_Grupos e resincroniza com os papeis(ROLE) do banco de dados
-- Digitar o CTRL + T para o resultar sair em modo texto
Use IPASGO
GO
/*
select * from Operadores where NOME_Operador = '12426652187'

select * from RH_Colaboradores  where NUMR_CPF = '12426652187'

select * from ipasgo.dbo.Operadores_Grupos where NUMG_operador = 2620

select * from ipasgo.dbo.Operadores_Grupos og inner join Grupos g on og.Numg_grupo = g.Numg_Grupo where NUMG_operador = 2620

select * from ipasgo.dbo.grupos where SIGL_grupo = 'SIGA - MOVIMENTAR CONTAS'-- 424

--Sp_HelpUser '12426652187'
*/

Set Nocount on

Declare @NUMG_operador int = 2620

-- Fazendo um bkp dos dados de grupos do operadores
Select *
into #Operadores_Grupos -- Select * from #Operadores_Grupos 
from ipasgo.dbo.Operadores_Grupos 
where NUMG_operador = @NUMG_operador

-- Gerando o Script de deleção dos grupos do operador para posterior inserção
Select 'Delete from ipasgo.dbo.Operadores_Grupos where NUMG_operador = '+Cast(@NUMG_operador as varchar)+' And NUMG_grupo = '+cast(NUMG_grupo as varchar) + '
GO' 
from ipasgo.dbo.Operadores_Grupos 
where NUMG_operador = @NUMG_operador

-- Removento todos os papeis que não estão na Operadores_Grupos
SELECT 'ALTER ROLE [' + DP1.name + '] DROP MEMBER ['+Ope.NOME_Operador+']
GO'
FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
                                        INNER JOIN sys.database_principals AS DP2   ON DRM.member_principal_id = DP2.principal_id  
										INNER JOIN IPASGO.dbo.Operadores   AS Ope   On DP2.name = Ope.NOME_Operador
WHERE DP1.type = 'R'
And ( -- Teste tabela Operadores_Grupos
		Select count(*) 
		from ipasgo.dbo.Operadores_Grupos og
		where og.NUMG_operador = Ope.NUMG_operador
		And   og.Numg_Grupo IN (Select g.Numg_Grupo from Ipasgo.dbo.Grupos g where g.SIGL_grupo COLLATE SQL_Latin1_General_CP1_CI_AI = DP1.name COLLATE SQL_Latin1_General_CP1_CI_AI)
	 ) = 0 -- esse teste é pra pegar quem não tem o registro inserido na Operadores_Grupos
	 -- Se quiser ver os que ainda tem registros inseridos na operadores cadastro é so testar maior que zero (> 0)
And Ope.NUMG_Operador = @NUMG_operador
And DP1.name Not In ('siga - supervisor')

-- Gerando o Script de Reinsersão dos registro para rodar a inclusão dos papeis
Select 'Insert into ipasgo.dbo.Operadores_Grupos(NUMG_operador,NUMG_grupo) values('+Cast(@NUMG_operador as varchar)+','+cast(NUMG_grupo as varchar)+')
GO' 
from ipasgo.dbo.Operadores_Grupos 
where NUMG_operador = @NUMG_operador

