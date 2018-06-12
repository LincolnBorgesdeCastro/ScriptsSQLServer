CREATE PROCEDURE dbo.usp_ScriptDatabaseDiagrams @DiagramName varchar(128) = null
AS

-- Variable Declarations
------------------------
Declare @id int
Declare @objectid int
Declare @property varchar(64)
Declare @value varchar (255)
Declare @uvalue varchar (255)
Declare @lvaluePresent bit
Declare @version int
Declare @PointerToData varbinary (16)
Declare @ImageRowByteCount int
Declare @CharData varchar (8000)
Declare @DiagramDataFetchStatus int
Declare @CharDataFetchStatus int
Declare @Offset int
Declare @LastObjectid int
Declare @NextObjectid int
Declare @ReturnCode int


-- Initializations
------------------
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET @ReturnCode = -1
SET @ImageRowByteCount = 40
SET @LastObjectid = -1
SET @NextObjectid = -1


-- Temp Table Creation for transforming Image Data into a text (hex) format
---------------------------------------------------------------------------
CREATE TABLE #ImageData (KeyValue int NOT NULL IDENTITY (1, 1),
DataField varbinary(8000) NULL) ON [PRIMARY]

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO CREATE TABLE
#ImageData'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END

ALTER TABLE #ImageData ADD CONSTRAINT
PK_ImageData PRIMARY KEY CLUSTERED
(KeyValue) ON [PRIMARY]

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO Index TABLE
#ImageData'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END



-- Output Script Header Documentation
-------------------------------------
PRINT '------------------------------------------------------------------------'
PRINT '-- Database Diagram Reconstruction Script'
PRINT '------------------------------------------------------------------------'
PRINT '-- Created on: ' + Convert(varchar(23), GetDate(), 121)
PRINT '-- From Database: ' + DB_NAME()
PRINT '-- By User: ' + USER_NAME()
PRINT '--'
PRINT '-- This SQL Script was designed to reconstruct a set of
database'
PRINT '-- diagrams, by repopulating the system table dtproperties, in
the'
PRINT '-- current database, with values which existed at the time
this'
PRINT '-- script was created. Typically, this script would be created
to'
PRINT '-- backup a set of database diagrams, or to package up those
diagrams'
PRINT '-- for deployment to another database.'
PRINT '--'
PRINT '-- Minimally, all that needs to be done to recreate the target'
PRINT '-- diagrams is to run this script. There are several options,'
PRINT '-- however, which may be modified, to customize the diagrams to
be'
PRINT '-- produced. Changing these options is as simple as modifying
the'
PRINT '-- initial values for a set of variables, which are defined
immediately'
PRINT '-- following these comments. They are:'
PRINT '--'
PRINT '-- Variable Name Description'
PRINT '-- -----------------------
---------------------------------------------'
PRINT '-- @TargetDatabase This varchar variable will establish
the'
PRINT '-- target database, within which the
diagrams'
PRINT '-- will be reconstructed. This variable
is'
PRINT '-- initially set to database name from
which the'
PRINT '-- script was built, but it may be
modified as'
PRINT '-- required. A valid database name
must be'
PRINT '-- specified.'
PRINT '--'
PRINT '-- @DropExistingDiagrams This bit variable is initially set
set to a'
PRINT '-- value of zero (0), which indicates
that any'
PRINT '-- existing diagrams in the target
database are'
PRINT '-- to be preserved. By setting this
value to'
PRINT '-- one (1), any existing diagrams in
the target'
PRINT '-- database will be dropped prior to'
PRINT '-- reconstruction. Zero and One are the
only'
PRINT '-- valid values for the variable.'
PRINT '--'
PRINT '-- @DiagramSuffix This varchar variable will be used
to append'
PRINT '-- to the original diagram names, as
they'
PRINT '-- existed at the time they were
scripted. This'
PRINT '-- variable is initially set to take on
the'
PRINT '-- value of the current date/time,
although it'
PRINT '-- may be modified as required. An
empty string'
PRINT '-- value would effectively turn off the
diagram'
PRINT '-- suffix option.'
PRINT '--'
PRINT '------------------------------------------------------------------------'
PRINT ''
PRINT 'SET NOCOUNT ON'
PRINT ''
PRINT '-- User Settable Options'
PRINT '------------------------'
PRINT 'Declare @TargetDatabase varchar (128)'
PRINT 'Declare @DropExistingDiagrams bit'
PRINT 'Declare @DiagramSuffix varchar (50)'
PRINT ''
PRINT '-- Initialize User Settable Options'
PRINT '-----------------------------------'
PRINT 'SET @TargetDatabase = ''Payment'''
PRINT 'SET @DropExistingDiagrams = 0'
PRINT 'SET @DiagramSuffix = '' '' + Convert(varchar(23), GetDate(),
121)'
PRINT ''
PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '-- END OF USER MODIFIABLE SECTION - MAKE NO CHANGES TO THE
LOGIC BELOW --'
PRINT '-------------------------------------------------------------------------'
PRINT ''
PRINT ''
PRINT '-- Setting Target database and clearing dtproperties, if
indicated'
PRINT '------------------------------------------------------------------'
PRINT 'Exec(''USE '' + @TargetDatabase)'
PRINT 'IF (@DropExistingDiagrams = 1)'
PRINT ' TRUNCATE TABLE dtproperties'
PRINT ''
PRINT ''
PRINT '-- Creating Temp Table to persist specific variables '
PRINT '-- between Transact SQL batches (between GO statements)'
PRINT '-------------------------------------------------------'
PRINT 'IF EXISTS(SELECT 1'
PRINT ' FROM tempdb..sysobjects'
PRINT ' WHERE name like ''%#PersistedVariables%'''
PRINT ' AND xtype = ''U'')'
PRINT ' DROP TABLE #PersistedVariables'
PRINT 'CREATE TABLE #PersistedVariables (VariableName varchar (50)
NOT NULL,'
PRINT ' VariableValue varchar (50)
NOT NULL) ON [PRIMARY]'
PRINT 'ALTER TABLE #PersistedVariables ADD CONSTRAINT'
PRINT ' PK_PersistedVariables PRIMARY KEY CLUSTERED '
PRINT ' (VariableName) ON [PRIMARY]'
PRINT ''
PRINT ''
PRINT '-- Persist @DiagramSuffix'
PRINT '-------------------------'
PRINT 'INSERT INTO #PersistedVariables VALUES (''DiagramSuffix'','
PRINT ' @DiagramSuffix)'
PRINT 'GO'
PRINT ''


-- Cusror to be used to enumerate through each row of
-- diagram data from the table dtproperties
-----------------------------------------------------
Declare DiagramDataCursor Cursor
FOR SELECT dtproperties.id,
dtproperties.objectid,
dtproperties.property,
dtproperties.value,
dtproperties.uvalue,
CASE WHEN (dtproperties.lvalue is Null) THEN 0
ELSE 1
END,
dtproperties.version
FROM dtproperties INNER JOIN (SELECT objectid
FROM dtproperties
WHERE property = 'DtgSchemaNAME'
AND value =
IsNull(@DiagramName, value)) TargetObject
ON dtproperties.objectid =
TargetObject.objectid
ORDER BY dtproperties.id,
dtproperties.objectid

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO DECLARE CURSOR
DiagramDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END

-- Cusror to be used to enumerate through each row of
-- varchar data from the temp table #ImageData
-----------------------------------------------------
Declare CharDataCursor Cursor
FOR SELECT '0x'+Payment.dbo.ufn_VarbinaryToVarcharHex(DataField)
FROM #ImageData
ORDER BY KeyValue

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO DECLARE CURSOR
CharDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END


-- Open the DiagramDataCursor cursor
------------------------------------
OPEN DiagramDataCursor

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO OPEN CURSOR
DiagramDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END


-- Get the Row of Diagram data
------------------------------
FETCH NEXT FROM DiagramDataCursor
INTO @id,
@objectid,
@property,
@value,
@uvalue,
@lvaluePresent,
@version

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO FETCH NEXT FROM
CURSOR DiagramDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END


-- Initialize the Fetch Status for the DiagramDataCursor cursor
---------------------------------------------------------------
SET @DiagramDataFetchStatus = @@FETCH_STATUS

-- Check for an unexpected error
--------------------------------
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO SET
@DiagramDataFetchStatus'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END


-- Begin the processing each Row of Diagram data
------------------------------------------------
WHILE (@DiagramDataFetchStatus = 0)
BEGIN
-- Build an Insert statement for non-image data
PRINT ''
PRINT '-- Insert a new dtproperties row'
PRINT '--------------------------------'
IF (@LastObjectid <> @objectid)
BEGIN
-- Retrieve the persisted DiagramSuffix - If processing DtgSchemaNAME
IF (@property = 'DtgSchemaNAME')
BEGIN
PRINT 'Declare @DiagramSuffix varchar (50)'
PRINT 'SELECT @DiagramSuffix = Convert(varchar
(50), VariableValue)'
PRINT 'FROM #PersistedVariables'
PRINT 'WHERE VariableName = ''DiagramSuffix'''
END
-- Build the Insert statement for a New Diagram - Apply and Persist the new Objectid
PRINT 'INSERT INTO dtproperties (objectid,'
PRINT ' property,'
PRINT ' value,'
PRINT ' uvalue,'
PRINT ' lvalue,'
PRINT ' version)'
PRINT ' VALUES (0,'
PRINT ' ''' + @property +
''','
PRINT ' ' + CASE WHEN
(@property = 'DtgSchemaNAME')
THEN
IsNull(('''' + @value + ''' + @DiagramSuffix,'), 'null,')
ELSE
IsNull(('''' + @value + ''','), 'null,')
END
PRINT ' ' + CASE WHEN
(@property = 'DtgSchemaNAME')
THEN
IsNull(('''' + @uvalue + '''+ @DiagramSuffix,'), 'null,')
ELSE
IsNull(('''' + @uvalue + ''','), 'null,')
END
PRINT ' ' + CASE WHEN
(@lvaluePresent = 1)
THEN
'cast(''0'' as varbinary(10)),'
ELSE
'null,'
END
PRINT ' ' +
IsNull(Convert(varchar(15), @version), 'null') + ')'
PRINT 'DELETE #PersistedVariables'
PRINT 'WHERE VariableName = ''NextObjectid'''
PRINT 'INSERT INTO #PersistedVariables VALUES
(''NextObjectid'','
PRINT '
Convert(varchar(15), @@IDENTITY))'
PRINT 'Declare @NextObjectid int'
PRINT 'SELECT @NextObjectid = Convert(int,
VariableValue)'
PRINT 'FROM #PersistedVariables'
PRINT 'WHERE VariableName = ''NextObjectid'''
PRINT 'UPDATE dtproperties'
PRINT ' SET Objectid = @NextObjectid'
PRINT 'WHERE id = @NextObjectid'
SET @LastObjectid = @objectid
END
ELSE
BEGIN
-- Retrieve the persisted DiagramSuffix - If processing DtgSchemaNAME
IF (@property = 'DtgSchemaNAME')
BEGIN
PRINT 'Declare @DiagramSuffix varchar (50)'
PRINT 'SELECT @DiagramSuffix = Convert(varchar
(50), VariableValue)'
PRINT 'FROM #PersistedVariables'
PRINT 'WHERE VariableName = ''DiagramSuffix'''
END
-- Build the Insert statement for an in process Diagram - Retrieve the persisted Objectid
PRINT 'Declare @NextObjectid int'
PRINT 'SELECT @NextObjectid = Convert(int,
VariableValue)'
PRINT 'FROM #PersistedVariables'
PRINT 'WHERE VariableName = ''NextObjectid'''
PRINT 'INSERT INTO dtproperties (objectid,'
PRINT ' property,'
PRINT ' value,'
PRINT ' uvalue,'
PRINT ' lvalue,'
PRINT ' version)'
PRINT ' VALUES (@NextObjectid,'
PRINT ' ''' + @property +
''','
PRINT ' ' + CASE WHEN
(@property = 'DtgSchemaNAME')
THEN
IsNull(('''' + @value + ''' + @DiagramSuffix,'), 'null,')
ELSE
IsNull(('''' + @value + ''','), 'null,')
END
PRINT ' ' + CASE WHEN
(@property = 'DtgSchemaNAME')
THEN
IsNull(('''' + @uvalue + '''+ @DiagramSuffix,'), 'null,')
ELSE
IsNull(('''' + @uvalue + ''','), 'null,')
END
PRINT ' ' + CASE WHEN
(@lvaluePresent = 1)
THEN
'cast(''0'' as varbinary(10)),'
ELSE
'null,'
END
PRINT ' ' +
IsNull(Convert(varchar(15), @version), 'null') + ')'
END
-- Each Insert deliniates a new Transact SQL batch
PRINT 'GO'

-- Check for a non-null lvalue (image data is present)
IF (@lvaluePresent = 1)
BEGIN
-- Fill the temp table with Image Data of length @ImageRowByteCount
INSERT INTO #ImageData (DataField)
EXEC usp_dtpropertiesTextToRowset @id,
@ImageRowByteCount
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
INSERT INTO #ImageData'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Prepare to build the UPDATETEXT statement(s) for the image data
SET @Offset = 0
-- Open the CharDataCursor cursor
OPEN CharDataCursor
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
OPEN CURSOR CharDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Get the CharData Row
FETCH NEXT FROM CharDataCursor
INTO @CharData
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
FETCH NEXT FROM CURSOR CharDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Initialize the Fetch Status for the CharDataCursor cursor
SET @CharDataFetchStatus = @@FETCH_STATUS
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
SET @CharDataFetchStatus'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Begin the processing of each Row of Char data
WHILE (@CharDataFetchStatus = 0)
BEGIN
-- Update a segment of image data
PRINT ''
PRINT '-- Update this dtproperties row with a
new segment of Image data'
PRINT 'Declare @PointerToData varbinary (16)'
PRINT 'SELECT @PointerToData = TEXTPTR(lvalue)
FROM dtproperties WHERE id = (SELECT MAX(id) FROM dtproperties)'
PRINT 'UPDATETEXT dtproperties.lvalue
@PointerToData ' + convert(varchar(15), @Offset) + ' null ' +
@CharData
-- Each UPDATETEXT deliniates a new Transact SQL batch
PRINT 'GO'
-- Calculate the Offset for the next segment of image data
SET @Offset = @Offset + ((LEN(@CharData) - 2)
/ 2)
-- Get the CharData Row
FETCH NEXT FROM CharDataCursor
INTO @CharData
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE
ATTEMPTING TO FETCH NEXT FROM CURSOR CharDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Update the Fetch Status for the CharDataCursor cursor
SET @CharDataFetchStatus = @@FETCH_STATUS
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE
ATTEMPTING TO SET @CharDataFetchStatus'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
END
-- Cleanup CharDataCursor Cursor resources
Close CharDataCursor
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
CLOSE CURSOR CharDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Flush the processed Image data
TRUNCATE TABLE #ImageData
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO
TRUNCATE TABLE #ImageData'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
END
-- Get the Row of Diagram data
FETCH NEXT FROM DiagramDataCursor
INTO @id,
@objectid,
@property,
@value,
@uvalue,
@lvaluePresent,
@version
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO FETCH
NEXT FROM CURSOR DiagramDataCursor'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
-- Update the Fetch Status for the DiagramDataCursor cursor
SET @DiagramDataFetchStatus = @@FETCH_STATUS
-- Check for an unexpected error
IF (@@error != 0)
BEGIN
PRINT ''
PRINT '***'
PRINT '*** ERROR OCCURRED WHILE ATTEMPTING TO SET
@DiagramDataFetchStatus'
PRINT '***'
PRINT ''
GOTO Procedure_Exit
END
END

PRINT ''
PRINT '-- Cleanup the temp table #PersistedVariables'
PRINT '---------------------------------------------'
PRINT 'IF EXISTS(SELECT 1'
PRINT ' FROM tempdb..sysobjects'
PRINT ' WHERE name like ''%#PersistedVariables%'''
PRINT ' AND xtype = ''U'')'
PRINT ' DROP TABLE #PersistedVariables'
PRINT 'GO'
PRINT ''
PRINT 'SET NOCOUNT OFF'
PRINT 'GO'

-- Processing Complete
----------------------
SET @ReturnCode = 0


Procedure_Exit:
---------------
Close DiagramDataCursor
DEALLOCATE DiagramDataCursor
DEALLOCATE CharDataCursor
DROP TABLE #ImageData
SET NOCOUNT OFF
RETURN @ReturnCode
GO

GRANT EXECUTE ON [dbo].[usp_ScriptDatabaseDiagrams] TO [Public]
GO
