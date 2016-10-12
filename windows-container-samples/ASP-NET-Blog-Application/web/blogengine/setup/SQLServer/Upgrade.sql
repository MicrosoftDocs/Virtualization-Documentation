--
-- Add BlogId to unique constraints
--
ALTER TABLE dbo.be_Rights DROP CONSTRAINT AK_RightName
GO
ALTER TABLE dbo.be_Rights ADD CONSTRAINT AK_RightName UNIQUE (BlogId, RightName)
GO
ALTER TABLE dbo.be_Settings DROP CONSTRAINT AK_SettingName
GO
ALTER TABLE dbo.be_Settings ADD CONSTRAINT AK_SettingName UNIQUE (BlogId, SettingName)
GO
ALTER TABLE dbo.be_PackageFiles DROP CONSTRAINT PK_be_PackageFiles
GO
ALTER TABLE dbo.be_PackageFiles ADD CONSTRAINT PK_be_PackageFiles UNIQUE (PackageId, FilePath)
GO