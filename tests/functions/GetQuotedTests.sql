--- Tests
IF dbo.GetQuoted('MyTable') != '[dbo].[MyTable]'
	THROW 60001, 'Error in function dbo.GetQuoted test 1', 1;
IF dbo.GetQuoted('dbo.MyTable') != '[dbo].[MyTable]'
	THROW 60001, 'Error in function dbo.GetQuoted test 2', 1;
IF dbo.GetQuoted('test.MyTable') != '[test].[MyTable]'
	THROW 60001, 'Error in function dbo.GetQuoted test 3', 1;
GO