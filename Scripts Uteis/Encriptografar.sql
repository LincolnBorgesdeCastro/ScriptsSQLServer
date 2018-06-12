SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[fn_string_helper]') 
		and (OBJECTPROPERTY(id, N'IsTableFunction') 
			+ OBJECTPROPERTY(id, N'IsInlineFunction')
			+ OBJECTPROPERTY(id, N'IsScalarFunction') = 1 ) )
drop function [dbo].[fn_string_helper]
GO
create function dbo.fn_string_helper
 (@long_string     varchar(255),
  @short_string    varchar(32) )
RETURNS  varchar(255) 
with encryption
as
/***************************************************************************************
* Proc: fn_string_helper 
*
 * Purpose: Do encryption/ decryption: The name is deliberately vague and misleading for security
 *
 *	This procedure uses RC4 to encrypt/decrypt the first parameter
 *  using the second parameter in the encryption key.
 *
 * Input Parameters:
 *	 @long_string     varchar(255) - The string to be encrypted/decrypted.
 *       @short_string    varchar(32)  - The string key used to encrypt/decrypt.
 *
 * Output Parameters:
 *	  @out_string varchar(255) - The encrypted/decrypted string.
 *
 * CalledBy:
 *	n/a
 *
 * History:
 *	   Date		Developer	Description
 *	-------------	------------	--------------------------------------
 *	01/22/2002	Brad Baker	Created procedure.
 *	02/19/2002	Mike Arney	Optimized extensively and put in a function.	
 *	03/06/2002	Mike Arney	Use datalength instead of len because datalength
 *					  does an rtrim, which messes up decryption if the last
 *					  encrypted character happens to be 0x20 (space)
 *
 * Notes:
 *  1. RC4 is a stream cipher symmetric key algorithm.
 *     It was developed in 1987 by Ronald Rivest and kept as a trade secret by RSA Data Security.
 *     On September 9, 1994, the RC4 algorithm was anonymously posted on the Internet on the Cyperpunks’ “anonymous remailers” list. 
 *
 *  2. RC4 uses a variable length key from 1 to 256 bytes to initialize a 256-byte state table.
 *     The state table is used for subsequent generation of pseudo-random bytes and then to generate a pseudo-random stream which is XORed
 *     with the plaintext to give the ciphertext.
 *     Each element in the state table is swapped at least once.  
 *
 *  3. The RC4 key is often limited to 40 bits, because of export restrictions but it is sometimes used as a 128 bit key.
 *     It has the capability of using keys between 1 and 2048 bits.
 *     RC4 is used in many commercial software packages such as Lotus Notes and Oracle Secure SQL.
 *     It is also part of the Cellular Specification. 
 *
 *  4. Procedure name and parameter names should be meaningless.
 *     Renaming this procedure RC4 would be very helpful to hackers.
 *
 *  5. This procedure should always be encrypted.
 *
 *  6. Since this procedure is used for both encryption and decryption,
 *     it is important to limit permissions to it. 
 *
 *  7. If using this function to encrypt a column in a table, it is strongly suggested
 *     that you use a different of @short_string for each row.  Eg:
 *		select dbo.fn_string_helper(name, convert(varchar, id)) from sysobjects
 *     If you don't do this, a user who can figure out the encryption for one row can
 *     easily figure it out for all rows.
 *
***************************************************************************************/
begin

DECLARE @out_string varchar(255) 
DECLARE
	@state smallint,
	@key char(1),
	@tempSwap binary(1),
	@a smallint,
	@b smallint,
	@N smallint,
 	@temp binary(1),
	@i smallint,
	@j smallint,
	@k smallint,
	@cipherby smallint,
	@cipher varchar(255),
	@code   varchar(64),

	@keys_key varchar(256),
	@keys_state varbinary(256)

	-- The RC4 algorithm works in two phases, key setup and ciphering.
	-- Key setup is the first and most difficult phase of this algorithm.
	-- During a N-bit key setup (N being your key length),
	--  the encryption key is used to generate an encrypting variable using two arrays,
	--  state and key, and N-number of mixing operations.
	--  These mixing operations consist of swapping bytes,
	--   modulo operations, and other formulas.
	--  A modulo operation is the process of yielding a remainder from division.
	-- This implementation of RC4 uses temporary tables in place of arrays.

	-- Initialize variable values.
	SET @code = @short_string + ',./;''p[\`0-=Z<?L:"P{|~!@#%^*(_'

	-- Initialize temp table with key and state values.
	SET @keys_key = @code + @code + @code + @code + @code + @code + @code + @code + @code
	SET @keys_state = 0x000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7F808182838485868788898A8B8C8D8E8F909192939495969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8D9DADBDCDDDEDFE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF

-- select @keys_state, @keys_key

	-- Initialize variable values.
	SELECT
	 @b = 0,
	 @a = 0
    -- The state array now undergoes 256 mixing operations.
	WHILE @a < 256
	BEGIN
		SELECT @b = (@b + convert(int, substring(@keys_state, @a + 1, 1)) +
				  ascii(substring(@keys_key, @a + 1, 1))     ) % 256 
		SELECT @tempSwap = substring(@keys_state, @a + 1, 1)

		SET @keys_state = convert(varbinary(256), stuff(@keys_state, @a + 1, 1, substring(@keys_state, @b + 1, 1) )  )

		SET @keys_state = convert(varbinary(256), stuff(@keys_state, @b + 1, 1, @tempSwap) )

		SET @a = @a + 1
	END

-- select @keys_state, @keys_key

	-- Initialize variable values.
	SELECT
	 @i = 0,
	 @j = 0,
	 @a = 1,
	 @cipher = '',
	 @cipherby = 0

	-- Once the encrypting variable is produced from the key setup,
	--  it enters the ciphering phase,
	--  where it is XORed with the plain text message to create and encrypted message.
	--  XOR is the logical operation of comparing two binary bits.
	--  If the bits are different, the result is 1.
	--  If the bits are the same, the result is 0.
	--  The string is decrypted by XORing the encrypted message with the same encrypting key. 
	WHILE @a < datalength(@long_string) + 1
	BEGIN

		SET @j = (@j + convert(smallint, substring(@keys_state, @i + 1, 1))) % 256
		SET @temp = substring(@keys_state, @i + 1, 1)
		SET @i = (@i + 1) % 256

		SET @keys_state = convert(varbinary(256), stuff(@keys_state, @i + 1, 1, substring(@keys_state, @j + 1, 1)) ) 

		SET @keys_state = convert(varbinary(256), stuff(@keys_state, @i + 1, 1, @temp ) ) 

		SET @k = convert(smallint, 
				  substring(@keys_state, 
						1 + ((convert(smallint, substring(@keys_state, @i + 1, 1)) +
						      convert(smallint, substring(@keys_state, @j + 1, 1))  ) % 256),
						1)	)

		SET @cipherby = Ascii(Substring(@long_string, @a, 1)) ^ @k
		SET @cipher = @cipher + Char(@cipherby)
		SET @a = @a + 1
	END

	-- Set ouput variable.
	SET @out_string = @cipher

	RETURN @out_string 
END
GO
-- select dbo.fn_string_helper('this is a test', 'xxx')
-- select dbo.fn_string_helper(dbo.fn_string_helper('this is a test', 'xxx'), 'xxx')
-- select dbo.fn_string_helper(dbo.fn_string_helper(name, convert(varchar, id)), convert(varchar, id)), dbo.fn_string_helper(name, convert(varchar, id)) from sysobjects

