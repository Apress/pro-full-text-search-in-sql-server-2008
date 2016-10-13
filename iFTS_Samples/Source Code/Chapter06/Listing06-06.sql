SELECT
	Commentary_ID,
	Article_Content
FROM dbo.Commentary
WHERE FREETEXT
(
	Article_Content,
	N'Africa',
	LANGUAGE 1033
);