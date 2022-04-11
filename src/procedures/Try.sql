use master
go


if OBJECT_ID('dbo.Try') is not null
drop proc dbo.Try
go


create proc dbo.Try
	@proc nvarchar(max) = '',
	@fail bit = 1,
	@retryCount int = 3,
	@retryDelay varchar(12) = '00:00:00.500',
	@debug bit = 0
as
begin
	set nocount on;

	if (@proc is null or len(@proc) = 0)
		throw 52001, 'Paramaeter @proc is empty', 1;

	set @retryCount = iif(@retryCount <= 0, 1, @retryCount);
	set @retryDelay = iif(@retryDelay = '', '00:00:00.500', @retryDelay);

	while @retryCount > 0
	begin
		begin try
			if (@debug = 1)
				print formatmessage('%s exec dbo.Try ''%s'', %i, %s',
					format(getdate(), 'HH:mm:ss.fff'), @proc, @retryCount, @retryDelay);
			exec sp_executesql @proc;
			return;
		end try
		begin catch
			if (@retryCount = 1 and @fail = 1)
				throw;
			waitfor delay @retryDelay;
			set @retryCount = @retryCount - 1;
		end catch
	end;
end;
go



-- Tests

create proc dbo.Test
	@fail bit = 0
as
begin
	print format(getdate(), 'HH:mm:ss.fff') + ' Exec dbo.Test';

	if (@fail = 0)
		select top 1 o.object_id from sys.objects o
	if (@fail = 1)
		select top 1 o.object_id from sys.objects o where 1 / 0 = 1;
end;
go

exec dbo.Try @proc = 'dbo.Test @fail = 0', @fail = 1, @retryCount = 2, @retryDelay = '00:00:00.010', @debug = 1;
print 'Test 1 done'
exec dbo.Try @proc = 'dbo.Test @fail = 1', @fail = 0, @retryCount = 2, @retryDelay = '00:00:00.010', @debug = 1;
print 'Test 2 done'
begin try
	exec dbo.Try @proc = 'dbo.Test @fail = 1', @fail = 1, @retryCount = 2, @retryDelay = '00:00:00.010', @debug = 1;
	throw 50921, 'Test 3 error', 1
end try
begin catch
	print 'Test 3 done'
end catch

drop proc dbo.Test
go