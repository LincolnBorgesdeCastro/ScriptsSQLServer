exec msdb.dbo.sysmail_stop_sp

exec msdb.dbo.sysmail_start_sp

select * from sysmail_unsentitems

select * from sysmail_faileditems



EXEC msdb.dbo.sysmail_help_status_sp


SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb'

SELECT items.subject,
    items.last_mod_date
    ,l.description ,*
FROM msdb.dbo.sysmail_faileditems as items
INNER JOIN msdb.dbo.sysmail_event_log AS l
    ON items.mailitem_id = l.mailitem_id
WHERE items.last_mod_date > getdate()-7
