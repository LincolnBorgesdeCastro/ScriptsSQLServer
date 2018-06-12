select p.name, p.type_desc, pp.name, pp.type_desc
from  sys.server_role_members roles join 
      sys.server_principals p on roles.member_principal_id = p.principal_id join 
      sys.server_principals pp on roles.role_principal_id = pp.principal_id
