-- Gera um script com o comando DROP TABLE para todas as tabelas de uma base

Select 'drop table '+name from sysobjects where xtype = 'U'
order by name