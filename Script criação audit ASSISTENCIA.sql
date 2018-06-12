USE [master]
GO

CREATE SERVER AUDIT [AUDT_IPASGO]
TO FILE 
(	FILEPATH = N'\\Catar\Auditorias\ASSISTENCIA\IPASGO\'
	,MAXSIZE = 1024 MB
	,MAX_ROLLOVER_FILES = UNLIMITED
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
	,AUDIT_GUID = 'f66e04c1-3716-48e7-afcb-094437c69e93'
)
WHERE ([Server_Principal_name]<>'IPASGO\81084056199')

ALTER SERVER AUDIT [AUDT_IPASGO] WITH (STATE = OFF)
GO




USE [IPASGO]
GO

create DATABASE AUDIT SPECIFICATION [DBAS_IPASGO] 
FOR SERVER AUDIT [AUDT_IPASGO]

ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_ContatosPessoa] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_Pessoas] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_DNEPessoa] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_DadosFinanceiros] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_DadosCartao] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_ContatosPessoa] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_DadosGeracaoCartao] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[gv_OrigensResponsaveis] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_Prestadores] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_EnderecosAtendimento] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_Enderecos] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_Contatos] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_ContatosEndereco] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_PessoasFisicas] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_PessoasJuridicas] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[pr_PrestadoresNaoCredenciados] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[cv_Usuarios] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[cv_UsuariosFuncionais] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[Fornecedores] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[rh_Colaboradores] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[RH_EndColaboradores] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[at_ResultadoClientes] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[cf_Credores] BY [dbo]),
ADD (INSERT, SELECT  ON OBJECT::[dbo].[cf_LancamentosOrdensPagamentos] BY [dbo])

GO



select * from [cf_Credores]

insert into [cf_Credores] (NUMG_Pessoa,NUMG_Fornecedor,NUMG_Prestador,NUMR_Identificador,NOME_Credor) 
values (697896,	NULL,	NULL,	9999999999,   	NULL)



