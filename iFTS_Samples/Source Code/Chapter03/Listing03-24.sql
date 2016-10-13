SELECT Article_Content
FROM dbo.Commentary
WHERE CONTAINS
(
	Article_Content,
	N'Bible'
)
AND Article_Content.exist(N'/article/title[contains(., "Bible")]') = 1;