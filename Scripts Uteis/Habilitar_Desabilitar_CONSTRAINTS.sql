--**************************************
--     
-- Name: Stored Procedure to Disable/Ree
--     nable All Constraints on a Given Table
-- Description:To be able to temporarily
--      disabled all foreign key and check cost
--     raints on a table to insert data that wo
--     uld otherwise not be insertable.
-- By: James Travis
--
-- Inputs:@TblName = the name of the tab
--     le to alter. @State = 0 to disable or do
--      not enter at all to reenable.
--
-- Assumes:WOrks with SQL 7 and above. D
--     oes not work with any previous version. 
--     Make sure once you have done the data en
--     try you wanted to do that you reenable t
--     he constraints or you leave your data ta
--     bles open to errors.
--
-- Side Effects:Turning of constraints a
--     llows entered data to break the otherwis
--     e controlling business logic of foreign 
--     key and check constraints until reeable 
--     is done.
--
--This code is copyrighted and has-- limited warranties.Please see http://
--     www.Planet-Source-Code.com/xq/ASP/txtCod
--     eId.303/lngWId.5/qx/vb/scripts/ShowCode.
--     htm--for details.--**************************************
--     

CREATE PROCEDURE sp_ConstraintState
@TblName	VARCHAR(128),
@State 		BIT = 1
AS
DECLARE @SQLState VARCHAR(500)
IF @State = 0
	BEGIN
		SET @SQLState = 'ALTER TABLE [' + @TblName + '] NOCHECK CONSTRAINT ALL'
	END
ELSE
	BEGIN
		SET @SQLState = 'ALTER TABLE [' + @TblName + '] CHECK CONSTRAINT ALL'
	END
EXEC (@SQLState)
