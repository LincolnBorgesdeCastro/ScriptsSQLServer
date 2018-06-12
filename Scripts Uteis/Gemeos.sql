/*
1067630-04	MARCELO AFONSO BATISTA
1067630-05	MARCIEL AFONSO BATISTA


select * From gv_Clientes where nums_matricula = 1051393
select * From Usuarios where nums_matricula = 1051393
select * From gv_Pessoas where numg_pessoa = 502801

select * from gv_pessoas where desc_nome = 'JOSE VICENTE LOPES'
*/

declare @numg_matricula int
declare @numg_pessoa int

set @numg_matricula = 320811

insert into gv_pessoas (
	desc_nome,	
	numr_cpf,
	numg_estadocivil,
	NUMG_CidadeNaturalidade,
	desc_sexo,
	DATA_Nascimento,
	DESC_NomeMae,
	NUMG_OperadorInclusao,
	data_inclusao,
	FLAG_Exclusao,
	FLAG_AlteraDados	)
select 
	NOME_usuario,
	NUMR_cpf,
	case when NUMG_estadoCivil = 8 then 1 else NUMG_estadoCivil end as numg_estadoCivil,
	case when NUMG_cidadeNaturalidade = 10979 then 2174 else isnull(NUMG_cidadeNaturalidade,2174) end as NUMG_cidadeNaturalidade,
	DESC_sexo,
	DATA_nascimento,
	isnull(NOME_mae,'') as nome_mae,
	NUMG_operadorInclusao,
	DATA_inclusao,
	0 as flag_exclusao,
	isnull(FLAG_AlteraDadosPessoais, 0)
from usuarios
where numg_matricula = @numg_matricula

select @numg_pessoa = scope_identity()




--select * from gv_pessoas where desC_nome = 'MARCELA SCHINDEL COSTA'

--begin tran
update gv_clientes set numg_pessoa = @numg_pessoa where numg_matricula = @numg_matricula
--commit


Insert dbo.gv_DnePessoa (
	Numg_Pessoa,
	Numr_Cep,
	Numg_TipoLogradouro,
	Desc_Logradouro,
	Desc_Complemento,
	Numg_Cidade,
	Desc_Bairro,
	Numg_DneStatus,
	Flag_Exclusao)
Select 
	Pes.Numg_Pessoa,
	Numr_Cep,
	Numg_TipoLogradouro,
	Desc_Logradouro,
	Desc_Complemento,
	Cid.Numg_Cidade,
	Dne.Desc_Bairro,
	Status = Case When Numr_Dne = 0 Then 2 Else 1 End,
	0 Exclui
From 
	dbo.sv_DneUsuarios Dne
	Inner Join dbo.gv_Clientes Cli On Dne.Numg_Matricula = Cli.Numg_Matricula
	Inner Join dbo.gv_Pessoas  Pes On Cli.Numg_Pessoa = Pes.Numg_Pessoa
	Inner Join dbo.dne_Estados Est On Dne.Sigl_Uf = Est.Desc_SiglaUf
	Inner Join dbo.dne_Cidades Cid On Dne.Desc_Localidade = Cid.Desc_Cidade And Est.Numg_Uf = Cid.Numg_Uf
	Left Join dbo.dne_TiposLogradouro Tip On Dne.Desc_Tipo = Tip.Desc_TipoLogradouro
where cli.numg_matricula = @numg_matricula
