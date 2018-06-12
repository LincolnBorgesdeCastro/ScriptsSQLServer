-- Script para carregar arquivo .trc em uma tabela


SELECT IDENTITY(int, 1, 1) AS RowNumber, * INTO select * from Wn20temp_trc
FROM ::fn_trace_gettable('x:\work\Trace_Auto_WN20.trc', default)