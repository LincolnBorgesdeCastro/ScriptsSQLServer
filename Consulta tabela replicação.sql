

USE DISTRIBUTION
select
			'-- Data da Verificação: ' +
			space(5) + 'Nome da Tabela Replicada: '  +
			space(25) + 'Nome da Publicação: ' +
			space(5) + 'Banco da Publicação:' as linha

union all

select distinct
			'-- ' + convert(varchar(20), getDate(), 120) +
			space(7) + left(M.article + space(35), 35) +
			space(16) + left(S.publication + space(19), 19) + 
			space(6) + left(X.publisher_db + space(20), 20) as linha
from MSarticles M
inner join MSpublications  S on M.publication_id =S.publication_id
inner join MSsubscriptions X on X.publication_id =S.publication_id
where M.article like '%at_GuiasAltas%'


