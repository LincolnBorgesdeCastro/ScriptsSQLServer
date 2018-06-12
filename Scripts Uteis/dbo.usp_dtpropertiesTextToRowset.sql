CREATE PROCEDURE dbo.usp_dtpropertiesTextToRowset @id int,
@RowsetCharLen int = 255

AS

-- Variable Declarations
------------------------
Declare @PointerToData varbinary (16)
Declare @TotalSize int
Declare @LastRead int
Declare @ReadSize int
Declare @ReturnCode int


-- Initializations
------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET @ReturnCode = -1


-- Establish the Pointer to the Image data
------------------------------------------
SELECT @PointerToData = TEXTPTR(lvalue),
@TotalSize = DATALENGTH(lvalue),
@LastRead = 0,
@ReadSize = CASE WHEN (@RowsetCharLen < DATALENGTH(lvalue))
THEN @RowsetCharLen

ELSE DATALENGTH(lvalue)
END
FROM dtproperties
WHERE id = @id


-- Loop through the image data, returning rows of the desired length
--------------------------------------------------------------------
IF (@PointerToData is not null) AND
(@ReadSize > 0)
WHILE (@LastRead < @TotalSize)
BEGIN
IF ((@ReadSize + @LastRead) > @TotalSize)
SET @ReadSize = @TotalSize - @LastRead
READTEXT dtproperties.lvalue @PointerToData @LastRead
@ReadSize
SET @LastRead = @LastRead + @ReadSize
END


-- Processing Complete
----------------------
SET @ReturnCode = 0



Procedure_Exit:
---------------
SET NOCOUNT OFF
RETURN @ReturnCode
GO
