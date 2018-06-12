SELECT CASE WHEN (GROUPING(sob.name)=1) THEN 'All_Tables'
   ELSE ISNULL(sob.name, 'unknown') END AS Table_name,
   SUM(sys.length) AS Byte_Length
FROM sysobjects sob, syscolumns sys
WHERE sob.xtype='u' AND sys.id=sob.id
GROUP BY sob.name
WITH CUBE
order by 2 Desc

/*
select count(*) from sicd_LOGPrestacoesContas
select * from sicd_LOGPrestacoesContas


select count(*) from  sicd_PrestacoesContas
select * from sicd_PrestacoesContas

*/
