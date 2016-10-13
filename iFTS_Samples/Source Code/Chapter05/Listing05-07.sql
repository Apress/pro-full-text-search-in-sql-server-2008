CREATE TABLE dbo.Book
(
	Book_ID int NOT NULL CONSTRANT PK_Book PRIMARY KEY,
	Book_LCID int NOT NULL,
	Book_Content varbinary(max) NOT NULL
);
GO