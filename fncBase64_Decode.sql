Create FUNCTION [dbo].[fncBase64_Decode] (
    @string VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
with encryption
AS BEGIN
 
    DECLARE @decoded VARCHAR(MAX)
    SET @decoded = CAST('' AS XML).value('xs:base64Binary(sql:variable("@string"))', 'varbinary(max)')
 
    RETURN CONVERT(VARCHAR(MAX), @decoded)
    
END