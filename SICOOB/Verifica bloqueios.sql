/* Verifica bloqueios */
sp_listabloqueio


SELECT DISTINCT 'KILL ''' + CONVERT(VARCHAR(100), request_owner_guid) + '''' Eliminar, request_owner_guid, request_session_id, transaction_begin_time
FROM sys.dm_tran_locks tl
    INNER JOIN sys.dm_tran_active_transactions at
        ON tl.request_owner_guid = at.transaction_uow
WHERE request_session_id = -2
    AND DATEDIFF(MINUTE, transaction_begin_time, GETDATE()) > 1


dbcc inputbuffer (5303)
WITH NO_INFOMSGS

