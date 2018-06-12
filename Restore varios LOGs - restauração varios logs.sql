declare
	@DESC_Comando		  	varchar(800),
	@DESC_Pasta			  	varchar(800),
	@DESC_Arquivo		  	varchar(800),
	@NOME_Base          varchar(50)

set @NOME_Base = 'SISIPASGO'
set @DESC_Pasta = '\\norte\k$\Backup\Recentes\LOG\2017-04-06\SISIPASGO'

IF OBJECT_ID('tempdb..#Dir') is not null DROP Table #Dir   
Create Table #Dir (Desc_Arquivo Varchar(8000) NULL) 

set @DESC_Comando = 'dir ' + @DESC_Pasta + ' /OGNE /B' 

insert #Dir   
exec master..xp_cmdshell  @DESC_Comando

delete from #Dir where desc_arquivo is null

--select * from #Dir
--select @DESC_Pasta

declare curArquivos cursor 
for
select  Desc_Arquivo --,SUBSTRING(desc_arquivo, 30, 4)
from #Dir 
where SUBSTRING(desc_arquivo, 30, 4) >= '2100'
order by Desc_Arquivo

open curArquivos

fetch next from curArquivos into @DESC_Arquivo

while	@@fetch_status = 0
begin

	select @DESC_Arquivo

	set @DESC_Arquivo = @DESC_Pasta + '\' + @DESC_Arquivo

	RESTORE LOG @NOME_Base FROM  DISK = @DESC_Arquivo
	WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10

	fetch next from curArquivos into @DESC_Arquivo

end

close curArquivos
deallocate curArquivos

/*

RESTORE DATABASE SERP with RECOVERY

*/