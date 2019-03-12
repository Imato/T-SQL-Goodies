CREATE FUNCTION dbo.STRING_SPLIT_COLUMNS
  (@string NVARCHAR(MAX),
  @separator NVARCHAR(10))

RETURNS TABLE
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2019-03-12
  Description:  Split string into columns
  Examples: SELECT * FROM dbo.STRING_SPLIT_COLUMNS('value1,value2,value3', ',');
*/
AS
RETURN
  (WITH T
    AS (SELECT s.ID, s.value
         FROM dbo.STRING_SPLIT(@string, @separator) s)

  SELECT [1] Column1, [2] Column2, [3] Column3, [4] Column4, [5] Column5, [6] Column6
    FROM T t
    PIVOT (MAX(value)
      FOR ID IN ([1], [2], [3], [4], [5], [6])) AS PT)
