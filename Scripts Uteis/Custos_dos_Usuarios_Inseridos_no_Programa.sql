DECLARE @RefInicial VARCHAR(6)
DECLARE @RefFinal VARCHAR(6)
DECLARE @parDATA_Inicial DATETIME
DECLARE @parDATA_Final DATETIME
DECLARE @parApuracaoAcompanhamento INT
DECLARE @parNUMG_ProgramaEspecial INT
DECLARE @parNUMG_Pessoa INT

SET @parDATA_Inicial = CONVERT(DATETIME, '2010-01-01')
SET @parDATA_Final = CONVERT(DATETIME, '2010-12-31')
SET @RefInicial = LEFT(CONVERT(VARCHAR, @parDATA_Inicial, 112), 6)
SET @RefFinal = LEFT(CONVERT(VARCHAR, @parDATA_Final, 112), 6)
SET @parApuracaoAcompanhamento = 1
SET @parNUMG_ProgramaEspecial = 1
SET @parNUMG_Pessoa = 0

IF Object_id('TempDb..#saFaturas') > 0
  DROP TABLE #saFaturas

IF Object_id('tempdb..#referencias') > 0
  DROP TABLE #referencias

IF Object_id('Tempdb..#PessoasTotal') > 0
  DROP TABLE #PessoasTotal

IF Object_id('tempdb..#PessoasTotal1') > 0
  DROP TABLE #PessoasTotal1

IF Object_id('TempDb..#saAtendimentos') > 0
  DROP TABLE #saAtendimentos

IF Object_id('TempDb..#saAtendimentosUti') > 0
  DROP TABLE #saAtendimentosUti

IF Object_id('TempDb..#saAtendimentosValores') > 0
  DROP TABLE #saAtendimentosValores

IF Object_id('tempdb..#TemporariaAtendimentos') > 0
  DROP TABLE #TemporariaAtendimentos

IF Object_id('TempDb..#tblPessoasSelecionadas') > 0
  DROP TABLE #tblPessoasSelecionadas

IF Object_id('tempdb..#TemporariaProcedimentos') > 0
  DROP TABLE #TemporariaProcedimentos

IF Object_id('TempDb..#saAtendimentosTratamentos') > 0
  DROP TABLE #saAtendimentosTratamentos

IF Object_id('TempDb..#saAtendimentosProcedimentos') > 0
  DROP TABLE #saAtendimentosProcedimentos

IF Object_id('tempdb..#saAtendimentosProcedimentosTemp') > 0
  DROP TABLE #saAtendimentosProcedimentosTemp

CREATE TABLE #tblPessoasSelecionadas
  (
     NUMG_Pessoa INT
  )

CREATE TABLE #saFaturas
  (
     NUMR_Mes             SMALLINT,
     NUMR_Ano             SMALLINT,
     NUMG_Prestador       INT,
     NUMG_Fatura          INT,
     NUMR_TipoAtendimento TINYINT
  )

-- Criando indice na tabela temporária #saFaturas para deixar a consulta mais rápida
CREATE INDEX IX_saFaturas
  ON #saFaturas (NUMG_Fatura)

CREATE TABLE #saAtendimentos
  (
     NUMG_Fatura      INT,
     NUMR_Mes         SMALLINT,
     NUMR_Ano         SMALLINT,
     NUMG_Atendimento INT,
     DATA_Atendimento DATETIME,
     NUMG_Pessoa      INT,
     NUMR_TipoGuia    TINYINT
  )

CREATE TABLE #referencias
  (
     NUMG_Pessoa INT,
     NUMR_Mes    SMALLINT,
     NUMR_Ano    SMALLINT
  )

CREATE TABLE #PessoasTotal
  (
     NUMG_Pessoa  INT,
     NUMR_Mes     SMALLINT,
     NUMR_Ano     SMALLINT,
     VALR_Pago    MONEY,
     sequenciaMes INT,
     Referencia   VARCHAR(7)
  )

CREATE TABLE #PessoasTotal1
  (
     NUMG_Pessoa INT,
     NUMR_Mes    SMALLINT,
     NUMR_Ano    SMALLINT,
     VALR_Pago   MONEY
  )

CREATE TABLE #TemporariaAtendimentos
  (
     Referencia           VARCHAR(7),
     NUMR_TipoAtendimento INT,
     NUMR_TipoGuia        INT,
     NUMG_Atendimento     INT,
     TipoAtendimento      VARCHAR(100),
     NUMG_Pessoa          INT,
     NUMG_Prestador       INT,
     DATA_Atendimento     VARCHAR(10),
     NUMR_DiasInternado   INT,
     NUMR_QtdDiasUti      INT,
     NUMR_Cid             CHAR(6),
     NUMR_Cid2            CHAR(6),
     VALR_Pago            MONEY
  )

CREATE TABLE #TemporariaProcedimentos
  (
     NUMG_Atendimento  INT,
     CODG_Procedimento NVARCHAR(16),
     TIPO_Evento       INT
  )

-- Criando indice na tabela temporária #saAtendimentos para deixar a consulta mais rápida
CREATE INDEX IX_saAtendimentos
  ON #saAtendimentos (NUMG_Atendimento)

CREATE TABLE #saAtendimentosValores
  (
     NUMG_Atendimento INT,
     TipoAtendimento  VARCHAR(50),
     VALR_Pago        MONEY
  )

CREATE INDEX IX_saAtendimentosValores
  ON #saAtendimentosValores (NUMG_Atendimento)

CREATE TABLE #saAtendimentosTratamentos
  (
     NUMG_Atendimento INT,
     TipoAtendimento  VARCHAR(50),
     VALR_Pago        MONEY
  )

CREATE INDEX IX_saAtendimentosTratamentos
  ON #saAtendimentosTratamentos (NUMG_Atendimento)

CREATE TABLE #saAtendimentosProcedimentos
  (
     NUMG_Atendimento  INT,
     NUMG_Procedimento INT
  )

CREATE TABLE #saAtendimentosProcedimentosTemp
  (
     NUMG_Atendimento INT
  )

CREATE INDEX IX_saAtendimentosProcedimentos
  ON #saAtendimentosProcedimentos (NUMG_Atendimento)

IF NOT EXISTS(SELECT NUMG_Pessoa
              FROM   dbo.gv_Pessoas
              WHERE  NUMG_Pessoa IN ( @parNUMG_Pessoa ))
  BEGIN
      INSERT INTO #tblPessoasSelecionadas
      SELECT pes.NUMG_Pessoa
      FROM   assistencia.ipasgo.dbo.sipe_UsuariosProgramas usu
             INNER JOIN assistencia.ipasgo.dbo.sipe_UsuariosEspeciais esp
               ON usu.NUMG_UsuarioEspecial = esp.NUMG_UsuarioEspecial
             INNER JOIN dbo.gv_pessoas pes
               ON esp.NUMG_Pessoa = pes.NUMG_Pessoa
             INNER JOIN assistencia.ipasgo.dbo.sipe_ProgramasEspeciais pro
               ON usu.NUMG_ProgramaEspecial = pro.NUMG_ProgramaEspecial
      WHERE  usu.NUMG_ProgramaEspecial = @parNUMG_ProgramaEspecial
  END
ELSE
  BEGIN
      INSERT INTO #tblPessoasSelecionadas
      SELECT NUMG_Pessoa
      FROM   dbo.gv_Pessoas
      WHERE  NUMG_Pessoa IN ( @parNUMG_Pessoa )
  END

IF @parApuracaoAcompanhamento = 1
  BEGIN
      INSERT #saFaturas
      SELECT NUMR_Mes,
             NUMR_Ano,
             NUMG_Prestador,
             NUMG_Fatura,
             NUMR_TipoAtendimento
      FROM   dbo.sa_Faturas
      WHERE  DATA_Exclusao IS NULL
             AND DATA_Processamento IS NOT NULL
             AND NUMR_TipoAtendimento NOT IN ( 10, 11, 16, 17 )
             AND FLAG_ProtocoloTemporario = 0
             AND CONVERT(VARCHAR, NUMR_Ano) + RIGHT('00' + CONVERT(VARCHAR, NUMR_Mes), 2) >= @RefInicial
             AND CONVERT(VARCHAR, NUMR_Ano) + RIGHT('00' + CONVERT(VARCHAR, NUMR_Mes), 2) <= @RefFinal


      INSERT #saAtendimentos
      SELECT DISTINCT Fat.NUMG_Fatura,
                      Fat.NUMR_Mes,
                      Fat.NUMR_Ano,
                      Ate.NUMG_Atendimento,
                      Ate.DATA_Atendimento,
                      Gui.NUMG_Pessoa,
                      Gui.NUMR_TipoGuia
      FROM   dbo.sa_Atendimentos Ate INNER JOIN #saFaturas Fat              ON Ate.NUMG_Fatura = Fat.NUMG_Fatura
                                     INNER JOIN dbo.Guias Gui               ON Ate.NUMG_Guia   = Gui.NUMG_Guia
                                     INNER JOIN #tblPessoasSelecionadas Pes ON Gui.NUMG_Pessoa = Pes.NUMG_Pessoa
      WHERE  Ate.NUMG_Glosa IS NULL

  END
ELSE
  BEGIN
      INSERT #saAtendimentos
      SELECT DISTINCT Ate.NUMG_Fatura,
                      CASE
                        WHEN Day(Ate.DATA_Atendimento) > 25 THEN Month(Dateadd(MONTH, 1, Ate.DATA_Atendimento))
                        ELSE Month(Ate.DATA_Atendimento)
                      END,
                      CASE
                        WHEN Day(Ate.DATA_Atendimento) > 25 THEN Year(Dateadd(MONTH, 1, Ate.DATA_Atendimento))
                        ELSE Year(Ate.DATA_Atendimento)
                      END,
                      Ate.NUMG_Atendimento,
                      Ate.DATA_Atendimento,
                      Gui.NUMG_Pessoa,
                      Gui.NUMR_TipoGuia
      FROM   dbo.sa_Atendimentos Ate INNER JOIN dbo.Guias Gui               ON Ate.NUMG_Guia = Gui.NUMG_Guia
                                     INNER JOIN #tblPessoasSelecionadas Pes ON Gui.NUMG_Pessoa = Pes.NUMG_Pessoa
      WHERE  Ate.NUMG_Glosa IS NULL
             AND Ate.DATA_Atendimento >= @parDATA_Inicial
             AND Ate.DATA_Atendimento <= @parDATA_Final

      INSERT #saFaturas
      SELECT ate.NUMR_Mes,
             ate.NUMR_Ano,
             Fat.NUMG_Prestador,
             Fat.NUMG_Fatura,
             Fat.NUMR_TipoAtendimento
      FROM   dbo.sa_Faturas Fat INNER JOIN #saAtendimentos Ate ON Fat.NUMG_Fatura = Ate.NUMG_Fatura
      WHERE  Fat.DATA_Exclusao IS NULL
             AND Fat.NUMR_TipoAtendimento NOT IN ( 10, 11, 16, 17 )
             AND Fat.FLAG_ProtocoloTemporario = 0

      INSERT #saFaturas
      SELECT Fat.NUMR_Mes,
             Fat.NUMR_Ano,
             NULL,
             NULL,
             NULL
      FROM   dbo.sa_Faturas Fat LEFT JOIN #saFaturas FatTemp  ON Fat.NUMR_Mes = FatTemp.NUMR_Mes
                                                             AND Fat.NUMR_Ano = FatTemp.NUMR_Ano
      WHERE  FatTemp.NUMR_Mes IS NULL
             AND CONVERT(VARCHAR, Fat.NUMR_Ano) + RIGHT('00' + CONVERT(VARCHAR, Fat.NUMR_Mes), 2) >= @RefInicial
             AND CONVERT(VARCHAR, Fat.NUMR_Ano) + RIGHT('00' + CONVERT(VARCHAR, Fat.NUMR_Mes), 2) <= @RefFinal
  END

-- Retirando as contas de oncologia (quimioterapia)
DELETE Ate
FROM   #saAtendimentos Ate INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosProcedimentos Tap
         ON Ato.NUMG_Ato = Tap.NUMG_Ato
       INNER JOIN dbo.sa_Procedimentos Pro
         ON Tap.NUMG_Procedimento = Pro.NUMG_Procedimento
WHERE  LEFT(Pro.CODG_Procedimento, 4) IN ( '3001', '3002' )

-- Retirando as contas de oncologia (quimioterapia)
DELETE Ate
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosExames Tae
         ON Ato.NUMG_Ato = Tae.NUMG_Ato
       INNER JOIN dbo.sa_Procedimentos Pro
         ON Tae.NUMG_Procedimento = Pro.NUMG_Procedimento
WHERE  LEFT(Pro.CODG_Procedimento, 4) IN ( '3001', '3002' )

-- CONSULTAS --
INSERT #saAtendimentosValores
SELECT Ate.NUMG_Atendimento,
       'CONSULTA',
       Sum(Atc.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosConsultas Atc
         ON Ate.NUMG_Atendimento = Atc.NUMG_Atendimento
WHERE  Atc.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- EXAMES --
INSERT #saAtendimentosValores
SELECT Ate.NUMG_Atendimento,
       'EXAME EXTERNO',
       Sum(Atx.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosExames Atx
         ON Ate.NUMG_Atendimento = Atx.NUMG_Atendimento
WHERE  Atx.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- ODONTOLOGIA --
INSERT #saAtendimentosValores
SELECT Ate.NUMG_Atendimento,
       'ODONTOLOGIA',
       Sum(Atd.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosOdontologicos Atd
         ON Ate.NUMG_Atendimento = Atd.NUMG_Atendimento
WHERE  Atd.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- Materiais/Medicamentos
INSERT #saAtendimentosTratamentos
SELECT Ate.NUMG_Atendimento,
       'MATMED',
       Sum(Tmm.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosMatMed Tmm
         ON Ato.NUMG_Ato = Tmm.NUMG_Ato
WHERE  Tmm.NUMG_MatMed NOT IN ( 5346, 5347, 5348, 5349,
                                5422, 5423, 5437, 5438,
                                5439, 5532, 5572, 5574,
                                5575, 5576, 5578, 5579,
                                5580, 5582, 5583, 5586,
                                5589, 5592, 5595, 5598,
                                5599, 5638, 5659, 5660,
                                5692, 5693, 5694, 5695,
                                5696, 5697, 5698, 5699,
                                5700, 5701, 5702, 5703,
                                5705, 5707, 5708, 5709,
                                5712, 5713, 5714, 5716,
                                5718, 5719, 5720, 5817,
                                5832, 5833, 5834, 5841,
                                5842, 5843, 5844, 5845,
                                5846, 5847, 5848, 5849,
                                5854, 5855, 5856, 5857,
                                5858, 5924, 5925, 5926,
                                5927, 5928, 5929, 5930,
                                5932, 5934, 5935, 5936,
                                5937, 5938, 5939, 5975,
                                5985, 5986, 5998, 6021,
                                6039, 6040, 6041, 6042,
                                6043, 6044, 6045, 6046,
                                6048, 6049, 6105, 6133,
                                6134, 6139, 6200, 6201,
                                6327, 6336, 6337, 6338,
                                6341, 6343, 6344, 6353,
                                6354, 6377, 6378, 6379,
                                6382, 6383, 6384, 6385,
                                6386, 6389, 6391, 6392,
                                6393, 6394, 6395, 6396,
                                6397, 6398, 6399, 6400,
                                6401, 6418, 6452, 6453,
                                6454, 6455, 6459, 6460,
                                6461, 6484, 6486, 6487,
                                6488, 6542, 6543, 6681,
                                6717, 6720, 6771, 6786,
                                6876, 6877, 6881, 6884,
                                6892, 6912, 6913, 6918,
                                6919, 6923, 6953, 6954,
                                6956, 6958, 6959, 6960,
                                6962, 6964, 6965, 6966,
                                6967, 6969, 6970, 6971,
                                6972, 6973, 6974, 6975,
                                6978, 6979, 6980, 6981,
                                6983, 6984, 6985, 6986,
                                6987, 6989, 6994, 6996,
                                6999, 7000, 7001, 7002,
                                7003, 7004, 7005, 7006,
                                7007, 7008, 7013, 7026,
                                7027, 7028, 7029, 7030,
                                7031, 7032, 7033, 7039,
                                7118, 7130, 7131, 7132,
                                7137, 7139, 7140, 7143,
                                7144, 7145, 7146, 7147,
                                7151, 7152, 7153, 7154,
                                7155, 7156, 7163, 7164,
                                7166, 7168, 7169, 7191,
                                7193, 7194, 7197, 7199,
                                7200, 7201, 7202, 7203,
                                7204, 7205, 7206, 7210,
                                7213, 7219, 7220, 7221,
                                7222, 7223, 7224, 7226,
                                7228, 7229, 7233, 7234,
                                7235, 7236, 7237, 7242,
                                7243, 7244, 7245, 7246,
                                7247, 7255, 7256, 7258,
                                7259, 7260, 7261, 7262,
                                7263, 7271, 7313, 7314,
                                7315, 7319, 7320, 7333,
                                7567, 7695, 7891, 7892,
                                7920, 7930, 8032, 9098,
                                9107, 9145, 9154, 9156,
                                9259, 9262, 9284, 9286,
                                9344, 9345, 9349, 9351,
                                9352, 9353, 9354, 9355,
                                9356, 9357, 9358, 9359,
                                9360, 9361, 9362, 9363,
                                9369, 9370, 9371, 9372,
                                9375, 9376, 9377, 9378,
                                9379, 9380, 9381, 9382,
                                9383, 9384, 9385, 9386,
                                9387, 9388, 9389, 9390,
                                9391, 9392, 9393, 9394,
                                9395, 9396, 9397, 9398,
                                9399, 9400, 9401, 9402,
                                9403, 9404, 9405, 9406,
                                9407, 9408, 9409, 9410,
                                9411, 9412, 9413, 9414,
                                9415, 9416, 9417, 9418,
                                9419, 9420, 9421, 9422,
                                9423, 9424, 9425, 9426,
                                9427, 9428, 9429, 9431,
                                9432, 9433, 9434, 9435,
                                9436, 9437, 9440, 9458,
                                9476, 9477, 9478, 9479,
                                9480, 9494 )
       AND Tmm.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- Exames Internos
INSERT #saAtendimentosTratamentos
SELECT Ate.NUMG_Atendimento,
       'EXAMES INTERNOS',
       Sum(Tae.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosExames Tae
         ON Ato.NUMG_Ato = Tae.NUMG_Ato
       INNER JOIN dbo.sa_Procedimentos Pro
         ON Tae.NUMG_Procedimento = Pro.NUMG_Procedimento
WHERE  Tae.VALR_Pago > 0
       AND LEFT(Pro.CODG_Procedimento, 4) NOT IN ( '3001', '3002' ) -- Retirando as contas de oncologia (quimioterapia)
GROUP  BY Ate.NUMG_Atendimento

-- Serviços Hospitalares
INSERT #saAtendimentosTratamentos
SELECT Ate.NUMG_Atendimento,
       'DESPESAS',
       Sum(Tad.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosDespesas Tad
         ON Ato.NUMG_Ato = Tad.NUMG_Ato
WHERE  tad.numg_servicohospitalar NOT IN ( 3, 79 )
       AND Tad.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- Utis
INSERT #saAtendimentosTratamentos
SELECT Ate.NUMG_Atendimento,
       'DIARIAS DE UTI',
       Sum(Tad.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosDespesas Tad
         ON Ato.NUMG_Ato = Tad.NUMG_Ato
WHERE  tad.numg_servicohospitalar IN ( 3, 79 )
       AND Tad.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

-- Serviços Profissionais
INSERT #saAtendimentosTratamentos
SELECT Ate.NUMG_Atendimento,
       'HONORARIOS',
       Sum(Tap.VALR_Pago)
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosProfissionais Tap
         ON Ato.NUMG_Ato = Tap.NUMG_Ato
WHERE  Tap.VALR_Pago > 0
GROUP  BY Ate.NUMG_Atendimento

INSERT #saAtendimentosValores
SELECT NUMG_Atendimento,
       TipoAtendimento,
       Sum(VALR_Pago)
FROM   #saAtendimentosTratamentos
GROUP  BY NUMG_Atendimento,
          TipoAtendimento

INSERT INTO #referencias
SELECT DISTINCT ate.NUMG_Pessoa,
                fat.NUMR_Mes,
                fat.NUMR_Ano
FROM   #saFaturas fat,
       #saAtendimentos ate

INSERT INTO #PessoasTotal1
SELECT ate.numg_pessoa,
       ate.numr_mes,
       ate.numr_ano,
       Sum(vlr.valr_pago) AS valr_pago
FROM   #saAtendimentos ate
       INNER JOIN #saAtendimentosValores vlr
         ON vlr.numg_atendimento = ate.numg_atendimento
GROUP  BY ate.numg_pessoa,
          ate.NUMR_Ano,
          ate.NUMR_Mes

-- insere as referências que não estão computados no período
INSERT INTO #pessoastotal1
            (numg_pessoa,
             numr_ano,
             numr_mes,
             valr_pago)
SELECT DISTINCT ref.numg_pessoa,
                ref.numr_ano,
                ref.numr_mes,
                Isnull(ate.valr_pago, 0)
FROM   #referencias ref
       LEFT JOIN #pessoastotal1 ate
         ON ref.numr_ano = ate.numr_ano
            AND ref.numr_mes = ate.numr_mes
            AND ref.numg_pessoa = ate.numg_pessoa
WHERE  ate.numg_pessoa IS NULL

INSERT INTO #PessoasTotal
SELECT ate.NUMG_Pessoa,
       ate.NUMR_Mes,
       ate.NUMR_Ano,
       ate.VALR_Pago,
       Row_number() OVER (PARTITION BY ate.numg_pessoa ORDER BY ate.numr_ano, ate.numr_mes)                  AS sequenciaMes,
       RIGHT('00' + CONVERT(VARCHAR, ate.NUMR_Mes), 2) + '/' + RIGHT('0000' + CONVERT(VARCHAR, NUMR_Ano), 4) AS Referencia
FROM   #pessoastotal1 ate
ORDER  BY ate.numg_pessoa,
          ate.numr_ano,
          ate.numr_mes

-- PROCEDIMENTOS - CONSULTA --
INSERT #saAtendimentosProcedimentos
SELECT Ate.NUMG_Atendimento,
       Atc.NUMG_Procedimento
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosConsultas Atc
         ON Ate.NUMG_Atendimento = Atc.NUMG_Atendimento
WHERE  Atc.VALR_Pago > 0

-- PROCEDIMENTOS - EXAMES --
INSERT #saAtendimentosProcedimentos
SELECT Ate.NUMG_Atendimento,
       Atx.NUMG_Procedimento
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosExames Atx
         ON Ate.NUMG_Atendimento = Atx.NUMG_Atendimento
WHERE  Atx.VALR_Pago > 0

-- PROCEDIMENTOS - DEMAIS ATENDIMENTOS --
INSERT #saAtendimentosProcedimentos
SELECT Ate.NUMG_Atendimento,
       Atd.NUMG_Procedimento
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_AtendimentosOdontologicos Atd
         ON Ate.NUMG_Atendimento = Atd.NUMG_Atendimento
WHERE  Atd.VALR_Pago > 0

INSERT #saAtendimentosProcedimentos
SELECT Ate.NUMG_Atendimento,
       Tap.NUMG_Procedimento
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosProcedimentos Tap
         ON Ato.NUMG_Ato = Tap.NUMG_Ato

INSERT INTO #saAtendimentosProcedimentosTemp
SELECT DISTINCT numg_atendimento
FROM   #saAtendimentosProcedimentos

INSERT #saAtendimentosProcedimentos
SELECT Ate.NUMG_Atendimento,
       Tap.NUMG_Procedimento
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosExames Tap
         ON Ato.NUMG_Ato = Tap.NUMG_Ato
       LEFT JOIN #saAtendimentosProcedimentosTemp tmp
         ON tmp.numg_atendimento = ate.numg_atendimento
WHERE  tmp.numg_atendimento IS NULL

SELECT Ate.NUMG_Atendimento,
       Sum(Tad.NUMR_QtdPaga)AS NUMR_QtdDiasUti
INTO   #saAtendimentosUti
FROM   #saAtendimentos Ate
       INNER JOIN dbo.sa_TratamentosAtos Ato
         ON Ate.NUMG_Atendimento = Ato.NUMG_Atendimento
       INNER JOIN dbo.sa_TratamentosAtosDespesas Tad
         ON Ato.NUMG_Ato = Tad.NUMG_Ato
       INNER JOIN #saFaturas Fat
         ON Fat.numg_fatura = ate.numg_fatura
WHERE  Fat.NUMR_TipoAtendimento = 4
       AND Tad.NUMG_ServicoHospitalar IN ( 3, 79 )
       AND Tad.NUMR_QtdPaga > 0
GROUP  BY Ate.NUMG_Atendimento

INSERT INTO #TemporariaAtendimentos
SELECT RIGHT('00' + CONVERT(VARCHAR, Ate.NUMR_Mes), 2) + '/' + CONVERT(VARCHAR, Ate.NUMR_Ano)AS Referencia,
       Fat.NUMR_TipoAtendimento,
       Ate.NUMR_TipoGuia,
       Ate.NUMG_Atendimento,
       CONVERT(VARCHAR(100), '')                                                             AS TipoAtendimento,
       ate.numg_pessoa,
       Fat.numg_prestador,
       CONVERT(VARCHAR, Ate.DATA_Atendimento, 103)                                           AS DATA_Atendimento,
       CASE
         WHEN Fat.NUMR_TipoAtendimento = 4
              AND ( Datediff(Day, Ate.DATA_Atendimento, CASE
                                                          WHEN Atr.DATA_Alta IS NULL THEN Ate.DATA_Atendimento
                                                          ELSE Atr.DATA_Alta
                                                        END) ) = 0 THEN 1
         ELSE Datediff(Day, Ate.DATA_Atendimento, CASE
                                                    WHEN Atr.DATA_Alta IS NULL THEN Ate.DATA_Atendimento
                                                    ELSE Atr.DATA_Alta
                                                  END)
       END                                                                                   AS NUMR_DiasInternado,
       Isnull(uti.NUMR_QtdDiasUti, 0)                                                        AS NUMR_QtdDiasUti,
       Isnull(Cid.NUMR_Cid, '')                                                              AS NUMR_Cid,
       Isnull(Cid2.NUMR_Cid, '')                                                             AS NUMR_Cid2,
       Sum(Vlr.VALR_Pago)                                                                    AS VALR_Pago
FROM   #saAtendimentos Ate
       INNER JOIN #saAtendimentosValores Vlr
         ON Ate.NUMG_Atendimento = Vlr.NUMG_Atendimento
       INNER JOIN #saFaturas Fat
         ON Fat.numg_fatura = ate.numg_fatura
       LEFT JOIN dbo.sa_AtendimentosTratamentos Atr
         ON Ate.NUMG_Atendimento = Atr.NUMG_Atendimento
       LEFT JOIN #saAtendimentosUti uti
         ON uti.NUMG_Atendimento = ate.NUMG_Atendimento
       LEFT JOIN dbo.Cids Cid
         ON Atr.NUMG_CidPrincipal = Cid.NUMG_Cid
       LEFT JOIN dbo.Cids Cid2
         ON Atr.NUMG_Cid2 = Cid2.NUMG_Cid
GROUP  BY Ate.Numr_mes,
          ate.numr_ano,
          Fat.numr_tipoatendimento,
          ate.numr_tipoguia,
          ate.numg_atendimento,
          ate.numg_pessoa,
          Fat.numg_prestador,
          ate.data_atendimento,
          atr.data_alta,
          cid.numr_cid,
          cid2.numr_cid,
          uti.NUMR_QtdDiasUti

INSERT INTO #TemporariaProcedimentos
SELECT DISTINCT Ate.NUMG_Atendimento,
                Prc.CODG_Procedimento,
                CASE
                  WHEN Pro.NUMG_Procedimento IN ( 3781, 3802, 7524, 7609,
                                                  7797, 7825, 8014, 8034,
                                                  8038, 8091, 8363, 8372 ) THEN 0 -- Atendimento ambulatorial (eletivo)
                  WHEN Ate.NUMR_TipoAtendimento = 7 THEN 0 -- Atendimento ambulatorial (eletivo)
                  WHEN Pro.NUMG_Procedimento = 8150 THEN 1 -- Atendimento em pronto socorro (urgência / emergência)
                  WHEN Ate.NUMR_TipoAtendimento = 4
                       AND Pro.NUMG_Procedimento = 8106 THEN 2 -- Internação domiciliar
                  WHEN Pro.NUMG_Procedimento = 3782 THEN 4 -- Internação hospitalar clínica médica eletiva/urgência/emergência
                  WHEN ( Pro.NUMG_Procedimento <> 3782
                         AND Ate.NUMR_TipoAtendimento = 4
                         AND Prc.DESC_TipoAtendimento NOT IN ( 'E', 'U' ) ) THEN 4
                  WHEN Ate.NUMR_TipoAtendimento IN ( 4, 5, 6 )
                       AND Prc.DESC_TipoAtendimento = 'E' THEN 5 -- Internação hospitalar clínica cirúrgica eletiva
                  WHEN Ate.NUMR_TipoAtendimento IN ( 4, 5, 6 )
                       AND Prc.DESC_TipoAtendimento = 'U' THEN 6 -- Internação hospitalar clínica cirúrgica urgência/emergência
                  WHEN Ate.NUMR_TipoAtendimento IN ( 1, 3, 8, 12,
                                                     13, 14 )
                       AND Ate.NUMR_TipoGuia = 3 THEN 7 -- Series ambulatoriais ( Ex.: sessões de fisioterapia)
                  WHEN ( Ate.NUMR_TipoAtendimento IN ( 1, 2, 12, 13, 14 )
                         AND Ate.NUMR_TipoGuia = 2 ) THEN 8 -- SADT (exames )
                  WHEN Ate.NUMR_TipoAtendimento IN ( 5, 6 ) THEN 6 -- Internação hospitalar clínica cirúrgica urgência/emergência
                  ELSE 0
                END AS TIPO_Evento
FROM   #TemporariaAtendimentos Ate
       INNER JOIN #saAtendimentosProcedimentos Pro
         ON Ate.NUMG_Atendimento = Pro.NUMG_Atendimento
       INNER JOIN dbo.sa_Procedimentos Prc
         ON Pro.NUMG_Procedimento = Prc.NUMG_Procedimento

IF Object_id('tempdb..#Relatorio2') > 0
  DROP TABLE #Relatorio2

SELECT DISTINCT Pes.NUMG_Pessoa,
                RIGHT('0000000' + Rtrim(CONVERT(CHAR(7), Pes.NUMR_Matricula)), 7) + '-' + RIGHT('00' + Rtrim(CONVERT(CHAR(2), Pes.NUMR_Complemento)), 2) AS matricula_paciente,
                CONVERT(VARCHAR, Pes.DESC_Nome)                                                                                                          DESC_Nome,
                CONVERT(VARCHAR, Pes.DESC_Sexo)                                                                                                          DESC_Sexo,-- + ';' +
                CONVERT(VARCHAR, Pes.DATA_Nascimento, 103)                                                                                               DATA_Nascimento,-- + ';' +
                Datediff(yyyy, Pes.DATA_Nascimento, Getdate())                                                                                           Idade
INTO   #Relatorio2
FROM   #tblPessoasSelecionadas Ate
       INNER JOIN dbo.gv_Pessoas Pes
         ON Ate.NUMG_Pessoa = Pes.NUMG_Pessoa
       INNER JOIN dbo.gv_DnePessoa Dne
         ON Pes.NUMG_Pessoa = Dne.NUMG_Pessoa
GROUP  BY Pes.NUMG_Pessoa,
          Pes.NUMR_Matricula,
          Pes.NUMR_Complemento,
          Pes.DESC_Sexo,
          Pes.DATA_Nascimento,
          Pes.DESC_Nome

SELECT DISTINCT h.numg_pessoa,
                t.matricula_paciente,
                t.desc_nome,
                t.desc_sexo,
                t.data_nascimento,
                t.idade,
                h.sequenciaMes,
                h.Referencia,
                h.valr_pago
FROM   #PessoasTotal h
       INNER JOIN #Relatorio2 t
         ON h.numg_pessoa = t.numg_pessoa
ORDER  BY t.desc_nome 
