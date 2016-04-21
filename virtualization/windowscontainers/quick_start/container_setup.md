---
author: neilpeterson
redirect_url: quick_start_configure_host
---

# Deploy a Windows Container Host to a New Hyper-V Virtual Machine

This document steps through using a PowerShell script to deploy a new Hyper-V virtual machine, which is then configured as a Windows Container Host.

To step through a scripted deployment, of a Windows Container host, to an existing virtual or physical system, see [In-Place Windows Container Host Deployment](./inplace_setup.md).

**PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

The following are required in order to complete both the **Windows Server** and **Hyper-V Containers** exercises in this quick start.

* System running Windows 10 build 10586 or later / Windows Server Technical Preview 4 or later.
* Hyper-V role enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell)).
* 20GB available storage for container host image, OS Base Image and setup scripts.
* Administrator permissions on the Hyper-V host.

> A virtualized container host, running Hyper-V containers, will require nested virtualization. Both the physical host and virtual host will need to be running an OS that supports nested virtualization. For more information, see What’s New in Hyper-V on [Windows Server 2016 Technical Preview](https://technet.microsoft.com/library/dn765471.aspx#BKMK_nested).

## Setup a New Container Host in a New Virtual Machine

Windows Containers consist of several components such as the Windows Container Host and Container OS Base Images. We have put together a script that will download and configure these items for you. Follow these steps to deploy a new Hyper-V Virtual Machine and configure this system as a Windows Container Host.

Start a PowerShell session as Administrator. This can be done by right clicking on the PowerShell icon and selecting ‘Run as Administrator’, or by running the following command from any PowerShell session.

``` powershell
PS C:\> start-process powershell -Verb runAs
```

Before downloading and running the script, ensure that an external Hyper-V virtual switch has been created. This script will fail without one. 

Run the following to return a list of external virtual switches. If nothing is returned, create a new external virtual switch, and then proceed to the next step of this guide.

```powershell
PS C:\> Get-VMSwitch | where {$_.SwitchType -eq “External”}
```

Use the following command to download the configuration script. The script can also be manually downloaded from this location - [Configuration Script](https://aka.ms/tp4/New-ContainerHost).
 
``` PowerShell
PS C:\> wget -uri https://aka.ms/tp4/New-ContainerHost -OutFile c:\New-ContainerHost.ps1
```
   
Run the following command to create and configure the container host, where `<containerhost>` will be the virtual machine name.

``` powershell
PS C:\> powershell.exe -NoProfile c:\New-ContainerHost.ps1 -VMName testcont -WindowsImage ServerDatacenterCore -Hyperv
```

When the script begins, you will be prompted for a password. This will be the password assigned to the Administrator account.
  
Next, you will be asked to read and accept licensing terms.

```
Before installing and using the Windows Server Technical Preview 4 with Containers virtual machine you must:
    1. Review the license terms by navigating to this link: http://aka.ms/tp4/containerseula
    2. Print and retain a copy of the license terms for your records.
By downloading and using the Windows Server Technical Preview 4 with Containers virtual machine you agree to such
license terms. Please confirm you have accepted and agree to the license terms.
[N] No  [Y] Yes  [?] Help (default is "N"):
```

The script will then begin to download and configure the Windows Container components. This process may take quite some time due to the large download. When finished your Virtual Machine will be configured and ready for you to create and manage Windows Containers and Windows Container Images with both PowerShell and Docker.  

When the configuration script has completed, log into the virtual machine using the password specified during the configuration process and make sure that the Virtual Machine has a valid IP address. With these items completed your system should be ready for Windows Containers. 

## Next Steps: Start Using Containers

Now that you have a Windows Server 2016 system running the Windows Container feature, jump to the following guides to begin working with Windows Server and Hyper-V Containers.

You can use the `Enter-PSSession` command in the Hyper-V management host to connect to the container host.

```powershell
PS C:\> Enter-PSSession -VMName <VM Name>
```
 
[Quick Start: Windows Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Containers and Docker](./manage_docker.md) 
