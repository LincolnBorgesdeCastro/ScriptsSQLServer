		SELECT
			Name
			,[Path]
			,SUBSTRING([Path],18,425) As Caminho
		INTO #RelSSRS
		FROM 
			ReportServer.dbo.Catalog 
		WHERE 
			Type = 2 AND Path like '/RelatoriosIpasgo/%'

		SELECT
			sm.NUMG_Sistema 
			,sm.NUMG_SistemaMenu
			,g.NUMG_Grupo
			,g.DESC_Grupo
			,g.SIGL_Grupo
			,sm.DESC_SistemaMenu
			,sm.DESC_linkMenu
		INTO #RelMenu
		FROM 
			assistencia.ipasgo.dbo.sistemas_menus sm
			INNER JOIN assistencia.ipasgo.dbo.sistemas_grupos_operadores sgo ON sm.NUMG_SistemaMenu = sgo.NUMG_SistemaMenu
			INNER JOIN assistencia.ipasgo.dbo.grupos g ON sgo.NUMG_Grupo = g.NUMG_Grupo
		WHERE 
			sm.numg_sistema = 126

		SELECT 
			NUMG_Sistema,
			NUMG_SistemaMenu,
			NUMG_Grupo,
			DESC_Grupo,
			SIGL_Grupo,
			DESC_SistemaMenu,
			Caminho
		INTO #RelSSRSMenu
		FROM 
			#RelSSRS rs
			LEFT JOIN #RelMenu rm ON rs.Caminho COLLATE Latin1_General_CI_AI = rm.DESC_LinkMenu COLLATE Latin1_General_CI_AI

		SELECT
			NUMG_Sistema,
			NUMG_SistemaMenu,
			NUMG_Grupo,
			DESC_Grupo,
			SIGL_Grupo,
			DESC_SistemaMenu,
			Caminho
			into #todos
		FROM
			#RelSSRSMenu rsm
		ORDER BY
			Caminho,
			SIGL_Grupo


select * from #todos 
where desc_sistemamenu = 'Populações

