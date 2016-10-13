SELECT
	fulltext_catalog_id,
	name,
	is_default,
	is_accent_sensitivity_on,
	principal_id,
	is_importing
FROM sys.fulltext_catalogs;