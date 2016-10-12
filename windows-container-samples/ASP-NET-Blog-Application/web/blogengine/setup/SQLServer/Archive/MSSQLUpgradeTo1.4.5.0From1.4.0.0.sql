/****** BlogEngine.NET 1.4. SQL Upgrade Script ******/

/* be_Categories update */
ALTER TABLE [dbo].[be_Categories]
	ADD
		[ParentID] [uniqueidentifier] NULL

/* be_DataStoreSettings update */
ALTER TABLE [dbo].[be_DataStoreSettings]
	ALTER COLUMN Settings varchar(max)

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
INSERT INTO be_Users (UserName, Password, LastLoginTime, EmailAddress)
	VALUES ('Admin', '', GETDATE(), 'email@example.com');
INSERT INTO be_Roles (Role) 
	VALUES ('Administrators');
INSERT INTO be_Roles (Role) 
	VALUES ('Editors');
INSERT INTO be_UserRoles (UserID, RoleID)
VALUES ( 1, 1);

UPDATE be_DataStoreSettings 
SET Settings =
'<?xml version="1.0" encoding="utf-16"?>
<WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings>
</WidgetData>'
WHERE ExtensionId = 'be_WIDGET_ZONE'
GO
