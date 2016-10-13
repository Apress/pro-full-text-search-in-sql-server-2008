SELECT
	document_id,
	SUM(occurrence_count) AS keywords_per_document
FROM sys.dm_fts_index_keywords_by_document
(
	DB_ID(N'iFTS_Books'),
	OBJECT_ID(N'dbo.Book')
)
GROUP BY document_id
ORDER BY SUM(occurrence_count) DESC;