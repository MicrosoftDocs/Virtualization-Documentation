
CREATE TABLE [dbo].[be_BlogRollItems](
	[BlogRollId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[BlogUrl] [varchar](255) NOT NULL,
	[FeedUrl] [varchar](255) NULL,
	[Xfn] [varchar](255) NULL,
	[SortIndex] [int] NOT NULL,
 CONSTRAINT [PK_be_BlogRollItems] PRIMARY KEY CLUSTERED 
(
	[BlogRollId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[be_Referrers](
	[ReferrerId] [uniqueidentifier] NOT NULL,
	[ReferralDay] [datetime] NOT NULL CONSTRAINT [DF_be_Referrers_Day]  DEFAULT (getdate()),
	[ReferrerUrl] [varchar](255) NOT NULL,
	[ReferralCount] [int] NOT NULL,
	[Url] [varchar](255) NULL,
	[IsSpam] [bit] NULL,
 CONSTRAINT [PK_be_Referrers] PRIMARY KEY CLUSTERED 
(
	[ReferrerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE dbo.be_Pages ADD Slug nvarchar(255) NULL
GO

ALTER TABLE dbo.be_PostComment ADD ModeratedBy nvarchar(100) NULL
GO

ALTER TABLE dbo.be_PostComment ADD Avatar nvarchar(255) NULL
GO

