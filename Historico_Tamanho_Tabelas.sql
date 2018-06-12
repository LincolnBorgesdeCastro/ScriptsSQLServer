

if object_id('Historico_Tamanho_Tabela') is not null
	drop table Historico_Tamanho_Tabela

if object_id('BaseDados') is not null
	drop table BaseDados

if object_id('Tabela') is not null
	drop table Tabela

if object_id('Servidor') is not null
	drop table Servidor

	
CREATE TABLE [dbo].[BaseDados](
	[Id_BaseDados] [int] IDENTITY(1,1) NOT NULL,
	[Nm_Database] [varchar](100) NULL
	 CONSTRAINT [PK_BaseDados] PRIMARY KEY CLUSTERED (Id_BaseDados)
) ON [PRIMARY]


CREATE TABLE [dbo].[Tabela](
	[Id_Tabela] [int] IDENTITY(1,1) NOT NULL,
	[Nm_Tabela] [varchar](1000) NULL,
 CONSTRAINT [PK_Tabela] PRIMARY KEY CLUSTERED ([Id_Tabela] ASC)
) ON [PRIMARY]


CREATE TABLE [dbo].[Servidor](
	[Id_Servidor] [smallint] IDENTITY(1,1) NOT NULL,
	[Nm_Servidor] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Servidor] PRIMARY KEY CLUSTERED ([Id_Servidor] ASC)
) ON [PRIMARY]

CREATE TABLE [dbo].[Historico_Tamanho_Tabela](
	[Id_Historico_Tamanho] [int] IDENTITY(1,1) NOT NULL,
	[Id_Servidor] [smallint] NULL,
	[Id_BaseDados] [int] NULL,
	[Id_Tabela] [int] NULL,
	[Nm_Drive] [char](1) NULL,
	[Nr_Tamanho_Total] [numeric](9, 2) NULL,
	[Nr_Tamanho_Dados] [numeric](9, 2) NULL,
	[Nr_Tamanho_Indice] [numeric](9, 2) NULL,
	[Qt_Linhas] [bigint] NULL,
	[Dt_Referencia] [date] NULL,
 CONSTRAINT [PK_Historico_Tamanho_Tabela] PRIMARY KEY CLUSTERED ([Id_Historico_Tamanho] ASC),
 CONSTRAINT FK_Id_Servidor FOREIGN KEY (Id_Servidor) REFERENCES Servidor(Id_Servidor),
 CONSTRAINT FK_Id_Tabela FOREIGN KEY (Id_Tabela) REFERENCES Tabela(Id_Tabela),
 CONSTRAINT FK_Id_BaseDados FOREIGN KEY (Id_BaseDados) REFERENCES BaseDados(Id_BaseDados)
) ON [PRIMARY]

GO
if object_id('vwTamanho_Tabela') is not null
	drop view vwTamanho_Tabela
GO
create view vwTamanho_Tabela
AS
select A.Dt_Referencia, B.Nm_Servidor, C.Nm_Database,D.Nm_Tabela ,A.Nm_Drive, A.Nr_Tamanho_Total, A.Nr_Tamanho_Dados,
	A.Nr_Tamanho_Indice, A.Qt_Linhas
from Historico_Tamanho_Tabela A
	join Servidor B on A.Id_Servidor = B.Id_Servidor
	join BaseDados C on A.Id_BaseDados = C.Id_BaseDados
	join Tabela D on A.Id_Tabela = D.Id_Tabela
	
GO
GO
if object_id('stpCarga_Tamanhos_Tabelas') is not null
	drop procedure stpCarga_Tamanhos_Tabelas
GO

Create proc [dbo].stpCarga_Tamanhos_Tabelas
as
	declare @Databases table(Id_Database int identity(1,1), Nm_Database varchar(120))

	declare @Total int, @i int, @Database varchar(120), @cmd varchar(8000);
	insert into @Databases(Nm_Database)
	select name
	from sys.databases
	where name not in ('master','model','tempdb') 
	and state_desc = 'online'	
						
	select @Total = max(Id_Database)
	from @Databases

	set @i = 1

	if object_id('tempdb..##Tamanho_Tabelas') is not null 
				drop table ##Tamanho_Tabelas
				
	CREATE TABLE ##Tamanho_Tabelas(
		Nm_Servidor VARCHAR(256),
		Nm_Database varchar(256),
		[Nm_Schema] [varchar](8000) NULL,
		[Nm_Tabela] [varchar](8000) NULL,
		[Nm_Index] [varchar](8000) NULL,
		Nm_Drive CHAR(1),
		[Used_in_kb] [int] NULL,
		[Reserved_in_kb] [int] NULL,
		[Tbl_Rows] [bigint] NULL,
		[Type_Desc] [varchar](20) NULL
	) ON [PRIMARY]

	while (@i <= @Total)
	begin

		IF EXISTS (SELECT NULL from @Databases  where Id_Database = @i) -- caso a database foi deletada da tabela @databases, não faz nada.
		BEGIN 
		
			select @Database = Nm_Database
			from @Databases
			where Id_Database = @i
			
			set @cmd = '
				insert into ##Tamanho_Tabelas
				select @@SERVERNAME 
					, '''+@Database + ''' Nm_Database, t.schema_name, t.table_Name, t.Index_name,
					(SELECT SUBSTRING(filename,1,1) 
					FROM [' + @Database + '].sys.sysfiles 
					WHERE fileid = 1),
				sum(t.used) as used_in_kb,
				sum(t.reserved) as Reserved_in_kb,
				--case grouping (t.Index_name) when 0 then sum(t.ind_rows) else sum(t.tbl_rows) end as rows,
				 max(t.tbl_rows)  as rows,
				type_Desc
				from (
					select s.name as schema_name, 
							o.name as table_Name,
							coalesce(i.name,''heap'') as Index_name,
							p.used_page_Count*8 as used,
							p.reserved_page_count*8 as reserved, 
							p.row_count as ind_rows,
							(case when i.index_id in (0,1) then p.row_count else 0 end) as tbl_rows, 
							i.type_Desc as type_Desc
					from 
						[' + @Database + '].sys.dm_db_partition_stats p
						join [' + @Database + '].sys.objects o on o.object_id = p.object_id
						join [' + @Database + '].sys.schemas s on s.schema_id = o.schema_id
						left join [' + @Database + '].sys.indexes i on i.object_id = p.object_id and i.index_id = p.index_id
					where o.is_Ms_shipped = 0 --and o.type_desc = ''user_Table'' 
				) as t
				group by t.schema_name, t.table_Name,t.Index_name,type_Desc
				--with rollup -- no sql server 2005, essa linha deve ser habilitada **********************************************
				--order by grouping(t.schema_name),t.schema_name,grouping(t.table_Name),t.table_Name,	grouping(t.Index_name),t.Index_name
				'

			EXEC(@cmd);
			/*print @cmd; -- para debbug
			print '
				##################################################################################
			'; -- para debbug*/
		END
		
		set @i = @i + 1
	end 

	INSERT INTO dbo.Servidor(Nm_Servidor)
	SELECT DISTINCT A.Nm_Servidor 
	FROM ##Tamanho_Tabelas A
		LEFT JOIN dbo.Servidor B ON A.Nm_Servidor = B.Nm_Servidor
	WHERE B.Nm_Servidor IS null
		
	INSERT INTO dbo.BaseDados(Nm_Database)
	SELECT DISTINCT A.Nm_Database 
	FROM ##Tamanho_Tabelas A
		LEFT JOIN dbo.BaseDados B ON A.Nm_Database = B.Nm_Database
	WHERE B.Nm_Database IS null
	
	INSERT INTO dbo.Tabela(Nm_Tabela)
	SELECT DISTINCT A.Nm_Tabela 
	FROM ##Tamanho_Tabelas A
		LEFT JOIN dbo.Tabela B ON A.Nm_Tabela = B.Nm_Tabela
	WHERE B.Nm_Tabela IS null	

	insert into dbo.Historico_Tamanho_Tabela(Id_Servidor,Id_BaseDados,Id_Tabela,Nm_Drive,Nr_Tamanho_Total,
				Nr_Tamanho_Dados,Nr_Tamanho_Indice,Qt_Linhas,Dt_Referencia)
	select B.Id_Servidor, D.Id_BaseDados, C.Id_Tabela ,UPPER(A.Nm_Drive),
			sum(Reserved_in_kb)/1024.00 [Reservado (KB)], 
			sum(case when Type_Desc in ('CLUSTERED','HEAP') then Reserved_in_kb else 0 end)/1024.00 [Dados (KB)], 
			sum(case when Type_Desc in ('NONCLUSTERED') then Reserved_in_kb else 0 end)/1024.00 [Indices (KB)],
			max(Tbl_Rows) Qtd_Linhas,
			CONVERT(VARCHAR, GETDATE() ,112)
						 
	from ##Tamanho_Tabelas A
		JOIN dbo.Servidor B ON A.Nm_Servidor = B.Nm_Servidor 
		JOIN dbo.Tabela C ON A.Nm_Tabela = C.Nm_Tabela
		JOIN dbo.BaseDados D ON A.Nm_Database = D.Nm_Database
			LEFT JOIN dbo.Historico_Tamanho_Tabela E ON B.Id_Servidor = E.Id_Servidor 
								AND D.Id_BaseDados = E.Id_BaseDados AND C.Id_Tabela = E.Id_Tabela 
								AND E.Dt_Referencia = CONVERT(VARCHAR, GETDATE() ,112)    
	where Nm_Index is not null	and Type_Desc is not NULL
		AND E.Id_Historico_Tamanho IS NULL 
	group by B.Id_Servidor, D.Id_BaseDados, C.Id_Tabela,UPPER(A.Nm_Drive), E.Dt_Referencia
GO

--Exec MONITOR.dbo.stpCarga_Tamanhos_Tabelas

/*

SELECT *
FROM vwTamanho_Tabela
ORDER BY Nr_Tamanho_Total desc


SELECT Nm_Database, Sum(Nr_Tamanho_Total)--/1024
FROM vwTamanho_Tabela
group by Nm_Database

*/
--truncate table Historico_Tamanho_Tabela