/****** BlogEngine.NET 1.4.5 SQL Upgrade Script from 1.3.x ******/

/* be_Categories update */
ALTER TABLE [dbo].[be_Categories]
	ADD
		[ParentID] [uniqueidentifier] NULL
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
/***  Load StopWords Data ***/
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

INSERT INTO be_Users (UserName, Password, LastLoginTime, EmailAddress)
	VALUES ('Admin', '', GETDATE(), 'email@example.com');
INSERT INTO be_Roles (Role) 
	VALUES ('Administrators');
INSERT INTO be_Roles (Role) 
	VALUES ('Editors');
INSERT INTO be_UserRoles (UserID, RoleID)
VALUES ( 1, 1);

INSERT INTO be_DataStoreSettings (ExtensionType, ExtensionId, Settings)
VALUES (1, 'be_WIDGET_ZONE', 
'<?xml version="1.0" encoding="utf-16"?>
<WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings>
</WidgetData>');
GO
