

declare @nome varchar(100)

DECLARE cur CURSOR FOR 
select name from sysobjects where xtype = 'P'

OPEN cur

FETCH NEXT FROM cur INTO @nome

WHILE @@FETCH_STATUS = 0
BEGIN

set @nome = 'geimporta.' + @nome

EXEC sp_changeobjectowner @nome, 'dbo'

FETCH NEXT FROM cur INTO @nome

END

CLOSE cur
DEALLOCATE cur













