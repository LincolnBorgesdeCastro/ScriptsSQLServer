SET NOCOUNT ON
--Se a tabela temporaria existir, será excluida
IF EXISTS ( SELECT  Name
            FROM    tempdb..sysobjects
            Where   name like '#HoldforEachDB%' )
    DROP TABLE #HoldforEachDB_size


--Criando a tabela temporaria que conterá as informações
--de cada database
CREATE TABLE #HoldforEachDB_size
    (
      [DatabaseName] [nvarchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS
                                    NOT NULL,
      [Size] [decimal] NOT NULL,
      [Name] [nvarchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS
                            NOT NULL,
      [Filename] [nvarchar](90) COLLATE SQL_Latin1_General_CP1_CI_AS
                                NOT NULL,

    )
ON  [PRIMARY]


--Se a tabela temporária existir, será excluida
IF EXISTS ( SELECT  name
            FROM    tempdb..sysobjects
            Where   name like '#fixed_drives%' )
    DROP TABLE #fixed_drives

--Criando a tabela temporária que conterá as informações de
--espaço livre dos discos no servidor
CREATE TABLE #fixed_drives
    (
      [Drive] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS
                        NOT NULL,
      [MBFree] [decimal] NOT NULL
    )
ON  [PRIMARY]


--Utilizando a procedure SP_MSFOREACHDB para inserir as informações
--de cada database
INSERT  INTO #HoldforEachDB_size
        EXEC sp_MSforeachdb 'Select ''?'' as DatabaseName, Case When [?]..sysfiles.size * 8 / 1024 = 0 Then 1 Else [?]..sysfiles.size * 8 / 1024 End
AS size,[?]..sysfiles.name,
[?]..sysfiles.filename From [?]..sysfiles'

--Inserindo na tabela temporaria o resultado da extented stored procedure
--que retorna o tamanho dos discos
INSERT  INTO #fixed_drives
        EXEC xp_fixeddrives


SELECT  @@Servername
PRINT '' ;

--Exibir os arquivo de dados e log de cada banco
--ordenando pelos bancos que são maiores
SELECT  RTRIM(CAST(DatabaseName AS VARCHAR(75))) AS DatabaseName,
        Drive,
        Filename,
        CAST(Size AS INT) AS Size,
        CAST(MBFree AS VARCHAR(10)) AS MB_Free
FROM    #HoldforEachDB_size
        INNER JOIN #fixed_drives ON LEFT(#HoldforEachDB_size.Filename, 1) = #fixed_drives.Drive
GROUP BY DatabaseName,
        Drive,
        MBFree,
        Filename,
        CAST(Size AS INT)
ORDER BY Drive,
        Size DESC
PRINT '' ;

--Exibindo as unidades de disco
SELECT  Drive AS [Total Data Space Used |],
        CAST(SUM(Size) AS VARCHAR(10)) AS [Total Size],
        CAST(MBFree AS VARCHAR(10)) AS MB_Free
FROM    #HoldforEachDB_size
        INNER JOIN #fixed_drives ON LEFT(#HoldforEachDB_size.Filename, 1) = #fixed_drives.Drive
GROUP BY Drive,
        MBFree

PRINT '' ;

SELECT  COUNT(DISTINCT RTRIM(CAST(DatabaseName AS VARCHAR(75)))) AS Database_Count
FROM    #HoldforEachDB_size 