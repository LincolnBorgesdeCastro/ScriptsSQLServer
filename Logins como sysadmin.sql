 SELECT
    a.name AS LoginName,
    a.type_desc AS LoginType,
    a.default_database_name AS DefaultDBName,
    CASE WHEN b.sysadmin = 1 THEN 'True'
         ELSE 'False'
    END [SysAdmin],
    CASE WHEN b.sysadmin = 1 THEN 'ALTER SERVER ROLE [sysadmin]  DROP MEMBER ' + '[' + a.name + ']'
         ELSE 'ALTER SERVER ROLE [sysadmin]  ADD MEMBER ' + '[' + a.name + ']'
    END Command,
    CASE WHEN a.is_disabled = 1 THEN 'Login desabilitado'
         ELSE 'Login habilitado'
    END Status
 FROM
    sys.server_principals a
    JOIN master..syslogins b ON a.sid = b.sid
 WHERE
    a.type <> 'R'
    AND b.sysadmin = 1
    AND a.name NOT LIKE '##%'
 ORDER BY
    b.sysadmin;