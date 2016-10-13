CREATE TABLE dbo.Book_EN
(
	Book_ID int NOT NULL PRIMARY KEY,
	Content varbinary(max),
	File_Ext nvarchar(4)
);
GO
CREATE TABLE dbo.Book_ES
(
	Book_ID int NOT NULL PRIMARY KEY,
	Content varbinary(max),
	File_Ext nvarchar(4)
);
GO
CREATE TABLE dbo.Book_DE
(
	Book_ID int NOT NULL PRIMARY KEY,
	Content varbinary(max),
	File_Ext nvarchar(4)
);
GO