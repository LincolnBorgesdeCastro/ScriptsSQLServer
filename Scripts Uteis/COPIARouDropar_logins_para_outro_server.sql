-- Setup a linked server called impserve
--     r from which the
-- standard logins needs to be transferr
--     ed. You can call it
-- whatever you want & modify the linked
--      server name also.

DECLARE @login sysname , @password sysname 
DECLARE implogins CURSOR FOR 
 SELECT name , password 
 FROM master.dbo.syslogins 
 WHERE isntname = 0 AND charindex( 'repl_' , name ) = 0 and 
charindex( 'distributor' , name ) = 0 AND name != 'sa' 
OPEN implogins 
WHILE ( 'FETCH IS OK' = 'FETCH IS OK' ) 


    BEGIN 
     FETCH implogins INTO @login , @password 
     IF @@fetch_status < 0 BREAK 
     print 'EXEC sp_addlogin '''+ @login +''','''+ @password+''', @encryptopt = ''skip_encryption'''
END 
CLOSE implogins 
DEALLOCATE implogins 
GO 



Dropar Logins
DECLARE @login sysname , @password sysname 
DECLARE implogins CURSOR FOR 
 SELECT name , password 
 FROM master.dbo.syslogins 
 WHERE isntname = 0 AND charindex( 'repl_' , name ) = 0 and 
charindex( 'distributor' , name ) = 0 AND name != 'sa' 
OPEN implogins 
WHILE ( 'FETCH IS OK' = 'FETCH IS OK' ) 


    BEGIN 
     FETCH implogins INTO @login , @password 
     IF @@fetch_status < 0 BREAK 
     print 'EXEC sp_droplogin '''+ @login + ''''
END 
CLOSE implogins 
DEALLOCATE implogins 
GO 
