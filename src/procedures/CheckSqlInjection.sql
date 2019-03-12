EXEC dbo.CheckExists 'dbo.CheckSqlInjection ', 'P';
GO

ALTER proc dbo.CheckSqlInjection
  @sqlString nvarchar(max)
as
begin
  set nocount on;

  declare @exception table (string nvarchar(100));
  insert into @exception
  values
    ('delete '),
    ('drop '),
    ('truncate '),
    ('update '),
    ('alter '),
    ('insert '),
    ('merge '),
    ('set '),
    ('create ');

  declare @exclude table (string nvarchar(100));
  insert into @exclude
  values
    ('insert into #'),
    ('create table #'),
    ('drop table #');

  declare @positions table (id int not null);

  insert into @positions
  select charindex(e.string, @sqlString)
    from @exception e
    where charindex(e.string, @sqlString) > 0
  except
  select charindex(e.string, @sqlString)
    from @exclude e
    where charindex(e.string, @sqlString) > 0;

  if exists (select top 1 1
              from @positions)
  begin
    declare @error nvarchar(max) =
      N'Injection in string: ' + nchar(13) + @sqlString;
    throw 60001, @error, 1
  end;
end;