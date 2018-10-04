--Melhores praticas para compressão/compactação de tabelas e inides

https://social.technet.microsoft.com/wiki/pt-br/contents/articles/28197.entendendo-mais-sobre-compressao-de-dados-em-sql-server.aspx
https://technet.microsoft.com/en-us/library/dd894051(v=sql.100).aspx -- SQLSERVR2008
https://docs.microsoft.com/pt-br/sql/relational-databases/data-compression/data-compression?view=sql-server-2017

-- Percentual de update

SELECT o.name AS [Table_Name], x.name AS [Index_Name],
       i.partition_number AS [Partition],
       i.index_id AS [Index_ID], x.type_desc AS [Index_Type],
       i.leaf_update_count * 100.0 /
           (i.range_scan_count + i.leaf_insert_count
            + i.leaf_delete_count + i.leaf_update_count
            + i.leaf_page_merge_count + i.singleton_lookup_count
           ) AS [Percent_Update]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i  
JOIN sys.objects o  WITH(NOLOCK) ON o.object_id = i.object_id  
JOIN sys.indexes x  WITH(NOLOCK) ON x.object_id = i.object_id AND x.index_id = i.index_id
WHERE (i.range_scan_count + i.leaf_insert_count
       + i.leaf_delete_count + leaf_update_count
       + i.leaf_page_merge_count + i.singleton_lookup_count) != 0
AND objectproperty(i.object_id,'IsUserTable') = 1
ORDER BY [Percent_Update] ASC

/**********************************************************************************/
-- Percentual de scans

SELECT o.name AS [Table_Name], x.name AS [Index_Name],
       i.partition_number AS [Partition],
       i.index_id AS [Index_ID], x.type_desc AS [Index_Type],
       i.range_scan_count * 100.0 /
           (i.range_scan_count + i.leaf_insert_count
            + i.leaf_delete_count + i.leaf_update_count
            + i.leaf_page_merge_count + i.singleton_lookup_count
           ) AS [Percent_Scan]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i
JOIN sys.objects o  WITH(NOLOCK) ON o.object_id = i.object_id
JOIN sys.indexes x  WITH(NOLOCK) ON x.object_id = i.object_id AND x.index_id = i.index_id
WHERE (i.range_scan_count + i.leaf_insert_count
       + i.leaf_delete_count + leaf_update_count
       + i.leaf_page_merge_count + i.singleton_lookup_count) != 0
AND objectproperty(i.object_id,'IsUserTable') = 1
ORDER BY [Percent_Scan] DESC


/**********************************************************************************/


