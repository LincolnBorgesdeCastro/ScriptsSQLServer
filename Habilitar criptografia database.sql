--Será utilizado o certificado já criado anteriormente

USE SIGA
GO  

CREATE DATABASE ENCRYPTION KEY  WITH ALGORITHM = AES_128  
ENCRYPTION BY SERVER CERTIFICATE ctMaster;
GO  

ALTER DATABASE [SIGA] SET ENCRYPTION ON;  
GO  


/*

SELECT
[db].name,
[db].is_encrypted,
[dek].encryption_state,
CASE [dek].encryption_state
WHEN 0 THEN 'Not Encrypted'
WHEN 1 THEN 'Unencrypted'
WHEN 2 THEN 'Encryption in progress'
WHEN 3 THEN 'Encrypted'
WHEN 4 THEN 'Key change in progress'
WHEN 5 THEN 'Decryption in progress'
WHEN 6 THEN 'Protection change in progress '
ELSE 'Not Encrypted'
END AS 'Desc',
[dek].percent_complete
FROM sys.dm_database_encryption_keys [dek]
     RIGHT JOIN
     sys.databases [db] ON [dek].database_id = [db].database_id

where [db].database_id = db_id()
order by is_encrypted desc, encryption_state


-- Conexões encriptadas
select encrypt_option, * from sys.dm_exec_connections
order by session_id


-- Remover

USE OSMTD
GO  

DROP DATABASE ENCRYPTION KEY  
GO  

ALTER DATABASE ipasgo SET ENCRYPTION OFF;  
GO  


*/