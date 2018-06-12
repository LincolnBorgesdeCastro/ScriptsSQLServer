--CREATE PROCEDURE SP_TakeOfflineAllDatabase(@Flag_Status smallint = 0) AS
--BEGIN

    DECLARE @Flag_Status smallint = 6
	--0 = OnLine
	--6 = OffLine

    DECLARE @db sysname, @q varchar(max);
    
    --SELECT * FROM sys.databases WHERE owner_sid<>0x01 and group_database_id is null;
    SELECT name FROM sys.databases WHERE owner_sid<>0x01 and group_database_id is null and state <> @Flag_Status;

	DECLARE cur_db CURSOR FOR
        SELECT name FROM sys.databases WHERE owner_sid<>0x01 and group_database_id is null and state <> @Flag_Status;
 
	OPEN cur_db;

    WHILE 1=1
    BEGIN
        FETCH NEXT FROM cur_db INTO @db;

        IF @@FETCH_STATUS <> 0
           BREAK;

        IF @Flag_Status = 6  
           SET @q = N'ALTER DATABASE [' + @db + N'] SET OFFLINE WITH ROLLBACK IMMEDIATE';
        ELSE
		   SET @q = N'ALTER DATABASE [' + @db + N'] SET ONLINE';

        EXEC(@q);
    END;

    CLOSE cur_db;
    DEALLOCATE cur_db;
--END;