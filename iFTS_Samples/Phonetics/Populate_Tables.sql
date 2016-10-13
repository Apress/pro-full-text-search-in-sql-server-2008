USE $(DBNAME);
GO

BULK INSERT dbo.Surnames
FROM N'$(CURDIR)\Surnames.txt'
WITH
(
	FORMATFILE = N'$(CURDIR)\Surnames.fmt'
	
);
GO

UPDATE dbo.Surnames
SET Surname_NYSIIS = dbo.NYSIIS(Surname);
GO

INSERT INTO dbo.SurnameTriGrams
(
	Surname_Id,
	NGram_Id,
	NGram
)
SELECT 
	s.Id,
	t.Id,
	t.NGram
FROM dbo.Surnames s
CROSS APPLY dbo.GetNGrams(3, s.Surname) t;
GO