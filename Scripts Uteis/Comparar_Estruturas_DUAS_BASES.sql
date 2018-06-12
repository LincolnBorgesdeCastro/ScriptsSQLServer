/*****************************************************************************************************************************************
 *
 * Author  Rafal Skotak
 * Purpose This procedure is supposed to compare selected databases options and objects and return found differences
 *         (it should compare databases structures)
 * Date    2008.08.19
 *
 ******************************************************************************************************************************************/


if object_id('dbo.proc_compare_databases', 'P') is not null
	drop procedure dbo.proc_compare_databases
go

create procedure dbo.proc_compare_databases
	@db_a sysname,
	@db_b sysname
as
begin
	set nocount on

	if @db_a is null
	begin
		raiserror('Database A name is null', 16, 1)
		return
	end

	if @db_b is null
	begin
		raiserror('Database B name is null', 16, 1)
		return
	end

	if db_id(@db_a) is null
	begin
		raiserror('Database A does not exist', 16, 1)
		return
	end

	if db_id(@db_b) is null
	begin
		raiserror('Database B does not exist', 16, 1)
		return
	end

	declare @command varchar(max)

	------------------------------------------------------------------------------------------------------------------
	-- compare databases options

	select 
		ra.compatibility_level,
		rb.compatibility_level,
		ra.collation_name,
		rb.collation_name,
		ra.user_access,
		rb.user_access,
		ra.user_access_desc,
		rb.user_access_desc,	
		ra.is_read_only,
		rb.is_read_only,
		ra.is_auto_close_on,
		rb.is_auto_close_on,
		ra.is_auto_shrink_on,
		rb.is_auto_shrink_on,
		ra.state,
		rb.state,
		ra.state_desc,
		rb.state_desc,
		ra.is_in_standby	,
		rb.is_in_standby,
		ra.is_supplemental_logging_enabled,
		rb.is_supplemental_logging_enabled,
		ra.snapshot_isolation_state,
		rb.snapshot_isolation_state,
		ra.snapshot_isolation_state_desc	,
		rb.snapshot_isolation_state_desc,
		ra.is_read_committed_snapshot_on,
		rb.is_read_committed_snapshot_on,
		ra.recovery_model,
		rb.recovery_model,
		ra.recovery_model_desc,
		rb.recovery_model_desc,
		ra.is_auto_create_stats_on	,
		rb.is_auto_create_stats_on,
		ra.is_auto_update_stats_on,
		rb.is_auto_update_stats_on,
		ra.is_ansi_null_default_on,
		rb.is_ansi_null_default_on,
		ra.is_ansi_nulls_on,
		rb.is_ansi_nulls_on,
		ra.is_ansi_padding_on,
		rb.is_ansi_padding_on,
		ra.is_ansi_warnings_on,
		rb.is_ansi_warnings_on,
		ra.is_arithabort_on,
		rb.is_arithabort_on,
		ra.is_concat_null_yields_null_on,
		rb.is_concat_null_yields_null_on,
		ra.is_numeric_roundabort_on,
		rb.is_numeric_roundabort_on,
		ra.is_quoted_identifier_on,
		rb.is_quoted_identifier_on,
		ra.is_recursive_triggers_on,
		rb.is_recursive_triggers_on,
		ra.is_cursor_close_on_commit_on,
		rb.is_cursor_close_on_commit_on,
		ra.is_local_cursor_default,
		rb.is_local_cursor_default,
		ra.is_fulltext_enabled,
		rb.is_fulltext_enabled,
		ra.is_broker_enabled,
		rb.is_broker_enabled
	from
	(
	select * from master.sys.databases where name = @db_a
	) as ra
	cross join
	(
	select * from master.sys.databases where name = @db_b
	) as rb
	where
		ra.compatibility_level <> rb.compatibility_level or
		ra.collation_name <> rb.collation_name or
		ra.user_access <> rb.user_access or
		ra.is_read_only <> rb.is_read_only or
		ra.is_auto_close_on <> rb.is_auto_close_on or
		ra.is_broker_enabled <> rb.is_broker_enabled or
		ra.is_fulltext_enabled <> rb.is_fulltext_enabled or
		ra.is_local_cursor_default <> rb.is_local_cursor_default or
		ra.is_cursor_close_on_commit_on <> rb.is_cursor_close_on_commit_on or
		ra.is_recursive_triggers_on <> rb.is_recursive_triggers_on or
		ra.is_quoted_identifier_on <> rb.is_quoted_identifier_on or
		ra.is_numeric_roundabort_on <> rb.is_numeric_roundabort_on or
		ra.is_concat_null_yields_null_on <> rb.is_concat_null_yields_null_on or
		ra.is_arithabort_on <> rb.is_arithabort_on or
		ra.is_ansi_warnings_on <> rb.is_ansi_warnings_on or
		ra.is_ansi_padding_on <> rb.is_ansi_padding_on or
		ra.is_ansi_nulls_on <> rb.is_ansi_nulls_on or
		ra.is_ansi_null_default_on <> rb.is_ansi_null_default_on or
		ra.is_auto_update_stats_on <> rb.is_auto_update_stats_on or
		ra.is_auto_create_stats_on <> rb.is_auto_create_stats_on or
		ra.recovery_model_desc <> rb.recovery_model_desc or
		ra.recovery_model <> rb.recovery_model or
		ra.is_read_committed_snapshot_on <> rb.is_read_committed_snapshot_on or
		ra.snapshot_isolation_state_desc <> rb.snapshot_isolation_state_desc or
		ra.snapshot_isolation_state <> rb.snapshot_isolation_state or
		ra.is_supplemental_logging_enabled <> rb.is_supplemental_logging_enabled or
		ra.is_in_standby <> rb.is_in_standby or
		ra.state <> rb.state or
		ra.is_auto_shrink_on <> rb.is_auto_shrink_on 



	------------------------------------------------------------------------------------------------------------------
	-- compare tables

	set @command = cast('select 
	ra.schema_name,
	rb.schema_name,
	ra.table_name,
	rb.table_name,
	ra.column_name,
	rb.column_name,
	ra.type_name,
	rb.type_name,
	ra.uses_ansi_nulls,
	rb.uses_ansi_nulls,
	ra.column_id,
	rb.column_id,
	ra.system_type_id,
	rb.system_type_id,
	ra.max_length,
	rb.max_length,
	ra.precision,
	rb.precision,	
	ra.scale,
	rb.scale,
	ra.collation_name,
	rb.collation_name,
	ra.is_nullable,
	rb.is_nullable,
	ra.is_ansi_padded,
	rb.is_ansi_padded,
	ra.is_rowguidcol,
	rb.is_rowguidcol,
	ra.is_identity,
	rb.is_identity,
	ra.is_computed,
	rb.is_computed
from
(
select 
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	sc.name as column_name,
	sts.name as type_name,
	uses_ansi_nulls,
	column_id,
	sc.system_type_id,
	sc.user_type_id,
	sc.max_length,
	sc.precision,
	sc.scale,
	sc.collation_name,
	sc.is_nullable,
	sc.is_ansi_padded,
	sc.is_rowguidcol,
	sc.is_identity,
	sc.is_computed
from [' as varchar(max)) + @db_a + '].sys.tables st inner join
	[' + @db_a + '].sys.schemas ss on
		st.schema_id = ss.schema_id inner join
	[' + @db_a + '].sys.columns as sc on
		sc.object_id = st.object_id inner join
	[' + @db_a + '].sys.types as sts on
		sc.user_type_id = sts.user_type_id
)
as ra full outer join
(
select 
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	sc.name as column_name,
	sts.name as type_name,
	uses_ansi_nulls,
	column_id,
	sc.system_type_id,
	sc.user_type_id,
	sc.max_length,
	sc.precision,
	sc.scale,
	sc.collation_name,
	sc.is_nullable,
	sc.is_ansi_padded,
	sc.is_rowguidcol,
	sc.is_identity,
	sc.is_computed
from 
	[' + @db_b + '].sys.tables st inner join
	[' + @db_b + '].sys.schemas ss on
		st.schema_id = ss.schema_id inner join
	[' + @db_b + '].sys.columns as sc on
		sc.object_id = st.object_id inner join
	[' + @db_b + '].sys.types as sts on
		sc.user_type_id = sts.user_type_id
)
as rb on
	ra.schema_name = rb.schema_name collate database_default and
	ra.table_name = rb.table_name collate database_default and
	ra.column_name = rb.column_name collate database_default
where
	ra.object_id is null or rb.object_id is null or
	(ra.object_id is not null and rb.object_id is not null and
		( 
			(ra.type_name <> rb.type_name collate database_default ) or
			(ra.column_id <> rb.column_id) or
			(ra.uses_ansi_nulls <> rb.uses_ansi_nulls) or
			(ra.system_type_id <> rb.system_type_id) or
			(ra.user_type_id <> rb.user_type_id) or
			(ra.max_length <> rb.max_length) or
			(ra.precision <> rb.precision) or
			(ra.scale <> rb.scale) or
			(ra.is_nullable <> rb.is_nullable) or
			(ra.is_ansi_padded <> rb.is_ansi_padded) or
			(ra.is_rowguidcol <> rb.is_rowguidcol) or
			(ra.is_identity <> rb.is_identity) or
			(ra.is_computed <> rb.is_computed) or
			(ra.collation_name <> rb.collation_name collate database_default)
		)
	)
order by
	ra.schema_name,
	ra.table_name,
	ra.column_name'

	--print @command

	exec(@command)

	------------------------------------------------------------------------------------------------------------------
	-- compare indexes

	set @command = cast('
select 
 	ra.schema_name,
	rb.schema_name,
	ra.table_name,
	rb.table_name,
	ra.index_name,
	rb.index_name,
	ra.index_column_name,
	rb.index_column_name,
	ra.type_name,
	rb.type_name,
	ra.is_primary_key,
	rb.is_primary_key,
	ra.key_ordinal,
	rb.key_ordinal,
	ra.is_descending_key,
	rb.is_descending_key,
	ra.is_included_column,
	rb.is_included_column,
	ra.type,
	rb.type,
	ra.type_desc,	
	rb.type_desc,
	ra.is_unique,
	rb.is_unique,
	ra.ignore_dup_key,
	rb.ignore_dup_key,
	ra.is_unique_constraint,
	rb.is_unique_constraint,
	ra.is_disabled,
	rb.is_disabled,
	ra.system_type_id,
	rb.system_type_id,
	ra.user_type_id,
	rb.user_type_id
from
(
select 
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	si.name as index_name,
	sc.name as index_column_name,
	sts.name as type_name,
	is_primary_key,
	key_ordinal,
	is_descending_key,
	is_included_column,
	si.type,
	si.type_desc,
	is_unique,
	ignore_dup_key,
	is_unique_constraint,
	is_disabled,
	sc.system_type_id,
	sc.user_type_id
from 
	['as varchar(max)) + @db_a + '].sys.tables st inner join
	[' + @db_a + '].sys.schemas ss on
		st.schema_id = ss.schema_id inner join
	[' + @db_a + '].sys.columns as sc on
		sc.object_id = st.object_id inner join
	[' + @db_a + '].sys.indexes as si on
		si.object_id = st.object_id inner join
	[' + @db_a + '].sys.index_columns sic on
		si.object_id = sic.object_id and
		si.index_id = sic.index_id and
		sc.column_id = sic.column_id inner join
	[' + @db_a + '].sys.types as sts on
		sc.user_type_id = sts.user_type_id
)
as ra full outer join
(
select 
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	si.name as index_name,
	sc.name as index_column_name,
	sts.name as type_name,
	is_primary_key,
	key_ordinal,
	is_descending_key,
	is_included_column,
	si.type,
	si.type_desc,
	is_unique,
	ignore_dup_key,
	is_unique_constraint,
	is_disabled,
	sc.system_type_id,
	sc.user_type_id
from 
	[' + @db_b + '].sys.tables st inner join
	[' + @db_b + '].sys.schemas ss on
		st.schema_id = ss.schema_id inner join
	[' + @db_b + '].sys.columns as sc on
		sc.object_id = st.object_id inner join
	[' + @db_b + '].sys.indexes as si on
		si.object_id = st.object_id inner join
	[' + @db_b + '].sys.index_columns sic on
		si.object_id = sic.object_id and
		si.index_id = sic.index_id and
		sc.column_id = sic.column_id inner join
	[' + @db_b + '].sys.types as sts on
		sc.user_type_id = sts.user_type_id
)
as rb on
	ra.schema_name = rb.schema_name collate database_default and
	ra.table_name = rb.table_name collate database_default and
	ra.index_name = rb.index_name collate database_default and
	ra.index_column_name = rb.index_column_name
where
	ra.object_id is null or rb.object_id is null or
	(ra.object_id is not null and rb.object_id is not null and
		( 
			(ra.is_primary_key <> rb.is_primary_key) or
			(ra.type <> rb.type) or
			(ra.type_desc <> rb.type_desc collate database_default ) or
			(ra.type_name <> rb.type_name collate database_default ) or
			(ra.is_unique <> rb.is_unique) or
			(ra.is_descending_key <> rb.is_descending_key) or
			(ra.key_ordinal <> rb.key_ordinal) or
			(ra.is_included_column <> rb.is_included_column) or
			(ra.ignore_dup_key <> rb.ignore_dup_key) or
			(ra.is_unique_constraint <> rb.is_unique_constraint) or
			(ra.is_disabled <> rb.is_disabled) or
			(ra.system_type_id <> rb.system_type_id) or
			(ra.user_type_id <> rb.user_type_id)
		)
	)
order by
	ra.schema_name,
	ra.table_name,
	ra.is_primary_key desc,
	ra.index_name,
	ra.is_included_column asc,
	ra.key_ordinal asc'

	--print @command

	exec(@command)

	set @command = cast('select 
	ra.schema_name,
	rb.schema_name,
	ra.table_name,
	rb.table_name,
	ra.check_constraint_name,
	rb.check_constraint_name,
	ra.type_desc,	
	rb.type_desc,
	ra.definition,
	rb.definition
from
(
select
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	scc.name as check_constraint_name,
	scc.type_desc,
	definition
from 
	['as varchar(max)) + @db_a + '].sys.check_constraints as scc inner join
	[' + @db_a + '].sys.tables as st on
		st.object_id = scc.parent_object_id inner join
	[' + @db_a + '].sys.schemas ss on
		st.schema_id = ss.schema_id
)
as ra full outer join
(
select
	st.object_id,
	ss.name as schema_name,
	st.name as table_name,
	scc.name as check_constraint_name,
	scc.type_desc,
	definition
from 
	[' + @db_b + '].sys.check_constraints as scc inner join
	[' + @db_b + '].sys.tables as st on
		st.object_id = scc.parent_object_id inner join
	[' + @db_b + '].sys.schemas ss on
		st.schema_id = ss.schema_id
)
as rb on
	ra.schema_name = rb.schema_name collate database_default and
	ra.table_name = rb.table_name collate database_default and
	ra.check_constraint_name = rb.check_constraint_name collate database_default
where
	ra.object_id is null or rb.object_id is null or
	(ra.object_id is not null and rb.object_id is not null and
		( 
			(ra.definition <> rb.definition)
		)
	)
order by
	ra.schema_name,
	ra.table_name,	
	ra.check_constraint_name'

	--print @command

	exec (@command)

	---------------------------------------------------------------------------------------------
	-- compare foreign keys

	set @command = cast('select 
	ra.foreign_key_name,
	rb.foreign_key_name,
	ra.type_desc,
	rb.type_desc,
	ra.is_disabled,
	rb.is_disabled,
	ra.delete_referential_action,
	rb.delete_referential_action,
	ra.delete_referential_action_desc,
	rb.delete_referential_action_desc,
	ra.update_referential_action,
	rb.update_referential_action,
	ra.update_referential_action_desc,
	rb.update_referential_action_desc,
	ra.schema_a_name,
	rb.schema_a_name,
	ra.table_a_name,
	rb.table_a_name,
	ra.schema_b_name,
	rb.schema_b_name,
	ra.table_b_name,
	rb.table_b_name,
	ra.column_name,
	rb.column_name,
	ra.ref_column_name,
	rb.ref_column_name
from
(
select 
	sfk.object_id,
	sfk.name as foreign_key_name,
	sfk.type_desc,
	is_disabled,
	delete_referential_action,
	delete_referential_action_desc,
	update_referential_action,
	update_referential_action_desc,
	ss1.name as schema_a_name,
	so1.name as table_a_name,
	ss2.name as schema_b_name,
	so2.name as table_b_name,
	sc1.name as column_name,
	sc2.name as ref_column_name
from 
	[' as varchar(max)) + @db_a + '].sys.foreign_keys as sfk inner join
	[' + @db_a + '].sys.objects as so1 on
		so1.object_id = sfk.parent_object_id inner join
	[' + @db_a + '].sys.objects as so2 on
		so2.object_id = sfk.parent_object_id inner join
	[' + @db_a + '].sys.foreign_key_columns as sfkc on
		sfk.object_id = sfkc.constraint_object_id inner join
	[' + @db_a + '].sys.columns as sc1 on
		sc1.object_id = sfkc.referenced_object_id and
		sc1.column_id = sfkc.parent_column_id inner join
	[' + @db_a + '].sys.columns as sc2 on
		sc2.object_id = sfkc.referenced_object_id and
		sc2.column_id = sfkc.parent_column_id inner join
	[' + @db_a + '].sys.schemas as ss1 on
		so1.schema_id = ss1.schema_id inner join
	[' + @db_a + '].sys.schemas as ss2 on
		so2.schema_id = ss2.schema_id
)
as ra full outer join
(
select 
	sfk.object_id,
	sfk.name as foreign_key_name,
	sfk.type_desc,
	is_disabled,
	delete_referential_action,
	delete_referential_action_desc,
	update_referential_action,
	update_referential_action_desc,
	ss1.name as schema_a_name,
	so1.name as table_a_name,
	ss2.name as schema_b_name,
	so2.name as table_b_name,
	sc1.name as column_name,
	sc2.name as ref_column_name
from 
	[' + @db_b + '].sys.foreign_keys as sfk inner join
	[' + @db_b + '].sys.objects as so1 on
		so1.object_id = sfk.parent_object_id inner join
	[' + @db_b + '].sys.objects as so2 on
		so2.object_id = sfk.parent_object_id inner join
	[' + @db_b + '].sys.foreign_key_columns as sfkc on
		sfk.object_id = sfkc.constraint_object_id inner join
	[' + @db_b + '].sys.columns as sc1 on
		sc1.object_id = sfkc.referenced_object_id and
		sc1.column_id = sfkc.parent_column_id inner join
	[' + @db_b + '].sys.columns as sc2 on
		sc2.object_id = sfkc.referenced_object_id and
		sc2.column_id = sfkc.parent_column_id inner join
	[' + @db_b + '].sys.schemas as ss1 on
		so1.schema_id = ss1.schema_id inner join
	[' + @db_b + '].sys.schemas as ss2 on
		so2.schema_id = ss2.schema_id
)
as rb on
	ra.schema_a_name = rb.schema_a_name collate database_default and
	ra.schema_b_name = rb.schema_b_name collate database_default and
	ra.table_a_name = rb.table_a_name collate database_default and
	ra.table_b_name = rb.table_b_name collate database_default and
	ra.table_a_name = rb.table_a_name collate database_default and
	ra.column_name = rb.ref_column_name collate database_default and
	ra.foreign_key_name = rb.foreign_key_name collate database_default
where
	ra.object_id is null or rb.object_id is null or
	(ra.object_id is not null and rb.object_id is not null and
		( 
			(ra.is_disabled <> rb.is_disabled) or
			(ra.delete_referential_action <> rb.delete_referential_action) or
			(ra.update_referential_action_desc <> rb.update_referential_action_desc)
		)
	)
order by
	ra.foreign_key_name,
	rb.foreign_key_name,
	ra.schema_a_name,
	rb.schema_a_name,
	ra.table_a_name,
	rb.table_a_name,
	ra.schema_b_name,
	rb.schema_b_name,
	ra.table_b_name,
	rb.table_b_name,
	ra.column_name,
	rb.column_name,
	ra.ref_column_name,
	rb.ref_column_name'

	--print @command

	exec (@command)

	---------------------------------------------------------------------------------------------------
	-- find other missing objects

	set @command = cast('select 
		ra.schema_name,
		ra.object_name,
		ra.object_type,
		rb.schema_name,
		rb.object_name,
		rb.object_type
	from
	(
	select 
		ss.name as schema_name,
		so.object_id,
		so.name as object_name,
		so.type as object_type
	from 
		[' as varchar(max)) + @db_a + '].sys.objects as so left outer join
		[' + @db_a + '].sys.schemas as ss on
			so.schema_id = ss.schema_id
	)
	as ra full outer join
	(
	select 
		ss.name as schema_name,
		so.object_id,
		so.name as object_name,
		so.type as object_type
	from 
		[' + @db_b + '].sys.objects as so left outer join
		[' + @db_b + '].sys.schemas as ss on
			so.schema_id = ss.schema_id
	)
	as rb on
		ra.schema_name = rb.schema_name collate database_default and
		ra.object_name = rb.object_name collate database_default and
		ra.object_type = rb.object_type collate database_default
	where
		ra.object_id is null or rb.object_id is null 
	order by
		ra.schema_name,
		rb.schema_name,
		ra.object_name,
		rb.object_name,
		ra.object_type,
		rb.object_type'

	--print @command

	exec (@command)

	-----------------------------------------------------------------------------------------------
	-- compare views, triggers, procedures

	set @command = cast('select 
		ra.schema_name,
		ra.object_name,
		ra.object_type,
		rb.schema_name,
		rb.object_name,
		rb.object_type,
		ra.encrypted,
		rb.encrypted,
		ra.object_body,
		rb.object_body
	from
	(
	select 
		so.object_id,
		so.name as object_name,
		ss.name as schema_name,
		so.type as object_type,
		sc.encrypted,
		object_body
	from 
		[' as varchar(max)) + @db_a + '].sys.objects as so inner join
		[' + @db_a + '].sys.schemas as ss on
			so.schema_id = ss.schema_id inner join
		(select id, min(cast(encrypted as int)) as encrypted from [' + @db_a + '].sys.syscomments group by id) as sc on
			sc.id = so.object_id cross apply
		(
		select 
			replace([text], char(13), '''') as [text()]
		from
			[' + @db_a + '].sys.syscomments as scx
		where
			scx.id = so.object_id
		for xml path('''')
		)
		as tempres(object_body)
	)
	as ra full outer join
	(
	select 
		so.object_id,
		so.name as object_name,
		ss.name as schema_name,
		so.type as object_type,
		sc.encrypted,
		object_body
	from 
		[' + @db_b + '].sys.objects as so inner join
		[' + @db_b + '].sys.schemas as ss on
			so.schema_id = ss.schema_id inner join
		(select id, min(cast(encrypted as int)) as encrypted from [' + @db_b + '].sys.syscomments group by id) as sc on
			sc.id = so.object_id cross apply
		(
		select 
			replace([text], char(13), '''') as [text()]
		from
			[' + @db_b + '].sys.syscomments as scx
		where
			scx.id = so.object_id
		for xml path('''')
		)
		as tempres(object_body)
	)
	as rb on
		ra.schema_name = rb.schema_name collate database_default and
		ra.object_name = rb.object_name collate database_default and
		ra.object_type = rb.object_type collate database_default
	where
		ra.object_id is null or rb.object_id is null or
		ra.schema_name is null or rb.schema_name is null or
		ra.object_name is null or rb.object_name is null or
		ra.object_type is null or rb.object_type is null or
		(	
			ra.object_id   is not null and rb.object_id   is not null and
			ra.schema_name is not null and rb.schema_name is not null and
			ra.object_name is not null and rb.object_name is not null and
			ra.object_type is not null and rb.object_type is not null and
			( 
				(ra.encrypted <> rb.encrypted) or
				(ra.object_body <> rb.object_body)
			)
		)
	order by
		ra.object_type,
		rb.object_type,
		ra.object_name,
		ra.schema_name,
		rb.object_name,
		rb.schema_name,
		ra.encrypted,
		rb.encrypted,
		ra.object_body,
		rb.object_body'

	--print @command

	exec (@command)

	----------------------------------------------------------------------------------------
	-- compare partition schemes

	set @command = cast('select 
		ra.partition_scheme_name,
		ra.scheme_type,
		ra.is_default,
		ra.function_name,
		ra.function_type,
		ra.fanout,
		ra.boundary_value_on_right,
		ra.system_type_id,
		ra.parameter_type_name,
		ra.max_length,
		ra.precision,
		ra.scale,
		ra.collation_name,	
		rb.partition_scheme_name,
		rb.scheme_type,
		rb.is_default,
		rb.function_name,
		rb.function_type,
		rb.fanout,
		rb.boundary_value_on_right,
		rb.system_type_id,
		rb.parameter_type_name,
		rb.max_length,
		rb.precision,
		rb.scale,
		rb.collation_name	
	from
	(
		select 
			ps.name as partition_scheme_name,
			ps.type as scheme_type,
			ps.is_default,
			pf.name as function_name,
			pf.type as function_type,
			pf.fanout,
			pf.boundary_value_on_right,
			st.system_type_id,
			st.name as parameter_type_name,
			pp.max_length,
			pp.precision,
			pp.scale,
			pp.collation_name	
		from 
			[' as varchar(max)) + @db_a + '].sys.partition_schemes as ps left outer join
			[' + @db_a + '].sys.partition_functions as pf on
				ps.function_id = pf.function_id left outer join
			[' + @db_a + '].sys.partition_parameters as pp on
				pf.function_id = pp.function_id left outer join
			[' + @db_a + '].sys.types as st on
				pp.system_type_id = st.system_type_id
	)
	as ra full outer join
	(
		select 
			ps.name as partition_scheme_name,
			ps.type as scheme_type,
			ps.is_default,
			pf.name as function_name,
			pf.type as function_type,
			pf.fanout,
			pf.boundary_value_on_right,
			st.system_type_id,
			st.name as parameter_type_name,
			pp.max_length,
			pp.precision,
			pp.scale,
			pp.collation_name	
		from 
			[' + @db_b + '].sys.partition_schemes as ps left outer join
			[' + @db_b + '].sys.partition_functions as pf on
				ps.function_id = pf.function_id left outer join
			[' + @db_b + '].sys.partition_parameters as pp on
				pf.function_id = pp.function_id left outer join
			[' + @db_b + '].sys.types as st on
				pp.system_type_id = st.system_type_id
	)
	as rb on
		ra.partition_scheme_name = rb.partition_scheme_name collate database_default
	where
		ra.partition_scheme_name is null or rb.partition_scheme_name is null or
		(ra.partition_scheme_name is not null and rb.partition_scheme_name is not null and
			( 
				ra.scheme_type <> rb.scheme_type or
				ra.is_default <> rb.is_default or
				(coalesce(cast(ra.is_default as int), -1) <> coalesce(cast(rb.is_default as int), -1)) or
				coalesce(ra.function_name, '''') <> coalesce(rb.function_name, '''') or
				coalesce(ra.function_type, '''') <> coalesce(rb.function_type, '''') or
				(coalesce(cast(ra.fanout as int), -1) <> coalesce(cast(rb.fanout as int), -1)) or
				(coalesce(cast(ra.boundary_value_on_right as int), -1) <> coalesce(cast(rb.boundary_value_on_right as int), -1)) or 
				coalesce(ra.system_type_id, -1) <> coalesce(rb.system_type_id, -1) or
				coalesce(ra.parameter_type_name, '''') <> coalesce(rb.parameter_type_name, '''') or
				coalesce(ra.max_length, -1) <> coalesce(rb.max_length, -1) or	
				coalesce(ra.precision, -1) <> coalesce(rb.precision, -1) or	
				coalesce(ra.scale, -1) <> coalesce(rb.scale, -1) or
				coalesce(ra.collation_name, '''') <> coalesce(rb.collation_name, '''')
			)
		)
	order by
		ra.partition_scheme_name,
		rb.partition_scheme_name,
		ra.function_name,
		rb.function_name'	

	--print @command

	exec (@command)

	------------------------------------------------------------------------------------------------
	-- compare partition schemes

	set @command = cast('select 
		ra.schema_name,
		ra.table_name,
		ra.index_name,
		ra.partition_number, 

		rb.schema_name,
		rb.table_name,
		rb.index_name,
		rb.partition_number, 

		ra.function_name,
		rb.function_name,

		ra.partition_scheme_name,
		rb.partition_scheme_name,
		ra.index_id,
		rb.index_id,

		ra.file_group_name,
		rb.file_group_name,

		ra.value,
		rb.value
	from
	(
		select	
			ss.name as schema_name,
			st.name as table_name,
			spf.name as function_name,
			sps.name as partition_scheme_name,
			si.index_id,
			si.name as index_name,
			partition_number as partition_number, 
			sfg.name as file_group_name,
			sprv.value
		from
			[' as varchar(max)) + @db_a + '].sys.tables as st inner join
			[' + @db_a + '].sys.schemas as ss on
				st.schema_id = ss.schema_id inner join
			[' + @db_a + '].sys.indexes as si on
				st.object_id = si.object_id inner join
			[' + @db_a + '].sys.partitions as sp on
				sp.object_id = st.object_id and	
				si.index_id = sp.index_id inner join
			[' + @db_a + '].sys.allocation_units as sau on
				sau.container_id = sp.partition_id inner join
			[' + @db_a + '].sys.filegroups as sfg on
				sfg.data_space_id = sau.data_space_id inner join
			[' + @db_a + '].sys.partition_schemes as sps on
				sps.data_space_id = si.data_space_id inner join
			[' + @db_a + '].sys.partition_functions as spf on
				spf.function_id = sps.function_id left outer join
			[' + @db_a + '].sys.partition_range_values as sprv on 
				sprv.function_id = spf.function_id and
				partition_number = sprv.boundary_id	
	)
	as ra full outer join
	(
		select	
			ss.name as schema_name,
			st.name as table_name,
			spf.name as function_name,
			sps.name as partition_scheme_name,
			si.index_id,
			si.name as index_name,
			partition_number as partition_number, 
			sfg.name as file_group_name,
			sprv.value
		from
			[' + @db_b + '].sys.tables as st inner join
			[' + @db_b + '].sys.schemas as ss on
				st.schema_id = ss.schema_id inner join
			[' + @db_b + '].sys.indexes as si on
				st.object_id = si.object_id inner join
			[' + @db_b + '].sys.partitions as sp on
				sp.object_id = st.object_id and	
				si.index_id = sp.index_id inner join
			[' + @db_b + '].sys.allocation_units as sau on
				sau.container_id = sp.partition_id inner join
			[' + @db_b + '].sys.filegroups as sfg on
				sfg.data_space_id = sau.data_space_id inner join
			[' + @db_b + '].sys.partition_schemes as sps on
				sps.data_space_id = si.data_space_id inner join
			[' + @db_b + '].sys.partition_functions as spf on
				spf.function_id = sps.function_id left outer join
			[' + @db_b + '].sys.partition_range_values as sprv on 
				sprv.function_id = spf.function_id and
				partition_number = sprv.boundary_id	
	)
	as rb on
		ra.partition_scheme_name = rb.partition_scheme_name collate database_default and
		ra.schema_name = rb.schema_name collate database_default and
		ra.table_name = rb.table_name collate database_default and
		ra.index_name = rb.index_name collate database_default and
		ra.partition_number = rb.partition_number
	where
		ra.partition_scheme_name is null or rb.partition_scheme_name is null or
		ra.table_name            is null or rb.table_name            is null or
		ra.index_name            is null or rb.index_name            is null or
		ra.schema_name           is null or rb.schema_name           is null or
		ra.partition_number      is null or rb.partition_number      is null or
		ra.file_group_name       is null or rb.file_group_name       is null or
		(
			ra.partition_scheme_name is not null and rb.partition_scheme_name is not null and
			ra.table_name            is not null and rb.table_name            is not null and
			ra.index_name            is not null and rb.index_name            is not null and
			ra.schema_name           is not null and rb.schema_name           is not null and
			ra.partition_number      is not null and rb.partition_number      is not null and
			ra.file_group_name       is not null and rb.file_group_name       is not null and
			(
				coalesce(ra.function_name, '') <> coalesce(rb.function_name, '') collate database_default or
				ra.file_group_name <> rb.file_group_name collate database_default or
				cast(ra.value as varchar(max)) <> cast(rb.value as varchar(max))
			)
		)
	order by
		ra.partition_scheme_name,
		rb.partition_scheme_name,
		ra.schema_name,
		rb.schema_name,
		ra.table_name,
		rb.table_name,
		ra.index_name,
		rb.index_name'

end
go

exec dbo.proc_compare_databases 'siga', 'ipasgo'

