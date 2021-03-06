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

USE [OSSES]
GO
checkpoint
DBCC SHRINKFILE (N'osses_log' , 0)
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
USE [CITRIX_SITE]
GO
checkpoint
DBCC SHRINKFILE (N'CITRIX_SITE_log' , 0)
GO
/**********************************************************/

USE [tempdb]
GO
checkpoint
GO
DBCC SHRINKDATABASE(N'tempdb')
GO
DBCC SHRINKDATABASE(N'tempdb' , NOTRUNCATE)
GO
DBCC SHRINKDATABASE(N'tempdb' , TRUNCATEONLY)
GO
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 256)
GO
DBCC SHRINKFILE (N'tempdev1' , 256)
GO
DBCC SHRINKFILE (N'tempdev2' , 256)
GO
DBCC SHRINKFILE (N'tempdev3' , 256)
GO

DBCC SHRINKFILE (N'tempdev4' , 256)
GO
DBCC SHRINKFILE (N'tempdev5' , 256)
GO
DBCC SHRINKFILE (N'tempdev6' , 256)
GO
DBCC SHRINKFILE (N'tempdev7' , 256)
GO
DBCC SHRINKFILE (N'templog' , 256)
GO

/**********************************************************/

/**********************************************************/

/**********************************************************/

/**********************************************************/