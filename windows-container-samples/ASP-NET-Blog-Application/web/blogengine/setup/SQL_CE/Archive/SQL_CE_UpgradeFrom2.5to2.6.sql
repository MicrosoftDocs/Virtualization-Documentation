

--
-- dbo.be_Packages
--
CREATE TABLE [be_Packages](
	[PackageId] [nvarchar](128) NOT NULL,
	[Version] [nvarchar](128) NOT NULL
);
GO
ALTER TABLE [be_Packages] ADD CONSTRAINT [PK_be_Packages] PRIMARY KEY ([PackageId]);
GO


--
-- be_PackageFiles
--
CREATE TABLE [be_PackageFiles](
	[PackageId] [nvarchar](128) NOT NULL,
	[FileOrder] [int] NOT NULL,
	[FilePath] [nvarchar](255) NOT NULL,
	[IsDirectory] [bit] NOT NULL
);
GO
ALTER TABLE [be_PackageFiles] ADD CONSTRAINT [PK_be_PackageFiles] PRIMARY KEY ([PackageId], [FileOrder]);
GO

--
-- be_QuickNotes
--
CREATE TABLE [be_QuickNotes](
	[QuickNoteID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [uniqueidentifier] NOT NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Note] [ntext] NOT NULL,
	[Updated] [datetime] NULL
);
GO
ALTER TABLE [be_QuickNotes] ADD CONSTRAINT [PK_be_QuickNotes] PRIMARY KEY ([QuickNoteID]);
GO
CREATE INDEX [idx_be_NoteId_BlogId_UserName] ON [be_QuickNotes] ([NoteID] ASC,[BlogID] ASC,[UserName] ASC);
GO


--
-- be_QuickSettings
--
CREATE TABLE [be_QuickSettings](
	[QuickSettingID] [int] IDENTITY(1,1) NOT NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[SettingName] [nvarchar](255) NOT NULL,
	[SettingValue] [nvarchar](255) NOT NULL
);
GO
ALTER TABLE [be_QuickSettings] ADD CONSTRAINT [PK_be_QuickSettings] PRIMARY KEY ([QuickSettingID]);
GO


--
-- be_FileStoreDirectory
--
CREATE TABLE [be_FileStoreDirectory](
	[Id] [uniqueidentifier] NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[BlogID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FullPath] [nvarchar](1000) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastAccess] [datetime] NOT NULL,
	[LastModify] [datetime] NOT NULL
);
GO
ALTER TABLE [be_FileStoreDirectory] ADD CONSTRAINT [PK_be_FileStoreDirectory] PRIMARY KEY ([Id]);
GO


--
-- be_FileStoreFiles
--
CREATE TABLE [be_FileStoreFiles](
	[FileID] [uniqueidentifier] NOT NULL,
	[ParentDirectoryID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FullPath] [nvarchar](255) NOT NULL,
	[Contents] [image] NOT NULL,
	[Size] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastAccess] [datetime] NOT NULL,
	[LastModify] [datetime] NOT NULL
);
GO
ALTER TABLE [be_FileStoreFiles] ADD CONSTRAINT [PK_be_FileStoreFiles] PRIMARY KEY ([FileID]);
GO


--
-- be_FileStoreFileThumbs
--
CREATE TABLE [be_FileStoreFileThumbs](
	[thumbnailId] [uniqueidentifier] NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[size] [int] NOT NULL,
	[contents] [image] NOT NULL
);
GO
ALTER TABLE [be_FileStoreFileThumbs] ADD CONSTRAINT [PK_be_FileStoreFileThumbs] PRIMARY KEY ([thumbnailId]);
GO


--
-- be_Blogs
--
-- Adding as column with NOT NULL is not allowed, set a default value or allow NULL
--
ALTER TABLE [be_Blogs] ADD [IsSiteAggregation] bit NULL;
GO
UPDATE [be_Blogs] SET [IsSiteAggregation] = 0;
GO
ALTER TABLE [be_Blogs] ALTER COLUMN [IsSiteAggregation] bit NOT NULL;
GO


INSERT INTO be_Packages ([PackageId], [Version]) VALUES ('JQ-Mobile', '1.2.3');
GO

INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 1, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\App_Code\JQ-Mobile', 1);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 2, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\App_Code\JQ-Mobile\ThemeHelper.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 3, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile', 1);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 4, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls', 1);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 5, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\CommentView.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 6, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\CommentView.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 7, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\Header.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 8, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\Header.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 9, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\MainHeader.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 10, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\MainHeader.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 11, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\Pager.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 12, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\Pager.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 13, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\PostList.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 14, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\controls\PostList.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 15, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Archive.aspx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 16, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Archive.aspx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 17, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\CommentView.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 18, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Contact.aspx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 19, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Contact.aspx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 20, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\logo.png', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 21, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\newsletter.html', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 22, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Post.aspx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 23, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Post.aspx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 24, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\PostView.ascx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 25, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\PostView.ascx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 26, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Readme.txt', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 27, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Search.aspx', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 28, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\Search.aspx.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 29, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\site.master', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 30, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\site.master.cs', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 31, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\style.css', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 32, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\theme.png', 0);
GO
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 33, 'D:\Src\Hg\be\BlogEngine\BlogEngine.NET\themes\JQ-Mobile\theme.xml', 0);
GO



