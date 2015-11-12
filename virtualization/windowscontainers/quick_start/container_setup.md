# Preparing Windows Server Technical Preview for Windows Server Containers

In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers in a Hyper-V Virtual Machine.

> Other getting started guides:
  * Run Windows Server Containers in [Azure](./azure_setup.md).
  * Run Windows Server Containers in [an existing physical or virtual machine](./inplace_setup.md).

  **PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

* System running Windows 10 / Windows Server Technical Preview 2 or later.
* Hyper-V role enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell)).
* 20GB available storage for container host image, OS Base Image and setup scripts.
* Administrator permissions on the Hyper-V host.

> Windows Server Containers do not require Hyper-V however to keep things simple this guide assumes that a Hyper-V environment is being used to run the Windows Server Container host.

## Setup a New Container Host on a New Virtual Machine
Windows Server Containers consist of several components such as the Windows Server Container Host and Container OS Base Image. We have put together a script that will download and configure these items for you. Follow these steps to deploy a new Hyper-V Virtual Machine and configure this system as a Windows Server Container Host.

Start a PowerShell session as Administrator. This can be done by right clicking on the PowerShell icon and selecting ‘Run as Administrator’, or by running the following command from any PowerShell session.

``` powershell
start-process powershell -Verb runAs
```

Use the following command to download the configuration script. The script can also be manually downloaded from this location - [Configuration Script](https://aka.ms/newcontainerhost).
 
``` PowerShell
wget -uri https://aka.ms/newcontainerhost -OutFile New-ContainerHost.ps1
```
   
Run the following command to create and configure the container host where `<containerhost>` will be the virtual machine name and `<password>` will be the password assigned to the Administrator account.

``` powershell
.\New-ContainerHost.ps1 –VmName <containerhost> -Password <password>
```
  
When the script begins you will be asked to read and accept licensing terms.

```
Before installing and using the Windows Server Technical Preview 3 with Containers virtual machine you must:
    1. Review the license terms by navigating to this link: https://aka.ms/WindowsServerTP3ContainerVHDEula
    2. Print and retain a copy of the license terms for your records.
By downloading and using the Windows Server Technical Preview 3 with Containers virtual machine you agree to such
license terms. Please confirm you have accepted and agree to the license terms.
[N] No  [Y] Yes  [?] Help (default is "N"): Y
```

The script will then begin to download and configure the Windows Server Container components. This process may take quite some time due to the large download. When finished your Virtual Machine will be configured and ready for you to create and manage Windows Server Containers and Windows Server Container Images with both PowerShell and Docker.  

You may receive the following message during the Window Server Container host deployment process. 
```
This VM is not connected to the network. To connect it, run the following:
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>
```  
If you do, check the properties of the virtual machine and connect the virtual machine to a virtual switch. You can also run the following PowerShell command where `<switchname>` is the name of the Hyper-V virtual switch that you would like to connect to the virtual machine.

``` powershell 
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>
```

When the configuration script has completed, start the virtual machine. The VM is configured with Windows Server 2016 Core and will look like the following.
  
<center>![](./media/containerhost2.png)</center><br />
  
Finally log into the virtual machine using the password specified during the configuration process and make sure that the Virtual Machine has a valid IP address. With these items completed your system should be ready for Windows Server Containers. 

## Video Walkthrough

<iframe src="https://channel9.msdn.com/Blogs/containers/Quick-Start-Configure-Windows-Server-Containers-on-a-Local-System/player" width="800" height="450" allowFullScreen="true" frameBorder="0" scrolling="no"></iframe>


## Next Steps - Start Using Containers

Now that you have a Windows Server 2016 system running the Windows Server Container feature jump to the following guides to begin working with Windows Server Containers and Windows Server Container images. 
 
[Quick Start: Windows Server Containers and Docker](./manage_docker.md) 

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md) 

-------------------

[Back to Container Home](../containers_welcome.md)  
[Known Issues for Current Release](../about/work_in_progress.md)
