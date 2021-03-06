-- Retorna o codigo do grupo do caracter informado
-- no parâmetro.
-- Obs: se a letra não estiver definida em algum grupo 
--      retorna-se vazio
create function fn_GrupoFonetico(@caracter char(1))
returns varchar(5)
as
begin

	declare @cr char(1)
	declare @grupo varchar(5)

	set @cr = UPPER(@caracter)
	-- Verifica qual é o código do grupo do caracter.
	if ( CHARINDEX(@cr,'BFPVW') <> 0 )
		set @grupo = '1'
	else if ( CHARINDEX(@cr,'CçÇGJKQSXZ') <> 0 )
		set @grupo = '2'
	else if ( CHARINDEX(@cr,'DT') <> 0 ) 
		set @grupo = '3'
	else if ( CHARINDEX(@cr,'L') <> 0 ) 
		set @grupo = '4'
	else if ( CHARINDEX(@cr,'MN') <> 0 ) 
		set @grupo = '5'
	else if ( CHARINDEX(@cr,'R') <> 0 )
		set @grupo = '6'
	else 
		set @grupo = ''
	-- Retorna o código do grupo do caracter
	return @grupo
end
