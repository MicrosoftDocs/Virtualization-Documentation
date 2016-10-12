Running BlogEngine.NET using SQL Server 2008 and up:

If you wish to use SQL Server to store all your blog data, this folder has all the 
information you'll likely need.  The scripts included here are for SQL Server 2008 and up.
They could be modified to be used with earlier or later versions if needed.

Instructions for new setup:

1. Open SQL Server Management Studio and connect to your SQL Server.
2. Create a new database if desired.
3. Execute the Setup script against the database you want to add the BlogEngine data to.
4. Rename DbWeb.Config to Web.config and copy it to your blog folder.  (This will
overwrite your existing web.config file.  If this is not a new installation, make sure 
you have a backup).
5. Update the BlogEngine connection string in the web.config.
6. Surf out to your Blog and see the welcome post.
7. Login with the username admin and password admin.  Change the password.

Upgrading from previous version

 - Use Upgrade.sql to upgrade from latest version (3.1)

Upgrading from earlier versions

- Use scripts in Archive folder to bring your DB to version 3.1, then run Upgrade.sql