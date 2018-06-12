USE IPASGO
GO

ipasgo.dbo.up_SBDCadastraPermissoesObjetos 'DES_gvManipulacaoCR',	'gv_Observacoes',	1, 1, 1, 1

ipasgo.dbo.up_SBDCadastraPermissoesObjetos 'DES_gvManipulacaoCR',	'gv_LOGObservacoes',	1, 0, 0, 0

[SGF-ContasReceber]

/*
--Inserindo grupo
insert into scbd_GruposEquipes values (10,	125,	'DES_saManipulacaoERP')
*/

/* Procedure que retonar as permissoes para o sistemas de GSI*/
up_gsBuscaControlePermissaoAcesso 63

select  *
from dbo.scbd_GruposEquipes 
where 
NOME_Grupo = 'DES_saManipulacaoSS'
numg_sistema = 79

select * from sigs_Equipes


select * from dbo.scbd_PermissoesGrupos where NOME_Objeto = 'sa_LOGAtendimentosDevolvidos'

begin tran -- commit rollback
 delete from dbo.scbd_PermissoesGrupos where numg_permissaogrupo = 4325


select * from sigs_Equipes 

select * from scbd_GruposEquipes where NOME_Grupo like '%DES_pmsoManipulacaoCR%'

select * from Sistemas
 where SIGL_sistema LIKE '%ERP%'

Select distinct ge.NOME_Grupo, pg.NOME_Objeto, pg.FLAG_Select, pg.FLAG_Insert, pg.FLAG_Update, pg.FLAG_Delete, pg.NUMG_GrupoEquipe
from assistencia.ipasgo.dbo.scbd_GruposEquipes ge
                inner join assistencia.ipasgo.dbo.scbd_PermissoesGrupos pg on ge.NUMG_GrupoEquipe = pg.NUMG_GrupoEquipe
where /*ge.NOME_Grupo = 'DES_prManipulacaoPG'
and   */NOME_Objeto = 'gv_DadosAvaliacoesFinanceiras'


--delete 
select *
from scbd_PermissoesGrupos
where NOME_Objeto      like  '%SecoesVigencias' 
--and NUMG_GrupoEquipe = 38
  
delete from scbd_PermissoesGrupos
where NUMG_PermissaoGrupo in (3451, 3452)


select * from dbo.sigs_Equipes

select * from dbo.Sistemas where SIGL_sistema LiKE '%CR%'

insert into scbd_GruposEquipes select 11,64,'DES_pmsoManipulacaoCR'


select * from scbd_GruposEquipes

begin tran -- commit rollback
 delete from scbd_GruposEquipes where NUMG_GrupoEquipe = 225 and NUMG_Equipe = 10 and NUMG_Sistema = 125