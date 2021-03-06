-- Recebe uma palavra como parâmetro, e retorna o seu código Fonetico.
-- Esta função chama outra função "fn_GrupoFonetico" é preciso cria-la primeiro.
create function fn_FoneticoPalavra(@texto varchar(100))
returns varchar(30)
as
begin

	declare @aux varchar(100)
	declare @texto2 varchar(100)
	declare @aux2 char(1)
	declare @i int
	-- A variável texto2 recebe a palavra.
	set @texto2 = @texto
	-- Transforma para maiúsculas
	set @texto2 = UPPER(@texto2)
	--------------alteração--
	set @texto2 = ltrim(@texto2) --retira espaços em branco no inicio
	-------------------------
	--?????
	if( CHARINDEX(' ',@texto2) <> 0 ) 
	begin
		set @texto2 = replace(@texto2,' ','')       --retira espaço em branco
	end
	--?????
	if( CHARINDEX('"',@texto2) <> 0 ) 
	begin
		set @texto2 = replace(@texto2,'"','')       --retira aspas duplas
	end
	
	if( CHARINDEX(char(13)+char(10),@texto2) <> 0 ) 
	begin
		set @texto2 = replace(@texto2,char(13)+char(10),'')  --retira o 'enter'
	end
	
	if( CHARINDEX(char(9),@texto2) <> 0 ) 
	begin
		set @texto2 = replace(@texto2,char(9),'')   --retira o 'Tab'
	end
	
	--Se a palavra inicía com caracter
	--especial, sai da função e retorna branco.
	if ( ASCII(substring(@texto2,1,1)) < 65  or  ASCII(substring(@texto2,1,1)) > 90 )
	begin
		return ''
	end		
	-------------------------------particularidades--------------------------------

	--se a primeira letra for 'H' então retira-a
	if(substring(@texto2,1,1) = 'H')        
		set @texto2 = substring(@texto2,2,len(@texto2))
	--se a primeira letra for 'C' troca-se por 'S' ou 'K'
	if(substring(@texto2,1,1) = 'C') 
	begin       
		if(substring(@texto2,2,1) = 'I' or substring(@texto2,2,1) = 'Y' or substring(@texto2,2,1) = 'E' or substring(@texto2,2,1) = 'H' )
			set @texto2 = 'S'+substring(@texto2,2,len(@texto2))
		else--if(substring(@texto2,2,1) = 'A' or substring(@texto2,2,1) = 'O'or substring(@texto2,2,1) = 'U')
			set @texto2 = 'K'+substring(@texto2,2,len(@texto2))
	end
	--se a primeira letra for 'J' troca-se por 'G'
	if(substring(@texto2,1,1) = 'G')
	begin
		if (substring(@texto2,2,1) = 'E' or substring(@texto2,2,1) = 'I' or substring(@texto2,2,1) = 'Y')        
			set @texto2 = 'J'+substring(@texto2,2,len(@texto2))
	end
	-----------
	--se a primeira letra for 'Q' troca-se por 'K'
	if(substring(@texto2,1,1) = 'Q')        
		set @texto2 = 'K'+substring(@texto2,2,len(@texto2))
	--se a primeira letra for 'V' ou 'U' troca-se por 'W'
	if(substring(@texto2,1,1) = 'V' or substring(@texto2,1,1) = 'U')        
		set @texto2 = 'W'+substring(@texto2,2,len(@texto2))
	--------------------------------------------------------------------------------
	if ( len(@texto2) = 0 )
	begin
		return ''
	end
	-- Variável AUX recebe o primeiro caracter da palavra.
	set @aux = substring(@texto2,1,1)

	-- Percorre todos os caracteres da palavra e calcula o código
	--de cada um, chamando a função fn_GrupoSoundex, armazenando
	--na variável AUX.

	set @i = 2
	while ( @i <= len(@texto2) )
	begin
		set @aux2= substring(@texto2,@i,1)
		set @aux = @aux + dbo.fn_GrupoFonetico(@aux2)
		
		set @i = @i+1
	end
	-- A variável texto2 recebe o código de todos os caracteres.
	set @texto2 = @aux
	-- Percorre o código e retira caracteres duplicados
	set @i = 1
	while(@i <= len(@texto2))
	begin
		if(substring(@texto2,@i,1) = substring(@texto2,@i+1,1))
		begin
			set @texto2= left(@texto2,@i) + right( @texto2,len(@texto2)-(@i+1) ) --retira a letra repetida
		end
		
		set @i = @i + 1
	end
	-- O código soundex deverá conter uma letra e quatro dígitos.
	-- Esta rotina armazena apenas os quatro primeiros dígitos do código.
	-- Se o código não tiver quatro dígitos, preenche com zeros.
	if(len(@texto2) > 4)
		set @texto2=substring(@texto2,1,4)
	else if(len(@texto2) < 4)	
	begin
		while(len(@texto2) < 4)
			set @texto2 = @texto2 + '0'
	end
	
	return @texto2


end

-------------------------------------------------------------------------------------------------------
