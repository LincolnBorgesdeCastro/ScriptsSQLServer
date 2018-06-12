
return

exec sp_helpuser '56568355100'

exec sp_helpuser '91653681187'
exec sp_helpuser 'IPASGO\89130138191'

sp_helprotect 'up_crGeraRelatorioEncontroContas'


select * from Operadores_Grupos where 

EXEC master.dbo.xp_restore_database
     @database = 'LIFERAY62'
   , @filename = '\\catar\Backup_BD\SQL_BKP\RUSSIA\RELATORIOS\bkp_LIFERAY_Full_04-03-2015.bak'
   , @with = 'move ''LIFERAY_Data'' to ''e:\sql_data\LIFERAY62_Data.mdf'''
   , @with = 'move ''LIFERAY_Log'' to ''e:\sql_data\LIFERAY62_Log.ldf'''
   , @with = 'password = ''1sbdlitespeed''' -- COLOCAR SENHA
   , @with = 'recovery'



sp_adduser '08066122667'
--RSA_USER
revoke IMPERSONATE ON USER::[USR_SCSS] TO [80307035115]


exec IPASGO.dbo.sp_droprolemember 'DES_gvManipulacaoso', '01188297180' 

CREATE PROCEDURE ON SCHEMA :: DBO TO [80307035115]


USE IPASGO
GO
revoke ALTER ON SCHEMA :: DBO TO [DES_crEquipe]
revoke ALTER ON SCHEMA :: DBO TO [DES_pmsoEquipe]
revoke ALTER ON SCHEMA :: DBO TO [DES_agEquipe]
revoke ALTER ON SCHEMA :: DBO TO [DES_atEquipe]
USE SIGA
GO
revoke ALTER ON SCHEMA :: DBO TO [DES_saEquipe]

webService

 select *                     
from sys.database_permissions                     
where grantor_principal_id = user_id ('USR_SCSF');  

select * from sys.database_principals where principal_id in (


select top 10 * from operadores order by NUMG_Operador desc


create user [75419408104]

sp_ADDuser '01122141181'
sp_dropuser '80307035115'

sp_revokedbaccess 'guest'

alter user guest enable
--2012
ALTER SERVER ROLE [sysadmin] ADD MEMBER [71156615100]
GO
ALTER SERVER ROLE [sysadmin] DROP MEMBER [IPASGO\91653681187]

--2005
EXEC master..sp_addsrvrolemember @loginame = N'replica_logs', @rolename = N'sysadmin'
EXEC master..sp_dropsrvrolemember @loginame = N'replica_logs', @rolename = N'sysadmin'


revoke update on so_rds to [99086867120] --bdhomologacao
revoke update on so_RespostasRds to [99086867120]



exec sp_addrolemember 'Desenv_Ipasgo','senior' 
exec sp_addrolemember 'GTI_SCIINF','93176554168' -- VOLTAR

exec sp_droprolemember 'Desenv_Ipasgo','93176554168' --03670785116

drop table #Permissoes
create table #Permissoes (grupo varchar(100), usuario varchar(20), member varchar(500))
insert #Permissoes
exec sp_helprolemember 'Desenv_Ipasgo' --db_datareader

select distinct nome_operador , o.nome_completo 
from #Permissoes r
inner join ipasgo.dbo.operadores o on r.usuario = o.nome_operador 


EXEC sp_addrolemember N'db_securityadmin', N'Operadores - Cadastro'
GO
select * from grupos where sigl_grupo = 'SIPEC – EVOLUCAOPACIENTE'

sp_helprotect null, 'Consulta LOG'

revoke VIEW DEFINITION TO [SIGVIDAS - SUPERVISAO TECNICA]
GRANT SELECT ON [dbo].[syscomments] TO [GTI_Qualidade]

grant exec on sp_adduser to public

select * from ipasgo.dbo.operadores where nome_operador like '%803%'
select * from ipasgo.dbo.operadores where nome_completo like '%weks%'


select * from ipasgo.dbo.operadores where numg_operador = 1453

select og.*
from operadores_grupos og
inner join operadores op on og.numg_operador = op.numg_operador
where og.numg_grupo=244
and op.numg_operador = 1453

select * from grupos where sigl_grupo = 'saat_auditoria - auditores'

select * from grupos where numg_grupo = 245

Exec dbo.up_SBDMostraPermissoesTabelas 'SIGA - Supervisor', null, null
up_SBDMostraPermissoesTabelas null, null, 'siac_AtendimentosAgendados'


exec up_SBDCadastraPermissoesObjetos 'DES_prManipulacaoAt', 'pr_PrestadoresHistAgendamentos', 1, 0, 0, 0


CREATE ROLE DES_saManipulacaoGV AUTHORIZATION [dbo]


up_SBDAjustaPermissoesUsuario 'usr_sicd', 'sicd_PrestacoesContas', 1, 1, 1, 1
up_SBDAjustaPermissoesUsuario 'usr_sicd', 'sgc_legislacaoCadastro', 1, 0, 0, 0
up_SBDAjustaPermissoesUsuario 'usr_sipo', 'sigc_MunicipiosRegional', 1, 0, 0, 0
up_SBDAjustaPermissoesUsuario 'USR_DPCW', 'rh_Colaboradores', 1, 0, 1, 0

EXEC DBO.up_SBDAjustaPermissoesUsuario 'usr_simm', 'simm_MateriaisMedicamentosUnificados', 1, 1, 0, 1
EXEC BDHOMOLOGACAO.FABRICA.DBO.up_SBDAjustaPermissoesUsuario 'usr_simm', 'simm_MateriaisMedicamentosUnificados', 1, 1, 0, 1


USE [SIGA]
--EXEC sp_droprolemember 'Suporte', '97835340178'

-- todos o grupo da base
sp_helprole 'SGF - Cadastro Tabela Atuarial'

sp_recompile 'up_SBDExecutaSelec'

-- permissoes  procedures
sp_helprotect  NULL, 'MANTER SENHA' 

sp_helprotect 'up_atobtemresultadosreceitas'


grant select on vw_gvOrigensOTRS to [USR_OTRS]

grant  exec on up_rfBuscaDespesasGeraisPas to [Relatorio Usuarios]
grant  exec on up_rhBuscaMaquinasRegPonto to [rh - GDP]

 grant exec on up_crChecaDiaUtil to [USR_RUSSIA]

sp_helpindex receitas


PT6JVBR8764T9FT6FVJ2H48PV -- OperadorAdmin ?

x7kvsRimW1IGW18S2xOU -- cydc\adminsqlwitness


exec sp_addrole 'Desenv_Ipasgo'

grant exec on xp_cmdshell to '80307035115'

grant alter trace to [senior]

grant alter any login to [70413878104] 
revoke alter any login to [00481185160]


36258040187 - Rosângela
02328282105 - Thamyres
01209935112 - Olendina
23257695187 - Fátima
01453537104 - Lucas
99640864153 - Kellen
01896275141 - Warner
97935204187 - Flávio David
92257739191 - Tatiana 
00061768103 - Renata
03500023126 - douglas
70413878104 - carol
00891243160 - JANIO

sp_adduser 'OperadorAdmin'
grant exec on sp_dbaVetor to public 

deny exec on sp_dbavetor to '80307035115'

revoke exec on up_gcBuscaLicitacaoCategorias to 84315229172

RESTORE DATABASE prestadores WITH RECOVERY

revoke VIEW DEFINITION to [Desenv_Ipasgo]

--select * from rh_colaboradores where nome_colaborador like '%kkkk%'
--select * from rh_Ponto where numg_colaborador = 1111 order by numg_ponto desc
--dbo.up_rhCorrigePontoColaboradores nnnn, nn,  'dddddddddddddddddd'

-----------------------------------------------------------
drop table #GruposUsuario
create table #GruposUsuario (usuario varchar(20),grupo varchar(1000), login varchar(20),
							 defDBName varchar(100), defSchemaName varchar(100), userID varchar(100), SID varchar(100))
INSERT #GruposUsuario
EXEC sp_helpuser '95780637172'

sp_helpuser 'IPASGO\95780637172'


declare @grupo varchar(200)

declare curBorderos cursor 
for
select distinct grupo from #GruposUsuario
open curBorderos
fetch next from curBorderos into @grupo
while	@@fetch_status = 0
begin

	exec sp_addrolemember @grupo, 'IPASGO\95780637172' 
--	EXEC sp_droprolemember 'SIGVidas – Cartao', @grupo

	fetch next from curBorderos into @grupo

end
close curBorderos
deallocate curBorderos





drop table #rh_interior
create table #rh_interior (grupo varchar(100), usuario varchar(20), member varchar(500))
insert #rh_interior
exec sp_helprolemember 'prestadores - credenciamento intranet'



select * from ipasgo.dbo.grupos where sigl_grupo like 'prestadores%'



exec sp_droprolemember 'db_datareader','guest'



select distinct o.* 
from #rh_interior r
inner join ipasgo.dbo.operadores o on r.usuario = o.nome_operador 
left join operadores_grupos g on o.numg_operador = g.numg_operador-- and g.numg_grupo = 118
left join grupos s on g.numg_grupo = s.numg_grupo and s.sigl_grupo like 'siga%'
where s.numg_grupo is null
order by o.nome_completo

select * from grupos where sigl_grupo like 'siga%'

declare @usuario varchar(20)
declare curBorderos cursor 
for

--select NOME_Operador from ipasgo.dbo.Operadores where NUMG_Secao = 122 And DATA_Bloqueio is null
--select usuario from  #rh_interior

Select name From master..syslogins 
Where name not in  (Select name From siga..sysusers Where issqluser = 1 and isnumeric(name) = 1)
and isnumeric(name) = 1	
and name not like '%,%'									
and name not like '% %'	
and len(name) = 11

open curBorderos
fetch next from curBorderos into @usuario
while	@@fetch_status = 0
begin

	--exec sp_addrolemember 'SIGVIDAS - CARTAO', @usuario
	EXEC siga.dbo.sp_adduser @usuario

	--exec sp_droprolemember 'Desenv_Ipasgo','93176554168'

	fetch next from curBorderos into @usuario

end
close curBorderos
deallocate curBorderos




drop table #Permissoes
create table #Permissoes (owner varchar(100), objeto varchar(200), grantee varchar(200), grantor varchar(100), ProtectType varchar(50), Action varchar(20), Column1 varchar(30))
insert #Permissoes
exec sp_helprotect null, 'SIGVIDAS - CARTAO'

declare @objeto varchar(200)
declare @comando varchar(200)
declare curBorderos cursor 
for
select distinct objeto from #Permissoes where left(objeto, 2) <> 'vw'
open curBorderos
fetch next from curBorderos into @objeto
while	@@fetch_status = 0
begin

--	set @comando = 'revoke exec on ' + @objeto + ' to [SIGVidas – Cartao]'
--	exec (@comando)
	set @comando = 'grant exec on ' + @objeto + ' to [Sigvidas - Gestor de Cartoes]'
	exec (@comando)

	fetch next from curBorderos into @objeto

end
close curBorderos
deallocate curBorderos





	revoke select on scbd_GruposEquipes to [92211526187]
	revoke select on scbd_PermissoesGrupos to [92211526187]


	select * from scbd_GruposEquipes where NOME_Grupo like '%des_dne%'

	select * from scbd_PermissoesGrupos where NUMG_GrupoEquipe = 86

	begin tran --- commit
	update s
	set NOME_Grupo = 'DES_ssManipulacaoAT'
	from scbd_GruposEquipes s where NUMG_GrupoEquipe = 86
