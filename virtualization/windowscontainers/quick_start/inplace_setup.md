---
author: neilpeterson
redirect_url: ./quick_start_configure_host
---

# Deploy a Windows Container Host to an Existing Virtual or Physical System

This document steps through using a PowerShell script to deploy and configure the Windows Container role on an existing physical or virtual system.

To step through a scripted deployment of a new Hyper-V virtual machine configured as a Windows Container Host, see [New Hyper-V Windows Container Host](./container_setup.md).

**PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

The following are required in order to complete both the Windows Server Containers and Hyper-V containers exercises in this quick start.

* System running Windows Server Technical Preview 4 or later.
* 10GB available storage for container host image, OS Base Image and setup scripts.
* Administrator permissions on the system.

## Setup an existing Virtual Machine or Bare Metal host for Containers
Windows Containers require the Container OS Base Images. We have put together a script that will download and install this for you. Follow these steps to configure your system as a Windows Container Host. For more information, see What’s New in Hyper-V on [Windows Server 2016 Technical Preview]( https://tnstage.redmond.corp.microsoft.com/en-US/library/dn765471.aspx#BKMK_nested).

Start a PowerShell session as administrator. This can be done by running the following command from the command line.

``` powershell
PS C:\> powershell.exe
```

Make sure the title of the windows is "Administrator: Windows PowerShell". If it does not say Administrator, run this command to run with admin priveledges:

``` powershell
PS C:\> start-process powershell -Verb runas
```

Use the following command to download the setup script. The script can also be manually downloaded from this location - [Configuration Script](https://aka.ms/tp4/Install-ContainerHost).
 
``` PowerShell
PS C:\> wget -uri https://aka.ms/tp4/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1
```
   
 After the download completes, execute the script.
``` PowerShell
PS C:\> powershell.exe -NoProfile C:\Install-ContainerHost.ps1 -HyperV
```

The script will then begin to download and configure the Windows Container components. This process may take quite some time due to the large download. The machine may reboot during the process. When finished your machine will be configured and ready for you to create and manage Windows Containers and Windows Container Images with both PowerShell and Docker. 

 With these items completed your system should be ready for Windows Containers. 

## Next Steps: Start Using Containers

Now that you have a Windows Server 2016 system running the Windows Container feature, jump to the following guides to begin working with Windows Server and Hyper-V Containers.
 
[Quick Start: Windows Containers and Docker](./manage_docker.md)  

[Quick Start: Windows Containers and PowerShell](./manage_powershell.md)
