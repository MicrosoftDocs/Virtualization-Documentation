Running BlogEngine.NET using SQLite:

If you wish to use SQLite to store all your blog data, this is the guide for you.
Included in this folder is a default SQLite database, that you can use to get you 
started with your blog.  In addition, you will find a sample web.config file with
the needed changes to use SQLite and an upgrade scripts for current SQLite users 
who wish to upgrade from previous version.

Instructions for new setup:

1. Copy System.Data.SQLite.DLL from the /setup/SQLite to your blog's bin folder.
2. Copy BlogEngine.s3db from the SQLite folder to your App_Data folder.
3. Rename SQLiteWeb.Config to Web.config and copy it to your blog folder.  (This will
overwrite your existing web.config file.  If this is not a new installation, make sure 
you have a backup).
4. Surf out to your Blog and see the welcome post.
5. Login with the username Admin and password admin.  Change the password.  Note: This 
data is case sensitive.

Upgrading from 2.6

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 2.6 to 3.0 against the database.

Upgrading from 2.5

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 2.5 to 2.6 against the database.
4. The web.config file has changed in 2.7.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.

Upgrading from 2.0

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 2.0 to 2.5 against the database.
4. The web.config file has changed in 2.5.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.

Upgrading from 1.6

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 1.6 to 2.0 against the database.
4. The web.config file has changed in 2.0.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.

Upgrading from 1.5

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 1.5 to 1.6 against the database.
4. You will need to manually edit the be_PostComments table.  Change the field 
"ParentCommentID" to have the field constraint of NOT NULL.
5. The web.config file has changed in 1.6.0.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.

Upgrading from 1.4.5

1. If you don't already have SQLite Admin tool installed, you'll need to get one. SQLite
Admin has worked great for me.  (http://sqliteadmin.orbmu2k.de/)
2. Open your BlogEngine.s3db database.  (You will likely need to copy your BlogEngine.s3db
file from your web server, perform the update, and copy it back out after these changes
depending on your setup.)
3. Execute the upgrade script for 1.4.5 to 1.5 against the database.
4. Execute the upgrade script for 1.5 to 1.6 against the database.
5. You will need to manually edit the be_PostComments table.  Change the field 
"ParentCommentID" to have the field constraint of NOT NULL.
6. The web.config file has changed in 1.6.0.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.

Additional information can be found at http://dotnetblogengine.net