SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(INFLECTIONAL, fish)',
	1033,
	dbo.Stoplist_ID(N'NoFish_Stoplist'),
	1
);