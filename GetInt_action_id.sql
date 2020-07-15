create function dbo.GetInt_action_id ( @action_id varchar(4)) returns int
begin
	
	declare @x int
	
	SET @x = convert(int, convert(varbinary(1), upper(substring(@action_id, 1, 1))))
	
	if LEN(@action_id)>=2
		SET @x = convert(int, convert(varbinary(1), upper(substring(@action_id, 2, 1)))) * power(2,8) + @x
	
	else
	
		SET @x = convert(int, convert(varbinary(1), ' ')) * power(2,8) + @x
	
	if LEN(@action_id)>=3
	
		SET @x = convert(int, convert(varbinary(1), upper(substring(@action_id, 3, 1)))) * power(2,16) + @x
	
	else
	
		SET @x = convert(int, convert(varbinary(1), ' ')) * power(2,16) + @x
	
	if LEN(@action_id)>=4
	
		SET @x = convert(int, convert(varbinary(1), upper(substring(@action_id, 4, 1)))) * power(2,24) + @x
	
	else
	
		SET @x = convert(int, convert(varbinary(1), ' ')) * power(2,24) + @x
	
	return @x
	
end