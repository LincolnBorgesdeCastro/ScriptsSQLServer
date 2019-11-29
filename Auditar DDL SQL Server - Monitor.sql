------------------------------------------------------------------
-- Como auditar comandos DDL no SQL Server
------------------------------------------------------------------

-- Banco de MONITOR
use master
go

--drop database MONITOR;
if db_id('MONITOR') is null
begin
	CREATE DATABASE MONITOR;
	
	ALTER DATABASE MONITOR SET RECOVERY SIMPLE;
	ALTER DATABASE [MONITOR] SET trustworthy ON;
end

Use MONITOR

-- Tabela para guardar dados de auditoria
if object_id('SBD_audit_ddl') is not null drop table SBD_audit_ddl
create table MONITOR.dbo.SBD_audit_ddl (
    id_alteracao int identity(1, 1) not null,
    dt_alteracao datetime2 not null,
    nr_spid int null,
    nm_computador sysname null,
    ds_ip varchar(50) null,
    nm_login sysname null,
    nm_banco sysname null,
    ds_tipo_evento varchar(50) null,
    nm_objeto sysname null,
    ds_tipo_objeto varchar(50) null,
    ds_sql varchar(max) null,   
    constraint pk_adm_audit_ddl primary key (dt_alteracao, id_alteracao))
go
 

use ipasgo
go
 
-- Trigger para gerar dados de auditoria, registrada no banco que queremos auditar, no caso o banco curso
if exists (select 1 from sys.server_triggers where name = 'tr_SBDAlteracoesBD') drop trigger tr_SBDAlteracoesBD on all server
go

create trigger tr_SBDAlteracoesBD on all server for
    -- obs: é possível selecionar eventos individuais ou todos os eventos, como fiz nesse exemplo
    /*ddl_database_level_events*/
    DDL_PROCEDURE_EVENTS, --create_procedure, alter_procedure, drop_procedure, 
	DDL_ASSEMBLY_EVENTS,DDL_CERTIFICATE_EVENTS, DDL_MASTER_KEY_EVENTS, DDL_PARTITION_SCHEME_EVENTS, DDL_TYPE_EVENTS,
	DDL_PLAN_GUIDE_EVENTS, DDL_RULE_EVENTS, DDL_SEARCH_PROPERTY_LIST_EVENTS,DDL_SERVICE_EVENTS, DDL_SYNONYM_EVENTS,
    DDL_TABLE_EVENTS,--create_table, alter_table, drop_table, 
    DDL_FUNCTION_EVENTS, --create_function, alter_function, drop_function,
    DDL_VIEW_EVENTS,--create_view, alter_view, drop_view,
	DDL_SERVER_LEVEL_EVENTS,
	DDL_SEQUENCE_EVENTS,
	DDL_TRIGGER_EVENTS

as
    set nocount on
    set arithabort on
    -- salvar evento (convertendo o XML para lowercase, pois o método value é case-sensitive, e não queremos nos preocupar com isso)
    declare @ds_dados_evento xml = lower(cast(eventdata() as varchar(max)))

	if IsNull(upper(@ds_dados_evento.value('(/event_instance/databasename)[1]', 'sysname')), '') in ('', 'IPASGO', 'SIGA', 'CONTAS_PAGAR', 'PRESTADORES')

    insert into MONITOR.dbo.SBD_audit_ddl (dt_alteracao, nr_spid, nm_computador,  ds_ip, nm_login, nm_banco, ds_tipo_evento, nm_objeto, ds_tipo_objeto, ds_sql)
        select
            sysdatetime(),
            @@spid, -- identificador da conexão
            host_name(), -- nome da máquina do cliente
            cast (connectionproperty('client_net_address') as varchar(300)), -- ip
            Original_login(), -- login
            upper(@ds_dados_evento.value('(/event_instance/databasename)[1]', 'sysname')),
            @ds_dados_evento.value('(/event_instance/eventtype)[1]', 'varchar(50)'), 
            @ds_dados_evento.value('(/event_instance/objectname)[1]', 'sysname'), 
            @ds_dados_evento.value('(/event_instance/objecttype)[1]', 'varchar(50)'), 
            @ds_dados_evento.value('(/event_instance/tsqlcommand/commandtext)[1]', 'varchar(max)')
go 
 
 
--------------------------------------------------
-- Testando a auditoria
--------------------------------------------------
-- Testes da trigger e do log
/*
truncate table teste
create table teste (id int, nome varchar(100))
alter table teste add nm varchar(100)
drop table teste
create table amigos (nm varchar(100), email varchar(200), telefone varchar(15))
alter table amigos drop column telefone
drop table amigos
create procedure up_teste as select 1
drop procedure up_teste 

-- Listando eventos registrados
select * from MONITOR.dbo.SBD_audit_ddl
select * from MONITOR.dbo.SBD_audit_ddl where nm_login like '%81084056199%'
 
 alter role [siga - supervisor] add member [86273795134]
 alter role [siga - supervisor] drop member [86273795134]
-- Excluindo dados de teste
--drop database MONITOR
*/