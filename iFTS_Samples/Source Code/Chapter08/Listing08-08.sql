SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(THESAURUS, aqua)',
	1033,
	null,
	0
);