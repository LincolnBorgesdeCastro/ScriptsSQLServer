declare @cmd varchar(8000)
declare @cmd1 varchar(8000)
declare @arquivo varchar(400)


set @arquivo = '\\israel\c$\Script_Publicadores.txt'

set @cmd = '
Dim objDMO
Dim objReplication
Dim objReplicationDatabase
Dim ObjTransactionalPublication
Dim fso
Dim ts

''Seta os valores numericos das propriedades do metodo script.
''O metodo script recebe as propriedades sempre em valor numerico,
''mas fica mais facil utilizar o nome
''da propriedade por clareza de programacao
''Leia no Books On Line no topico
''Script Method (Replication Objects) sobre outros parametros.
Const SQLDMORepScript_PublicationCreation=65536
Const SQLDMORepScript_InstallReplication=1048576
Const SQLDMORepScript_InstallPublisher=1024


Const SQLDMORepScript_PullSubscriptionCreation=262144 
Const SQLDMORepScript_ReplicationJobs=4194304 



''Cria um arquivo texto que vai receber os comandos T-SQL da replicacao.
set fso = CreateObject("Scripting.FileSystemObject")
Set ts = fso.CreateTextFile("' + @arquivo + '",True)

''Cria o objeto SQLDMO da replicacao e conecta no servidor de banco de dados
Set objDMO = CreateObject("SQLDMO.SQLServer")
objDMO.LoginSecure = True
''Substituir pelo nome do servidor
objDMO.Connect "' + @@servername + '"

''Gera o script de instalacao do Publisher e da instalacao da Replicacao.
''Perceba que o metodo Script recebe como parametro
''as constantes definidas no inicio do script.
''O mesmo comando poderia ser escrito
''ObjReplication.Script(1048576 or 1024)
Set objReplication = objDMO.Replication
''ts.write ObjReplication.Script(SQLDMORepScript_InstallPublisher or SQLDMORepScript_InstallReplication)

''Para cada banco de dados que possui replicacao,
''gera o comando T-SQL de criacao da publicacao e dos artigos
For Each ObjReplicationDatabase in ObjReplication.ReplicationDatabases
For Each ObjTransactionalPublication in objReplicationDatabase.TransPublications
''ts.write objTransactionalPublication.Script(SQLDMORepScript_PublicationCreation)
Next
Next




ts.write ObjReplication.Script(SQLDMORepScript_PullSubscriptionCreation or SQLDMORepScript_ReplicationJobs)




ts.Close '

if object_id('tempdb..##temp')>0 drop table ##temp

create table ##temp (linha varchar(8000))

insert into ##temp values (@cmd)


set @cmd1 = 'bcp "select linha from ##temp" queryout \\israel\Temp\temp.vbs -S -U -P -c -C raw'

exec master..xp_cmdshell @cmd1

set @cmd = 'cscript \\israel\Temp\temp.vbs'

exec master..xp_cmdshell @cmd

set @cmd1 = 'del \\israel\Temp\temp.vbs'

exec master..xp_cmdshell @cmd1


