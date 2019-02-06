EXEC dbo.Check_Exists 'IsEqualStrings', 'F';
GO

ALTER FUNCTION dbo.IsEqualStrings
  (@STRING1 VARCHAR(MAX), @STRING2 VARCHAR(MAX))
RETURNS BIT
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-27
  Description:  Check that strings is equal
  Examples: SELECT dbo.IsEqualStrings('teST', 'test');
*/
BEGIN 
  DECLARE @R BIT = 1,
          @I INT = LEN(@STRING1);

  IF LEN(@STRING1) != LEN(@STRING2)
    RETURN 0;

  WHILE @I > 0
  BEGIN
    IF ASCII(SUBSTRING(@STRING1, @I, 1)) != ASCII(SUBSTRING(@STRING2, @I, 1))
    BEGIN
      SET @R = 0;
      BREAK;
    END;
    SET @I -= 1;
  END;

  RETURN @R;
END;
GO

-- Tests
IF dbo.IsEqualStrings('*', '1') != 0
  THROW 60001, 'ERROR IN TEST 1', 1;
IF dbo.IsEqualStrings('Ô tesT!', 'Ô tesT!') != 1
  THROW 60001, 'ERROR IN TEST 2', 1;
IF dbo.IsEqualStrings('Ô tesT!', 'Ô test!') != 0
  THROW 60001, 'ERROR IN TEST 3', 1;
GO