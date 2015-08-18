ms.ContentId: 44b138bb-962f-4474-a0c4-284646a872e2
title: Setup Windows Containers in place

# Preparing a physical machine or an existing virtual machine for Windows Server Containers


In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers on bare metal or in an existing virtual machine running Windows Server 2016 Technical Preview. 

To run Windows Server Containers in Azure instead, follow [these instructions](./azure_setup.md).
To run Windows Server Containers in a Hyper-V VM instead, follow [these instructions](./container_setup.md).

  **PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

* System running Windows 10 / Windows Server Technical Preview 2 or later.
* Hyper-V role enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell)).
* 20GB available storage for container host image, OS Base Image and setup scripts.
* Administrator permissions on the Hyper-V host.

> Windows Server Containers do not require Hyper-V however to keep things simple this guide assumes that a Hyper-V environment is being used to run the Windows Server Container host.

## Setup an existing Virtual Machine or Bare Metal host for Containers
Windows Server Containers consist of several components such as the Windows Server Container Host and Container OS Base Image. We have put together a script that will download and configure these items for you. Follow these steps to configure your system as a Windows Server Container Host.

Start a PowerShell session as Administrator. This can be done by right clicking on the PowerShell icon and selecting ‘Run as Administrator’, or by running the following command from any PowerShell or cmd session.

``` powershell
start-process powershell -Verb runAs
```

Use the following command to download the setup script. The script can also be manually downloaded from this location - [Configuration Script](http://aka.ms/setupcontainers).
 
``` PowerShell
wget -uri http://aka.ms/setupcontainers -OutFile C:\ContainerSetup.ps1
```
   
 After the download completes, execute the script.
``` PowerShell
C:\ContainerSetup.ps1
```

The script will then begin to download and configure the Windows Server Container components. This process may take quite some time due to the large download. The machine may reboot during the process. When finished your machine will be configured and ready for you to create and manage Windows Server Containers and Windows Server Container Images with both PowerShell and Docker.  

 With these items completed your system should be ready for Windows Server Containers. 

## Next Steps - Start Using Containers