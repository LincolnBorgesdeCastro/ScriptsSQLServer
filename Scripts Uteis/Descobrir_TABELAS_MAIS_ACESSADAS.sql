

/* Após o acesso através de comandos de leitura e gravação, vejamos o retorno da sys.dm_db_index_usage_stats. */

SELECT
OBJECT_NAME(object_id,database_id) As Tabela, Index_Id,
last_user_seek, last_user_scan, last_user_lookup, last_user_update
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID() And OBJECTPROPERTYEX(object_id,'IsUserTable') = 1
ORDER BY Tabela, Index_ID

/*****************************************************************************************************************/



/*Para descobrir o momento mais recente em que a tabela que foi acessada, basta olhar a operação sobre os índices que 
tem a maior data. Tal parte do script nos lista isso */

WITH Utilizacao (Tabela, Index_ID, Seek, Scan, LookUp, [Update])
As (
SELECT
OBJECT_NAME(object_id,database_id) As Tabela, Index_Id,
last_user_seek, last_user_scan, last_user_lookup, last_user_update
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID() And OBJECTPROPERTYEX(object_id,'IsUserTable') = 1)
SELECT * FROM Utilizacao
UNPIVOT
(DataReferencia FOR Operacao IN ([Seek], [Scan], [LookUp], [Update])) As UP
ORDER BY Tabela, Index_ID

/****************************************************************************/


/*

Uma vez que as colunas com as datas foram transformadas em linhas, é muito fácil aplicar a função MAX, 
para descobrir a última data de referência. Aproveitei para fazer alguns "ajustes" na consulta como mostrar a 
última operação bem como contemplar as tabelas que não possuem entradas na sys.dm_db_index_usage_stats.

*/

WITH Utilizacao (object_id, Index_ID, Seek, Scan, LookUp, [Update])
As (
SELECT
T.object_id, Index_Id,
last_user_seek, last_user_scan, last_user_lookup, last_user_update
FROM sys.dm_db_index_usage_stats As I
INNER JOIN sys.tables As T ON I.object_id = T.object_id
WHERE database_id = DB_ID()),
Referencias (object_id, DataReferencia, Operacao)
As (
SELECT object_id, DataReferencia, Operacao FROM Utilizacao
UNPIVOT
(DataReferencia FOR Operacao IN ([Seek], [Scan], [LookUp], [Update])) As UP),
UltimoAcesso (object_id, UltimaData)
As (
SELECT object_id, MAX(DataReferencia) FROM Referencias
GROUP BY object_id),
UltimasOperacoes (object_id, UltimaData, Operacoes)
As (
SELECT U.*,
(SELECT DISTINCT Operacao FROM Referencias As R
WHERE U.object_id = R.object_id AND U.UltimaData = R.DataReferencia
FOR XML AUTO)
FROM UltimoAcesso As U)
SELECT
Name As Tabela, UltimaData As UltimoAcesso,
REPLACE(REPLACE(Operacoes,'"/>',', '),'<R Operacao="','') As UltimasOperacoes
FROM sys.tables As T
LEFT OUTER JOIN UltimasOperacoes As U ON T.object_id = U.object_id