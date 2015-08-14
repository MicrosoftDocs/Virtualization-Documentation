ms.ContentId: 71a03c62-50fd-48dc-9296-4d285027a96a
title: Setup Windows Containers in a local VM

# Preparing Windows Server Technical Preview for Windows Containers

In order to create and manage Windows Server Containers, the Windows Server 2016 Technical Preview environment must be prepared. This guide will walk through configuring Windows Server Containers in a virtual machine running locally with Hyper-V.

To run Windows Server Containers in Azure instead, follow [these instructions](./azure_setup.md).
 
## Requirements

* Running Windows 8.1 or later or Windows Server 2012 R2 or later.
* Hyper-V role is enabled ([see instructions](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_install#UsingPowerShell))
* 20GB available
  * 6GB to download a zip file containing:  
    * Windows Server Core  
    * Windows Server Container base image
    * a hand full of setup scripts
  * 13GB -- to unzip the contents (once the file is extracted, you can delete the zip file).
* Administrator permissions

** Why do I need Hyper-V? **  
Windows Server Containers do not require Hyper-V. However, this guide and all of the set-up scripts we're providing assume you're running containers in a Hyper-V virtual machine. It's easier to get going in a virtual machine with Hyper-V.

<!-- We need a baremetal setup doc as a userguide -->

## Set up a new container host on a new virtual machine
There are a few different components necessary for running Windows Server Container, however we have a script that will pull all of these together for you. The following steps will guide you through the automated creation of a new virtual machine configured as a Windows Server Container Host.

1. Launch a PowerShell session as Administrator.

2. Read this legal reminder:  
  > **PLEASE READ PRIOR TO INSTALLING THE CONTAINER OS IMAGE:**  The license terms of the Microsoft Windows Server Pre-Release software (“License Terms”) apply to your use of the Microsoft Windows Container OS Image supplement (the “supplemental software).  By downloading and using the supplemental software, you agree to the License Terms, and you may not use it if you have not accepted the License Terms. Both the Windows Server Pre-Release software and the supplemental software are licensed by Microsoft Corporation.  

2. Download configuration script – http://aka.ms/newcontainerhost. Make note of where this script is saved.

  You can also use PowerShell:
  ```PowerShell
  wget -uri http://aka.ms/newcontainerhost -OutFile New-ContainerHost.ps1
  ```
  
  Run `Get-Help New-ContainerHost.ps1` to see optional parameters for creating your Container Host VM.

3. Run the following command to begin an automated deployment of the container host. This example will create a Virtual Machine named CONTAINERHOST with an administrative password or Password12.

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
  This script will then begin to download and configure the Windows Server Container components. This process will take quite some time due to the large download.  
  Once finished your Virtual Machine will be configured and ready to create and manage Windows Server Containers with both PowerShell and Docker.

  > Note:  If you recieve this message:  
  ```
  Currently, your container is not connected to the network.
  Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>
  ```  
  You already have set up an external switch and should manually it to your virtual machine.

5. Launch your new virtual machine with VM Connect.  `CONTAINERHOST` is the VMName you used with the `New-ContainerHost` script.
  
  ``` PowerShell
  vmconnect.exe localhost CONTAINERHOST
  ```
  
  The VM should connect to this screen:
  ![](./media/ContainerHost.png)
  
6.  Enter your password.  This is the password you used with the `New-ContainerHost` script.

Now you have a Windows Server Core virtual machine running Docker and Windows Server Containers!

## Next - Start using containers

Jump to the following quick starts to begin containerizing applications and managing Windows Server Containers.

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md) 

The Docker and PowerShell guides both walk through containerizing a web server and performing equivalent management tasks.  Use whichever toolset you prefer. 

-------------------

[Back to Container Home](../containers_welcome.md)