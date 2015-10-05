ms.ContentId: c0da5ae7-69b6-49a5-934a-6315b5538d6c
title: Managing integration services

# Managing integration service
Welcome to the in-depth reference for everything integration service related.

## Integration services and what they do
Integration services (often called integration components) are services that allow the virtual machine to communicate with the Hyper-V host.

Many of these services are conviniences (such as guest services) while others can be quite important to the guest operating system's ability to fucntion correctly (time synchronization).

This article aims to demystify the finer points of managing integration services on any supported Hyper-V environment.


## Integration service management

### Enable or disable integration services from the Hyper-V host
Integration services can be enabled or disabled on a per-virtual machine basis using both the virtual machine settings in Hyper-V Manager and PowerShell.

To enable or disable integration services using Hyper-V Manager, select a virtual machine and open settings.

![](./media/HyperVManager-OpenVMSettings.png)

From the virtual machine settings window, go to the Integration Services tab under Management.

![](./media/HyperVManager-IntegrationServices.png)

Here you can see all integration services available on this Hyper-V host.  It's worth noting that the guest operating system may or may not support all of the integration services listed.

Integration services were designed such that they need to be enabled in both the host and the guest in order to function.  While all integration services are enabled by default on Windows guest operating systems, they can be disabled.  See how in the next section.


### Manage integration services from the guest operating system

#### On Windows Guests

> **Note:** disabling integration services may severly affect the hosts ability to manage your virtual machine.

Integration services appear as services in Windows.  To enable or disable an integration services from inside the virtual machine, open the Windows Services manager.

![](media/HVServices.png) 

Find the services containing Hyper-V in the name.  Right click on the service you'd like to enable or disable and start or stop the service.
 
By default, all integration services are enabled in the guest operation system.

#### On Linux Guests

Linux integration services are provided through the Linux kernel.

On Linux virtual machines you can check to see if the integration services driver and daemons are running by running the following commands in your Linux guest operating system.

``` BASH
lsmod|grep hv_utils
```

Run the following command in your Linux guest operating system to see if the required daemons are running.

``` BASH
ps –eaf|grep hv
```

## Installing and updating integration services

> IC Version is deprecated in Windows 10 and Server 16.

### Install integration components on offline virtual machines

## Integration service details

| Service Name | Default State | Introduced | Supported Guests | Service Name in Windows Guests | Driver/Daemon name in Linux Guests | 
|:----------|:---------------|:------------|:------------|:------------|
| Operating system shutdown | Enabled | Windows Server 2012 | Windows Server 2012, Windows Server 2012 R2 | Hyper-V Guest Shutdown Service | hv_utils |
| Time synchronization | Enabled | Windows Server 2012 | Windows Server 2012,  Windows Server 2012 R2 | Hyper-V Time Synchronization Service | hv_utils |
| Data Exchange | Enabled | Windows Server 2012 | Windows Server 2012, Windows Server 2012 R2 | Hyper-V Data Exchange Service | hv_utils, hv_kvp_daemon |
| Heartbeat | Enabled | Windows Server 2012 | Windows Server 2012 and Windows Server 2012 R2 | Hyper-V Heartbeat Service | hv_utils |
| Backup (volume snapshot) | Enabled | Windows Server 2012 | Windows Server 2012, Windows Server 2012 R2 | Hyper-V Volume Shadow Copy Requestor | hv_utils, hv_vss_daemon |
| Guest services | Disabled | Windows Server 2012 R2 | Windows Server 2012 R2 | Hyper-V Guest Services Interface | hv_utils, hv_fcopy_daemon |

### Time synchronization
The time synchronization service provides the ability to synchronize your virtual machines’ time with the time from the host. Just as time is critical to physical servers it is critical to virtual machines.
For additional information about time synchronization and in what scenarios you should disable the service, see Time Synchronization.
Data Exchange

### Operating system shutdown
The operating system shutdown service provides a mechanism to shut down the operating system of a virtual machine from the management interfaces on the host or management computer. This allows the Hyper-V administrator the ability to initiate an orderly shutdown of the virtual machines without having to log into the virtual machine. The virtual machine will attempt to close open processes and write to disk any data in memory before shutting down the virtual machine, in the same way if the administrator had selected Shutdown from within the virtual machine.
You can shutdown virtual machines from the Hyper-V Manager console or via the Stop-VM PowerShell cmdlet. For more information about Stop-VM cmdlet, see Stop-VM.

### Data exchange (KVP)
The Data Exchange integration service (often called KVP) allows basic data sharing between the Hyper-V host and virtual machine using the Windows registry.

The data shared can be seen in:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters
```

> The data exchange integration service does not expose data between any two virtual machines. It is limited to the host and virtual machine.

### Backup (Volume Shadow Copy)
The backup service enables consistent backup of the virtual machines from backup software running on the host. The backup service allows for the virtual machine to be backed up while it is running without any interruption to the virtual machine or the services running in the virtual machine.
For more information about backing up your virtual machines, see Considerations for backing up and restoring virtual machines.
Guest services

### Heartbeat 
The heartbeat service monitors the state of running virtual machines by reporting a heartbeat at regular intervals. This service helps you identify running virtual machines that might have stopped responding. You can check the heartbeat status of a virtual machine on the Summary tab of the Virtual Machines details page or you can use the Get-VMIntegrationSerivce cmdlet. For additional information about the Get-VMIntegrationService cmdlet, see Get-VMIntegrationService.

### Guest Services
The data exchange service, also known as key-value pairs (KVP), allows for the sharing of information between the host and virtual machine. General information about the virtual machine and host is automatically generated and stored in the registry for virtual machines running Windows and in files for virtual machines running Linux. Additionally there is a registry key and file where information can be created manually that can be shared between the host and the virtual machine. For example a service running in a virtual machine could write to this location when a specific event has occurred that requires the Hyper-V administrator to perform a specific action.
Access to the data from the host is via WMI scripts only.
For additional information about data exchange, see Data Exchange: Using key-value pairs to share information between the host and guest on Hyper-V
Heartbeat

The Hyper-V Guest Service Interface service enters a running state when the Guest services service is selected on the Integration Services property page of the virtual machine.
To disable this feature in a virtual machine running Windows, set the Hyper-V Guest Service Interface service startup type to Disabled inside the virtual machine.
To disable this feature in a virtual machine running Linux, stop and disable the hv_fcopy_daemon daemon. Consult your Linux distribution’s documentation for the steps to stop or disable a daemon process.
To copy a file to a virtual machine you need to use the Copy-VMFile PowerShell cmdlet. For additional information about the Copy-VMFile Windows PowerShell cmdlet, see Copy-VMFile.


Guest File Copy
The guest service allows the Hyper-V administrator to copy files to a running virtual machine without using a network connection. Beforehand the only way to copy files to the virtual machine was for both the virtual machine and the host be connected to same network and then either use file services to copy file or to create a remote desktop session to the virtual machine and copy files via RDS session.



PowerShell Direct
