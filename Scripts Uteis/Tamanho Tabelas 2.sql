set nocount off

if object_id('tempdb..#temp01') > 0 drop table #temp01
select   
e.NOME_Tabela,
e.NUMR_TamanhoTabela*1024 as NUMR_TamanhoTabela
INTO #temp01
from dbo.sbde_EstatisticasCrescimentoTabelas e
	inner join dbo.sbdi_BasesDados b on e.numg_baseDado = b.numg_baseDado
where b.DATA_Referencia = '2011-01-01'
and not ((upper(e.NOME_Tabela) like '%_LOG%') or (upper(e.NOME_Tabela) like '%LOG_%'))
order by NUMR_TamanhoTabela desc

if object_id('tempdb..#temp12') > 0 drop table #temp12
select   
e.NOME_Tabela,
e.NUMR_TamanhoTabela*1024 as NUMR_TamanhoTabela
INTO #temp12
from dbo.sbde_EstatisticasCrescimentoTabelas e
	inner join dbo.sbdi_BasesDados b on e.numg_baseDado = b.numg_baseDado
where b.DATA_Referencia = '2012-01-01'
and not ((upper(e.NOME_Tabela) like '%_LOG%') or (upper(e.NOME_Tabela) like '%LOG_%'))
order by NUMR_TamanhoTabela desc


if object_id('tempdb..#temp') > 0 drop table #temp
create table #temp(
   Tabela Varchar(100), 
   "Inicial(MB)" DECIMAL(20,2), 
   "Final(MB)" DECIMAL(20,2)
  ,"Taxa%" DECIMAL(20,2)
)
insert into #temp
SELECT T01.NOME_Tabela as Tabela, 
       Round(T01.NUMR_TamanhoTabela,2) as Inicial, 
       Round(T12.NUMR_TamanhoTabela,2) as Final, 
       Round(Case Round(T01.NUMR_TamanhoTabela,2) When 0 
              Then (Case Round(T12.NUMR_TamanhoTabela,2) when 0.00 Then 0.0 else 100  End)
              Else (Round(T12.NUMR_TamanhoTabela,2) / Round(T01.NUMR_TamanhoTabela,2)  - 1) * 100 
             End , 2) as Taxa

FROM #temp01 T01 INNER JOIN #temp12 T12 ON T01.NOME_Tabela = T12.NOME_Tabela
set nocount on

Select Tabela, "Final(MB)" as "Tamanho(MB)", "Taxa%" as "Taxa Crescimento Anual(%)" from #temp order by Tabela
