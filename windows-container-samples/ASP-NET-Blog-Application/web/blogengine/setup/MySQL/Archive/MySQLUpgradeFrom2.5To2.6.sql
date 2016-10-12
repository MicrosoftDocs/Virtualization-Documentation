
CREATE TABLE `be_Packages` (
  `PackageId` varchar(128) NOT NULL,
  `Version` varchar(128) NOT NULL,
  PRIMARY KEY (`PackageId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PackageFiles` (
  `PackageId` varchar(128) NOT NULL,
  `FileOrder` int(10) UNSIGNED NOT NULL,
  `FilePath` varchar(255) NOT NULL,
  `IsDirectory` tinyint(1) NOT NULL,
  PRIMARY KEY (`PackageId`, `FileOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_QuickNotes` (
  `QuickNoteID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NoteID` varchar(36) NOT NULL,
  `BlogID` varchar(36) NOT NULL,
  `UserName` varchar(100) NOT NULL,
  `Note` longtext NOT NULL,
  `Updated` datetime NOT NULL,
  PRIMARY KEY (`QuickNoteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_QuickSettings` (
  `QuickSettingID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL,
  `UserName` varchar(100) NOT NULL,
  `SettingName` varchar(255) NOT NULL,
  `SettingValue` varchar(255) NOT NULL,
  PRIMARY KEY (`QuickSettingID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_FileStoreDirectory` (
  `Id` varchar(36) NOT NULL,
  `ParentID` varchar(36) NOT NULL,
  `BlogID` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `FullPath` varchar(1000) NOT NULL,
  `CreateDate` datetime NOT NULL,
  `LastAccess` datetime NOT NULL,
  `LastModify` datetime NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_FileStoreFiles` (
  `FileID` varchar(36) NOT NULL,
  `ParentDirectoryID` varchar(36) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `FullPath` varchar(255) NOT NULL,
  `Contents` longblob NOT NULL,
  `Size` int(10) UNSIGNED NOT NULL,
  `CreateDate` datetime NOT NULL,
  `LastAccess` datetime NOT NULL,
  `LastModify` datetime NOT NULL,
  PRIMARY KEY (`FileID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_FileStoreFileThumbs` (
  `thumbnailId` varchar(36) NOT NULL,
  `FileId` varchar(36) NOT NULL,
  `Size` int(10) UNSIGNED NOT NULL,
  `Contents` longblob NOT NULL,
  PRIMARY KEY (`thumbnailId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE be_Blogs ADD IsSiteAggregation tinyint(1) NOT NULL DEFAULT 0;


