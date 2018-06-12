 SELECT NON EMPTY { [Measures].[Qtd_Solicitacoes], [Measures].[VALR_ProcAnalisado] } ON COLUMNS,
  NON EMPTY { (
  
				[Prestador Solicitante].[NOME Prestador].[NOME Prestador].ALLMEMBERS * 
               [Data Solicitacao].[Ano Mes].[Ano Mes].ALLMEMBERS * 
			   [Procedimentos Solicitados].[NOME Procedimento].[NOME Procedimento].ALLMEMBERS * 

			   [Justificativas Auditorias].[Justificativa Auditoria].[Justificativa Auditoria].ALLMEMBERS * 

			   [Status Solicitacoes].[DESC Status Geral].[DESC Status Geral].ALLMEMBERS
			   
			    ) } 


			   DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS FROM ( SELECT ( { [Data Solicitacao].[Ano Mes].&[2016-03], 
																								 [Data Solicitacao].[Ano Mes].&[2016-04], 
																								 [Data Solicitacao].[Ano Mes].&[2016-05] } ) 
			   ON COLUMNS FROM ( SELECT ( { [Prestador Solicitante].[NOME Prestador].&[AUGUSTO PEREIRA], 
											[Prestador Solicitante].[NOME Prestador].&[RONALDO DE MAGALHAES NARDELLI], 
											[Prestador Solicitante].[NOME Prestador].&[JOAO JORGE NASSARALLA JUNIOR] 
											
											} ) 
			   ON COLUMNS FROM [cbas_Autorizativa])) CELL PROPERTIES VALUE, 
 BACK_COLOR, FORE_COLOR, FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS
