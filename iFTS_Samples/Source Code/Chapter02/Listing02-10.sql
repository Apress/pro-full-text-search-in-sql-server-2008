RESTORE DATABASE iFTS_Books
FROM DISK = N'C:\iFTS_Books\iFTS_Books.bak'
	WITH FILE = 1,
	NOUNLOAD,
	REPLACE,
	STATS = 10;