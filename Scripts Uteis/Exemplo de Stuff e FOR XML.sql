select
	numg_justificativa,
	stuff(( select ', ' + convert(varchar, numg_procedimento)
		      From   aa_SolicitacoesAnalisesProcedimentos 
		      Where  numg_solicitacaoanalise  = sol.numg_solicitacaoanalise		
		      FOR XML path ('')
		    ) , 1, 2, '')  as teste
from	aa_SolicitacoesAnalisesProcedimentos sol
where sol.numg_solicitacaoanalise =  3322925
and   sol.numg_justificativa is not null
group by numg_justificativa, numg_solicitacaoanalise



	Select  stuff(',' + Cast(t.ID as varchar(9)), 1, 2, ' ') 
	From   OSMTD.dbo.OSSYS_EMAIL_CONTENT  c 
	Inner join OSMTD.dbo.OSSYS_TENANT t on c.TENANT_ID = t.ID
	FOR XML path ('')


