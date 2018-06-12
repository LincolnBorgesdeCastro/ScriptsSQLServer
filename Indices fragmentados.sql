use ipasgo
go


SET NOCOUNT ON  

DECLARE @NOME_Tabela VARCHAR (128)  
DECLARE @DESC_Comando   VARCHAR (255)  
DECLARE @NUMR_IdObjeto  INT  
DECLARE @NUMR_IdIndice   INT  
DECLARE @NUMR_Frag      DECIMAL  
DECLARE @NUMR_MaxFrag   DECIMAL  
  
-- Decide on the maximum fragmentation to allow  
SET @NUMR_MaxFrag = 30.0  

if object_id ('tempdb..#fraglist') > 0 drop table #fraglist 
CREATE TABLE #fraglist (  
   ObjectName CHAR (255),  
   ObjectId INT,  
   IndexName CHAR (255),  
   IndexId INT,  
   Lvl INT,  
   CountPages INT,  
   CountRows INT,  
   MinRecSize INT,  
   MaxRecSize INT,  
   AvgRecSize INT,  
   ForRecCount INT,  
   Extents INT,  
   ExtentSwitches INT,  
   AvgFreeBytes INT,  
   AvgPageDensity INT,  
   ScanDensity DECIMAL,  
   BestCount INT,  
   ActualCount INT,  
   LogicalFrag DECIMAL,  
   ExtentFrag DECIMAL)  
  
-- Declare cursor  
DECLARE curTabelas CURSOR FOR 
 
   SELECT TABLE_NAME  
   FROM INFORMATION_SCHEMA.TABLES  
   WHERE TABLE_TYPE = 'BASE TABLE' 
   and TABLE_NAME <> 'cr_ArquivoRetorno'
   order by TABLE_NAME
  
-- Open the cursor  
OPEN curTabelas  
  
-- Loop through all the tables in the database  
FETCH NEXT FROM curTabelas INTO @NOME_Tabela  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
-- Do the showcontig of all indexes of the table  
   INSERT INTO #fraglist   
   EXEC ('DBCC SHOWCONTIG (''' + @NOME_Tabela + ''')   
      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')  
   FETCH NEXT FROM curTabelas INTO @NOME_Tabela  
END  
  
-- Close and deallocate the cursor  
CLOSE curTabelas  
DEALLOCATE curTabelas  
  
SELECT ObjectName, IndexName, ObjectId, IndexId, LogicalFrag 
FROM #fraglist  
WHERE LogicalFrag >= 30 --and objectname like '%polimed%'
  AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0  order by LogicalFrag desc