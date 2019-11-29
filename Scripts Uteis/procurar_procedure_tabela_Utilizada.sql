select distinct sys.name from sysobjects sys
inner join syscomments co on co.id = sys.id
where co.text like '%gv_dadosfinanceiros%' and xtype = 'p'
order by sys.name


SELECT distinct p.name, p.create_date, p.modify_date 
FROM  sys.procedures p inner join syscomments c on p.object_id = c.id
WHERE OBJECT_DEFINITION(object_id) LIKE '%DATA_ContribuicaoFinal%'
and   SUBSTRING(p.name, 1, 5) =  'up_gv'
AND   c.text like '%UPDATE%' 


Select distinct 
  sys.name,
	case xtype 
	 when 'C'  THEN 'CHECK constraint'
	 when 'D'  THEN  'Default or DEFAULT constraint'
	 when 'F'  THEN  'FOREIGN KEY constraint'
	 when 'L'  THEN  'Log'
	 when 'FN' THEN  'Scalar function'
	 when 'IF' THEN  'Inlined table-function'
	 when 'P'  THEN  'Stored procedure'
	 when 'PK' THEN  'PRIMARY KEY constraint (type is K)'
	 when 'RF' THEN  'Replication filter stored procedure '
	 when 'S'  THEN  'System table'
	 when 'TF' THEN  'Table function'
	 when 'TR' THEN  'Trigger'
	 when 'U'  THEN  'User table'
	 when 'UQ' THEN  'UNIQUE constraint (type is K)'
	 when 'V'  THEN  'View'
	 when 'X'  THEN  'Extended stored procedure'
	END AS Tipo

from sysobjects sys inner join syscomments co on co.id = sys.id
where lower(co.text) like '%up_aeBuscaAtendimentosNaoAuditados%' 
--and xtype = 'p'
order by sys.name

/******************************************************************************************************/
-- Para buscar quando quiser pesquivar mais de um valor na mesma pesquisa
/******************************************************************************************************/

USE IPASGO
GO

SELECT type_desc
,          obj.name AS SP_NAME
--,          mod.definition AS SP_DEFINITION
FROM sys.sql_modules AS mod
INNER JOIN sys.objects AS obj ON mod.object_id = obj.object_id
WHERE mod.definition LIKE '%usu_FichasSociais%'  
and mod.definition LIKE '%numg_patologia%'  --Objto a ser procurado
--and obj.NAME = 'up_ssBuscaPerfilFichaSocial'
ORDER BY type_desc

