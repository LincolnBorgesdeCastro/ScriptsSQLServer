

http://viacep.com.br/ws/74310250/xml/

http://viacep.com.br/ws/74310250/piped/

https://viacep.com.br/ws/74310250/json


exec stpConsulta_CEP '74310250'




alter PROCEDURE dbo.stpConsulta_CEP (
    @Nr_CEP VARCHAR(20)
)
AS BEGIN
 
    DECLARE 
        @obj INT,
        @Url VARCHAR(255),
        @resposta VARCHAR(8000),
        @xml XML
 
 
    SET @Url = 'http://viacep.com.br/ws/' + @Nr_CEP + '/xml/'
 
    EXEC sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @obj OUT
    EXEC sys.sp_OAMethod @obj, 'open', NULL, 'GET', @Url, FALSE
    EXEC sys.sp_OAMethod @obj, 'send'
    EXEC sys.sp_OAGetProperty @obj, 'responseText', @resposta OUT
    EXEC sys.sp_OADestroy @obj
 
    SET @xml = @resposta COLLATE SQL_Latin1_General_CP1251_CS_AS
 
    SELECT
        @xml.value('(/xmlcep/cep)[1]', 'varchar(9)') AS CEP,
        @xml.value('(/xmlcep/logradouro)[1]', 'varchar(200)') AS Logradouro,
        @xml.value('(/xmlcep/complemento)[1]', 'varchar(200)') AS Complemento,
        @xml.value('(/xmlcep/bairro)[1]', 'varchar(200)') AS Bairro,
        @xml.value('(/xmlcep/localidade)[1]', 'varchar(200)') AS Cidade,
        @xml.value('(/xmlcep/uf)[1]', 'varchar(200)') AS UF,
        @xml.value('(/xmlcep/ibge)[1]', 'varchar(200)') AS IBGE
 
END