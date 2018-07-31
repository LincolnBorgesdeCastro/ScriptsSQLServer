SELECT
	sm.NUMG_Sistema 
	,sm.NUMG_SistemaMenu
	,g.NUMG_Grupo
	,g.DESC_Grupo
	,g.SIGL_Grupo
	,sm.DESC_SistemaMenu
	,sm.DESC_linkMenu
FROM 
	ipasgo.dbo.sistemas_menus sm
	INNER JOIN ipasgo.dbo.sistemas_grupos_operadores sgo ON sm.NUMG_SistemaMenu = sgo.NUMG_SistemaMenu
	INNER JOIN ipasgo.dbo.grupos g ON sgo.NUMG_Grupo = g.NUMG_Grupo
WHERE 
	sm.numg_sistema = 126