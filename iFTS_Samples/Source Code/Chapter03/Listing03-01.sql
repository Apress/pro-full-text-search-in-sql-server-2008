USE iFTS_Books;
GO
SELECT b.Book_ID
FROM dbo.Book b
WHERE CONTAINS
(
	*,
	N'fish and chips'
);
SELECT b.Book_ID
FROM dbo.Book b
WHERE FREETEXT
(
	*,
	N'love''s or money'
);
