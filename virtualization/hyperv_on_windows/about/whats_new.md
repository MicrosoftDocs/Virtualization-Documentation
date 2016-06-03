---
redirect_url: https://msdn.microsoft.com/virtualization/hyperv_on_windows/windows_welcome
---

## Hot add and remove for network adapters and memory

You can now add or remove a network adapter while the virtual machine is running, without downtime. This works for Generation 2 virtual machines running both Windows and Linux operating systems. 

You can also adjust the amount of memory assigned to a virtual machine while it's running, even if you haven’t enabled Dynamic Memory. This works for both Generation 1 and Generation 2 virtual machines.

## Production checkpoints

Production checkpoints allow you to easily create “point in time” images of a virtual machine, which can be restored later on in a way that is completely supported for all production workloads. This is achieved by using backup technology inside the guest to create the checkpoint, instead of using saved state technology. For production checkpoints, the Volume Snapshot Service (VSS) is used inside Windows virtual machines. Linux virtual machines flush their file system buffers to create a file system consistent checkpoint. If you want to create checkpoints using saved state technology, you can still choose to use standard checkpoints for your virtual machine. 


> **Important:** The default for new virtual machines will be to create production checkpoints with a fallback to standard checkpoints. 
 

## Hyper-V Manager improvements

- **Alternate credentials support** – You can now use a different set of credentials in Hyper-V Manager when you connect to another Windows 10 Technical Preview remote host. You can also save these credentials so it's easier to log on later. 

- **Down-level management** - You can now use Hyper-V Manager to manage more versions of Hyper-V. With Hyper-V Manager in Windows 10 Technical Preview, you can manage computers running Hyper-V on Windows Server 2012, Windows 8, Windows Server 2012 R2, and Windows 8.1.

- **Updated management protocol** - Hyper-V Manager has been updated to communicate with remote Hyper-V hosts using the WS-MAN protocol, which permits CredSSP, Kerberos or NTLM authentication. When you use CredSSP to connect to a remote Hyper-V host, it allows you to perform a live migration without first enabling constrained delegation in Active Directory. WS-MAN-based infrastructure also simplifies the configuration necessary to enable a host for remote management. WS-MAN connects over port 80, which is open by default.


## Connected Standby compatibility 

When Hyper-V is enabled on a computer that uses the Always On/Always Connected (AOAC) power model, the Connected Standby power state is now available.

In Windows 8 and 8.1, Hyper-V caused computers that used the Always On/Always Connected (AOAC) power model (also known as InstantON) to never sleep. See this [KB article](
https://support.microsoft.com/en-us/kb/2973536) for a full description.


## Linux secure boot 

More Linux operating systems, running on Generation 2 virtual machines, can now boot with the secure boot option enabled.  Ubuntu 14.04 and later, and SUSE Linux Enterprise Server 12, are enabled for secure boot on hosts that run the Technical Preview. Before you boot the virtual machine for the first time, you must specify that the virtual machine should use the Microsoft UEFI Certificate Authority.  At an elevated Windows PowerShell prompt, type:

    Set-VMFirmware [-VMName] <VMName> [-SecureBootTemplate] <MicrosoftUEFICertificateAuthority>

For more information on running Linux virtual machines on Hyper-V, see [Linux and FreeBSD Virtual Machines on Hyper-V](http://technet.microsoft.com/library/dn531030.aspx).
 
 
## Virtual Machine configuration version

When you move or import a virtual machine to a host running Hyper-V on Windows 10 from a host running Windows 8.1, the virtual machine’s configuration file isn’t automatically upgraded. This allows the virtual machine to be moved back to a host running Windows 8.1. You won’t be able to use new Hyper-V features with your virtual machine until you manually update the virtual machine configuration version. 

The virtual machine configuration version represents what versions of Hyper-V the virtual machine’s configuration, saved state, and snapshot files are compatible with. Virtual machines with configuration version 5 are compatible with Windows 8.1 and can run on both Windows 8.1 and Windows 10. Virtual machines with configuration version 6 are compatible with Windows 10 and won't run on Windows 8.1.

### Check configuration version

From an elevated command prompt, run the following command:

``` PowerShell
Get-VM * | Format-Table Name, Version
```

### Upgrade configuration version 

From an elevated Windows PowerShell prompt, run one of the following commands:

``` 
Update-VmConfigurationVersion <VMName>
```

Or

``` 
Update-VmConfigurationVersion <VMObject>
```

> **Important:**
>
- After you upgrade the virtual machine configuration version, you can't move the virtual machine to a host that runs Windows 8.1.
- You can't downgrade the virtual machine configuration version from version 6 to version 5.
- You must turn off the virtual machine to upgrade the virtual machine configuration.
- After the upgrade, the virtual machine uses the new configuration file format. For more information, see [Configuration file format](#configuration-file-format).


## <a name="configuration-file-format"></a>Configuration file format

Virtual machines now have a new configuration file format which is designed to increase the efficiency of reading and writing virtual machine configuration data. It's also designed to reduce the potential for data corruption if there's a storage failure. The new configuration files use the .VMCX extension for virtual machine configuration data and the .VMRS extension for runtime state data. 

> **Important:** The .VMCX file is a binary format. Directly editing the .VMCX or .VMRS file isn't supported.