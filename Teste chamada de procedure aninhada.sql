Alter Procedure up_P1
as
Set Nocount On 
Declare @DESC_Erro Varchar(1000) -- MENSAGEM DE ERRO  

begin try 
  begin tran
    insert into dbo.testeErroLincoln(Texto) values ('Chamada da procedure 1')
	select 1/0
  commit
end try
begin catch

    set @DESC_Erro =  'Chamada da procedure 1 '
 
    If @@trancount > 0 
	Begin 
	   Rollback Transaction
	End
   
    If ERROR_PROCEDURE() IS NOT NULL 
    Begin
        Set @DESC_Erro = @DESC_Erro + 'Store Procedure: ' + ERROR_PROCEDURE() + '  Lincoln '
    End

    RaisError (@DESC_Erro, 16, 1)

end catch
GO

/********************************************************************************************/
Alter Procedure up_P2
as
Set Nocount On 
Declare @DESC_Erro Varchar(1000) -- MENSAGEM DE ERRO  

begin try 
  begin tran

    insert into dbo.testeErroLincoln(Texto) values ('Chamada da procedure 2')
    
	
	exec dbo.up_P1
	--select 1/0
  commit

end try
begin catch

    set @DESC_Erro =  'Chamada da procedure 2 '
 
    If @@trancount > 0 
	Begin 
	   Rollback Transaction
	End
   
    If ERROR_PROCEDURE() IS NOT NULL 
    Begin
        Set @DESC_Erro = @DESC_Erro + ' Procedure: ' + ERROR_PROCEDURE() 
    End

    RaisError (@DESC_Erro, 16, 1)

end catch
GO

/****************************************************************************************************/

--create table testeErroLincoln([Data] datetime DEFAULT getdate(), Texto varchar(1000))


begin tran -- commit rollback

exec dbo.up_P2

--select * from testeErroLincoln

/*

truncate table testeErroLincoln
select * from testeErroLincoln

*/


