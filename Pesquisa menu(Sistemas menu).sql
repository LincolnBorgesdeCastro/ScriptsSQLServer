
select * from Sistemas_Menus
where DESC_linkMenu like '%Gastos Com Procedimentos de Hemodinâmica%'



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