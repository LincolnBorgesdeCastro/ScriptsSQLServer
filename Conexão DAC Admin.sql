/*
Conexão DAC
https://www.dirceuresende.com/blog/habilitando-e-utilizando-a-conexao-remota-dedicada-para-administrador-dac-no-sql-server/
Conexão para administrador quando não se tem acesso ao servidor por servidor esta topado
*/	

--Trace flag  7806 para o SQL Server Express

--Visualizar
EXEC sp_configure 'remote admin connections'


--Ativar
Use master
GO

/* 0 = Apenas DAC local; 1 = DAC remoto */
sp_configure 'remote admin connections', 1 
GO
RECONFIGURE
GO

--Consultar
SELECT
    B.session_id,
    A.name,
    B.connect_time,
    B.last_read,
    B.last_write,
    B.client_net_address
FROM
    sys.endpoints A
    INNER JOIN sys.dm_exec_connections B ON A.endpoint_id = B.endpoint_id
WHERE
    A.is_admin_endpoint = 1



--Desativar
/*
--Ativar
Use master
GO

/* 0 = Apenas DAC local; 1 = DAC remoto */
sp_configure 'remote admin connections', 0 
GO
RECONFIGURE
GO

*/