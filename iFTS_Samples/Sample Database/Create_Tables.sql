USE $(DBNAME);
GO

PRINT 'Creating Tables';
GO

CREATE TABLE dbo.Book
(
	Book_ID int NOT NULL,
	Book_GUID uniqueidentifier ROWGUIDCOL  NOT NULL,
	Book_LCID int NOT NULL,
	Book_Class_Code nchar(1) NULL,
	Book_Subclass_Code nvarchar(3) NOT NULL,
	Book_Content varbinary(max) FILESTREAM  NOT NULL,
	Book_File_Ext nvarchar(4) NOT NULL,
	Book_Image_Name nvarchar(100) NULL,
	Book_Image varbinary(max) NULL,
	Change_Track_Version timestamp NULL,
    CONSTRAINT PK_Book PRIMARY KEY CLUSTERED 
    (
		Book_ID
    )
    FILESTREAM_ON FileStreamGroup,
    CONSTRAINT UQ_Book UNIQUE NONCLUSTERED 
    (
		Book_GUID
    )
)
FILESTREAM_ON FileStreamGroup;
GO

CREATE TABLE dbo.Book_Commentary
(
	Book_ID int NOT NULL,
	Commentary_ID int NOT NULL,
	CONSTRAINT PK_Book_Commentary PRIMARY KEY CLUSTERED 
	(
		Book_ID
	)
);
GO

CREATE TABLE dbo.Book_Subject
(
	Book_ID int NOT NULL,
	Subject_ID smallint NOT NULL,
	CONSTRAINT PK_Book_Subject PRIMARY KEY CLUSTERED 
	(
		Book_ID,
		Subject_ID
	)
);
GO

CREATE TABLE dbo.Book_Title
(
	Book_ID int NOT NULL,
	Title_ID int NOT NULL,
	CONSTRAINT PK_Book_Title PRIMARY KEY CLUSTERED 
	(
		Book_ID,
		Title_ID
	)
);
GO

CREATE TABLE dbo.Commentary
(
	Commentary_ID int NOT NULL,
	Commentary nvarchar(max) NOT NULL,
	Article_Content xml NULL,
	CONSTRAINT PK_Commentary PRIMARY KEY CLUSTERED 
	(
		Commentary_ID 
	)
);
GO

CREATE TABLE dbo.Contributor
(
	Contributor_ID int NOT NULL,
	CONSTRAINT PK_Contributor PRIMARY KEY CLUSTERED 
	(
		Contributor_ID
	)
);
GO

CREATE TABLE dbo.Contributor_Birth_Place
(
	Contributor_ID int NOT NULL,
	Birth_City nvarchar(50) NOT NULL,
	Birth_State nvarchar(50) NULL,
	Birth_Country nvarchar(50) NOT NULL,
	CONSTRAINT PK_Contributor_Birth_Place PRIMARY KEY CLUSTERED 
	(
		Contributor_ID 
	)
);

GO

CREATE TABLE dbo.Contributor_Book
(
	Contributor_ID int NOT NULL,
	Book_ID int NOT NULL,
	Is_Primary_Contributor bit NOT NULL,
	Contributor_Role_ID tinyint NOT NULL,
	CONSTRAINT PK_Contributor_Book PRIMARY KEY CLUSTERED 
	(
		Contributor_ID,
		Book_ID
	)
);
GO

CREATE TABLE dbo.Contributor_Information
(
	Contributor_ID int NOT NULL,
	Information nvarchar(1000) NOT NULL,
	CONSTRAINT PK_Contributor_Information PRIMARY KEY CLUSTERED 
	(
		Contributor_ID
	)
);
GO

CREATE TABLE dbo.Contributor_Key_Dates
(
	Contributor_ID int NOT NULL,
	Date_Type_ID tinyint NOT NULL,
	Key_Date date NOT NULL,
	Is_Exact bit NOT NULL,
	CONSTRAINT PK_Contributor_Key_Dates PRIMARY KEY CLUSTERED 
	(
		Contributor_ID,
		Date_Type_ID
	)
);
GO

CREATE TABLE dbo.Contributor_Name
(
	Contributor_Name_ID int NOT NULL IDENTITY(1, 1),
	Contributor_ID int NOT NULL,
	Contributor_LCID int NOT NULL,
	Last_Name nvarchar(50) NOT NULL,
	First_Name nvarchar(50) NULL,
	Middle_Name nvarchar(50) NULL,
	Is_Primary_Spelling bit NULL,
	CONSTRAINT PK_Contributor_Name PRIMARY KEY CLUSTERED 
	(
		Contributor_ID,
		Contributor_LCID
	),
	CONSTRAINT UQ_Contributor_Name UNIQUE
	(
		Contributor_Name_ID
	)
);
GO

CREATE TABLE dbo.Contributor_Role
(
	Contributor_Role_ID tinyint NOT NULL,
	Contributor_Role_Description nvarchar(100) NOT NULL,
	CONSTRAINT PK_Contributor_Role PRIMARY KEY CLUSTERED 
	(
		Contributor_Role_ID
	)
);
GO

CREATE TABLE dbo.Date_Type
(
	Date_Type_ID tinyint NOT NULL,
	Date_Description nvarchar(100) NOT NULL,
	CONSTRAINT PK_Date_Type PRIMARY KEY CLUSTERED 
	(
		Date_Type_ID
	)
);
GO

CREATE TABLE dbo.File_Ext
(
	File_Ext nvarchar(4) NOT NULL,
	File_Ext_Description nvarchar(100) NOT NULL,
	CONSTRAINT PK_File_Ext PRIMARY KEY CLUSTERED 
	(
		File_Ext 
	)
);
GO

CREATE TABLE dbo.LoC_Class
(
	Class_Code nchar(1) NOT NULL,
	Class_Description nvarchar(200) NOT NULL,
	CONSTRAINT PK_LoC_Class PRIMARY KEY CLUSTERED 
	(
		Class_Code
	)
);
GO

CREATE TABLE dbo.LoC_Subclass
(
	Subclass_ID int NOT NULL IDENTITY(1, 1),
	Class_Code nchar(1) NOT NULL,
	Subclass_Code nvarchar(3) NOT NULL,
	Subclass_Description nvarchar(200) NOT NULL,
	CONSTRAINT PK_LoC_SubClass PRIMARY KEY CLUSTERED 
	(
		Class_Code,
		Subclass_Code
	),
	CONSTRAINT UQ_LoC_SubClass UNIQUE
	(
		Subclass_ID
	)
);
GO

CREATE TABLE dbo.Numbers
(
	n int NOT NULL,
	CONSTRAINT PK_Numbers PRIMARY KEY CLUSTERED
	(
		n
	)
);
GO

CREATE TABLE dbo.Subject
(
	Subject_ID smallint NOT NULL,
	Subject_Description nvarchar(100) NOT NULL,
	CONSTRAINT PK_Subject PRIMARY KEY CLUSTERED 
	(
		Subject_ID
	)
);
GO

CREATE TABLE dbo.Title
(
	Title_ID int NOT NULL,
	Title_LCID int NOT NULL,
	Is_Primary_Title bit NOT NULL,
	Title nvarchar(100) NOT NULL,
	CONSTRAINT PK_Title PRIMARY KEY CLUSTERED 
	(
		Title_ID
	)
);
GO

CREATE TABLE dbo.Xml_Lang_Code
(
	LCID int NOT NULL,
	Xml_Lang_Code varchar(20) NOT NULL,
	CONSTRAINT PK_Xml_Lang_Code PRIMARY KEY CLUSTERED 
	(
		LCID
	)
);
GO