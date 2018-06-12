-- implementações futuras
--	   Permitir a inclusão de procedures vazias

if object_id('tempdb..#proceduresGrupos') is not null drop table #proceduresGrupos
if object_id('tempdb..#grupos') is not null drop table #grupos
if object_id('tempdb..#proceduresGrupos') is not null drop table #proceduresGrupos
if object_id('tempdb..#proceduresExclusao') is not null drop table #proceduresExclusao
if object_id('tempdb..#proceduresAdicao') is not null drop table #proceduresAdicao
if object_id('tempdb..#gruposExclusao') is not null drop table #gruposExclusao
if object_id('tempdb..#grants') is not null drop table #grants

create table #grupos (nome_grupo varchar(max))
create table #proceduresGrupos (name varchar(125), user_name varchar(125))
create table #proceduresExclusao  (name varchar(125))
create table #proceduresAdicao (name varchar(125))
create table #gruposExclusao (name varchar(125))
create table #grants (name varchar(max))

-- DECLARAR AS VARIAVEIS NECESSARIAS
Declare @ColunasPivot varchar(max)
Declare @ColunasPivot2 varchar(max)
Declare @resultado varchar(max)
Declare @contador int
Declare @execut nvarchar(max)
Declare @Nome_Procedure varchar(max)
Declare @grupos varchar(max)
Declare @Trecho_Nome varchar(max)
Declare @Nome_ProcedureExclusao varchar(max)
Declare @Nome_ProcedureInclusao varchar(max)
Declare @Nome_GruposExclusao varchar(max)
Set @grupos = ''
Set @Nome_ProcedureExclusao = ''
Set @Nome_GruposExclusao = ''
Set @Nome_ProcedureInclusao = ''


	-- DEFINIR O TRECHO DO NOME DAS PROCEDURES A SER BUSCADO (prefixo up_ mais prefixo do sistema)
	Set @Trecho_Nome = 'up_aaBuscaHistoricoFichas'
	

-- ADICIONAR PROCEDURES E/OU GRUPOS
/*******  REPETIR ESSE TRECHO DE CÓDIGO PARA MAIS DE UMA PROCEDURE A SER ADICIONADA *******/
	Set @grupos = ''
	

	
	
		-- nome da procedure a ser adicionada
		Set @Nome_Procedure = 'up_atBuscaAnalisesSolicitacoesFichas' 

		-- separados por pipe, pra ser utilizado por dbaVetor.
		-- obs.: O grupo tem que existir na tabela GRUPOS.
		Set @grupos = @grupos + 'SAAT - ODONTOLOGIA AUDITOR|'
		Set @grupos = @grupos + 'SAAT - ODONTOLOGIA SUPERVISOR|'





	-- inserir os registros na tabela
	Set @grupos = '''' + replace(@grupos, '|', '''|''') + ''''
	Delete From #grupos
	Exec master.dbo.sp_dbaVetor '#grupos','nome_grupo',@grupos
	Insert Into #proceduresGrupos
	Select @Nome_Procedure, nome_grupo
	From #grupos

	insert into #grants
	select guarantee = 'grant exec on ' + @Nome_Procedure + ' to [' + nome_grupo + ']'
	from #grupos where nome_grupo <> ''

/******* FIM REPETIÇÃO *******/



	-- APAGAR PROCEDURES DO RETORNO
	Set @Nome_ProcedureExclusao = @Nome_ProcedureExclusao + ''
	Set @Nome_ProcedureExclusao = @Nome_ProcedureExclusao + ''
	Set @Nome_ProcedureExclusao = @Nome_ProcedureExclusao + ''
	Set @Nome_ProcedureExclusao = @Nome_ProcedureExclusao + ''
	Set @Nome_ProcedureExclusao = @Nome_ProcedureExclusao + ''





	-- APAGAR GRUPOS DO RETORNO
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Cadastro de Respostas - Ouvidoria|'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Consultas - Ouvidoria            |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'DIARG                            |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Gerencia de Controle de Veiculos |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Gerencia de Ouvidoria            |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'POSTOS                           |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Publicacao de Noticias           |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SGC - CADASTRO                   |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SGF - GERENCIA                   |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SGF - OPERADOR                   |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - ATENDENTES            |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - CADASTRO              |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - COORDENADORES         |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - GERENCIA              |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - GESTOR DE CARTOES     |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - SUPERVISAO TECNICA    |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIGVIDAS - SUPERVISORES          |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Prestadores - Cadastro Intranet       |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Prestadores - Consulta Intranet       |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'Prestadores - Credenciamento Intranet |'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIODONTO - ADMINISTRADOR|'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIODONTO - CONSULTA|'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIODONTO - OPERADORES|'
	Set @Nome_GruposExclusao = @Nome_GruposExclusao + 'SIODONTO - SUPERVISOR|'
	

	---- ADICIONAR PROCEDURES AO RETORNO
	--Set @Nome_ProcedureInclusao = @Nome_ProcedureInclusao + '|'
	--Set @Nome_ProcedureInclusao = @Nome_ProcedureInclusao + '|'
	--Set @Nome_ProcedureInclusao = @Nome_ProcedureInclusao + '|'


-- ADICIONA O QUE FOI DEFINIDO PRA SER ADICIONADO
Set @Nome_ProcedureInclusao = '''' + replace(@Nome_ProcedureInclusao, '|', '''|''') + ''''
Exec master.dbo.sp_dbaVetor '#proceduresAdicao','name',@Nome_ProcedureInclusao


-- CRIAR A PRIMEIRA TABELA COM TODOS OS ITENS PARA REALIZAR O PIVOT
Insert into #proceduresGrupos
Select  
	obj.name
	,user_name = user_name(perm.grantee_principal_id) --, g.DESC_grupo
From 
	sys.all_objects obj
	inner join sys.database_permissions perm on obj.object_id = perm.major_id
	inner join sys.sysusers us on perm.grantee_principal_id = us.uid
	inner join grupos g on user_name(perm.grantee_principal_id) = g.SIGL_grupo
Where 
	obj.name like '%' + @Trecho_Nome+ '%'
	or obj.name like 'up_at%'
	or obj.name like 'up_aa%'
	or obj.name like 'sp_at%'
	or obj.name like 'sp_aa%'
	
	and us.issqluser = 0
	and user_name(perm.grantee_principal_id) <> '0800'
	or obj.name in (select proi.name from #proceduresAdicao proi)
Order by 
	obj.name


-- APAGA AS PROCEDURES QUE FORAM DEFINIDAS PARA SEREM APAGADAS
Set @Nome_ProcedureExclusao = '''' + replace(@Nome_ProcedureExclusao, '|', '''|''') + ''''
Exec master.dbo.sp_dbaVetor '#proceduresExclusao','name',@Nome_ProcedureExclusao
Delete p
From 
	#proceduresGrupos p
	inner join #proceduresExclusao e on p.name = e.name

-- APAGA OS GRUPOS QUE FORAM DEFINIDOS PRA SEREM APAGADOS
Set @Nome_GruposExclusao = '''' + replace(@Nome_GruposExclusao, '|', '''|''') + ''''
Exec master.dbo.sp_dbaVetor '#gruposExclusao','name',@Nome_GruposExclusao
Delete p
From
	#proceduresGrupos p
	inner join #gruposExclusao g on g.name = p.user_name


Set @contador = 1

-- CRIAR AS STRING NECESSARIAS NA HORA DE CRIAR O PIVOT E RETORNAR O RESULTADO
SELECT  
@ColunasPivot = COALESCE(
	@ColunasPivot + ',[' + CAST(user_name AS VARCHAR(max)) + '] as ''' + replace(replace(replace(user_name, ' ', ''), '-', ''), '–', '') + ''''
	,                '[' + CAST(user_name AS VARCHAR(max)) + '] as ''' + replace(replace(replace(user_name, ' ', ''), '-', ''), '–', '') + ''''
)
,@ColunasPivot2 = COALESCE(
	@ColunasPivot2 + ',[' + CAST(user_name AS VARCHAR(max)) + ']'
	,                 '[' + CAST(user_name AS VARCHAR(max)) + ']'

)
,@resultado = COALESCE(
		@resultado + ',case ' + replace(replace(replace(CAST(user_name AS VARCHAR(max)), ' ', ''), '-', ''), '–', '') + ' when 1 then '' X |'' else ''   |'' end as ''|= G' + cast(@contador as varchar(max)) + ''''
		,             'case ' + replace(replace(replace(CAST(user_name AS VARCHAR(max)), ' ', ''), '-', ''), '–', '') + ' when 1 then '' X |'' else ''   |'' end as ''|= G' + cast(@contador as varchar(max)) + ''''
)
,@contador = @contador + 1
From #proceduresGrupos
Group By user_name--, desc_Grupo
Order By user_name

Select
	 '|=GRUPO' = '| G' + cast(row_number() over (order by user_name) as varchar(10))
	,'|=SIGLA GRUPO' = '| ' + g.sigl_grupo
	,'|=DESCRIÇÃO|' = '| ' + g.DESC_grupo + ' |'
From
	#proceduresGrupos pg
	Left Join Grupos g on pg.user_name = g.SIGL_grupo
Group By user_name, g.sigl_grupo, g.DESC_grupo
Order By user_name


-- SETAR A VARIAVEL COM O SELECT Q SERÁ REALIZADO
set @execut = N'
	select name, ' + @ColunasPivot + '
	into #final
	from #proceduresGrupos
	pivot
	(
		count(user_name)
		for user_name in (' + @ColunasPivot2 + ')
	) as pvt

	select ''| '' + name as ''|= STORED PROCEDURE'', ''| '' + ' + @resultado + '
	from #final
'

-- FINALMENTE, EXECUTAR O CODIGO
execute(@execut)

select * from #grants