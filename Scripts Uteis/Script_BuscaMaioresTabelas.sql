-- Este script permite localizar as maiores tabelas de uma base

Select object_name(id),rowcnt,dpages*8 as [tamanho KB] from sysindexes 
where indid in (1,0) and objectproperty(id,'isusertable')=1 
order by rowcnt desc 


--select * from #Abono______________________________________________________________________________________________________________0000000095B1