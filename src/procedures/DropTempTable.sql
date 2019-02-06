EXEC dbo.CheckExists 'dbo.DropTempTable ', 'P';
GO

ALTER PROCEDURE dbo.DropTempTable 
  @temp_table VARCHAR(500)
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-22
  Description:  Drop table into tempdb
  Examples:     EXECUTE dbo.DropTempTable '#tmp_t1';

*/
BEGIN
  SET NOCOUNT ON;
  DECLARE @tsql NVARCHAR(4000);

  IF LEFT(@temp_table, 1) != '#'
	RETURN;

  SET @temp_table = 'tempdb..' + @temp_table;

  IF OBJECT_ID(@temp_table) IS NOT NULL 
  BEGIN 
	SET @tsql = 'DROP TABLE ' + @temp_table;
	EXEC sp_executesql  @tsql;
  END;
END;
GO

--- Test 1
EXECUTE dbo.DropTempTable '#tmp_t1';
CREATE TABLE #tmp_t1(ID INT);
EXECUTE dbo.DropTempTable '#tmp_t1';
GO

BEGIN TRY
	EXECUTE ('SELECT * FROM #tmp_t1');
	THROW 60001, 'Error in test 1', 1;
END TRY
BEGIN CATCH
	PRINT 'Test 1 - done';
END CATCH
GO
