CREATE VIEW database_stats
AS
SELECT
 CASE
   WHEN O2.object_ID IS NOT NULL THEN O2.object_id
   ELSE O.object_id
 END AS objectID,
 CASE
   WHEN S2.Name IS NULL THEN S.name
   ELSE S2.name
 END AS schemaName,
 CASE
   WHEN O2.object_id IS NULL THEN 
     CASE
       WHEN O.name = 'sysconvgroup' THEN 'sysconvgroup (conversation_groups)'
       WHEN O.name = 'sysdesend' THEN 'sysdesend (conversation_endpoints)'
       WHEN O.name = 'sysdercv' THEN 'sysdercv (conversation_endpoints)'
       WHEN O.name = 'sysxmitqueue' THEN 'sysxmitqueue (transmission_queue)'
     ELSE O.name
   END
   ELSE O2.name
 END AS objectName,
 CASE
   WHEN O2.object_id IS NULL THEN O.type_desc
   ELSE IT.internal_type_desc
 END AS 'type',
 (CONVERT(DECIMAL(20,5),(DE1.used_page_count)) / 
 (SELECT SUM(used_page_count) FROM sys.dm_db_partition_stats)) 
 * 100 AS percentOfDB,
 CASE
   WHEN DE1.used_page_count = 0 THEN 0
   ELSE (CONVERT(DECIMAL(20,5),used_page_count) / CONVERT(DECIMAL(20,5),reserved_page_count)) * 100
 END as PercentPagesFull,
 DE1.row_count,
 DE2.tableData - (DE1.lob_used_page_count * 8) AS rowData,
 (DE1.lob_used_page_count * 8) AS lobData,
 ISNULL(DE3.indexData,0) indexData,
 DE1.in_row_data_page_count,
 DE1.in_row_used_page_count,
 DE1.in_row_reserved_page_count,
 DE1.lob_used_page_count,
 DE1.lob_reserved_page_count,
 DE1.row_overflow_used_page_count,
 DE1.row_overflow_reserved_page_count,
 DE1.used_page_count,
 DE1.reserved_page_count
FROM
 sys.objects O
INNER JOIN
 sys.schemas S ON O.schema_id = S.schema_id
INNER JOIN
 (
 SELECT
   PS1.Object_ID objectID,
   MAX(PS1.row_count) AS row_count,
   SUM(PS1.in_row_data_page_count) in_row_data_page_count,
   SUM(PS1.in_row_used_page_count) in_row_used_page_count,
   SUM(PS1.in_row_reserved_page_count) in_row_reserved_page_count,
   SUM(PS1.lob_used_page_count) lob_used_page_count,
   SUM(PS1.lob_reserved_page_count) lob_reserved_page_count,
   SUM(PS1.row_overflow_used_page_count) row_overflow_used_page_count,
   SUM(PS1.row_overflow_reserved_page_count) row_overflow_reserved_page_count,
   SUM(PS1.used_page_count) used_page_count,
   SUM(PS1.reserved_page_count) reserved_page_count
 FROM 
   sys.dm_db_partition_stats PS1
 GROUP BY
   OBJECT_ID
  ) DE1 ON O.object_ID = DE1.objectID
INNER JOIN
 (
 SELECT
   OBJECT_ID objectID,
   SUM(used_page_count) * 8 AS tableData
 FROM 
   sys.dm_db_partition_stats PS
 WHERE
   index_id IN (0,1) -- Heap, Cluster
 GROUP BY
   OBJECT_ID
 ) DE2 ON DE1.objectID = DE2.objectID
LEFT OUTER JOIN
 (
 SELECT
   OBJECT_ID objectID,
   SUM(used_page_count) * 8 AS indexData
 FROM 
   sys.dm_db_partition_stats PS
 WHERE
   index_id NOT IN (0,1) -- Heap, Cluster
 GROUP BY
   OBJECT_ID
 ) DE3 ON DE1.objectID = DE3.objectID
LEFT OUTER JOIN
 sys.objects O2 ON O.parent_object_id = O2.object_id
 AND O.type = 'IT'
LEFT OUTER JOIN
 sys.schemas S2 ON O2.schema_id = S2.schema_id
LEFT OUTER JOIN 
  sys.internal_tables IT ON O.object_id = IT.object_id
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW database_index_stats
AS
SELECT
    O.object_id AS objectID,
    S.name AS schemaName,
    O.name AS objectName,
    CASE
        WHEN SI.name IS NULL THEN 'Heap'
        ELSE SI.name
    END AS indexName,
    SI.type AS indexType,
    (CONVERT(DECIMAL(20,5),(PS.used_page_count)) / 
        (SELECT SUM(used_page_count) FROM sys.dm_db_partition_stats)) 
        * 100 AS percentOfDB,
    CASE
        WHEN PS.used_page_count = 0 THEN 0
        ELSE (CONVERT(DECIMAL(20,5),PS.used_page_count) / CONVERT(DECIMAL(20,5),PS.reserved_page_count)) * 100
    END as PercentPagesFull,
    PS.used_page_count,
    PS.reserved_page_count,
    US.user_seeks,
    US.user_scans,
    US.user_lookups,
    US.user_updates,
    ((US.user_seeks + US.user_scans + US.user_lookups) - US.user_updates) AS efficiency
FROM sys.objects O
INNER JOIN sys.schemas S ON O.schema_id = s.schema_id
INNER JOIN sys.dm_db_partition_stats PS ON O.object_id = PS.object_id
INNER JOIN sys.indexes SI ON PS.object_id = SI.object_id
AND PS.index_id = SI.index_id
INNER JOIN sys.dm_db_index_usage_stats US ON US.object_id = SI.object_id
AND US.index_id = SI.index_id
AND US.database_id = db_id()
WHERE O.is_ms_shipped = 0

