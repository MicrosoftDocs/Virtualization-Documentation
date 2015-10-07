ms.ContentId: c0da5ae7-69b6-49a5-934a-6315b5538d6c
title: Managing integration services

# Hyper-V Integration Services in Windows 10
Integration services (often called integration components), are services that allow the virtual machine to communicate with the Hyper-V host. Many of these services are conveniences (such as guest file copy), while others can be quite important to the guest operating system's ability to function correctly (time synchronization).

This article will detail how to manage integration services using both Hyper-V manager and PowerShell in Windows 10. For more information on each individual integration service, see [Integration Services]( https://technet.microsoft.com/en-us/library/dn798297.aspx) .

### Enable or Disable Integration Services using Hyper-V Manager

1. Select a virtual machine and open settings.
  ![](./media/HyperVManager-OpenVMSettings.png)
  
2. From the virtual machine settings window, go to the Integration Services tab under Management.
  
![](./media/HyperVManager-IntegrationServices.png)
  
  Here you can see all integration services available on this Hyper-V host.  It's worth noting that the guest operating system may or may not support all of the integration services listed.

### Enable or Disable Integration Services Using PowerShell

Integration services can also be enabled and disabled with PowerShell by running [`Enable-VMIntegrationService`](https://technet.microsoft.com/en-us/library/hh848500.aspx) and [`Disable-VMIntegrationService`](https://technet.microsoft.com/en-us/library/hh848488.aspx).

In this example, we'll enable and then disable the guest file copy integration service on the "demovm" virtual machine seen above.

1. See what integration services are running
  
  ``` PowerShell
  Get-VMIntegrationService -VMName "demovm"
  ```

  The output will look like this:  
  ``` PowerShell
  VMName      Name                    Enabled PrimaryStatusDescription SecondaryStatusDescription
  ------      ----                    ------- ------------------------ --------------------------
  chost       Guest Service Interface False   OK
  chost       Heartbeat               True    OK                       OK
  chost       Key-Value Pair Exchange True    OK
  chost       Shutdown                True    OK
  chost       Time Synchronization    True    OK
  chost       VSS                     True    OK
  ```

2. Enable the `Guest Service Interface` integration service

   ``` PowerShell
   Enable-VMIntegrationService -VMName "demovm" -Name "Guest Service Interface"
   ```
   
   If you run `Get-VMIntegrationService -VMName "demovm"` you will see that the Guest Service Interface integration service is enabled.
 
3. Disable the `Guest Service Interface` integration service

   ``` PowerShell
   Disable-VMIntegrationService -VMName "demovm" -Name "Guest Service Interface"
   ```
   
Integration services were designed such that they need to be enabled in both the host and the guest in order to function.  While all integration services are enabled by default on Windows guest operating systems, they can be disabled.  See how in the next section.


### Manage Integration Services from Guest OS (Windows)

> **Note:** disabling integration services may severely affect the hosts ability to manage your virtual machine.  Integration services must be enabled on both the host and guest to operate.

Integration services appear as services in Windows. To enable or disable an integration services from inside the virtual machine, open the Windows Services manager.

![](media/HVServices.png) 

Find the services containing Hyper-V in the name. Right click on the service you'd like to enable or disable and start or stop the service.

Alternately, to see all integration services with PowerShell, run:

```PowerShell
Get-Service -Name vm*
```

that will return a list that looks something like this:

```PowerShell
Status   Name               DisplayName
------   ----               -----------
Running  vmicguestinterface Hyper-V Guest Service Interface
Running  vmicheartbeat      Hyper-V Heartbeat Service
Running  vmickvpexchange    Hyper-V Data Exchange Service
Running  vmicrdv            Hyper-V Remote Desktop Virtualizati...
Running  vmicshutdown       Hyper-V Guest Shutdown Service
Running  vmictimesync       Hyper-V Time Synchronization Service
Stopped  vmicvmsession      Hyper-V VM Session Service
Running  vmicvss            Hyper-V Volume Shadow Copy Requestor
```

Start or stop services using [`Start-Service`](https://technet.microsoft.com/en-us/library/hh849825.aspx) or [`Stop-Service`](https://technet.microsoft.com/en-us/library/hh849790.aspx) .

By default, all integration services are enabled in the guest operation system.

### Manage Integration Services from Guest OS (Linux)

Linux integration services are provided through the Linux kernel.

On Linux virtual machines you can check to see if the integration services driver and daemons are running by running the following commands in your Linux guest operating system.

``` BASH
lsmod|grep hv_utils
```

Run the following command in your Linux guest operating system to see if the required daemons are running.

``` BASH
ps –eaf|grep hv
```

## Updating integration services

### Why should I update my integration services?
Integration services recieve updates to enable more management features across the host and guest operating system.

### When do I update integration components?

Starting in Windows 10, integration components are delivered directly through Windows Update and update automatically as part of the important updates.

Prior to Windows 10, integration components needed to be updated any time the Hyper-V host was updated.

**How do I install integration services?**
Integration services are built into Windows as well as many versions of Linux therefor they rarely (if ever) need to be installed.

### Updating on windows 10

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
The time synchronization service synchronizes your virtual machines’ time with the time from the pysical host.

### Operating system shutdown
The operating system shutdown service lets the Hyper-V administrator start a friendly shutdown sequence in the virtual machine from the host without logging into the virtual machine.

Using the shutdown service, the virtual machine will attempt to close open processes and write to disk any data in memory before shutting down the virtual machine, in the same way if the administrator had selected Shutdown from within the guest operating system.  Without this integration service, the Hyper-V administrator can only perform hard shutdowns -- this is the equivelant of pulling the powercord.

You can shutdown virtual machines from Hyper-V Manager or PowerShell using [`Stop-VM`](https://technet.microsoft.com/en-us/library/hh848468.aspx).

### Data exchange (KVP)
The Data Exchange integration service (often called KVP) allows basic data sharing between the Hyper-V host and virtual machine using the Windows registry.
information about the virtual machine and host is automatically generated and stored in the registry for virtual machines running Windows and in files for virtual machines running Linux. Additionally there is a registry key and file where information can be created manually that can be shared between the host and the virtual machine. For example a service running in a virtual machine could write to this location when a specific event has occurred that requires the Hyper-V administrator to perform a specific action.
Access to the data from the host is via WMI scripts only.
For additional information about data exchange, see Data Exchange: Using key-value pairs to share information between the host and guest on Hyper-V
Heartbeat

The data shared can be seen in:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters
```

> The data exchange integration service does not expose data between any two virtual machines. It is limited to the host and virtual machine.

### Backup (Volume Shadow Copy)
The backup service lets the Hyper-V administrator backup the virtual machine while running.

### Heartbeat 
The heartbeat service reports that the guest operating system is running.

You can check the heartbeat status of a virtual machine on the Summary tab of the Virtual Machines details page or you can use the Get-VMIntegrationSerivce cmdlet. For additional information about the Get-VMIntegrationService cmdlet.

### Guest Services
To copy a file to a virtual machine you need to use the Copy-VMFile PowerShell cmdlet. For additional information about the Copy-VMFile Windows PowerShell cmdlet, see Copy-VMFile.

Guest File Copy
The guest service allows the Hyper-V administrator to copy files to a running virtual machine without using a network connection. Beforehand the only way to copy files to the virtual machine was for both the virtual machine and the host be connected to same network and then either use file services to copy file or to create a remote desktop session to the virtual machine and copy files via RDS session.

PowerShell Direct
