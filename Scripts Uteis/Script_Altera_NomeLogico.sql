-- Este script permite alterar o nome lógico do database

ALTER DATABASE pubs MODIFY FILE (NAME = 'nortwind_Data',NEWNAME = 'pubs_Data')
GO
ALTER DATABASE pubs MODIFY FILE (NAME = 'nortwind_Log',NEWNAME = 'pubs_Log')