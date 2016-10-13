SELECT
	ct.[KEY],
	ct.[RANK],
	t.Title
FROM CONTAINSTABLE
(
	dbo.Book,
	*,
	N'"president" AND "army"'
) ct
INNER JOIN dbo.Book_Title bt
	ON ct.[KEY] = bt.Book_ID
INNER JOIN dbo.Title t
	ON bt.Title_ID = t.Title_ID
WHERE t.Is_Primary_Title = 1;