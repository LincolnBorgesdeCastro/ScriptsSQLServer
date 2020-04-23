
declare @DataInicial date = '2020-04-13'

Select * 
from rh_ponto
where NUMG_colaborador = 4485
and format(data_acao, 'yyyy-MM-dd') >= @DataInicial
and format(data_acao, 'yyyy-MM-dd') <= @DataInicial


/**********************************************************************************************/
Select   NUMG_colaborador Colaborador
       , format(data_acao, 'dd/MM/yyyy') Data
       , count(*) Quantidade
from rh_ponto
where NUMG_colaborador = 4485
and format(data_acao, 'yyyy-MM-dd') >= @DataInicial
group by NUMG_colaborador, format(data_acao, 'dd/MM/yyyy')
having count(*) > 4
--order by format(data_acao, 'MM') 

/**********************************************************************************************/

--Select * from rh_Colaboradores where NUMG_colaborador = 4485


/**********************************************************************************************/