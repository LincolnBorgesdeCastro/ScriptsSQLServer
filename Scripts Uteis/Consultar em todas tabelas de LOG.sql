USE LOG
GO

declare @DESC_Tabela   varchar(255)
declare @DESC_Script   nvarchar(4000)
declare @NUMR_Registro int
declare @DESC_Servidor varchar(255)

SET @DESC_Servidor = @@SERVERNAME  

DECLARE  CUR_TABLES cursor for
Select name 
from sys.tables
where name like '%Log%'
--and name not in ('')

open CUR_TABLES

fetch next from CUR_TABLES into @DESC_Tabela

while @@FETCH_STATUS = 0
 begin

  --print @DESC_Tabela

	SET @DESC_Script = 'Select @NUMR_Registro = count(*) from ' + @DESC_Tabela + ' where DESC_Operador like ''%89727126120%'''

	Begin try
	  Exec sp_executesql @DESC_Script, N'@NUMR_Registro int OUT', @NUMR_Registro output 
	
	  if @NUMR_Registro > 0 
	  begin
	    --print @DESC_Tabela + ' - ' + Convert(varchar, @NUMR_Registro)
    
   		SET @DESC_Script = 'bcp "select * from LOG.dbo.' + @DESC_Tabela + ' where DESC_Operador like ''%89727126120%'' " queryout "\\ipasgo18449\89727126120\Auditoria_'+@DESC_Tabela+'_89727126120.txt" -c -T -S ' + @DESC_Servidor 

		   
      EXEC master..xp_cmdShell @DESC_Script, NO_OUTPUT
    end	 
	End try
	Begin catch
		print @DESC_Tabela + ' - ' + Convert(varchar, @NUMR_Registro)
		print 'Erro: '+ error_message()
	End catch

   

	fetch next from CUR_TABLES into @DESC_Tabela
 end

 close CUR_TABLES
 deallocate CUR_TABLES




/*
************** Tabelas sem o campo DESC_Operador *************************

LOG_RECEITAS2009 - 0
Polimed_RecepcaoLog - 0
Receitas_Observacoes_Log - 0
temp_Polimed_RecepcaoLog - 0
LOG_RECEITAS2005 - 0
LOG_Atendimentos_PessoasJuridicas - 0
LOG_RECEITAS2004 - 0
gv_LogDependentesInseridosHistorico - 0
LOG_ReceitasAnterior2004 - 0
Log_Receitas5Anos - 18
LOG_RECEITAS2012 - 0
LOG_Receitas2013 - 0
LOG_RECEITAS2011 - 0
LOG_RECEITAS2010 - 0
pr_LOGEnderecosAtendimento30-07-2012 - 0
LOG_prPrestadores30-07-2012 - 0
gv_LOGOrigens12-07-2012_Excluir - 0
LOG_Atendimentos_PessoasFisicas - 0
LOG_RECEITAS2006 - 0
LOG_Prestadores_servicos - 0
LOG_RECEITAS2008 - 0
LOG_RECEITAS2007 - 0
Log_Acordos_Usuarios_OLD - 0

*/

