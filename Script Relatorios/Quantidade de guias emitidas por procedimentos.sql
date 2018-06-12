select pro.codg_procedimento Código, pro.desc_procedimento Procedimento,  count(distinct g.numg_guia) Quantidade
from ipasgo.dbo.guias g
inner join ipasgo.dbo.procedimentos_Guias pg on g.numg_guia = pg.numg_guia
inner join ipasgo.dbo.sa_procedimentos pro on pg.numg_procedimento = pro.numg_procedimento
left join ipasgo.dbo.at_guiasCanceladas gc on g.numg_guia = gc.numg_guia
where gc.numg_guia is null
	  and pg.numg_procedimento in (9810, 9811, 9812)
	  and g.data_emissao between '2016-06-26 00:00:01' and '2016-07-25 23:59:01'
group by pro.codg_procedimento, pro.desc_procedimento