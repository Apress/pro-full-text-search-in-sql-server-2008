SELECT Book_ID
FROM dbo.Book
WHERE CONTAINS
(
	*,
	N'"center" OR "centre"'
);