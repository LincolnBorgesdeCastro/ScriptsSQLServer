use SIFE
Go

select * from sa_ArquivosPrestadores a with(nolock) left join sa_arquivosmensagensprestadores m with(nolock) on a.numg_arquivo = m.numg_arquivo  
where DATA_Processamento is null
and NUMR_Mes = 2
and NUMR_Ano = 2018
and m.NUMG_Arquivo is null


--Select * From Sife.dbo.sa_SifeFaturas


/*

select * from sa_ArquivosPrestadores
where NUMR_Mes = 2
and NUMR_Ano = 2018
and numr_prestador = 7321058

*/

/*
select * from sa_ArquivosPrestadores
where DATA_Arquivo < '2018-02-28 12:00:00'
and DATA_Arquivo > '2018-02-28 06:00:00'
and NUMR_Mes = 2
and NUMR_Ano = 2018

select * from sa_ArquivosPrestadores
where DATA_Arquivo < '2018-01-27 12:00:00'
and DATA_Arquivo > '2018-01-27 06:00:00'
and NUMR_Mes = 1
and NUMR_Ano = 2018

select * from sa_ArquivosPrestadores
where DATA_Arquivo < '2017-03-01 12:00:00'
and DATA_Arquivo > '2017-03-01 06:00:00'
and NUMR_Mes = 2
and NUMR_Ano = 2017
*/