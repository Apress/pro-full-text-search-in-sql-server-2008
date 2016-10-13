CREATE TABLE [dbo].[Commentary]
(
	Commentary_ID int NOT NULL CONSTRAINT PK_Commentary PRIMARY KEY CLUSTERED,
	Commentary nvarchar(max) NOT NULL,
	Article_Content xml NULL
);
GO