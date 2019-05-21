


--Conforme solicitado pelo supervisor Gabriel, por motivo de segurança em sistemas do IPASGO, fazer o reset das senhas no banco de dados dos colaboradores listados no script abaixo:

SELECT 'ALTER LOGIN [' + cast(ope.NOME_Operador as varchar(20)) + '] WITH PASSWORD=N'''' 
GO'
from Operadores Ope
Inner JOin dbo.RH_Colaboradores Col on Ope.NOME_Operador = Col.NUMR_CPF
UNION
SELECT  'ALTER LOGIN [' + cast(ope.NOME_Operador as varchar(20)) + '] WITH PASSWORD=N''''
GO' 
from Operadores Ope
Left JOin dbo.RH_Colaboradores Col on Ope.NOME_Operador = Col.NUMR_CPF
WHERE	
	col.NUMR_CPF is null
	and Ope.FLAG_AtendeMais = 1
order by 1

