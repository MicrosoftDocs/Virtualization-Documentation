--
-- be_Pages SortOrder
--
ALTER TABLE [be_Pages] ADD
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_be_Pages_SortOrder] DEFAULT 0
GO
CREATE NONCLUSTERED INDEX [IX_be_Pages] ON [be_Pages]
(
	[SortOrder]
);
GO
--
-- add new rights to administrators
--
SET IDENTITY_INSERT [be_RightRoles] ON;
GO
INSERT INTO [be_RightRoles] ([RightRoleRowId],[BlogId],[RightName],[Role]) VALUES (66,'27604f05-86ad-47ef-9e05-950bb762570c',N'ViewDashboard',N'Administrators');
GO
INSERT INTO [be_RightRoles] ([RightRoleRowId],[BlogId],[RightName],[Role]) VALUES (67,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManageExtensions',N'Administrators');
GO
INSERT INTO [be_RightRoles] ([RightRoleRowId],[BlogId],[RightName],[Role]) VALUES (68,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManageThemes',N'Administrators');
GO
INSERT INTO [be_RightRoles] ([RightRoleRowId],[BlogId],[RightName],[Role]) VALUES (69,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManagePackages',N'Administrators');
GO
SET IDENTITY_INSERT [be_RightRoles] OFF;
GO
SET IDENTITY_INSERT [be_Rights] ON;
GO
INSERT INTO [be_Rights] ([RightRowId],[BlogId],[RightName]) VALUES (41,'27604f05-86ad-47ef-9e05-950bb762570c',N'ViewDashboard');
GO
INSERT INTO [be_Rights] ([RightRowId],[BlogId],[RightName]) VALUES (42,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManageExtensions');
GO
INSERT INTO [be_Rights] ([RightRowId],[BlogId],[RightName]) VALUES (43,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManageThemes');
GO
INSERT INTO [be_Rights] ([RightRowId],[BlogId],[RightName]) VALUES (44,'27604f05-86ad-47ef-9e05-950bb762570c',N'ManagePackages');
GO
SET IDENTITY_INSERT [be_Rights] OFF;
GO
