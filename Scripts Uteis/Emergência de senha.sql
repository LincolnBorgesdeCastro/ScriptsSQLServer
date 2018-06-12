SQL Server 2012: Emerg�ncia de senha

Caso ocorra algum imprevisto e voc� esque�a a senha do SQL Server, h� outras formas de retornar ao sistema.
Saleem Hakani

Voc� � um orgulho e um DBA confi�vel em sua organiza��o. Voc� � respons�vel pela manuten��o e atualiza��o de diversos servi�os importantes em execu��o em servidores SQL em seu ambiente de produ��o. Voc� decidiu realizar as etapas a seguir � que s�o as melhores pr�ticas levaria qualquer DBA s�lido � para proteger sua empresa do servidores SQL de qualquer acesso n�o autorizado:

    Voc� removeu a contas de administrador interna todas de logons do SQL Server.
    Voc� removeu todos os usu�rios (exceto o administrador do sistema ou SA) que faziam parte da fun��o de servidor SYSADMIN (incluindo qualquer logons de contas do Windows e SQL Server).
    Voc� definiu a senha da conta SA como algo extremamente complexo que seria dif�cil para algu�m adivinhar ou lembrar.
    Para as opera��es di�rias no SQL Server, voc� pode usar sua conta de usu�rio de dom�nio, que tem permiss�es de banco de dados propriet�rio (DBO) em bancos de dados do usu�rio, mas n�o tem privil�gios SYSADMIN no sistema.
    Voc� ainda n�o documentado a senha do SA em qualquer lugar para impedir que outros o sab�-lo. Afinal, n�o � uma boa pr�tica para documentar a senha.

Porque voc� definir a senha SA ser t�o complexa � e voc� estiver usando sua conta de dom�nio e n�o a conta SA para todos os seu banco de dados-relacionados atividade di�ria no SQL Server � o impens�vel aconteceu. Voc� esqueceu sua senha do SQL Server SA.

Voc� era a �nica pessoa que sabia a senha do SA em sua equipe. Agora voc� n�o se lembra o que era e voc� precisar� fazer algumas altera��es de configura��o no servidor-n�vel para suas caixas de SQL Server de produ��o. O que voc� vai fazer agora? Aqui est�o algumas op��es:

    Tente fazer login como SA com todas as senhas poss�veis que voc� tem em sua mente.
    Procure a senha do SA no seu disco r�gido de computador ou em seus e-mails (voc� pode ter armazenado em algum arquivo, que � uma m� pr�tica, mas pode ser �til).
    Tente restaurar o mestre de banco de dados de backup de banco de dados. Isso n�o vai ajudar a longo prazo, porque voc� ainda vai encontrar o mesmo problema, se voc� n�o se lembra a senha SA.
    Reconstruir o mestre banco de dados. Isso � apenas marginalmente �teis, como voc� vai perder todas as configura��es de n�vel de servidor e de sistema e configura��es, incluindo logins, permiss�es e quaisquer objetos de n�vel de servidor.
    Re-instalar o SQL Server 2012 e anexar todos os bancos de dados do usu�rio. Isso pode n�o funcionar, como voc� pode ter os mesmos problemas que voc� experimentaria com reconstruir o mestre de banco de dados.

Assuma todas suas tentativas de fazer logon sistema usando a senha SA falharam. Agora � hora de voc� chamar por refor�os: servi�os equipe de suporte de produto da Microsoft. Aqui est� o que eles podem dizer-lhe fazer:

Este � um backdoor para SQL Server 2012 que ir� ajud�-lo a acessar sua produ��o servidores SQL SYSADMIN. No entanto, isso significa que sua conta do Windows vai ter que ser um membro do grupo Administradores locais em servidores Windows que est�o executando o SQL Server 2012 servi�os.

SQL Server permite que qualquer membro de um grupo de administradores locais se conectar ao SQL Server com privil�gios SYSADMIN.

Aqui est�o os passos para assumir o controle de seu servidor de SQL 2012 como uma SA:
1. 	Inicie a inst�ncia do SQL Server 2012 usando o modo de usu�rio �nico no prompt de comando, lan�ando o prompt de comando como administrador. Voc� tamb�m pode iniciar o SQL Server 2012 usando configura��o m�nima, que tamb�m ir� colocar o SQL Server no modo de usu�rio �nico.
2. 	No prompt de comando (executar como administrador), digite: SQLServr.Exe � m (ou SQLServr.exe � f) e iniciar o mecanismo de banco de dados do SQL Server 2012. Certifica-se de que voc� n�o fechar esta janela de prompt de comando. Voc� pode localizar o SQLServr.exe na pasta Binn do seu caminho ambiental. Se voc� n�o tiver uma pasta Binn de 2012 do SQL Server em seu caminho ambiental, voc� sempre pode navegar para a pasta Binn seu computador SQL Server 2012. Geralmente a pasta Binn est� localizada em C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn >.
3. 	Uma vez o SQL Server 2012 servi�o iniciado em modo de usu�rio �nico ou com configura��o m�nima, voc� pode agora abrir outra janela de linha de comando como administrador e use o comando SQLCMD no prompt de comando para se conectar � inst�ncia do SQL Server 2012:

              SQLCMD �S <Server_Name\Instance_Name>
    Example: SQLCMD �S "SALEEMHAKANI"
            

  	Voc� vai agora ser logado para SQL Server. Tenha em mente que voc� est� conectado como um administrador na inst�ncia SALEEMHAKANI SQL Server 2012.
4. 	Uma vez que voc� est� conectado ao SQL Server 2012 usando SQLCMD no prompt de comando, voc� tem a op��o de criar uma nova conta e concedendo-lhe qualquer permiss�o de n�vel de servidor. Criar um novo logon no SQL Server 2012, chamado "Saleem_SQL" e, em seguida, adicione esta conta para a fun��o de servidor de SA. Para criar um novo login no prompt de comando depois de executar a etapa 3, use o seguinte:

              1> CREATE LOGIN '<Login_Name>' with PASSWORD='<Password>'
    2> GO
            

  	Aqui est� um exemplo:

              1>     CREATE LOGIN SQL_SALEEM WITH PASSWORD='$@L649$@m'
    2>     GO
            

  	Depois de criar o novo login "SQL_SALEEM", adicione este logon para a fun��o de servidor de SA na inst�ncia do SQL Server 2012. Partir da mesma janela de prompt de comando, execute a seguinte instru��o:

              1> SP_ADDSRVROLEMEMBER '<Login_Name>','SYSADMIN'
    2>go
            

  	Para adicionar um logon existente para a fun��o de servidor SYSADMIN, execute o seguinte:

              1>     SP_ADDSRVROLEMEMBER '<LOGIN_NAME>','SYSADMIN'
    2>     GO
            

  	Aqui est� um exemplo:

              1>     SP_ADDSRVROLEMEMBER SQL_SALEEM,'SYSADMIN'
    2>     GO
            

  	A opera��o anterior vai cuidar-se de conceder privil�gios SYSADMIN para o login "SQL_SALEEM".
5. 	Uma vez que voc� j� realizou com sucesso estas etapas, o pr�ximo passo � parar e iniciar servi�os do SQL Server usando op��es de inicializa��o normal. Desta vez voc� n�o vai precisar � f ou � m.
6. 	Acessar o 2012 de SQL Server management studio. Voc� tamb�m poderia entrar prompt de comando usando a conta de "SQL_SALEEM" e sua respectiva senha. Agora voc� tem acesso de SA a inst�ncia do SQL Server 2012. Agora, voc� pode redefinir a senha SA e assumir o controle da sua produ��o de caixas de SQL Server.

� perfeitamente normal para esquecer a sua senha de vez em quando, mas isso n�o significa que ele � todo em menos de um aborrecimento. Estas etapas de emerg�ncia devem te funcionando sem demais lutando ou tempo de inatividade.