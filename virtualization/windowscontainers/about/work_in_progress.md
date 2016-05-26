---
title: Windows Containers Work in Progress
description: Windows Containers Work in Progress
keywords: docker, containers
author: scooley
manager: timlt
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 5d9f1cb4-ffb3-433d-8096-b085113a9d7b
---

# Work in Progress

If you don't see your problem addressed here or have questions, post them on the [forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

-----------------------

## General functionality

### Container and host build number match
A Windows Container requires an operating system image that matches the container host in respect to build and patch level. A mismatch will lead to potential instability and or unpredictable behavior for the container and/or the host.

If you install updates against the Windows container host OS you will need to update the container base OS image to have the matching updates.
<!-- Can we give examples of behavior or errors?  Makes it more searchable -->

**Work Around:**   
Download and install a container base image matching the OS version and patch level of the container host.

### Default firewall behavior
In a container host and containers environment, you only have the container host's firewall. All the firewall rules configured in the container host will propagate to all of its containers.

### Windows Containers start slowly
If your container is taking more than 30 seconds to start, it may be performing many duplicate virus scans.

Many anti-malware solutions, such as Windows Defender, may be unnecessarily scanning files with-in container images including all of the OS binaries and files in the container OS image.  This occurs when ever a new container is created and from the anti-malware’s perspective all of the “container’s files” look like new files that have not previously been scanned.  So when processes inside the container attempt to read these files the anti-malware components first scan them before allowing access to the files.  In reality these files were already scanned when the container image was imported or pulled to the server. In future previews new infrastructure will be in place such that anti-malware solutions, including Windows Defender, will be aware of these situations and can act accordingly to avoid multiple scans. 

### Start/Stop sometimes fails if memory is restricted to < 48MB
Windows Containers experience random, inconsistant, errors when memory is restricted to less than 48MB.

Running the following PowerShell and repeating the start, stop, action multiple will cause failures in either starting or stopping.

```PowerShell
new-container "Test" -containerimagename "WindowsServerCore" -MaximumBytes 32MB
start-container test
stop-container test
```

**Work Around:**  
Change the memory value to 48MB. 


### Start-container fails when the processor count is 1 or 2 on a 4 core VM

Windows Containers fail to start with error:  
`failed to start: This operation returned because the timeout period expired. (0x800705B4).`

This occurs when the processor count is set to 1 or 2 on a 4 core VM.

``` PowerShell
new-container "Test2" -containerimagename "WindowsServerCore"
Set-ContainerProcessor -ContainerName test2 -Maximum 2
Start-Container test2

Start-Container : 'test2' failed to start.
'test2' failed to start: This operation returned because the timeout period expired. (0x800705B4).
'test2' failed to start. (Container ID 133E9DBB-CA23-4473-B49C-441C60ADCE44)
'test2' failed to start: This operation returned because the timeout period expired. (0x800705B4). (Container ID
133E9DBB-CA23-4473-B49C-441C60ADCE44)
At line:1 char:1
+ Start-Container test2
+ ~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationTimeout: (:) [Start-Container], VirtualizationException
    + FullyQualifiedErrorId : OperationTimeout,Microsoft.Containers.PowerShell.Cmdlets.StartContainer
PS C:\> Set-ContainerProcessor -ContainerName test2 -Maximum 3
PS C:\> Start-Container test2
```

**Work Around:**  
Increase the processors available to the container, don't explicitly specify processors available to the container, or reduce processors available to the VM.

--------------------------

## Networking

### Network Compartment Isolation and Implications
Each container uses a network compartment to provide isolation. All container network adapters (endpoints) attached to a given container, will be resident in the same network compartment. Depending on the networking mode (driver) used, you may be unable to access two different container endpoints using the same IP address or port. Moreover, Windows firewall rules are not compartment- or container-aware and so any firewall rules plumbed will apply to all containers on the container host irrespective of a particular endpoint.

*** Transparent Networking ***


*** NAT Networking ***
You may expose multiple endpoints attached to a single container using NAT port forwarding rules which are applied on a per-endpoint basis. These forwarding rules must use different external ports (on the container host) when mapped to the same internal port (in the container).  As stated above, however, the firewall rules plumbed will have global scope across the container host.



### Static NAT mappings could conflict with port mappings through Docker
Beginning in Windows Server Technical Preview 5, NAT creation and port mapping rules are integrated into the *ContainerNetwork* cmdlets and docker commands. The Windows Host Network Service (HNS) will manage the NAT on your behalf. However, it is possible that an external client could try and create a duplicate port mapping rule using the same NAT created by HNS.


Here's an example of a conflict with a static mapping on port 80 and the error reported by docker when this occurs.
```
C:\Users\Administrator>docker run -it -p 80:80 windowsservercore cmd
docker: Error response from daemon: failed to create endpoint berserk_bassi on network nat: hnsCall failed in Win32: The remote procedure call failed. (0x6be).
```


***Mitigation***
In general, it is highly unlikely that this will occur since HNS will be managing the NAT. All port forwarding/mapping rules should be created using `docker run -p <external>:<internal>` or Add-ContainerNetworkAdapterStaticMapping. However, if the mappings are not cleaned up automatically by HNS, this error may be resolved by removing the port mapping using PowerShell. This will remove the port 80 conflict caused in the the example above.
```powershell
Get-NetNatStaticMapping | ? ExternalPort -eq 80 | Remove-NetNatStaticMapping
```


### Windows containers are not getting IPs
If you're connecting to the windows containers with DHCP VM Switches it's possible for the container host to receive an IP while the containers do not.

The containers get a 169.254.***.*** APIPA IP address.

**Work around:**
This is a side effect of sharing the kernel.  All containers effectively have the same mac address.

Enable MAC address spoofing on the physical host which is hosting the container host VM.

This can be achieved using PowerShell
```
Get-VMNetworkAdapter -VMName "[YourVMNameHere]"  | Set-VMNetworkAdapter -MacAddressSpoofing On
```
--------------------------

## Application compatibility

There are so many questions about which applications work and don't work in Windows Containers, we decided to break application compatibility information into [its own article](../reference/app_compat.md).

Some of the most common issues are located here as well.

### Unexpected error occurred inside a localdb instance api method call
Unexpected error occurred inside a localdb instance api method call

### RTerm doesn't work
RTerm installs but won't start in a Windows Server Container.

Error:  
```
'C:\Program' is not recognized as an internal or external command,
operable program or batch file.
```


### Container: Visual C++ Runtime x64/x86 2015 is not getting installed

Observed behavior:
In a Container:
```
C:\build\vcredist_2015_x64.exe /q /norestart
C:\build>echo %errorlevel%
0
C:\build>wmic product get
No Instance(s) Available.
```

This is an interop issue with the dedup filter. Dedup checks the rename target to see if it is a deduped file. The create it issues fails with `STATUS_IO_REPARSE_TAG_NOT_HANDLED` because the Windows Server Container filter is sitting above dedup.


See the [application compatability article](../reference/app_compat.md) for more information about what applications can be containerized.

--------------------------


## Docker management

### Not all Docker commands work
* Docker exec fails in Hyper-V Containers.

If anything that isn't on this list fails (or if a command fails differently than expected), let us know via [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

### Pasting commands to interactive Docker session is limited to 50 characters
Pasting commands to interactive Docker session is limited to 50 characters.  
If you copy a command line into an interactive Docker session, it is currently limited to 50 characters. The pasted string is simply truncated.

This is not by design, we're working on lifting the restriction.

### Net use errors
Net use returns System error 1223 instead of prompting for username or password

**Work Around:**  
Specify the username and password when running net use.

``` PowerShell
net use S: \\your\sources\here /User:shareuser [yourpassword]
``` 


--------------------------



## Remote Desktop 

Windows Containers cannot be managed/interacted with through a RDP session in TP5.

--------------------------

### Exiting a container in a Nano Server container host cannot be done with "exit"
If you try to exit a container that is in a Nano Server container host, using "exit" will disconnect you from the Nano Server container host, and will not exit the container.

**Work Around:**
Use Exit-PSSession instead to exit the container.

Feel free to voice feature requests in [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers). 


--------------------------


## Users and Domains

### Local Users
Local user accounts may be created and used for running Windows services and applications in containers.


### Domain Membership
Containers cannot join Active Directory domains, and cannot run services or applications as domain users, service accounts, or machine accounts. 

Containers are designed to start quickly to a known consistent state that is largely environment agnostic. Joining a domain and applying group policy settings from the domain would increase the time it takes to start a container, change how it functions over time, and limit the ability to move or share images between developers and across deployments.

We're carefully considering feedback on how services & applications use Active Directory and the intersection of deploying those in containers. If you have details on what would work best for you, please share it with us in [the forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers). 

We are actively looking at solutions to support these types of scenarios.
