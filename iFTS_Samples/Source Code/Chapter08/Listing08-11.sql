SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(THESAURUS, fl)',
	1033,
	NULL,
	0
);