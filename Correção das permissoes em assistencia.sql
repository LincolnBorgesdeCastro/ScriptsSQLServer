/*
select count(*) from PermissoesTabelas04102012

select top 100 * from PermissoesTabelas04102012


select * from PermissoesTabelasAntes04102012 
where DESC_Tabela = 'aa_Auditores'
where desc_tipo <> 'Permitido'

select * from PermissoesTabelas04102012
where DESC_Tabela = 'aa_Auditores'
where desc_tipo <> 'Permitido'
*/

Select 'Revoke select on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois left join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela         = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Antes.DESC_Tabela is null
and depois.desc_tipo = 'Permitido'
and depois.DESC_Select = 'X' 

Select 'Revoke insert on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois left join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Antes.DESC_Tabela is null
and depois.desc_tipo = 'Permitido'
and depois.DESC_Insert = 'X' 

Select 'Revoke update on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois left join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Antes.DESC_Tabela is null
and depois.desc_tipo = 'Permitido'
and depois.DESC_Update = 'X' 

Select 'Revoke delete on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois left join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Antes.DESC_Tabela is null
and depois.desc_tipo = 'Permitido'
and depois.DESC_Delete = 'X' 

Select 'Revoke execute on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois left join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Antes.DESC_Tabela is null
and depois.desc_tipo = 'Permitido'
and depois.DESC_Execute = 'X' 


Select distinct 'Revoke select on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois inner join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Depois.DESC_Select = Antes.DESC_Select
and depois.desc_tipo = 'Permitido'
and depois.DESC_Select = 'X' 



Select distinct 'Revoke insert on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois inner join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Depois.DESC_Insert <> Antes.DESC_Insert
and depois.desc_tipo = 'Permitido'
and depois.DESC_Insert = 'X' 

Select distinct 'Revoke update on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois inner join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Depois.DESC_Update <> Antes.DESC_Update
and depois.desc_tipo = 'Permitido'
and depois.DESC_Update = 'X' 

Select distinct 'Revoke delete on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois inner join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Depois.DESC_Delete <> Antes.DESC_Delete
and depois.desc_tipo = 'Permitido'
and depois.DESC_Delete = 'X' 

Select distinct 'Revoke execute on ' + depois.DESC_Tabela + ' to ['+ depois.DESC_Permissionado +']'
From PermissoesTabelas04102012 Depois inner join PermissoesTabelasAntes04102012 Antes on Depois.DESC_Tabela = Antes.DESC_Tabela
                                                                                     and Depois.DESC_Permissionado = Antes.DESC_Permissionado
Where Depois.DESC_Execute <> Antes.DESC_Execute
and depois.desc_tipo = 'Permitido'
and depois.DESC_Execute = 'X' 


/*

select * from PermissoesTabelas04102012
where DESC_Tabela = 'hu_ProcedimentoAgenda'

select * from PermissoesTabelasAntes04102012
where DESC_Tabela = 'hu_ProcedimentoAgenda'


Select 'grant select on ' + DESC_Tabela + ' to ['+ DESC_Permissionado +']'
From PermissoesTabelasAntes04102012 
Where desc_tipo = 'Permitido'
and DESC_Select = 'X' 

Select distinct 'grant insert on ' + DESC_Tabela + ' to ['+ DESC_Permissionado +']'
From PermissoesTabelasAntes04102012 
Where desc_tipo = 'Permitido'
and DESC_insert = 'X' 
and DESC_Tabela is not null

Select distinct 'grant update on ' + DESC_Tabela + ' to ['+ DESC_Permissionado +']'
From PermissoesTabelasAntes04102012 
Where desc_tipo = 'Permitido'
and DESC_update = 'X' 
and DESC_Tabela is not null

Select distinct 'grant delete on ' + DESC_Tabela + ' to ['+ DESC_Permissionado +']'
From PermissoesTabelasAntes04102012 
Where desc_tipo = 'Permitido'
and DESC_delete = 'X' 
and DESC_Tabela is not null

*/

