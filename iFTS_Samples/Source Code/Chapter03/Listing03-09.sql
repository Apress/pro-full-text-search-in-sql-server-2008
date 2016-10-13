SELECT
	t.*,
	k.[RANK]
FROM dbo.Book b
INNER JOIN dbo.Book_Title bt
	ON b.Book_ID = bt.Book_ID
INNER JOIN dbo.Title t
	ON bt.Title_ID = t.Title_ID
INNER JOIN FREETEXTTABLE
(
	dbo.Book,
	*,
	N'fish',
	5
) AS k
	ON k.[KEY] = b.Book_ID
WHERE t.Is_Primary_Title = 1
	ORDER BY k.[RANK] DESC;