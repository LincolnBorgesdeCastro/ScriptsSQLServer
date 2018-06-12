SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

alter  function fn_DesCriptografa( @strInput VARCHAR(1024), @strPassword VARCHAR(1024) = null )  
returns VARCHAR(1024)
with encryption
as
BEGIN
--Returns a string encrypted with  key k ( RC4 encryption )

DECLARE @i int
DECLARE @j int
DECLARE @n int
DECLARE @t int
DECLARE @s VARCHAR(256)
DECLARE @k VARCHAR(256)
DECLARE @tmp1 CHAR(1)
DECLARE @tmp2 CHAR(1)
DECLARE @result VARCHAR(1024)


select @result = master.dbo.fn_Criptografa(@strInput,@strPassword)
set @result = replace(@result, '*', '')
RETURN @result
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

