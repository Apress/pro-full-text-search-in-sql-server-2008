CREATE PROCEDURE dbo.Upgrade_Noisewords
(
	@Stoplist sysname,
	@Path nvarchar(2000),
	@LCID int
)
AS
BEGIN
	-- First create a temp table that maps noise word file three-letter
	-- codes to the proper LCIDs
	CREATE TABLE #ThreeLetterCode
	(
		Code nvarchar(3) NOT NULL PRIMARY KEY,
		LCID int NOT NULL
	);

	INSERT INTO #ThreeLetterCode
	(
		Code,
		LCID
	)
	VALUES (N'CHS', 2052), (N'CHT', 1028), (N'DAN', 1030), (N'DEU', 1031),
		(N'ENG', 2057), (N'ENU', 1033), (N'ESN', 3082), (N'FRA', 1036),
		(N'ITA', 1040), (N'JPN', 1041), (N'KOR', 1042), (N'NEU', 0),
		(N'NLD', 1043), (N'PLK', 1045), (N'PTB', 1046), (N'PTS', 2070),
		(N'RUS', 1049), (N'SVE', 1053), (N'THA', 1054), (N'TRK', 1055);

	-- Next see if a stoplist with the specified name exists.
	-- If not, create it with dynamic SQL
	DECLARE @Sql nvarchar(2000);
	IF NOT EXISTS
	(
		SELECT 1
		FROM sys.fulltext_stoplists
		WHERE name = @Stoplist
	)
	BEGIN
		SET @Sql = N'CREATE FULLTEXT STOPLIST ' +
			QUOTENAME(@Stoplist) + N';';
		EXEC (@sql);
	END;

	-- Declare a cursor that iterates the possible three-letter codes we
	-- previously stored in the temp table. The inner join to the
	-- sys.fulltext_languages catalog view ensures we only try to import
	-- noise word lists for languages supported on this instance
	DECLARE File_Cursor CURSOR
	FORWARD_ONLY READ_ONLY
	FOR
	SELECT
		tlc.Code,
		tlc.LCID
	FROM #ThreeLetterCode tlc
	INNER JOIN sys.fulltext_languages fl
		ON tlc.LCID = fl.LCID
	WHERE tlc.LCID = COALESCE(@LCID, tlc.LCID);

	-- Open the cursor and iterate the three-letter codes, importing the
	-- files and adding them to the stoplist
	OPEN File_Cursor;
	DECLARE @Code nvarchar(3),
		@Language int;

	FETCH NEXT
	FROM File_Cursor
	INTO
		@Code,
		@Language;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- The file is initially imported as a binary file since some of the
		-- files can be Unicode while others might not
		DECLARE @BinFile varbinary(max),
			@Words nvarchar(max);

		-- OPENROWSET is used to import the file as a BLOB
		SELECT @Sql = N'SELECT @BinFile = BulkColumn ' +
			N'FROM OPENROWSET(BULK ' +
			QUOTENAME(@Path + N'\noise' + @Code + N'.txt', '''') +
			N', SINGLE_BLOB) AS x;';

		EXEC dbo.sp_executesql @Sql,
			N'@BinFile varbinary(max) OUTPUT',
			@BinFile = @BinFile OUTPUT;

		-- If the BLOB has the byte order mark (0xFFFE) at the start, it will
		-- be cast to nvarchar(max), otherwise varchar(max). The varchar(max)
		-- is then implicitly cast to nvarchar(max)
		SET @Words = CASE SUBSTRING(@BinFile, 1, 2)
			WHEN 0xFFFE THEN CAST(@BinFile AS nvarchar(max))
			ELSE CAST(@BinFile AS varchar(max))
			END;

		-- This series of nested REPLACE functions removes carriage returns,
		-- line feeds, extra spaces, and the "?about" that occurs in some files.
		-- It also replaces spaces with commas to create a comma-separated list.
		SELECT @Words = REPLACE
		(
			REPLACE
			(
				REPLACE
				(
					REPLACE
					(
						REPLACE(@Words, 0x0a, N' '), 0x0d, N' '
					), N' ', N' '
				), N' ', N','
			), N'?about,', N''
		);

		-- The dbo.Add_Stopwords procedure adds the comma-separated list of
		-- stopwords to the stoplist
		EXEC dbo.Add_Stopwords @Stoplist,
			@Words,
			@Language;

		FETCH NEXT
		FROM File_Cursor
		INTO
		@Code,
		@Language;

	END;
	CLOSE File_Cursor;
	DEALLOCATE File_Cursor;
END;
GO