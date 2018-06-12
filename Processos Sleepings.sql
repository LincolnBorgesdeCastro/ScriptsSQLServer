DECLARE @DESC_Comando VARCHAR(30)
DECLARE curProcessos CURSOR 

FOR
Select DESC_Comando = 'KILL ' + CAST(session_id AS VARCHAR)  
from sys.dm_exec_sessions
where status = 'sleeping'
and program_name IN ('Microsoft SQL Server Management Studio - Query', 'dbForge SQL Complete Express', 'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense')
and login_name not in ('IPASGO\Cluster', 'IPASGO\81084056199', 'USR_AIES', 'USR_PENTAHO', 'USR_SIMM', 'USR_SIGC', 'guest')
and open_transaction_count=0 
and login_name not like 'IPASGO\%'
and last_request_end_time < dateadd(mi,-15,getdate())

OPEN curProcessos

FETCH NEXT FROM curProcessos INTO @DESC_Comando

WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE (@DESC_Comando)
		FETCH NEXT FROM curProcessos INTO @DESC_Comando
	END

CLOSE curProcessos
DEALLOCATE curProcessos