SELECT Book_ID
FROM dbo.Book
WHERE CONTAINS
(
	Book_Content,
	N'"florida"'
);