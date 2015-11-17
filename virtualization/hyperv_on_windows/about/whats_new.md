# What's New for Hyper-V on Windows 10

This topic explains the new and changed functionality in Hyper-V on Windows 10®.

## Windows PowerShell Direct

There is a now an easy and reliable way to run Windows PowerShell commands inside a virtual machine from the host operating system. There are no network or firewall requirements or special configuration. 
It works regardless of your remote management configuration. To use it, you must run Windows 10 or Windows Server Technical Preview on the host and the virtual machine guest operating system.

To create a PowerShell Direct session, use one of the following commands:

``` PowerShell
Enter-PSSession -VMName VMName
Invoke-Command -VMName VMName -ScriptBlock { commands }
```

Today, Hyper-V administrators rely on two categories of tools for connecting to a virtual machine on their Hyper-V host:
- Remote management tools such as PowerShell or Remote Desktop
- Hyper-V Virtual Machine Connection (VM Connect)

Both of these technologies work well, but each have trade-offs as your Hyper-V deployment grows. VMConnect is reliable, but it can be hard to automate. Remote PowerShell is powerful, but can be difficult to setup and maintain. 

Windows PowerShell Direct provides a powerful scripting and automation experience with the simplicity of VMConnect. Because Windows PowerShell Direct runs between the host and virtual machine, there is no need for a network connection or to enable remote management. You do need guest credentials to log into the virtual machine.

### Requirements
- You must be connected to a Windows 10 or Windows Server Technical Preview host with virtual machines that run Windows 10 or Windows Server Technical Preview as guests.
- You need to be logged in with Hyper-V Administrator credentials on the host.
- You need User credentials for the virtual machine.
- The virtual machine you want to connect to must be running and booted.


## Hot add and remove for network adapters and memory

You can now add or remove a Network Adapter while the virtual machine is running, without downtime. This works for generation 2 virtual machines running both Windows and Linux operating systems. 

You can also adjust the amount of memory assigned to a virtual machine while it's running, even if you haven’t enabled Dynamic Memory. This works for both generation 1 and generation 2 virtual machines.

## Production checkpoints

Production checkpoints allow you to easily create “point in time” images of a virtual machine, which can be restored later on in a way that is completely supported for all production workloads. This is achieved by using backup technology inside the guest to create the checkpoint, instead of using saved state technology. For production checkpoints, the Volume Snapshot Service (VSS) is used inside Windows virtual machines. Linux virtual machines flush their file system buffers to create a file system consistent checkpoint. If you want to create checkpoints using saved state technology, you can still choose to use standard checkpoints for your virtual machine. 


> **Important:** The default for new virtual machines will be to create production checkpoints with a fallback to standard checkpoints. 
 

## Hyper-V Manager improvements

- **Alternate credentials support** – You can now use a different set of credentials in Hyper-V manager when you connect to another Windows 10 Technical Preview remote host. You can also save these credentials so it's easier to log on later. 

- **Down-level management** - You can now use Hyper-V manager to manage more versions of Hyper-V. With Hyper-V manager in Windows 10 Technical Preview, you can manage computers running Hyper-V on Windows Server 2012, Windows 8, Windows Server 2012 R2 and Windows 8.1.

- **Updated management protocol** - Hyper-V manager has been updated to communicate with remote Hyper-V hosts using the WS-MAN protocol, which permits CredSSP, Kerberos or NTLM authentication. When you use CredSSP to connect to a remote Hyper-V host, it allows you to perform a live migration without first enabling constrained delegation in Active Directory. WS-MAN-based infrastructure also simplifies the configuration necessary to enable a host for remote management. WS-MAN connects over port 80, which is open by default.


## Connected Standby works 

When Hyper-V is enabled on a computer that uses the Always On/Always Connected (AOAC) power model, the Connected Standby power state is now available.

In Windows 8 and 8.1, Hyper-V caused computers that used the Always On/Always Connected (AOAC) power model (also known as InstantON) to never sleep. See this [KB article](
https://support.microsoft.com/en-us/kb/2973536) for a full description.


## Linux secure boot 

More Linux operating systems, running on generation 2 virtual machines, can now boot with the secure boot option enabled.  Ubuntu 14.04 and later, and SUSE Linux Enterprise Server 12, are enabled for secure boot on hosts that run the Technical Preview. Before you boot the virtual machine for the first time, you must specify that the virtual machine should use the Microsoft UEFI Certificate Authority.  At an elevated Windows Powershell prompt, type:

    Set-VMFirmware vmname -SecureBootTemplate MicrosoftUEFICertificateAuthority

For more information on running Linux virtual machines on Hyper-V, see [Linux and FreeBSD Virtual Machines on Hyper-V](http://technet.microsoft.com/library/dn531030.aspx).
 
 
## Virtual Machine configuration version

When you move or import a virtual machine to a host running Hyper-V on Windows 10 from host running Windows 8.1, the virtual machine’s configuration file isn't automatically upgraded. This allows the virtual machine to be moved back to a host running Windows 8.1. You won't have access to new virtual machine features until you manually update the virtual machine configuration version. 

The virtual machine configuration version represents what version of Hyper-V the virtual machine’s configuration, saved state, and snapshot files it's compatible with. Virtual machines with configuration version 5 are compatible with Windows 8.1 and can run on both Windows 8.1 and Windows 10. Virtual machines with configuration version 6 are compatible with Windows 10 and won't run on Windows 8.1.

### Check configuration version

From an elevated command prompt, run the following command:

``` PowerShell
Get-VM * | Format-Table Name, Version
```

### Upgrade configuration version 

From an elevated Windows PowerShell command prompt, run one of the following commands:

``` PowerShell
Update-VmConfigurationVersion <vmname>
```

Or

``` PowerShell
Update-VmConfigurationVersion <vmobject>
```

**Important: **
- After you upgrade the virtual machine configuration version, you can't move the virtual machine to a host that runs Windows 8.1.
- You can't downgrade the virtual machine configuration version from version 6 to version 5.
- You must turn off the virtual machine to upgrade the virtual machine configuration.
- After the upgrade, the virtual machine uses the new configuration file format. For more information, see New virtual machine configuration file format.


## Configuration file format

Virtual machines now have a new configuration file format which is designed to increase the efficiency of reading and writing virtual machine configuration data. It's also designed to reduce the potential for data corruption if there's a storage failure. The new configuration files use the .VMCX extension for virtual machine configuration data and the .VMRS extension for runtime state data. 


> **Important:** The .VMCX file is a binary format. Directly editing the .VMCX or .VMRS file isn't supported.

## Integration Services through Windows Update

Updates to integration services for Windows guests are now distributed through Windows Update.

Integration components (also called integration services) are the set of synthetic drivers which allow a virtual machine to communicate with the host operating system.  They control services ranging from time sync to guest file copy.  We've been talking to customers about integration component installation and update over the past year to discover that they are a huge pain point during the upgrade process.　

Historically, all new versions of Hyper-V came with new integration components. Upgrading the Hyper-V host required upgrading the integration components in the virtual machines as well.  The new integration components were included with the Hyper-V host then they were installed in the virtual machines using vmguest.iso.  This process required restarting the virtual machine and couldn't be batched with other Windows updates.  Since the Hyper-V administrator had to offer vmguest.iso and the virtual machine administrator had to install them, integration component upgrade required the Hyper-V administrator have administrator credentials in the virtual machines -- which isn't always the case.　　　　

In Windows 10 and going forward, all integration components will be delivered to virtual machined through Windows Update along with other important updates.　

There are updates available today for virtual machines running:
*  Windows Server 2012
*  Windows Server 2008 R2
*  Windows 8
*  Windows 7

The virtual machine must be connected to Windows Update or a WSUS server.  In the future, integration component updates will have a category ID, for this release, they are listed as KBs.

To read more about how we determine applicability, see this [blog post](http://blogs.technet.com/b/virtualization/archive/2014/11/24/integration-components-how-we-determine-windows-update-applicability.aspx).


See [this blog](http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/11/12/updating-integration-components-over-windows-update.aspx) post for a detailed walkthrough of installing integration services.


> **Important:** The ISO image file vmguest.iso is no longer needed for updating integration components. It's not included with Hyper-V on Windows 10.


## Next Step
[Walk through Hyper-V on Windows 10](..\quick_start\walkthrough.md) 