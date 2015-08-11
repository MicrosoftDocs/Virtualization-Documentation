ms.ContentId: 71a03c62-50fd-48dc-9296-4d285027a96a
title: Container Setup

# Preparing Windows Server Technical Preview for Windows Containers

In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared.  This guide will walk through configuring Windows Server Containers in a virtual machine running locally with Hyper-V.

To run Windows Server Containers in Azure instead, follow [these instructions](./azure_setup.md).
 
## Step 1 - Requirements

* Hyper-V is enabled
* 14GB available (so you can download Server Core and a base image)
* Administrator permissions

** Why do I need Hyper-V? **  
Windows Server Containers do not require Hyper-V.  However, this guide and all of the set-up scripts we're providing assume you're running containers in a virtual machine.  It's easier to get going in a virtual machine with Hyper-V.

If you really want to run Windows Server Containers on a Server Core Technical Preview machine, there is a script for you.

## Step 2 - Download and run the installation script
There are a few different components necessary for running Windows Server Containers.

The scripts available in the download center pull all of these dependencies for you.

## Next Steps

You now have a working Windows Server Container environment, now onto the fun stuff.  Windows Server Containers can be created and managed using either PowerShell or Docker. We have put together a quick stat guide for both of these management experiences.

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md)  

[Back to Container Home](../containers_welcome.md)