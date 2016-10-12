--
-- be_Pages SortOrder
--
ALTER TABLE be_Pages ADD COLUMN SortOrder INT DEFAULT 0;
--
-- add new rights to administrators
--
INSERT INTO be_RightRoles (BlogID, RightName, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ViewDashboard', 'Administrators');
INSERT INTO be_RightRoles (BlogID, RightName, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ManageExtensions', 'Administrators');
INSERT INTO be_RightRoles (BlogID, RightName, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ManageThemes', 'Administrators');
INSERT INTO be_RightRoles (BlogID, RightName, Role) VALUES ('27604F05-86AD-47EF-9E05-950BB762570C', 'ManagePackages', 'Administrators');

INSERT INTO be_Rights (BlogId, RightName) VALUES ('27604f05-86ad-47ef-9e05-950bb762570c', 'ViewDashboard');
INSERT INTO be_Rights (BlogId, RightName) VALUES ('27604f05-86ad-47ef-9e05-950bb762570c', 'ManageExtensions');
INSERT INTO be_Rights (BlogId, RightName) VALUES ('27604f05-86ad-47ef-9e05-950bb762570c', 'ManageThemes');
INSERT INTO be_Rights (BlogId, RightName) VALUES ('27604f05-86ad-47ef-9e05-950bb762570c', 'ManagePackages');

