

ALTER TABLE [be_PostCategory] DROP CONSTRAINT [FK_be_PostCategory_be_Categories]
GO
ALTER TABLE [be_PostCategory] DROP CONSTRAINT [FK_be_PostCategory_be_Posts]
GO
ALTER TABLE [be_PostComment] DROP CONSTRAINT [FK_be_PostComment_be_Posts]
GO
ALTER TABLE [be_PostNotify] DROP CONSTRAINT [FK_be_PostNotify_be_Posts]
GO
ALTER TABLE [be_PostTag] DROP CONSTRAINT [FK_be_PostTag_be_Posts]
GO
ALTER TABLE [be_UserRoles] DROP CONSTRAINT [FK_be_UserRoles_be_Roles]
GO
ALTER TABLE [be_UserRoles] DROP CONSTRAINT [FK_be_UserRoles_be_Users]
GO

CREATE TABLE [be_Blogs] (
  [BlogRowId] int NOT NULL  IDENTITY (2,1)
, [BlogId] uniqueidentifier NOT NULL
, [BlogName] nvarchar(255) NOT NULL
, [Hostname] nvarchar(255) NOT NULL
, [IsAnyTextBeforeHostnameAccepted] bit NOT NULL
, [StorageContainerName] nvarchar(255) NOT NULL
, [VirtualPath] nvarchar(255) NOT NULL
, [IsPrimary] bit NOT NULL
, [IsActive] bit NOT NULL
);
GO
ALTER TABLE [be_Blogs] ADD CONSTRAINT [PK_be_Blogs_BlogRowId] PRIMARY KEY ([BlogRowId]);
GO
INSERT INTO [be_Blogs] ([BlogId], [BlogName], [Hostname], [IsAnyTextBeforeHostnameAccepted], [StorageContainerName], [VirtualPath], [IsPrimary], [IsActive]) VALUES (N'27604f05-86ad-47ef-9e05-950bb762570c', N'Primary', N'', 0, N'', N'~/', 1, 1)
GO
-- Adding as column with NOT NULL is not allowed, set a default value or allow NULL
ALTER TABLE [be_BlogRollItems] ADD [BlogRollRowId] int NOT NULL  IDENTITY (7,1)
GO
ALTER TABLE [be_BlogRollItems] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_BlogRollItems] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_BlogRollItems] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_BlogRollItems] DROP CONSTRAINT [PK_be_BlogRollItems_BlogRollId]
GO
ALTER TABLE [be_BlogRollItems] ADD CONSTRAINT [PK_be_BlogRollItems_BlogRollRowId] PRIMARY KEY ([BlogRollRowId]);
GO
CREATE INDEX [idx_be_BlogRollItems_BlogId] ON [be_BlogRollItems] ([BlogId] ASC);
GO
ALTER TABLE [be_Categories] ADD [CategoryRowID] int NOT NULL  IDENTITY (2,1)
GO
ALTER TABLE [be_Categories] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Categories] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Categories] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Categories] DROP CONSTRAINT [PK_be_Categories_CategoryID]
GO
ALTER TABLE [be_Categories] ADD CONSTRAINT [PK_be_Categories_CategoryRowID] PRIMARY KEY ([CategoryRowID]);
GO
CREATE UNIQUE INDEX [idx_be_Categories_BlogID_CategoryID] ON [be_Categories] ([BlogID] ASC,[CategoryID] ASC);
GO
ALTER TABLE [be_DataStoreSettings] ADD [DataStoreSettingRowId] int NOT NULL  IDENTITY (2,1)
GO
ALTER TABLE [be_DataStoreSettings] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_DataStoreSettings] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_DataStoreSettings] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_DataStoreSettings] ADD CONSTRAINT [PK_be_DataStoreSettings_DataStoreSettingRowId] PRIMARY KEY ([DataStoreSettingRowId]);
GO
CREATE INDEX [idx_be_DataStoreSettings_BlogId_ExtensionType_TypeID] ON [be_DataStoreSettings] ([BlogId] ASC,[ExtensionType] ASC,[ExtensionId] ASC);
GO
DROP INDEX [be_DataStoreSettings].[I_TypeID];
GO
ALTER TABLE [be_Pages] ADD [PageRowID] int NOT NULL  IDENTITY (1,1)
GO
ALTER TABLE [be_Pages] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Pages] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Pages] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Pages] DROP CONSTRAINT [PK_be_Pages_PageID]
GO
ALTER TABLE [be_Pages] ADD CONSTRAINT [PK_be_Pages_PageRowID] PRIMARY KEY ([PageRowID]);
GO
CREATE INDEX [idx_Pages_BlogId_PageId] ON [be_Pages] ([BlogID] ASC,[PageID] ASC);
GO
ALTER TABLE [be_PingService] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_PingService] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_PingService] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE INDEX [idx_be_PingService_BlogId] ON [be_PingService] ([BlogID] ASC);
GO
ALTER TABLE [be_PostCategory] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_PostCategory] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_PostCategory] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE INDEX [idx_be_PostCategory_BlogId_CategoryId] ON [be_PostCategory] ([BlogID] ASC,[CategoryID] ASC);
GO
CREATE INDEX [idx_be_PostCategory_BlogId_PostId] ON [be_PostCategory] ([BlogID] ASC,[PostID] ASC);
GO
DROP INDEX [be_PostCategory].[FK_CategoryID];
GO
DROP INDEX [be_PostCategory].[FK_PostID];
GO
ALTER TABLE [be_PostComment] ADD [PostCommentRowID] int NOT NULL  IDENTITY (1,1)
GO
ALTER TABLE [be_PostComment] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_PostComment] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_PostComment] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_PostComment] DROP CONSTRAINT [PK_be_PostComment_PostCommentID]
GO
ALTER TABLE [be_PostComment] ADD CONSTRAINT [PK_be_PostComment_PostCommentRowID] PRIMARY KEY ([PostCommentRowID]);
GO
CREATE INDEX [idx_be_PostComment_BlogId_PostId] ON [be_PostComment] ([BlogID] ASC,[PostID] ASC);
GO
DROP INDEX [be_PostComment].[FK_PostID];
GO
ALTER TABLE [be_PostNotify] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_PostNotify] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_PostNotify] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Posts] ADD [PostRowID] int NOT NULL  IDENTITY (2,1)
GO
ALTER TABLE [be_Posts] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Posts] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Posts] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Posts] DROP CONSTRAINT [PK_be_Posts_PostID]
GO
ALTER TABLE [be_Posts] ADD CONSTRAINT [PK_be_Posts_PostRowID] PRIMARY KEY ([PostRowID]);
GO
CREATE UNIQUE INDEX [be_Posts_BlogID_PostID] ON [be_Posts] ([BlogID] ASC,[PostID] ASC);
GO
ALTER TABLE [be_PostTag] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_PostTag] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_PostTag] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE INDEX [idx_be_PostTag_BlogId_PostId] ON [be_PostTag] ([BlogID] ASC,[PostID] ASC);
GO
DROP INDEX [be_PostTag].[FK_PostID];
GO
ALTER TABLE [be_Profiles] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Profiles] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Profiles] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE INDEX [idx_be_Profiles_BlogId_UserName] ON [be_Profiles] ([BlogID] ASC,[UserName] ASC);
GO
DROP INDEX [be_Profiles].[I_UserName];
GO
ALTER TABLE [be_Referrers] ADD [ReferrerRowId] int NOT NULL  IDENTITY (1,1)
GO
ALTER TABLE [be_Referrers] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_Referrers] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Referrers] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Referrers] DROP CONSTRAINT [PK_be_Referrers_ReferrerId]
GO
ALTER TABLE [be_Referrers] ADD CONSTRAINT [PK_be_Referrers_ReferrerRowId] PRIMARY KEY ([ReferrerRowId]);
GO
CREATE INDEX [idx_be_Referrers_BlogId] ON [be_Referrers] ([BlogId] ASC);
GO
ALTER TABLE [be_RightRoles] ADD [RightRoleRowId] int NOT NULL  IDENTITY (1,1)
GO
ALTER TABLE [be_RightRoles] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_RightRoles] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_RightRoles] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_RightRoles] DROP CONSTRAINT [PK_be_RightRoles_RightName_Role]
GO
ALTER TABLE [be_RightRoles] ADD CONSTRAINT [PK_be_RightRoles_RightRoleRowId] PRIMARY KEY ([RightRoleRowId]);
GO
CREATE INDEX [idx_be_RightRoles_BlogId] ON [be_RightRoles] ([BlogId] ASC);
GO
ALTER TABLE [be_Rights] ADD [RightRowId] int NOT NULL  IDENTITY (1,1)
GO
ALTER TABLE [be_Rights] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_Rights] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Rights] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Rights] DROP CONSTRAINT [PK_be_Rights_RightName]
GO
ALTER TABLE [be_Rights] ADD CONSTRAINT [PK_be_Rights_RightRowId] PRIMARY KEY ([RightRowId]);
GO
CREATE INDEX [idx_be_Rights_BlogId] ON [be_Rights] ([BlogId] ASC);
GO
ALTER TABLE [be_Roles] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Roles] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Roles] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE UNIQUE INDEX [idx_be_Roles_BlogID_Role] ON [be_Roles] ([BlogID] ASC,[Role] ASC);
GO
ALTER TABLE [be_Settings] ADD [SettingRowId] int NOT NULL  IDENTITY (63,1)
GO
ALTER TABLE [be_Settings] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_Settings] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Settings] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_Settings] DROP CONSTRAINT [PK_be_Settings_SettingName]
GO
ALTER TABLE [be_Settings] ADD CONSTRAINT [PK_be_Settings_SettingRowId] PRIMARY KEY ([SettingRowId]);
GO
CREATE INDEX [idx_be_Settings_BlogId] ON [be_Settings] ([BlogId] ASC);
GO
ALTER TABLE [be_StopWords] ADD [StopWordRowId] int NOT NULL  IDENTITY (109,1)
GO
ALTER TABLE [be_StopWords] ADD [BlogId] uniqueidentifier NULL  
GO
UPDATE [be_StopWords] SET [BlogId] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_StopWords] ALTER COLUMN [BlogId] uniqueidentifier NOT NULL
GO
ALTER TABLE [be_StopWords] DROP CONSTRAINT [PK_be_StopWords_StopWord]
GO
ALTER TABLE [be_StopWords] ADD CONSTRAINT [PK_be_StopWords_StopWordRowId] PRIMARY KEY ([StopWordRowId]);
GO
CREATE INDEX [idx_be_StopWords_BlogId] ON [be_StopWords] ([BlogId] ASC);
GO
CREATE TABLE [be_UserRoles_temp] (
  [UserRoleID] int NOT NULL  IDENTITY (2,1)
, [BlogID] uniqueidentifier NOT NULL
, [UserName] nvarchar(100) NOT NULL
, [Role] nvarchar(100) NOT NULL
);
GO
INSERT INTO [be_UserRoles_temp] ([BlogID],[UserName],[Role])
SELECT '27604F05-86AD-47EF-9E05-950BB762570C', u.[UserName], r.[Role]
FROM [be_UserRoles] AS ur
INNER JOIN [be_Users] AS u ON u.[UserID] = ur.[UserID]
INNER JOIN [be_Roles] AS r ON r.[RoleID] = ur.[RoleID]
GO
DROP TABLE [be_UserRoles]
GO
SP_RENAME 'be_UserRoles_temp', 'be_UserRoles'
GO
ALTER TABLE [be_UserRoles] ADD CONSTRAINT [PK_be_UserRoles_UserRoleID] PRIMARY KEY ([UserRoleID]);
GO
CREATE INDEX [idx_be_UserRoles_BlogId] ON [be_UserRoles] ([BlogID] ASC);
GO
ALTER TABLE [be_Users] ADD [BlogID] uniqueidentifier NULL  
GO
UPDATE [be_Users] SET [BlogID] = '27604F05-86AD-47EF-9E05-950BB762570C'
GO
ALTER TABLE [be_Users] ALTER COLUMN [BlogID] uniqueidentifier NOT NULL
GO
CREATE INDEX [idx_be_Users_BlogId_UserName] ON [be_Users] ([BlogID] ASC,[UserName] ASC);
GO

