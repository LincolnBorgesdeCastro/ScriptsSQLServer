SET NOCOUNT ON
; with cte_Colaboradores (NUMR_CPF, DATA_Bloqueio) as
(
    Select C.NUMR_CPF, max(C.DATA_Bloqueio) DATA_Bloqueio
    from ipasgo.dbo.RH_Colaboradores C
    where C.NUMG_Situacao = 2                           -- Situação bloqueado
    And   C.NUMR_CPF Is not null
    And   C.DATA_Bloqueio IS NOT NULL                   -- Data Bloqueio da tabela de RH_colaboradores tem que ser nula
    
    And   C.NUMR_CPF not in (Select DIstinct NUMR_CPF
                               From   ipasgo.dbo.RH_Colaboradores Col2
                               Where  Col2.NUMR_CPF      = C.NUMR_CPF
                               AND    Col2.DATA_Bloqueio IS NULL) -- Removendo caso o Colaborar tiver mais de um registro na RH_Colaborador que ainda esta ativo
    group by C.NUMR_CPF
) --Select * from cte_Colaboradores

Select  'ALTER ROLE [' + Papeis.Role_Database + '] DROP MEMBER [' + Papeis.User_Database + ']
GO' as Script--, Papeis.*
--distinct Papeis.User_Database
--DISTINCT 'ALTER LOGIN ['+NOME_Operador+'] DISABLE' as Script,NOME_Operador, NOME_Completo, Ope.NUMG_Operador, Col.DATA_Bloqueio, Col.NUMG_MotivoBloqueio
From  ipasgo.dbo.Operadores Ope , cte_Colaboradores cte_Col, ipasgo.dbo.RH_Colaboradores  Col, sys.sql_logins l,
	(
		SELECT DP1.name as [Role_Database], Dp2.name as [User_Database]
		FROM sys.database_role_members AS DRM   INNER JOIN sys.database_principals AS DP1   ON DRM.role_principal_id = DP1.principal_id  
												INNER JOIN sys.database_principals AS DP2    ON DRM.member_principal_id = DP2.principal_id  
		WHERE DP1.type = 'R'
	) As Papeis

Where Ope.NOME_Operador = Col.NUMR_CPF               -- Junção tabela Operadores com RH_Colaboradores
And   Col.NUMR_CPF      = cte_Col.NUMR_CPF           -- Junção com cte para pegar somente o ultimo registro bloqueado do colaborador
And   Col.DATA_Bloqueio = cte_Col.DATA_Bloqueio      

And   Papeis.User_Database COLLATE SQL_Latin1_General_CP1_CI_AI = Ope.NOME_Operador COLLATE SQL_Latin1_General_CP1_CI_AI  -- Pegar os papeis dos operadores

And   Col.NUMG_Situacao = 2                           -- Situação bloqueado
And   Col.NUMG_MotivoBloqueio not in (13,14,15,30,31,32) -- 13 - LICENCA MEDICA 14 - LICENCA POR INTERESSE PARTICULAR 15 - LICENCA PREMIO 30 e 32 - FERIAS 31 - LICENCA MATERNIDADE
And   Ope.NOME_Operador = l.name                      -- Junção da tabela Operadores com visão dos logins
And   Ope.DATA_Bloqueio IS NOT NULL                   -- Data Bloqueio da tabela de Operadores tem que ser nula
And   l.is_disabled = 1                               -- Login que esta bloqeuado  

And Ope.NOME_Operador not in ('santos', 'SantosPre', 'SAATPRE', 'QUIOSQUE')
And Papeis.Role_Database not in ('SIGA - SUPERVISOR')

And (
		Select count(*) 
		from ipasgo.dbo.Operadores_Grupos og
		where og.NUMG_operador = Ope.NUMG_operador
		And   og.Numg_Grupo IN (Select g.Numg_Grupo from Ipasgo.dbo.Grupos g where g.SIGL_grupo COLLATE SQL_Latin1_General_CP1_CI_AI = Papeis.Role_Database COLLATE SQL_Latin1_General_CP1_CI_AI)
	 ) = 0 -- esse teste é pra pegar quem não tem o registro inserido na Operadores_Grupos
	 -- Se quiser ver os que ainda tem registros inseridos na operadores cadastro é so testar maior que zero (> 0)


Order By NOME_Completo


/*
Select RH_Colaboradores.data_bloqueio,RH_Colaboradores.NUMR_CPF,* from RH_Colaboradores 
where DATA_Bloqueio >(select modify_date from sys.procedures where name = 'up_opInsertOperadorColaborador')
and NUMG_MotivoBloqueio not in (13, 14, 15, 30, 31)

order by RH_Colaboradores.DATA_Bloqueio desc

select Operadores.data_bloqueio,* from Operadores
where DATA_Bloqueio >(select modify_date from sys.procedures where name = 'up_opInsertOperadorColaborador')
--and NOME_Operador = '01151503150'

order by Operadores.DATA_Bloqueio desc


declare @Ope varchar(20) = '47914904104'

Select data_bloqueio, * from ipasgo.dbo.RH_Colaboradores  where NUMR_CPF = @Ope

Select data_bloqueio,* from ipasgo.dbo.Operadores where NOME_Operador = @Ope


select * from ipasgo.dbo.operadores_grupos where numg_operador = 2314


--select * from grupos where numg_grupo = 186

*/