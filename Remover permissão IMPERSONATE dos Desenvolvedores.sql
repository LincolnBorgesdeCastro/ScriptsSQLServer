-- Script que remove a permissao de imperssonate dos desenvolvedores. Pode ser filtrado por equipe passando a Sigla da equipe

declare @DESC_Comando varchar(800) = NULL
declare @NUMR_CPFColaborador varchar(15)

declare curCursor cursor 

for 
select distinct  p.NOME_Operador as NUMR_CPFColaborador
from assistencia.ipasgo.dbo.sigs_OperadoresEquipes o
	inner join assistencia.ipasgo.dbo.sigs_Equipes e on o.numg_equipe = e.numg_equipe
	inner join assistencia.ipasgo.dbo.operadores p on o.NUMG_OperadorEquipe = p.numg_operador
where p.DATA_Bloqueio is null 
--and e.NOME_Equipe = 'SCINOVA'

open curCursor

fetch next from curCursor into @NUMR_CPFColaborador

while	@@fetch_status = 0
begin
	
set @DESC_Comando = 'REVOKE IMPERSONATE ON USER::USR_SOBREAV TO [' + @NUMR_CPFColaborador + ']'
exec (@DESC_Comando)

fetch next from curCursor into @NUMR_CPFColaborador
end

close curCursor
deallocate curCursor

/*

use ipasgo
go

drop USER [USR_SOBREAV] 

use SIGA
go

drop user [USR_SOBREAV]

*/