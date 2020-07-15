--select * from osmtd.dbo.ossys_User where NAME LIKE '%LINCOLN BORGES DE CASTRO%' and  External_id = 4798
-- Setando contexto
DECLARE @BinVar varbinary(11) 

Select @BinVar = CAST('1138' + space(128) AS varbinary(11))

SET CONTEXT_INFO @BinVar