/************************************************************************
Descrição: Este script cria uma procedure que lê o errorlog do SQL Server
filtrando apenas pelo eventos do dia corrente ou de qualquer outro dia.
Também é possível informar em qual errolog deseja realizar a pesquisa.

Parâmetros OPCIONAIS:

@STRn -->> String que deseja pesquisar no errorlog Ex: deadlocks
@ErrorlogN -->> Por default o SQL Server guarda os últimos 6 errorlog no formato:
ERRORLOG (Atual), ERRORLOG.1,...ERORLOG.6(Cria um a cada Stop/Start). 
Neste parâmetro você pode especificar qual error log você quer ler ou pesquisar pela string

Autor: Nilton Pinheiro
HomePage: http://www.mcdbabrasil.com.br
Artigo relacionado: http://www.mcdbabrasil.com.br/modules.php?name=News&file=article&sid=69

*************************************************************************/
USE PUBS
GO
CREATE PROC proc_leerrorlog
	@STRn as VarChar(50)= '',
	@ErrorlogN as Char(1) = ''
AS
Declare @StrSQL as Varchar(100)
Declare @PATH_DATA as VarCHar(50)
Declare @sql_path	NVARCHAR(260) 
Declare @data_path	NVARCHAR(260) 
exec sp_MSget_setup_paths @sql_path output , @data_path output

If @STRn= '' -- Se a string de pesquisa for '', pega todos os eventos da data corrente.
	Set @STRn= RTrim(Convert(varchar(10),GetDate(),120))

Set @StrSQL = 'master..xp_cmdshell "findstr /I /N /C:'+ @STRn + ' ' +@data_path +'\log\errorlog.'+ RTrim(@ErrorlogN)+'"'
exec (@StrSQL)

GO
