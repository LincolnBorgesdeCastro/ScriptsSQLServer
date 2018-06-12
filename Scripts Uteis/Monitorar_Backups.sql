/* Script to find last full and TL backups location, time and size.*/

-- Collecting Full Backup Details

SELECT BS.database_name as 'Databases', BS.backup_finish_date as 'Backuptakenat', 
	BMF.physical_device_name as 'FullBackupLocation',
	convert(int,round (BS.backup_size/(1024*1024),0)) as 'BackupSize' 
 INTO #FullBack	
	  FROM	msdb..backupmediafamily BMF
	 JOIN msdb..backupmediaset BMS ON BMF.media_set_id = BMS.media_set_id
	  JOIN msdb.dbo.backupset BS ON BS.media_set_id = BMS.media_set_id
 	JOIN master.dbo.sysdatabases SDB ON SDB.name = BS.database_name
	  WHERE BS.backup_set_id = (SELECT MAX(SBS.backup_set_id) FROM  msdb.dbo.backupset SBS
				WHERE SBS.database_name = BS.database_name AND SBS.type = 'D' 
				and SBS.database_name not in ('Northwind','pubs','tempdb'))
		 
-- Collecting TL Backup details

SELECT BS.database_name as 'Databases', BS.backup_finish_date as 'TransactionLogbackedat', 
	BMF.physical_device_name as 'TLBackupLocation'
 INTO #TLBack	
	  FROM	msdb..backupmediafamily BMF
	 JOIN msdb..backupmediaset BMS ON BMF.media_set_id = BMS.media_set_id
	  JOIN msdb.dbo.backupset BS ON BS.media_set_id = BMS.media_set_id
 	JOIN master.dbo.sysdatabases SDB ON SDB.name = BS.database_name
	  WHERE BS.backup_set_id = (SELECT MAX(SBS.backup_set_id) FROM  msdb.dbo.backupset SBS
				WHERE SBS.database_name = BS.database_name AND SBS.type = 'L' 
				and SBS.database_name not in ('Northwind','pubs','tempdb'))

-- Join the tables

SELECT FB.Databases as 'Database Name', FB.FullBackupLocation as 'Last Full Backup Location', 
FB.BackupSize as 'Backup Size (MB)', FB.Backuptakenat as 'Last Full Backup Time',
TB.TLBackupLocation as 'TL Backup Location', TB.TransactionLogbackedat as 'Last TL Backup Time' 
FROM #FullBack FB LEFT OUTER JOIN #TLBack TB 
ON FB.Databases = TB.Databases ORDER BY FB.Databases

-- Deleting temporary tables

DROP TABLE #FullBack
DROP TABLE #TLBack