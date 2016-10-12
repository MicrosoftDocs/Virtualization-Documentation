/****** BlogEngine.NET 1.4.5 SQL Setup Script ******/

/****** Object:  Table [dbo].[be_Categories]    Script Date: 12/22/2007 14:14:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Categories](
	[CategoryID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_be_Categories_CategoryID]  DEFAULT (newid()),
	[CategoryName] [nvarchar](50) NULL,
	[Description] [nvarchar](200) NULL,
	[ParentID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_be_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_DataStoreSettings]    Script Date: 06/28/2008 19:29:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[be_DataStoreSettings](
	[ExtensionType] [nvarchar](50) NOT NULL,
	[ExtensionId] [nvarchar](100) NOT NULL,
	[Settings] [nvarchar](max) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[be_Pages]    Script Date: 12/22/2007 14:15:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Pages](
	[PageID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_be_Pages_PageID]  DEFAULT (newid()),
	[Title] [nvarchar](255) NULL,
	[Description] [nvarchar](max) NULL,
	[PageContent] [nvarchar](max) NULL,
	[Keywords] [nvarchar](max) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[IsPublished] [bit] NULL,
	[IsFrontPage] [bit] NULL,
	[Parent] [uniqueidentifier] NULL,
	[ShowInList] [bit] NULL,
 CONSTRAINT [PK_be_Pages] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_PingService]    Script Date: 12/22/2007 14:15:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_PingService](
	[PingServiceID] [int] IDENTITY(1,1) NOT NULL,
	[Link] [nvarchar](255) NULL,
 CONSTRAINT [PK_be_PingService] PRIMARY KEY CLUSTERED 
(
	[PingServiceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_Posts]    Script Date: 12/22/2007 14:16:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Posts](
	[PostID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_be_Posts_PostID]  DEFAULT (newid()),
	[Title] [nvarchar](255) NULL,
	[Description] [nvarchar](max) NULL,
	[PostContent] [nvarchar](max) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[Author] [nvarchar](50) NULL,
	[IsPublished] [bit] NULL,
	[IsCommentEnabled] [bit] NULL,
	[Raters] [int] NULL,
	[Rating] [real] NULL,
	[Slug] [nvarchar](255) NULL,
 CONSTRAINT [PK_be_Posts] PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_Settings]    Script Date: 12/22/2007 14:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Settings](
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_be_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_Profiles]    Script Date: 06/28/2008 19:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Profiles](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[SettingName] [nvarchar](200) NULL,
	[SettingValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_be_Profiles] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_StopWords]    Script Date: 06/28/2008 19:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_StopWords](
	[StopWord] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_be_StopWords] PRIMARY KEY CLUSTERED 
(
	[StopWord] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_PostCategory]    Script Date: 12/22/2007 14:17:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_PostCategory](
	[PostCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[PostID] [uniqueidentifier] NOT NULL,
	[CategoryID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_be_PostCategory] PRIMARY KEY CLUSTERED 
(
	[PostCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[be_PostCategory]  WITH CHECK ADD  CONSTRAINT [FK_be_PostCategory_be_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[be_Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[be_PostCategory] CHECK CONSTRAINT [FK_be_PostCategory_be_Categories]
GO
ALTER TABLE [dbo].[be_PostCategory]  WITH CHECK ADD  CONSTRAINT [FK_be_PostCategory_be_Posts] FOREIGN KEY([PostID])
REFERENCES [dbo].[be_Posts] ([PostID])
GO
ALTER TABLE [dbo].[be_PostCategory] CHECK CONSTRAINT [FK_be_PostCategory_be_Posts]
GO
/****** Object:  Table [dbo].[be_PostComment]    Script Date: 12/22/2007 14:17:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_PostComment](
	[PostCommentID] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_be_PostComment_PostCommentID]  DEFAULT (newid()),
	[PostID] [uniqueidentifier] NOT NULL,
	[CommentDate] [datetime] NOT NULL,
	[Author] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[Comment] [nvarchar](max) NULL,
	[Country] [nvarchar](255) NULL,
	[Ip] [nvarchar](50) NULL,
	[IsApproved] [bit] NULL,
 CONSTRAINT [PK_be_PostComment] PRIMARY KEY CLUSTERED 
(
	[PostCommentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[be_PostComment]  WITH CHECK ADD  CONSTRAINT [FK_be_PostComment_be_Posts] FOREIGN KEY([PostID])
REFERENCES [dbo].[be_Posts] ([PostID])
GO
ALTER TABLE [dbo].[be_PostComment] CHECK CONSTRAINT [FK_be_PostComment_be_Posts]
GO
/****** Object:  Table [dbo].[be_PostNotify]    Script Date: 12/22/2007 14:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_PostNotify](
	[PostNotifyID] [int] IDENTITY(1,1) NOT NULL,
	[PostID] [uniqueidentifier] NOT NULL,
	[NotifyAddress] [nvarchar](255) NULL,
 CONSTRAINT [PK_be_PostNotify] PRIMARY KEY CLUSTERED 
(
	[PostNotifyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[be_PostNotify]  WITH CHECK ADD  CONSTRAINT [FK_be_PostNotify_be_Posts] FOREIGN KEY([PostID])
REFERENCES [dbo].[be_Posts] ([PostID])
GO
ALTER TABLE [dbo].[be_PostNotify] CHECK CONSTRAINT [FK_be_PostNotify_be_Posts]
GO
/****** Object:  Table [dbo].[be_PostTag]    Script Date: 12/22/2007 14:17:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_PostTag](
	[PostTagID] [int] IDENTITY(1,1) NOT NULL,
	[PostID] [uniqueidentifier] NOT NULL,
	[Tag] [nvarchar](50) NULL,
 CONSTRAINT [PK_be_PostTag] PRIMARY KEY CLUSTERED 
(
	[PostTagID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[be_PostTag]  WITH CHECK ADD  CONSTRAINT [FK_be_PostTag_be_Posts] FOREIGN KEY([PostID])
REFERENCES [dbo].[be_Posts] ([PostID])
GO
ALTER TABLE [dbo].[be_PostTag] CHECK CONSTRAINT [FK_be_PostTag_be_Posts]
GO
/****** Object:  Table [dbo].[be_Users]    Script Date: 07/30/2008 21:55:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[LastLoginTime] [datetime] NULL,
	[EmailAddress] [nvarchar](100) NULL,
 CONSTRAINT [PK_be_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_Roles]    Script Date: 07/30/2008 21:56:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_be_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[be_UserRoles]    Script Date: 07/31/2008 12:26:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[be_UserRoles](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_be_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[be_UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_be_UserRoles_be_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[be_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[be_UserRoles] CHECK CONSTRAINT [FK_be_UserRoles_be_Roles]
GO
ALTER TABLE [dbo].[be_UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_be_UserRoles_be_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[be_Users] ([UserID])
GO
ALTER TABLE [dbo].[be_UserRoles] CHECK CONSTRAINT [FK_be_UserRoles_be_Users]
GO
/****** Object:  Index [FK_PostID]    Script Date: 12/22/2007 14:18:36 ******/
CREATE NONCLUSTERED INDEX [FK_PostID] ON [dbo].[be_PostCategory] 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_CategoryID]    Script Date: 12/22/2007 14:19:19 ******/
CREATE NONCLUSTERED INDEX [FK_CategoryID] ON [dbo].[be_PostCategory] 
(
	[CategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_PostID]    Script Date: 12/22/2007 14:19:45 ******/
CREATE NONCLUSTERED INDEX [FK_PostID] ON [dbo].[be_PostComment] 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_PostID]    Script Date: 12/22/2007 14:20:29 ******/
CREATE NONCLUSTERED INDEX [FK_PostID] ON [dbo].[be_PostNotify] 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_PostID]    Script Date: 12/22/2007 14:20:43 ******/
CREATE NONCLUSTERED INDEX [FK_PostID] ON [dbo].[be_PostTag] 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [I_TypeID]    Script Date: 06/28/2008 19:34:43 ******/
CREATE NONCLUSTERED INDEX [I_TypeID] ON [dbo].[be_DataStoreSettings] 
(
	[ExtensionType] ASC,
	[ExtensionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Index [I_UserName]    Script Date: 06/28/2008 19:35:12 ******/
CREATE NONCLUSTERED INDEX [I_UserName] ON [dbo].[be_Profiles] 
(
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/***  Load initial Data ***/
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('administratorrole', 'Administrators');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('alternatefeedurl', '');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('authorname', 'My name');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('avatar', 'combine');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('blogrollmaxlength', '23');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('blogrollupdateminutes', '60');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('blogrollvisibleposts', '3');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('contactformmessage', '<p>I will answer the mail as soon as I can.</p>');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('contactthankmessage', '<h1>Thank you</h1><p>The message was sent.</p>');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('culture', 'Auto');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('dayscommentsareenabled', '0');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('description', 'Short description of the blog');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('displaycommentsonrecentposts', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('displayratingsonrecentposts', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('email', 'user@example.com');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('emailsubjectprefix', 'Weblog');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablecommentsearch', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablecommentsmoderation', 'False');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablecontactattachments', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablecountryincomments', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablehttpcompression', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enableopensearch', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablepingbackreceive', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablepingbacksend', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablerating', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablereferrertracking', 'False');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablerelatedposts', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enablessl', 'False');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enabletrackbackreceive', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('enabletrackbacksend', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('endorsement', 'http://www.dotnetblogengine.net/syndication.axd');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('fileextension', '.aspx');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('geocodinglatitude', '0');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('geocodinglongitude', '0');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('handlewwwsubdomain', '');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('iscocommentenabled', 'False');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('iscommentsenabled', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('language', 'en-GB');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('mobiletheme', 'Mobile');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('name', 'Name of the blog');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('numberofrecentcomments', '10');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('numberofrecentposts', '10');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('postsperfeed', '10');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('postsperpage', '10');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('removewhitespaceinstylesheets', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('searchbuttontext', 'Search');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('searchcommentlabeltext', 'Include comments in search');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('searchdefaulttext', 'Enter search term');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('sendmailoncomment', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('showdescriptioninpostlist', 'False');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('showlivepreview', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('showpostnavigation', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('smtppassword', 'password');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('smtpserver', 'mail.example.dk');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('smtpserverport', '25');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('smtpusername', 'user@example.com');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('storagelocation', '~/App_Data/');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('syndicationformat', 'Rss');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('theme', 'Standard');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('timestamppostlinks', 'True');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('timezone', '-5');
INSERT INTO be_Settings (SettingName, SettingValue)	VALUES ('trackingscript', '');

INSERT INTO be_PingService (Link) VALUES ('http://rpc.technorati.com/rpc/ping');
INSERT INTO be_PingService (Link) VALUES ('http://rpc.pingomatic.com/rpc2');
INSERT INTO be_PingService (Link) VALUES ('http://ping.feedburner.com');
INSERT INTO be_PingService (Link) VALUES ('http://www.bloglines.com/ping');
INSERT INTO be_PingService (Link) VALUES ('http://services.newsgator.com/ngws/xmlrpcping.aspx');
INSERT INTO be_PingService (Link) VALUES ('http://api.my.yahoo.com/rpc2 ');
INSERT INTO be_PingService (Link) VALUES ('http://blogsearch.google.com/ping/RPC2');
INSERT INTO be_PingService (Link) VALUES ('http://rpc.pingthesemanticweb.com/');

INSERT INTO be_StopWords (StopWord)	VALUES ('a');
INSERT INTO be_StopWords (StopWord)	VALUES ('about');
INSERT INTO be_StopWords (StopWord)	VALUES ('actually');
INSERT INTO be_StopWords (StopWord)	VALUES ('add');
INSERT INTO be_StopWords (StopWord)	VALUES ('after');
INSERT INTO be_StopWords (StopWord)	VALUES ('all');
INSERT INTO be_StopWords (StopWord)	VALUES ('almost');
INSERT INTO be_StopWords (StopWord)	VALUES ('along');
INSERT INTO be_StopWords (StopWord)	VALUES ('also');
INSERT INTO be_StopWords (StopWord)	VALUES ('an');
INSERT INTO be_StopWords (StopWord)	VALUES ('and');
INSERT INTO be_StopWords (StopWord)	VALUES ('any');
INSERT INTO be_StopWords (StopWord)	VALUES ('are');
INSERT INTO be_StopWords (StopWord)	VALUES ('as');
INSERT INTO be_StopWords (StopWord)	VALUES ('at');
INSERT INTO be_StopWords (StopWord)	VALUES ('be');
INSERT INTO be_StopWords (StopWord)	VALUES ('both');
INSERT INTO be_StopWords (StopWord)	VALUES ('but');
INSERT INTO be_StopWords (StopWord)	VALUES ('by');
INSERT INTO be_StopWords (StopWord)	VALUES ('can');
INSERT INTO be_StopWords (StopWord)	VALUES ('cannot');
INSERT INTO be_StopWords (StopWord)	VALUES ('com');
INSERT INTO be_StopWords (StopWord)	VALUES ('could');
INSERT INTO be_StopWords (StopWord)	VALUES ('de');
INSERT INTO be_StopWords (StopWord)	VALUES ('do');
INSERT INTO be_StopWords (StopWord)	VALUES ('down');
INSERT INTO be_StopWords (StopWord)	VALUES ('each');
INSERT INTO be_StopWords (StopWord)	VALUES ('either');
INSERT INTO be_StopWords (StopWord)	VALUES ('en');
INSERT INTO be_StopWords (StopWord)	VALUES ('for');
INSERT INTO be_StopWords (StopWord)	VALUES ('from');
INSERT INTO be_StopWords (StopWord)	VALUES ('good');
INSERT INTO be_StopWords (StopWord)	VALUES ('has');
INSERT INTO be_StopWords (StopWord)	VALUES ('have');
INSERT INTO be_StopWords (StopWord)	VALUES ('he');
INSERT INTO be_StopWords (StopWord)	VALUES ('her');
INSERT INTO be_StopWords (StopWord)	VALUES ('here');
INSERT INTO be_StopWords (StopWord)	VALUES ('hers');
INSERT INTO be_StopWords (StopWord)	VALUES ('his');
INSERT INTO be_StopWords (StopWord)	VALUES ('how');
INSERT INTO be_StopWords (StopWord)	VALUES ('i');
INSERT INTO be_StopWords (StopWord)	VALUES ('if');
INSERT INTO be_StopWords (StopWord)	VALUES ('in');
INSERT INTO be_StopWords (StopWord)	VALUES ('into');
INSERT INTO be_StopWords (StopWord)	VALUES ('is');
INSERT INTO be_StopWords (StopWord)	VALUES ('it');
INSERT INTO be_StopWords (StopWord)	VALUES ('its');
INSERT INTO be_StopWords (StopWord)	VALUES ('just');
INSERT INTO be_StopWords (StopWord)	VALUES ('la');
INSERT INTO be_StopWords (StopWord)	VALUES ('like');
INSERT INTO be_StopWords (StopWord)	VALUES ('long');
INSERT INTO be_StopWords (StopWord)	VALUES ('make');
INSERT INTO be_StopWords (StopWord)	VALUES ('me');
INSERT INTO be_StopWords (StopWord)	VALUES ('more');
INSERT INTO be_StopWords (StopWord)	VALUES ('much');
INSERT INTO be_StopWords (StopWord)	VALUES ('my');
INSERT INTO be_StopWords (StopWord)	VALUES ('need');
INSERT INTO be_StopWords (StopWord)	VALUES ('new');
INSERT INTO be_StopWords (StopWord)	VALUES ('now');
INSERT INTO be_StopWords (StopWord)	VALUES ('of');
INSERT INTO be_StopWords (StopWord)	VALUES ('off');
INSERT INTO be_StopWords (StopWord)	VALUES ('on');
INSERT INTO be_StopWords (StopWord)	VALUES ('once');
INSERT INTO be_StopWords (StopWord)	VALUES ('one');
INSERT INTO be_StopWords (StopWord)	VALUES ('ones');
INSERT INTO be_StopWords (StopWord)	VALUES ('only');
INSERT INTO be_StopWords (StopWord)	VALUES ('or');
INSERT INTO be_StopWords (StopWord)	VALUES ('our');
INSERT INTO be_StopWords (StopWord)	VALUES ('out');
INSERT INTO be_StopWords (StopWord)	VALUES ('over');
INSERT INTO be_StopWords (StopWord)	VALUES ('own');
INSERT INTO be_StopWords (StopWord)	VALUES ('really');
INSERT INTO be_StopWords (StopWord)	VALUES ('right');
INSERT INTO be_StopWords (StopWord)	VALUES ('same');
INSERT INTO be_StopWords (StopWord)	VALUES ('see');
INSERT INTO be_StopWords (StopWord)	VALUES ('she');
INSERT INTO be_StopWords (StopWord)	VALUES ('so');
INSERT INTO be_StopWords (StopWord)	VALUES ('some');
INSERT INTO be_StopWords (StopWord)	VALUES ('such');
INSERT INTO be_StopWords (StopWord)	VALUES ('take');
INSERT INTO be_StopWords (StopWord)	VALUES ('takes');
INSERT INTO be_StopWords (StopWord)	VALUES ('that');
INSERT INTO be_StopWords (StopWord)	VALUES ('the');
INSERT INTO be_StopWords (StopWord)	VALUES ('their');
INSERT INTO be_StopWords (StopWord)	VALUES ('these');
INSERT INTO be_StopWords (StopWord)	VALUES ('thing');
INSERT INTO be_StopWords (StopWord)	VALUES ('this');
INSERT INTO be_StopWords (StopWord)	VALUES ('to');
INSERT INTO be_StopWords (StopWord)	VALUES ('too');
INSERT INTO be_StopWords (StopWord)	VALUES ('took');
INSERT INTO be_StopWords (StopWord)	VALUES ('und');
INSERT INTO be_StopWords (StopWord)	VALUES ('up');
INSERT INTO be_StopWords (StopWord)	VALUES ('use');
INSERT INTO be_StopWords (StopWord)	VALUES ('used');
INSERT INTO be_StopWords (StopWord)	VALUES ('using');
INSERT INTO be_StopWords (StopWord)	VALUES ('very');
INSERT INTO be_StopWords (StopWord)	VALUES ('was');
INSERT INTO be_StopWords (StopWord)	VALUES ('we');
INSERT INTO be_StopWords (StopWord)	VALUES ('well');
INSERT INTO be_StopWords (StopWord)	VALUES ('what');
INSERT INTO be_StopWords (StopWord)	VALUES ('when');
INSERT INTO be_StopWords (StopWord)	VALUES ('where');
INSERT INTO be_StopWords (StopWord)	VALUES ('who');
INSERT INTO be_StopWords (StopWord)	VALUES ('will');
INSERT INTO be_StopWords (StopWord)	VALUES ('with');
INSERT INTO be_StopWords (StopWord)	VALUES ('www');
INSERT INTO be_StopWords (StopWord)	VALUES ('you');
INSERT INTO be_StopWords (StopWord)	VALUES ('your');

DECLARE @postID uniqueidentifier, @catID uniqueidentifier;

SET @postID = NEWID();
SET @catID = NEWID();

INSERT INTO be_Categories (CategoryID, CategoryName)
	VALUES (@catID, 'General');

INSERT INTO be_Posts (PostID, Title, Description, PostContent, DateCreated, Author, IsPublished)
	VALUES (@postID, 
	'Welcome to BlogEngine.NET 1.4.5 using Microsoft SQL Server', 
	'The description is used as the meta description as well as shown in the related posts. It is recommended that you write a description, but not mandatory',
	'<p>If you see this post it means that BlogEngine.NET 1.4.5 is running with SQL Server and the DbBlogProvider is configured correctly.</p>
	<h2>Setup</h2>
	<p>If you are using the ASP.NET Membership provider, you are set to use existing users.  If you are using the default BlogEngine.NET XML provider, it is time to setup some users.  Find the sign-in link located either at the bottom or top of the page depending on your current theme and click it. Now enter "admin" in both the username and password fields and click the button. You will now see an admin menu appear. It has a link to the "Users" admin page. From there you can change the username and password.</p>
	<h2>Write permissions</h2>
	<p>Since you are using SQL to store your posts, most information is stored there.  However, if you want to store attachments or images in the blog, you will want write permissions setup on the App_Data folder.</p>
	<h2>On the web </h2>
	<p>You can find BlogEngine.NET on the <a href="http://www.dotnetblogengine.net">official website</a>. Here you will find tutorials, documentation, tips and tricks and much more. The ongoing development of BlogEngine.NET can be followed at <a href="http://www.codeplex.com/blogengine">CodePlex</a> where the daily builds will be published for anyone to download.</p>
	<p>Good luck and happy writing.</p>
	<p>The BlogEngine.NET team</p>',
	GETDATE(), 
	'admin',
	1);

INSERT INTO be_PostCategory (PostID, CategoryID)
	VALUES (@postID, @catID);
INSERT INTO be_PostTag (PostID, Tag)
	VALUES (@postID, 'blog');
INSERT INTO be_PostTag (PostID, Tag)
	VALUES (@postID, 'welcome');

INSERT INTO be_Users (UserName, Password, LastLoginTime, EmailAddress)
	VALUES ('Admin', '', GETDATE(), 'email@example.com');
INSERT INTO be_Roles (Role) 
	VALUES ('Administrators');
INSERT INTO be_Roles (Role) 
	VALUES ('Editors');
INSERT INTO be_UserRoles (UserID, RoleID)
VALUES (1, 1);

INSERT INTO be_DataStoreSettings (ExtensionType, ExtensionId, Settings)
VALUES (1, 'be_WIDGET_ZONE', 
'<?xml version="1.0" encoding="utf-16"?>
<WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings>
</WidgetData>');

GO
