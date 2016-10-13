USE iFTS_Books;
GO
SELECT *
FROM sys.fulltext_stopwords
WHERE stoplist_id = dbo.Stoplist_ID(N'NoFish_Stoplist');