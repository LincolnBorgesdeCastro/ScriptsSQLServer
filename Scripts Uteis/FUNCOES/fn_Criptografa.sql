SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create  function fn_Criptografa( @strInput VARCHAR(1024), @strPassword VARCHAR(1024)=null )  
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

if @strPassword is null 
set @strPassword = 'a5sd6jg5h7jfhg51jf32j1fd68f4dgd25lsd65f4s6df8gsdf3d21s6f85ds21f1s58dg41g1h5kakskdjalsdkasgdasd23as1d56as1d5a5sfsd2f156da8f79s6d8f4s3d216sad8f4s2gh5j4ds2fd1s5dh4tfg62n4df85a4sf651fdg6r5t4g3sd21as65dg4f6g5j4ghh5j4tf4vc6xf4s5df45s8df8gd4sadf4sr6tg8dffg45df5g4a5sd6jg5h7jfhg51jf32j1fd68f4dgd25lsd65f4s6df8gsdf3d21s6f85ds21f1s58dg41g1h5kakskdjalsdkasgdasd23as1d56as1d5a5sfsd2f156da8f79s6d8f4s3d216sad8f4s2gh5j4ds2fd1s5dh4tfg62n4df85a4sf651fdg6r5t4g3sd21as65dg4f6g5j4ghh5j4tf4vc6xf4s5df45s8df8gd4sadf4sr6tg8dffg45df5g4'
--print len(@strPassword)

DECLARE @TAMANHO INT
DECLARE @P VARCHAR(1025)

CRIPTO:
SET @P = @strinput + 'A'
SET @TAMANHO = LEN(@P)-1

SET @i=0 
SET @s='' 
SET @k='' 
SET @result=''
WHILE  @i <= 255
BEGIN
	SET @s=@s+CHAR(@i)
	SET  @k=@k+CHAR(ASCII(SUBSTRING(@strPassword, 1+@i %  LEN(@strPassword),1)))
	SET @i=@i+1
END

SET @i=0
SET  @j=0

WHILE @i<=255
BEGIN
	SET @j=(@j+ ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@k,@i+1,1)))% 256
	SET @tmp1 = SUBSTRING(@s,@i+1,1)
	SET @tmp2 = SUBSTRING(@s,@j+1,1)
	SET @s = STUFF(@s,@i+1,1,@tmp2)
	SET @s = STUFF(@s,@j+1,1,@tmp1)
--print str(@i)+'  '+str(@j)+'   '+str(ascii(SUBSTRING(@s,@i+1,1)))+'   '+str(ascii(SUBSTRING(@k,@i+1,1)))
	SET @i= @i+1
END
--SET @i=1 WHILE @i<=256 BEGIN print  ASCII(SUBSTRING(@s,@i,1)) SET @i=@i+1 END
SET @i=0 SET @j=0
SET @n=1
WHILE  @n<=@tamanho
BEGIN
	SET @i=(@i+1) % 256
	SET  @j=(@j+ASCII(SUBSTRING(@s,@i+1,1))) % 256
	SET @tmp1=SUBSTRING(@s,@i+1,1)
	SET  @tmp2=SUBSTRING(@s,@j+1,1)
	SET @s=STUFF(@s,@i+1,1,@tmp2)
	SET  @s=STUFF(@s,@j+1,1,@tmp1)
	SET  @t=((ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@s,@j+1,1))) % 256)
	--print  str(ASCII(SUBSTRING(@s,@t+1,1))) + '    ' +  str(ASCII(SUBSTRING(@strInput,@n,1)))
	IF  ASCII(SUBSTRING(@s,@t+1,1))=ASCII(SUBSTRING(@strInput,@n,1))
	SET  @result = @result+SUBSTRING(@strInput,@n,1)
ELSE
	SET  @result=@result+CHAR(ASCII(SUBSTRING(@s,@t+1,1)) ^  ASCII(SUBSTRING(@strInput,@n,1)))
	SET  @n=@n+1
END

IF PATINDEX('%|%', @RESULT) <> 0
BEGIN
	SET @strInput = @strInput + '*'
	GOTO CRIPTO

END  


RETURN @result
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

