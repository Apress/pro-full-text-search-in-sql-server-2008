SELECT *
FROM dbo.Commentary c
WHERE FREETEXT
(
	(c.Commentary, c.Article_Content),
	N'Aristotle'
);