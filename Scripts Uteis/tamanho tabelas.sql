USE IPASGO
GO

select substring(object_name(id),1,30) nome,
       rowcnt,
	   dpages*8/1024.0/1024.0 as [tamanho\GB]

from sysindexes
where indid in (1,0) and objectproperty(id,'isusertable')=1  
and substring(object_name(id),1,30) in ('Guias')

order by nome,[tamanho\GB]  desc

/**/

SELECT TOP 100
    OBJECT_NAME(object_id) As Tabela, Rows As Linhas,
    SUM(Total_Pages * 8) /1024.0 As "Reservado(MB)",
    SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) /1024.0  As "Dados(MB)",
        SUM(Used_Pages * 8)  -
        SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) /1024.0  As "Indice(MB)",
    SUM((Total_Pages - Used_Pages) * 8) /1024.0  As "NaoUtilizado(MB)"
FROM
    sys.partitions As P
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
--WHERE
--	OBJECT_NAME(object_id) in ('guias')

GROUP BY OBJECT_NAME(object_id), Rows
ORDER BY linhas desc


