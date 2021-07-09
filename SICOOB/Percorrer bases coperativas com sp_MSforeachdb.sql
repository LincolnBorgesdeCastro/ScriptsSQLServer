DescHashSenhaAcesso e  DescSenhaAcesso tabela ofc_usuariooffice
DescSenhaEfetivacao tabela ofc_usuarioconta

sp_helprotect 'OFC_UsuarioOffice'

/*

deny select on dbo.OFC_UsuarioOffice(DescHashSenhaAcesso) to RL_CONSULA_SICOOBNET_EMPRESARIAL
deny select on dbo.OFC_UsuarioOffice(DescSenhaAcesso)     to RL_CONSULA_SICOOBNET_EMPRESARIAL
deny select on dbo.ofc_usuarioconta(DescSenhaEfetivacao) to RL_CONSULA_SICOOBNET_EMPRESARIAL



*/

Exec sp_MSforeachdb 'Use [?];

if ( DB_Name()  like ''BDSicoob____'' or DB_Name()   = ''BDSicoobProdLab'')
begin
   deny select on dbo.OFC_UsuarioOffice(DescHashSenhaAcesso) to RL_CONSULA_SICOOBNET_EMPRESARIAL;
   deny select on dbo.OFC_UsuarioOffice(DescSenhaAcesso)     to RL_CONSULA_SICOOBNET_EMPRESARIAL;
   deny select on dbo.ofc_usuarioconta(DescSenhaEfetivacao) to RL_CONSULA_SICOOBNET_EMPRESARIAL;
end'

