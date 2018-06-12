--Code Snippet
SET NOCOUNT ON

DECLARE @test varchar(20), @key varchar(100)

IF charindex('\',@@servername,0) <>0

BEGIN

set @key = 'SOFTWARE\MICROSOFT\Microsoft SQL Server\'+@@servicename+'\MSSQLServer\Supersocketnetlib\TCP'

END ELSE

BEGIN

set @key = 'SOFTWARE\MICROSOFT\MSSQLServer\MSSQLServer\Supersocketnetlib\TCP'

END

EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE',

@key=@key,@value_name='Tcpport',@value=@test OUTPUT

SELECT 'Server Name: '+@@servername + ' Port Number:'+convert(varchar(10),@test)

 

