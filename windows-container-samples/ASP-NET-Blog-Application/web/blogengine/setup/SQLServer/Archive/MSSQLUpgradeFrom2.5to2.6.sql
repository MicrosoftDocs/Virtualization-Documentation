


--
-- dbo.be_Packages
--
CREATE TABLE [dbo].[be_Packages](
	[PackageId] [nvarchar](128) NOT NULL,
	[Version] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_be_Packages] PRIMARY KEY CLUSTERED 
(
	[PackageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--
-- be_PackageFiles
--
CREATE TABLE [dbo].[be_PackageFiles](
	[PackageId] [nvarchar](128) NOT NULL,
	[FileOrder] [int] NOT NULL,
	[FilePath] [nvarchar](255) NOT NULL,
	[IsDirectory] [bit] NOT NULL,
 CONSTRAINT [PK_be_PackageFiles] PRIMARY KEY CLUSTERED 
(
	[PackageId] ASC,
	[FileOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--
-- be_QuickNotes
--
CREATE TABLE [dbo].[be_QuickNotes](
	[QuickNoteID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [uniqueidentifier] NOT NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_be_QuickNotes] PRIMARY KEY CLUSTERED 
(
	[QuickNoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [idx_be_NoteId_BlogId_UserName] ON [dbo].[be_QuickNotes] 
(
	[NoteID] ASC,
	[BlogID] ASC,
	[UserName] ASC
)
GO


--
-- be_QuickSettings
--
CREATE TABLE [dbo].[be_QuickSettings](
	[QuickSettingID] [int] IDENTITY(1,1) NOT NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[SettingName] [nvarchar](255) NOT NULL,
	[SettingValue] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_be_QuickSettings] PRIMARY KEY CLUSTERED 
(
	[QuickSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


--
-- be_FileStoreDirectory
--
CREATE TABLE [dbo].[be_FileStoreDirectory](
	[Id] [uniqueidentifier] NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[FullPath] [varchar](1000) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastAccess] [datetime] NOT NULL,
	[LastModify] [datetime] NOT NULL,
 CONSTRAINT [PK_be_FileStoreDirectory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--
-- be_FileStoreFiles
--
CREATE TABLE [dbo].[be_FileStoreFiles](
	[FileID] [uniqueidentifier] NOT NULL,
	[ParentDirectoryID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[FullPath] [varchar](255) NOT NULL,
	[Contents] [varbinary](max) NOT NULL,
	[Size] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastAccess] [datetime] NOT NULL,
	[LastModify] [datetime] NOT NULL,
 CONSTRAINT [PK_be_FileStoreFiles] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[be_FileStoreFiles]  WITH CHECK ADD CONSTRAINT [FK_be_FileStoreFiles_be_FileStoreDirectory] FOREIGN KEY([ParentDirectoryID])
REFERENCES [dbo].[be_FileStoreDirectory] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[be_FileStoreFiles] CHECK CONSTRAINT [FK_be_FileStoreFiles_be_FileStoreDirectory]
GO


--
-- be_FileStoreFileThumbs
--
CREATE TABLE [dbo].[be_FileStoreFileThumbs](
	[thumbnailId] [uniqueidentifier] NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[size] [int] NOT NULL,
	[contents] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_be_FileStoreFileThumbs] PRIMARY KEY CLUSTERED 
(
	[thumbnailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[be_FileStoreFileThumbs]  WITH CHECK ADD CONSTRAINT [FK_be_FileStoreFileThumbs_be_FileStoreFiles] FOREIGN KEY([FileId])
REFERENCES [dbo].[be_FileStoreFiles] ([FileID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[be_FileStoreFileThumbs] CHECK CONSTRAINT [FK_be_FileStoreFileThumbs_be_FileStoreFiles]
GO


--
-- be_Blogs
--
ALTER TABLE dbo.be_Blogs ADD
	IsSiteAggregation bit NOT NULL CONSTRAINT DF_be_Blogs_IsSiteAggregation DEFAULT 0
GO





