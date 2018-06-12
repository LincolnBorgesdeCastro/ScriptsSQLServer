-- SCript para restaurar um database colocando seus arquivos em localização diferente da original
RESTORE DATABASE [DBPE01]
FROM  DISK = N'W:\Backup\DBPE01_BKP.BAK'
WITH  FILE = 2,
NOUNLOAD ,  STATS = 10,  RECOVERY ,
MOVE N'DBPE01_Log' TO N'Q:\Log\DBPE01_log.ldf',
MOVE N'DBPE01_Data' TO N'S:\DADOS\DBPE01.mdf'