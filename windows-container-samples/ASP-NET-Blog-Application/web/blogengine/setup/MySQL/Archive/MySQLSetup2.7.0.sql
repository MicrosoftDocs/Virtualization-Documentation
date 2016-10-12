
CREATE TABLE `be_Blogs` (
  `BlogRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `BlogName` varchar(255) NOT NULL DEFAULT '',
  `Hostname` varchar(255) NOT NULL DEFAULT '',
  `IsAnyTextBeforeHostnameAccepted` tinyint(1) NOT NULL DEFAULT 1,
  `StorageContainerName` varchar(255) NOT NULL DEFAULT '',
  `VirtualPath` varchar(255) NOT NULL DEFAULT '',
  `IsPrimary` tinyint(1) NOT NULL DEFAULT 0,
  `IsActive` tinyint(1) NOT NULL DEFAULT 1,
  `IsSiteAggregation` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`BlogRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Categories` (
  `CategoryRowID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `CategoryID` varchar(36) NOT NULL DEFAULT '',
  `CategoryName` varchar(50) DEFAULT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `ParentID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`CategoryRowID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_DataStoreSettings` (
  `DataStoreSettingRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `ExtensionType` varchar(50) NOT NULL,
  `ExtensionId` varchar(100) NOT NULL,
  `Settings` text NOT NULL,
  PRIMARY KEY (`DataStoreSettingRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Pages` (
  `PageRowID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PageID` varchar(36) NOT NULL DEFAULT '',
  `Title` varchar(255) NOT NULL DEFAULT '',
  `Description` text,
  `PageContent` longtext,
  `Keywords` text,
  `DateCreated` datetime DEFAULT NULL,
  `DateModified` datetime DEFAULT NULL,
  `IsPublished` tinyint(1) DEFAULT NULL,
  `IsFrontPage` tinyint(1) DEFAULT NULL,
  `Parent` varchar(64) DEFAULT NULL,
  `ShowInList` tinyint(1) DEFAULT NULL,
  `Slug` varchar(255) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PageRowID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PingService` (
  `PingServiceID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `Link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PingServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Posts` (
  `PostRowID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `Title` varchar(255) NOT NULL DEFAULT '',
  `Description` text NOT NULL,
  `PostContent` longtext NOT NULL,
  `DateCreated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DateModified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Author` varchar(50) NOT NULL DEFAULT '',
  `IsPublished` tinyint(1) NOT NULL DEFAULT '0',
  `IsCommentEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `Raters` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `Rating` float NOT NULL DEFAULT '0',
  `Slug` varchar(255) NOT NULL DEFAULT '',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PostRowID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Profiles` (
  `ProfileID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `UserName` varchar(100) NOT NULL,
  `SettingName` varchar(200) NOT NULL,
  `SettingValue` text NOT NULL,
  PRIMARY KEY (`ProfileID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Roles` (
  `RoleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `Role` varchar(100) NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `be_Settings` (
  `SettingRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `SettingName` varchar(50) NOT NULL,
  `SettingValue` text,
  PRIMARY KEY (`SettingRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_StopWords` (
  `StopWordRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `StopWord` varchar(50) NOT NULL,
  PRIMARY KEY (`StopWordRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Users` (
  `UserID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `UserName` varchar(100) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `LastLoginTime` datetime DEFAULT '0000-00-00 00:00:00',
  `EmailAddress` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `be_UserRoles` (
  `UserRoleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `UserName` varchar(100) NOT NULL DEFAULT '',
  `Role` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`UserRoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostCategory` (
  `PostCategoryID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `CategoryID` varchar(36) NOT NULL DEFAULT '',
  PRIMARY KEY (`PostCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostComment` (
  `PostCommentRowID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PostCommentID` varchar(36) NOT NULL DEFAULT '',
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `ParentCommentID` varchar(36) NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
  `CommentDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Author` varchar(255) NOT NULL DEFAULT '',
  `Email` varchar(255) NOT NULL DEFAULT '',
  `Website` varchar(255) NOT NULL DEFAULT '',
  `Comment` text NOT NULL,
  `Country` varchar(255) NOT NULL DEFAULT '',
  `Ip` varchar(50) NOT NULL DEFAULT '',
  `IsApproved` tinyint(1) NOT NULL DEFAULT '0',
  `ModeratedBy` varchar(100) DEFAULT NULL,
  `Avatar` varchar(255) DEFAULT NULL,
  `IsSpam` tinyint(1)  NOT NULL DEFAULT '0',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PostCommentRowID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostNotify` (
  `PostNotifyID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `NotifyAddress` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PostNotifyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostTag` (
  `PostTagID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogID` varchar(36) NOT NULL DEFAULT '',
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `Tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PostTagID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_BlogRollItems` (
  `BlogRollRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `BlogRollId` varchar(36) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `BlogUrl` varchar(255) NOT NULL,
  `FeedUrl` varchar(255) DEFAULT NULL,
  `Xfn` varchar(255) DEFAULT NULL,
  `SortIndex` int(10) NOT NULL,
  PRIMARY KEY (`BlogRollRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_Referrers` (
  `ReferrerRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `ReferrerId` varchar(36) NOT NULL,
  `ReferralDay` datetime NOT NULL,
  `ReferrerUrl` varchar(255) NOT NULL,
  `ReferralCount` int(10) NOT NULL,
  `Url` varchar(255) DEFAULT NULL,
  `IsSpam` tinyint(1) NULL,
  PRIMARY KEY (`ReferrerRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_Rights` (
  `RightRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `RightName` varchar(100) NOT NULL,
  PRIMARY KEY (`RightRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_RightRoles` (
  `RightRoleRowId` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `BlogId` varchar(36) NOT NULL DEFAULT '',
  `RightName` varchar(100) NOT NULL,
  `Role` varchar(100) NOT NULL,
  PRIMARY KEY (`RightRoleRowId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

/***  Load initial Data ***/

INSERT INTO be_Blogs (BlogId, BlogName, Hostname, IsAnyTextBeforeHostnameAccepted, StorageContainerName, VirtualPath, IsPrimary, IsActive) VALUES ('27604f05-86ad-47ef-9e05-950bb762570c', 'Primary', '', 0, '', '~/', 1, 1);

INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'administratorrole', 'Administrators');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'alternatefeedurl', '');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'authorname', 'My name');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'avatar', 'combine');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'blogrollmaxlength', '23');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'blogrollupdateminutes', '60');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'blogrollvisibleposts', '3');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'contactformmessage', '<p>I will answer the mail as soon as I can.</p>');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'contactthankmessage', '<h1>Thank you</h1><p>The message was sent.</p>');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'culture', 'Auto');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'dayscommentsareenabled', '0');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'description', 'Short description of the blog');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'displaycommentsonrecentposts', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'displayratingsonrecentposts', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'email', 'user@example.com');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'emailsubjectprefix', 'Weblog');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablecommentsearch', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablecommentsmoderation', 'False');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablecontactattachments', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablecountryincomments', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablehttpcompression', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enableopensearch', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablepingbackreceive', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablepingbacksend', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablerating', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablereferrertracking', 'False');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablerelatedposts', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablessl', 'False');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enabletrackbackreceive', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enabletrackbacksend', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'endorsement', 'http://www.dotnetblogengine.net/syndication.axd');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'fileextension', '.aspx');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'geocodinglatitude', '0');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'geocodinglongitude', '0');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'handlewwwsubdomain', '');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'iscocommentenabled', 'False');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'iscommentsenabled', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'language', 'en-GB');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'mobiletheme', 'JQ-Mobile');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'name', 'Name of the blog');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'numberofrecentcomments', '10');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'numberofrecentposts', '10');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'postsperfeed', '10');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'postsperpage', '10');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'removewhitespaceinstylesheets', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'searchbuttontext', 'Search');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'searchcommentlabeltext', 'Include comments in search');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'searchdefaulttext', 'Enter search term');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'sendmailoncomment', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'showdescriptioninpostlist', 'False');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'showlivepreview', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'showpostnavigation', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'smtppassword', 'password');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'smtpserver', 'mail.example.dk');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'smtpserverport', '25');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'smtpusername', 'user@example.com');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'storagelocation', '~/App_Data/');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'syndicationformat', 'Rss');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'theme', 'Standard');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'timestamppostlinks', 'True');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'timezone', '0');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'trackingscript', '');
INSERT INTO be_Settings (BlogID, SettingName, SettingValue)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'enablequicknotes', 'True');

INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://rpc.technorati.com/rpc/ping');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://rpc.pingomatic.com/rpc2');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://ping.feedburner.com');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://www.bloglines.com/ping');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://services.newsgator.com/ngws/xmlrpcping.aspx');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://api.my.yahoo.com/rpc2 ');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://blogsearch.google.com/ping/RPC2');
INSERT INTO be_PingService (BlogID, Link) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'http://rpc.pingthesemanticweb.com/');

INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'a');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'about');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'actually');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'add');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'after');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'all');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'almost');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'along');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'also');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'an');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'and');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'any');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'are');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'as');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'at');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'be');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'both');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'but');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'by');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'can');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'cannot');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'com');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'could');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'de');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'do');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'down');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'each');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'either');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'en');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'for');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'from');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'good');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'has');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'have');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'he');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'her');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'here');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'hers');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'his');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'how');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'i');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'if');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'in');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'into');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'is');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'it');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'its');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'just');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'la');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'like');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'long');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'make');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'me');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'more');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'much');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'my');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'need');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'new');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'now');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'of');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'off');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'on');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'once');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'one');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ones');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'only');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'or');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'our');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'out');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'over');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'own');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'really');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'right');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'same');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'see');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'she');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'so');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'some');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'such');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'take');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'takes');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'that');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'the');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'their');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'these');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'thing');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'this');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'to');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'too');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'took');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'und');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'up');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'use');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'used');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'using');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'very');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'was');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'we');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'well');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'what');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'when');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'where');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'who');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'will');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'with');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'www');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'you');
INSERT INTO be_StopWords (BlogId, StopWord)	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'your');

INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', '25e4d8da-3278-4e58-b0bf-932496dabc96', 'Mads Kristensen', 'Full featured simplicity in ASP.NET and C#', 'http://madskristensen.net', 'http://feeds.feedburner.com/netslave', 'contact', 0 );
INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', 'ccc817ef-e760-482b-b82f-a6854663110f', 'Al Nyveldt', 'Adventures in Code and Other Stories', 'http://www.nyveldt.com/blog/', 'http://feeds.feedburner.com/razorant', 'contact', 1 );
INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', 'dcdaa78b-0b77-4691-99f0-1bb6418945a1', 'Ruslan Tur', '.NET and Open Source: better together', 'http://rtur.net/blog/', 'http://feeds.feedburner.com/rtur', 'contact', 2 );
INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', '8a846489-b69e-4fde-b2b2-53bc6104a6fa', 'John Dyer', 'Technology and web development in ASP.NET, Flash, and JavaScript', 'http://johndyer.name/', 'http://johndyer.name/syndication.axd', 'contact', 3 );
INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', '7f906880-4316-47f1-a934-1a912fc02f8b', 'Russell van der Walt', 'an adventure in web technologies', 'http://blog.ruski.co.za/', 'http://feeds.feedburner.com/rusvdw', 'contact', 4 );
INSERT INTO be_BlogRollItems ( BlogId, BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '27604F05-86AD-47EF-9E05-950BB762570C', '890f00e5-3a86-4cba-b85b-104063964a87', 'Ben Amada', 'adventures in application development', 'http://allben.net/', 'http://feeds.feedburner.com/allben', 'contact', 5 );

INSERT INTO be_Categories (BlogID, CategoryID, CategoryName)
	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ffc26b8b-7d45-46e3-b702-7198e8847e06', 'General');

INSERT INTO be_Posts (BlogID, PostID, Title, Description, PostContent, DateCreated, DateModified, Author, IsPublished)
	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 
	'Welcome to BlogEngine.NET 2.7 using MySQL', 
	'The description is used as the meta description as well as shown in the related posts. It is recommended that you write a description, but not mandatory',
	'<p>If you see this post it means that BlogEngine.NET 2.7 is running and the hard part of creating your own blog is done. There is only a few things left to do.</p>
<h2>Write Permissions</h2>
<p>To be able to log in to the blog and writing posts, you need to enable write permissions on the App_Data folder. If you&rsquo;re blog is hosted at a hosting provider, you can either log into your account&rsquo;s admin page or call the support. You need write permissions on the App_Data folder because all posts, comments, and blog attachments are saved as XML files and placed in the App_Data folder.&nbsp;</p>
<p>If you wish to use a database to to store your blog data, we still encourage you to enable this write access for an images you may wish to store for your blog posts.&nbsp; If you are interested in using Microsoft SQL Server, MySQL, SQL CE, or other databases, please see the <a href="http://blogengine.codeplex.com/documentation">BlogEngine wiki</a> to get started.</p>
<h2>Security</h2>
<p>When you\'ve got write permissions to the App_Data folder, you need to change the username and password. Find the sign-in link located either at the bottom or top of the page depending on your current theme and click it. Now enter "admin" in both the username and password fields and click the button. You will now see an admin menu appear. It has a link to the "Users" admin page. From there you can change the username and password.&nbsp; Passwords are hashed by default so if you lose your password, please see the <a href="http://blogengine.codeplex.com/documentation">BlogEngine wiki</a> for information on recovery.</p>
<h2>Configuration and Profile</h2>
<p>Now that you have your blog secured, take a look through the settings and give your new blog a title.&nbsp; BlogEngine.NET 2.7 is set up to take full advantage of of many semantic formats and technologies such as FOAF, SIOC and APML. It means that the content stored in your BlogEngine.NET installation will be fully portable and auto-discoverable.&nbsp; Be sure to fill in your author profile to take better advantage of this.</p>
<h2>Themes, Widgets &amp; Extensions</h2>
<p>One last thing to consider is customizing the look of your blog.&nbsp; We have a few themes available right out of the box including two fully setup to use our new widget framework.&nbsp; The widget framework allows drop and drag placement on your side bar as well as editing and configuration right in the widget while you are logged in.&nbsp; Extensions allow you to extend and customize the behaivor of your blog.&nbsp; Be sure to check the <a href="http://dnbegallery.org/">BlogEngine.NET Gallery</a> at <a href="http://dnbegallery.org/">dnbegallery.org</a> as the go-to location for downloading widgets, themes and extensions.</p>
<h2>On the web</h2>
<p>You can find BlogEngine.NET on the <a href="http://www.dotnetblogengine.net">official website</a>. Here you\'ll find tutorials, documentation, tips and tricks and much more. The ongoing development of BlogEngine.NET can be followed at <a href="http://blogengine.codeplex.com/">CodePlex</a> where the daily builds will be published for anyone to download.&nbsp; Again, new themes, widgets and extensions can be downloaded at the <a href="http://dnbegallery.org/">BlogEngine.NET gallery</a>.</p>
<p>Good luck and happy writing.</p>
<p>The BlogEngine.NET team</p>',
	CURDATE(), 
	CURDATE(),
	'admin',
	1);

INSERT INTO be_PostCategory (BlogID, PostID, CategoryID)
	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'ffc26b8b-7d45-46e3-b702-7198e8847e06');
INSERT INTO be_PostTag (BlogID, PostID, Tag)
	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'blog');
INSERT INTO be_PostTag (BlogID, PostID, Tag)
	VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'welcome');
	
INSERT INTO be_Users (BlogID, UserName, Password, LastLoginTime, EmailAddress) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'Admin', '', CURDATE(), 'email@example.com');
INSERT INTO be_Roles (BlogID, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'Administrators');
INSERT INTO be_Roles (BlogID, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'Editors');
INSERT INTO be_UserRoles (BlogID, UserName, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'Admin', 'Administrators');

INSERT INTO be_DataStoreSettings (BlogId, ExtensionType, ExtensionId, Settings)
VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 1, 'be_WIDGET_ZONE', '<?xml version="1.0" encoding="utf-16"?><WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings></WidgetData>');

INSERT INTO be_Packages (`PackageId`, `Version`) VALUES ('JQ-Mobile', '1.3.0');

INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 1, 'App_Code\\JQ-Mobile', 1);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 2, 'App_Code\\JQ-Mobile\\ThemeHelper.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 3, 'themes\\JQ-Mobile', 1);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 4, 'themes\\JQ-Mobile\\controls', 1);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 5, 'themes\\JQ-Mobile\\controls\\CommentView.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 6, 'themes\\JQ-Mobile\\controls\\CommentView.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 7, 'themes\\JQ-Mobile\\controls\\Header.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 8, 'themes\\JQ-Mobile\\controls\\Header.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 9, 'themes\\JQ-Mobile\\controls\\MainHeader.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 10, 'themes\\JQ-Mobile\\controls\\MainHeader.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 11, 'themes\\JQ-Mobile\\controls\\Pager.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 12, 'themes\\JQ-Mobile\\controls\\Pager.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 13, 'themes\\JQ-Mobile\\controls\\PostList.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 14, 'themes\\JQ-Mobile\\controls\\PostList.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 15, 'themes\\JQ-Mobile\\Archive.aspx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 16, 'themes\\JQ-Mobile\\Archive.aspx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 17, 'themes\\JQ-Mobile\\CommentView.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 18, 'themes\\JQ-Mobile\\Contact.aspx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 19, 'themes\\JQ-Mobile\\Contact.aspx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 20, 'themes\\JQ-Mobile\\logo.png', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 21, 'themes\\JQ-Mobile\\newsletter.html', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 22, 'themes\\JQ-Mobile\\Post.aspx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 23, 'themes\\JQ-Mobile\\Post.aspx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 24, 'themes\\JQ-Mobile\\PostView.ascx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 25, 'themes\\JQ-Mobile\\PostView.ascx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 26, 'themes\\JQ-Mobile\\Readme.txt', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 27, 'themes\\JQ-Mobile\\Search.aspx', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 28, 'themes\\JQ-Mobile\\Search.aspx.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 29, 'themes\\JQ-Mobile\\site.master', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 30, 'themes\\JQ-Mobile\\site.master.cs', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 31, 'themes\\JQ-Mobile\\style.css', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 32, 'themes\\JQ-Mobile\\theme.png', 0);
INSERT INTO be_PackageFiles (PackageId, FileOrder, FilePath, IsDirectory) VALUES ('JQ-Mobile', 33, 'themes\\JQ-Mobile\\theme.xml', 0);


