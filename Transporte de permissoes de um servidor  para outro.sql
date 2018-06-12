-- Script que busta as permissos de objetos para serem executados
set nocount on
if object_id('tempdb..#Objetos') Is Not Null drop table #Objetos
create table #Objetos(Objeto varchar(200))

/************************************************************************************************/
--Criando lista de objetos que tera a permissão transportada

insert into #Objetos values ('up_opBloqueiaGrupos')
insert into #Objetos values ('up_opDesbloqueiaGrupos')
insert into #Objetos values ('up_opBuscaGruposBloqueados')
insert into #Objetos values ('up_opPesquisaGruposPorSigla')
insert into #Objetos values ('up_opBloqueiaOperador')
insert into #Objetos values ('up_opDesbloqueiaOperador')
insert into #Objetos values ('up_opBuscaAtalhosSistOperador')
insert into #Objetos values ('up_opBuscaDescSecao')
insert into #Objetos values ('up_opBuscaSecoes')
insert into #Objetos values ('up_opBuscaGrupoSistema')
insert into #Objetos values ('up_opBuscaGrupoMenuSist')
insert into #Objetos values ('up_opIncluiPermissaoGrupos') 
insert into #Objetos values ('up_opExcluiPermissaoGrupos') 
insert into #Objetos values ('up_opAlteraSistemaMenu') 
insert into #Objetos values ('up_opBuscaDadosSistemasMenus') 
insert into #Objetos values ('up_opBuscaMenuSuperior') 
insert into #Objetos values ('up_opBloqueiaSistema') 
insert into #Objetos values ('up_opDesbloqueiaSistema') 
insert into #Objetos values ('up_opBuscaSiglSistema')
insert into #Objetos values ('up_opBuscaSisBloqueados')



/************************************************************************************************/
declare @objeto varchar(200)
declare @grupo varchar(200)
declare @comando varchar(200)
declare @Acao varchar(200)
declare @ServidorConsulta varchar(200)
declare @Path varchar(400)

declare curObjetos cursor 
for
select distinct objeto from #Objetos 

set @ServidorConsulta = '[BDHOMOLOGACAO].[ipasgo].[dbo].[sp_helprotect] '
--set @ServidorConsulta = 'BDDesenv.IPASGO.dbo.sp_helprotect '

open curObjetos

fetch next from curObjetos into @objeto
while	@@fetch_status = 0
begin

	if object_id('tempdb..#Permissoes') Is Not Null drop table #Permissoes
   
	create table #Permissoes (owner varchar(100), objeto varchar(200), grantee varchar(200), grantor varchar(100), ProtectType varchar(50), Action varchar(20), Column1 varchar(30))
	
	set @Path = @ServidorConsulta + ' @name = ' +@objeto

	 insert #Permissoes 	 
	 exec (@Path)	
		
	declare curGrupos cursor 
	for
	select distinct Grantee, Action from #Permissoes where left(objeto, 2) <> 'vw'

	open curGrupos

	fetch next from curGrupos into @grupo, @Acao

	while	@@fetch_status = 0
	begin
		--set @comando = 'revoke '+@Acao+' on ' + @objeto + ' to ['+@grupo+']'
		--exec (@comando)
		set @comando = 'grant '+@Acao+' on ' + @objeto + ' to ['+@grupo+']'
		
		exec (@comando)-- Executa a permissão
		print @comando + ' --Executado'

		fetch next from curGrupos into @grupo, @Acao

	end

	close curGrupos
	deallocate curGrupos

	fetch next from curObjetos into @objeto
end

close curObjetos
deallocate curObjetos
set nocount off
