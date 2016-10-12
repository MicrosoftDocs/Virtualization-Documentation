ALTER TABLE blogengine.be_categories
 ADD ParentID VARCHAR(36) AFTER Description;

ALTER TABLE blogengine.be_datastoresettings
 CHANGE Settings Settings TEXT ASCII NOT NULL;
 
UPDATE be_DataStoreSettings 
SET Settings = '<?xml version="1.0" encoding="utf-16"?><WidgetData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Settings>&lt;widgets&gt;&lt;widget id="d9ada63d-3462-4c72-908e-9d35f0acce40" title="TextBox" showTitle="True"&gt;TextBox&lt;/widget&gt;&lt;widget id="19baa5f6-49d4-4828-8f7f-018535c35f94" title="Administration" showTitle="True"&gt;Administration&lt;/widget&gt;&lt;widget id="d81c5ae3-e57e-4374-a539-5cdee45e639f" title="Search" showTitle="True"&gt;Search&lt;/widget&gt;&lt;widget id="77142800-6dff-4016-99ca-69b5c5ebac93" title="Tag cloud" showTitle="True"&gt;Tag cloud&lt;/widget&gt;&lt;widget id="4ce68ae7-c0c8-4bf8-b50f-a67b582b0d2e" title="RecentPosts" showTitle="True"&gt;RecentPosts&lt;/widget&gt;&lt;/widgets&gt;</Settings></WidgetData>'
WHERE ExtensionId = 'be_WIDGET_ZONE';

UPDATE be_DataStoreSettings 
SET Settings = ''
WHERE ExtensionType = 0;