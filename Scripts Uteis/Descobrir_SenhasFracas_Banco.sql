DECLARE @WeakPwdList TABLE(WeakPwd NVARCHAR(255))
--Define weak password list
--Use @@Name if users password contain their name
INSERT INTO @WeakPwdList(WeakPwd)
SELECT ''
UNION SELECT '123'
UNION SELECT '1234'
UNION SELECT '12345'
UNION SELECT 'abc'
UNION SELECT 'default'
UNION SELECT 'guest'
UNION SELECT '123456'
UNION SELECT '@@Name123'
UNION SELECT '@@Name'
UNION SELECT '@@Name@@Name'
UNION SELECT 'admin'
UNION SELECT 'Administrator'
UNION SELECT 'admin123'
-- SELECT * FROM @WeakPwdList
SELECT t1.name [Login Name], REPLACE(t2.WeakPwd,'@@Name',t1.name) As [Password]
FROM sys.sql_logins t1
	INNER JOIN @WeakPwdList t2 ON (PWDCOMPARE(t2.WeakPwd, password_hash) = 1 
		OR PWDCOMPARE(REPLACE(t2.WeakPwd,'@@Name',t1.name),password_hash) = 1)

