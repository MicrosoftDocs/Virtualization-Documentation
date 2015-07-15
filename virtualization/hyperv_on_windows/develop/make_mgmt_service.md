ms.ContentId: 6C7EB25D-66FB-4B6F-AB4A-79D6BB424637
title: Make a new management service

# Make a new management service #
This document introduces VM Services built on Hyper-V sockets and how to get started using them.

## What is a VM Service?
VM Services are services that span the Hyper-V host and virtual machines running on the host.

Hyper-V now (Windows 10 and Server 2016+) provides a non-network connection which allows you to create services spanning the host/virtual machine boundary while preserving Hyper-V’s fundamental requirements around tenant/hoster isolation, control, and diagnosable.

Hyper-V will continue to provide a base set of in-box services (integration services) for basics (such as time sync) and for common requests we receive, but now anyone can write and deploy a VM service as needed.

## What is a Hyper-V socket?
Hyper-V sockets are TCP-like sockets with no dependence on networking.  Using Hyper-V sockets, services can run independently of the networking stack and all data flow stays on host memory.

## System Requirements

**Supported Host OS**
*	Windows 10
*	Windows Server Technical Preview 3
*	Future releases (Server 2016 +)

**Supported Guest OS**
*	Windows 10
*	Windows Server Technical Preview 3
*	Future releases (Server 2016 +)
*	Linux

## Capabilities and Limitations
Kernel mode or user mode  
Data stream only  	
No block memory so not the best for backup/video  
[todo] Ballpark benchmarks  


# Getting started #
## Register your service on the Hyper-V host ##
In order to use a custom service integrated with Hyper-V, the new service must be registered with the Hyper-V Host's registry.

By registering the service in the registry, you get:
*  WMI management for enable, disable, and listing available services
*  Onto the list of services allowed to communicate with virtual machines directly.

### Registry location and information ###
Registry key:

``` 
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\VirtualDevices\6C09BB55-D683-4DA0-8931-C9BF705F6480\GuestCommunicationServices\
```

In this registry location, you'll see several GUIDS.  Those are our in-box services.

Information in the registry per service:
*  `Service GUID`   
    *  `ElementName (REG_SZ)` -- this is the service's friendly name
    *  (planned) Service Discription

### Generate a GUID with PowerShell ###
To generate a GUID in PowerShell and copy it to the clipboard, run:

``` PowerShell
[System.Guid]::NewGuid().ToString() | clip.exe
```
