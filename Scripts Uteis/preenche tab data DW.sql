--select min(data_adesao) from gv_clientes 
--where datepart(year,data_adesao) > '1952'
--
--
--select * from dw.dbo.dim_tempo


declare @data datetime

set @data = '1950-01-01'

while @data < '2001-07-01'
begin
	insert into dim_tempo (data_completa) values (@data)
	print @data
	set @data = dateadd(dd, 1, @data)
end


update dim_tempo 
set dia_semana = datepart (dw,data_completa) , nome_diasemana = case when datepart (dw,data_completa) = 1 then 'Domingo'
																	 when datepart (dw,data_completa) = 2 then 'Segunda-Feira'
																	 when datepart (dw,data_completa) = 3 then 'Terca-Feira'
																	 when datepart (dw,data_completa) = 4 then 'Quarta-Feira'
																	 when datepart (dw,data_completa) = 5 then 'Quinta-Feira'
																	 when datepart (dw,data_completa) = 6 then 'Sexta-Feira' 
																	 when datepart (dw,data_completa) = 7 then 'Sabado' end
where dia_semana is null

-----------------------

update dim_tempo 
set dia_mes = datepart (dd,data_completa),
	mes = case when datepart (m,data_completa) = 1 then 'Janeiro'
			 when datepart (m,data_completa) = 2 then 'Fevereiro'
			 when datepart (m,data_completa) = 3 then 'Marco'
			 when datepart (m,data_completa) = 4 then 'Abril'
			 when datepart (m,data_completa) = 5 then 'Maio'
			 when datepart (m,data_completa) = 6 then 'Junho' 
			 when datepart (m,data_completa) = 7 then 'Julho'
			 when datepart (m,data_completa) = 8 then 'Agosto'
			 when datepart (m,data_completa) = 9 then 'Setembro'
			 when datepart (m,data_completa) = 10 then 'Outubro'
			 when datepart (m,data_completa) = 11 then 'Novembro'
			 when datepart (m,data_completa) = 12 then 'Dezembro' end,
	ano = datepart (yy,data_completa)
from dim_tempo where semestre is null
	

update dim_tempo
set trimestre = case when datepart (m,data_completa) in (1,2,3) then 1
					 when datepart (m,data_completa) in (4,5,6) then 2
					 when datepart (m,data_completa) in (7,8,9) then 3
					 when datepart (m,data_completa) in (10,11,12) then 4 end,
	semestre = case when datepart (m,data_completa) in (1,2,3,4,5,6) then 1
					 when datepart (m,data_completa) in (7,8,9,10,11,12) then 2 end
where semestre is null


update dim_tempo
set Numero_mesAno = datepart (m,data_completa)
where numero_semanaAno is null

-----------------------

declare @cont int
declare @data datetime
declare @ano int


set @cont = 1
set @data = '1950-01-01 00:00:00.000'
set @ano = datepart (year, @data)

while datepart (year, @data) <> 2001 or datepart (month, @data) <> 07
begin
	update dim_tempo
		set numero_diaAno = @cont
	where data_completa = @data
	
	set @cont = @cont + 1

	set @data = dateadd(dd, 1, @data)
	if @ano <> datepart (year, @data)
	begin
		set @cont = 1
		set @ano = datepart (year, @data)
	end
end





------------------------

declare @cont int
declare @data datetime
declare @ano int


set @cont = 1
set @DATA = '1950-01-01 00:00:00.000'
set @ano = datepart (year, @data)

while datepart (year, @data) <> 2001 or datepart (month, @data) <> 07
begin
	

	update dim_tempo
		set numero_semanaAno = @cont
	where data_completa = @data
	
	if datepart (dw, @data) = 7
		set @cont = @cont + 1

	set @data = dateadd(dd, 1, @data)

	if @ano <> datepart (year, @data)
	begin
		set @cont = 1
		set @ano = datepart (year, @data)
	end


end





select * from dim_tempo

drop table dim_tempo2