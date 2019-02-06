EXEC dbo.CheckExists 'dbo.ExecuteIntoTempTable ', 'P';
GO

ALTER PROCEDURE dbo.ExecuteIntoTempTable 
  @sql			NVARCHAR(MAX),
  @temp_table	VARCHAR(500),
  @row_count	INT				= NULL OUT
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-22
  Description:  Save result from procedure or query @sql into temp table @temp_table dynamically
  Examples:      

*/
BEGIN
  SET NOCOUNT ON;

  IF LEFT(@temp_table, 2) != '##'
	THROW 60002, 'Temp table @temp_table must be global!', 1;

  DECLARE @tsql NVARCHAR(4000),
		  @db   VARCHAR(500) = DB_NAME()

  EXECUTE dbo.DropTempTable @temp_table;  

  SET @tsql = 
	 'SELECT * INTO '
	 + @temp_table 
	 + ' FROM OPENROWSET(''SQLOLEDB'', ''Data Source=localhost;Catalog=' + @db + ';Trusted_Connection=yes;Integrated Security=SSPI'', ''' + @sql + ''')';

  EXEC sp_executesql @tsql;
END;
GO

--- Test 1
DECLARE @row_count INT;
EXEC dbo.ExecuteIntoTempTable  'SELECT * FROM sys.objects', '##tmp_result_table', @row_count out;
PRINT @row_count
SELECT * FROM ##tmp_result_table