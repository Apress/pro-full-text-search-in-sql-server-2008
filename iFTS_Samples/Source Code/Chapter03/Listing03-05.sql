SELECT b.Book_ID,
	b.Book_LCID
FROM dbo.Book b
WHERE FREETEXT
(
	b.Book_Content,
	N'gift',
	LANGUAGE 1033
);