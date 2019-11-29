Declare @DESC_Login  sysname = '13115424850'

Select 'IF NOT EXISTS (SELECT * FROM master.sys.sql_logins WHERE [name] = ''' + [name] + ''')
    CREATE LOGIN [' + [name] + '] 
    WITH PASSWORD=' + master.sys.fn_varbintohexstr(password_hash) + ' HASHED,
    SID = ' + master.sys.fn_varbintohexstr([sid]) + ',  
    DEFAULT_DATABASE=[' + default_database_name + '], DEFAULT_LANGUAGE=[us_english], 
    CHECK_EXPIRATION=' + CASE WHEN is_expiration_checked = 1 THEN 'ON' ELSE 'OFF' END + ', CHECK_POLICY=' + CASE WHEN is_policy_checked = 1 THEN 'ON' ELSE 'OFF' END + ';'
from master.sys.sql_logins 
where type_desc = 'SQL_LOGIN' 
and [name] not in ('sa', 'guest')
and name = @DESC_Login 

union all

Select  'IF EXISTS (SELECT * FROM master.sys.sql_logins WHERE [name] = ''' + [name] + ''')
    ALTER LOGIN [' + [name] + ']
    WITH CHECK_EXPIRATION=' + 
    CASE WHEN is_expiration_checked = 1 THEN 'ON' ELSE 'OFF' END + ', CHECK_POLICY=' + 
    CASE WHEN is_policy_checked = 1 THEN 'ON' ELSE 'OFF' END 
--[name], [sid] , password_hash 
from master.sys.sql_logins 
where type_desc = 'SQL_LOGIN' 
and [name] not in ('sa', 'guest')
and name = @DESC_Login 

--CREATE FUNCTION [dbo].[fn_hexadecimal] 
--(
--    -- Add the parameters for the function here
--     @binvalue varbinary(256)
--)
--RETURNS VARCHAR(256)
--AS
--BEGIN

--    DECLARE @charvalue varchar(256)
--    DECLARE @i int
--    DECLARE @length int
--    DECLARE @hexstring char(16)
--    SELECT @charvalue = '0x'
--    SELECT @i = 1
--    SELECT @length = DATALENGTH (@binvalue)
--    SELECT @hexstring = '0123456789ABCDEF' 
--    WHILE (@i <= @length) 
--    BEGIN
--      DECLARE @tempint int
--      DECLARE @firstint int
--      DECLARE @secondint int
--      SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
--      SELECT @firstint = FLOOR(@tempint/16)
--      SELECT @secondint = @tempint - (@firstint*16)
--      SELECT @charvalue = @charvalue +
--        SUBSTRING(@hexstring, @firstint+1, 1) +
--        SUBSTRING(@hexstring, @secondint+1, 1)
--      SELECT @i = @i + 1
--    END
--    return @charvalue

--END
--GO

--DROP FUNCTION [dbo].[fn_hexadecimal] 

/****************************************************************************************************************/
/*
SELECT 'create login [' + sp.name + '] ' + CASE
        WHEN sp.type IN (
                'U'
                ,'G'
                )
            THEN 'from windows '
        ELSE ''
        END + 'with ' + CASE
        WHEN sp.type = 'S'
            THEN 'password = ' + master.sys.fn_varbintohexstr(sl.password_hash) + ' hashed, ' + 'sid = ' + master.sys.fn_varbintohexstr(sl.sid) + ', check_expiration = ' + CASE
                    WHEN sl.is_expiration_checked > 0
                        THEN 'ON, '
                    ELSE 'OFF, '
                    END + 'check_policy = ' + CASE
                    WHEN sl.is_policy_checked > 0
                        THEN 'ON, '
                    ELSE 'OFF, '
                    END + CASE
                    WHEN sl.credential_id > 0
                        THEN 'credential = ' + c.name + ', '
                    ELSE ''
                    END
        ELSE ''
        END + 'default_database = ' + sp.default_database_name + CASE
        WHEN len(sp.default_language_name) > 0
            THEN ', default_language = ' + sp.default_language_name
        ELSE ''
        END
FROM sys.server_principals sp
LEFT JOIN sys.sql_logins sl ON sp.principal_id = sl.principal_id
LEFT JOIN sys.credentials c ON sl.credential_id = c.credential_id
WHERE sp.type IN (
        'S'
        ,'U'
        ,'G'
        )
    AND sp.name <> 'sa'
    AND sp.name NOT LIKE 'NT Authority%'
    AND sp.name NOT LIKE 'NT Service%'
*/
