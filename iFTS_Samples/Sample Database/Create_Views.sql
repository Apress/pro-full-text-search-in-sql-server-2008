USE $(DBNAME);
GO

PRINT 'Creating Views';
GO

CREATE VIEW dbo.View_All_Book_Names
AS
SELECT 
  b.Book_ID, 
  t.Title,
  cn.Last_Name, 
  cn.First_Name, 
  cn.Middle_Name, 
  cr.Contributor_Role_Description,
  fl.name AS Book_Language_Desc, 
  co.Commentary,
  b.Book_GUID
FROM dbo.Book b
INNER JOIN dbo.Book_Title bt
  ON b.Book_ID = bt.Book_ID
INNER JOIN dbo.Title t
  ON bt.Title_ID = t.Title_ID
  AND t.Is_Primary_Title = 1
INNER JOIN dbo.Contributor_Book cb
  ON b.Book_ID = cb.Book_ID
INNER JOIN dbo.Contributor c
  ON cb.Contributor_ID = c.Contributor_ID
INNER JOIN dbo.Contributor_Name cn
  ON c.Contributor_ID = cn.Contributor_ID
INNER JOIN dbo.Contributor_Role cr
  ON cb.Contributor_Role_ID = cr.Contributor_Role_ID
LEFT JOIN sys.fulltext_languages fl
  ON b.Book_LCID = fl.lcid
LEFT JOIN dbo.Book_Commentary bc
  ON b.Book_ID = bc.Book_ID
LEFT JOIN dbo.Commentary co
  ON bc.Commentary_ID = co.Commentary_ID
WHERE cb.Is_Primary_Contributor = 1
  AND cn.Is_Primary_Spelling = 1;
GO


GO


