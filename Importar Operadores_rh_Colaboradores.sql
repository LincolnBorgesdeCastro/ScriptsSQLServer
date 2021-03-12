/* Importar Operadores/rh_Colaboradores */

disable trigger [tr_i_Operadores] on operadores

/* Se precisar criar o user */
/*
create user [01508274665]

create user [52853780287]
*/

use IPASGO select * from operadores where nome_operador IN ('01508274665')
use IPASGO select * from operadores where nome_operador IN ('52853780287')

use IPASGO select * from rh_colaboradores where NUMR_CPF IN ('01508274665')
use IPASGO select * from rh_colaboradores where NUMR_CPF IN ('52853780287')

begin tran -- commit rollback

set IDENTITY_INSERT rh_colaboradores on

insert into rh_colaboradores(NUMG_Colaborador,NOME_Colaborador,NUMG_Empresa,DATA_Nascimento,NUMG_CidadeNaturalidade,NUMG_PaisNacionalidade,NOME_Mae,NOME_Pai,DESC_Sexo,NUMG_EstadoCivil,NUMR_CPF,NUMR_Identidade,DESC_OrgaoEmissor,SIGL_UFOrgaoEmissor,DATA_Expedicao,NUMR_TituloEleitor,NUMR_ZonaTitulo,NUMR_SecaoTitulo,NUMR_PisPasep,NUMR_CarteiraProf
,NUMR_Serie,NUMR_Reservista,NUMS_MatFuncional,NUMS_MatriculaIpasgo,NUMS_ComplementoIpasgo,NUMR_Prontuario,NUMG_Grupo,NUMG_situacao,DESC_Observacao,NUMG_MotivoBloqueio,FLAG_Bloqueio,DATA_Bloqueio,NUMG_OperadorBloqueio,DATA_Exoneracao,NUMR_DOE,DATA_DOE,DATA_Inclusao,NUMG_OperadorInclusao,DATA_Alteracao
,NUMG_OperadorAlteracao,TIPO_IsentoFrequencia,NOME_CidadeNaturalidade)
Select NUMG_Colaborador,NOME_Colaborador,NUMG_Empresa,DATA_Nascimento,NUMG_CidadeNaturalidade,NUMG_PaisNacionalidade,NOME_Mae,NOME_Pai,DESC_Sexo,NUMG_EstadoCivil,NUMR_CPF,NUMR_Identidade,DESC_OrgaoEmissor,SIGL_UFOrgaoEmissor,DATA_Expedicao,NUMR_TituloEleitor,NUMR_ZonaTitulo,NUMR_SecaoTitulo,NUMR_PisPasep,NUMR_CarteiraProf
,NUMR_Serie,NUMR_Reservista,NUMS_MatFuncional,NUMS_MatriculaIpasgo,NUMS_ComplementoIpasgo,NUMR_Prontuario,NUMG_Grupo,NUMG_situacao,DESC_Observacao,NUMG_MotivoBloqueio,FLAG_Bloqueio,DATA_Bloqueio,NUMG_OperadorBloqueio,DATA_Exoneracao,NUMR_DOE,DATA_DOE,DATA_Inclusao,NUMG_OperadorInclusao,DATA_Alteracao
,NUMG_OperadorAlteracao,TIPO_IsentoFrequencia,NOME_CidadeNaturalidade
From assistencia.ipasgo.dbo.rh_colaboradores where NUMR_CPF = '01508274665'

insert into rh_colaboradores(NUMG_Colaborador,NOME_Colaborador,NUMG_Empresa,DATA_Nascimento,NUMG_CidadeNaturalidade,NUMG_PaisNacionalidade,NOME_Mae,NOME_Pai,DESC_Sexo,NUMG_EstadoCivil,NUMR_CPF,NUMR_Identidade,DESC_OrgaoEmissor,SIGL_UFOrgaoEmissor,DATA_Expedicao,NUMR_TituloEleitor,NUMR_ZonaTitulo,NUMR_SecaoTitulo,NUMR_PisPasep,NUMR_CarteiraProf
,NUMR_Serie,NUMR_Reservista,NUMS_MatFuncional,NUMS_MatriculaIpasgo,NUMS_ComplementoIpasgo,NUMR_Prontuario,NUMG_Grupo,NUMG_situacao,DESC_Observacao,NUMG_MotivoBloqueio,FLAG_Bloqueio,DATA_Bloqueio,NUMG_OperadorBloqueio,DATA_Exoneracao,NUMR_DOE,DATA_DOE,DATA_Inclusao,NUMG_OperadorInclusao,DATA_Alteracao
,NUMG_OperadorAlteracao,TIPO_IsentoFrequencia,NOME_CidadeNaturalidade)
Select NUMG_Colaborador,NOME_Colaborador,NUMG_Empresa,DATA_Nascimento,NUMG_CidadeNaturalidade,NUMG_PaisNacionalidade,NOME_Mae,NOME_Pai,DESC_Sexo,NUMG_EstadoCivil,NUMR_CPF,NUMR_Identidade,DESC_OrgaoEmissor,SIGL_UFOrgaoEmissor,DATA_Expedicao,NUMR_TituloEleitor,NUMR_ZonaTitulo,NUMR_SecaoTitulo,NUMR_PisPasep,NUMR_CarteiraProf
,NUMR_Serie,NUMR_Reservista,NUMS_MatFuncional,NUMS_MatriculaIpasgo,NUMS_ComplementoIpasgo,NUMR_Prontuario,NUMG_Grupo,NUMG_situacao,DESC_Observacao,NUMG_MotivoBloqueio,FLAG_Bloqueio,DATA_Bloqueio,NUMG_OperadorBloqueio,DATA_Exoneracao,NUMR_DOE,DATA_DOE,DATA_Inclusao,NUMG_OperadorInclusao,DATA_Alteracao
,NUMG_OperadorAlteracao,TIPO_IsentoFrequencia,NOME_CidadeNaturalidade
From assistencia.ipasgo.dbo.rh_colaboradores where NUMR_CPF = '52853780287'

set IDENTITY_INSERT rh_colaboradores off


begin tran -- commit rollback
set IDENTITY_INSERT operadores on
insert into operadores(NUMG_Operador,NUMG_OperadorInclusao,NOME_Operador,DESC_Alias,NUMR_OperadorSQL,NOME_Completo,DESC_Senha,DESC_Observacao,DATA_Nascimento,DATA_Bloqueio,DATA_Inclusao,NUMG_Secao,FLAG_AtendeMais,NOME_Computador)
select NUMG_Operador,NUMG_OperadorInclusao,NOME_Operador,DESC_Alias,NUMR_OperadorSQL,NOME_Completo,DESC_Senha,DESC_Observacao,DATA_Nascimento,DATA_Bloqueio,DATA_Inclusao,NUMG_Secao,FLAG_AtendeMais,NOME_Computador
from assistencia.ipasgo.dbo.operadores where nome_operador = '01508274665'

insert into operadores(NUMG_Operador,NUMG_OperadorInclusao,NOME_Operador,DESC_Alias,NUMR_OperadorSQL,NOME_Completo,DESC_Senha,DESC_Observacao,DATA_Nascimento,DATA_Bloqueio,DATA_Inclusao,NUMG_Secao,FLAG_AtendeMais,NOME_Computador)
select NUMG_Operador,NUMG_OperadorInclusao,NOME_Operador,DESC_Alias,NUMR_OperadorSQL,NOME_Completo,DESC_Senha,DESC_Observacao,DATA_Nascimento,DATA_Bloqueio,DATA_Inclusao,NUMG_Secao,FLAG_AtendeMais,NOME_Computador
from assistencia.ipasgo.dbo.operadores where nome_operador = '52853780287'
set IDENTITY_INSERT operadores off

enable trigger [tr_i_Operadores] on operadores

/* 

Se precisar colocar permissões basicas 
use IPASGO select * from operadores where nome_operador IN ('01508274665')
use IPASGO select * from operadores where nome_operador IN ('52853780287')

*/
--up_OpIncluiGrupoOperadores 8578, '148|338|535|545'


 