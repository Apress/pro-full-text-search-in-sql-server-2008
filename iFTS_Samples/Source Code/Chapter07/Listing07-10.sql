SELECT *
FROM sys.dm_fts_index_keywords_by_document
(
	DB_ID(),
	OBJECT_ID('dbo.Book')
)
WHERE display_term LIKE N'fish%';