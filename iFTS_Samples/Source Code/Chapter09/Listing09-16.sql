SELECT
	t.name AS table_name,
	c.name AS column_name,
	c.column_id,
	ic.language_id
FROM sys.fulltext_index_columns ic
INNER JOIN sys.tables t
	ON ic.object_id = t.object_id
INNER JOIN sys.columns c
	ON ic.object_id = c.object_id
		AND ic.column_id = c.column_id
ORDER BY
	t.name,
	c.name,
	c.column_id;