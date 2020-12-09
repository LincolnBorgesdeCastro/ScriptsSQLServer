SELECT * 
FROM OPENQUERY(otrs,

' Select 
a.id as NUMG_Chamado,
a.create_time,
tn as NUMR_Chamado, 
substring(adm.a_body from 1 for 3630)  as DESC_Chamado
		from public.ticket a 
		inner JOIN public.article b on b.ticket_id = a.id  
		inner JOIN public.article_data_mime ADM on b.id = ADM.Article_id  
		where adm.a_body like ''%OperadorAgenciaCorreio%'' 
		order by a.create_time desc')

