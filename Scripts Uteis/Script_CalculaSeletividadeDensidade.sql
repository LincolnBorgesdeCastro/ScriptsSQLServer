/* Este scripts permite identificar a coluna mais �ndicada a ser tornar chave ou �ndice
cluster em uma tabela. 
Quanto mais pr�ximo de 1 for a seletividade, melhor � a coluna

*/

*** O nome do campo a ser analizado. Neste caso StatusPausa
*** Alterar nome da tabela. Neste caso authors

select  [Qtde. Registros] = count(*), 
	[Reg. Distintos] = count(distinct StatusPausa),
	[Seletividade (quanto > melhor)] = count(distinct StatusPausa)/cast( count(*) as dec(8,2)),
        [Densidade/Duplicidade (quanto < melhor)]= 1/cast(count(distinct StatusPausa)as dec (8,2))
from authors