use SBD
go

declare @DESC_TipoBackup varchar(4)
declare @NOME_Base varchar(50)
declare @NOME_Servidor varchar(50)
declare @DESC_PastaDia varchar(800)

set @DESC_TipoBackup = 'LOG'
set @NOME_Base = 'IPASGO'
set @NOME_Servidor = '10.6.63.81'
set @DESC_PastaDia ='2010-09-12'

declare
	@DESC_Comando			varchar(800),
	@DESC_Pasta				varchar(800),
	@DESC_Arquivo			varchar(800),
	@DESC_Recovery			varchar(10)

set @DESC_Pasta = '\\' + @NOME_Servidor + '\e$\Bkp\LOG\2013-09-12\Tarde'
set @DESC_Recovery = 'norecovery'

--if @DESC_TipoBackup = 'LOG' 
--	begin 
--		set @DESC_Pasta = @DESC_Pasta + '\' + @DESC_TipoBackup + '\' + @DESC_PastaDia + '\' + @NOME_Base
--	end
--else
--	begin
--		set @DESC_Pasta = @DESC_Pasta + '\' + @DESC_TipoBackup --+ '\' + @DESC_PastaDia
--	end

IF OBJECT_ID('tempdb..#Dir') IS NOT NULL DROP Table #Dir   
Create Table #Dir (Desc_Arquivo Varchar(8000) NULL) 

set @DESC_Comando = 'dir ' + @DESC_Pasta + ' /OGNE /B' 

insert #Dir   
exec master..xp_cmdshell  @DESC_Comando

delete from #Dir where desc_arquivo is null

/*
select @DESC_Arquivo = @DESC_Pasta + '\' + @DESC_Arquivo
select * from #Dir
*/
declare curArquivos cursor 
for

	select Desc_Arquivo from #Dir

open curArquivos

fetch next from curArquivos into @DESC_Arquivo

while	@@fetch_status = 0
begin

	if @DESC_TipoBackup = 'LOG'
		begin

			set @DESC_Arquivo = @DESC_Pasta + '\' + @DESC_Arquivo

			RESTORE LOG @NOME_Base
			FROM  DISK = @DESC_Arquivo
			WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10


			--EXEC master.dbo.xp_restore_database
			--	 @database = @NOME_Base
			--   , @filename = @DESC_Arquivo
			--   , @with = 'move ''ipasgo_data'' to ''E:\Dados\IPASGO_data.mdf'''
			--   , @with = 'move ''ipasgo_data2'' to ''E:\Dados\IPASGO_data2.mdf'''
			--   , @with = 'move ''ipasgo_index'' to ''E:\Dados\IPASGO_Index.ndf'''
			--   , @with = 'move ''ipasgo_log'' to ''E:\Logs\IPASGO_log.ldf'''
			--   , @with = @DESC_Recovery 

		end

	fetch next from curArquivos into @DESC_Arquivo

end

close curArquivos
deallocate curArquivos

return
