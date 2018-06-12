
select 
(case  when name like '%LOG%'  then  'grant select, insert on ' + name + ' to usr_osruntime'
else  'grant select, insert,delete, update  on ' + name + ' to usr_osruntime' end) as Comando

select   'grant select, insert on ' + name + ' to usr_osruntime' 

,* from sys.tables
where is_ms_shipped = 0
and name not like 'Excluir%'
and name like '%odontol%'
and lob_data_space_id = 0
and name not in ('sbdi_BasesDados','sbde_EstatisticasCrescimentoTabelas')
order by name
