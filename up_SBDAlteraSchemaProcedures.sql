USE IPASGO
GO

/********************************************************************
Empresa:	Ipasgo
Projeto:	Restauração BDDESENV
Nome:		  up_SBDAlteraSchemaProcedures
Função:		Alterar os eschemas das procedures de dbo para sp
Autor:		Lincoln Borges de Castro
Data:		05/10/2012
********************************************************************/
/*
-- Criar esquema que será de todas as procedures
Create schema sp

-- Criar o usuario que será o dono do esquema das procedures
Create user USR_SP without login

--Setar o usuario para o esquema
alter authorization on schema::sp to USR_SP
*/

Alter procedure up_SBDAlteraSchemaProcedures (
  @NOME_Procedure varchar(100) = null
)
As

--Declare @NOME_Procedure varchar(100)
Declare @NUMG_QuantidadePermissao integer
Declare @DESC_Grupo varchar(200)
Declare @DESC_TipoPermissao varchar(20)

--Set @NOME_Procedure = lower('up_crReativaUsuarios')
Set nocount on


-- Criar esquema que será de todas as procedures
If (schema_id('sp') <= 0) begin execute('Create schema sp') end

-- Criar o usuario que será o dono do esquema das procedures
If (user_id('USR_SP') <= 0) 
 begin 
  execute('Create user USR_SP without login') 
  --Setar o usuario para o esquema
 end

Alter authorization on schema::sp to USR_SP

Declare curProcedures cursor
For
Select distinct pro.name as "procedure"
From ipasgo.sys.procedures pro 
Where pro.schema_id = schema_id('dbo')
and pro.name not like 'sp_MSins%'
and pro.name not like 'sp_MSupd%'
and pro.name not like 'dt_%'
and pro.name not like 'sel_%'
and pro.name not like 'sp_cft%'
and pro.name not like 'sp_ins%'
and pro.name not like 'sp_sel%'
and pro.name not like 'sp_upd%'
and pro.name not like 'sp_MSdel%'
and ((@NOME_Procedure is null) or (pro.name = @NOME_Procedure))
Order by pro.name 

Open curProcedures

Fetch next from curProcedures into @NOME_Procedure

While @@FETCH_STATUS = 0
 Begin

 	if object_id('tempdb..#Grupos') Is Not Null drop table #Grupos
	create table #Grupos (owner varchar(100), objeto varchar(200), grantee varchar(200), grantor varchar(100), ProtectType varchar(50), Action varchar(20), Column1 varchar(30))

	Begin Try
   
	 --Set @NOME_Procedure = 'sp.' + @NOME_Procedure

	 Insert #Grupos
	 Execute ('sp_helprotect ' + @NOME_Procedure)

	End Try
	Begin Catch	 

	End Catch

  --Alteração do schema para procedures já existente. 
  Execute('Alter schema sp transfer dbo.' + @NOME_Procedure)
 
  -- Criação do sinimo da procedure. Podera ser feito pelo usuario(Desenvolvedor)
  Execute('Create synonym [dbo].['+ @NOME_Procedure + '] for [sp].['+@NOME_Procedure+']')

	Select @NUMG_QuantidadePermissao = count(*) from #Grupos 

	If (@NUMG_QuantidadePermissao > 0)
	 begin
		Declare curGrupos cursor
		For
		Select distinct grantee, ProtectType from #Grupos 

		Open curgrupos

		Fetch next from curgrupos into @DESC_Grupo, @DESC_TipoPermissao

		While	@@fetch_status = 0
		Begin
			If @DESC_TipoPermissao <> 'Deny'
			 Execute ('Grant execute on sp.' + @NOME_Procedure + ' to [' + @DESC_Grupo + ']')
			else
			 Execute ('Deny execute on sp.' + @NOME_Procedure + ' to [' + @DESC_Grupo + ']')			 
			Fetch next from curgrupos into @DESC_Grupo, @DESC_TipoPermissao
		End -- Fim while curGrupos

		Close curGrupos
		Deallocate curGrupos
	 End

  Fetch next from curProcedures into @NOME_Procedure
 End -- Fim while curProcedures
  
Close curProcedures
Deallocate curProcedures



