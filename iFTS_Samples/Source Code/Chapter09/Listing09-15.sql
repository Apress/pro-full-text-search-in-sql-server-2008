SELECT
	t.name AS table_name,
	c.name AS catalog_name,
	i.name AS index_name,
	i.type_desc
FROM sys.fulltext_index_catalog_usages icu
INNER JOIN sys.tables t
	ON icu.object_id = t.object_id
INNER JOIN sys.fulltext_catalogs c
	ON icu.fulltext_catalog_id = c.fulltext_catalog_id
INNER JOIN sys.indexes i
	ON icu.object_id = i.object_id
		AND icu.index_id = i.index_id;