SELECT
	Commentary_ID,
	DATALENGTH(Article_Content) AS XML_Length,
	DATALENGTH
	(
		CAST
		(
			Article_Content AS nvarchar(max)
		)
	) AS Char_Length
FROM dbo.Commentary;