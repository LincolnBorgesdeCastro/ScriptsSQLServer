CREATE VIEW vLocks
AS
SELECT  L.request_session_id AS SPID, 
        DB_NAME(L.resource_database_id) AS DatabaseName,
        O.Name AS LockedObjectName, 
        P.object_id AS LockedObjectId, 
        L.resource_type AS LockedResource, 
        L.request_mode AS LockType,
        ST.text AS SqlStatementText,        
        ES.login_name AS LoginName,
        ES.host_name AS HostName,
        TST.is_user_transaction AS IsUserTransaction,
        AT.name AS TransactionName    
FROM    sys.dm_tran_locks L
        LEFT JOIN sys.partitions P ON P.hobt_id = L.resource_associated_entity_id
        LEFT JOIN sys.objects O ON O.object_id = P.object_id
        LEFT JOIN sys.dm_exec_sessions ES ON ES.session_id = L.request_session_id
        LEFT JOIN sys.dm_tran_session_transactions TST ON ES.session_id = TST.session_id
        LEFT JOIN sys.dm_tran_active_transactions AT ON TST.transaction_id = AT.transaction_id
        LEFT JOIN sys.dm_exec_requests ER ON AT.transaction_id = ER.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(ER.sql_handle) AS ST
WHERE   resource_database_id = db_id() 
GO
Next we have to create our stored procedure template:

CREATE PROC <ProcedureName>
AS
  BEGIN TRAN
    BEGIN TRY 

      <SPROC TEXT GOES HERE>

    COMMIT
  END TRY
  BEGIN CATCH
    -- check transaction state
    IF XACT_STATE() = -1
    BEGIN
      DECLARE @message xml
      -- get our deadlock info FROM the VIEW
      SET @message = '<TransactionLocks>' + (SELECT * FROM vLocks ORDER BY SPID FOR XML PATH('TransactionLock')) + '</TransactionLocks>'

      -- issue ROLLBACK so we don't ROLLBACK mail sending
      ROLLBACK

      -- get our error message and number
      DECLARE @ErrorNumber INT, @ErrorMessage NVARCHAR(2048)
      SELECT @ErrorNumber = ERROR_NUMBER(), @ErrorMessage = ERROR_MESSAGE()

      -- if it's deadlock error send mail notification
      IF @ErrorNumber = 1205
      BEGIN
        DECLARE @MailBody NVARCHAR(max)
        -- create out mail body in the xml format. you can change this to your liking.
        SELECT  @MailBody = '<DeadlockNotification>' 
                            +  
                            (SELECT 'Error number: ' + isnull(CAST(@ErrorNumber AS VARCHAR(5)), '-1') + CHAR(10) +
                                    'Error message: ' + isnull(@ErrorMessage, ' NO error message') + CHAR(10)
                             FOR XML PATH('ErrorMeassage')) 
                            + 
                            CAST(ISNULL(@message, '') AS NVARCHAR(MAX)) 
                            + 
                            '</DeadlockNotification>'
        -- for testing purposes
        -- SELECT CAST(@MailBody AS XML)

        -- send an email with the defined email profile. 
        -- since this is async it doesn't halt execution
        EXEC msdb.dbo.sp_send_dbmail 
                       @profile_name = 'your mail profile',
                       @recipients = 'dba@yourCompany.com',
                       @subject = 'Deadlock occured notification',
                       @body = @MailBody;
      END
    END
  END CATCH
GO