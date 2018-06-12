-------------------------------------
-- Extracao
-------------------------------------
create	table #temp(numg_matricula int, nome_usuario varchar(70))
create	table #Segurados (numg_matricula int)
create	table #Seg_Excluidos (numg_matricula int, numg_motivo int)
create	table #Dependentes (numg_matricula int)
create	table #Dep_Excluidos (numg_matricula int, numg_motivo int)


-- Segurados
insert	#Segurados
select	usu.numg_matricula
from	dbo.usuarios usu
inner	join ipasgo.dbo.segurados seg on usu.numg_matricula = seg.numg_matricula  



-- Seg_Excluidos
insert	#Seg_Excluidos
select	usu.numg_matricula,
	segexc.numg_motivo
from	dbo.usuarios usu
inner	join ipasgo.dbo.seg_excluidos segexc on usu.numg_matricula = segexc.numg_matricula  



-- Dependentes
insert	#Dependentes
select	usu.numg_matricula
from	dbo.usuarios usu
inner	join ipasgo.dbo.dependentes dep on usu.numg_matricula = dep.numg_matricula  



-- Dep_Excluidos
insert	#Dep_Excluidos
select	usu.numg_matricula,
	depexc.numg_motivo
from	dbo.usuarios usu
inner	join ipasgo.dbo.dep_excluidos depexc on usu.numg_matricula = depexc.numg_matricula  



------------------------------------------
-- Transformacao 
------------------------------------------
create table #metricas
(
	UsuMatricula int,
	nome_usuario varchar(70),
	SegMatricula int,
	SegExcMatricula int,
	DepMatricula int,
	DepExcMatricula int,
	SegExcMotivo int,
	DepExcMotivo int
)

create table #metricas2
(
	UsuMatricula int,
	nome_usuario varchar(70),
	status varchar(9)
)


insert #metricas
(
	UsuMatricula,
	nome_usuario,
	SegMatricula,
	SegExcMatricula,
	DepMatricula,
	DepExcMatricula,
	SegExcMotivo,
	DepExcMotivo
)
select	usu.numg_matricula as UsuMatricula,
	usu.nome_usuario,
	seg.numg_matricula as SegMatricula,
	segexc.numg_matricula as SegExcMatricula,
	dep.numg_matricula as DepMatricula,
	depexc.numg_matricula as DepExcMatricula,
	segexc.numg_motivo as SegExcMotivo,
	depexc.numg_motivo as DepExcMotivo
from	dbo.usuarios usu
left	join #dependentes dep on usu.numg_matricula = dep.numg_matricula 
left	join #dep_excluidos depexc on usu.numg_matricula = depexc.numg_matricula 
left	join #segurados seg on usu.numg_matricula = seg.numg_matricula
left	join #seg_excluidos segexc on usu.numg_matricula = segexc.numg_matricula  


-- Regras
insert	#metricas2
(
	UsuMatricula,
	nome_usuario,
	status
)
select	UsuMatricula,
	nome_usuario,
	case
	when	SegMatricula is not null
	and	SegExcMatricula is null
	and	DepMatricula is null
	and	DepExcMatricula is null	
	then	'ATIVO' -- 1
	when	SegMatricula is null
	and	SegExcMatricula is not null
	and	DepExcMatricula is null
	and	DepExcMatricula is null
	and	SegExcMotivo in (2, 9, 17, 20, 21, 22, 23, 24, 25, 28, 30, 31, 32, 36, 38, 39, 40, 41, 42, 46)
	then	'BLOQUEADO' -- 2
	when	SegMatricula is null
	and	SegExcMatricula is not null
	and	DepMatricula is null
	and	DepExcMatricula is null
	and	SegExcMotivo not in (2, 9, 17, 20, 21, 22, 23, 24, 25, 28, 30, 31, 32, 36, 38, 39, 40, 41, 42, 46)
	then	'EXCLUIDO' -- 3
	when	SegMatricula is null
	and	SegExcMatricula is null
	and	DepMatricula is not null
	and	DepExcMatricula is null
	then	'ATIVO' --1
	when	SegMatricula is null
	and	SegExcMatricula is null
	and	DepMatricula is null
	and	DepExcMatricula is not null
	and	DepExcMotivo in (0, 1, 2, 3, 13, 14, 20, 23, 24, 26, 27, 28, 29, 30, 32, 34, 35, 36, 37, 39, 41, 42)
	then	'BLOQUEADO' -- 2
	when	SegMatricula is null
	and	SegExcMatricula is null
	and	DepMatricula is null
	and	DepExcMatricula is not null
	and	DepExcMotivo not in (0, 1, 2, 3, 13, 14, 20, 23, 24, 26, 27, 28, 29, 30, 32, 34, 35, 36, 37, 39, 41, 42)
	then	'EXCLUIDO' -- 3
	else	'ERRO' -- 9
	end as codigo
from	#metricas


-------------------------------------
-- Validacao
-------------------------------------
select	UsuMatricula
from	#metricas2
where	status = 'ERRO'

