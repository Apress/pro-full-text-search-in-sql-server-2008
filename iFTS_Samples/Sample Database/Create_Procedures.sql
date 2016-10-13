USE $(DBNAME);
GO

PRINT 'Creating Procedures';
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

CREATE PROCEDURE dbo.Validate_Thesaurus_File @Filename nvarchar(200)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Error_Count int = 0;
  DECLARE @Warning_Count int = 0;
  DECLARE @Attribute nvarchar(1000);
  DECLARE @BinFile varbinary(max);
  DECLARE @x xml;
  DECLARE @Node_Count int;
  DECLARE @Namespace nvarchar(1000);
  DECLARE @Position int;
  DECLARE @Message nvarchar(1000);
  DECLARE @Value nvarchar(1000);
  DECLARE @Position2 int;
  DECLARE @Diacritic_Count int;

  -- Load the thesaurus file as a varbinary BLOB
  DECLARE @Sql nvarchar(1000) = N'SELECT @BinFile = BulkColumn ' +
    N'FROM OPENROWSET (BULK ' + 
    QUOTENAME(@FileName, N'''') + 
    N', SINGLE_BLOB) x';

  EXEC dbo.sp_executesql @Sql, 
    N'@BinFile varbinary(max) OUTPUT', 
    @BinFile = @BinFile OUTPUT;
    
  IF SUBSTRING(@BinFile, 1, 2) <> 0xFFFE
  BEGIN
    PRINT N'ERROR: Thesaurus file is not in Unicode format. Load it into a text editor and resave as Unicode.';
    SET @Error_Count += 1;
  END;
  
  SET @x = CAST(@BinFile AS xml);
  
  -- Check for existence of a root element
  SET @Node_Count = @x.value(N'fn:count(/*)', N'int');
  IF (@Node_Count = 0)
  BEGIN
    PRINT N'ERROR: There is no root element. There should be a single <XML> root element.';
    SET @Error_Count += 1;
  END
  ELSE IF (@Node_Count > 1)
  BEGIN
    PRINT N'ERROR: There are multiple root elements. There should only be a single <XML> root element.';
    SET @Error_Count += 1;
  END

  -- Check the root <XML> element namespace
  SET @Namespace = @x.value(N'fn:namespace-uri(/*:XML[1])', N'nvarchar(1000)');
  IF @Namespace <> N''
  BEGIN
    PRINT N'ERROR: The root <XML> element has an associated namespace, and it should not.';
    SET @Error_Count += 1;
  END;

  -- Check for existence of a root <XML> element
  SET @Node_Count = @x.value('fn:count(/*:XML)', 'int');
  IF (@Node_Count = 0)
  BEGIN
    PRINT N'ERROR: There is no <XML> root element. There should be a single <XML> root element with no namespace.';
    SET @Error_Count += 1;
  END
  ELSE IF (@Node_Count > 1)
  BEGIN
    PRINT N'ERROR: There are multiple <XML> root elements. There should only be a single <XML> root element.';
    SET @Error_Count += 1;
  END;

  -- Check root <XML> element ID attribute
  SET @Attribute = @x.value('/*:XML[1]/@ID', 'nvarchar(1000)');
  IF @Attribute IS NULL
  BEGIN
    PRINT N'WARNING: The root <XML> element has no ID attribute. There should be an ID attribute with its value set to "Microsoft Search Thesaurus". Your thesaurus file should load correctly, but you should add the ID attribute and properly set its value.';
    SET @Warning_Count += 1;
  END
  ELSE IF @Attribute <> N'Microsoft Search Thesaurus' COLLATE Latin1_General_CS_AS
  BEGIN
    PRINT N'WARNING: The root <XML> element ID attribute value should be set to "Microsoft Search Thesaurus". Your thesaurus file should load correctly, but you should change this ID attribute value.';
    SET @Warning_Count += 1;
  END;

  -- Check count/existence of <thesaurus> element(s) under root <XML> element
  SET @Node_Count = @x.value('fn:count(/*:XML[1]/*:thesaurus)', 'int');
  IF @Node_Count = 0
  BEGIN
    PRINT N'ERROR: There is no <thesaurus> element directly under the <XML> root element.';
    SET @Error_Count += 1;
  END
  ELSE IF @Node_Count > 1
  BEGIN
    PRINT N'WARNING: There are multiple <thesaurus> elements directly under the <XML> root element. Your thesaurus file should load correctly, but you should consider combining the multiple <thesaurus> elements into one.';
    SET @Warning_Count += 1;
  END;

  -- Check the namespaces of each <thesaurus> element under the root <XML> element
  DECLARE Namespace_Cursor CURSOR
  FORWARD_ONLY READ_ONLY
  FOR 
  SELECT node.value('fn:namespace-uri(.[1])', 'nvarchar(1000)')
  FROM @x.nodes('/*:XML[1]/*:thesaurus') T(node);

  CREATE TABLE #Elements
  (
    thesaurus_Element_ID int NOT NULL,
    sub_Element_Order_ID int NOT NULL IDENTITY(1, 1),
    sub_Element_Type char(1) NOT NULL,
    sub_Element_URI nvarchar(1000),
    Element xml
  );

  OPEN Namespace_Cursor;

  FETCH NEXT
  FROM Namespace_Cursor
  INTO @Namespace;

  SET @Position = 1;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    -- Check <thesaurus> element namespace 
    IF @Namespace <> N'x-schema:tsSchema.xml' COLLATE Latin1_General_CS_AS
    BEGIN
      PRINT N'ERROR: Namespace of <thesaurus> element #' + 
        CAST(@Position AS nvarchar(10)) + 
        N' is set to ' + 
        COALESCE(N'"' + @Namespace + N'"', 'NULL') + 
        N' and should be set to "x-schema:tsSchema.xml". No rules underneath this <thesaurus> element will be recognized.';
      SET @Error_Count += 1;
    END; 

    -- Check <diacritics_sensitive> element count
    SET @Diacritic_Count = @x.value(N'fn:count(/*:XML[1]/*:thesaurus[sql:variable("@Position")]/*:diacritics_sensitive)', N'int');
    IF @Diacritic_Count = 0
    BEGIN
      PRINT N'WARNING: There is no <diacritics_sensitive> element under <thesaurus> element #' + 
        CAST(@Position AS VARCHAR(10)) + 
        N'. Your thesaurus file should load properly, but the lack of this element may cause unexpected results at query time.';
      SET @Warning_Count += 1;
    END
    ELSE IF @Diacritic_Count > 1 
    BEGIN
      PRINT N'WARNING: There are multiple <diacritics_sensitive> elements under <thesaurus> element #' + 
        CAST(@Position AS nvarchar(10)) + 
        N'. Your thesaurus file should load properly, but the additional <diacritics_sensitive> elements may cause unexpected results at query time.';
      SET @Warning_Count += 1;
    END;

    SET @Position2 = 1;

    -- Loop through all <diacritics_sensitive> elements (in case there is more than one)
    WHILE @Position2 <= @Diacritic_Count
    BEGIN
      SELECT @Namespace = @x.value(N'fn:namespace-uri((/*:XML[1]/*:thesaurus[sql:variable("@Position")]/*:diacritics_sensitive[sql:variable("@Position2")])[1])[1]', N'nvarchar(1000)'),
        @Value = @x.value(N'(/*:XML[1]/*:thesaurus[sql:variable("@Position")]/*:diacritics_sensitive[sql:variable("@Position2")])[1]', N'nvarchar(1000)');

      -- Check <diacritics_sensitive> element namespace
      IF @Namespace <> N'x-schema:tsSchema.xml' COLLATE Latin1_General_CS_AS
      BEGIN
        PRINT N'WARNING: The <diacritics_sensitive> element #' + 
          CAST(@Position2 AS nvarchar(10)) + 
          N' under <thesaurus> element #' + 
          CAST(@Position AS nvarchar(10)) + 
          N' is defined under the namespace URI ' + 
          COALESCE(N'"' + @Namespace + N'"', N'NULL') + 
          N' but the namespace URI needs to be "x-schema:tsSchema.xml". The thesaurus file should load properly, but this element may be ignored resulting in unexpected query results.';
        SET @Warning_Count += 1;
      END;
    
      -- Make sure <diacritics_sensitive> element contains only 0 or 1
      IF @Value NOT IN (N'0', N'1')
      BEGIN
        PRINT N'WARNING: The <diacritics_sensitive> element #' + 
          CAST(@Position2 AS nvarchar(10)) + 
          N' under <thesaurus> element #' + 
          CAST(@Position AS nvarchar(10)) + 
          N' is defined with the value ' + 
          COALESCE(N'"' + @Value + N'"', N'NULL') + 
          N' but the only valid values are "0" and "1". The thesaurus file should load properly, but this element may result in unexpected query results.';
        SET @Warning_Count += 1;
      END;

      SET @Position2 += 1;
    
    END;

    -- Grab all <replacement> and <expansion> elements and store as XML in a temp table
    INSERT INTO #Elements
    (
      thesaurus_Element_ID,
      sub_Element_Type,
      sub_Element_URI,
      Element
    )
    SELECT 
      @Position,
      'R',
      node.value('fn:namespace-uri(.)', 'nvarchar(1000)'),
      node.query('.')
    FROM @x.nodes('/*:XML[1]/*:thesaurus[sql:variable("@Position")]/*:replacement') T(node)

    UNION ALL

    SELECT
      @Position,
      'X',
      node.value('fn:namespace-uri(.)', 'nvarchar(1000)'),
      node.query('.')
    FROM @x.nodes('/*:XML[1]/*:thesaurus[sql:variable("@Position")]/*:expansion') T(node);

    SET @Position += 1;

    FETCH NEXT
    FROM Namespace_Cursor
    INTO @Namespace;

  END;

  CLOSE Namespace_Cursor;

  DEALLOCATE Namespace_Cursor;

  -- Store all thesaurus terms in a temporary table, with locations
  CREATE TABLE #Terms
  (
    thesaurus_Element_ID int NOT NULL,
    sub_Element_Type char(1) NOT NULL,
    sub_Element_ID int NOT NULL,
    sub_Element_URI nvarchar(1000) NOT NULL,
    Term nvarchar(1000)
  );
  
  INSERT INTO #Terms
  ( 
    thesaurus_Element_ID,
    sub_Element_Type,
    sub_Element_ID,
    sub_Element_URI,
    Term
  )
  -- Grab all <replacement> rule terms
  SELECT 
    e.thesaurus_Element_ID,
    e.sub_Element_Type,
    ROW_NUMBER() OVER 
    (
      PARTITION BY 
        e.thesaurus_Element_ID, 
        e.sub_Element_Type 
      ORDER BY 
        e.sub_Element_Order_ID
    ),
    e.sub_Element_URI,
    node.value('.[1]', 'nvarchar(1000)')
  FROM #Elements e
  CROSS APPLY e.Element.nodes('/*:replacement/*:pat') T(node)
  WHERE e.sub_Element_Type = 'R'

  UNION ALL

  -- Grab all <expansion> rule terms
  SELECT 
    e.thesaurus_Element_ID,
    e.sub_Element_Type,
    ROW_NUMBER() OVER 
    (
      PARTITION BY 
        e.thesaurus_Element_ID, 
        e.sub_Element_Type 
      ORDER BY 
        e.sub_Element_Order_ID
    ),
    e.sub_Element_URI,
    node.value('.[1]', 'nvarchar(1000)')
  FROM #Elements e
  CROSS APPLY e.Element.nodes('/*:expansion/*:sub') T(node)
  WHERE e.sub_Element_Type = 'X';

  -- Determine which terms are ambiguous
  CREATE TABLE #Ambiguous_Terms
  (
    Term nvarchar(1000) NOT NULL
  );

  INSERT INTO #Ambiguous_Terms
  (
    Term
  )
  SELECT Term
  FROM #Terms
  GROUP BY Term
  HAVING COUNT(*) > 1;
  
  -- Generate warning messages for ambiguous terms  
  CREATE TABLE #Messages
  (
    [Message] nvarchar(1000)
  );
  
  INSERT INTO #Messages
  (
    [Message]
  )
  SELECT N'WARNING: Ambiguous term found: [Term = "' + 
    at.Term + 
    N'": <thesaurus> #' + 
    CAST(t.thesaurus_Element_ID AS nvarchar(10)) + 
    N', ' +
    CASE t.sub_Element_Type
      WHEN 'R' THEN N'<replacement> #' + CAST(t.sub_Element_ID AS nvarchar(10))
      ELSE N'<expansion> #' + 
      CAST(t.sub_Element_ID AS nvarchar(10))
      END + 
      N']. Your thesaurus file should load properly, but some ambiguous rules will be ignored.'
  FROM #Ambiguous_Terms at
  INNER JOIN #Terms t
    ON t.Term = at.Term;

  -- Iterate all ambiguous term messages and print them out
  DECLARE Ambiguous_Term_Cursor CURSOR
  FORWARD_ONLY READ_ONLY
  FOR
  SELECT [Message]
  FROM #Messages
  ORDER BY [Message];
  
  OPEN Ambiguous_Term_Cursor;
  
  FETCH NEXT
  FROM Ambiguous_Term_Cursor
  INTO @Message;
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT @Message;
  
    SET @Warning_Count += 1;

    FETCH NEXT
    FROM Ambiguous_Term_Cursor
    INTO @Message;
  END;
  
  CLOSE Ambiguous_Term_Cursor;
  
  DEALLOCATE Ambiguous_Term_Cursor;
    
  -- Print out total error and warning counts
  PRINT N'Total Error Count = ' + 
    CAST(@Error_Count AS nvarchar(10));
  PRINT N'Total Warning Count = ' + 
    CAST(@Warning_Count AS nvarchar(10));

  -- Clean up, drop temp tables
  DROP TABLE #Messages;
  DROP TABLE #Ambiguous_Terms;
  DROP TABLE #Terms;
  DROP TABLE #Elements;

END;

GO

CREATE PROCEDURE dbo.Upgrade_Stoplist
(
  @Stoplist sysname,
  @Path nvarchar(2000),
  @LCID int
)
AS
BEGIN

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
  VALUES (N'CHS', 2052),
    (N'CHT', 1028),
    (N'DAN', 1030),
    (N'DEU', 1031),
    (N'ENG', 2057),
    (N'ENU', 1033),
    (N'ESN', 3082),
    (N'FRA', 1036),
    (N'ITA', 1040),
    (N'JPN', 1041),
    (N'KOR', 1042),
    (N'NEU', 0),
    (N'NLD', 1043),
    (N'PLK', 1045),
    (N'PTB', 1046),
    (N'PTS', 2070),
    (N'RUS', 1049),
    (N'SVE', 1053),
    (N'THA', 1054),
    (N'TRK', 1055);

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
  
    DECLARE @BinFile varbinary(max),
      @Words nvarchar(max);
  
    SELECT @Sql = N'SELECT @BinFile = BulkColumn ' +
      N'FROM OPENROWSET(BULK ' + 
      QUOTENAME(@Path + N'\noise' + @Code + N'.txt', '''') + 
      N', SINGLE_BLOB) AS x;';
  
    EXEC dbo.sp_executesql @Sql,
      N'@BinFile varbinary(max) OUTPUT',
      @BinFile = @BinFile OUTPUT;

    SET @Words = CASE SUBSTRING(@BinFile, 1, 2) 
        WHEN 0xFFFE THEN CAST(@BinFile AS nvarchar(max))
        ELSE CAST(@BinFile AS varchar(max))
      END;

    SELECT @Words = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Words, 0x0a, N' '), 0x0d, N' '), N'  ', N' '), N' ', N','), N'?about,', N'');

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




