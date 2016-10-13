SELECT
	fc.name AS catalog_name,
	d.name AS database_name,
	ac.name,
	CASE ac.is_paused
		WHEN 1 THEN N'Yes'
		ELSE N'No'
		END AS is_paused,
	CASE ac.status
		WHEN 0 THEN N'Initializing'
		WHEN 1 THEN N'Ready'
		WHEN 2 THEN N'Paused'
		WHEN 3 THEN N'Temporary error'
		WHEN 4 THEN N'Remount needed'
		WHEN 5 THEN N'Shutdown'
		WHEN 6 THEN N'Quiesced for backup'
		WHEN 7 THEN N'Backup is done through catalog'
		WHEN 8 THEN N'Catalog is corrupt'
		ELSE N'Unknown'
		END AS status,
	ac.status_description,
	ac.worker_count,
	ac.active_fts_index_count,
	ac.auto_population_count,
	ac.manual_population_count,
	ac.full_incremental_population_count,
	ac.row_count_in_thousands,
	CASE ac.is_importing
		WHEN 1 THEN N'Yes'
		ELSE N'No'
		END AS is_importing
FROM sys.dm_fts_active_catalogs ac
INNER JOIN sys.fulltext_catalogs fc
	ON ac.catalog_id = fc.fulltext_catalog_id
INNER JOIN sys.databases d
	ON ac.database_id = d.database_id;