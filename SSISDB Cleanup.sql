--With thanks to Bill Fellows for the script from here:
-- http://stackoverflow.com/questions/21781351/how-can-i-clean-up-the-ssisdb

USE SSISDB;

SET nocount ON;

IF Object_id('tempdb..#DELETE_CANDIDATES') IS NOT NULL
  BEGIN
      DROP TABLE #delete_candidates;
  END;

CREATE TABLE #delete_candidates
  (
     operation_id BIGINT NOT NULL PRIMARY KEY
  );

--Adjust accordingly. If you've been set at the default of 365 days, you probably want to start close to that upper limit.
--Adjust downward in appropriate increments for your environment. 10-20 at a time is usually a good start.
DECLARE @DaysRetention INT = 350;

INSERT INTO #delete_candidates
            (operation_id)
SELECT IO.operation_id
FROM   internal.operations AS IO
WHERE  IO.start_time < Dateadd(day, -@DaysRetention, CURRENT_TIMESTAMP);



WHILE EXISTS (SELECT * FROM internal.event_message_context AS emc JOIN #delete_candidates AS dc ON dc.operation_id = emc.operation_id)
BEGIN -- delete event_message_context
DELETE TOP(4500) T
FROM   internal.event_message_context AS T
       INNER JOIN #delete_candidates AS DC
               ON DC.operation_id = T.operation_id;
CHECKPOINT
END -- delete event_message_context

WHILE EXISTS (SELECT * FROM internal.event_messages AS e JOIN #delete_candidates AS dc ON dc.operation_id = e.operation_id)
BEGIN --Delete event_messages
DELETE TOP(4500) T
FROM   internal.event_messages AS T
       INNER JOIN #delete_candidates AS DC
               ON DC.operation_id = T.operation_id;
CHECKPOINT
END --Delete event_messages

WHILE EXISTS (SELECT * FROM internal.operation_messages AS o JOIN #delete_candidates AS dc ON dc.operation_id = o.operation_id)
BEGIN --Delete operation_messages
DELETE TOP(4500) T
FROM   internal.operation_messages AS T
       INNER JOIN #delete_candidates AS DC
               ON DC.operation_id = T.operation_id;
CHECKPOINT
END --Delete operation_messages

--etc
--Finally, remove the entry from operations
DELETE T
FROM   internal.operations AS T
       INNER JOIN #delete_candidates AS DC
               ON DC.operation_id = T.operation_id;
GO
CHECKPOINT
GO


/*
--https://blog.sqlauthority.com/2018/11/24/sql-server-huge-size-of-ssisdb-catalog-database-ssisdb-cleanup-script/
USE SSISDB
GO
delete from [internal].[executions] 
GO
delete from [internal].[executable_statistics]
GO
delete from [internal].[execution_component_phases] 
GO
delete from [internal].[execution_data_statistics] 
GO
delete from [internal].[execution_data_taps] 
GO
delete from [internal].[execution_parameter_values]
GO
delete from [internal].[execution_property_override_values]
GO
delete from [internal].[extended_operation_info]
GO
delete from [internal].[operation_messages]
GO
delete from [internal].[event_messages]
GO
delete from [internal].[event_message_context]
GO
delete from [internal].[operation_os_sys_info]
GO
delete from [internal].[operation_permissions]
GO
delete from [internal].[validations]
GO



EXEC SSISDB.internal.cleanup_server_log
GO
EXEC SSISDB.catalog.configure_catalog @property_name='SERVER_OPERATION_ENCRYPTION_LEVEL', @property_value='2'
GO
ALTER DATABASE SSISDB SET MULTI_USER
GO
EXEC SSISDB.internal.Cleanup_Server_execution_keys @cleanup_flag = 1
GO


*/

