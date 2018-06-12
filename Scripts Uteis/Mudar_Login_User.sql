-- Ex. usp_RenameLogin 'Test', 'TestLogin' 

---Code should be put in master database ---

CREATE PROCEDURE usp_RenameLogin 

@CurrentLogin sysname,
@NewLogin sysname 

AS 

DECLARE @SQLState AS VARCHAR(200) 

--Configure server to allow ad hoc updat -- es to system tables

EXEC master.dbo.sp_configure 'allow updates', '1'
RECONFIGURE WITH OVERRIDE 

--Update user login name in master db
-- >
SET @SQLState = 'UPDATE master.dbo.sysxlogins SET [name] = ''' + @NewLogin + ''' WHERE [name] = ''' + @CurrentLogin + ''''
EXEC (@SQLState) 

--Update user login name in each db wher -- e has access as in in sysusers table
-- 
SET @SQLState = 'EXEC master.dbo.sp_MSForEachDB ''UPDATE ?.dbo.sysusers SET [name] = ''''' + @NewLogin + ''''' where [name] = ''''' + @CurrentLogin + ''''''''
EXEC (@SQLState) 

--Configure server to disallow ad hoc
-- >--updates to system tables

EXEC master.dbo.sp_configure 'allow updates', '0'
RECONFIGURE WITH OVERRIDE
GO
