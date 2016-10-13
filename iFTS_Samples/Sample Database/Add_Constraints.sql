USE $(DBNAME);
GO

PRINT 'Adding Constraints';
GO

ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_File_Ext] FOREIGN KEY([Book_File_Ext])
REFERENCES [dbo].[File_Ext] ([File_Ext])
GO

ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_File_Ext]
GO

ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_LoC_Subclass] FOREIGN KEY([Book_Class_Code], [Book_Subclass_Code])
REFERENCES [dbo].[LoC_Subclass] ([Class_Code], [Subclass_Code])
GO

ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_LoC_Subclass]
GO

ALTER TABLE [dbo].[Book_Commentary]  WITH CHECK ADD  CONSTRAINT [FK_Book_Commentary_Book1] FOREIGN KEY([Book_ID])
REFERENCES [dbo].[Book] ([Book_ID])
GO

ALTER TABLE [dbo].[Book_Commentary] CHECK CONSTRAINT [FK_Book_Commentary_Book1]
GO

ALTER TABLE [dbo].[Book_Commentary]  WITH CHECK ADD  CONSTRAINT [FK_Book_Commentary_Commentary] FOREIGN KEY([Commentary_ID])
REFERENCES [dbo].[Commentary] ([Commentary_ID])
GO

ALTER TABLE [dbo].[Book_Commentary] CHECK CONSTRAINT [FK_Book_Commentary_Commentary]
GO

ALTER TABLE [dbo].[Book_Subject]  WITH CHECK ADD  CONSTRAINT [FK_Book_Subject_Book] FOREIGN KEY([Book_ID])
REFERENCES [dbo].[Book] ([Book_ID])
GO

ALTER TABLE [dbo].[Book_Subject] CHECK CONSTRAINT [FK_Book_Subject_Book]
GO

ALTER TABLE [dbo].[Book_Subject]  WITH CHECK ADD  CONSTRAINT [FK_Book_Subject_Subject] FOREIGN KEY([Subject_ID])
REFERENCES [dbo].[Subject] ([Subject_ID])
GO

ALTER TABLE [dbo].[Book_Subject] CHECK CONSTRAINT [FK_Book_Subject_Subject]
GO

ALTER TABLE [dbo].[Book_Title]  WITH CHECK ADD  CONSTRAINT [FK_Book_Title_Book] FOREIGN KEY([Book_ID])
REFERENCES [dbo].[Book] ([Book_ID])
GO

ALTER TABLE [dbo].[Book_Title] CHECK CONSTRAINT [FK_Book_Title_Book]
GO

ALTER TABLE [dbo].[Book_Title]  WITH CHECK ADD  CONSTRAINT [FK_Book_Title_Title] FOREIGN KEY([Title_ID])
REFERENCES [dbo].[Title] ([Title_ID])
GO

ALTER TABLE [dbo].[Book_Title] CHECK CONSTRAINT [FK_Book_Title_Title]
GO

ALTER TABLE [dbo].[Contributor_Birth_Place]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Birth_Place_Contributor] FOREIGN KEY([Contributor_ID])
REFERENCES [dbo].[Contributor] ([Contributor_ID])
GO

ALTER TABLE [dbo].[Contributor_Birth_Place] CHECK CONSTRAINT [FK_Contributor_Birth_Place_Contributor]
GO

ALTER TABLE [dbo].[Contributor_Book]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Book_Book] FOREIGN KEY([Book_ID])
REFERENCES [dbo].[Book] ([Book_ID])
GO

ALTER TABLE [dbo].[Contributor_Book] CHECK CONSTRAINT [FK_Contributor_Book_Book]
GO

ALTER TABLE [dbo].[Contributor_Book]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Book_Contributor] FOREIGN KEY([Contributor_ID])
REFERENCES [dbo].[Contributor] ([Contributor_ID])
GO

ALTER TABLE [dbo].[Contributor_Book] CHECK CONSTRAINT [FK_Contributor_Book_Contributor]
GO

ALTER TABLE [dbo].[Contributor_Book]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Book_Contributor_Role] FOREIGN KEY([Contributor_Role_ID])
REFERENCES [dbo].[Contributor_Role] ([Contributor_Role_ID])
GO

ALTER TABLE [dbo].[Contributor_Book] CHECK CONSTRAINT [FK_Contributor_Book_Contributor_Role]
GO

ALTER TABLE [dbo].[Contributor_Information]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Information_Contributor] FOREIGN KEY([Contributor_ID])
REFERENCES [dbo].[Contributor] ([Contributor_ID])
GO

ALTER TABLE [dbo].[Contributor_Information] CHECK CONSTRAINT [FK_Contributor_Information_Contributor]
GO

ALTER TABLE [dbo].[Contributor_Key_Dates]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Key_Dates_Contributor] FOREIGN KEY([Contributor_ID])
REFERENCES [dbo].[Contributor] ([Contributor_ID])
GO

ALTER TABLE [dbo].[Contributor_Key_Dates] CHECK CONSTRAINT [FK_Contributor_Key_Dates_Contributor]
GO

ALTER TABLE [dbo].[Contributor_Key_Dates]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Key_Dates_Date_Type] FOREIGN KEY([Date_Type_ID])
REFERENCES [dbo].[Date_Type] ([Date_Type_ID])
GO

ALTER TABLE [dbo].[Contributor_Key_Dates] CHECK CONSTRAINT [FK_Contributor_Key_Dates_Date_Type]
GO

ALTER TABLE [dbo].[Contributor_Name]  WITH CHECK ADD  CONSTRAINT [FK_Contributor_Name_Contributor] FOREIGN KEY([Contributor_ID])
REFERENCES [dbo].[Contributor] ([Contributor_ID])
GO

ALTER TABLE [dbo].[Contributor_Name] CHECK CONSTRAINT [FK_Contributor_Name_Contributor]
GO

ALTER TABLE [dbo].[LoC_Subclass]  WITH CHECK ADD  CONSTRAINT [FK_LoC_Subclass_LoC_Class] FOREIGN KEY([Class_Code])
REFERENCES [dbo].[LoC_Class] ([Class_Code])
GO

ALTER TABLE [dbo].[LoC_Subclass] CHECK CONSTRAINT [FK_LoC_Subclass_LoC_Class]
GO