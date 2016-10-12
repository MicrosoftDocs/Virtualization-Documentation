#!/bin/bash
##
## BlogEngine.NET Mono Setup Script
##
## This script will prepare a Mono installation of BlogEngine.NET.  See the
## ReadMe.txt file in the same directory for instructions on how to use it and
## what it does.
##
## Usage:
##   ./mono_setup.sh [group_name]
##

## Step 1 - Create the symlink
echo "Creating symlink (bin -> Bin)..."
cd ../..
if [ -e bin ]; then
    echo "bin already exists - nothing done"
else
    ln -s Bin bin
    echo "Done!"
fi

echo

if [ -z $1 ]; then
## No group, no changed permissions...
    echo "No group specified; permissions on App_Data were NOT changed"
    echo
    echo "BlogEngine.NET Mono setup completed"
    cd setup/Mono
    exit 0
fi

## Step 2 - change the group of App_Data
echo "Changing App_Data to group $1..."
chgrp -R $1 App_Data

echo "Assigned group write permissions to App_Data..."
chmod -R g+w App_Data

echo "Done!"
echo
echo "BlogEngine.NET Mono setup completed"
cd setup/Mono
exit 0
