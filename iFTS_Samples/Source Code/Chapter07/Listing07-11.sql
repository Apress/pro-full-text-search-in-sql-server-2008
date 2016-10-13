SELECT Book_Id
FROM dbo.Book
WHERE CONTAINS (*, '"fish"');