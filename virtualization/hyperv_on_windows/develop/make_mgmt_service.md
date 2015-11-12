# Make a new management service #

This document introduces VM Services built on Hyper-V sockets and how to get started using them.

## What is a VM Service?
VM Services are services that span the Hyper-V host and virtual machines running on the host.

Hyper-V now (Windows 10 and Server 2016+) provides a non-network connection which allows you to create services spanning the host/virtual machine boundary while preserving Hyper-V’s fundamental requirements around tenant/hoster isolation, control, and diagnosable.

Hyper-V will continue to provide a base set of in-box services (integration services) for basics (such as time sync) and for common requests we receive, but now anyone can write and deploy a VM service as needed.

PowerShell Direct is an in-box example of a VM Service.

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

## Getting started

This guide assumes you're familiar with socket programming in C/C++.

### Step 1 - Register your service on the Hyper-V host
In order to use a custom service integrated with Hyper-V, the new service must be registered with the Hyper-V Host's registry.

By registering the service in the registry, you get:
*  WMI management for enable, disable, and listing available services
*  Onto the list of services allowed to communicate with virtual machines directly.

** Registry location and information **  

``` 
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\VirtualDevices\6C09BB55-D683-4DA0-8931-C9BF705F6480\GuestCommunicationServices\
```
In this registry location, you'll see several GUIDS.  Those are our in-box services.

Information in the registry per service:
* `Service GUID`   
    * `ElementName (REG_SZ)` -- this is the service's friendly name

To register your own service, create a new registry key using your own GUID and friendly name.

The registry entry will look like this:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\GuestCommunicationServices\
    999E53D4-3D5C-4C3E-8779-BED06EC056E1\
	    ElementName	REG_SZ	VM Session Service
    YourGUID\
	    ElementName	REG_SZ	Your Service Friendly Name
```

> ** Tip: **  To generate a GUID in PowerShell and copy it to the clipboard, run:  
``` PowerShell
[System.Guid]::NewGuid().ToString() | clip.exe
```

<!-- How do customers know this worked -->

### Step 2 - Create a simple host-side service



### Step 3 - Create a simple guest-side service

## More information about AF_HYPERV
Since Hyper-V sockets do not depend on a networking stack, TCP/IP, DNS, etc. the socket end point needed a non-IP, not hostname, format that still describes the connection.  In lieu of an IP or hostname, AF_HYPERV endpoints rely heavily on two GUIDS:  
* VM ID – this is the unique ID assigned per VM.  A VM’s ID can be found using the following PowerShell snippet.
```PowerShell
(Get-VM -Name vmname).Id
```
* Service ID – GUID under which the service is registered in the Hyper-V host registry.  See [Registering a New Service](#GettingStarted).

For connections from a service on the host to the service on a VM:  
VMID and Service ID
For connections from a service on a VM to the service on the host:  
Zero GUID and Service ID

## Supported socket commands

Socket()
Bind()
Connect ()
Send()
Listen()
Accept()


 
