CREATE FUNCTION dbo.Stoplist_ID
(
	@name sysname
)
RETURNS int
AS
BEGIN
RETURN
(
	SELECT stoplist_id
	FROM sys.fulltext_stoplists
	WHERE name = @name
);
END;