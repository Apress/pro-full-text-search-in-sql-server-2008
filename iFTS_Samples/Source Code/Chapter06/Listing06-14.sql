SELECT
	b.Book_ID,
	t.Title,
	b.Book_Content.PathName() AS FilePath,
	b.Book_File_Ext
FROM dbo.Book b
INNER JOIN dbo.Book_Title bt
	ON b.Book_ID = bt.Book_ID
INNER JOIN dbo.Title t
	ON bt.Title_ID = t.Title_ID
WHERE FREETEXT(Book_Content, @SearchString)
	AND t.Is_Primary_Title = 1;