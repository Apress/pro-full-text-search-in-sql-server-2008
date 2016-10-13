SELECT
	b.Book_ID,
	t.Title,
	t.Title_LCID,
	b.Book_File_Ext,
	b.Book_LCID
FROM dbo.Book b
INNER JOIN dbo.Book_Title bt
	ON b.Book_ID = bt.Book_ID
INNER JOIN dbo.Title t
	ON bt.Title_ID = t.Title_ID
WHERE FREETEXT
(
	b.Book_Content,
	N'Yorick'
)
	AND t.Is_Primary_Title = 1;