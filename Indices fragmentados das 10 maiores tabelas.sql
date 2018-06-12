SET NOCOUNT ON  

DECLARE @NOME_Tabela VARCHAR (128)  
DECLARE @NUMR_MaxFrag   DECIMAL  
DECLARE @DESC_Mensagem varchar(1000)
DECLARE @DESC_Indices varchar(4000)
  
-- Decide on the maximum fragmentation to allow  
SET @NUMR_MaxFrag = 30

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
SELECT TOP 10 OBJECT_NAME(ID)
FROM SYSINDEXES 
WHERE INDID IN (1,0) AND OBJECTPROPERTY(ID,'ISUSERTABLE')=1 
AND OBJECT_NAME(ID) <> 'CR_ARQUIVORETORNO'
ORDER BY ROWCNT DESC 
  
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

DECLARE curIndices CURSOR FOR
SELECT 'DBCC DBREINDEX (''' + RTrim(ObjectName) + ''', ' + RTrim(IndexName) + ', 80)' 
FROM #fraglist  
WHERE LogicalFrag >= @NUMR_MaxFrag --and objectname like '%polimed%'
  AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0  
order by LogicalFrag desc

OPEN curIndices

FETCH NEXT FROM curIndices INTO @DESC_Mensagem

WHILE @@FETCH_STATUS = 0
begin
 SET @DESC_Indices = coalesce(@DESC_Indices,'') + @DESC_Mensagem + ';  ' + CHAR(10) 
 FETCH NEXT FROM curIndices INTO @DESC_Mensagem
end

if (coalesce(@DESC_Indices,'') <> '') 
begin
    SET @DESC_Indices = coalesce(@DESC_Indices,'') + CHAR(10) + 'Atenciosamente, ' + CHAR(10) + CHAR(10) + 'Sub-coordenação de Banco de Dados'

	exec ipasgo.dbo.up_crEnviaEmailGeral 'gti_dba@ipasgo.go.gov.br', 
                                         'REINDEXAR 10 maiores tabelas na base IPASGO',
                                         @DESC_Indices, 
                                         null, 
                                         'GTI_DBA'
end

CLOSE curIndices
DEALLOCATE curIndices