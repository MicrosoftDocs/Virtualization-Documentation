CREATE TABLE `be_Categories` (
  `CategoryID` varchar(36) NOT NULL DEFAULT '',
  `CategoryName` varchar(50) DEFAULT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `ParentID` varchar(36) DEFAULT NULL,
  PRIMARY KEY  (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_DataStoreSettings` (
  `ExtensionType` varchar(50) NOT NULL,
  `ExtensionId` varchar(100) NOT NULL,
  `Settings` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Pages` (
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
  PRIMARY KEY  (`PageID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PingService` (
  `PingServiceID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Link` varchar(255) DEFAULT NULL,
  PRIMARY KEY  (`PingServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Posts` (
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
  PRIMARY KEY  (`PostID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Profiles` (
  `ProfileID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserName` varchar(100) NOT NULL,
  `SettingName` varchar(200) NOT NULL,
  `SettingValue` text NOT NULL,
  PRIMARY KEY  (`ProfileID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Roles` (
  `RoleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Role` varchar(100) NOT NULL,
  PRIMARY KEY  (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `be_Settings` (
  `SettingName` varchar(50) NOT NULL,
  `SettingValue` text,
  PRIMARY KEY  (`SettingName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_StopWords` (
  `StopWord` varchar(50) NOT NULL,
  PRIMARY KEY  (`StopWord`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_Users` (
  `UserID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserName` varchar(100) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `LastLoginTime` datetime DEFAULT '0000-00-00 00:00:00',
  `EmailAddress` varchar(100) DEFAULT NULL,
  PRIMARY KEY  (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `be_UserRoles` (
  `UserRoleID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `RoleID` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY  (`UserRoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostCategory` (
  `PostCategoryID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `CategoryID` varchar(36) NOT NULL DEFAULT '',
  PRIMARY KEY  (`PostCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostComment` (
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
  PRIMARY KEY  (`PostCommentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostNotify` (
  `PostNotifyID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `NotifyAddress` varchar(255) DEFAULT NULL,
  PRIMARY KEY  (`PostNotifyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `be_PostTag` (
  `PostTagID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PostID` varchar(36) NOT NULL DEFAULT '',
  `Tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY  (`PostTagID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_BlogRollItems` (
  `BlogRollID` varchar(36) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `BlogUrl` varchar(255) NOT NULL,
  `FeedUrl` varchar(255) DEFAULT NULL,
  `Xfn` varchar(255) DEFAULT NULL,
  `SortIndex` int(10) NOT NULL,
  PRIMARY KEY  (`BlogRollID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_Referrers` (
  `ReferrerId` varchar(36) NOT NULL,
  `ReferralDay` datetime NOT NULL,
  `ReferrerUrl` varchar(255) NOT NULL,
  `ReferralCount` int(10) NOT NULL,
  `Url` varchar(255) DEFAULT NULL,
  `IsSpam` tinyint(1) NULL,
  PRIMARY KEY  (`ReferrerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '25e4d8da-3278-4e58-b0bf-932496dabc96', 'Mads Kristensen', 'Full featured simplicity in ASP.NET and C#', 'http://madskristensen.net', 'http://feeds.feedburner.com/netslave', 'contact', 0 );
INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( 'ccc817ef-e760-482b-b82f-a6854663110f', 'Al Nyveldt', 'Adventures in Code and Other Stories', 'http://www.nyveldt.com/blog/', 'http://feeds.feedburner.com/razorant', 'contact', 1 );
INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( 'dcdaa78b-0b77-4691-99f0-1bb6418945a1', 'Ruslan Tur', '.NET and Open Source: better together', 'http://rtur.net/blog/', 'http://feeds.feedburner.com/rtur', 'contact', 2 );
INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '8a846489-b69e-4fde-b2b2-53bc6104a6fa', 'John Dyer', 'Technology and web development in ASP.NET, Flash, and JavaScript', 'http://johndyer.name/', 'http://johndyer.name/syndication.axd', 'contact', 3 );
INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '7f906880-4316-47f1-a934-1a912fc02f8b', 'Russell van der Walt', 'an adventure in web technologies', 'http://blog.ruski.co.za/', 'http://feeds.feedburner.com/rusvdw', 'contact', 4 );
INSERT INTO be_BlogRollItems ( BlogRollId, Title, Description, BlogUrl, FeedUrl, Xfn, SortIndex )
VALUES ( '890f00e5-3a86-4cba-b85b-104063964a87', 'Ben Amada', 'adventures in application development', 'http://allben.net/', 'http://feeds.feedburner.com/allben', 'contact', 5 );

INSERT INTO be_Categories (CategoryID, CategoryName)
	VALUES ('ffc26b8b-7d45-46e3-b702-7198e8847e06', 'General');

INSERT INTO be_Posts (PostID, Title, Description, PostContent, DateCreated, DateModified, Author, IsPublished)
	VALUES ('daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 
	'Welcome to BlogEngine.NET 1.6 using MySQL', 
	'The description is used as the meta description as well as shown in the related posts. It is recommended that you write a description, but not mandatory',
	'<p>If you see this post it means that BlogEngine.NET 1.6 is running with MySQL and the DbBlogProvider is configured correctly.</p>
	<h2>Setup</h2>
	<p>You are configured to have your user names and passwords stored in MySQL by default.  It is time to setup some users. Find the sign-in link located either at the bottom or top of the page depending on your current theme and click it. Now enter "admin" in both the username and password fields and click the button. You will now see an admin menu appear. It has a link to the "Users" admin page.  You should also see a link to a Change Password page.  You should use this to change the default password right away.</p>
	<h2>Write permissions</h2>
	<p>Since you are using MySQL to store your posts, most information is stored there.  However, if you want to store attachments or images in the blog, you will want write permissions setup on the App_Data folder.</p>
	<h2>On the web </h2>
	<p>You can find BlogEngine.NET on the <a href="http://www.dotnetblogengine.net">official website</a>. Here you will find tutorials, documentation, tips and tricks and much more. The ongoing development of BlogEngine.NET can be followed at <a href="http://blogengine.codeplex.com/">CodePlex</a> where the daily builds will be published for anyone to download.</p>
	<p>Good luck and happy writing.</p>
	<p>The BlogEngine.NET team</p>',
	CURDATE(), 
	CURDATE(),
	'admin',
	1);

INSERT INTO be_PostCategory (PostID, CategoryID)
	VALUES ('daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'ffc26b8b-7d45-46e3-b702-7198e8847e06');
INSERT INTO be_PostTag (PostID, Tag)
	VALUES ('daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'blog');
INSERT INTO be_PostTag (PostID, Tag)
	VALUES ('daf4bc0e-f4b7-4895-94b2-3b1413379d4b', 'welcome');
	
INSERT INTO be_Users (UserName, Password, LastLoginTime, EmailAddress)
	VALUES ('Admin', '', CURDATE(), 'email@example.com');
INSERT INTO be_Roles (Role) 
	VALUES ('Administrators');
INSERT INTO be_Roles (Role) 
	VALUES ('Editors');
INSERT INTO be_UserRoles (UserID, RoleID)
VALUES
( (SELECT UserID FROM be_Users WHERE UserName = 'Admin'), 
(SELECT RoleID FROM be_Roles WHERE Role = 'Administrators'));

INSERT INTO be_DataStoreSettings (ExtensionType, ExtensionId, Settings)
VALUES (1, 'be_WIDGET_ZONE', '<?xml version="1.0" encoding="utf-16"?><WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings></WidgetData>');


