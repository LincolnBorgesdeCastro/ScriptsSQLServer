-- Este script permite localizar tabelas temporárias Globais ou Locais em uma dada base de dados
    set nocount on

    declare @rc int -- @@rowcount
    declare @e int  -- @@error
    declare @nr int -- number of recommendations for possible investigation found here
	declare @sp_name varchar(256)
	declare @DebugFlag int
	set @nr = 0
	set @DebugFlag=0
	create table #t_sp ([text] varchar(8000))
	DECLARE all_sp_cursor CURSOR FOR 
			select
				[name]
	   		from dbo.sysobjects
			where xtype = 'P '
			order by [name]
		
	OPEN all_sp_cursor
	
	FETCH NEXT FROM all_sp_cursor 
		INTO @sp_name
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    if @DebugFlag <> 0 select 'processando ' + @sp_name    
            insert into #t_sp ([text] )execute sp_helptext @sp_name			    	
	if exists (select 1 from #t_sp where [text] like '%##%')
		begin
			select @sp_name + ' usa tabelas temporárias'
			select * from #t_sp 
				where [text] like '%##%' or [text] like '%#%'
			set @nr = @nr + 1
		end
		FETCH NEXT FROM all_sp_cursor 
			INTO @sp_name

		truncate table #t_sp		
	END -- while cursor loop
	CLOSE all_sp_cursor
	DEALLOCATE all_sp_cursor	
	drop table #t_sp
GO