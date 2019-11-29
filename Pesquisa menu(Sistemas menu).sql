
Select * from Sistemas_Menus
where DESC_sistemaMenu like '%Valor Gasto com Totalidade - PAS%'
--where DESC_linkMenu like '%Patologia%'



-- Argentina
SELECT
	Name
	,[Path]
	,SUBSTRING([Path],18,425) As Caminho,
	ModifiedDate
FROM 
	ARGENTINA.ReportServer.dbo.Catalog 
WHERE 
	Type = 2 AND Path like '/RelatoriosIpasgo/%'


	and Path like '%Gastos Com Procedimentos de Hemodinâmica%'



