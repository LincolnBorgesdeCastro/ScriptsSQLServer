-- Altera��es de tabelas, em produ��o, que fazem parte de replica��o

-- Desabilitar o JOB que faz o RESUME
-- Este JOB executa de tempo em tempo e for�a a volta da sincroniza��o
1) exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

-- Suspender o mirror
2) ALTER DATABASE IPASGO SET PARTNER SUSPEND

-- Tirar tabela da replicacao
-- Verificar se a tabela de LOG n�o est� na replica��o
3) Rodar script abaixo para localizar qual o publicador tem a(s) tabela(s) que ser�(�o) alterada(s)

use distribution
select distinct
      M.article,
      M.publication_id,
      S.publication,
      X.publisher_db
from MSarticles M
inner join MSpublications  S on M.publication_id =S.publication_id
inner join MSsubscriptions X on X.publication_id =S.publication_id
where M.article like 'sipe_ProgramasEspeciais'
use ipasgo

4) Ir no publicador e retirar a(s) tabela(s).
-- Importante: se a tabela for muito grande fazer em hor�rio mais tranquilo
-- select count(*) from sipe_ProgramasEspeciais
-- select count(*) from sipe_MotivosCancelamentos

-- Desabilitar a trigger que confere se a tabela est� na replica��o
5) disable trigger tr_SBDConferirReplicacao on database

6) -- Para os casos de exclus�o de colunas deve-se:
	1. Atualizar em toda a tabela a coluna que ser� exclu�da, para que os seus valores sejam inseridos na tabela de LOG;
	2. Alterar a coluna para aceitar valor nulo na tabela de LOG;
	3. Excluir as triggers que N�O est�o no padr�o que comporta tal altera��o. Antes, verificar se n�o tem alguma implementa��o extra. Caso tenha, deve-se implement�-la na nova estrutura;
	4. Excluir a coluna da tabela principal;
	5. Criar as trigger de Delete e Update utilizando a up_SBDCriaTabelaLogTrigger(@NOME_Tabela, @DESC_Owner, @FLAG_SistemaFabrica(1=Sistemas da F�brica, 0=N�o s�o Sistemas da F�brica), @FLAG_CriaTabelaLog(0=N�o cria tabela de Log e cria as trigger de Delete e Update);
	6. Criar a trigger de Insert utilizando a up_SBDCriaTriggerInsert(@NOME_Tabela, @DESC_Owner)

7) --Fazer a(s) altera��o(�es) na(s) tabela(s) principal e de LOG (database IPASGO e/ou SIGA).
-- Obs.: Para exclus�o de coluna deve-se alterar a coluna para NULL na tabela de LOG

8) Excluir as triggers e recri�-las no modelo novo
up_SBDCriaTabelaLogTrigger scad_Testes,dbo,0,0

-- Habilitar a trigger
9) enable trigger tr_SBDConferirReplicacao on database

-- Habilitar o JOB que faz o RESUME para voltar a sincronizar
10) exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1

-- Voltando a sincroniza��o
11) ALTER DATABASE IPASGO SET PARTNER RESUME

12) Alterar tabela no MAURITANIA (Database LOG, LOG_SIGA e LOG_SIFE)

13) Ir no Publicador e dar a carga inicial novamente.
Adcionar a tabela na replica��o ir no Articles properties - para todas as tabelas
Marcar para levar os �ndices n�o closterizados - Copy nonclustered indexes, marcar true
Verificar no View Snapshot Agent Status se startou a cria��o do snapshot
Caso n�o startou ir no Reinitialize All Subscriptions
	Caso n�o deixe marcar a op��o 'Generetion the new snapshot now' seguir os passos:
	1. Gerar o script do publicador
	2. Marcar a op��o @immediate_sync = N'true' no script
	3. Salvar o script na pasta 'SBD_SubunidadeBancoDados\Assistencia\Scripts\Publicadores'
	4. Apagar o assinante e a publica��o
	5. Executar o script no assistencia
	6. Abrir o script do assinante(DBReports e/ou Mauritania)
	7. Executar o script - executar a parte do Assistencia e do DBReports separados
	8. Alterar o usu�rio Owner do JOB do assinante para "SA"
	9. Ir no View Snapshot Agent Status e startar a cria��o do snapshot no publicador
Ir no(s) servidor(es) assinante(s) e startar a sincroniza��o. View Synchronization Status