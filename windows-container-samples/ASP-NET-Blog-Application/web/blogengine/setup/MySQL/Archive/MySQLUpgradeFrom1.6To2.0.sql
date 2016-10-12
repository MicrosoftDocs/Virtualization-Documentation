
ALTER TABLE `be_PostComment` ADD `IsSpam` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE `be_PostComment` ADD `IsDeleted` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE `be_Posts` ADD `IsDeleted` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE `be_Pages` ADD `IsDeleted` tinyint(1) NOT NULL DEFAULT '0';

CREATE TABLE IF NOT EXISTS `be_Rights` (
  `RightName` varchar(100) NOT NULL,
  PRIMARY KEY  (`RightName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `be_RightRoles` (
  `RightName` varchar(100) NOT NULL,
  `Role` varchar(100) NOT NULL,
  PRIMARY KEY (`RightName`, `Role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

