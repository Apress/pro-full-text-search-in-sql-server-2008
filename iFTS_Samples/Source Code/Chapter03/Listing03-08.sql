SELECT
	special_term,
	display_term,
	source_term,
	occurrence
FROM sys.dm_fts_parser
(
	N'kop-van-jut',
	1043,
	0,
	0
);
GO
SELECT
	special_term,
	display_term,
	source_term,
	occurrence
FROM sys.dm_fts_parser
(
	N'pianiste-componiste',
	1043,
	0,
	0
);
GO
-- The above are indexed as separate words. The following demonstrates how
-- the entire token is indexed as a unit, both with and without hyphens in place
SELECT
	special_term,
	display_term,
	source_term,
	occurrence
FROM sys.dm_fts_parser
(
	N'kop-hals-rompboerderij',
	1043,
	0,
	0
);
GO