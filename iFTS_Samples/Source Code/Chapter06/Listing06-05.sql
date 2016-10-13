SELECT 
	Commentary_ID, 
	Article_Content
FROM dbo.Commentary
WHERE FREETEXT
(
	Article_Content,
	N'abogados',
	LANGUAGE 3082
);

SELECT
	Commentary_ID,
	Article_Content
FROM dbo.Commentary
WHERE FREETEXT
(
	Article_Content,
	N' 性質',
	LANGUAGE 1041
);