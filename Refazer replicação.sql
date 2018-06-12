-- Alterações de tabelas, em produção, que fazem parte de replicação

-- Desabilitar o JOB que faz o RESUME
-- Este JOB executa de tempo em tempo e força a volta da sincronização
1) exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 0

-- Suspender o mirror
2) ALTER DATABASE IPASGO SET PARTNER SUSPEND

-- Tirar tabela da replicacao
-- Verificar se a tabela de LOG não está na replicação
3) Rodar script abaixo para localizar qual o publicador tem a(s) tabela(s) que será(ão) alterada(s)

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
-- Importante: se a tabela for muito grande fazer em horário mais tranquilo
-- select count(*) from sipe_ProgramasEspeciais
-- select count(*) from sipe_MotivosCancelamentos

-- Desabilitar a trigger que confere se a tabela está na replicação
5) disable trigger tr_SBDConferirReplicacao on database

6) -- Para os casos de exclusão de colunas deve-se:
	1. Atualizar em toda a tabela a coluna que será excluída, para que os seus valores sejam inseridos na tabela de LOG;
	2. Alterar a coluna para aceitar valor nulo na tabela de LOG;
	3. Excluir as triggers que NÃO estão no padrão que comporta tal alteração. Antes, verificar se não tem alguma implementação extra. Caso tenha, deve-se implementá-la na nova estrutura;
	4. Excluir a coluna da tabela principal;
	5. Criar as trigger de Delete e Update utilizando a up_SBDCriaTabelaLogTrigger(@NOME_Tabela, @DESC_Owner, @FLAG_SistemaFabrica(1=Sistemas da Fábrica, 0=Não são Sistemas da Fábrica), @FLAG_CriaTabelaLog(0=Não cria tabela de Log e cria as trigger de Delete e Update);
	6. Criar a trigger de Insert utilizando a up_SBDCriaTriggerInsert(@NOME_Tabela, @DESC_Owner)

7) --Fazer a(s) alteração(ões) na(s) tabela(s) principal e de LOG (database IPASGO e/ou SIGA).
-- Obs.: Para exclusão de coluna deve-se alterar a coluna para NULL na tabela de LOG

8) Excluir as triggers e recriá-las no modelo novo
up_SBDCriaTabelaLogTrigger scad_Testes,dbo,0,0

-- Habilitar a trigger
9) enable trigger tr_SBDConferirReplicacao on database

-- Habilitar o JOB que faz o RESUME para voltar a sincronizar
10) exec msdb.dbo.sp_update_job @job_name = "SBD - JOB RESUME", @enabled = 1

-- Voltando a sincronização
11) ALTER DATABASE IPASGO SET PARTNER RESUME

12) Alterar tabela no MAURITANIA (Database LOG, LOG_SIGA e LOG_SIFE)

13) Ir no Publicador e dar a carga inicial novamente.
Adcionar a tabela na replicação ir no Articles properties - para todas as tabelas
Marcar para levar os índices não closterizados - Copy nonclustered indexes, marcar true
Verificar no View Snapshot Agent Status se startou a criação do snapshot
Caso não startou ir no Reinitialize All Subscriptions
	Caso não deixe marcar a opção 'Generetion the new snapshot now' seguir os passos:
	1. Gerar o script do publicador
	2. Marcar a opção @immediate_sync = N'true' no script
	3. Salvar o script na pasta 'SBD_SubunidadeBancoDados\Assistencia\Scripts\Publicadores'
	4. Apagar o assinante e a publicação
	5. Executar o script no assistencia
	6. Abrir o script do assinante(DBReports e/ou Mauritania)
	7. Executar o script - executar a parte do Assistencia e do DBReports separados
	8. Alterar o usuário Owner do JOB do assinante para "SA"
	9. Ir no View Snapshot Agent Status e startar a criação do snapshot no publicador
Ir no(s) servidor(es) assinante(s) e startar a sincronização. View Synchronization Status