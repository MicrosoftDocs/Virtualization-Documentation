ms.ContentId: 71a03c62-50fd-48dc-9296-4d285027a96a
title: Setup Windows Containers in a local VM

# Preparing Windows Server Technical Preview for Windows Containers

In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers in a virtual machine running locally with Hyper-V.

To run Windows Server Containers in Azure instead, follow [these instructions](./azure_setup.md).

  > **PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  
 
## Requirements

* Running Windows 8.1 / Windows Server 2012 R2 or later.
* Hyper-V role is enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell))
* 20GB available storage for container host image, base image and setup scripts.
* Administrator permissions on the Hyper-V host.

> Windows Server Containers do not require Hyper-V however to keep things simple this guide assumes that a Hyper-V environment is being used to run the Windows Server Container host.

## Set up a new container host on a new virtual machine
Windows Server Containers consist of several components such as the Windows Server Container Host and Container OS Base Image. We have put together a script that will download and configure these items. Follow these steps to deploy a new Hyper-V Virtual Machine and configure this system as a Windows Server Container Host.

1. Launch a PowerShell session as Administrator.

```
powershell
```

2. Use the following command to download the configuration script.
 
``` PowerShell
wget -uri http://aka.ms/newcontainerhost -OutFile New-ContainerHost.ps1
```
   
3. Run the following command to create and configure the container host where `contianerhost` will be the virtual machine name and `password` will be the password assigned to the Administrator account.

```powershell
.\New-ContainerHost.ps1 –VmName <CONTAINERHOST> -Password <password>
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

This script will then begin to download and configure the Windows Server Container components. This process will take quite some time due to the large download. When finished your Virtual Machine will be configured and ready to create and manage Windows Server Containers with both PowerShell and Docker.  

When the configuration script has completed log into your virtual machine. The VM is configured with Windows Server 2016 Core and will look like the following.
  
<center>![](./media/ContainerHost.png)</center>
  
Now you have a Windows Server Core virtual machine running Docker and Windows Server Containers!

## Next - Start using containers

Now that you have a container host jump to the following guides to begin working with Windows Server containers and Window Server container Images. 

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md) 

-------------------
[Alpha Release Known Issues:](../about/work_in_progress.md)

[Back to Container Home](../containers_welcome.md)