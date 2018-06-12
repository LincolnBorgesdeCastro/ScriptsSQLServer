
select distinct month(g.DATA_emissao) as mes,
    day(g.DATA_emissao) as dia,
    g.NUMG_prestadorPJ,
    g.NUMG_Pessoa
into #guias
from dbo.guias g
    left join dbo.at_GuiasCanceladas gc
        on g.numg_guia = gc.numg_guia
where g.DATA_emissao between '2016-01-01' and '2016-05-31 23:59:59'
and g.NUMR_tipoGuia in (1,2,3,7)
and gc.NUMG_Guia is null
              
create index #guias_idx
on #guias
(numg_pessoa)

select distinct pes.numg_pessoa
into #emails
from dbo.gv_Pessoas pes
    inner join #guias g
        on pes.NUMG_Pessoa = g.numg_pessoa
    inner join dbo.gv_ContatosPessoa cp
        on pes.NUMG_Pessoa = cp.NUMG_Pessoa
    inner join dbo.gv_TiposContato tc
        on cp.NUMG_TipoContato = tc.NUMG_TipoContato
where tc.NUMG_TipoContato = 5 --e-mail

create index #emails_idx
on #emails
(numg_pessoa)

select distinct pes.numg_pessoa
into #celulares
from dbo.gv_Pessoas pes
    inner join #guias g
        on pes.NUMG_Pessoa = g.numg_pessoa
    inner join dbo.gv_ContatosPessoa cp
        on pes.NUMG_Pessoa = cp.NUMG_Pessoa
    inner join dbo.gv_TiposContato tc
        on cp.NUMG_TipoContato = tc.NUMG_TipoContato
    left join #emails e
        on pes.numg_pessoa = e.numg_pessoa
where tc.NUMG_TipoContato = 3  -- celular
and e.numg_pessoa is null

create index #celulares_idx
on #celulares
(numg_pessoa)

select distinct pes.numg_pessoa
into #outros
from dbo.gv_Pessoas pes
    inner join #guias g
        on pes.NUMG_Pessoa = g.numg_pessoa
    inner join dbo.gv_ContatosPessoa cp
        on pes.NUMG_Pessoa = cp.NUMG_Pessoa
    inner join dbo.gv_TiposContato tc
        on cp.NUMG_TipoContato = tc.NUMG_TipoContato
    left join #emails e
        on pes.numg_pessoa = e.numg_pessoa
    left join #celulares c
        on pes.numg_pessoa = c.numg_pessoa
where e.numg_pessoa is null
    and c.numg_pessoa is null

create index #outros_idx
on #outros
(numg_pessoa)

select 'atendimentos email' as tipo, count as qtd
from #guias g
    inner join #emails e
        on g.numg_pessoa = e.numg_pessoa
union all
select 'atendimentos celular' as tipo, count as qtd
from #guias g
    inner join #celulares c
        on g.numg_pessoa = c.numg_pessoa
union all
select 'atendimentos outros' as tipo, count as qtd
from #guias g
    inner join #outros o
        on g.numg_pessoa = o.numg_pessoa

/*
select *
from #emails
union all
select *
from #celulares
union all
select *
from #outros
*/

select 'Total de pessoas com e-mail', count(numg_pessoa)
    from #emails
union all
select 'Total de pessoas com celular', count(numg_pessoa)
    from #celulares
union all
select 'Total de pessoas outro contato', count(numg_pessoa)
    from #outros