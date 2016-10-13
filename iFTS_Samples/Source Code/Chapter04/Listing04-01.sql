CREATE PROCEDURE SimpleCommentaryHighlight
  @SearchTerm nvarchar(100),
  @Style nvarchar(200)
AS
BEGIN
  CREATE TABLE #match_docs
  (
    doc_id bigint NOT NULL PRIMARY KEY
  );

  INSERT INTO #match_docs
  (
    doc_id
  )
  SELECT DISTINCT
    Commentary_ID
  FROM Commentary
  WHERE FREETEXT 
  (
    Commentary, 
    @SearchTerm, 
    LANGUAGE N'English'
  );

  DECLARE @db_id int = DB_ID(),
    @table_id int = OBJECT_ID(N'Commentary'),
    @column_id int =
    (
      SELECT 
        column_id
      FROM sys.columns
      WHERE object_id = OBJECT_ID(N'Commentary')
        AND name = N'Commentary'
    );

  SELECT
    s.Commentary_ID,
    t.Title,
    MIN
    (
      N'...' + SUBSTRING
      (
        REPLACE
          (
            c.Commentary, 
            s.Display_Term, 
            N'<span style="' + @Style + '">' + s.Display_Term + '</span>'
          ), 
        s.Pos - 512, 
        s.Length + 1024
      ) + N'...'
    ) AS Snippet
  FROM
    (
      SELECT DISTINCT 
        c.Commentary_ID,
        w.Display_Term,
        PATINDEX
          (
            N'%[^a-z]' + w.Display_Term + N'[^a-z]%', 
            c.Commentary
          ) AS Pos, 
        LEN(w.Display_Term) AS Length
      FROM sys.dm_fts_index_keywords_by_document
        (
          @db_id, 
          @table_id
        ) w
      INNER JOIN dbo.Commentary c
        ON w.document_id = c.Commentary_ID
      WHERE w.column_id = @column_id
        AND EXISTS 
          (
            SELECT 1
            FROM #match_docs m
            WHERE m.doc_id = w.document_id 
          )
        AND EXISTS 
          (
            SELECT 1
            FROM sys.dm_fts_parser
              (
                N'FORMSOF(FREETEXT, "' + @SearchTerm + N'")', 
                1033, 
                0, 
                1
              ) p
            WHERE p.Display_Term = w.Display_Term
          )
    ) s
  INNER JOIN dbo.Commentary c
    ON s.Commentary_ID = c.Commentary_ID
  INNER JOIN dbo.Book_Commentary bc
    ON c.Commentary_ID = bc.Commentary_ID
  INNER JOIN dbo.Book_Title bt
    ON bc.Book_ID = bt.Book_ID
  INNER JOIN dbo.Title t
    ON bt.Title_ID = t.Title_ID
  WHERE t.Is_Primary_Title = 1
  GROUP BY
    s.Commentary_ID,
    t.Title;

  DROP TABLE #match_docs;

END;
GO