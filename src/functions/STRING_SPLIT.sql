EXEC dbo.Check_Exists 'STRING_SPLIT', 'FT';
GO

ALTER FUNCTION [dbo].[STRING_SPLIT]
  (@string NVARCHAR(MAX), @separator NVARCHAR(10))
RETURNS @VALUES TABLE (ID INT IDENTITY(1,1), [value] NVARCHAR(MAX))
AS
BEGIN

  -- Replace special strings

  WITH REPLC
  AS (SELECT '<' AS string, '&lt;' AS replacment
      UNION ALL SELECT '>', '&gt;'
      UNION ALL SELECT '&', '&amp;'
      UNION ALL SELECT '''', '&apos;'
      UNION ALL SELECT '"', '&quot;')

  SELECT @string = REPLACE(@string, string, replacment)
  FROM REPLC;

  -- Split string frow xml

  DECLARE @XML XML = CAST('<X>' + REPLACE(@string, @separator ,'</X><X>') + '</X>' AS XML);
  INSERT INTO @VALUES
  SELECT n.value('.', 'NVARCHAR(MAX)') AS [value]
  FROM @XML.nodes('X') AS t(n);
  RETURN;
END
GO