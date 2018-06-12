DECLARE @FKName			VARCHAR(255)
DECLARE @MainEntity		VARCHAR(255)
DECLARE @SQLString			VARCHAR(4000)

DECLARE cur_FK CURSOR FOR
	SELECT	name FKName, OBJECT_NAME(parent_object_id) MainEntity
	FROM	sys.foreign_keys
	WHERE	OBJECT_NAME(referenced_object_id) = 'User'
OPEN cur_FK
FETCH NEXT FROM cur_FK INTO @FKName, @MainEntity

WHILE @@FETCH_STATUS = 0 BEGIN                         --NOCHECK   
	SET @SQLString = 'ALTER TABLE ['+ @MainEntity + '] CHECK CONSTRAINT [' + @FKName +']'

	--PRINT @SQLString
	EXEC (@SQLString)

FETCH NEXT FROM cur_FK INTO @FKName, @MainEntity
END
CLOSE cur_FK
DEALLOCATE cur_FK