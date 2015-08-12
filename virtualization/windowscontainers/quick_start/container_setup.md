ms.ContentId: 71a03c62-50fd-48dc-9296-4d285027a96a
title: Container Setup

# Preparing Windows Server Technical Preview for Windows Containers

In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers in a virtual machine running locally with Hyper-V.

To run Windows Server Containers in Azure instead, follow [these instructions](./azure_setup.md).
 
## Requirements

* Hyper-V is enabled
* 14GB available (so you can download Server Core and a base image)
* Administrator permissions

** Why do I need Hyper-V? **  
Windows Server Containers do not require Hyper-V. However, this guide and all of the set-up scripts we're providing assume you're running containers in a virtual machine. It's easier to get going in a virtual machine with Hyper-V.

If you really want to run Windows Server Containers on a Server Core Technical Preview machine, there is a script for you.

## New Container Host on a New Virtual Machine
There are a few different components necessary for running Windows Server Container, however we have a script that will pull all of these together for you. The following steps will guide you through the automaed creation of a  new virtual machine configured as a Windows Server Container Host.

1. Download configuration script from – http://updatelocation .
2. Launch a PowerShell session as Administrator.
3. Run the following command to begin an automated deployment of the container host. This example will create a Virtual Machine named CONTAINERHOST with an administrative password or Password12.

  ```powershell
  .\New-ContainerHost.ps1 -VmName CONTAINERHOST -Password Password12
  ```
4. When the script begins you will be asked to read and accept licensing terms.

```
Before installing and using the Windows Server Technical Preview 3 with Containers virtual machine you must:
    1. Review the license terms by navigating to this link: http://aka.ms/WindowsServerTP3ContainerVHDEula
    2. Print and retain a copy of the license terms for your records.
By downloading and using the Windows Server Technical Preview 3 with Containers virtual machine you agree to such
license terms. Please confirm you have accepted and agree to the license terms.
[N] No  [Y] Yes  [?] Help (default is "N"): Y
```
This script will then begin to download and configure the Windows Server Container components. This process will take quite some time due to the large download. Once com

Once finished your Virtual Machine will be configured and ready to create and manage Windows Server Containers with both PowerShell and Docker. Jump to the following quick starts to begin working with either of these Windows Server Container Management technologies.

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md)  

## New Container Host on an Exsisting Virtual Machine

Neil to Run and Doc script.

## Next Steps

You now have a working Windows Server Container environment, now onto the fun stuff.  Windows Server Containers can be created and managed using either PowerShell or Docker. We have put together a quick start guide for both of these management experiences.

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md)  

[Back to Container Home](../containers_welcome.md)