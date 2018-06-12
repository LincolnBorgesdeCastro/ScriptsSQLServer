
declare @DataInicial date = '2017-04-01'


Select   NUMG_colaborador Colaborador
       , format(data_acao, 'dd/MM/yyyy') Data
       , count(*) Quantidade
from rh_ponto
where NUMG_colaborador = 4485
and format(data_acao, 'yyyy-MM-dd') >= @DataInicial
group by NUMG_colaborador, format(data_acao, 'dd/MM/yyyy')
having count(*) > 4
--order by format(data_acao, 'MM') 


--Select * from rh_Colaboradores where NUMG_colaborador = 4485