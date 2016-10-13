SELECT *
FROM
(
	SELECT
		Commentary_ID,
		SUM([Rank]) AS Rank
	FROM
	(
		SELECT
			bc.Commentary_ID,
			c.[RANK] * 10 AS [Rank]
		FROM FREETEXTTABLE
		(
			dbo.Contributor_Birth_Place,
			*,
			N'England'
		) c
		INNER JOIN dbo.Contributor_Book cb
			ON c.[KEY] = cb.Contributor_ID
		INNER JOIN dbo.Book_Commentary bc
			ON cb.Book_ID = bc.Book_ID

		UNION ALL

		SELECT
			c.[KEY],
			c.[RANK] * 5
		FROM FREETEXTTABLE
		(
			dbo.Commentary,
			Commentary,
			N'England'
		) c

		UNION ALL

		SELECT
			ac.[KEY],
			ac.[RANK]
		FROM FREETEXTTABLE
		(
			dbo.Commentary,
			Article_Content,
			N'England'
		) ac
	) s
	GROUP BY Commentary_ID
) s1
INNER JOIN dbo.Commentary c1
	ON c1.Commentary_ID = s1.Commentary_ID
ORDER BY [Rank] DESC;