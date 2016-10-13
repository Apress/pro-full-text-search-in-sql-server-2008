SELECT
	t.name AS table_name,
	c.name AS catalog_name,
	i.unique_index_id,
	CASE i.is_enabled
		WHEN 1 THEN N'Yes'
		ELSE N'No'
		END AS is_enabled,
	i.change_tracking_state_desc AS change_tracking,
	CASE i.has_crawl_completed
		WHEN 1 THEN N'Yes'
		ELSE N'No'
		END AS crawl_complete,
	COALESCE(s.name, N'**SYSTEM**') AS stoplist_name
FROM sys.fulltext_indexes i
INNER JOIN sys.tables t
	ON i.object_id = t.object_id
INNER JOIN sys.fulltext_catalogs c
	ON i.fulltext_catalog_id = c.fulltext_catalog_id
LEFT JOIN sys.fulltext_stoplists s
	ON i.stoplist_id = s.stoplist_id;