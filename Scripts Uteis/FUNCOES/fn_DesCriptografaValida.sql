SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

alter  function fn_DesCriptografaValida( @strInput VARCHAR(1024), @strCompare VARCHAR(1024) )  
returns bit
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
declare @resultado bit



select @result = master.dbo.fn_DesCriptografa(@strInput, null)

if @result = @strCompare
set @resultado = 1
else
set @resultado = 0

RETURN @resultado
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

