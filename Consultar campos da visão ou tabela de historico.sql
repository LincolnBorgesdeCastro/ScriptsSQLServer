SELECT  th.NOME_Tabela, thc.NOME_Coluna
FROM    dbo.scad_TabelasHistoricosColunas AS thc 
        INNER JOIN dbo.scad_TabelasHistoricos AS th ON thc.NUMG_TabelaHistorico = th.NUMG_TabelaHistorico
WHERE  (th.NOME_Tabela like 'gv_%')
ORDER BY 1,2

--select * from scad_TabelasHistoricos


