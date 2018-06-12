create table #rh_interior (grupo varchar(500), usuario varchar(200), member varchar(500))
insert #rh_interior
exec sp_helprolemember 'CADASTRO'
declare @usuario varchar(192)
declare curBorderos cursor 
for
select distinct usuario from #rh_interior order by usuario
open curBorderos
fetch next from curBorderos into @usuario
while	@@fetch_status = 0
begin
	exec sp_addrolemember 'SIGVidas – Atendentes', @usuario -- adicionar no grupo
    --exec sp_droprolemember 'CADASTRO', @usuario -- retirar do grupo
	fetch next from curBorderos into @usuario
end
close curBorderos
deallocate curBorderos