USE $(DBNAME)
GO

CREATE FUNCTION dbo.DamLev(@string1 nvarchar(4000), @string2 nvarchar(4000))
RETURNS int WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME Phonetics.[Apress.Examples.Phonetics].DamLev;
GO

CREATE FUNCTION dbo.LCS(@string1 nvarchar(4000), @string2 nvarchar(4000))
RETURNS nvarchar(4000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME Phonetics.[Apress.Examples.Phonetics].LCS;
GO

CREATE FUNCTION dbo.NYSIIS(@string1 nvarchar(4000))
RETURNS nvarchar(4000) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME Phonetics.[Apress.Examples.Phonetics].NYSIIS;
GO

CREATE FUNCTION dbo.ScoreDamLev(@string1 nvarchar(4000), @string2 nvarchar(4000))
RETURNS numeric(5, 4) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME Phonetics.[Apress.Examples.Phonetics].ScoreDamLev;
GO

CREATE FUNCTION dbo.ScoreLCS(@string1 nvarchar(4000), @string2 nvarchar(4000))
RETURNS numeric(5, 4) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME Phonetics.[Apress.Examples.Phonetics].ScoreLCS;
GO

CREATE FUNCTION [dbo].[GetNGrams](@length [int], @string1 [nvarchar](4000))
RETURNS  TABLE (
	[Id] [int] NULL,
	[nGram] [nvarchar](8) NULL
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [Phonetics].[Apress.Examples.Phonetics].[GetNGrams];
GO

CREATE FUNCTION [dbo].[GetTrigramMatches]
(
	@Surname nvarchar(128),
	@Quality decimal(10, 4)
)
RETURNS @r TABLE 
(
	Id int PRIMARY KEY NOT NULL, 
	Surname nvarchar(128), 
	Quality decimal(10, 4)
)
AS
BEGIN
	DECLARE @i decimal(10, 4);

	SELECT @i = COUNT(*) 
	FROM dbo.GetNGrams(3, @Surname);

	WITH NGramCTE
	(
		Id,
		Surname,
		Quality
	)
	AS
	(
		SELECT 
			t.Surname_Id AS Id, 
			s.Surname AS Surname, 
			COUNT(t.Surname_Id) * 2.0 / (@i + 
			(
				SELECT COUNT(*)
				FROM SurnameTriGrams s1
				WHERE s1.Surname_Id = t.Surname_Id
			)) AS Quality
		FROM SurnameTriGrams t
		INNER JOIN Surnames s
			ON t.Surname_ID = s.Id
		WHERE EXISTS
		(
			SELECT 1
			FROM dbo.GetNGrams(3, @Surname) g
			WHERE g.NGram = t.NGram
		)
		GROUP BY 
			t.Surname_Id,
			s.Surname
	)
	INSERT INTO @r 
	(
		Id, 
		Surname, 
		Quality
	)
	SELECT
		Id,
		Surname,
		Quality
	FROM NGramCTE
	WHERE Quality >= @Quality;
	
	RETURN;
END;
GO

CREATE FUNCTION [dbo].[GetTrigramMatches_Distance]
(
	@Surname nvarchar(128),
	@Quality float,
	@Distance int
)
RETURNS @r TABLE 
(
	Id int PRIMARY KEY NOT NULL, 
	Surname nvarchar(128), 
	Quality decimal(10, 4)
)
AS
BEGIN
	DECLARE @i DECIMAL(10, 4);

	SELECT @i = COUNT(*) 
	FROM dbo.GetNGrams(3, @Surname);

	WITH NGramCTE
	(
		Id,
		Surname,
		Quality
	)
	AS
	(
		SELECT 
			t.Surname_ID AS Id, 
			s.Surname AS Surname, 
			COUNT(t.Surname_Id) * 2.0 / (@i + 
			(
				SELECT COUNT(*)
				FROM dbo.SurnameTriGrams s1
				WHERE s1.Surname_Id = t.Surname_Id
			)) AS Quality
		FROM SurnameTriGrams t
		INNER JOIN Surnames s
			ON t.Surname_Id = s.Id
		WHERE EXISTS
		(
			SELECT 1
			FROM dbo.GetNGrams(3, @Surname) g
			WHERE g.NGram = t.NGram
			AND g.Id BETWEEN t.NGram_Id - @Distance AND t.NGram_Id + @Distance
		)
		GROUP BY 
			t.Surname_Id,
			s.Surname
	)
	INSERT INTO @r 
	(
		Id, 
		Surname, 
		Quality
	)
	SELECT 
		Id,
		Surname,
		Quality
	FROM NGramCTE
	WHERE Quality >= @Quality;
	
	RETURN;
END;
GO