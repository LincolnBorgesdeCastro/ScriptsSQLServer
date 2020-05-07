
declare @DataInicio datetime
declare @DataFim datetime
declare @NomeEspace varchar (100)
declare @FlagApenasLogin bit

set @DataInicio = '2020-04-29 17:00:00'
set @DataFim = '2020-04-29 18:59:00'
set @NomeEspace = 'Prestadores_FrontEnd'
set @FlagApenasLogin = 0

SELECT TOP (11) ENLogAcessoSistema.[ID] o0, ENLogAcessoSistema.[USERID] o1, 
ENLogAcessoSistema.[ESPACENAME] o2, ENLogAcessoSistema.[DATAOCORRENCIA] o3, 
ENLogAcessoSistema.[IP] o4, ENLogAcessoSistema.[URLREQUISICAO] o5, 
ENLogAcessoSistema.[METODOREQUISICAO] o6, ENLogAcessoSistema.[POSTREQUISICAO] o7, 
ENLogAcessoSistema.[USUARIOINCLUSAOID] o8, ENLogAcessoSistema.[DATAINCLUSAO] o9, 
ENLogAcessoSistema.[ULTIMOUSUARIOID] o10, ENTipoUsuario.[ID] o11, ENTipoUsuario.[LABEL] o12, 
ENTipoUsuario.[ORDER] o13, ENTipoUsuario.[IS_ACTIVE] o14, ENUser.[ID] o15, ENUser.[NAME] o16, 
ENUser.[USERNAME] o17, ENUser.[PASSWORD] o18, ENUser.[EMAIL] o19, ENUser.[MOBILEPHONE] o20, 
ENUser.[EXTERNAL_ID] o21, ENUser.[CREATION_DATE] o22, ENUser.[LAST_LOGIN] o23, ENUser.[IS_ACTIVE] o24, 
ENUserPortal.[ID] o25, ENUserPortal.[TIPOUSUARIOID] o26, ENUserPortal.[USERID] o27, ENUserPortal.[USUARIOINCLUSAOID] o28, ENUserPortal.[SENHAREDE] o29, ENUserPortal.[DATAINCLUSAO] o30, ENUserPortal.[ULTIMOUSUARIOID] o31
FROM ((([SISIPASGO].DBO.[OSUSR_7O2_LOGACESSOSISTEMA] ENLogAcessoSistema
	Inner JOIN [OSMTD].DBO.[OSSYS_USER_T39] ENUser ON (ENLogAcessoSistema.[USERID] = ENUser.[ID])) 
	Inner JOIN [SISIPASGO].DBO.[OSUSR_7O2_USERPORTAL] ENUserPortal ON (ENUser.[ID] = ENUserPortal.[USERID])) 
	Inner JOIN [SISIPASGO].DBO.[OSUSR_7O2_TIPOUSUARIO] ENTipoUsuario ON (ENUserPortal.[TIPOUSUARIOID] = ENTipoUsuario.[ID])) 
WHERE (((((@DataFim <> (convert(datetime, '1900-01-01'))) 
AND (((((@DataInicio >= ENLogAcessoSistema.[DATAOCORRENCIA]) 
AND (@DataInicio <= ENLogAcessoSistema.[DATAOCORRENCIA])) 
OR ((@DataFim >= ENLogAcessoSistema.[DATAOCORRENCIA]) 
AND (@DataFim <= ENLogAcessoSistema.[DATAOCORRENCIA]))) OR ((@DataFim >= ENLogAcessoSistema.[DATAOCORRENCIA]) 
AND (@DataInicio <= ENLogAcessoSistema.[DATAOCORRENCIA]))) OR ((@DataInicio >= ENLogAcessoSistema.[DATAOCORRENCIA]) 
AND (@DataFim <= ENLogAcessoSistema.[DATAOCORRENCIA])))) OR ((@DataFim = (convert(datetime, '1900-01-01'))) AND 
(@DataFim >= ENLogAcessoSistema.[DATAOCORRENCIA]))) OR ((@DataFim = (convert(datetime, '1900-01-01'))) AND 
(@DataFim >= ENLogAcessoSistema.[DATAOCORRENCIA]))) OR ((@DataFim = (convert(datetime, '1900-01-01'))) AND
 (@DataFim = (convert(datetime, '1900-01-01'))))) AND (ENUser.[ID] IS NOT NULL) AND (ENLogAcessoSistema.[ESPACENAME] LIKE (@NomeEspace + N'%')) AND ((CASE WHEN (@FlagApenasLogin = 1) THEN (CASE WHEN (ENLogAcessoSistema.[METODOREQUISICAO] = N'') THEN 1 ELSE 0 END) ELSE (CASE WHEN (ENLogAcessoSistema.[METODOREQUISICAO] <> N'') THEN 1 ELSE 0 END) END) = 1)
ORDER BY ENLogAcessoSistema.[DATAOCORRENCIA] DESC 
