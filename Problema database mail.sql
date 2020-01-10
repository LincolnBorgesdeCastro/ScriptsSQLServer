-- Acessar o servidor com problema e matar o processo do database mail
--Após isso rode os scripts abaixo:
use msdb
go

EXECUTE msdb.dbo.sysmail_stop_sp

EXECUTE msdb.dbo.sysmail_start_sp 



/**/

use msdb
go


select * from msdb.dbo.sysmail_allitems
where sent_status = 'unsent'
--where sent_status <> 'sent'

--where sent_status = 'failed'

SELECT items.subject,  
    items.last_mod_date  
    ,l.description FROM dbo.sysmail_faileditems as items  
INNER JOIN dbo.sysmail_event_log AS l  
    ON items.mailitem_id = l.mailitem_id  
WHERE items.recipients LIKE '%XXX%'    
    OR items.copy_recipients LIKE '%XXX%'   
    OR items.blind_copy_recipients LIKE '%XXX%'  
GO  
