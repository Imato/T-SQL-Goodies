if not exists (select top 1 1
                from #test
                where Property = '"service"'
                 and Value = '"cdb"')
  THROW 60001, 'Error in function dbo.GetJsonValues test 1', 1;

if not exists (select top 1 1
                from #test
                where Property = '"test"'
                 and Value is null)
  THROW 60001, 'Error in function dbo.GetJsonValues test 2', 1;