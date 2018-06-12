use tempdb

declare @id int

declare @dt smalldatetime

create table #spt_space_all

(

id int,

name varchar(500),

rows varchar(200) null,

reserved varchar(200) null,

data varchar(200) null,

index_size varchar(200)null,

unused varchar(200) null,

create_date smalldatetime null,

)

declare TMP_ITEMS CURSOR LOCAL FAST_FORWARD for

select id from sysobjects

where xtype='U'

open TMP_ITEMS

fetch next from TMP_ITEMS into @id

declare @pages int

WHILE @@FETCH_STATUS = 0

begin

create table #spt_space

(

id int,

rows int null,

reserved dec(15) null,

data dec(15) null,

indexp dec(15) null,

unused dec(15) null

,

create_date smalldatetime null,

)

set nocount on

 

if @id is not null

 

set @dt = (select crdate from sysobjects where id=@id)

begin

/*

** Now calculate the summary data.

** reserved: sum(reserved) where indid in (0, 1, 255)

*/

insert into #spt_space (reserved)

select sum(reserved)

from sysindexes

where indid in (0, 1, 255)

and id = @id

/*

** data: sum(dpages) where indid < 2

** + sum(used) where indid = 255 (text)

*/

select @pages = sum(dpages)

from sysindexes

where indid < 2

and id = @id

select @pages = @pages + isnull(sum(used), 0)

from sysindexes

where indid = 255

and id = @id

update #spt_space

set data = @pages

 

/* index: sum(used) where indid in (0, 1, 255) - data */

update #spt_space

set indexp = (select sum(used)

from sysindexes

where indid in (0, 1, 255)

and id = @id)

- data

/* unused: sum(reserved) - sum(used) where indid in (0, 1, 255) */

update #spt_space

set unused = reserved

- (select sum(used)

from sysindexes

where indid in (0, 1, 255)

and id = @id)

update #spt_space

set rows = i.rows

from sysindexes i

where i.indid < 2

and i.id = @id

update #spt_space set create_date=@dt

end

insert into #spt_space_all

select name = @id,object_name(@id),

rows = convert(char(11), rows),

reserved = ltrim(str(reserved * d.low / 1024.,15,0) +

' ' + 'KB'),

data = ltrim(str(data * d.low / 1024.,15,0) +

' ' + 'KB'),

index_size = ltrim(str(indexp * d.low / 1024.,15,0) +

' ' + 'KB'),

unused = ltrim(str(unused * d.low / 1024.,15,0) +

' ' + 'KB'),create_date

from #spt_space, master.dbo.spt_values d

where d.number = 1

and d.type = 'E'

drop table #spt_space

FETCH NEXT FROM TMP_ITEMS

INTO @id

end

CLOSE TMP_ITEMS

DEALLOCATE TMP_ITEMS

select * from #spt_space_all where [name] not like '%#spt_space_all%'

drop table #spt_space_all

GO
