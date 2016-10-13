USE $(DBNAME);
GO

PRINT 'Creating Tables';
GO

CREATE TABLE dbo.Dictionary
(
	[Keyword] [varchar](50) NOT NULL,
	CONSTRAINT [PK_Dictionary] PRIMARY KEY CLUSTERED 
	(
		[Keyword]
	)
); 
GO
