




delete
--select *  
from dbo.gs_SolPerSistAdiciona where  NUMG_Solicitacao = 16170


delete
--select *  
from dbo.gs_SolPerSistemas where  NUMG_OperadorSol = 6394

create user [04628444111] without login

delete 
--select *  
from Operadores_Grupos where  NUMG_operador = 6394

drop user [04628444111] 

delete 
--select *  
from Operadores where  NOME_Operador = '04628444111'



