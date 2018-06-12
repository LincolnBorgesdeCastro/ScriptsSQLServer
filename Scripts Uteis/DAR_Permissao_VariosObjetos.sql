SET NOCOUNT ON


DECLARE @VtblCodeID TABLE

 ( CodeID INT NOT NULL

 IDENTITY(1, 1)

 PRIMARY KEY CLUSTERED

 , Code VARCHAR(255) )

DECLARE @Debug BIT

SET @Debug = 1 

INSERT INTO @VtblCodeID

 SELECT 'GRANT SELECT ON [' + name + '] TO icis_app'

 FROM SYSOBJECTS

 WHERE TYPE IN ( 'U', 'V', 'FN' )



DECLARE @VinCounter INT

 , @VinCounterMax INT

 , @CODE VARCHAR(255)

 , @SQL VARCHAR(255)



SELECT @VinCounter = 1

 , @VinCounterMax = MAX(CodeID)

FROM @VtblCodeID



--LOOP THROUGH EACH CODE RECORD

WHILE ( @VinCounter <= @VinCounterMax )

 BEGIN

 SELECT @SQL = Code

 FROM @VtblCodeID

 WHERE CodeID = @VinCounter

 SET @VinCounter = @VinCounter + 1

 IF @Debug = 1 

 PRINT @SQL

 IF @Debug = 0 

 EXEC ( @SQL )

 END




