SELECT A.is_policy_checked, A.is_expiration_checked, COUNT(*) AS total 
FROM 
(SELECT L.name, S.loginname, S.password, L.password_hash, L.sid, L.is_disabled, L.is_policy_checked, L.is_expiration_checked 
 FROM syslogins S LEFT JOIN [IPASGO].[sys].[sql_logins] L ON S.sid = L.sid 
 WHERE 1=1 AND PWDCOMPARE('', L.password_hash) = 0 AND L.is_disabled = 1) A 
GROUP BY A.is_policy_checked, A.is_expiration_checked;

/****************************************************************************************************************/

SELECT L.name, S.loginname, S.password, L.password_hash, L.sid, L.is_disabled, L.is_policy_checked, L.is_expiration_checked 
FROM syslogins S LEFT JOIN [IPASGO].[sys].[sql_logins] L ON S.sid = L.sid 
WHERE 1=1 AND PWDCOMPARE('', L.password_hash) = 1 AND L.is_disabled = 1
Order by loginname


/****************************************************************************************************************/

SELECT L.*
FROM [sys].[sql_logins] L
where 1=1 
And PWDCOMPARE('', L.password_hash) = 1 
AND L.is_disabled = 1
And name = ''

select * from operadores where NOME_Operador = '82962863191'
select * from Log_Operadores where NOME_Operador = '82962863191' order by DATA_Ocorrencia desc

/****************************************************************************************************************/


/****************************************************************************************************************/
