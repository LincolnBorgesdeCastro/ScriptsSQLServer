EXEC sys.sp_MSforeachdb '
if (
        SELECT
            count(*)
        FROM 
            [?].sys.database_permissions A WITH(NOLOCK)
            LEFT JOIN [?].sys.all_objects B WITH(NOLOCK) ON A.major_id = B.[object_id]
        WHERE 
            A.grantee_principal_id = 2
            AND A.state IN (''G'', ''W'')
            AND (A.major_id = 0 OR B.[object_id] IS NOT NULL)
            AND NOT ''?'' IN (''master'', ''tempdb'', ''model'', ''msdb'',''SSISDB'', ''RECYCLE'',''distribution'') 
			AND A.[permission_name] = ''CONNECT''
   ) > 0			
   Begin
      Print ''Use '' + ''?
GO'';
      use [?]
--      REVOKE CONNECT FROM GUEST;
   End
      
'
/*
USE CONTAS_PAGAR
GO

SELECT *
FROM 
   sys.database_permissions A WITH(NOLOCK)
   LEFT JOIN sys.all_objects B WITH(NOLOCK) ON A.major_id = B.[object_id]
WHERE 
A.grantee_principal_id = 2
AND A.state IN ('G', 'W')
AND (A.major_id = 0 OR B.[object_id] IS NOT NULL)
AND NOT DB_NAME() IN ('master', 'tempdb', 'model', 'msdb','SSISDB', 'RECYCLE') 
AND A.[permission_name] = 'CONNECT'


*/