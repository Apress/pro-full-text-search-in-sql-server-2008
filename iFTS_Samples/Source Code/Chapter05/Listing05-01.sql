SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(FREETEXT, marie-claire)',
	1036,
	NULL,
	0
);

SELECT *
FROM sys.dm_fts_parser
(
	N'FORMSOF(FREETEXT, Marie-Claire)',
	1036,
	NULL,
	0
);