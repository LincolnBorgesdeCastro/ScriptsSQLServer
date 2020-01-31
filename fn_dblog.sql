Use IPASGO

SELECT
[Current LSN],
[Transaction ID],
[Operation],
[Transaction Name],
[CONTEXT],
[AllocUnitName],
[Page ID],
[Slot ID],
[Begin Time],
[End Time],
[Number of Locks],
[Lock Information]
FROM sys.fn_dblog(NULL,NULL)
WHERE Operation IN
('LOP_INSERT_ROWS','LOP_MODIFY_ROW',
'LOP_DELETE_ROWS','LOP_BEGIN_XACT','LOP_COMMIT_XACT')
ORDER BY [Begin Time] DESC

