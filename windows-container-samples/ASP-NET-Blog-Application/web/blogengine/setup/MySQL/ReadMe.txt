Running BlogEngine.NET using MySQL:

If you wish to use MySQL to store all your blog data, this folder has all the 
information you'll likely need.  The scripts included here are for MySQL 5.6.
They could be modified to be used with earlier versions if needed.

Included is the Initial Setup script for use with new BE installation.  
Also, included is an upgrade script from previous versions. In addition, you 
will find a sample web.config file with the needed changes to use MySQL.

Instructions for new setup:

1. Using the tool of your choice, execute the Setup script against the database you 
want to add the BlogEngine data to.  This can be a new or existing database.
2. Rename MySQLWeb.Config to Web.config and copy it to your blog folder.  (This will
overwrite your existing web.config file.  If this is not a new installation, make sure 
you have a backup).
3. Update the BlogEngine connection string in the web.config.
4. Add the MySQL .NET Connector (6.9.7) to the bin folder.
5. Surf out to your Blog and see the welcome post.
6. Login with the username admin and password admin.  Change the password.

Upgrading from earlier versions

- Use scripts in Archive folder to bring your DB to latest version.