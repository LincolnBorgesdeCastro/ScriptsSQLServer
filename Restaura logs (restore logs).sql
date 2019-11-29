/* SCRIPT de restauração de LOGs  */

declare @DESC_TipoBackup varchar(4)
declare @NOME_Base varchar(50)

declare @DESC_PastaDia varchar(800)
declare @FLAG_BackupRecente	bit 

set @DESC_TipoBackup = 'LOG'
set @NOME_Base = 'LIFERAY_New'

set @DESC_PastaDia =''
set @FLAG_BackupRecente = 1

declare
@DESC_Comando			varchar(800),
@DESC_Pasta				varchar(800),
@DESC_Arquivo			varchar(800),
@DESC_Recovery			varchar(10),
@NUMR_QuantArquivos		int,
@NUMR_Contador			int

set @DESC_Pasta = '\\norte\k$\Backup\Recentes\LOG\2019-10-10\LIFERAY'
set @DESC_Recovery = 'norecovery'
set @NUMR_Contador = 0

--if @FLAG_BackupRecente = 1 set @DESC_Pasta = @DESC_Pasta + '\Recentes\' 

--if @DESC_TipoBackup = 'LOG' 
--	begin 
--		set @DESC_Pasta = @DESC_Pasta + '\' + @DESC_TipoBackup + '\' + @DESC_PastaDia + '\' + @NOME_Base
--	end
--else
--	begin
--		set @DESC_Pasta = @DESC_Pasta + '\' + @DESC_TipoBackup + '\' + @DESC_PastaDia
--	end

IF OBJECT_ID('tempdb..#Dir') is not null DROP Table #Dir   
Create Table #Dir (Desc_Arquivo Varchar(8000) NULL) 

set @DESC_Comando = 'dir ' + @DESC_Pasta + ' /OGNE /B' 

insert #Dir   
exec master..xp_cmdshell  @DESC_Comando

--select SUBSTRING(desc_arquivo, 28, 4) from #Dir
delete from #Dir where desc_arquivo is null

delete from #Dir where SUBSTRING(desc_arquivo, 28, 4) <= '0400' -- Para o LIFERAY
delete from #Dir where SUBSTRING(desc_arquivo, 28, 4) >  '1130'

--select * from #Dir
/*
SELECT * , SUBSTRING(desc_arquivo, 25, 4) 
from #Dir 
where SUBSTRING(desc_arquivo, 25, 4) > '0135'
*/

select @NUMR_QuantArquivos = count(desc_arquivo) from #Dir

declare curArquivos cursor 
for

	select  Desc_Arquivo from #Dir order by Desc_Arquivo

open curArquivos

fetch next from curArquivos into @DESC_Arquivo

while	@@fetch_status = 0
begin

	if @DESC_TipoBackup = 'LOG'
		begin

			select @DESC_Arquivo

			set @NUMR_Contador = @NUMR_Contador + 1

			if @NUMR_Contador = @NUMR_QuantArquivos set @DESC_Recovery = 'norecovery'

			set @DESC_Arquivo = @DESC_Pasta + '\' + @DESC_Arquivo

			RESTORE LOG @NOME_Base FROM  DISK = @DESC_Arquivo WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10
			print @DESC_Arquivo

		end

	fetch next from curArquivos into @DESC_Arquivo

end

close curArquivos
deallocate curArquivos

