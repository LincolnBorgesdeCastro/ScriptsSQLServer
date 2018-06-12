--Executar leitura de um arquivo de TRACE
SELECT * FROM ::fn_trace_gettable('C:\Documentation\SQL_Traces\Trace1.trc', default)
order by starttime
GO