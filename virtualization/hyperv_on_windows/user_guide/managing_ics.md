ms.ContentId: c0da5ae7-69b6-49a5-934a-6315b5538d6c
title: Managing integration services

# Managing integration service
Welcome to the in-depth reference for everything integration service related.

## Integration services and what they do
Integration services (often called integration components) are services that allow the virtual machine to communicate with the Hyper-V host.  
Some of the tasks integration services provide include:
* Time synchronization
* Operating system shutdown
* Data exchange (KVP)
* Backup (Volume Shadow Copy)
* Heartbeat 
* Guest Services
  * Guest File Copy
  * PowerShell Direct

Many of these services are conviniences (such as guest services) while others can be quite important to the guest operating system's ability to fucntion correctly (time synchronization) -- the list above is loosely organized by importance on a fresh Hyper-V installation.

This article aims to demystify the finer points of managing integration services on any supported Hyper-V environment.


## Integration service management

### Enable or disable integration services from the Hyper-V host
Integration services can be enabled or disabled on a per-virtual machine basis using both the virtual machine settings in Hyper-V Manager and PowerShell.

To enable or disable integration services using Hyper-V Manager, select a virtual machine and open settings.

![](./media/HyperVManager-OpenVMSettings.png)

![](./media/HyperVManager-IntegrationServices.png)

Integration services were designed such that they need to be enabled in both the host and the guest in order to function.

### Manage integration services from the guest operating system

> **Note** disabling integration services may severly affect the hosts ability to manage your virtual machine.

Integration components appear as services in virtual machines running Windows.  To enable or disable an integration components from inside the virtual machine, open the Windows Services manager.

![](media/HVServices.png) 

Find the services containing Hyper-V in the name.  Right click on the service you'd like to enable or disable and start or stop the service.
 
By default, all integration services are enabled in the guest operation system.

## Installing and updating integration services

> IC Version is deprecated in Windows 10 and Server 16.

### Install integration components on offline virtual machines

## Service details

| Service Name | Default State | Supported Guests | Introduced in | 
|:----------|:---------------|:------------|:------------|
| Operating system shutdown| jfndkng | kifjhndinf| orfjhndihng |

### Time synchronization
### Operating system shutdown
### Data exchange (KVP)
The Data Exchange integration service (often called KVP) allows basic data sharing between the Hyper-V host and virtual machine using the Windows registry.

The data shared can be seen in:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters
```

> The data exchange integration service does not expose data between any two virtual machines. It is limited to the host and virtual machine.

### Backup (Volume Shadow Copy)
### Heartbeat 
### Guest Services
Guest File Copy
PowerShell Direct
