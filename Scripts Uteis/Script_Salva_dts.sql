/****************************************************************
Criado por: Muthusamy Anantha Kumar aka The MAK

Artigo referência: http://www.sqlservercentral.com/articles/articlesexternal.asp?articleid=1523 (Automating "Save DTS package")

*******************************************************************

use master
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp__SaveDTS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp__SaveDTS]
GO

set quoted_identifier off
go
CREATE proc sp__SaveDTS
@DTSname varchar(256) = '',
@Applicationpath varchar(700) ='',
@destinationpath varchar(700) ='D:\DTS\',
@switches varchar(200) = ' -E -!X '
as
--Created by:MAK
--Date: Aug 29, 2004
--Objective: Save all or given DTS package to a folder
set quoted_identifier off
set nocount on
set concat_null_yields_null off
declare @count int
declare @folderexist int
declare @maxcount int
declare @query varchar(1000)
declare @date varchar(10)
declare @versionid varchar(40)
declare @createdate varchar(25)

set @date = convert(varchar(10),getdate(),112)
set @count =1
Print 'Saving DTS packages - Started'
print getdate()
set @Applicationpath = @Applicationpath +'DTSRUN.exe'
create table #DTSTABLE(id int identity(1,1), DTSname varchar(256),
versionid varchar(40), createdate varchar(25))
if @dtsname = ''
begin
insert into #DTSTABLE (dtsname,versionid,createdate) select name,versionid,replace(replace(convert(varchar(25),createdate,109),':',' '),' ','_')  from 
msdb..sysdtspackages
--drop table #DTSTABLE 
end
else
begin
   insert into #DTSTABLE (dtsname,versionid,createdate) select name,versionid,replace(replace(convert(varchar(25),createdate,109),':',' '),' ','_')  from 
msdb..sysdtspackages where name =@DTSname
end

if (select count(*) from #dTStable) = 0
begin
      set @date = convert(varchar(100), getdate(),109)
      Print 'Error: No valid DTS package found for saving'
end
else
begin
      set @destinationpath = @destinationpath +@date
      create table #files (Files int, Folder int, parent int)
      insert #files exec master.dbo.xp_fileexist @destinationpath
      select @folderexist = Folder from #files
      if @folderexist <>1
      begin
      set @query = 'MKDIR "'+@destinationpath+'"'
      print @query
    exec master..xp_cmdshell @query
      set @destinationpath = @destinationpath
      end
	else
	begin
	print 'Information:'+ @destinationpath + ' already exist. Skipping Folder Creation'
	end
      set @maxcount =  (select max(id) from #dTStable)
While @count <= @maxcount
begin
select @dtsname =dtsname,@versionid=versionid ,@createdate =createdate from #DTSTABLE where id = @count
      set @query = ''+@applicationpath +''+ ' -S"'+@@servername+ '" -N"'+@dtsname+'" -V"'+@versionid +'" -F"'+@destinationpath++'\'+@dtsname+'_'+@createdate+'.dts"'+ @switches       set @query = @query
	set @query = "exec master..xp_cmdshell '" + @query + "'"
      print @query
	exec(@query)
--      exec master..xp_cmdshell @query

if @@error <> 0
begin
Print 'Error'
end

set @count = @count+1
end

end
print getdate()
Print 'Save DTS packages - Completed'
