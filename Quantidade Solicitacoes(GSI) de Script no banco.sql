
/************************************************************************************************************************/
 DECLARE @DataInicial date = '2017-01-01'
 DECLARE @ColunasPivot VARCHAR(8000)
 DECLARE @Script VARCHAR(8000)

/************************************************/
--Todos os sistemas

 Select @ColunasPivot = stuff(
 (
 Select  DISTINCT ' ,['+ ltrim(rtrim(a.SIGL_Sistema)) + ']' 
 From IPASGO.dbo.sigs_Solicitacoes s inner join sigs_SolicitacoesBanco b on s.NUMG_Solicitacao = b.NUMG_Solicitacao
									 inner join dbo.Sistemas a on b.NUMG_Sistema = a.NUMG_Sistema	
 Where NUMG_TipoServico = 6 -- Executar script
 And DATA_Solicitacao >= cast(@DataInicial as date)

 and NUMG_Situacao = 8 -- Executada

 Group by YEAR(DATA_Solicitacao), MONTH(DATA_Solicitacao) , a.SIGL_Sistema
 
 FOR XML path ('')

 ), 1, 2, '')  

--select @ColunasPivot

/************************************************/
set @Script ='
; with cte_Solicitacoes (Mes, Ano, Quantidade) as
(
 Select MONTH(DATA_Solicitacao) as Mes
        ,YEAR(DATA_Solicitacao)  as Ano  
        ,Count(*) as Quantidade
 From IPASGO.dbo.sigs_Solicitacoes
 Where NUMG_TipoServico  = 6 -- Executar script
 And   DATA_Solicitacao >= cast('''+convert(varchar(10), @DataInicial, 102)+''' as datetime)
 Group by YEAR(DATA_Solicitacao), MONTH(DATA_Solicitacao) 

)
, cte_SolicitacoesExecutadas (Mes, Ano, Quantidade) as
(
 Select MONTH(DATA_Solicitacao) as Mes
        ,YEAR(DATA_Solicitacao)  as Ano  
        ,Count(*) as Quantidade

 From IPASGO.dbo.sigs_Solicitacoes
 Where NUMG_TipoServico = 6 -- Executar script
 And DATA_Solicitacao >= cast('''+convert(varchar(10), @DataInicial, 102)+''' as datetime)

 and NUMG_Situacao = 8 -- Executada

 Group by YEAR(DATA_Solicitacao), MONTH(DATA_Solicitacao) 

)

, cte_SolicitacoesExecutadasSistema (Mes, Ano, Sistema, Quantidade) as
(
 Select MONTH(DATA_Solicitacao) as Mes
        ,YEAR(DATA_Solicitacao)  as Ano  
		,a.SIGL_Sistema 
        ,Count(*) as Quantidade

 From IPASGO.dbo.sigs_Solicitacoes s inner join sigs_SolicitacoesBanco b on s.NUMG_Solicitacao = b.NUMG_Solicitacao
									 inner join dbo.Sistemas a on b.NUMG_Sistema = a.NUMG_Sistema	
 Where NUMG_TipoServico = 6 -- Executar script
 And DATA_Solicitacao >= cast('''+convert(varchar(10), @DataInicial, 102)+''' as datetime)

 And NUMG_Situacao = 8 -- Executada

 Group by YEAR(DATA_Solicitacao), MONTH(DATA_Solicitacao) , a.SIGL_Sistema

)

Select Convert(Varchar(2), Mes)+''/''+Convert(Varchar(4), Ano) as Referência
, Abertas
, Executadas
, '+@ColunasPivot+'
From
(

	Select s.Mes
	     , s.Ano
	     , s.Quantidade as Abertas
	     , sa.Quantidade as Executadas
	     , si.Sistema as Sistema
	     , si.Quantidade as ExecutadasSistema
	From cte_Solicitacoes s inner join cte_SolicitacoesExecutadas sa on s.Mes = sa.Mes and s.Ano = sa.Ano
	                        inner join cte_SolicitacoesExecutadasSistema si on s.Mes = si.Mes and s.Ano = si.Ano	
)

AS P PIVOT

(SUM(ExecutadasSistema) 

FOR Sistema in ('+@ColunasPivot+')) as pvt

Order by Ano, Mes'

exec (@script)

/************************************************************************************************************************/

