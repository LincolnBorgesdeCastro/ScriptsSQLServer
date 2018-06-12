CREATE TABLE TbA (
     CdA int identity(1,1)  
,    DtA SmallDateTime not null
,    CdTop int
,    CdFrn int
)
go
alter table TbA add constraint pk_tbA primary key (CdA)
go

CREATE TABLE TbB (
     CdB int identity(1,1) 
,    CdObj int
,    CdFin int
,    CdA int     
)
alter table TbB add constraint pk_tbB primary key (CdB)
alter table TbB add constraint Fk_tbA_tbB Foreign key (CdA) references  TbA (CdA)
go

--alimenta tabela ** ainda não particionada
insert into TbA values ('20061231',1,1),('20071231',1,1),('20101231',1,1),('20121231',1,1)
insert into TbB values (1,1,1),(2,1,1),(3,1,1),(4,1,1)
go

-- Função de Partição
CREATE PARTITION FUNCTION Func_Part (SmallDateTime)
AS RANGE LEFT FOR VALUES ('20061231', '20071231', '20081231', '20091231', '20101231', '20111231') ;
go

-- Esquema de Partição
CREATE PARTITION SCHEME Sch_Part AS PARTITION Func_Part 
--TO ([PRIMARY], FG2007, FG2008, FG2009, FG2010, FG2011, FGD2011);
ALL TO ([PRIMARY])
go

-- X da questão  (particiona tabela já existente com registros)
ALTER TABLE TbB drop CONSTRAINT Fk_tbA_tbB;
go
ALTER TABLE TbA DROP CONSTRAINT pk_tbA WITH (MOVE TO Sch_Part(DtA))
GO
ALTER TABLE TbA ADD CONSTRAINT pk_tbA PRIMARY KEY(CdA,DtA) on Sch_Part(DtA)
GO
-- precisa incluir o campo dta na tabela b
--alter table TbB add constraint Fk_tbA_tbB Foreign key (CdA,DtB) references  TbA (CdA,DtA)
go

--mostra quantidade de registros por partition
SELECT OBJECT_NAME(p.object_id) as obj_name, p.index_id, p.partition_number,d.name, p.rows, a.type, a.filegroup_id 
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
left join sys.data_spaces d
ON d.data_space_id= a.filegroup_id
WHERE p.object_id = (OBJECT_ID(N'TbA'))
and p.index_id = 1
ORDER BY obj_name, p.index_id, p.partition_number;
go


drop table TbB
drop table TbA
go
drop PARTITION SCHEME Sch_Part
go
drop PARTITION FUNCTION Func_Part
