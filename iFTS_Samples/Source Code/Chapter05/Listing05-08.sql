﻿SELECT
	Book_ID,
	Book_LCID
FROM dbo.Book
WHERE FREETEXT
(
	*,
	N'gift',
	LANGUAGE 1031
);
GO