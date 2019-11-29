
Select Name, Type_desc
from sys.sql_logins
where len([dbo].[fn_ObterNumString](cast(name as varchar))) <> 11
And is_disabled = 0
And name not like 'USR_%'
And name not like 'DPCW%'
And name not in ('sa', 'OperadorAdmin', 'operadores', 'DBA', 'dw', 'guest', 'lincoln', 'usuario_bi', 'ruber', 'marcelo', 'helder', 'distributor_admin', 'Cassio', 'Shellen')

