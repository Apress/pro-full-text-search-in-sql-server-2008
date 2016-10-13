SELECT b.Book_ID
FROM dbo.Book b
WHERE FREETEXT
(
	*,
	N'mutton'
);