-- ---------------------------------------------------------------------------------------
-- Written by Kimberly L. Tripp - all rights reserved.
-- 
-- For more scripts, sample code and Kimberly's schedule check out www.SQLSkills.com
-- For "More than Just Training," see the Industry Experts at www.SolidQualityLearning.com
--
-- Disclaimer - Thoroughly test this script, execute at your own risk.
-- ---------------------------------------------------------------------------------------

-- Execute this whole script to create the sp_RebuildIndexes stored procedure in Master.
-- Best Viewed with Courier New 12pt. and Tabs saved as 4 spaces not 8. (Tools, Options, Editor)

-- To use the sp_RebuildIndexes procedure once created use:
-- sp_RebuildIndexes 
--		To Rebuild All Indexes on All Tables for all that have a Scan Density < 100%
-- sp_RebuildIndexes @ScanDensity = 80
--		To Rebuild All Indexes on All Tables with a Scan Density of < 80%
-- sp_RebuildIndexes 'Authors'
--		To Rebuild All Indexes on the authors table - for a Scan Density of < 100%
-- sp_RebuildIndexes 'Authors', 80
--		To Rebuild All Indexes on the authors table - for a Scan Density of < 80%
-- Object Name and ScanDensity are both optional parameters. 
-- ScanDensity must be a whole number between 1 and 100.

USE master
go
IF OBJECTPROPERTY(object_id('sp_RebuildClusteredIndex'), 'IsProcedure') = 1
	DROP PROCEDURE sp_RebuildClusteredIndex
go

IF OBJECTPROPERTY(object_id('sp_RebuildIndexes'), 'IsProcedure') = 1
	DROP PROCEDURE sp_RebuildIndexes
go

CREATE PROCEDURE sp_RebuildClusteredIndex
(
	@TableName		sysname		= NULL,
	@IndexName		sysname		= NULL
)		
AS
-- Written by Kimberly L. Tripp of SYSolutions, Inc.
-- For more code samples go to http://www.sqlskills.com
-- NOTE: If your clustered index is NOT unique then rebuilding the clustered
-- index will cause the non-clustered indexes to be rebuilt. If the nonclustered
-- indexes were fragmented then this series of scripts will build them again.
IF @TableName IS NOT NULL
	BEGIN
		IF (OBJECTPROPERTY(object_id(@TableName), 'IsUserTable') = 0 
				AND OBJECTPROPERTY(object_id(@TableName), 'IsView') = 0) 
			BEGIN
				RAISERROR('Object: %s exists but is NOT a User-defined Table. This procedure only accepts valid table names to process for index rebuilds.', 16, 1, @TableName)
				RETURN
			END
		ELSE
			BEGIN
				IF OBJECTPROPERTY(object_id(@TableName), 'IsTable') IS NULL
					BEGIN
						RAISERROR('Object: %s does not exist within this database. Please check the table name and location (which database?). This procedure only accepts existing table names to process for index rebuilds.', 16, 1, @TableName)
						RETURN
					END
			END
    END

IF @IndexName IS NOT NULL
	BEGIN
		IF INDEXPROPERTY(object_id(@TableName), @IndexName, 'IsClustered') = 0
			BEGIN
				RAISERROR('Index: %s exists but is a Clustered Index. This procedure only accepts valid table names and their clustered indexes for rebuilds.', 16, 1, @IndexName)
				RETURN
			END
		ELSE
			BEGIN
				IF INDEXPROPERTY(object_id(@TableName), @IndexName, 'IsClustered') IS NULL
					BEGIN
						SELECT @TableName, @IndexName, INDEXPROPERTY(object_id(@TableName), @IndexName, 'IsClustered')
						RAISERROR('There is no index with name:%s on this table. Please check the table name and index name as well as location (which database?). This procedure only accepts existing table names and their clustered indexes for rebuilds.', 16, 1, @IndexName)
						RETURN
					END
			END
    END

-- So now we have a valid table, a valid CLUSTERED index and we're ready to rebuild.
	-- Here's a quick overview of what this code will do:
		-- Get the Column List and Index Defintion (Use the output from sp_helpindex)
		-- Figure out if it's UNIQUE - to specify in CREATE INDEX statement
		-- Build and Execute the CREATE INDEX command through dynamic string execution

DECLARE @ExecStr		nvarchar(4000) -- more than enough even if 16 cols of 128 chars, 
									   -- Tablename of 128 and Indexname of 128...
									   -- but if this is the case you have other problems :).
		, @ColList		nvarchar(3000)
		, @Unique		nvarchar(7)	   -- Will be either '' or 'Unique ' and added to CR Index String
		, @FillFactor	nvarchar(100)

CREATE TABLE #IndexInfo
(
	IndexName	sysname,
	IndexDesc	varchar(210),
	IndexKeys	nvarchar(2126)
)

INSERT INTO #IndexInfo 
	EXEC sp_helpindex @TableName

SELECT @ColList = IndexKeys
		 , @Unique = CASE 
						WHEN IndexDesc LIKE 'clustered, unique%' 
							THEN 'Unique '
						ELSE ''
					END --CASE Expression
		 , @FillFactor = ', FILLFACTOR = ' + NULLIF(convert(nvarchar(3), 
						(SELECT OrigFillFactor 
							FROM sysindexes 
							WHERE id = object_id(@TableName) 
								AND Name = @IndexName)), 0)
FROM #IndexInfo
WHERE IndexName = @IndexName

SELECT @ExecStr = 'CREATE ' + @Unique + 'CLUSTERED INDEX ' 
						+ QUOTENAME(@IndexName, ']') + ' ON ' 
						+ QUOTENAME(@TableName, ']') + '(' + @collist 
						+ ') WITH DROP_EXISTING ' + ISNULL(@FillFactor, '')
-- For testing the String
-- SELECT @ExecStr

-- Create the Clustered Index
EXEC(@ExecStr)
go

CREATE PROCEDURE sp_RebuildIndexes
(
	@TableName		sysname		= NULL,
	@ScanDensity 	tinyint		= 100
)
AS
-- Written by Kimberly L. Tripp of SYSolutions, Inc.
-- For more code samples go to http://www.sqlskills.com
--
-- This procedure will get the Fragmentation information
-- for all tables and indexes within the database. 
-- Programmatically it will then walk the list rebuilding all
-- indexes that have a scan density less than the value 
-- passed in - by default any less than 100% contiguous.
-- 
-- Use this script as a starting point. Modify it for your
-- options, ideas, etc. - and then schedule it to run regularly.
-- 
-- NOTE - This gathers density information for all tables 
-- and all indexes. This might be time consuming on large
-- databases. 
-- 
-- DISCLAIMER - Execute at your own risk. TEST THIS FIRST. 
SET NOCOUNT ON

IF @ScanDensity IS NULL
	SET @ScanDensity = 100
 
IF @ScanDensity NOT BETWEEN 1 AND 100
	BEGIN
		RAISERROR('Value supplied:%i is not valid. @ScanDensity is a percentage. Please supply a value for Scan Density between 1 and 100.', 16, 1, @ScanDensity)
		RETURN
	END
IF @TableName IS NOT NULL
	BEGIN
		IF OBJECTPROPERTY(object_id(@TableName), 'IsUserTable') = 0 
			BEGIN
				RAISERROR('Object: %s exists but is NOT a User-defined Table. This procedure only accepts valid table names to process for index rebuilds.', 16, 1, @TableName)
				RETURN
			END
		ELSE
			BEGIN
				IF OBJECTPROPERTY(object_id(@TableName), 'IsTable') IS NULL
					BEGIN
						RAISERROR('Object: %s does not exist within this database. Please check the table name and location (which database?). This procedure only accepts existing table names to process for index rebuilds.', 16, 1, @TableName)
						RETURN
					END
			END
    END

-- Otherwise the Object Exists and it is a table so we'll continue from here. 
-- First thing to do is create a temp location for the data returned from DBCC SHOWCONTIG

CREATE TABLE #ShowContigOutput
(
	ObjectName			sysname,
	ObjectId				int,
	IndexName				sysname,
	IndexId					tinyint,
	[Level]					tinyint,
	Pages					int,
	[Rows]					bigint,
	MinimumRecordSize		smallint,
	MaximumRecordSize	smallint,
	AverageRecordSize		smallint,
	ForwardedRecords		bigint,
	Extents					int,
	ExtentSwitches			numeric(10,2),
	AverageFreeBytes		numeric(10,2),
	AveragePageDensity	numeric(10,2),
	ScanDensity			numeric(10,2),
	BestCount				int,
	ActualCount			int,
	LogicalFragmentation	numeric(10,2),
	ExtentFragmentation	numeric(10,2)
)                            

IF @TableName IS NOT NULL -- then we only need the showcontig output for that table
	INSERT #ShowContigOutput
		EXEC('DBCC SHOWCONTIG (' + @TableName + ') WITH FAST, ALL_INDEXES, TABLERESULTS') 
ELSE -- All Tables, All Indexes Will be processed.
	INSERT #ShowContigOutput
		EXEC('DBCC SHOWCONTIG WITH FAST, ALL_INDEXES, TABLERESULTS') 
PRINT N' '

-- Quick test to see if everything is getting here correctly
-- SELECT * FROM #ShowContigOutput

-- Walk the showcontig output table skipping all replication tables as well as all tables necessary for
-- the UI. This is also where you can list large tables that you don't want to rebuild all at one time.
-- NOTE: If you take out a large table from rebuilding this script may have already checked density
-- meaning that the expense in terms of time may have been expensive.
-- Also, you should use a different procedure to rebuild a large table specifically. 
-- Even when you pass in the tablename it will be avoided here if MANUALLY added to the 
-- list by you. 
-- Test, Test, Test!

DECLARE @ObjectName				sysname,
			@IndexName			sysname,
			@QObjectName			nvarchar(258),
			@QIndexName			nvarchar(258),
			@IndexID				tinyint,
			@ActualScanDensity	numeric(10,2),
			@InformationalOutput	nvarchar(4000),
			@StartTime				datetime,
			@EndTime				datetime

DECLARE TableIndexList CURSOR FAST_FORWARD FOR 
	SELECT ObjectName, IndexName, IndexID, ScanDensity 
	FROM #ShowContigOutput AS sc
		JOIN sysobjects AS so ON sc.ObjectID = so.id
	WHERE sc.ScanDensity < @ScanDensity 
		AND (OBJECTPROPERTY(sc.ObjectID, 'IsUserTable') = 1 
				OR OBJECTPROPERTY(sc.ObjectID, 'IsView') = 1)
		AND so.STATUS > 0
		AND sc.IndexID BETWEEN 1 AND 250 
		AND sc.ObjectName NOT IN ('dtproperties') 
			-- Here you can list large tables you do not WANT rebuilt.
	ORDER BY sc.ObjectName, sc.IndexID

OPEN TableIndexList

FETCH NEXT FROM TableIndexList 
	INTO @ObjectName, @IndexName, @IndexID, @ActualScanDensity

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @QObjectName = QUOTENAME(@ObjectName, ']')
		SELECT @QIndexName = QUOTENAME(@IndexName, ']')
		SELECT @InformationalOutput = N'Processing Table: ' + RTRIM(UPPER(@QObjectName)) 
											+ N' Rebuilding Index: ' + RTRIM(UPPER(@QIndexName)) 
		PRINT @InformationalOutput
		IF @IndexID = 1 
		BEGIN
			SELECT @StartTime = getdate()
			EXEC sp_RebuildClusteredIndex @ObjectName, @IndexName
			SELECT @EndTime = getdate()
			SELECT @InformationalOutput = N'Total Time to process = ' + convert(nvarchar, datediff(ms, @StartTime, @EndTime)) + N' ms'
			PRINT @InformationalOutput 
		END
		ELSE
		BEGIN
			SELECT @StartTime = getdate()
			EXEC('DBCC DBREINDEX(' + @QObjectName + ', ' + @QIndexName + ') WITH NO_INFOMSGS')
			SELECT @EndTime = getdate()
			SELECT @InformationalOutput = N'Total Time to process = ' + convert(nvarchar, datediff(ms, @StartTime, @EndTime)) + N' ms'
			PRINT @InformationalOutput 
		END
		PRINT N' '
		FETCH NEXT FROM TableIndexList 
			INTO @ObjectName, @IndexName, @IndexID, @ActualScanDensity
	END
END
PRINT N' '
SELECT @InformationalOutput = N'***** All Indexes have been rebuilt.  ***** ' 
PRINT @InformationalOutput 
DEALLOCATE TableIndexList 
go

