SELECT Book_ID
FROM dbo.Book
WHERE CONTAINS
(
	*,
	N'"fish" AND NOT "hook"'
);