

set identity_insert dbo.sipm_Pesquisas on  

INSERT dbo.sipm_Pesquisas (
NUMG_Pesquisa					 ,
NUMG_OperadorInclusao	 ,
NOME_Pesquisa					 ,
DESC_Cabecalho				 ,
DATA_Inicio						 ,
DATA_Termino					 ,
FLAG_Ativo						 ,
FLAG_RespostaAnonima	 ,
FLAG_RespostaMultipla	 ,
FLAG_FormularioUnico	 ,
DATA_Inclusao
)
SELECT 
ASS.NUMG_Pesquisa					 ,
ASS.NUMG_OperadorInclusao	 ,
ASS.NOME_Pesquisa					 ,
ASS.DESC_Cabecalho				 ,
ASS.DATA_Inicio						 ,
ASS.DATA_Termino					 ,
ASS.FLAG_Ativo						 ,
ASS.FLAG_RespostaAnonima	 ,
ASS.FLAG_RespostaMultipla	 ,
ASS.FLAG_FormularioUnico	 ,
ASS.DATA_Inclusao
  FROM ASSISTENCIA.[IPASGO].[dbo].[sipm_Pesquisas] ASS
  LEFT JOIN dbo.sipm_Pesquisas HOM ON ASS.NUMG_Pesquisa = HOM.NUMG_Pesquisa    
  WHERE HOM.NUMG_Pesquisa IS NULL --and hom2.NOME_Programa is null

set identity_insert dbo.sipm_Pesquisas off 