sp_adduser [operadorteste]
grant create role to [operador]

----------------------------------------
sp_addsrvrolemember @loginame = N'operador', @rolename = N'securityadmin'

use master
go
grant alter any login to [operador]
go

use ipasgo
go
sp_adduser operador
go



grant create role to [operador]
go
grant alter any user to [operador]
go
---------------------
use siga
go
sp_adduser operador
go 
grant create role to [operador]
go
grant alter any user to [operador]
go
---------------------
use contas_pagar
go
sp_adduser operador
go
grant create role to [operador]
go
grant alter any user to [operador]
go






grant create role to [operador]