-- Shrinck Files de LOG

USE [IPASGO]
GO
checkpoint
DBCC SHRINKFILE (N'ipasgo_log' , 0)
GO

/**********************************************************/

USE [SIGA]
GO
checkpoint
DBCC SHRINKFILE (N'siga_log' , 0)
GO

/**********************************************************/

USE [OSMTD]
GO
checkpoint
DBCC SHRINKFILE (N'osmtd_log' , 0)
GO

/**********************************************************/

USE [SISIPASGO]
GO
checkpoint
DBCC SHRINKFILE (N'sisipasgo_log' , 0)
GO

/**********************************************************/

USE [DNE]
GO
checkpoint
DBCC SHRINKFILE (N'DNE_log' , 0)
GO

/**********************************************************/

USE [SISSED]
GO
checkpoint
DBCC SHRINKFILE (N'sissed_log' , 0)
GO
/**********************************************************/

/**********************************************************/

/**********************************************************/

/**********************************************************/

/**********************************************************/