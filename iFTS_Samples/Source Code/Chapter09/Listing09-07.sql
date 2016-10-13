SELECT
	OBJECT_NAME(ob.table_id) AS table_name,
	fc.name AS catalog_name,
	COUNT(*) AS outstanding_batches
FROM sys.dm_fts_outstanding_batches ob
INNER JOIN sys.fulltext_catalogs fc
	ON ob.catalog_id = fc.fulltext_catalog_id
INNER JOIN sys.databases d
	ON ob.database_id = d.database_id
GROUP BY
	ob.table_id,
	fc.name;