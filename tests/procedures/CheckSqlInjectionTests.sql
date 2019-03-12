
begin try
  exec dbo.CheckSqlInjection @sqlString = 'drop table test';
  throw 60000, 'Test 1 for dbo.CheckSqlInjection faild', 1;
end try
begin catch
end catch

begin try
  exec dbo.CheckSqlInjection @sqlString = 'select * from dbo.test';
end try
begin catch
  throw 60000, 'Test 2 for dbo.CheckSqlInjection faild', 1;
end catch