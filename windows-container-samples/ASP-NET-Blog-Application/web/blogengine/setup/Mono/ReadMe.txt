About the Files in This Directory
---------------------------------

The mono_setup.sh script will make a few changes to an installation of
BlogEngine.NET that will prepare it for use.  It will:

1.  Create a symlink of "bin" to the "Bin" folder (work-around for
    automatically-generated capitalized folder that throws Mono off)
2.  Change the group of App_Data and below to the group specified
3.  Give the group write permissions on App_Data and below

How to Run mono_setup.sh
------------------------
The script should be run as root, as it changes permissions.  Before executing
it, either become root or use sudo in step 2.

1.  Change to the setup directory (example is from BlogEngine root)

    cd setup/Mono

2.  Make the script executable

    chmod +x mono_setup.sh

3.  Run the script, giving it the group to which permissions should be
    assigned.

    ./mono_setup.sh www-data
    
    NOTE: You may omit the group if you are not wanting to set permissions
    on the App_Data folder; if you are using a database for everything,
    including roles and users, you can use this option.

A Note about Security
---------------------
www-data is the standard group for Debian-based systems.  If using Apache with
mod_mono, this group should be the group under which Apache is running.  If
using FastCGI, this group should be the group under which the FastCGI process is
started.

A Note to Developers
--------------------
Do not edit mono_setup.sh with Visual Studio; if it has Windows line endings, it
will not execute properly.
