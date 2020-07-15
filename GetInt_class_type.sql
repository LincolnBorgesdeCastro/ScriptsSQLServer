create function dbo.GetInt_class_type ( @class_type varchar(2)) returns int

begin

declare @x int

SET @x = convert(int, convert(varbinary(1), upper(substring(@class_type, 1, 1))))

if LEN(@class_type)>=2

SET @x = convert(int, convert(varbinary(1), upper(substring(@class_type, 2, 1)))) * power(2,8) + @x

else

SET @x = convert(int, convert(varbinary(1), ' ')) * power(2,8) + @x

return @x

end

go