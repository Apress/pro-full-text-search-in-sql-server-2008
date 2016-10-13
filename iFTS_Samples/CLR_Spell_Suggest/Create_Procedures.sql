USE $(DBNAME);
GO

CREATE PROCEDURE [dbo].[GetDictionary]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SpellCheck].[Apress.Examples.SpellCheck].[GetDictionary];
GO

CREATE PROCEDURE [dbo].[GetMatch]
	@key [nvarchar](4000)
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SpellCheck].[Apress.Examples.SpellCheck].[GetMatch];
GO

CREATE PROCEDURE [dbo].[GetSuggestions]
	@key [nvarchar](4000),
	@distance [int]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SpellCheck].[Apress.Examples.SpellCheck].[GetSuggestions]
GO

CREATE PROCEDURE [dbo].[ReloadDictionary]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SpellCheck].[Apress.Examples.SpellCheck].[ReloadDictionary];
GO
