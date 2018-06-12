/********************************************************************************
Descri��o : Verificar todos os TRIGGER de um Database e informa se os mesmos 
est�o habilitados ou desabilitados. Caso o TRIGGER esteja desabilitado existe 
a op��o para habilit�-lo, alterando o valor para a vari�vel @enabled.

Como Executar: Coloque o scripts no Query Anallizer e tecle F5

Criado por: NILTON PINHEIRO
Home Page : www.mcdbabrasil.com.br

Exemplo de resultado com @enabled = 0
O trigger trig1 da tabela authors est� ativado !
O trigger trig2 da tabela employee est� desativado !

Exemplo de resultado com @enabled = 1
O trigger trig1 da tabela authors est� ativado !
O trigger trig2 da tabela employee estava desativado e foi ativado !!
*********************************************************************************/

USE Pubs -- Troque "Pubs" pelo nome do banco que deseja verificar os TRIGGERS
GO
declare x cursor for select name,parent_obj 
from sysobjects where xtype='TR' 

declare @trname varchar(50) 
declare @enabled int 
declare @st int 
declare @parobj int 
declare @instrucao varchar(200) 
open x 
fetch next from x into @trname,@parobj 

-- Se @enabled = 1 habilita os trigger, Default 0 - apenas lista os trigger e seus status.
SET @enabled = 0

IF @@fetch_status = -1
	print 'N�o existe TRIGGER neste Database !'	
ELSE
BEGIN
    while @@fetch_status=0 
    begin 
      set @st=ObjectProperty(Object_ID(@trname),'ExecIsTriggerDisabled') 
      IF @st=1 
          begin 
              IF @enabled = 1
        	begin
	     	     print 'O trigger ' + @trname + ' da tabela ' + object_name(@parobj) + ' estava desativado e foi ativado !!' 
 	     	     select @instrucao='alter table ' + object_name(@parobj) + ' enable trigger ' + @trname 
 	             exec(@instrucao) 
		end
	      ELSE
		    print 'O trigger ' + @trname + ' da tabela ' + object_name(@parobj) + ' est� desativado !'	 
         end 
      ELSE
         print 'O trigger ' + @trname + ' da tabela ' + object_name(@parobj) + ' est� ativado !'	 

      fetch next from x into @trname,@parobj 
   end 
END
close x 
deallocate x 

GO