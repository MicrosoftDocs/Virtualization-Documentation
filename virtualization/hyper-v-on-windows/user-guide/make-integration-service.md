---
title: Make your own integration services
description: Windows 10 integration services.
keywords: windows 10, hyper-v, HVSocket, AF_HYPERV
author: scooley
ms.author: scooley
ms.date: 04/07/2017
ms.topic: article
ms.prod: windows-10-hyperv
ms.assetid: 1ef8f18c-3d76-4c06-87e4-11d8d4e31aea
---

# Make your own integration services

Starting in Windows 10 Anniversary Update, anyone can make applications that communicate between the Hyper-V host and its virtual machines using Hyper-V sockets -- a Windows Socket with a new address family and specialized endpoint for targeting virtual machines.  All communication over Hyper-V sockets runs without using networking and all data stays on the same physical memory. Applications using Hyper-V sockets are similar to Hyper-V's integration services.

This document walks through creating a simple program built on Hyper-V sockets.

**Supported Host OS**
* Windows 10 and later
* Windows Server 2016 and later

**Supported Guest OS**
* Windows 10 and later
* Windows Server 2016 and later
* Linux guests with Linux Integration Services (see [Supported Linux and FreeBSD virtual machines for Hyper-V on Windows](/windows-server/virtualization/hyper-v/Supported-Linux-and-FreeBSD-virtual-machines-for-Hyper-V-on-Windows))
> **Note:** A supported Linux guest must have kernel support for:
> ```bash
> CONFIG_VSOCKET=y
> CONFIG_HYPERV_VSOCKETS=y
> ```

**Capabilities and Limitations**
* Supports kernel mode or user mode actions
* Data stream only
* No block memory (not the best for backup/video)

--------------

## Getting started

Requirements:
* C/C++ compiler.  If you don't have one, checkout [Visual Studio Community](https://aka.ms/vs)
* [Windows 10 SDK](https://developer.microsoft.com/windows/downloads/windows-10-sdk) -- pre-installed in Visual Studio 2015 with Update 3 and later.
* A computer running one of the host operating systems above with at least one vitual machine. -- this is for testing your application.

> **Note:** The API for Hyper-V sockets became publicly available in Windows 10 Anniversary Update. Applications that use HVSocket will run on any Windows 10 host and guest but can only be developed with a Windows SDK later than build 14290.

## Register a new application
In order to use Hyper-V sockets, the application must be registered with the Hyper-V Host's registry.

By registering the service in the registry, you get:
*  WMI management for enable, disable, and listing available services
*  Permission to communicate with virtual machines directly

The following PowerShell will register a new application named "HV Socket Demo".  This must be run as administrator.  Manual instructions below.

``` PowerShell
$friendlyName = "HV Socket Demo"

# Create a new random GUID.  Add it to the services list
$service = New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\GuestCommunicationServices" -Name ((New-Guid).Guid)

# Set a friendly name
$service.SetValue("ElementName", $friendlyName)

# Copy GUID to clipboard for later use
$service.PSChildName | clip.exe
```


**Registry location and information:**
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\GuestCommunicationServices\
```
In this registry location, you'll see several GUIDs.  Those are our in-box services.

Information in the registry per service:
* `Service GUID`
    * `ElementName (REG_SZ)` -- this is the service's friendly name

To register your own service, create a new registry key using your own GUID and friendly name.

The friendly name will be associated with your new application.  It will appear in performance counters and other places where a GUID isn't appropriate.

The registry entry will look like this:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\GuestCommunicationServices\
    999E53D4-3D5C-4C3E-8779-BED06EC056E1\
        ElementName    REG_SZ    VM Session Service
    YourGUID\
        ElementName    REG_SZ    Your Service Friendly Name
```

> **Note:** The Service GUID for a Linux guest uses the VSOCK protocol which addresses via a `svm_cid` and `svm_port` rather than a guids. To bridge this inconsistency with Windows the well-known GUID is used as the service template on the host which translates to a port in the guest. To customize your Service GUID simply change the first "00000000" to the port number desired. Ex: "00000ac9" is port 2761.
> ```C++
> // Hyper-V Socket Linux guest VSOCK template GUID
> struct __declspec(uuid("00000000-facb-11e6-bd58-64006a7986d3")) VSockTemplate{};
>
>  /*
>   * GUID example = __uuidof(VSockTemplate);
>   * example.Data1 = 2761; // 0x00000AC9
>   */
> ```
>

> **Tip:**  To generate a GUID in PowerShell and copy it to the clipboard, run:
>``` PowerShell
>(New-Guid).Guid | clip.exe
>```

## Create a Hyper-V socket

In the most basic case, defining a socket requires an address family, connection type, and protocol.

Here is a simple [socket definition](/windows/desktop/api/winsock2/nf-winsock2-socket)

``` C
// Windows
SOCKET WSAAPI socket(
  _In_ int af,
  _In_ int type,
  _In_ int protocol
);

// Linux guest
int socket(int domain, int type, int protocol);
```

For a Hyper-V socket:
* Address family - `AF_HYPERV` (Windows) or `AF_VSOCK` (Linux guest)
* type - `SOCK_STREAM`
* protocol - `HV_PROTOCOL_RAW` (Windows) or `0` (Linux guest)


Here is an example declaration/instantiation:
``` C
// Windows
SOCKET sock = socket(AF_HYPERV, SOCK_STREAM, HV_PROTOCOL_RAW);

// Linux guest
int sock = socket(AF_VSOCK, SOCK_STREAM, 0);
```

## Bind to a Hyper-V socket

Bind associates a socket with connection information.

The function definition is copied below for convinience, read more about bind [here](/windows/desktop/api/winsock/nf-winsock-bind).

``` C
// Windows
int bind(
  _In_ SOCKET                s,
  _In_ const struct sockaddr *name,
  _In_ int                   namelen
);

// Linux guest
int bind(int sockfd, const struct sockaddr *addr,
         socklen_t addrlen);
```

In contrast to the socket address (sockaddr) for a standard Internet Protocol address family (`AF_INET`) which consists of the host machine's IP address and a port number on that host, the socket address for `AF_HYPERV` uses the virtual machine's ID and the application ID defined above to establish a connection. If binding from a Linux guest `AF_VSOCK` uses the `svm_cid` and the `svm_port`.

Since Hyper-V sockets do not depend on a networking stack, TCP/IP, DNS, etc. the socket endpoint needed a non-IP, not hostname, format that still unambiguously describes the connection.

Here is the definition for a Hyper-V socket's socket address:

``` C
// Windows
struct SOCKADDR_HV
{
     ADDRESS_FAMILY Family;
     USHORT Reserved;
     GUID VmId;
     GUID ServiceId;
};

// Linux guest
// See include/uapi/linux/vm_sockets.h for more information.
struct sockaddr_vm {
    __kernel_sa_family_t svm_family;
    unsigned short svm_reserved1;
    unsigned int svm_port;
    unsigned int svm_cid;
    unsigned char svm_zero[sizeof(struct sockaddr) -
                   sizeof(sa_family_t) -
                   sizeof(unsigned short) -
                   sizeof(unsigned int) - sizeof(unsigned int)];
};
```

In lieu of an IP or hostname, AF_HYPERV endpoints rely heavily on two GUIDs:
* VM ID – this is the unique ID assigned per VM.  A VM’s ID can be found using the following PowerShell snippet.
  ```PowerShell
  (Get-VM -Name $VMName).Id
  ```
* Service ID – GUID, [described above](#register-a-new-application), with which the application is registered in the Hyper-V host registry.

There is also a set of VMID wildcards available when a connection isn't to a specific virtual machine.

### VMID Wildcards

| Name | GUID | Description |
|:-----|:-----|:-----|
| HV_GUID_ZERO | 00000000-0000-0000-0000-000000000000 | Listeners should bind to this VmId to accept connection from all partitions. |
| HV_GUID_WILDCARD | 00000000-0000-0000-0000-000000000000 | Listeners should bind to this VmId to accept connection from all partitions. |
| HV_GUID_BROADCAST | FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF | |
| HV_GUID_CHILDREN | 90db8b89-0d35-4f79-8ce9-49ea0ac8b7cd | Wildcard address for children. Listeners should bind to this VmId to accept connection from its children. |
| HV_GUID_LOOPBACK | e0e16197-dd56-4a10-9195-5ee7a155a838 | Loopback address. Using this VmId connects to the same partition as the connector. |
| HV_GUID_PARENT | a42e7cda-d03f-480c-9cc2-a4de20abb878 | Parent address. Using this VmId connects to the parent partition of the connector.* |


\* `HV_GUID_PARENT`
The parent of a virtual machine is its host.  The parent of a container is the container's host.
Connecting from a container running in a virtual machine will connect to the VM hosting the container.
Listening on this VmId accepts connection from:
(Inside containers): Container host.
(Inside VM: Container host/ no container): VM host.
(Not inside VM: Container host/ no container): Not supported.

## Supported socket commands

Socket()
Bind()
Connect()
Send()
Listen()
Accept()

## Useful links
[Complete WinSock API](/windows/desktop/WinSock/winsock-functions)

[Hyper-V Integration Services reference](../reference/integration-services.md)
