
CREATE TABLE `be_CustomFields` (
	`CustomType` varchar(25) NOT NULL,
	`ObjectId` varchar(100) NOT NULL,
	`BlogId` varchar(36) NOT NULL,
	`Key` varchar(150) NOT NULL,
	`Value` text NOT NULL,
	`Attribute` varchar(250) NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


