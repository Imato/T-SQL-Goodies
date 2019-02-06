CREATE FUNCTION dbo.GetQuoted (@STRING VARCHAR(500))
  RETURNS VARCHAR(500)
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-22
  Description:  Return right quated sql object name.
  Examples:
    PRINT dbo.GetQuoted('MyTable')
    PRINT dbo.GetQuoted('dbo.MyTable')
	PRINT dbo.GetQuoted('test.MyTable')
    ----
    [dbo].[MyTable]
	[dbo].[MyTable]
    [test].[MyTable]
*/
BEGIN
  SET @STRING = LTRIM(RTRIM(@STRING));

  -- Object schema
  DECLARE @SCHEMA VARCHAR(255) = '[dbo]';
  IF @STRING LIKE '%.%'
    SET @SCHEMA = SUBSTRING(@STRING, 1, CHARINDEX('.', @STRING) - 1)
  SET @STRING = REPLACE(@STRING, @SCHEMA + '.', '');
  IF LEFT(@SCHEMA, 1) != '['
    SET @SCHEMA = '[' + @SCHEMA;
  IF RIGHT(@SCHEMA, 1) != ']'
    SET @SCHEMA += ']';

  IF LEFT(@STRING, 1) != '['
    SET @STRING = '[' + @STRING;
  IF RIGHT(@STRING, 1) != ']'
    SET @STRING += ']';

  SET @STRING = @SCHEMA + '.' + @STRING
  RETURN @STRING
END;
GO

--- Tests
IF dbo.GetQuoted('MyTable') != '[dbo].[MyTable]'
	THROW 60001, 'Error in test 1', 1;
IF dbo.GetQuoted('dbo.MyTable') != '[dbo].[MyTable]'
	THROW 60001, 'Error in test 2', 1;
IF dbo.GetQuoted('test.MyTable') != '[test].[MyTable]'
	THROW 60001, 'Error in test 3', 1;
GO