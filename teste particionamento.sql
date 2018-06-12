create partition function PartFunc (datetime) as
range right for values ('01/01/2005',
                        '01/01/2006', 
                        '01/01/2008',
                        '01/01/2009',
                        '01/01/2010',
                        '01/01/2011',
                        '01/01/2012',
                        '01/01/2013',
                        '01/01/2014',
                        '01/01/2015')



create partition scheme MyPartScheme as partition PartFunc all to ([PRIMARY]);

select * from sys.partition_schemes

--drop partition scheme MyPartScheme

create table lincoln(codigo int, descricao varchar(100), data datetime) on mypartscheme(data);

create table lincoln2(codigo int, descricao varchar(100), data datetime);

alter table lincoln2 on mypartscheme(data);

set nocount on
declare @month int, @day int
set @month = 1
set @day = 1
while @month <= 12
begin
 while @day <= 28 
 begin
  insert into dbo.lincoln3 (descricao, data) 
  values ( cast(@day as varchar(2)) + '/' +
           cast(@month as varchar(2)), 
           cast(@month as varchar(2)) + '-' + 
           cast(@day as varchar(2)) + '-' +
           cast(2004 + cast(@month as varchar(2)) as varchar(4)))

  set @day = @day + 1 
 end
 set @day = 1
 set @month = @month + 1
end

select * from sys.partitions 
where object_id = object_id('dbo.lincoln2')

declare @codigo int
set @codigo = (SELECT ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)))
insert into dbo.lincoln2 (codigo, descricao, data)
values (@codigo,'Second 2017', '01/01/2017')  

select * from lincoln2

/*Adicionando divizor(Limite)*/
alter partition function PartFunc() SPLIT RANGE ('01/01/2018')

/*Setando o proximo filegroup */
alter partition scheme MyPartScheme NEXT USED [second]

/*Removendo divizor(Limite)*/
alter partition function PartFunc() MERGE RANGE ('01/01/2017')

select * from lincoln3 order by codigo

/* update gerando numero aleatorio*/
update lincoln set codigo = (SELECT ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT))) 

/*Adição da pk de forma normal*/
alter table lincoln add constraint  pk_lincoln primary key(codigo) 

/*Deletando movendo para o schema de particionamento*/
/*****************************************************************************************/
alter table lincoln2 drop constraint  pk_lincoln2 with( MOVE TO MyPartScheme (data))

alter table lincoln2 add constraint Pk_lincoln2 primary key(codigo,data)
/*****************************************************************************************/

create table lincoln4(codigo int identity(1,1) not null , descricao varchar(100), data datetime not null) on mypartscheme(data);

create table lincoln5(codigo int identity(1,1) not null , descricao varchar(100), data datetime not null) on second;
alter table lincoln5 add constraint Pk_lincoln5 primary key(codigo,data)
--drop table lincoln4


alter table lincoln3 add constraint Pk_lincoln3 primary key(codigo,data)

select * from sys.partitions
where object_id = object_id('dbo.lincoln4')

/* A partição 13 vai ser transportada para a tabela lincoln4 q tem a mesma estrutura da tabela lincoln2
tambem estando no mesmo filegroup */
ALTER TABLE lincoln2 SWITCH PARTITION 13 TO lincoln4

ALTER TABLE lincoln2 SWITCH PARTITION 14 TO lincoln5

select * from lincoln2 order by data desc

select * from lincoln4

select * from lincoln5

SET IDENTITY_INSERT dbo.lincoln4 ON
SET IDENTITY_INSERT dbo.lincoln4 OFF


update lincoln4 set data = '01/01/2017'
where codigo = 1


ALTER TABLE lincoln4 SWITCH partition 13 TO lincoln2 partition 13

ALTER TABLE lincoln5 SWITCH partition 14 TO lincoln2 partition 14

alter table lincoln4 drop constraint pk_lincoln4 with (move to MyPartScheme(data))

alter table lincoln4 add constraint pk_lincoln4 primary key(codigo,data)


drop table lincoln6

create table lincoln6(codigo int identity(1,1) not null , descricao varchar(100), data datetime not null)
on MyPartScheme(data)

alter table lincoln6 drop Pk_lincoln6 
with (move to [primary])

alter table lincoln6 add constraint Pk_lincoln6 primary key(codigo,data) 
ON MyPartScheme(data)

alter table lincoln6 add constraint Pk_lincoln6 primary key(codigo)

CREATE CLUSTERED INDEX IX_DATA ON lincoln6 (codigo, data) 
ON MyPartScheme(data)

drop index IX_data on lincoln6

select * from sys.partitions
where object_id = object_id('dbo.lincoln6')
