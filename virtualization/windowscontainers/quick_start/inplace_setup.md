# Preparing a physical machine or an existing virtual machine for Windows Containers

In order to create and manage Windows Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers in a Hyper-V Virtual Machine.

**PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

The following are required in order to complete both the Windows Server Containers and Hyper-V containers exercises in this quick start.

* System running Windows 10 build 1056 or later / Windows Server Technical Preview 4 or later.
* Hyper-V role enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell)).
* 10GB available storage for container host image, OS Base Image and setup scripts.
* Administrator permissions on the Hyper-V host.

## Setup an existing Virtual Machine or Bare Metal host for Containers
Windows Containers require the Container OS Base Images. We have put together a script that will download and install this for you. Follow these steps to configure your system as a Windows Container Host.

Start a PowerShell session as administrator. This can be done by running the following command from the command line.

``` powershell
powershell.exe
```

Make sure the title of the windows is "Administrator: Windows PowerShell". If it does not say Administrator, run this command to run with admin priveledges:

``` powershell
start-process powershell -Verb runas
```

Use the following command to download the setup script. The script can also be manually downloaded from this location - [Configuration Script](https://aka.ms/tp4/Install-ContainerHost).
 
``` PowerShell
wget -uri https://aka.ms/tp4/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1
```
   
 After the download completes, execute the script.
``` PowerShell
C:\Install-ContainerHost.ps1 -HyperV
```

The script will then begin to download and configure the Windows Container components. This process may take quite some time due to the large download. The machine may reboot during the process. When finished your machine will be configured and ready for you to create and manage Windows Containers and Windows Container Images with both PowerShell and Docker. 

 With these items completed your system should be ready for Windows Containers. 

## Next Steps - Start Using Containers

Now that you have a Windows Server 2016 system running the Windows Container feature, jump to the following guides to begin working with Windows Server and Hyper-V Containers.
 
[Quick Start: Windows Server Containers and Docker](./manage_docker.md) 

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)