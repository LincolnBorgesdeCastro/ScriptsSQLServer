
Select  d.name, d.snapshot_isolation_state_desc, d.is_read_committed_snapshot_on  
From sys.databases d
Where d.database_id > 4

And d.snapshot_isolation_state_desc = 'ON'

and name like 'BDSICOOBPRODLAB' 

--And d.is_read_committed_snapshot_on = 1

