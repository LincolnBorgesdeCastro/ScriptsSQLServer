              
alter PROC sp_DbaReplicaLogsDBNTS                                              
as                            
                                              
DECLARE @NUMG_DATA INT                                              
DECLARE @DATA_GERACAO DATETIME                                              
DECLARE @DATA_ULTIMOLOG DATETIME                                              
DECLARE @PATH VARCHAR(100)                                              
DECLARE @SERVIDOR VARCHAR(50)                                              
DECLARE @CMD VARCHAR(4000)                                              
DECLARE @ARQUIVO VARCHAR (100)                                              
DECLARE @ARQUIVOCOMPLETO VARCHAR (4000)                                              
DECLARE @TABELA VARCHAR(400)                                       
DECLARE @ERRO INT                                
DECLARE @CONT INT                                
DECLARE @DUPL INT                                     
                                              
SET NOCOUNT ON                                              
                                              
IF OBJECT_ID('TEMPDB..#ARQUIVOS') > 0  DROP TABLE #ARQUIVOS                                              
CREATE TABLE #ARQUIVOS (NOME_ARQUIVO VARCHAR(200)  NULL)                                              
                                              
                                              
SET @SERVIDOR = 'ASSISTENCIA'                                              
SET @PATH = '\\' + @SERVIDOR + '\F$\LOG_FILES\'                                              
SET @PATH = @PATH + LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)                                              
                                              
--SET @CMD = 'MD ' + @PATH  + '\OK'                                              
--EXEC MASTER..XP_CMDSHELL  @CMD                                                        
                                              
select  @NUMG_DATA = MAX(NUMG_DATA)  ,                                               
    @Data_geracao = MAX(Data_geracao) ,                                               
    @DATA_ULTIMOLOG = MAX(DATA_ULTIMOLOG)                                               
from dba_geracaoarquivo                                              
where flag_processado = 0                                    
                                    
if @DATA_ULTIMOLOG is null                                              
begin                                      
 RAISERROR( 'DATA ULTIMO LOG É NULA',16,1)                                      
 return                                      
end                                      
                                              
                                              
SET @CMD = 'DIR ' +  + @PATH + '\*.TXT  /OGNE /B'                                              
PRINT @CMD                                              
                                  
INSERT #ARQUIVOS                                              
EXEC MASTER..XP_CMDSHELL @CMD                                              
                                              
                                              
DECLARE CUR CURSOR FOR                                              
 SELECT NOME_ARQUIVO                                              
 FROM #ARQUIVOS                                              
 WHERE NOME_ARQUIVO <> 'File Not Found'                                              
  AND NOME_ARQUIVO IS NOT NULL                                              
                                              
OPEN CUR                                      
                                      
FETCH NEXT FROM CUR INTO @ARQUIVO                                              
WHILE @@FETCH_STATUS = 0                                              
BEGIN                                              
  BEGIN TRAN                                         
  SET @ARQUIVOCOMPLETO = @PATH + '\' + @ARQUIVO                                              
  PRINT @ARQUIVOCOMPLETO                                   
                                           
  select @TABELA = replace(replace(REPLACE(case when desc_tabelaInserir is null then owner + '.' + Desc_tabela                                                 
      else desc_tabelaInserir end  , '.TXT', ''), 'ADM.', ''), 'DBO.', '')                                         
  from dba_replicacoes                                              
  where desc_tabela = replace(replace(REPLACE(@ARQUIVO, '.TXT', ''), 'ADM.', ''), 'DBO.', '')                                      
                                  
  if object_id ('tempdb..##tabela') > 0 drop table ##tabela                                  
                                  
  set @cmd = 'select * into ##tabela from ' + @tabela + ' where 1=2'                                  
  exec (@cmd)                                  
                                  
  SET @CMD = 'BULK INSERT ##tabela FROM ''' + @ARQUIVOCOMPLETO + '''' +                                              
    ' WITH ( ' +                                              
    ' DATAFILETYPE = ''char'',' +                                              
    ' FIELDTERMINATOR = ''|;'',' +                                  
    ' MAXERRORS = 0' +                                             
    ' )'                                              
  EXEC (@CMD)                                
                            
                    
                            
 if exists ( select column_name                             
     from information_schema.columns where                             
     table_name = @tabela and                            
     column_name = 'data_ocorrencia2')                             
 set @cmd = ' delete tmp' +                                   
            ' from ##tabela tmp' +                                   
            ' inner join ' + @tabela + ' tab on tab.data_ocorrencia2 = tmp.data_ocorrencia2'                            
 else set @cmd = ' delete tmp' +                                   
              ' from ##tabela tmp' +                                   
             ' inner join ' + @tabela + ' tab on tab.data_ocorrencia = tmp.data_ocorrencia'                            
                            
                            
  --apaga os registros duplicados                                     
  exec (@cmd)                                
                                
  select @dupl = @@rowcount                                 
                                
  if @dupl > 0                                
  print cast(@dupl as varchar) + ' registros Duplicados na tabela ' + @tabela + '. Verificar!!!'                              
                                  
  --insere os registros                                  
  set @cmd = ' insert into ' + @tabela +                                  
             ' select NUMG_Auditoria,NUMG_Processo,NUMG_TipoProcesso,NUMG_Pessoa,DATA_Referencia,NUMG_Matricula,FLAG_Envio,VALR_Processo,NUMG_TipoAuditoria,DATA_Cadastro,DATA_Impressao,NUMG_Ar,DESC_Operador,DATA_Ocorrencia,FLAG_Ocorrencia,(NUMG_Log + 7215)' +                                  
             ' from ##tabela'                                  
  exec (@cmd)                                  
                        
--LOG_crMalaDiretaAuditoria
        
  select @erro = @@error, @cont = @@rowcount                                
                                 
                                
  if @erro <> 0                                    
  begin                                    
    print 'erro na tabela: ' + @tabela                                    
    ROLLBACK                                    
  end                                    
  else begin                                        
    print 'Foram inseridas ' + cast (@cont as varchar) + ' linhas na tabela ' + @tabela                                
    UPDATE dba_replicacoes                                              
    SET DATA_OCORRENCIA = @DATA_ULTIMOLOG                                              
           where desc_tabela = replace(replace(REPLACE(@ARQUIVO, '.TXT', ''), 'ADM.', ''), 'DBO.', '')                                          
                                                
    SET @CMD = 'MOVE ' + @arquivocompleto + ' ' + @PATH  + '\OK\'                                      
    EXEC MASTER..XP_CMDSHELL  @CMD                                              
    COMMIT                                            
  end                                    
                                            
  FETCH NEXT FROM CUR INTO @ARQUIVO                                              
END                                           
CLOSE CUR                                              
DEALLOCATE CUR                                              
                                          
                                    
update dba_geracaoarquivo                                              
set flag_processado = 1                                              
where numg_data = @numg_data                   
                  
                  
--select  * from dba_geracaoarquivo 