select pre.nome_prestador, ce.desc_contato, b.desc_bairro, c.desc_cidade, ea.desc_logradouro, ea.desc_complemento, ea.desc_referencia
from   ipasgo.dbo.pr_enderecosatendimento ea
inner  join ipasgo.dbo.pr_contatosendereco ce on ea.numg_enderecoAtendimento = ce.numg_enderecoatendimento
inner  join ipasgo.dbo.pr_prestadores pre on ea.numg_prestador = pre.numg_prestador
inner  join ipasgo.dbo.bairros b on ea.numg_bairro = b.numg_bairro
inner  join ipasgo.dbo.dne_cidades c on b.numg_cidade = c.numg_cidade
where  pre.numg_prestador in (7002,1996,2142,797,1448,1402,
3966,2499,1862,1742,5314,3298,8354,6718,7019,7554,8432,8442,10015,10195,11212)
			 and ea.flag_correspondencia = 1
