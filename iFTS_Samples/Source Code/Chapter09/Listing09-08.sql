SELECT
	fc.name AS catalog_name,
	d.name AS database_name,
	ip.population_type,
	ip.population_type_description,
	SUM(ip.range_count) AS ranges,
	SUM(ip.completed_range_count) AS completed_ranges
FROM sys.dm_fts_index_population ip
INNER JOIN sys.fulltext_catalogs fc
	ON ip.catalog_id = fc.fulltext_catalog_id
INNER JOIN sys.databases d
	ON ip.database_id = d.database_id
GROUP BY
	fc.name,
	d.name,
	ip.population_type,
	ip.population_type_description;