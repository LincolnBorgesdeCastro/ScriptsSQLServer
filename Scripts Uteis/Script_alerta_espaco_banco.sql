/* Script que cria a proc sp_monitorabanco */
/* A proc permite monitorar o espaço livre na área de dados de uma database*/
/* quando < 10% envia mensagem para o error log do SQL Server*/

/*** INICIO: Cria a proc no master *********/
use master
go
CREATE PROC sp_monitorabanco
AS

--Declara variáveis
declare @dbname sysname
declare @datafilesize dec(15,0)
declare @espacoLivre dec(15,0)
declare @plivre dec(15,0)
declare @str varchar(200)

--Atualiza as informações da base se o banco não estiver em loading ou readonly
IF databaseproperty(db_name(),'IsInLoad')=0 AND databaseproperty(db_name(),'IsReadOnly')=0
	BEGIN
	     dbcc updateusage(0) with no_infomsgs
	END

select  @dbname = db_name()
select @datafilesize = sum(convert(dec(15),size))from dbo.sysfiles where (status & 64 = 0)
select @espacoLivre = ltrim(str((@datafilesize - (select sum(convert(dec(15),reserved))from sysindexes 
	   									       where indid in (0, 1, 255)))))
-- Calcula percentual de espaço livre
select @plivre = (@espacoLivre*100)/@datafilesize
If @plivre < 10 -- Percencutal de 10%. Aumente este valor para aumentar o percentual
	BEGIN
	    -- Grava ALERTA no Error log do SQL Server e application log do Windows. Precia ser sysadmin
	    select @Str =  'ATENÇÃO !! O ESPAÇO LIVRE PARA A BASE '+@dbname + ' É MENOR QUE 10%%.' + ' O VALOR ATUAL É '+ convert(varchar(15),@PLivre)+ '%%'
	    RAISERROR(@Str, 0, 1)WITH LOG
	END
GO
-- Transforma a proc em uma proc de sistema
exec sp_MS_marksystemobject sp_monitorabanco
go
-- Atribui permissão a public
GRANT EXEC ON sp_sqltruncate TO PUBLIC
GO
/* FIM DO SCRIPT DE CRIAÇÃO DA PROC */

/************ Como Executar: ***************/

-- Executa a proc em todos os databases
sp_MsForEachDb '?..sp_monitorabanco'


