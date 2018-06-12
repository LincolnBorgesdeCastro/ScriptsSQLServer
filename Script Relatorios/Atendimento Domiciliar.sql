
--Select * 
--from sa_servicoshospitalares
--where desc_ServicoHospitalar like '%Diaria%'
/*
Select  Numr_Prestador, NOME_Prestador, [2008], [2009], [2010], [2011], [2012], [2013], [2014], [2015], [2016]
from
(
Select f.Numr_Ano as Ano, pre.Numr_Prestador as Numr_Prestador, pre.NOME_Prestador as NOME_Prestador, count(Distinct g.Numg_Pessoa) as QtdPessoa, Count(a.Numg_Atendimento) as QtdAtendimento
from sa_tratamentosAtosDespesas tad inner join sa_tratamentosAtos ta on tad.Numg_Ato = ta.Numg_Ato
									inner join sa_Atendimentos a on ta.numg_atendimento = a.Numg_atendimento
									inner join sa_faturas f on a.Numg_fatura = f.Numg_Fatura
									inner join ipasgo.dbo.Guias g on a.Numg_Guia = g.Numg_Guia
									inner join ipasgo.dbo.pr_prestadores pre on f.Numg_Prestador = pre.Numg_Prestador
where numg_servicohospitalar in (83,84,85)
and f.numr_ano >= 2008 and f.numr_ano <= 2016
and f.Numr_tipoAtendimento not in (16,17)
group by  f.Numr_Ano, pre.Numr_Prestador, pre.NOME_Prestador


) p
 Pivot
(
 Sum(p.QtdPessoa)
--,Sum(p.QtdAtendimento)

 FOR Ano  in ([2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015],[2016])
) As pvt
order by  pvt.Numr_Prestador
*/
/*
Select f.Numr_Ano, pre.Numr_Prestador, pre.NOME_Prestador, count(Distinct g.Numg_Pessoa) as QtdPessoa, Count(a.Numg_Atendimento) as QtdAtendimento
from sa_tratamentosAtosDespesas tad inner join sa_tratamentosAtos ta on tad.Numg_Ato = ta.Numg_Ato
									inner join sa_Atendimentos a on ta.numg_atendimento = a.Numg_atendimento
									inner join sa_faturas f on a.Numg_fatura = f.Numg_Fatura
									inner join ipasgo.dbo.Guias g on a.Numg_Guia = g.Numg_Guia
									inner join ipasgo.dbo.pr_prestadores pre on f.Numg_Prestador = pre.Numg_Prestador
where numg_servicohospitalar in (83,84,85)
and f.numr_ano >= 2008 and f.numr_ano <= 2016
and f.Numr_tipoAtendimento not in (16,17)
group by  f.Numr_Ano, pre.Numr_Prestador, pre.NOME_Prestador
order by  f.Numr_Ano, pre.Numr_Prestador
*/



