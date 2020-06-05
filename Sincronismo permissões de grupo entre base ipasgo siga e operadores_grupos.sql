-- Retorna os usuario que esta no papel da variavel @Grupo na base IPASGO
-- Que esta ou não na base SIGA (de acordo com o comando NOT IN ou IN)
-- Que esta ou não inserido na tabela Operadores_Grupos (De acordo com o sinal > ou o sinal =)

declare @Grupo varchar(50) = 'SIGA - SUPERVISOR'
--declare @Grupo varchar(50) = 'SIGA - AUDITORIA'

;With cte_Membros As -- Teste da base IPASGO
(
Select isnull (DP2.name, 'No members') AS DatabaseUserName   
									From IPASGO.sys.database_role_members AS DRM   INNER JOIN IPASGO.sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
									                                               INNER JOIN IPASGO.sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
									Where DP1.type = 'R'
									And DP1.name = @Grupo
									--And DP2.name = 'santos'
)

Select Mem.DatabaseUserName, ope.NOME_Completo, ope.DATA_Bloqueio, ope.NUMG_Secao, ope.DATA_Inclusao as Data_Inclusao_Operador
, 'ALTER ROLE [' +@Grupo+ '] ADD MEMBER [' +Mem.DatabaseUserName+ ']'
From cte_Membros Mem inner join ipasgo.dbo.operadores ope on Mem.DatabaseUserName = ope.NOME_Operador
where ope.data_bloqueio is null
And Mem.DatabaseUserName NOT IN -- Teste da base SIGA
( 
	Select isnull (DP2.name, 'No members') AS DatabaseUserName   
										From SIGA.sys.database_role_members AS DRM   INNER JOIN SIGA.sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
										                                        INNER JOIN SIGA.sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
										Where DP1.type = 'R'
										And DP1.name = @Grupo
										--And DP2.name = 'santos'
)

And ( -- Teste tabela Operadores_Grupos
		Select count(*) 
		from ipasgo.dbo.Operadores_Grupos og
		where og.NUMG_operador = Ope.NUMG_operador
		And   og.Numg_Grupo IN (Select g.Numg_Grupo from Ipasgo.dbo.Grupos g where g.SIGL_grupo COLLATE SQL_Latin1_General_CP1_CI_AI = @Grupo COLLATE SQL_Latin1_General_CP1_CI_AI)
	 ) = 0 -- esse teste é pra pegar quem não tem o registro inserido na Operadores_Grupos
	 -- Se quiser ver os que ainda tem registros inseridos na operadores cadastro é so testar maior que zero (> 0)

--and numg_secao not in ()