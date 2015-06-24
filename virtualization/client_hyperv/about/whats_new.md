ms.ContentId: 52DAFFBE-40F5-46D2-96F3-FB8659581594 
title: What's New in Client Hyper-V for Windows 10



# What's New for Client Hyper-V in Windows 10 #

This topic explains the new and changed functionality in Client Hyper-V running on Windows 10® Technical Preview.

----------
**Important** 

Before you begin, you need to update existing virtual machines to enable new features. 

If you use virtual machines that were created with Windows 8.1 you will not have access to new virtual machine features until you manually update the virtual machine configuration version. 

To upgrade the configuration version, shut down the virtual machine and then, at an elevated Windows PowerShell command prompt, type: 

    Update-VmConfigurationVersion <vmname> | <vmobject> 

For important information about virtual machine configuration version, see Virtual Machine Configuration Version. 

----------

## Compatible with Connected Standby ##

When Hyper-V is enabled on a computer that uses the Always On/Always Connected (AOAC) power model, the Connected Standby power state is now available and works as expected.
 
## Virtual Machine Configuration Version ##

When you move or import a virtual machine to a host running Client Hyper-V on Windows 10 from host running Windows 8.1, the virtual machine’s configuration file is not automatically upgraded. This allows the virtual machine to be moved back to host running Windows 8.1. You will not have access to new virtual machine features until you manually update the virtual machine configuration version. 

The virtual machine configuration version represents what version of Hyper-V the virtual machine’s configuration, saved state, and snapshot files it is compatible with. Virtual machines with configuration version 5 are compatible with Windows 8.1 and can run on both Windows 8.1 and Windows 10. Virtual machines with configuration version 6 are compatible with Windows 10 and will not run on Windows 8.1.

### How do I check the configuration version of the virtual machines running on Hyper-V? ###

From an elevated command prompt run the following command:

    Get-VM * | Format-Table Name, Version

### How do I upgrade the configuration version of a virtual machine?  ###

From an elevated Windows PowerShell command prompt run one of the following commands:

    Update-VmConfigurationVersion <vmname>

Or

    Update-VmConfigurationVersion <vmobject>

----------------
**Important **

• After you upgrade the virtual machine configuration version, you cannot move the virtual machine to a host running Windows 8.1.

• You cannot downgrade the virtual machine configuration version back from version 6 to version 5.

• The virtual machine must be turned off in order to upgrade the virtual machine configuration.

• After the upgrade the virtual machine will use the new configuration file format. For more information, see New virtual machine configuration file format.

----------

## New virtual machine configuration file format ##

Virtual machines now have a new configuration file format which is designed to increase the efficiency of reading and writing virtual machine configuration data. It is also designed to reduce the potential for data corruption in the event of a storage failure. The new configuration files use the .VMCX extension for virtual machine configuration data and the .VMRS extension for runtime state data. 

----------
**Important** 

The .VMCX file is a binary format, directly editing the .VMCX or .VMRS file is not supported.

----------

## Production checkpoints ##

Production checkpoints allow you to easily create “point in time” images of a virtual machine, which can be restored later on in a way that is completely supported for all production workloads. This is achieved by using backup technology inside the guest to create the checkpoint, instead of using saved state technology. For production checkpoints, the Volume Snapshot Service (VSS) is used inside Windows virtual machines. Linux virtual machines flush their file system buffers to create a file system consistent checkpoint. If you want to create checkpoints using saved state technology you can still choose to use standard checkpoints for your virtual machine. 

----------

**Important**

The default for new virtual machines will be to create production checkpoints with a fallback to standard checkpoints. 
 
----------

## Hyper-V Manager improvements ##

- **Alternate credentials support** – you can now use a different set of credentials in Hyper-V manager when connecting to another Windows 10 Technical Preview remote host. You can also choose to save these credentials to make it easier to log on again later. 

- **Down-level management** - you can now use Hyper-V manager to manage more versions of Hyper-V. With Hyper-V manager in Windows 10 Technical Preview, you can manage computers running Hyper-V on Windows Server 2012, Windows 8, Windows Server 2012 R2 and Windows 8.1.


- **Updated management protocol** - Hyper-V manager has been updated to communicate with remote Hyper-V hosts using the WS-MAN protocol, which permits CredSSP, Kerberos or NTLM authentication. Using CredSSP to connect to a remote Hyper-V host allows you to perform a live migration without first enabling constrained delegation in Active Directory. Moving to the WS-MAN-based infrastructure also simplifies the configuration necessary to enable a host for remote management because WS-MAN connects over port 80, which is open by default.

## Integration Services delivered through Windows Update ##

Updates to integration services for Windows guests are now distributed through Windows Update. For information about integration services for Linux guests, see Linux and FreeBSD Virtual Machines on Hyper-V .


----------
**Important**

vmguest.iso is no longer needed for updating integration components, it is no longer included with Hyper-V.
 
----------


## Hot add and remove for network adapters and memory ##

You can now add or remove a Network Adapter while the virtual machine is running, without incurring downtime. This works for generation 2 virtual machines running both Windows and Linux operating systems. 

You can also adjust the amount of memory assigned to a virtual machine while it is running, even if you haven’t enabled Dynamic Memory. This works for both generation 1 and generation 2 virtual machines.

## Linux secure boot ##

Linux operating systems running on generation 2 virtual machines can now boot with the secure boot option enabled.  Ubuntu 14.04 and later, and SUSE Linux Enterprise Server 12, are enabled for secure boot on hosts running the Technical Preview. Before you boot the virtual machine for the first time, you must specify that the virtual machine should use the Microsoft UEFI Certificate Authority.  At an elevated Windows Powershell prompt, type:

    Set-VMFirmware vmname -SecureBootTemplate MicrosoftUEFICertificateAuthority

For more information on running Linux virtual machines on Hyper-V, see [Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx).


## Next Steps ##
[Walk through Client Hyper-V on Windows 10](..\quick_start\walkthrough.md) 