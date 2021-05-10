--Set mail item id you want to re send
DECLARE @mailitemID INT = 2355174 -- MailItem_Id here e.g 2041
 
DECLARE @profilename NVARCHAR(128);
DECLARE @recipients VARCHAR(MAX);
DECLARE @copy_recipients VARCHAR(MAX);
DECLARE @blind_copy_recipients VARCHAR(MAX);
DECLARE @subject NVARCHAR(510);
DECLARE @body VARCHAR(MAX);
DECLARE @body_format VARCHAR(20);
DECLARE @importance VARCHAR(6);
DECLARE @sensitivity VARCHAR(12);
DECLARE @query BIT;
DECLARE @attachment BIT;
 
--Get the information for the email
SELECT
@profilename = [profiles].[name],
@recipients = [mail].[recipients],
@copy_recipients = [mail].[copy_recipients],
@blind_copy_recipients = [mail].[blind_copy_recipients],
@subject = [mail].[subject],
@body = [mail].[body],
@body_format = [mail].[body_format],
@importance = [mail].[importance] ,
@sensitivity = [mail].[sensitivity],
@query = CASE WHEN [mail].[query] IS NULL THEN 0 ELSE 1 END,
@attachment = CASE WHEN [mail].[file_attachments] IS NULL THEN 0 ELSE 1 END
FROM msdb.dbo.sysmail_allitems mail
INNER JOIN msdb.dbo.sysmail_profile profiles ON mail.profile_id = profiles.profile_id
WHERE mailitem_id = @mailitemID;
 
IF @query = 0 AND @attachment = 0
BEGIN
 
--Re send the email
EXEC msdb.dbo.sp_send_dbmail
@profile_name = @profilename,
@recipients = @recipients,
@copy_recipients = @copy_recipients,
@blind_copy_recipients = @blind_copy_recipients,
@subject = @subject,
@body = @body,
@body_format = @body_format,
@importance = @importance,
@sensitivity = @sensitivity
 
END
ELSE
BEGIN
RAISERROR('The mailitem_id specified (%d) uses a query or attachments, unfortunately this script cannot send your email',11,0,@mailitemID)
END