BACKUP DATABASE iFTS_Books
TO DISK = N'C:\iFTS_Books\iFTS_Books.bak'
WITH DESCRIPTION = N'iFTS_Books backup example including full-text catalogs',
	NOFORMAT,
	INIT,
	NAME = N'iFTS_Books-Full Database Backup',
	SKIP,
	NOREWIND,
	NOUNLOAD,
	STATS = 10;