
/*Retorna as tabelas e quantidade de operações*/
declare @DataInicial datetime2 = '2014-07-09 00:00:00.0000000';
declare @DataFinal   datetime2 = '2014-07-09 23:59:59.9999999';

Select object_name AS Tabelas, count(*)  as 'Operações'
From sys.fn_get_audit_file('\\Catar\Auditorias\ASSISTENCIA\IPASGO\*.sqlaudit', NULL, NULL)
Where sequence_number = 1
and DATEADD(hour, 3, event_time) >= @DataInicial and DATEADD(hour, 3, event_time) <= @DataFinal
and server_principal_name not in ('IPASGO\81084056299', 'sa', 'OperadorAdmin')
Group by object_name
Order By 2 DESC

/*Retorna os usuário e quantidades de operações*/
declare @DataInicial datetime2 = '2014-07-09 00:00:00.0000000';
declare @DataFinal   datetime2 = '2014-07-09 23:59:59.9999999';

With cte (OPERADOR, Operacoes) as
(
    Select coalesce((select NOME_Completo from dbo.operadores where NOME_Operador = replace(server_principal_name, 'IPASGO\', '')), server_principal_name) AS OPERADOR, count(*) as Operacoes
    From sys.fn_get_audit_file('\\Catar\Auditorias\ASSISTENCIA\IPASGO\*.sqlaudit', NULL, NULL)
    Where sequence_number = 1
    and DATEADD(hour, 3, event_time) >= @DataInicial and DATEADD(hour, 3, event_time) <= @DataFinal
    and server_principal_name not in ('IPASGO\81084056299', 'sa', 'OperadorAdmin')
		and lower(object_name) = 'receitas'

    Group by server_principal_name
)
Select OPERADOR, SUM(Operacoes) as 'Operações' from cte
Group by OPERADOR
Order By 2 DESC