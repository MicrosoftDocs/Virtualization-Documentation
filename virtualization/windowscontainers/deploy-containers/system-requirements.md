## Matching Container Host Version with Container Image Versions
### Windows Server Containers
Because Windows Server Containers and the underlying host share a single kernel, the container’s base image must match that of the host.  If the versions are different the container may start, but full functionally cannot be guaranteed. The Windows operating system has 4 levels of versioning, Major, Minor, Build and Revision – for example 10.0.14393.103. The build number (i.e. 14393) only changes when new versions of the OS are published, such as version 1709, 1803, fall creators update etc... The revision number (i.e. 103) is updated as Windows updates are applied.
#### Build Number (new release of Windows)
Windows Server Containers are blocked from starting when the build number between the container host and the container image are different - for example 10.0.14393.* (Windows Server 2016) and 10.0.16299.* (Windows Server version 1709).  
#### Revision Number (patching)
Windows Server Containers are _not_ blocked from starting when the revision number between the container host and the container image are different for example 10.0.14393.1914 (Windows Server 2016 with KB4051033 applied) and 10.0.14393.1944 (Windows Server 2016 with KB4053579 applied).  
For Windows Server 2016 based hosts/images – the container image’s revision must match the host to be in a supported configuration.  Starting with Windows Server version 1709, this is no longer applicable, and the host and container image need not have matching revisions.  It is as always recommended to keep your systems up-to-date with the latest patches and updates.
#### Practical Application
Example 1:  Container host is running Windows Server 2016 with KB4041691 applied.  Any Windows Server container deployed to this host must be based on the 10.0.14393.1770 container base images.  If KB4053579 is applied to the host the container images must be updated at the same time to remain supported.
Example 2:  Container host is running Windows Server version 1709 with KB4043961 applied.  Any Windows Server container deployed to this host must be based on a Windows Server version 1709 (10.0.16299) container base image but need not match the host KB.  If KB4054517 is applied to the host the container images do not need to be updated, though should be in order to fully address any security issues.
#### Querying version
Method 1:
Introduced in version 1709 the cmd prompt and ver command now return the revision details.
```
Microsoft Windows [Version 10.0.16299.125]
(c) 2017 Microsoft Corporation. All rights reserved.

C:\>ver

Microsoft Windows [Version 10.0.16299.125] 
```
Method 2:
Query the following registry key: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion
For example:
```
C:\>reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx
```
Or
```
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator> (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\').BuildLabEx
14393.321.amd64fre.rs1_release_inmarket.161004-2338
```

To check what version your base image is using you can review the tags on the Docker hub or the image hash table provided in the image description.  The [Windows 10 Update History](https://support.microsoft.com/en-us/help/12387/windows-10-update-history) page lists when each build and revision was released.

### Hyper-V Isolation for Containers
Windows containers can be run with or without Hyper-V isolation.  Hyper-V isolation creates a secure boundary around the container with an optimized VM.  Unlike standard Windows containers, which share the kernel between containers and the host, each Hyper-V isolated container has its own instance of the Windows kernel.  Because of this you can have different OS versions in the container host and image (see compatibility matrix below).  

To run a container with Hyper-V isolation, simply add the tag "--isolation=hyperv" to your docker run command.

### Compatibility Matrix
Windows Server builds after 2016 GA (10.0.14393.206) can run the Windows Server 2016 GA images of both Windows Server Core or Nano Server in a supported configuration regardless of the revision number.
A Windows Server version 1709 host can also run Windows Server 2016 based containers, however the inverse is not supported.

It is important to understand that in order to have the full functionality, reliability and security assurances provided with Windows updates you should maintain the latest versions on all systems.  
