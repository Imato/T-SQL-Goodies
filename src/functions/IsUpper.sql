EXEC dbo.Check_Exists 'IsUpper', 'F';
GO

ALTER FUNCTION dbo.IsUpper
  (@CHAR CHAR(1))
RETURNS BIT
AS
/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2017-06-27
  Description:  Check that char is UPPER
  Examples: SELECT dbo.IsUpper('U');
*/
BEGIN 
  DECLARE @R BIT,
          @TC CHAR(1)  = @CHAR COLLATE Cyrillic_General_CS_AS;

  IF (LOWER(@TC) COLLATE Cyrillic_General_CS_AS = @TC)
    SET @R = 0;
  ELSE 
    SET @R = 1;

  RETURN @R;
END;
GO

-- Tests
IF dbo.IsUpper('*') != 0
  THROW 60001, 'ERROR IN TEST 1', 1;
IF dbo.IsUpper('Ô') != 1
  THROW 60001, 'ERROR IN TEST 2', 1;
IF dbo.IsUpper('U') != 1 
  THROW 60001, 'ERROR IN TEST 3', 1;
IF dbo.IsUpper('uFDF') != 0 
  THROW 60001, 'ERROR IN TEST 4', 1;
GO