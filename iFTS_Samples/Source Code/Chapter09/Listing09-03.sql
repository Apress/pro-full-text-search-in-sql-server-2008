SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(INFLECTIONAL, "a penny saved")',
	1033,
	NULL,
	0
);