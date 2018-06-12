CREATE FUNCTION dbo.ufn_VarbinaryToVarcharHex (@VarbinaryValue
varbinary(4000))
RETURNS Varchar(8000) AS
BEGIN

Declare @NumberOfBytes Int
Declare @LeftByte Int
Declare @RightByte Int

SET @NumberOfBytes = datalength(@VarbinaryValue)

IF (@NumberOfBytes > 4)
RETURN Payment.dbo.ufn_VarbinaryToVarcharHex(cast(substring(@VarbinaryValue,

1,

(@NumberOfBytes/2)) as varbinary(2000)))
+ Payment.dbo.ufn_VarbinaryToVarcharHex(cast(substring(@VarbinaryValue,

((@NumberOfBytes/2)+1),

2000) as varbinary(2000)))

IF (@NumberOfBytes = 0)
RETURN ''


-- Either 4 or less characters (8 hex digits) were input
SET @LeftByte = CAST(@VarbinaryValue as Int) & 15
SET @LeftByte = CASE WHEN (@LeftByte < 10)
THEN (48 + @LeftByte)
ELSE (87 + @LeftByte)
END
SET @RightByte = (CAST(@VarbinaryValue as Int) / 16) & 15
SET @RightByte = CASE WHEN (@RightByte < 10)
THEN (48 + @RightByte)
ELSE (87 + @RightByte)
END
SET @VarbinaryValue = SUBSTRING(@VarbinaryValue, 1,
(@NumberOfBytes-1))

RETURN CASE WHEN (@LeftByte < 10)
THEN
Payment.dbo.ufn_VarbinaryToVarcharHex(@VarbinaryValue) +
char(@RightByte) + char(@LeftByte)
ELSE
Payment.dbo.ufn_VarbinaryToVarcharHex(@VarbinaryValue) +
char(@RightByte) + char(@LeftByte)
END


END
go

GRANT EXECUTE ON [dbo].[ufn_VarbinaryToVarcharHex] TO [PUBLIC]
GO
