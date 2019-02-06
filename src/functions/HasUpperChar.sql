EXEC dbo.Check_Exists 'HasUpperChar', 'F';
GO

ALTER FUNCTION dbo.HasUpperChar
  (@STRING VARCHAR(MAX))
RETURNS BIT
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-27
  Description:  Check that string has UPPER char
  Examples: SELECT dbo.HasUpperChar('UdswwfA*21');
*/
BEGIN 
  DECLARE @R BIT = 0,
          @I INT = LEN(@STRING)
          
  WHILE @I > 0
  BEGIN
    IF dbo.IsUpper(SUBSTRING(@STRING, @I, 1)) = 1
    BEGIN
      SET @R = 1;
      BREAK;
    END;
    SET @I -= 1;
  END;

  RETURN @R;
END;
GO

-- Tests
IF dbo.HasUpperChar('*&3sd') != 0
  THROW 60001, 'ERROR IN TEST 1', 1;
IF dbo.HasUpperChar('!Ôds') != 1
  THROW 60001, 'ERROR IN TEST 2', 1;
IF dbo.HasUpperChar('U') != 1 
  THROW 60001, 'ERROR IN TEST 3', 1;
IF dbo.HasUpperChar('udsewôâ') != 0 
  THROW 60001, 'ERROR IN TEST 4', 1;
GO