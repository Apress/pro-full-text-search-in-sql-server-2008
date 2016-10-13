SELECT
	b.Book_ID,
	CAST
	(
		b.Book_Content AS nvarchar(max)
	) AS Book_Content
FROM dbo.Book b
WHERE b.Book_ID = 9;