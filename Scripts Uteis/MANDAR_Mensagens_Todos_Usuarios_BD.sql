--  sp_dbshout.sql	(systems-level sp defined in master)
--  
--  Send given message to each machine with sessions in given db.
--  
--  
--  Syntax
--    sp_dbshout [@dbname =] 'database' 
--       , [@msg =] 'message'
--  
--  Arguments
--    [@dbname =] 'database' 
--      Is the name of the database whose users are sent the message.
--      database is sysname, with a default of NULL. 
--    [@msg =] 'message'
--      Is the message to be sent.
--      msg is varchar(255), with a default of NULL.
--    [@opt =] 'option'
--      Is an optional behavior. If 'LIST', host names will be listed.
--      opt is varchar(4), with a default of NULL.
--  
--  Return Code Values
--    0-32767 (success: number of messages sent) or -1 (failure)
--  
--  Revision History:
--  DATE     PROGRAMMER  DESCRIPTION
--  ======== =========== ===================================================
--  11/09/01 Joe Kohler  Authored.
--
--
--##########################################################################

USE master
GO

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_dbshout]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
  drop procedure [dbo].[sp_dbshout]
GO

create procedure [sp_dbshout] -- Ver 1.0, rev. 11/09/01, Joe Kohler
   @dbname sysname      = Null
  ,@msg    varchar(255) = Null
  ,@opt    varchar(4)   = Null
AS
-- SETUP RUNTIME OPTIONS / DECLARE VARIABLES --
set nocount on
declare @rc   int
,@msgcount    int
,@dbid        int
,@host        varchar(36)
,@cmd         varchar(312)
select @msgcount = 0, @rc=0

-- VALIDATE DATABASE --
select @dbid=dbid
   from master.dbo.sysdatabases where name=@dbname
if @dbid IS NULL begin
  raiserror(15010,-1,-1,@dbname)
  return (1)
end

-- VALIDATE MESSAGE --
if @msg IS NULL begin
  raiserror(15010,-1,-1,@msg)
  return (1)
end

-- VALIDATE OPT --
select @opt=upper(@opt)
if @opt not in ('LIST', NULL) begin
  raiserror(15010,-1,-1,@opt)
  return (1)
end

-- SEND MESSAGE --
declare c1 cursor local fast_forward for
  select distinct rtrim(hostname) from  master.dbo.sysprocesses
    where spid<>@@spid and dbid=@dbid
      and hostname not in (@@servername, '')
open c1
fetch next from c1 into @host
while ((@@fetch_status=0) AND (@rc=0)) begin
  select @msgcount = @msgcount + 1
  if (@opt='LIST')
    print @host
  select @cmd='net send '+@host+' '+@msg
  EXEC @rc=master..xp_cmdshell @cmd, no_output
  fetch next from c1 into @host
end -- while
close c1
deallocate c1

-- FINALIZATION: RETURN SUCCESS/FAILURE --
if @rc <> 0
   return (-1)
return  (@msgcount)  -- sp_dbshout

GO

