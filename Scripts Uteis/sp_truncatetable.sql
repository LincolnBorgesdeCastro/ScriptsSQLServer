USE master
GO
IF exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_truncatetable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_truncatetable]
GO
/************************************************************************************
Procedure 	: sp_truncatetable
Objetivo    	: Permitir que um usu�rio com permiss�o de DELETE possa executar um
TRUNCATE na tabela
 
Parametros: @dbname    -> Nome do Banco
	  : @tbname    -> Nome da Tabela

*** Resquisito necess�rio:
	1- Usu�rio deve ter permiss�o de DELETE	na tabela
	2- Procedure deve ser criada na base MASTER
	3- Usu�rios N�o sysadmin devem ter permiss�o para executar a procedure de
   sistema xp_cmdshell. Configure em SQL Server Agent\Properties\Guia Job Systems.

*** Exemplo de execu��o:
DECLARE @return_status int
EXEC @return_status = sp_truncatetable 'pubs','tb_delete'
SELECT 'Return Status' = @return_status
GO

**** OBS: Testado com SQL Server 2000/2005

** SQL Server 2005: Se voc� receber o erro:
Msg 15153, Level 16, State 1, Procedure xp_cmdshell, Line 1
The xp_cmdshell proxy account information cannot be retrieved or is invalid. 
Verify that the '##xp_cmdshell_proxy_account##' credential exists and contains valid information.

Procure no BOL por xp_cmdshell e veja o t�pico "xp_cmdshell Proxy Account"

Autor: Nilton Pinheiro
Artigo: http://www.mcdbabrasil.com.br

ANTES DE COLOCAR ESTA PROCEDURE EM PRODU��O, TESTE..TESTE..TESTE !! QUALQUER EXCLUS�O
DE DADOS INDEVIDOS � DE SUA INTEIRA RESPONSABILIDADE.
*************************************************************************************/

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE PROCEDURE  sp_truncatetable
@dbname		varchar(30),
@tbname		varchar(50)
-- Se quiser criptografar a procedure, descomente a linha abaixo. Neste caso, guarde este script original !!
--WITH ENCRYPTION
AS
SET NOCOUNT ON

-- Declaracao de Variaveis
DECLARE @sql nvarchar(2000), @sql1 nvarchar(2000), @user varchar(256),
@userid	smallint, @usergroups 	smallint, @cont	smallint, 
@loop smallint, @tableid int, @posicao	tinyint

DECLARE @status tinyint 
-- 0 - Sucesso
-- 1 - Falha
-- 2 - A tabela n�o existe
-- 3 - Usu�rio tem permiss�o negada (DENY) na tabela. Verifique as permiss�es do usu�rio os roles que ele pertence.
-- 4 - Para executar o TRUNCATE � necess�rio ter permiss�o de DELETE na tabela. Verifique as permiss�es do usu�rio

-- Pega o usu�rio que executou a procedure
SET @user = suser_sname()
SET @userid= user_id()

-- Verifica se o usu�rio � de Dom�nio. Se for, pega apenas a parte do nome.
IF charindex('\',@user) <> 0
   begin
	SET @posicao = charindex('\',@user) + 1
	SET @user = substring(@user,@posicao,len(@user))	
   end

-- Verifica se a tabela existe
SET @sql = 'SELECT @tableid=id FROM '+ @dbname +'..sysobjects WHERE xtype=''U'' AND name=''' + @tbname + ''''
exec sp_executesql @sql, N'@tableid int OUTPUT', @tableid OUTPUT

IF @tableid is null 
	begin
	--A tabela n�o existe
	SET @status= 2
	RETURN @status
	end
	
-- verifica se usu�rio � dbo ou sa. Se for j� executa direto.
IF IS_SRVROLEMEMBER ('sysadmin') = 1 OR IS_MEMBER ('db_owner') = 1 GOTO executa

-- verifica em quantos grupos o usu�rio est� cadastrado
SET @sql = 'SELECT @cont=count(groupuid) FROM '+ @dbname +  '..sysmembers WHERE memberuid = ' + convert (varchar(256),@userid ) + ''
exec sp_executesql @sql, N'@cont smallint OUTPUT', @cont OUTPUT

IF @cont > 0
	begin
	-- Pega os grupos para colocar na cl�usula IN
	SET @sql = 'SELECT groupuid FROM '+ @dbname +  '..sysmembers WHERE memberuid = ' + convert (varchar(256),@userid ) + ''
	CREATE TABLE #tbgroups(grupo smallint)
	INSERT INTO #tbgroups exec (@sql)
	set rowcount 1
	SELECT @usergroups = grupo FROM #tbgroups
	SELECT @sql1 = ' AND (uid IN (' + convert(varchar(20),@usergroups) + ''
	SET @loop = 1
	WHILE @loop < @cont 
		begin
			set rowcount 1
			DELETE #tbgroups WHERE grupo = @usergroups
			SELECT @usergroups = grupo FROM #tbgroups
			SELECT @sql1 = @sql1 + ','+ convert(varchar(20), @usergroups) + ''
			SELECT @loop = @loop + 1
		end		
    SELECT @sql1 = @sql1 + ') OR uid='+ convert(varchar(25),@userid) + ')'
	DROP TABLE #tbgroups
	end
	
ELSE
	SELECT @sql1=' AND uid='+ convert(varchar(25),@userid)

set rowcount 0
-- verifica as permiss�es do usu�rio
SELECT @sql = 'SELECT action, protecttype FROM '+ @dbname +  '..sysprotects WHERE id='
+ convert(varchar(50),@tableid) +  @sql1

CREATE TABLE #tbuserpermission(action tinyint, protecttype tinyint )
INSERT INTO #tbuserpermission exec (@sql)

IF exists(SELECT 1 FROM #tbuserpermission where protecttype = 206 and action = 196)
	begin
		--Usu�rio tem permiss�o negada (DENY) na tabela. Verifique as permiss�es do usu�rio os roles que ele pertence!'
		DROP TABLE #tbuserpermission
		SET @status= 3	
		RETURN (@status)		
	end
ELSE
	begin
		-- Verifica se tem permiss�o de DELETE na tabela
		IF exists( SELECT 1 FROM #tbuserpermission WHERE action = 196 and protecttype = 205)
			begin
				-- Tem permiss�o
				DROP TABLE #tbuserpermission
			end
		ELSE
			begin						
				--Para executar o TRUNCATE � necess�rio ter permiss�o de DELETE na tabela. Verifique as permiss�es do usu�rio!'
				DROP TABLE #tbuserpermission
				SET @status= 4
				RETURN (@status)							
			end
	end

executa:
-- Executa o TRUNCATE TABLE usando a xp_cmdshell
-- Para funcionar � preciso que usu�rios N�O sysadmin possam executar a xp_cmdshell.
-- Qualquer d�vida consulte o Books Online do SQL Server pesquisando por "xp_cmdshell"

SET @sql = 'osql /b /E /n /S'+@@servername+' /dmaster /Q"TRUNCATE TABLE '+ @dbname + '..' + @tbname+'"'
exec @status = master..xp_cmdshell @sql, no_output
IF @status = 0 or @status is null
   	-- Sucesso
	RETURN 0
 ELSE
	-- Erro na execu��o da xp_cmdshell
	RETURN 1  
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT EXEC ON sp_truncatetable TO PUBLIC
GO