SQL Server 2012: Emergência de senha

Caso ocorra algum imprevisto e você esqueça a senha do SQL Server, há outras formas de retornar ao sistema.
Saleem Hakani

Você é um orgulho e um DBA confiável em sua organização. Você é responsável pela manutenção e atualização de diversos serviços importantes em execução em servidores SQL em seu ambiente de produção. Você decidiu realizar as etapas a seguir — que são as melhores práticas levaria qualquer DBA sólido — para proteger sua empresa do servidores SQL de qualquer acesso não autorizado:

    Você removeu a contas de administrador interna todas de logons do SQL Server.
    Você removeu todos os usuários (exceto o administrador do sistema ou SA) que faziam parte da função de servidor SYSADMIN (incluindo qualquer logons de contas do Windows e SQL Server).
    Você definiu a senha da conta SA como algo extremamente complexo que seria difícil para alguém adivinhar ou lembrar.
    Para as operações diárias no SQL Server, você pode usar sua conta de usuário de domínio, que tem permissões de banco de dados proprietário (DBO) em bancos de dados do usuário, mas não tem privilégios SYSADMIN no sistema.
    Você ainda não documentado a senha do SA em qualquer lugar para impedir que outros o sabê-lo. Afinal, não é uma boa prática para documentar a senha.

Porque você definir a senha SA ser tão complexa — e você estiver usando sua conta de domínio e não a conta SA para todos os seu banco de dados-relacionados atividade diária no SQL Server — o impensável aconteceu. Você esqueceu sua senha do SQL Server SA.

Você era a única pessoa que sabia a senha do SA em sua equipe. Agora você não se lembra o que era e você precisará fazer algumas alterações de configuração no servidor-nível para suas caixas de SQL Server de produção. O que você vai fazer agora? Aqui estão algumas opções:

    Tente fazer login como SA com todas as senhas possíveis que você tem em sua mente.
    Procure a senha do SA no seu disco rígido de computador ou em seus e-mails (você pode ter armazenado em algum arquivo, que é uma má prática, mas pode ser útil).
    Tente restaurar o mestre de banco de dados de backup de banco de dados. Isso não vai ajudar a longo prazo, porque você ainda vai encontrar o mesmo problema, se você não se lembra a senha SA.
    Reconstruir o mestre banco de dados. Isso é apenas marginalmente úteis, como você vai perder todas as configurações de nível de servidor e de sistema e configurações, incluindo logins, permissões e quaisquer objetos de nível de servidor.
    Re-instalar o SQL Server 2012 e anexar todos os bancos de dados do usuário. Isso pode não funcionar, como você pode ter os mesmos problemas que você experimentaria com reconstruir o mestre de banco de dados.

Assuma todas suas tentativas de fazer logon sistema usando a senha SA falharam. Agora é hora de você chamar por reforços: serviços equipe de suporte de produto da Microsoft. Aqui está o que eles podem dizer-lhe fazer:

Este é um backdoor para SQL Server 2012 que irá ajudá-lo a acessar sua produção servidores SQL SYSADMIN. No entanto, isso significa que sua conta do Windows vai ter que ser um membro do grupo Administradores locais em servidores Windows que estão executando o SQL Server 2012 serviços.

SQL Server permite que qualquer membro de um grupo de administradores locais se conectar ao SQL Server com privilégios SYSADMIN.

Aqui estão os passos para assumir o controle de seu servidor de SQL 2012 como uma SA:
1. 	Inicie a instância do SQL Server 2012 usando o modo de usuário único no prompt de comando, lançando o prompt de comando como administrador. Você também pode iniciar o SQL Server 2012 usando configuração mínima, que também irá colocar o SQL Server no modo de usuário único.
2. 	No prompt de comando (executar como administrador), digite: SQLServr.Exe – m (ou SQLServr.exe – f) e iniciar o mecanismo de banco de dados do SQL Server 2012. Certifica-se de que você não fechar esta janela de prompt de comando. Você pode localizar o SQLServr.exe na pasta Binn do seu caminho ambiental. Se você não tiver uma pasta Binn de 2012 do SQL Server em seu caminho ambiental, você sempre pode navegar para a pasta Binn seu computador SQL Server 2012. Geralmente a pasta Binn está localizada em C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Binn >.
3. 	Uma vez o SQL Server 2012 serviço iniciado em modo de usuário único ou com configuração mínima, você pode agora abrir outra janela de linha de comando como administrador e use o comando SQLCMD no prompt de comando para se conectar à instância do SQL Server 2012:

              SQLCMD –S <Server_Name\Instance_Name>
    Example: SQLCMD –S "SALEEMHAKANI"
            

  	Você vai agora ser logado para SQL Server. Tenha em mente que você está conectado como um administrador na instância SALEEMHAKANI SQL Server 2012.
4. 	Uma vez que você está conectado ao SQL Server 2012 usando SQLCMD no prompt de comando, você tem a opção de criar uma nova conta e concedendo-lhe qualquer permissão de nível de servidor. Criar um novo logon no SQL Server 2012, chamado "Saleem_SQL" e, em seguida, adicione esta conta para a função de servidor de SA. Para criar um novo login no prompt de comando depois de executar a etapa 3, use o seguinte:

              1> CREATE LOGIN '<Login_Name>' with PASSWORD='<Password>'
    2> GO
            

  	Aqui está um exemplo:

              1>     CREATE LOGIN SQL_SALEEM WITH PASSWORD='$@L649$@m'
    2>     GO
            

  	Depois de criar o novo login "SQL_SALEEM", adicione este logon para a função de servidor de SA na instância do SQL Server 2012. Partir da mesma janela de prompt de comando, execute a seguinte instrução:

              1> SP_ADDSRVROLEMEMBER '<Login_Name>','SYSADMIN'
    2>go
            

  	Para adicionar um logon existente para a função de servidor SYSADMIN, execute o seguinte:

              1>     SP_ADDSRVROLEMEMBER '<LOGIN_NAME>','SYSADMIN'
    2>     GO
            

  	Aqui está um exemplo:

              1>     SP_ADDSRVROLEMEMBER SQL_SALEEM,'SYSADMIN'
    2>     GO
            

  	A operação anterior vai cuidar-se de conceder privilégios SYSADMIN para o login "SQL_SALEEM".
5. 	Uma vez que você já realizou com sucesso estas etapas, o próximo passo é parar e iniciar serviços do SQL Server usando opções de inicialização normal. Desta vez você não vai precisar – f ou – m.
6. 	Acessar o 2012 de SQL Server management studio. Você também poderia entrar prompt de comando usando a conta de "SQL_SALEEM" e sua respectiva senha. Agora você tem acesso de SA a instância do SQL Server 2012. Agora, você pode redefinir a senha SA e assumir o controle da sua produção de caixas de SQL Server.

É perfeitamente normal para esquecer a sua senha de vez em quando, mas isso não significa que ele é todo em menos de um aborrecimento. Estas etapas de emergência devem te funcionando sem demais lutando ou tempo de inatividade.