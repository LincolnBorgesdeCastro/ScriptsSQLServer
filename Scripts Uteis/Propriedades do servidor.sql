SELECT SERVERPROPERTY('servername') As "Nome do Servidor",

SERVERPROPERTY('productversion') As Versão,

SERVERPROPERTY ('productlevel') As "Service Pack", 

SERVERPROPERTY ('edition') As Edição,

@@Version As "Sistema Operacional"