USE iFTS_Books;
GO
CREATE PROCEDURE dbo.Add_Stopwords
(
	@stoplist sysname,
	@words nvarchar(max),
	@lcid int = 1033
)
AS
BEGIN
	SET @words = N',' + REPLACE(@words, N';', N'') + N',';
	CREATE TABLE #Stopwords
	(
		Word nvarchar(64)
	);

	WITH Numbers (n)
	AS
	(
		SELECT 1
		UNION ALL
		SELECT n + 1
		FROM Numbers
		WHERE n < LEN(@words)
	)
	INSERT INTO #Stopwords (Word)
	SELECT
		SUBSTRING
		(
			@words,
			n + 1,
			CHARINDEX(N',', @words, n + 1) - n - 1
		)
	FROM Numbers
	WHERE SUBSTRING(@words, n, 1) = N','
		AND n < LEN(@words)
	OPTION (MAXRECURSION 0);

	DECLARE Stopword_Cursor CURSOR
	FORWARD_ONLY READ_ONLY
	FOR
	SELECT LTRIM(RTRIM(Word)) AS Word
	FROM #Stopwords
	WHERE LEN(Word) > 0;

	OPEN Stopword_Cursor;
	DECLARE @sql nvarchar(400),
		@word nvarchar(64);

	FETCH NEXT
	FROM StopWord_Cursor
	INTO @word;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS
		(
			SELECT 1
			FROM sys.fulltext_stopwords fsw
			WHERE fsw.stoplist_id = dbo.Stoplist_ID(@stoplist)
				AND fsw.stopword = @word
				AND fsw.language_id = @lcid
		)
		BEGIN
			SET @sql = N'ALTER FULLTEXT STOPLIST ' +
				QUOTENAME(@stoplist) +
				N' ADD ' + QUOTENAME(@word, '''') +
				N' LANGUAGE ' + CAST(@lcid AS nvarchar(4)) + ';';

			EXEC (@sql);
		END;

		FETCH NEXT
		FROM StopWord_Cursor
		INTO @word;
	END;

	CLOSE StopWord_Cursor;
	DEALLOCATE StopWord_Cursor;
END;
GO