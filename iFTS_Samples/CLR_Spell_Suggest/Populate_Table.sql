USE $(DBNAME);
GO

DECLARE @v varbinary(max);
BULK INSERT dbo.Dictionary
FROM N'$(CURDIR)\Dictionary.txt';

PRINT '--Populated dictionary table';
GO