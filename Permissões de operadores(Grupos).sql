
Sp_helpuser '01110595182'
Sp_helprotect '01110595182'
Sp_helprotect null, '01110595182'

Select * From Operadores Where nome_operador = '01110595182'
--7049

Select Ope.NOME_Operador, Ope.NOME_Completo, Gru.DESC_grupo, Gru.SIGL_grupo 
From Operadores Ope inner join Operadores_Grupos OpeGru on Ope.NUMG_Operador = OpeGru.NUMG_operador
                             inner join Grupos Gru on OpeGru.NUMG_grupo = Gru.NUMG_grupo
Where Ope.NUMG_operador = 7049



