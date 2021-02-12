--sp_send_dbmail
--up_crEnviaEmailGeral
--@ipasgo.go.gov.br'
/*
--Contas de e-mails da Instância
EXECUTE msdb.dbo.sysmail_help_profileaccount_sp;
GO
*/
-- Lista de Objetos Que envia e-mail
EXECUTE master.sys.sp_MSforeachdb '
USE [?];
--if (''?''  in (''LOG'',''LOG_SIGA'',''LOG_SIFE'',''MONITOR'',''SADI'',''SBD'',''SIFE''))
--begin
Select distinct 
  sys.name As ''Nome do Objeto no Database ?'',
	case xtype 
	 when ''C''  THEN  ''CHECK constraint''
	 when ''D''  THEN  ''Default or DEFAULT constraint''
	 when ''F''  THEN  ''FOREIGN KEY constraint''
	 when ''L''  THEN  ''Log''
	 when ''FN'' THEN  ''Scalar function''
	 when ''IF'' THEN  ''Inlined table-function''
	 when ''P''  THEN  ''Stored procedure''
	 when ''PK'' THEN  ''PRIMARY KEY constraint (type is K)''
	 when ''RF'' THEN  ''Replication filter stored procedure ''
	 when ''S''  THEN  ''System table''
	 when ''TF'' THEN  ''Table function''
	 when ''TR'' THEN  ''Trigger''
	 when ''U''  THEN  ''User table''
	 when ''UQ'' THEN  ''UNIQUE constraint (type is K)''
	 when ''V''  THEN  ''View''
	 when ''X''  THEN  ''Extended stored procedure''
	END AS Tipo

from sysobjects sys inner join syscomments co on co.id = sys.id
where lower(co.text) like ''%@ipasgo.go.gov.br''''%'' 
--where lower(co.text) like ''%up_crEnviaEmailGeral%'' 
--where lower(co.text) like ''%sp_send_dbmail%'' 
order by sys.name
--end
';


