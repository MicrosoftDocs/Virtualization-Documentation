ms.ContentId: E324BA8C-D573-4A84-945D-BB8456161793
title: Make a new management service

# Make a new management service #
Why would you do this?
Need a way to communicate between the host OS and guest OS.  Data stream.

# Getting started #
## Register your service on the Hyper-V host ##
In order to use a custom service integrated with Hyper-V, the new service must be registered with the Hyper-V Host's registry.

By registering the service in the registry, you get:
*  WMI management for enable, disable, and listing available services
*  Onto the list of services allowed to communicate with virtual machines directly.

### Registry location and information ###
Registry key:

    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\VirtualDevices\6C09BB55-D683-4DA0-8931-C9BF705F6480\GuestCommunicationServices\

In this registry location, you'll see several GUIDS.  Those are our in-box services.

Information in the registry per service:
*  Service GUID
    **  ElementName (REG_SZ) -- this is the service's friendly name
    **  (planned) Service Discription

### Generate a GUID with PowerShell ###
To generate a GUID in PowerShell and copy it to the clipboard, run:

    [System.Guid]::NewGuid().ToString() | clip.exe

