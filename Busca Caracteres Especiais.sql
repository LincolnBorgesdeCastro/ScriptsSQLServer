 DECLARE @posicao int, @string varchar(100);  

SET @posicao = 1;
SET @string = 'TATIANE ROCHA DE LINS MEREB';
WHILE @posicao <= DATALENGTH(@string)
   BEGIN
   SELECT ASCII(SUBSTRING(@string, @posicao, 1)),
      CHAR(ASCII(SUBSTRING(@string, @posicao, 1)))
   SET @posicao = @posicao + 1
   END;
GO


/******/



select NUMG_Operador, NOME_Completo
from Ipasgo.dbo.operadores 
where  nome_completo like '%[^a-zA-Z0-9_$ ''´#()º/:.-]%'
order by NOME_Completo



