CREATE TABLE dbo.Book_Denorm
(
	Book_ID int NOT NULL CONSTRAINT PK_Book_Denorm PRIMARY KEY,
	Content_DE varbinary(max),
	File_Ext_DE nvarchar(4),
	Content_EN varbinary(max),
	File_Ext_EN nvarchar(4),
	Content_ES varbinary(max),
	File_Ext_ES nvarchar(4)
);
GO