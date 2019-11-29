--ROMENIA
--DROP EVENT SESSION [DDLChanges] ON SERVER 
GO

CREATE EVENT SESSION [DDLChanges] ON SERVER 

ADD EVENT sqlserver.alwayson_ddl_executed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.assembly_load(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.database_attached(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.database_detached(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.hadr_ddl_failover_execution_state(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.object_altered(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
    WHERE ((((((((((((([package0].[not_equal_uint64]([database_id],(2))) AND ([package0].[not_equal_uint64]([database_id],(16)))) AND ([package0].[not_equal_uint64]([database_id],(17)))) AND ([package0].[not_equal_uint64]([database_id],(18)))) AND ([package0].[not_equal_uint64]([database_id],(24)))) AND ([package0].[not_equal_uint64]([database_id],(25)))) AND ([package0].[not_equal_uint64]([database_id],(26)))) AND ([package0].[not_equal_uint64]([database_id],(27)))) AND ([package0].[not_equal_uint64]([database_id],(28)))) AND ([package0].[not_equal_uint64]([database_id],(29)))) AND ([package0].[not_equal_uint64]([database_id],(13)))) AND ([package0].[not_equal_uint64]([database_id],(11)))) AND ([ddl_phase]=(1)))),

ADD EVENT sqlserver.object_created(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
    WHERE ((((((((((((([package0].[not_equal_uint64]([database_id],(2))) AND ([package0].[not_equal_uint64]([database_id],(16)))) AND ([package0].[not_equal_uint64]([database_id],(17)))) AND ([package0].[not_equal_uint64]([database_id],(18)))) AND ([package0].[not_equal_uint64]([database_id],(24)))) AND ([package0].[not_equal_uint64]([database_id],(25)))) AND ([package0].[not_equal_uint64]([database_id],(26)))) AND ([package0].[not_equal_uint64]([database_id],(27)))) AND ([package0].[not_equal_uint64]([database_id],(28)))) AND ([package0].[not_equal_uint64]([database_id],(29)))) AND ([package0].[not_equal_uint64]([database_id],(13)))) AND ([package0].[not_equal_uint64]([database_id],(11)))) AND ([ddl_phase]=(1)))),

ADD EVENT sqlserver.object_deleted(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
    WHERE ((((((((((((([package0].[not_equal_uint64]([database_id],(2))) AND ([package0].[not_equal_uint64]([database_id],(16)))) AND ([package0].[not_equal_uint64]([database_id],(17)))) AND ([package0].[not_equal_uint64]([database_id],(18)))) AND ([package0].[not_equal_uint64]([database_id],(24)))) AND ([package0].[not_equal_uint64]([database_id],(25)))) AND ([package0].[not_equal_uint64]([database_id],(26)))) AND ([package0].[not_equal_uint64]([database_id],(27)))) AND ([package0].[not_equal_uint64]([database_id],(28)))) AND ([package0].[not_equal_uint64]([database_id],(29)))) AND ([package0].[not_equal_uint64]([database_id],(13)))) AND ([package0].[not_equal_uint64]([database_id],(11)))) AND ([ddl_phase]=(1)))),

ADD EVENT sqlserver.server_memory_change(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.server_start_stop(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username))

ADD TARGET package0.event_file(SET filename=N'DDLChanges.xel',max_file_size=(200),max_rollover_files=(5))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO

/**********************************************************************************************************************************************************************************************/
/**********************************************************************************************************************************************************************************************/
/**********************************************************************************************************************************************************************************************/

-- NORTE

CREATE EVENT SESSION [DDLChanges] ON SERVER 

ADD EVENT sqlserver.alwayson_ddl_executed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.assembly_load(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.database_attached(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.database_detached(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.hadr_ddl_failover_execution_state(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.object_altered(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
	WHERE           ([package0].[not_equal_uint64]([database_id],(2)) AND [package0].[not_equal_uint64]([database_id],(13)) AND [package0].[not_equal_uint64]([database_id],(17)) AND [package0].[not_equal_uint64]([database_id],(18)) AND [package0].[not_equal_uint64]([database_id],(19)) AND [package0].[not_equal_uint64]([database_id],(25)) AND [package0].[equal_uint64]([ddl_phase],(1)) AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSADMIN') AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSRUNTIME') AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSLOG') 	AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'liferay_sql') AND [sqlserver].[client_app_name]=N'SQLAgent - TSQL JobStep (Job 0x96BBD141066C0D4ABCD9F4FADD34A664 : Step 1)')),

ADD EVENT sqlserver.object_created(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
	WHERE ([package0].[not_equal_uint64]([database_id],(2)) AND [package0].[not_equal_uint64]([database_id],(13)) AND [package0].[not_equal_uint64]([database_id],(17)) AND [package0].[not_equal_uint64]([database_id],(18)) AND [package0].[not_equal_uint64]([database_id],(19)) AND [package0].[not_equal_uint64]([database_id],(25)) AND [package0].[equal_uint64]([ddl_phase],(1)) AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSADMIN') AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSRUNTIME') AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'USR_OSLOG') AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[username],N'liferay_sql'))),

ADD EVENT sqlserver.object_deleted(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)
	WHERE ([package0].[not_equal_uint64]([database_id],(2)) AND [package0].[not_equal_uint64]([database_id],(13)) AND [package0].[not_equal_uint64]([database_id],(17)) AND [package0].[not_equal_uint64]([database_id],(18)) AND [package0].[not_equal_uint64]([database_id],(19)) AND [package0].[not_equal_uint64]([database_id],(25)) AND [package0].[equal_uint64]([ddl_phase],(1)) AND [sqlserver].[username]<>N'USR_OSADMIN' AND [sqlserver].[username]<>N'USR_OSRUNTIME' AND [sqlserver].[username]<>N'USR_OSLOG' AND [sqlserver].[username]<>N'liferay_sql')),

ADD EVENT sqlserver.server_memory_change(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username)),

ADD EVENT sqlserver.server_start_stop(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text,sqlserver.username))

ADD TARGET package0.event_file(SET filename=N'\\Catar\Auditorias\ASSISTENCIA\IPASGO\DDLChanges.xel',max_file_size=(200),max_rollover_files=(5))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO





/*

while getdate() <= DATEADD(mi,1, getdate())
begin
	create table teste_lincoln (id int)
	
	alter table teste_lincoln add nome varchar(20)
	
	alter table teste_lincoln drop column nome 
	
	drop table teste_lincoln 
end
create database db_lincoln
drop  database db_lincoln
*/
