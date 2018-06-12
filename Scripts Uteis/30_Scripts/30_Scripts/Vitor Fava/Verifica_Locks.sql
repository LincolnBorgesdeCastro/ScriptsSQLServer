--Verificar Locks no banco de dados
SELECT 
CASE WHEN o.name IS NULL THEN 'INDX Row' ELSE o.name END as table_name, 
resource_associated_entity_id, request_mode, request_type, request_status, 
request_session_id, request_owner_type, request_owner_id, resource_type, resource_subtype, resource_database_id 
    FROM siopmcrp.sys.dm_tran_locks t LEFT OUTER JOIN siopmcrp.sys.sysobjects o ON 
t.resource_associated_entity_id = o.id
where request_mode in ('X','IX') and resource_type in ('OBJECT')--, 'KEY')  
and resource_database_id = DB_ID(DB_NAME()) ORDER BY request_session_id 
go
