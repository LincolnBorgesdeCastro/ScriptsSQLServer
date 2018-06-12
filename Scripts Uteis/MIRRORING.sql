--caso seja necessário SUSPENDER o espelhamento entre os databases IPASGO dos servidores ASSISTENCIA e DCSG3177\IPASGO, 
--para se melhorar a performance do Banco de Dados em função de algum gargalo, sigam os passos abaixo:

--1. Não se pode truncar o Transaction Log, pois quando o espelhamento for restabelecido, 
--o Log deve ser aplicado no servidor mirror para sincronizar as bases. 
--Portanto deve-se desabilitar o Job DBA - BACKUP LOG do database IPASGO do servidor ASSISTENCIA.

--2. Para se suspender o espelhamento, executar o comando: 

ALTER DATABASE IPASGO SET PARTNER SUSPEND


/*Após sua execução os databases devem ficar com os seguintes status:

IPASGO (Principal,Suspended) ==> No servidor Principal
IPASGO (Mirror,Suspended / Restoring...) ==> No servidor Mirror
*/

/*3. Durante todo o período em que estiver suspenso NÃO podemos fazer backup do Log, 
portanto é necessário acompanhar o crescimento do Log durante todo o tempo.
Se houver problema de espaço, o espelhamento deve ser restaurado (veja o comando abaixo) e 
mais espaço ser adicionado ao Log ou o espelhamento deve ser quebrado.
*/

--4. Para se restaurar o espelhamento, executar o comando: 

ALTER DATABASE IPASGO SET PARTNER RESUME

/*Após sua execução os databases devem ficar com os seguintes status:

IPASGO (Principal,Synchronized) ==> No servidor Principal
IPASGO (Mirror,Synchronized / Restoring...) ==> No servidor Mirror
*/

--5. A partir desse momento pode-se fazer backup do Log, portanto deve-se habilitar o Job DBA - BACKUP LOG.

--6. Para se criar um snapshot para o database IPASGO do servidor DCSG3177\IPASGO executar o comando abaixo:

USE [master]
GO
--DROP DATABASE IPASGO_SNP
/****** Object:  Database [prestadores_SNP]    Script Date: 12/30/2009 11:39:50 ******/
CREATE DATABASE [IPASGO_SNP] ON
 (NAME = N'ipasgo_Data', FILENAME = N'f:\Microsoft SQL Server\MSSQL.1\DATA\Ipasgo_SNP.SNP') 
,(NAME = N'ipasgo_Data2', FILENAME = N'f:\Microsoft SQL Server\MSSQL.1\DATA\Ipasgo2_SNP.SNP')
,(NAME = N'ipasgo_Index', FILENAME = N'f:\Microsoft SQL Server\MSSQL.1\DATA\IpasgoIx_SNP.SNP') AS SNAPSHOT OF [IPASGO]


/* Script para RETIRAR o status de RESTORING de uma base qualquer*/

RESTORE DATABASE prestadores WITH RECOVERY