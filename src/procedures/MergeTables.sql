exec dbo.CheckExists 'dbo.MergeTables ', 'P';
go

/***
Merge @source table into destination
*/

alter proc dbo.MergeTables
  @source varchar(255),
  @destination varchar(255),
  @delete bit= 0,
  @debug bit = 0
as 
begin
  set nocount on;

  declare @columns table 
    (name varchar(255) not null,
    isPrimary bit not null);

  insert into @columns
  select d.name, isnull(p.isPrimary, 0) isPrimary
    from sys.columns s
      join sys.columns d on d.name = s.name
      outer apply 
        (select top 1 1 isPrimary
          from sys.indexes i
            join sys.index_columns c 
              on c.object_id = i.object_id
              and c.index_id = i.index_id
          where i.object_id = object_id(@destination) 
            and i.is_primary_key = 1
            and c.column_id = d.column_id) p
    where s.object_id = object_id(@source)
      and d.object_id = object_id(@destination)
      and s.is_computed = 0
      and d.is_computed = 0
      order by d.column_id

  declare @sql nvarchar(max);

  set @sql = 
'
  merge into ' + @destination + ' d
    using ' + @source + ' s 
      on '

  select @sql += 'd.' + c.name + ' = s.' + c.name 
    + ' and '
    from @columns c 
    where isPrimary = 1;

  if len(@sql) > 5 set @sql = left(@sql, len(@sql) - 4);

  set @sql += '
  when matched then update set
  ';

  select @sql += 'd.' + c.name + ' = s.' + c.name + ', '
    from @columns c 
    where isPrimary = 0;

  if len(@sql) > 2 set @sql = left(@sql, len(@sql) - 1);

  set @sql += '
  when not matched then insert
  (';

  select @sql += c.name + ', '
    from @columns c;

  if len(@sql) > 2 set @sql = left(@sql, len(@sql) - 1);

  set @sql += ')
  values(';

  select @sql += 's.' + c.name + ', '
    from @columns c;

  if len(@sql) > 2 set @sql = left(@sql, len(@sql) - 1);

  set @sql += ')
  ';

  if @delete = 1
    set @sql += 'when not matched by source then delete';

  set @sql += ';';

  if @debug = 1 print @sql;
  exec sp_executesql @sql;
end;
go