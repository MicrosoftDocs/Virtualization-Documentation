--
-- be_Pages SortOrder
--
ALTER TABLE dbo.be_Pages ADD
	SortOrder int NOT NULL CONSTRAINT DF_be_Pages_SortOrder DEFAULT 0
GO
CREATE NONCLUSTERED INDEX IX_be_Pages ON dbo.be_Pages
	(
	SortOrder
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
--
-- ad unique constraints on be_Settings and be_Rights
--
   ALTER TABLE dbo.be_Settings
   ADD CONSTRAINT AK_SettingName UNIQUE (SettingName)

   ALTER TABLE dbo.be_Rights
   ADD CONSTRAINT AK_RightName UNIQUE (RightName)
--
-- add new rights to administrators
--
SET IDENTITY_INSERT [dbo].[be_RightRoles] ON 
GO
INSERT [dbo].[be_RightRoles] ([RightRoleRowId], [BlogId], [RightName], [Role]) VALUES (26131, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ViewDashboard', N'Administrators')
GO
INSERT [dbo].[be_RightRoles] ([RightRoleRowId], [BlogId], [RightName], [Role]) VALUES (26132, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManageExtensions', N'Administrators')
GO
INSERT [dbo].[be_RightRoles] ([RightRoleRowId], [BlogId], [RightName], [Role]) VALUES (26133, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManageThemes', N'Administrators')
GO
INSERT [dbo].[be_RightRoles] ([RightRoleRowId], [BlogId], [RightName], [Role]) VALUES (26134, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManagePackages', N'Administrators')
GO
SET IDENTITY_INSERT [dbo].[be_RightRoles] OFF
GO
SET IDENTITY_INSERT [dbo].[be_Rights] ON 
GO
INSERT [dbo].[be_Rights] ([RightRowId], [BlogId], [RightName]) VALUES (16081, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ViewDashboard')
GO
INSERT [dbo].[be_Rights] ([RightRowId], [BlogId], [RightName]) VALUES (16082, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManageExtensions')
GO
INSERT [dbo].[be_Rights] ([RightRowId], [BlogId], [RightName]) VALUES (16083, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManageThemes')
GO
INSERT [dbo].[be_Rights] ([RightRowId], [BlogId], [RightName]) VALUES (16084, N'27604f05-86ad-47ef-9e05-950bb762570c', N'ManagePackages')
GO
SET IDENTITY_INSERT [dbo].[be_Rights] OFF
GO





