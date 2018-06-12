select  sys.name
from sys.sysobjects sys 
	INNER join sys.syscolumns col ON sys.id = col.id
	inner join dbo.sbde_EstatisticasCrescimentoTabelas e ON sys.name = replace(replace(replace(replace(e.NOME_Tabela,'dbo',''),'[',''),']',''),'.','')
	inner join dbo.sbdi_BasesDados b on e.numg_baseDado = b.numg_baseDado
where  sys.xtype = 'u'
and col.name = 'NUMG_Pessoa'
and sys.name NOT LIKE '%LOG%'
and b.DATA_Referencia = '2012-01-01'
ORDER by NUMR_TamanhoTabela desc