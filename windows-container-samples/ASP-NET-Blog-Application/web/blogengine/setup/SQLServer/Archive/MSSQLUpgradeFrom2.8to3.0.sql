
--
-- be_CustomFields
--
CREATE TABLE [dbo].[be_CustomFields](
	[CustomType] [nvarchar](25) NOT NULL,
	[ObjectId] [nvarchar](100) NOT NULL,
	[BlogId] [uniqueidentifier] NOT NULL,
	[Key] [nvarchar](150) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Attribute] [nvarchar](250) NULL
)
GO

CREATE CLUSTERED INDEX [idx_be_CustomType_ObjectId_BlogId_Key] ON [dbo].[be_CustomFields] 
(
	[CustomType] ASC,
	[ObjectId] ASC,
	[BlogId] ASC,
	[Key] ASC
)
GO





