/***Script to move file to a new location ***/
--Find Database Physical and logical name
--Write result down very important
sp_helpfile PARTICIONAMENTO ---Use this OR

use PARTICIONAMENTO
select name,physical_name from sys.database_files
go

/*** Getting ready to go down to bussiness ****/
--ponint to master db
use Master
go
-- Rollback all trans 
--Ensure all users are notify of the down time

alter database PARTICIONAMENTO set single_user with rollback immediate
go
-- Set databae Offline
alter database PARTICIONAMENTO set Offline
go
--- Cut and paste the files from the original location to the new location
-- Be sure to write the name and new path exactly 
alter database PARTICIONAMENTO 
Modify file (Name = PARTICIONAMENTO,Filename = 'E:\DB\PARTICIONAMENTO.mdf')--Create one per every file
go
---Set database backonline
alter database PARTICIONAMENTO set Online
go
--Set Database back to multi_user
alter database PARTICIONAMENTO set multi_user
go