/* Consulta historico do relatorio desde o ultimo reinicio do serviço */
use REPORTSERVER
go

Select * from ExecutionLog3 where ItemPath like '%rpsIndGra-NutecCrescimentoVegetativoReceita'


/* Busca dados do cubo que passou o parametro */

use REPORTSERVER
go

up_biBuscaTextInTagSSRS 'bd_Receitas', 1  



