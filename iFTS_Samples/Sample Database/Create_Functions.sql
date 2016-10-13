USE $(DBNAME);
GO

PRINT 'Creating Functions';
GO

CREATE FUNCTION dbo.View_Contributors_By_Book (@Book_ID int)
RETURNS TABLE
AS
RETURN
(
	SELECT
	    cb.Book_ID,
		c.Contributor_ID,
		cn.Last_Name,
		cn.First_Name,
		cn.Middle_Name,
		cr.Contributor_Role_Description,
		cb.Is_Primary_Contributor,
		(
		  SELECT ckd.Key_Date
		  FROM dbo.Contributor_Key_Dates ckd
		  WHERE ckd.Contributor_ID = c.Contributor_ID
		  AND ckd.Date_Type_ID = 0
		) AS Birth_Date,
		(
		  SELECT ckd.Key_Date
		  FROM dbo.Contributor_Key_Dates ckd
		  WHERE ckd.Contributor_ID = c.Contributor_ID
		  AND ckd.Date_Type_ID = 1
		) AS Deceased_Date,
		fl.name AS Name_Language,
		cn.Is_Primary_Spelling,
		ci.Information
	FROM dbo.Contributor_Book cb
	INNER JOIN dbo.Contributor c
	  ON c.Contributor_ID = cb.Contributor_ID
	INNER JOIN dbo.Contributor_Name cn
	  ON c.Contributor_ID = cn.Contributor_ID
	INNER JOIN dbo.Contributor_Role cr
	  ON cb.Contributor_Role_ID = cr.Contributor_Role_ID
	LEFT JOIN dbo.Contributor_Information ci
	  ON cb.Contributor_ID = ci.Contributor_ID
	LEFT JOIN sys.fulltext_languages fl
	  ON cn.Contributor_LCID = fl.lcid
	WHERE cb.Book_ID = @Book_ID	  
);
GO

CREATE FUNCTION dbo.Stoplist_ID 
(
  @name sysname
) RETURNS int
AS
BEGIN
  RETURN
  (
    SELECT stoplist_id
    FROM sys.fulltext_stoplists
    WHERE name = @name
  );
END;
GO