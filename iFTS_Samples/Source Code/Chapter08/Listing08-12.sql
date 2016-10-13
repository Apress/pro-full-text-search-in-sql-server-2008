SELECT
	special_term,
	display_term,
	expansion_type,
	source_term
FROM sys.dm_fts_parser
(
	N'FORMSOF(THESAURUS, "fl")',
	1033,
	NULL,
	0
);