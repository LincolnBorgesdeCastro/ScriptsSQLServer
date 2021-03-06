----------------------------------------------
-- Testes 
----------------------------------------------
-- -- drop table #del_ave_turma
-- -- drop table #ide_ave_turma
-- -- drop table #sel_ave_turma
-- -- 
-- -- declare @origem varchar(100)
-- -- declare @getdate datetime
-- -- 
-- -- set @origem ='\\giz\e$\Imp_SIGE2005\Descompactados\DADOS_52056503_03102005_P\'
-- -- set @getdate = '01/01/2005'
-- -- 

----------------------------------------------
-- Variaveis
----------------------------------------------
declare @exe nvarchar(4000)
declare @update varchar(5)
declare @delete varchar(5)
declare @insert varchar(5)
declare @ok bit


----------------------------------------------
-- Tabelas
----------------------------------------------
if object_id('tempdb..#del_operadores') > 0 drop table #del_operadores
create	table #del_operadores
(
	NUMG_Operador int
)

if object_id('tempdb..#ide_operadores') > 0 drop table #ide_operadores
create	table #ide_operadores
(
	NUMG_Operador int
)

if object_id('tempdb..#sel_operadores') > 0 drop table #sel_operadores
create	table #sel_operadores
(
	NUMG_operador smallint,
	NOME_operador	varchar(20),
	DESC_senha varchar(6),
	DATA_inclusao smalldatetime,
	NOME_completo varchar(40),
	NUMG_secao smallint,
	DESC_observacao varchar(255),
	DATA_nascimento datetime,
	DATA_bloqueio datetime,
	NUMR_operadorSQL smallint
)

----------------------------------------------------------------------------------------
-- Apaga registros
----------------------------------------------------------------------------------------

---- Identifica registros apagados
insert	#del_operadores
(
	numg_operador
)
select	turS.numg_operador
from	operadores turS
	left	join dbnts.ipasgo.dbo.operadores tur on tur.numg_operador = turS.numg_operador
where	tur.numg_operador is null

-- Apaga registro
delete	turS
from	operadores turS
inner	join #del_operadores tur on tur.numg_operador = turS.numg_operador

set @delete = @@rowcount


----------------------------------------------------------------------------------------
-- Altera registros
----------------------------------------------------------------------------------------

---- Identifica registros alterados
insert	#ide_operadores
(
	numg_operador
)
select	i1S.numg_operador
from	operadores i1S
left	join dbnts.ipasgo.dbo.operadores i1 on 
	i1S.numg_operador = i1.numg_operador
	and i1S.NOME_operador = i1.NOME_operador
	and i1S.DESC_senha = i1.DESC_senha
	and i1S.DATA_inclusao = i1.DATA_inclusao
	and i1S.NOME_completo = i1.NOME_completo
	and i1S.NUMG_secao = i1.NUMG_secao
	and i1S.DESC_observacao = i1.DESC_observacao
	and i1S.DATA_nascimento = i1.DATA_nascimento
	and i1S.DATA_bloqueio = i1.DATA_bloqueio
	and i1S.NUMR_operadorSQL = i1.NUMR_operadorSQL
where i1.numg_operador is null

	
---- Seleciona registros alterados
insert	#sel_operadores 
(
NUMG_operador,
NOME_operador,
DESC_senha,
DATA_inclusao,
NOME_completo,
NUMG_secao,
DESC_observacao,
DATA_nascimento,
DATA_bloqueio,
NUMR_operadorSQL
)
select	i1.NUMG_operador,
	i1.NOME_operador,
	i1.DESC_senha,
	i1.DATA_inclusao,
	i1.NOME_completo,
	i1.NUMG_secao,
	i1.DESC_observacao,
	i1.DATA_nascimento,
	i1.DATA_bloqueio,
	i1.NUMR_operadorSQL
from	#ide_operadores ide
inner	join  dbnts.ipasgo.dbo.operadores i1 on ide.numg_operador = i1.numg_operador



---- Altera registros
update	i1S set
NUMG_operador = si1.NUMG_operador,
NOME_operador = si1.NOME_operador,
DESC_senha = si1.DESC_senha,
DATA_inclusao = si1.DATA_inclusao,
NOME_completo = si1.NOME_completo,
NUMG_secao = si1.NUMG_secao,
DESC_observacao = si1.DESC_observacao,
DATA_nascimento = si1.DATA_nascimento,
DATA_bloqueio = si1.DATA_bloqueio,
NUMR_operadorSQL = si1.NUMR_operadorSQL
from	operadores i1S
inner	join #sel_operadores si1 on i1S.numg_operador = si1.numg_operador


set @update = @@rowcount


	
----------------------------------------------------------------------------------------
-- Insere registros
----------------------------------------------------------------------------------------
set identity_insert operadores on
insert	operadores
(
NUMG_operador,
NOME_operador,
DESC_senha,
DATA_inclusao,
NOME_completo,
NUMG_secao,
DESC_observacao,
DATA_nascimento,
DATA_bloqueio,
NUMR_operadorSQL
)
select	tur.NUMG_operador,
	tur.NOME_operador,
	tur.DESC_senha,
	tur.DATA_inclusao,
	tur.NOME_completo,
	tur.NUMG_secao,
	tur.DESC_observacao,
	tur.DATA_nascimento,
	tur.DATA_bloqueio,
	tur.NUMR_operadorSQL
from	dbnts.ipasgo.dbo.operadores tur
left	join operadores turS on tur.numg_operador = turS.numg_operador
where	turS.numg_operador is null

set @insert = @@rowcount