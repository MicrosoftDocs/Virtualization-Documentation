

SET CONCAT_NULL_YIELDS_NULL, ANSI_NULLS, ANSI_PADDING, QUOTED_IDENTIFIER, ANSI_WARNINGS, ARITHABORT ON
SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS, XACT_ABORT OFF
GO

--
-- Drop foreign key FK_be_PostCategory_be_Categories on table "be_PostCategory"
--
ALTER TABLE dbo.be_PostCategory
  DROP CONSTRAINT FK_be_PostCategory_be_Categories
GO

--
-- Drop foreign key FK_be_PostCategory_be_Posts on table "be_PostCategory"
--
ALTER TABLE dbo.be_PostCategory
  DROP CONSTRAINT FK_be_PostCategory_be_Posts
GO

--
-- Drop foreign key FK_be_PostComment_be_Posts on table "be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  DROP CONSTRAINT FK_be_PostComment_be_Posts
GO

--
-- Drop foreign key FK_be_PostNotify_be_Posts on table "be_PostNotify"
--
ALTER TABLE dbo.be_PostNotify
  DROP CONSTRAINT FK_be_PostNotify_be_Posts
GO

--
-- Drop foreign key FK_be_PostTag_be_Posts on table "be_PostTag"
--
ALTER TABLE dbo.be_PostTag
  DROP CONSTRAINT FK_be_PostTag_be_Posts
GO

--
-- Create column "BlogID" on table "dbo.be_Users"
--
ALTER TABLE dbo.be_Users
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Users SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Users
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create index "idx_be_Users_BlogId_UserName" on table "be_Users"
--
CREATE INDEX idx_be_Users_BlogId_UserName
  ON dbo.be_Users (BlogID, UserName)
GO

--
-- Drop foreign key FK_be_UserRoles_be_Roles on table "be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  DROP CONSTRAINT FK_be_UserRoles_be_Roles
GO

--
-- Drop foreign key FK_be_UserRoles_be_Users on table "be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  DROP CONSTRAINT FK_be_UserRoles_be_Users
GO

--
-- Create column "BlogID" on table "dbo.be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_UserRoles SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_UserRoles
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create column "UserName" on table "dbo.be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  ADD UserName nvarchar(100) NULL
GO

--
-- Create column "[Role]" on table "dbo.be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  ADD [Role] nvarchar(100) NULL
GO

--
-- Insert/Lookup values for UserName and Role on table "dbo.be_UserRoles"
--
UPDATE dbo.be_UserRoles
SET [UserName] =
(
SELECT [UserName]
FROM dbo.be_Users
WHERE dbo.be_Users.[UserID] = dbo.be_UserRoles.[UserID]
),
[Role] = 
(
SELECT [Role]
FROM dbo.be_Roles
WHERE dbo.be_Roles.RoleID = dbo.be_UserRoles.RoleID
);

ALTER TABLE dbo.be_UserRoles
  ALTER
    COLUMN UserName nvarchar(100) NOT NULL
GO

ALTER TABLE dbo.be_UserRoles
  ALTER
    COLUMN [Role] nvarchar(100) NOT NULL
GO

--
-- Drop column "UserID" from table "dbo.be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  DROP COLUMN UserID
GO

--
-- Drop column "RoleID" from table "dbo.be_UserRoles"
--
ALTER TABLE dbo.be_UserRoles
  DROP COLUMN RoleID
GO

--
-- Create index "idx_be_UserRoles_BlogId" on table "be_UserRoles"
--
CREATE INDEX idx_be_UserRoles_BlogId
  ON dbo.be_UserRoles (BlogID)
GO

--
-- Drop primary key PK_be_StopWords on table "be_StopWords"
--
ALTER TABLE dbo.be_StopWords
  DROP CONSTRAINT PK_be_StopWords
GO

--
-- Create column "StopWordRowId" on table "dbo.be_StopWords"
--
ALTER TABLE dbo.be_StopWords
  ADD StopWordRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_StopWords"
--
ALTER TABLE dbo.be_StopWords
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_StopWords SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_StopWords
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_StopWords on table "be_StopWords"
--
ALTER TABLE dbo.be_StopWords
  ADD CONSTRAINT PK_be_StopWords PRIMARY KEY (StopWordRowId)
GO

--
-- Create index "idx_be_StopWords_BlogId" on table "be_StopWords"
--
CREATE INDEX idx_be_StopWords_BlogId
  ON dbo.be_StopWords (BlogId)
GO

--
-- Drop primary key PK_be_Settings on table "be_Settings"
--
ALTER TABLE dbo.be_Settings
  DROP CONSTRAINT PK_be_Settings
GO

--
-- Create column "SettingRowId" on table "dbo.be_Settings"
--
ALTER TABLE dbo.be_Settings
  ADD SettingRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_Settings"
--
ALTER TABLE dbo.be_Settings
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_Settings SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Settings
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Settings on table "be_Settings"
--
ALTER TABLE dbo.be_Settings
  ADD CONSTRAINT PK_be_Settings PRIMARY KEY (SettingRowId)
GO

--
-- Create index "idx_be_Settings_BlogId" on table "be_Settings"
--
CREATE INDEX idx_be_Settings_BlogId
  ON dbo.be_Settings (BlogId)
GO

--
-- Create column "BlogID" on table "dbo.be_Roles"
--
ALTER TABLE dbo.be_Roles
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Roles SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Roles
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create index "idx_be_Roles_BlogID_Role" on table "be_Roles"
--
CREATE UNIQUE INDEX idx_be_Roles_BlogID_Role
  ON dbo.be_Roles (BlogID, [Role])
GO

--
-- Drop primary key PK_be_Rights on table "be_Rights"
--
ALTER TABLE dbo.be_Rights
  DROP CONSTRAINT PK_be_Rights
GO

--
-- Create column "RightRowId" on table "dbo.be_Rights"
--
ALTER TABLE dbo.be_Rights
  ADD RightRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_Rights"
--
ALTER TABLE dbo.be_Rights
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_Rights SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Rights
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Rights on table "be_Rights"
--
ALTER TABLE dbo.be_Rights
  ADD CONSTRAINT PK_be_Rights PRIMARY KEY (RightRowId)
GO

--
-- Create index "idx_be_Rights_BlogId" on table "be_Rights"
--
CREATE INDEX idx_be_Rights_BlogId
  ON dbo.be_Rights (BlogId)
GO

--
-- Drop primary key PK_be_RightRoles on table "be_RightRoles"
--
ALTER TABLE dbo.be_RightRoles
  DROP CONSTRAINT PK_be_RightRoles
GO

--
-- Create column "RightRoleRowId" on table "dbo.be_RightRoles"
--
ALTER TABLE dbo.be_RightRoles
  ADD RightRoleRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_RightRoles"
--
ALTER TABLE dbo.be_RightRoles
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_RightRoles SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_RightRoles
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_RightRoles on table "be_RightRoles"
--
ALTER TABLE dbo.be_RightRoles
  ADD CONSTRAINT PK_be_RightRoles PRIMARY KEY (RightRoleRowId)
GO

--
-- Create index "idx_be_RightRoles_BlogId" on table "be_RightRoles"
--
CREATE INDEX idx_be_RightRoles_BlogId
  ON dbo.be_RightRoles (BlogId)
GO

--
-- Drop primary key PK_be_Referrers on table "be_Referrers"
--
ALTER TABLE dbo.be_Referrers
  DROP CONSTRAINT PK_be_Referrers
GO

--
-- Create column "ReferrerRowId" on table "dbo.be_Referrers"
--
ALTER TABLE dbo.be_Referrers
  ADD ReferrerRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_Referrers"
--
ALTER TABLE dbo.be_Referrers
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_Referrers SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Referrers
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Referrers on table "be_Referrers"
--
ALTER TABLE dbo.be_Referrers
  ADD CONSTRAINT PK_be_Referrers PRIMARY KEY (ReferrerRowId)
GO

--
-- Create index "idx_be_Referrers_BlogId" on table "be_Referrers"
--
CREATE INDEX idx_be_Referrers_BlogId
  ON dbo.be_Referrers (BlogId)
GO

--
-- Drop index "I_UserName" from table "be_Profiles"
--
DROP INDEX I_UserName ON dbo.be_Profiles
GO

--
-- Create column "BlogID" on table "dbo.be_Profiles"
--
ALTER TABLE dbo.be_Profiles
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Profiles SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Profiles
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create index "idx_be_Profiles_BlogId_UserName" on table "be_Profiles"
--
CREATE INDEX idx_be_Profiles_BlogId_UserName
  ON dbo.be_Profiles (BlogID, UserName)
GO

--
-- Drop primary key PK_be_Posts on table "be_Posts"
--
ALTER TABLE dbo.be_Posts
  DROP CONSTRAINT PK_be_Posts
GO

--
-- Create column "PostRowID" on table "dbo.be_Posts"
--
ALTER TABLE dbo.be_Posts
  ADD PostRowID int IDENTITY
GO

--
-- Create column "BlogID" on table "dbo.be_Posts"
--
ALTER TABLE dbo.be_Posts
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Posts SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Posts
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Posts on table "be_Posts"
--
ALTER TABLE dbo.be_Posts
  ADD CONSTRAINT PK_be_Posts PRIMARY KEY (PostRowID)
GO

--
-- Create index "be_Posts_BlogID_PostID" on table "be_Posts"
--
CREATE UNIQUE INDEX be_Posts_BlogID_PostID
  ON dbo.be_Posts (BlogID, PostID)
GO

--
-- Drop index "FK_PostID" from table "be_PostTag"
--
DROP INDEX FK_PostID ON dbo.be_PostTag
GO

--
-- Create column "BlogID" on table "dbo.be_PostTag"
--
ALTER TABLE dbo.be_PostTag
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_PostTag SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_PostTag
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create foreign key  on table "be_PostTag"
--
ALTER TABLE dbo.be_PostTag
  ADD CONSTRAINT FK_be_PostTag_be_Posts FOREIGN KEY (BlogID, PostID) REFERENCES dbo.be_Posts (BlogID, PostID)
GO

--
-- Create index "idx_be_PostTag_BlogId_PostId" on table "be_PostTag"
--
CREATE INDEX idx_be_PostTag_BlogId_PostId
  ON dbo.be_PostTag (BlogID, PostID)
GO

--
-- Drop index "FK_PostID" from table "be_PostNotify"
--
DROP INDEX FK_PostID ON dbo.be_PostNotify
GO

--
-- Rename primary key "PK_be_PostNotify" to "idx_be_PostCategory_BlogId_PostId" on Table "be_PostNotify"
--
EXEC sp_rename N'dbo.PK_be_PostNotify', N'idx_be_PostCategory_BlogId_PostId', 'OBJECT'
GO

--
-- Create column "BlogID" on table "dbo.be_PostNotify"
--
ALTER TABLE dbo.be_PostNotify
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_PostNotify SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_PostNotify
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create foreign key  on table "be_PostNotify"
--
ALTER TABLE dbo.be_PostNotify
  ADD CONSTRAINT FK_be_PostNotify_be_Posts FOREIGN KEY (BlogID, PostID) REFERENCES dbo.be_Posts (BlogID, PostID)
GO

--
-- Create index "FK_PostID" on table "be_PostNotify"
--
CREATE INDEX FK_PostID
  ON dbo.be_PostNotify (BlogID, PostID)
GO

--
-- Drop index "FK_PostID" from table "be_PostComment"
--
DROP INDEX FK_PostID ON dbo.be_PostComment
GO

--
-- Drop primary key PK_be_PostComment on table "be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  DROP CONSTRAINT PK_be_PostComment
GO

--
-- Create column "PostCommentRowID" on table "dbo.be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  ADD PostCommentRowID int IDENTITY
GO

--
-- Create column "BlogID" on table "dbo.be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_PostComment SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_PostComment
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_PostComment on table "be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  ADD CONSTRAINT PK_be_PostComment PRIMARY KEY (PostCommentRowID)
GO

--
-- Create index "idx_be_PostComment_BlogId_PostId" on table "be_PostComment"
--
CREATE INDEX idx_be_PostComment_BlogId_PostId
  ON dbo.be_PostComment (BlogID, PostID)
GO

--
-- Create foreign key  on table "be_PostComment"
--
ALTER TABLE dbo.be_PostComment
  ADD CONSTRAINT FK_be_PostComment_be_Posts FOREIGN KEY (BlogID, PostID) REFERENCES dbo.be_Posts (BlogID, PostID)
GO

--
-- Rename primary key "PK_be_PingService" to "PK_be_PingService_1" on Table "be_PingService"
--
EXEC sp_rename N'dbo.PK_be_PingService', N'PK_be_PingService_1', 'OBJECT'
GO

--
-- Create column "BlogID" on table "dbo.be_PingService"
--
ALTER TABLE dbo.be_PingService
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_PingService SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_PingService
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create index "idx_be_PingService_BlogId" on table "be_PingService"
--
CREATE INDEX idx_be_PingService_BlogId
  ON dbo.be_PingService (BlogID)
GO

--
-- Drop primary key PK_be_Pages on table "be_Pages"
--
ALTER TABLE dbo.be_Pages
  DROP CONSTRAINT PK_be_Pages
GO

--
-- Create column "PageRowID" on table "dbo.be_Pages"
--
ALTER TABLE dbo.be_Pages
  ADD PageRowID int IDENTITY
GO

--
-- Create column "BlogID" on table "dbo.be_Pages"
--
ALTER TABLE dbo.be_Pages
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Pages SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Pages
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Pages on table "be_Pages"
--
ALTER TABLE dbo.be_Pages
  ADD CONSTRAINT PK_be_Pages PRIMARY KEY (PageRowID)
GO

--
-- Create index "idx_Pages_BlogId_PageId" on table "be_Pages"
--
CREATE INDEX idx_Pages_BlogId_PageId
  ON dbo.be_Pages (BlogID, PageID)
GO

--
-- Drop index "I_TypeID" from table "be_DataStoreSettings"
--
DROP INDEX I_TypeID ON dbo.be_DataStoreSettings
GO

--
-- Create column "DataStoreSettingRowId" on table "dbo.be_DataStoreSettings"
--
ALTER TABLE dbo.be_DataStoreSettings
  ADD DataStoreSettingRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_DataStoreSettings"
--
ALTER TABLE dbo.be_DataStoreSettings
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_DataStoreSettings SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_DataStoreSettings
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_DataStoreSettings on table "be_DataStoreSettings"
--
ALTER TABLE dbo.be_DataStoreSettings
  ADD CONSTRAINT PK_be_DataStoreSettings PRIMARY KEY (DataStoreSettingRowId)
GO

--
-- Create index "idx_be_DataStoreSettings_BlogId_ExtensionType_TypeID" on table "be_DataStoreSettings"
--
CREATE INDEX idx_be_DataStoreSettings_BlogId_ExtensionType_TypeID
  ON dbo.be_DataStoreSettings (BlogId, ExtensionType, ExtensionId)
GO

--
-- Drop primary key PK_be_Categories on table "be_Categories"
--
ALTER TABLE dbo.be_Categories
  DROP CONSTRAINT PK_be_Categories
GO

--
-- Create column "CategoryRowID" on table "dbo.be_Categories"
--
ALTER TABLE dbo.be_Categories
  ADD CategoryRowID int IDENTITY
GO

--
-- Create column "BlogID" on table "dbo.be_Categories"
--
ALTER TABLE dbo.be_Categories
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_Categories SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_Categories
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_Categories on table "be_Categories"
--
ALTER TABLE dbo.be_Categories
  ADD CONSTRAINT PK_be_Categories PRIMARY KEY (CategoryRowID)
GO

--
-- Create index "idx_be_Categories_BlogID_CategoryID" on table "be_Categories"
--
CREATE UNIQUE INDEX idx_be_Categories_BlogID_CategoryID
  ON dbo.be_Categories (BlogID, CategoryID)
GO

--
-- Drop index "FK_CategoryID" from table "be_PostCategory"
--
DROP INDEX FK_CategoryID ON dbo.be_PostCategory
GO

--
-- Drop index "FK_PostID" from table "be_PostCategory"
--
DROP INDEX FK_PostID ON dbo.be_PostCategory
GO

--
-- Rename primary key "PK_be_PostCategory" to "PK_be_PostCategory_1" on Table "be_PostCategory"
--
EXEC sp_rename N'dbo.PK_be_PostCategory', N'PK_be_PostCategory_1', 'OBJECT'
GO

--
-- Create column "BlogID" on table "dbo.be_PostCategory"
--
ALTER TABLE dbo.be_PostCategory
  ADD BlogID uniqueidentifier NULL
GO

UPDATE dbo.be_PostCategory SET BlogID = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_PostCategory
  ALTER
    COLUMN BlogID uniqueidentifier NOT NULL
GO

--
-- Create foreign key  on table "be_PostCategory"
--
ALTER TABLE dbo.be_PostCategory
  ADD CONSTRAINT FK_be_PostCategory_be_Categories FOREIGN KEY (BlogID, CategoryID) REFERENCES dbo.be_Categories (BlogID, CategoryID)
GO

--
-- Create foreign key  on table "be_PostCategory"
--
ALTER TABLE dbo.be_PostCategory
  ADD CONSTRAINT FK_be_PostCategory_be_Posts FOREIGN KEY (BlogID, PostID) REFERENCES dbo.be_Posts (BlogID, PostID)
GO

--
-- Create index "idx_be_PostCategory_BlogId_CategoryId" on table "be_PostCategory"
--
CREATE INDEX idx_be_PostCategory_BlogId_CategoryId
  ON dbo.be_PostCategory (BlogID, CategoryID)
GO

--
-- Create index "idx_be_PostCategory_BlogId_PostId" on table "be_PostCategory"
--
CREATE INDEX idx_be_PostCategory_BlogId_PostId
  ON dbo.be_PostCategory (BlogID, PostID)
GO

--
-- Create table "dbo.be_Blogs"
--
CREATE TABLE dbo.be_Blogs (
  BlogRowId int IDENTITY,
  BlogId uniqueidentifier NOT NULL,
  BlogName nvarchar(255) NOT NULL,
  Hostname nvarchar(255) NOT NULL,
  IsAnyTextBeforeHostnameAccepted bit NOT NULL,
  StorageContainerName nvarchar(255) NOT NULL,
  VirtualPath nvarchar(255) NOT NULL,
  IsPrimary bit NOT NULL,
  IsActive bit NOT NULL,
  CONSTRAINT PK_be_Blogs PRIMARY KEY (BlogRowId)
)
GO

INSERT [dbo].[be_Blogs] ([BlogId], [BlogName], [Hostname], [IsAnyTextBeforeHostnameAccepted], [StorageContainerName], [VirtualPath], [IsPrimary], [IsActive]) VALUES (N'27604f05-86ad-47ef-9e05-950bb762570c', N'Primary', N'', 0, N'', N'~/', 1, 1)
GO

--
-- Drop primary key PK_be_BlogRollItems on table "be_BlogRollItems"
--
ALTER TABLE dbo.be_BlogRollItems
  DROP CONSTRAINT PK_be_BlogRollItems
GO

--
-- Create column "BlogRollRowId" on table "dbo.be_BlogRollItems"
--
ALTER TABLE dbo.be_BlogRollItems
  ADD BlogRollRowId int IDENTITY
GO

--
-- Create column "BlogId" on table "dbo.be_BlogRollItems"
--
ALTER TABLE dbo.be_BlogRollItems
  ADD BlogId uniqueidentifier NULL
GO

UPDATE dbo.be_BlogRollItems SET BlogId = '27604F05-86AD-47EF-9E05-950BB762570C'
GO

ALTER TABLE dbo.be_BlogRollItems
  ALTER
    COLUMN BlogId uniqueidentifier NOT NULL
GO

--
-- Create primary key PK_be_BlogRollItems on table "be_BlogRollItems"
--
ALTER TABLE dbo.be_BlogRollItems
  ADD CONSTRAINT PK_be_BlogRollItems PRIMARY KEY (BlogRollRowId)
GO

--
-- Create index "idx_be_BlogRollItems_BlogId" on table "be_BlogRollItems"
--
CREATE INDEX idx_be_BlogRollItems_BlogId
  ON dbo.be_BlogRollItems (BlogId)
GO

