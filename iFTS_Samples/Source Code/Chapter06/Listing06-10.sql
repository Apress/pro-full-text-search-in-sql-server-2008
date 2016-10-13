CREATE TABLE dbo.Book
(
	Book_ID int NOT NULL,
	Book_GUID uniqueidentifier ROWGUIDCOL NOT NULL,
	Book_LCID int NOT NULL,
	Book_Subject_ID tinyint NOT NULL,
	Book_Class_Code nchar(1),
	Book_Subclass_Code nvarchar(3) NOT NULL,
	Book_Content varbinary(max) FILESTREAM NOT NULL,
	Book_File_Ext nvarchar(4) NOT NULL,
	Book_Image_Name nvarchar(100),
	Book_Image varbinary(max),
	Change_Track_Version timestamp,
	CONSTRAINT PK_Book PRIMARY KEY CLUSTERED
	(
		Book_ID ASC
	),
	UNIQUE NONCLUSTERED
	(
		Book_GUID ASC
	)
);
GO