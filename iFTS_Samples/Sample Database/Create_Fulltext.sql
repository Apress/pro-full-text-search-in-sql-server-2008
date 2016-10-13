USE $(DBNAME);
GO

PRINT 'Creating Full-Text Catalog';
GO

CREATE FULLTEXT CATALOG Book_Cat
WITH ACCENT_SENSITIVITY = OFF
AS DEFAULT
AUTHORIZATION dbo;
GO

CREATE FULLTEXT INDEX ON dbo.Book
(
	Book_Content TYPE COLUMN Book_File_Ext
)
KEY INDEX PK_Book
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Commentary
(
	Commentary LANGUAGE 1033,
	Article_Content
)
KEY INDEX PK_Commentary
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Contributor_Birth_Place
(
	Birth_City LANGUAGE 1033,
	Birth_State LANGUAGE 1033,
	Birth_Country LANGUAGE 1033
)
KEY INDEX PK_Contributor_Birth_Place
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Contributor_Information
(
	Information LANGUAGE 1033
)
KEY INDEX PK_Contributor_Information
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Contributor_Name
(
	Last_Name,
	First_Name,
	Middle_Name
)
KEY INDEX UQ_Contributor_Name
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Contributor_Role
(
	Contributor_Role_Description LANGUAGE 1033
)
KEY INDEX PK_Contributor_Role
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.LoC_Class
(
	Class_Description LANGUAGE 1033
)
KEY INDEX PK_LoC_Class
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.LoC_Subclass
(
	Subclass_Description LANGUAGE 1033
)
KEY INDEX UQ_LoC_Subclass
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Subject
(
	Subject_Description LANGUAGE 1033
)
KEY INDEX PK_Subject
ON Book_Cat;
GO

CREATE FULLTEXT INDEX ON dbo.Title
(
	Title
)
KEY INDEX PK_Title
ON Book_Cat;
GO
