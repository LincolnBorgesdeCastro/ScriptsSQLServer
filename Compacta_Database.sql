use OSMTD
GO

exec SBD.dbo.up_Compacta_Database
             @Ds_Database = 'OSMTD',
             @Fl_Parar_Se_Falhar = 0,
             @Fl_Exibe_Comparacao_Tamanho = 1, 
             @Fl_Metodo_Compressao = 2 

/*
/*Consulta*/

Declare @Compressao int = 2 -- Colocar p metodo que deseja que seja migrado
Declare @Ds_Metodo_Compressao VARCHAR(20) = (CASE WHEN @Compressao  = 2 THEN 'PAGE' WHEN @Compressao = 1 THEN 'ROW' ELSE 'NONE' END)
-- 0 -- Não comprimido
-- 1 -- Compressão de linha
-- 2 -- Compressão de pagina
Declare @Ds_Tabela VARCHAR(200) =  NULL --'Receitas'

SELECT DISTINCT 
        A.name AS Tabela,
        NULL AS Indice,
		B.data_compression,
        'ALTER TABLE [' + C.name + '].[' + A.name + '] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = '+@Ds_Metodo_Compressao+')' AS Comando
    FROM 
        sys.tables                   A
        INNER JOIN sys.partitions    B   ON A.object_id = B.object_id
        INNER JOIN sys.schemas       C   ON A.schema_id = C.schema_id
    WHERE 
        B.data_compression <> @Compressao -- NONE
        AND A.type = 'U'
		AND ((@Ds_Tabela is null) or (A.name = @Ds_Tabela ))
        --and A.name = @Ds_Tabela
    UNION

    SELECT DISTINCT 
        B.name AS Tabela,
        A.name AS Indice,
		D.data_compression,
        'ALTER INDEX [' + A.name + '] ON [' + C.name + '].[' + B.name + '] REBUILD PARTITION = ALL WITH ( STATISTICS_NORECOMPUTE = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF, DATA_COMPRESSION = '+@Ds_Metodo_Compressao+')'
    FROM 
        sys.indexes                  A
        INNER JOIN sys.tables        B   ON A.object_id = B.object_id
        INNER JOIN sys.schemas       C   ON B.schema_id = C.schema_id
        INNER JOIN sys.partitions    D   ON A.object_id = D.object_id AND A.index_id = D.index_id
    WHERE 
        D.data_compression <> @Compressao -- 
        AND D.index_id <> 0
        AND B.type = 'U'
        AND ((@Ds_Tabela is null) or (B.name = @Ds_Tabela ))
		--and B.name = @Ds_Tabela
    ORDER BY
        Tabela,
        Indice

*/
/* Criação da procedure */
USE SBD
GO

Alter PROCEDURE [dbo].[up_Compacta_Database] (
    @Ds_Database SYSNAME,
    @Fl_Parar_Se_Falhar smallint = 1,
    @Fl_Exibe_Comparacao_Tamanho smallint = 1,
    @Fl_Metodo_Compressao smallint = 2
)
AS
-- 0 -- Não comprimido
-- 1 -- Compressão de linha
-- 2 -- Compressão de pagina
BEGIN
    SET NOCOUNT ON
    DECLARE
        @Ds_Query VARCHAR(MAX),
        @Ds_Comando_Compactacao VARCHAR(MAX),
        @Ds_Metodo_Compressao VARCHAR(20) = (CASE WHEN @Fl_Metodo_Compressao = 2 THEN 'PAGE' WHEN @Fl_Metodo_Compressao = 1 THEN 'ROW' ELSE 'NONE' END),
		@Nr_Metodo_Compressao VARCHAR(10) = (CASE WHEN @Fl_Metodo_Compressao = 2 THEN '2'    WHEN @Fl_Metodo_Compressao = 1 THEN '1'   ELSE '0'    END)

        
    IF (OBJECT_ID('tempdb..#Comandos_Compactacao') IS NOT NULL) DROP TABLE #Comandos_Compactacao
    CREATE TABLE #Comandos_Compactacao
    (
        Id BIGINT IDENTITY(1, 1),
        Tabela SYSNAME,
        Indice SYSNAME NULL,
        Comando VARCHAR(MAX)
    )
    
    IF (@Fl_Exibe_Comparacao_Tamanho = 1)
    BEGIN
        
        SET @Ds_Query = '
        SELECT 
            (SUM(a.total_pages) / 128) AS Vl_Tamanho_Tabelas_Antes_Compactacao
        FROM 
            [' + @Ds_Database + '].sys.tables					t     WITH(NOLOCK)
            INNER JOIN [' + @Ds_Database + '].sys.indexes			i     WITH(NOLOCK) ON t.OBJECT_ID = i.object_id
            INNER JOIN [' + @Ds_Database + '].sys.partitions			p     WITH(NOLOCK) ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
            INNER JOIN [' + @Ds_Database + '].sys.allocation_units		a     WITH(NOLOCK) ON p.partition_id = a.container_id
        WHERE 
            i.OBJECT_ID > 255 '
        
        EXEC(@Ds_Query)
        
    END
    
    SET @Ds_Query =
    'INSERT INTO #Comandos_Compactacao( Tabela, Indice, Comando )
    SELECT DISTINCT 
        A.name AS Tabela,
        NULL AS Indice,
        ''ALTER TABLE ['' + ''' + @Ds_Database + ''' + ''].['' + C.name + ''].['' + A.name + ''] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ' + @Ds_Metodo_Compressao + ')'' AS Comando
    FROM 
        [' + @Ds_Database + '].sys.tables                   A
        INNER JOIN [' + @Ds_Database + '].sys.partitions    B   ON A.object_id = B.object_id
        INNER JOIN [' + @Ds_Database + '].sys.schemas       C   ON A.schema_id = C.schema_id
    WHERE 
        B.data_compression <> '+@Nr_Metodo_Compressao+' 
        --AND B.index_id = 0 -- Tabela heap
        AND A.type = ''U''
    
    UNION

    SELECT DISTINCT 
        B.name AS Tabela,
        A.name AS Indice,
        ''ALTER INDEX ['' + A.name + ''] ON ['' + ''' + @Ds_Database + ''' + ''].['' + C.name + ''].['' + B.name + ''] REBUILD PARTITION = ALL WITH ( STATISTICS_NORECOMPUTE = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF, DATA_COMPRESSION = ' + @Ds_Metodo_Compressao + ')''
    FROM 
        [' + @Ds_Database + '].sys.indexes                  A
        INNER JOIN [' + @Ds_Database + '].sys.tables        B   ON A.object_id = B.object_id
        INNER JOIN [' + @Ds_Database + '].sys.schemas       C   ON B.schema_id = C.schema_id
        INNER JOIN [' + @Ds_Database + '].sys.partitions    D   ON A.object_id = D.object_id AND A.index_id = D.index_id
    WHERE 
        D.data_compression <> '+@Nr_Metodo_Compressao+' 
        AND D.index_id <> 0
        AND B.type = ''U''
    ORDER BY
        Tabela,
        Indice '
    
    EXEC(@Ds_Query)
        
    DECLARE 
        @Qt_Comandos INT = (SELECT COUNT(*) FROM #Comandos_Compactacao),
        @Contador INT = 1,
        @Ds_Mensagem VARCHAR(MAX),
        @Nr_Codigo_Erro INT = (CASE WHEN @Fl_Parar_Se_Falhar = 1 THEN 16 ELSE 10 END)
        
        
    WHILE(@Contador <= @Qt_Comandos)
    BEGIN
        
        SELECT
            @Ds_Comando_Compactacao = Comando
        FROM
            #Comandos_Compactacao
        WHERE
            Id = @Contador
        
            
        BEGIN TRY
            
            SET @Ds_Mensagem = 'Executando comando "' + @Ds_Comando_Compactacao + '"... Aguarde...'
            RAISERROR(@Ds_Mensagem, 10, 1) WITH NOWAIT 
            EXEC(@Ds_Comando_Compactacao)
             
        END TRY
                  
        BEGIN CATCH
            
            SELECT
                ERROR_NUMBER() AS ErrorNumber,
                ERROR_SEVERITY() AS ErrorSeverity,
                ERROR_STATE() AS ErrorState,
                ERROR_PROCEDURE() AS ErrorProcedure,
                ERROR_LINE() AS ErrorLine,
                ERROR_MESSAGE() AS ErrorMessage;
            
            SET @Ds_Mensagem = 'Falha ao executar o comando "' + @Ds_Comando_Compactacao + '"'
            RAISERROR(@Ds_Mensagem, @Nr_Codigo_Erro, 1) WITH NOWAIT
            
            RETURN
                        
        END CATCH	
        
        
        SET @Contador = @Contador + 1
        
    END
    
    
    
    IF (@Fl_Exibe_Comparacao_Tamanho = 1)
    BEGIN
        
        SET @Ds_Query = '
        SELECT 
            (SUM(a.total_pages) / 128) AS Vl_Tamanho_Tabelas_Depois_Compactacao
        FROM 
            [' + @Ds_Database + '].sys.tables					t     WITH(NOLOCK)
            INNER JOIN [' + @Ds_Database + '].sys.indexes			i     WITH(NOLOCK) ON t.OBJECT_ID = i.object_id
            INNER JOIN [' + @Ds_Database + '].sys.partitions			p     WITH(NOLOCK) ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
            INNER JOIN [' + @Ds_Database + '].sys.allocation_units		a     WITH(NOLOCK) ON p.partition_id = a.container_id
        WHERE 
            i.OBJECT_ID > 255
        '
        
        EXEC(@Ds_Query)
        
    END
    
    
    IF (@Qt_Comandos > 0)
        PRINT 'Database "' + @Ds_Database + '" compactado com sucesso!'
    ELSE
        PRINT 'Nenhum objeto para compactar no database "' + @Ds_Database + '"'
    
END