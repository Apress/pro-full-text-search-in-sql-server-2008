SELECT b.Book_ID
FROM dbo.Book b
WHERE CONTAINS
(
	*,
	N'leaf'
);