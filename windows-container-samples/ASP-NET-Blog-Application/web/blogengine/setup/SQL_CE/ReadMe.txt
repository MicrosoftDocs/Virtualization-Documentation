Running BlogEngine.NET using SQL CE 4.0

If you wish to use SQL CE to store all your blog data, this folder has all the information you'll 
likely need.  The BlogEngine.sdf is already setup with the DB tables and initial data needed
to get started with BlogEngine.NET.  Although not needed, SQL_CE_Setup_2.9.sql is provided
for reference.  This was the setup script used to create the BlogEngine.sdf file.

Instructions for New Setup
-----------------------------------------------------------
1. When running BlogEngine.NET under SQL CE 4.0, you will either need SQL CE 4.0 installed on 
your computer, or if deploying to a webhost, you can simply copy the SQL CE 4.0 binary (DLL) 
files to your /BIN directory.  The DLL files will be located in the installation folder for SQL 
CE 4.0.  The installation folder is located at:

%ProgramFiles(x86)%\Microsoft SQL Server Compact Edition\v4.0\Private

If you do not have SQL CE 4.0 installed on your computer, or you need the DLL files, the latest 
CTP version of SQL CE 4.0 can be downloaded at:
http://www.microsoft.com/download/en/details.aspx?id=17876

However, please check for the latest version of SQL CE 4.0 before downloading the one at the 
above link.

2. Copy the following files/folders to your /BIN directory.  The files are located in the SQL CE 
4.0 installation folder:

%ProgramFiles(x86)%\Microsoft SQL Server Compact Edition\v4.0\Private

 (a) Copy the file "System.Data.SqlServerCe.dll" into your /BIN directory.
 (b) There are two sub-folders: AMD64 and X86.  Copy both folders to your /BIN directory.

After copying these files and folders, your /BIN directory will look like this:

/bin
   System.Data.SqlServerCe.dll
/bin/x86
   sqlceca40.dll 
   sqlcecompact40.dll 
   sqlceer40EN.dll 
   sqlceme40.dll 
   sqlceqp40.dll 
   sqlcese40.dll 
/bin/amd64 
   sqlceca40.dll 
   sqlcecompact40.dll 
   sqlceer40EN.dll 
   sqlceme40.dll 
   sqlceqp40.dll 
   sqlcese40.dll 

3. Rename the SQL_CE_Web.Config file to web.config and copy it to your blog's root 
folder.  (This will overwrite your existing web.config file.  If this is not a new installation, 
make sure you have a backup.)
4. Copy the BlogEngine.sdf file into the App_Data folder.
5. Surf out to your Blog and see the welcome post.
6. Login with the username admin and password admin.  Change the password.

Upgrading from 2.6
-----------------------------------------------------------

 - Run SQL_CE_UpgradeFrom2.6to3.0.sql against your existing CE database. It will add new table and index.
   If you get an error with "GO" keyword not supported, run statements one by one excluding "; GO".

Upgrading from 2.5
-----------------------------------------------------------

There is an upgrade script to update your SDF file so it is compliant with BlogEngine.NET 2.7.
The upgrade script name is SQL_CE_UpgradeFrom2.5to2.6.sql.  This script will need to be
run against your BlogEngine.NET 2.5 SDF file.  A recommended tool is to use the
SQL Server Compact Toolbox utility found at:

http://sqlcetoolbox.codeplex.com/

An add-in for Visual Studio 2010/2012 can be downloaded, or a standalone version of the toolbox
can be downloaded.  This utility will allow you to run a SQL CE script against a SDF
file.  You would want to run the script contained in SQL_CE_UpgradeFrom2.5to2.6.sql
against your BlogEngine.NET 2.5 SDF file.  Once the script has been run, your BlogEngine.SDF
file will be ready to use in a BlogEngine.NET 2.5 website.

Additionally, the web.config file has changed from 2.5 to 2.7.  It will likely be easiest to start
with the sample web.config file as described above, but if you have other changes in it, 
you'll need to merge them.  Don't forget to move your connectionString over.

Troubleshooting
-----------------------------------------------------------
If you use one of the sample web.config files, are running your site on your own machine or a 
server that SQL CE 4.0 is already installed on, and you receive the following error message 
when starting the site:

"Failed to find or load the registered .Net Framework Data Provider."

In this scenario, you may need to remove the <system.data> section out of the web.config file.


