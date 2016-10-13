EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE WITH OVERRIDE;
GO

EXECUTE sp_configure 'transform noise words', 1;
RECONFIGURE WITH OVERRIDE;
GO