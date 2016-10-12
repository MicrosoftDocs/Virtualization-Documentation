/****** BlogEngine.NET 1.5 SQL Upgrade Script ******/

/* be_PostComment update */
ALTER TABLE [dbo].[be_PostComment]
	ADD
		[ParentCommentID] [uniqueidentifier] NOT NULL DEFAULT ('00000000-0000-0000-0000-000000000000')
