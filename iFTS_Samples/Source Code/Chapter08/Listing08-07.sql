SELECT Book_ID
FROM dbo.Book
WHERE CONTAINS
(
	Book_Content,
	N'"aqua" OR "azure" OR "aquamarine" OR "indigo" OR "teal" OR "cobalt" "navy" OR "blue"'
);