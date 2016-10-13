SELECT
	Commentary_ID,
	Commentary
FROM dbo.Commentary
WHERE FREETEXT
(
	Commentary,
	N'go'
);