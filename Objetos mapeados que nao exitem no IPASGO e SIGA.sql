


Select distinct p.NOME_Objeto, s.SIGL_Sistema, s.DESC_Sistema
from dbo.scbd_PermissoesGrupos p inner join scbd_GruposEquipes g on p.NUMG_GrupoEquipe = g.NUMG_GrupoEquipe
								 inner join Sistemas s on g.NUMG_Sistema = s.NUMG_Sistema

where
 (select count(*) from ipasgo.sys.objects i where i.name = p.NOME_Objeto  ) = 0 and 
  (select count(*) from siga.sys.objects t where t.name = p.NOME_Objeto  ) = 0
  
and p.NOME_Objeto not like '%SGF-Processa Retorno%'


