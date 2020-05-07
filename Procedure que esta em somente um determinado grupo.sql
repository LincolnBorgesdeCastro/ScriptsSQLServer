SET NOCOUNT ON

Declare @Objetc Varchar(100)

If OBJECT_ID('TempDB..#Object') is not null drop table #Object
Create table #Object(Owner varchar(100), Object varchar(100), Grantee varchar(100), Grantor varchar(100), ProtectType varchar(100), [Action] varchar(100), [Column] varchar(100))

If OBJECT_ID('TempDB..#SomenteUmaRole') is not null drop table #SomenteUmaRole
Create table #SomenteUmaRole(Object varchar(100))

Insert into #Object exec sp_helprotect null, 'SIGA - SUPERVISOR'

Delete from #Object where [Action] <> 'Execute'

While (Select Count(*) from #Object) > 0
Begin
  Select Top 1 @Objetc = Object From #Object

  If OBJECT_ID('TempDB..#Roles') is not null drop table #Roles
  Create table #Roles(Owner varchar(100), Object varchar(100), Grantee varchar(100), Grantor varchar(100), ProtectType varchar(100), [Action] varchar(100), [Column] varchar(100))

  Insert into #Roles exec sp_helprotect @Objetc
  
  if (Select Count(*) from #Roles) = 1 insert into #SomenteUmaRole(Object) Values(@Objetc)

  Delete from #Object where Object = @Objetc

  --if (Select Count(*) from #Object) = 970 break
End

Select Object as Objeto from #SomenteUmaRole


