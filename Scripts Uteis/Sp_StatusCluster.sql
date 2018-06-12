IF EXISTS(SELECT * from sysobjects where name = 'sp_StatusCluster')
	drop procedure dbo.sp_StatusCluster	
GO
/*******************************************************************
 * Procedure : sp_StatusCluster 			  	   *
 * Proposito : Verifica o Status do cluster			   *
 *             						           *
 * @Servidor pode ser :						   *
 * Nome do Cluster Ex.: CCBT005CTO (Cluster Name)		   *
 * Nome Físico de um dos nós Ex.: SCHX001 (Node Name)	   	   *
 * Nome de um Grupo no Cluster Ex.: VCHX001 (Cluster Group)        *
 * Exemplo : sp_StatusCluster 'VCHX001'    	                   *
 *             						           *
 * Ex.: exec sp_StatusCluster  'VCBT003BV176'		           *
 * Desenvolvido por Nilton R. Pinheiro 		 02/08/2002	   *
 *******************************************************************/

CREATE PROCEDURE  sp_StatusCluster 
@servidor	varchar(15)=''
as
--Se não for especificado o nome do servidor, a procedure carrega o servidor ativo da conexão.

If CharIndex('\',@@servername) = 0 and @servidor=''
	Set @Servidor =  @@ServerName	
Else
	Set @servidor=SubString(@@ServerName,1,CharIndex('\',@@servername)-1)

Declare @Str varchar(255)
--Mostra Status dos Grupos do cluster
SELECT @Str = "master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /CLUSTER:" +@servidor + " GROUP'"
EXEC (@Str)
--Mostra Status dos Recursos do Cluster
SELECT @Str = "master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /CLUSTER:" +@servidor + " RESOURCE'"
EXEC (@Str)
--Mostra Status dos Nós do Cluster
SELECT @Str = "master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /CLUSTER:" +@servidor + " NODE'"
EXEC (@Str)
--Mostra Status das Interfaces de Rede do Cluster
SELECT @Str = "master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /CLUSTER:" +@servidor + " NETINT'"
EXEC (@Str)
--Mostra Status das Placas do Cluster
SELECT @Str = "master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /CLUSTER:" +@servidor + " NET'"
EXEC (@Str)
--master..xp_cmdshell 'c:\WINNT\system32\cluster.exe /?'
