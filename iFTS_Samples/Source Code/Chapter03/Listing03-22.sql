SELECT
	c.[KEY],
	c.[RANK],
	t.Title
FROM dbo.Book_Title bt
INNER JOIN dbo.Title t
	ON bt.Title_ID = t.Title_ID
INNER JOIN CONTAINSTABLE
(
	dbo.Book,
	Book_Content,
	N'monster'
) c
	ON bt.Book_ID = c.[KEY]
WHERE t.Is_Primary_Title = 1
	ORDER BY c.[RANK] DESC;