﻿CREATE DATABASE iFTS_Books
ON PRIMARY
(
	NAME = N'iFTS_Books',
	FILENAME = N'C:\iFTS_Books\iFTS_Books_Data.mdf',
	SIZE = 43904KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB
),
FILEGROUP FileStreamGroup
CONTAINS FILESTREAM
DEFAULT
(
	NAME = N'iFTS_Books_FileStream',
	FILENAME = N'C:\iFTS_Books\iFTS_Books_FileStream'
)
LOG ON
(
	NAME = N'iFTS_Books_log',
	FILENAME = N'C:\iFTS_Books\iFTS_Books_Log.ldf',
	SIZE = 1024KB,
	MAXSIZE = 2048GB,
	FILEGROWTH = 10%
);
GO