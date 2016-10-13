SELECT Book_ID
FROM dbo.Book
WHERE CONTAINS
(
	*,
	N'"performing" AND ("center" OR "centre")'
);