-- Esta função chama outra função "fn_FoneticoPalavra"
-- é preciso cria-la primeiro 
create function fn_busca_fonetica (@texto varchar(200))
returns varchar(30)
as
begin
	declare @palavra varchar(100)
	declare @ret varchar(30)
	declare @aux varchar(200)
	declare @aux_soundex varchar(30)
	declare	@i int

	set @aux = @texto

	set @aux = ltrim(@aux)   --retira espaços em branco no inicio
	set @aux = rtrim(@aux)   --retira espaços em branco no final

	if (@aux = '')
		return ''
	

	set @ret = ''
	
	set @i = 0

	while( @i = 0 )
	begin
		if ( CHARINDEX(' ',@aux) <> 0 ) 
		begin
			set @palavra = substring(@aux,1,CHARINDEX(' ',@aux)-1 )
			set @aux = substring(@aux,CHARINDEX(' ',@aux)+1,len(@aux))
		end
		else 
		begin
			set @palavra = @aux
			set @i = 1
		end
		-- A variável AUX_SOUNDEX recebe o código
		--soundex da palavra.
		set @aux_soundex = dbo.fn_FoneticoPalavra(@palavra)
		
		set @ret = @ret + @aux_soundex
	end
	
	-- Retorna o código soundex concatenado.
	return @ret

end
-------------------------------------------------------------------------------------------------------
