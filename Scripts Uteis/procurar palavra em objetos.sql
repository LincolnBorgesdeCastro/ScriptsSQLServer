use ipasgo
select distinct sys.name from sysobjects sys 
inner join syscomments co on co.id = sys.id
where 
co.text like '%@erro%' and 
sys.xtype = 'p'
order by sys.name



USE [ipasgo]
GO

-- Iniciando a pesquisa nas tabelas de sistemas

SELECT A.NAME, A.TYPE, B.TEXT
  FROM SYSOBJECTS  A (nolock)
  JOIN SYSCOMMENTS B (nolock) 
    ON A.ID = B.ID
WHERE B.TEXT LIKE '%gi_dba%'  --- Informação a ser procurada no corpo da procedure, funcao ou view
  AND A.TYPE = 'P'                     --- Tipo de objeto a ser localizado no caso procedure
 ORDER BY A.NAME

GO 

   