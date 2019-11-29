-- Procedure up_opBloqueiaOperador e up_opDesbloqueiaOperador foram atualizadas  30/08/2019

Select DISTINCT 'ALTER LOGIN ['+NOME_Operador+'] DISABLE' as Script, NOME_Operador, NOME_Completo, Ope.NUMG_Operador
From  ipasgo.dbo.Operadores Ope , ipasgo.dbo.RH_Colaboradores Col, sys.sql_logins l 
Where Ope.NOME_Operador = Col.NUMR_CPF               -- Junção tabela Operadores com RH_Colaboradores
And   Ope.NOME_Operador = l.name                     -- Junção da tabela Operadores com visão dos logins
And   Ope.DATA_Bloqueio IS NOT NULL                   -- Data Bloqueio da tabela de Operadores tem que ser nula
And   Col.DATA_Bloqueio IS NOT NULL                   -- Data Bloqueio da tabela de RH_colaboradores tem que ser nula
And   Ope.DATA_Bloqueio < '2019-07-01'                -- Pegando somente os Operadores Bloqueado de Junho/2019 para traz
And   Col.NUMG_Situacao = 2                           -- Situação bloqueado
And   Col.NUMG_MotivoBloqueio not in (13,14,15,30,31) -- 13 - LICENCA MEDICA 14 - LICENCA POR INTERESSE PARTICULAR 15 - LICENCA PREMIO 30 - FERIAS 31 - LICENCA MATERNIDADE
And   l.is_disabled = 0                               -- Login que esta ativo  
And   Col.NUMR_CPF not in (Select DIstinct NUMR_CPF 
                           From   ipasgo.dbo.RH_Colaboradores Col2 
	  					 Where  Col2.NUMR_CPF      = Col.NUMR_CPF 
	  					 AND    Col2.DATA_Bloqueio IS NULL) -- Removendo caso o Colaborar tiver mais de um registro na RH_Colaborador que ainda esta ativo

Order By NOME_Operador

