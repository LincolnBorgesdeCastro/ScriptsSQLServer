USE IPASGO
GO

if OBJECT_ID('tempDB..#LogDeletes') is not null drop table #LogDeletes

SELECT
     Lsn = [Current LSN]
    ,Operation
    ,Context
    ,AllocUnitId
    ,Registro = [RowLog Contents 0]
INTO
    #LogDeletes
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'\\catar\Backup_BD\SQL_BKP\AUSTRALIA\LOG\IPASGO\bkp_IPASGO_Log_13-04-2020-1030.bak',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) T
WHERE
    AllocUnitId IN (
        SELECT
            AU.allocation_unit_id
        FROM
            sys.partitions P
            JOIN
            sys.allocation_units AU ON AU.container_id = P.hobt_id
        WHERE
            P.object_id = OBJECT_ID('dbo.gv_SituacoesCadCliente') AND P.index_id <= 1
    )
    AND
    Operation = 'LOP_DELETE_ROWS'
    AND
    Context  IN ('LCX_CLUSTERED','LCX_MARK_AS_GHOST')

	
Select Count(*) From #LogDeletes