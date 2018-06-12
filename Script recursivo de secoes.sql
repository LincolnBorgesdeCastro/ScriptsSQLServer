declare @NUMG_Secao int
set @NUMG_Secao = 7;
	
with 
TABL_SecoesEncontradas as (
    select
        s.numg_secao as NUMG_SecaoFilha 
    from
        ipasgo.dbo.sigc_Secoes s
    where s.NUMG_SecaoPai = @NUMG_Secao
),
TABL_SecoesFilhas as
(
	select 
		s.NUMG_Secao, s.NUMG_SecaoPai
	from
		TABL_SecoesEncontradas t
		inner join   ipasgo.dbo.sigc_Secoes s on t.NUMG_SecaoFilha IN (s.NUMG_SecaoPai , s.NUMG_Secao)

	union all

	select 
		s.NUMG_Secao, s.NUMG_SecaoPai
	from
		ipasgo.dbo.sigc_Secoes s
		inner join TABL_SecoesFilhas t on t.NUMG_SecaoPai = s.NUMG_Secao

) 

--insert #SecoesDiretorias
Select
distinct t.NUMG_SecaoPai, t.NUMG_Secao NUMG_SecaoFilha 
from TABL_SecoesFilhas t 
where t.NUMG_SecaoPai is not null
order by 1,2

--option (maxrecursion 32767) 


