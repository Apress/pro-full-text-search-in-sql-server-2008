SELECT
  SCHEMA_NAME(t.schema_id) AS user_table_schema,
  OBJECT_NAME(fti.object_id) AS user_table,
  fti.object_id AS user_table_name,
  it.name AS internal_table_name,
  it.object_id AS internal_table_id,
  it.internal_type_desc
FROM sys.internal_tables AS it
INNER JOIN sys.fulltext_indexes AS fti
  ON it.parent_id = fti.object_id
INNER JOIN sys.tables t
  ON t.object_id = fti.object_id
WHERE it.internal_type_desc LIKE 'FULLTEXT%'
  ORDER BY user_table;