
/*select	seg.numg_matricula
Into 	SegDep1
from	Segurados seg
inner	join Dep_Excluidos dep on dep.numg_matricula = seg.numg_matricula

select * from SegDep1

Begin tran -- commit rollback
Delete  Dep
From dbo.Dep_Excluidos Dep
Inner Join SegDep1 Tmp On Dep.Numg_Matricula = Tmp.numg_matricula

Begin tran -- commit rollback
Delete Usuarios Where Numg_Matricula In (876065,905361,873610,909218,909219,923996,823778,
984405,926157,926159,987494,987495,987776,987777,988152,988154,988155,988157,988159,988161,
982618,981914,981915,989722,989723,989724,989725,973034,973035,975615,975616)
and Numg_Matricula not In (select numg_matricula from #cartoes)

select distinct numg_matricula
into #cartoes
from Cartoes_Solicitados
Where Numg_Matricula In (876065,905361,873610,909218,909219,923996,823778,
984405,926157,926159,987494,987495,987776,987777,988152,988154,988155,988157,988159,988161,
982618,981914,981915,989722,989723,989724,989725,973034,973035,975615,975616)


Delete Usuarios Where Numg_Matricula In (94380,96951,551581,124802,291425,142206,474390,
128004,128006,128008,128010,678442)
Begin tran -- commit rollback
Delete sv_DneUsuarios Where Numg_Matricula In (94380,96951,551581,124802,291425,142206,474390,
128004,128006,128008,128010,678442)



SELECT 
	AG.NUMG_ATENDIMENTO,
	AG.NUMG_GUIA, 
	PG.NUMG_ATENDIMENTO
FROM POLIMED_ATENDIMENTOSGUIAS AG 
LEFT JOIN POLIMED_PROCEDIMENTOSGUIAS PG ON AG.NUMG_ATENDIMENTO = PG.NUMG_ATENDIMENTO
WHERE PG.NUMG_ATENDIMENTO IS NULL


SELECT * FROM PROCEDIMENTOS_GUIAS WHERE NUMG_GUIA = 7743621


NUMG_atendimento
NUMR_seqProcedimento
NUMR_autorizacao
DESC_situacao
NUMG_mensagem
NUMG_solicitante
NUMG_executante
NUMG_procedimento
VALR_coParticipacao
VALR_recPrestador
NUMR_sessao
VALR_insumo
VALR_honorario
VALR_insumoCalculado
VALR_honorarioCalculado
NUMG_ProcedimentoGuias




Delete Usuarios Where Numg_Matricula In (94380,96951,551581,124802,291425,142206,474390,
128004,128006,128008,128010,678442)

*/