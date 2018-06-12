--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- SOLUÇÃO COM TABELA TEMPORÁRIA
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IF OBJECT_ID('TEMPDB..#tabelas') > 0 DROP TABLE #tabelas
select name into #tabelas from sysobjects where xtype = 'u' 

IF OBJECT_ID('TEMPDB..#tabelaNlog') > 0 DROP TABLE #tabelaNlog
create table #tabelaNlog (nome varchar(50))

IF OBJECT_ID('TEMPDB..#temlog') > 0 DROP TABLE #temlog
create table #temlog(tname varchar(50), towner  varchar(50), isup int, isdel int, isinsert int,
isafter int, isinstead int)

declare @name varchar(50)
set rowcount 1
select @name=name from #tabelas

while @@rowcount <> 0
begin
	set rowcount 0
	truncate table #temlog
	insert into #temlog
	exec sp_helptrigger @name
	if @@rowcount = 0
	begin
		print @name
		insert into #tabelaNlog values (@name)
	end
	delete #tabelas where name = @name
	set rowcount 1
	select @name=name from #tabelas
end
set rowcount 0

select * from #tabelaNlog