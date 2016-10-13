SELECT Book_ID
FROM dbo.Book
WHERE FREETEXT(*, 'fish');