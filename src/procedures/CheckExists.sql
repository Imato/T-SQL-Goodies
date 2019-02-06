CREATE PROCEDURE dbo.CheckExists
  @object_name VARCHAR(500),
  @type        VARCHAR(2)
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-22
  Description:  Check what object exists. Create new object before alter it.
  Examples:
    EXEC dbo.CheckExists 'MyTestProcedure', 'P';
    ALTER PROC MyTestProcedure
    AS
    .....
    GO;
*/
BEGIN
  SET NOCOUNT ON;
  SET @object_name = dbo.GetQuoted(@object_name);
  IF OBJECT_ID(@object_name) IS NOT NULL
    RETURN;

  DECLARE @SQL NVARCHAR(2000) = 'CREATE ';

  SELECT @SQL +=
    CASE @type
    WHEN 'U' THEN 'TABLE %NAME% (ID INT);'
    WHEN 'V' THEN 'VIEW %NAME% AS SELECT 1 AS ID;'
    WHEN 'P' THEN 'PROCEDURE %NAME% AS SELECT 1 AS ID;'
    WHEN 'F' THEN 'FUNCTION %NAME%() RETURNS INT AS BEGIN RETURN 1; END;'
    WHEN 'TF' THEN 'FUNCTION %NAME%() RETURNS TABLE AS RETURN (SELECT 1 AS ID);'
    ELSE NULL END;

  SET @SQL = REPLACE(@SQL, '%NAME%', @object_name);

  IF @SQL IS NOT NULL
    EXECUTE sp_executesql @SQL;
END;
GO

