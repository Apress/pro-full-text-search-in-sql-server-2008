USE $(DBNAME);
GO

PRINT 'Creating Tables';
GO

CREATE TABLE dbo.Surnames
(
	Id int NOT NULL IDENTITY(1, 1),
	Surname varchar(16),
	Surname_NYSIIS varchar(6),
	CONSTRAINT PK_Surnames PRIMARY KEY
	(
		Id
	)
);
GO

CREATE NONCLUSTERED INDEX IX_Surnames_Surname_NYSIIS
ON dbo.Surnames (Surname_NYSIIS);
GO

CREATE TABLE dbo.SurnameTriGrams
(
	Surname_Id int NOT NULL,
	NGram_Id int NOT NULL,
	NGram char(3) NOT NULL,
	CONSTRAINT PK_SurnameTriGrams 
	PRIMARY KEY (Surname_Id, NGram_Id)
);
GO

CREATE INDEX IX_SurnameTriGrams
ON dbo.SurnameTriGrams (NGram);
GO


