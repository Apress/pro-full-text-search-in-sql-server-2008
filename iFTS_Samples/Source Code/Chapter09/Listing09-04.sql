SELECT *
FROM sys.dm_fts_index_keywords
(
	DB_ID(N'iFTS_Books'),
	OBJECT_ID(N'dbo.Book')
);