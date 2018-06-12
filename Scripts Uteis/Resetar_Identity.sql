DBCC CHECKIDENT ('pg_bordero') -- seta para o ultimo usado

DBCC CHECKIDENT ('sigd_TiposDocumentos', NORESEED) -- visualiza

DBCC CHECKIDENT ('sigd_Assuntos', RESEED, 0) -- volta para o valor estipulado ex. 30