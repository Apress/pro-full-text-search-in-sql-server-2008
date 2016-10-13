SELECT sw.*
FROM sys.fulltext_stoplists sl
INNER JOIN sys.fulltext_stopwords sw
	ON sl.stoplist_id = sw.stoplist_id
WHERE sl.name = N'NoFish_Stoplist'
	AND sw.language_id = 1033;