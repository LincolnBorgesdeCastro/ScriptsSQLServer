USE [LOG]
GO

if object_id('##TabelasJaTestadas') is null Create table ##TabelasJaTestadas (Tabela varchar(255))

Declare @Desc_Operador varchar(50) = 'IPASGO\86273795134'
Declare @Data_Inicial  datetime    = '2019-08-23 07:47:28'
Declare @Data_Final    datetime    = '2019-08-27 15:17:38'

Declare @Nome_Tabela varchar(255)
Declare @Desc_Comando varchar(2000)
Declare @Desc_CampoOperador varchar(20)
Declare @NUMR_QtdTabelas int

Set Nocount On

-- Pegar a quantidade de tabelas serão consutadas
Select 
@NUMR_QtdTabelas = 
Count(*)
From sys.tables t inner join sys.columns c on t.object_id = c.object_id
                  left join ##TabelasJaTestadas ttjt on t.name = ttjt.Tabela
Where t.name like '%Log%'
And   t.name not like '%Excluir%'
And c.name IN ('DESC_Operador', 'DESC_Operador2')
And ttjt.Tabela is null
-- select @NUMR_QtdTabelas

-- Pegando as tabelas para a consulta
if object_id('TempDB..#Tabelas') is not null drop table #Tabelas
Select  distinct 
--top 500
t.Name, c.name as Desc_Operador
into #Tabelas
From sys.tables t inner join sys.columns c on t.object_id = c.object_id
                  left join ##TabelasJaTestadas ttjt on t.name = ttjt.Tabela -- Tabela que armazenas as tabelas ja consutadas
Where t.name like '%Log%'
And   t.name not like '%Excluir%'
And c.name IN ('DESC_Operador', 'DESC_Operador2')
And ttjt.Tabela is null -- testando tabelas ainda não consultadas
Order by 1

while (select count(*) from #Tabelas) > 0
Begin
 
 Select top 1 @Nome_Tabela = name , @Desc_CampoOperador = Desc_Operador from #Tabelas output
 
 -- Select * from ##TabelasJaTestadas
 insert into ##TabelasJaTestadas values (@Nome_Tabela) -- Inserindo na tabela ja consutada

 if object_id('TempDB..##TabelaComDadosDeLogsGeral') is not null drop table ##TabelaComDadosDeLogsGeral
 Set @Desc_Comando = 'Select '''+@Nome_Tabela+''' as Tabela, Count(*) as QTD_Registros 
					  Into ##TabelaComDadosDeLogsGeral
					  From [' + @Nome_Tabela + ']' +
					  ' Where ' +@Desc_CampoOperador+ ' = ''' + @Desc_Operador + 
					  ''' and ' + iif(@Desc_CampoOperador='DESC_Operador2', 'DATA_Ocorrencia2', 'DATA_Ocorrencia' ) + 
					  ' Between ''' + cast(@Data_Inicial as varchar(25)) +''' And ''' + Cast(@Data_Final as varchar(25))  + ''''

 Exec(@Desc_Comando) -- Executando o comando

 -- Retornando a tabela e o valor da consulta que encontrou dados
 if (Select QTD_Registros from ##TabelaComDadosDeLogsGeral) > 0 Select * from ##TabelaComDadosDeLogsGeral 

 Delete from #Tabelas where name = @Nome_Tabela -- Excluindo o registro para continuar o laço de repetição

End

-- Apagando a tabela temporaria global
if object_id('TempDB..##TabelaComDadosDeLogsGeral') is not null drop table ##TabelaComDadosDeLogsGeral

-- Apagando a tabela global de tabelas ja testadas caso for a mesma quantidade do total de tabelas que devem ser consutadas(Significa que o ciclo foi completo)
if (Select count(*) from ##TabelasJaTestadas) = @NUMR_QtdTabelas drop table ##TabelasJaTestadas 
