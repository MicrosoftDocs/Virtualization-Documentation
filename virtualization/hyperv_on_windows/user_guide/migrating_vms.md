---
redirect_url: http://aka.ms/upgradevmconfig
---

# Migrate and upgrade virtual machines 

If you move virtual machines to your Windows 10 host that were originally created with Hyper-V in Windows 8.1 or earlier, you won't be able to use the new virtual machine features until you manually update the virtual machine configuration version. 

To upgrade the configuration version, shut down the virtual machine and then select to Upgrade Virtual Machine Configuration in Hyper-V Manager.  You can also open an elevated Windows PowerShell command prompt, and type: 

 ```PowerShell
Update-VmVersion <vmname> | <vmobject>
```

## How do I check the configuration version of the virtual machines running on Hyper-V? 

To find the configuration version, open an elevated Windows PowerShell command prompt, and run the following command:

**Get-VM * | Format-Table Name, Version**

The PowerShell command produces the following sample output:

```
Name		State		CPUUsage(%)	MemoryAssigned(M)	Uptime				Status					Version
    
Atlantis	Running			0		1024			 	00:04:20.5910000	Operating normally		5.0
    
SGC VM		Running			0		538 	 			00:02:44.8350000	Operating normally		6.2
```


## What happens if I do not upgrade the configuration version?

If you have virtual machines that you created with an earlier version of Hyper-V, some features may not work with those virtual machines until you update the VM version.

Minimum VM configuration version for new Hyper-V features:

| **Feature Name**                       | **Minimum VM version** ||
| :------------------------------------- | -----------------: ||
| Hot Add/Remove Memory                  |                6.0 ||
| Hot Add/Remove Network Adapters        |                5.0 ||
| Secure Boot for Linux VMs              |                6.0 ||
| Production Checkpoints                 |                6.0 || 
| PowerShell Direct                      |                6.2 ||
| Virtual Trusted Platform Module (vTPM) |                6.2 ||
| Virtual Machine Grouping               |                6.2 ||



## Virtual Machine Configuration Version ##

When you move or import a virtual machine to a host running Hyper-V on Windows 10 from host running Windows 8.1, the virtual machine’s configuration file isn't automatically upgraded. This allows the virtual machine to be moved back to a host running Windows 8.1. You won't have access to new virtual machine features until you manually update the virtual machine configuration version. 

The virtual machine configuration version represents what version of Hyper-V the virtual machine’s configuration, saved state, and snapshot files it's compatible with. Virtual machines with configuration version 5 are compatible with Windows 8.1 and can run on both Windows 8.1 and Windows 10. Virtual machines with configuration version 6 are compatible with Windows 10 and won't run on Windows 8.1.

It is not necessary to upgrade all of your virtual machines simultaneously. You can choose to upgrade specific virtual machines when required. However, you won't have access to new the virtual machine features until you manually update the configuration version for each virtual machine.  


----------------
**Important **

• After you upgrade the virtual machine configuration version, you can't move the virtual machine to a host that runs Windows 8.1.

• You can't downgrade the virtual machine configuration version from version 6 to version 5.

• You must turn off the virtual machine to upgrade the virtual machine configuration.

• After the upgrade, the virtual machine uses the new configuration file format. For more information, see New virtual machine configuration file format.

--------





## What happens when I upgrade the version of a virtual machine?
When you manually upgrade the configuration version of a virtual machine to version 6.x, you'll change the file structure that is used for storing the virtual machines configuration and checkpoint files. 

Upgraded virtual machines use a new configuration file format, which is designed to increase the efficiency of reading and writing virtual machine configuration data. The upgrade also reduces the potential for data corruption in the event of a storage failure. 

The following table lists the binary file locations and extension information for an upgraded virtual machine.  

|**Virtual machine configuration and checkpoint files (version 6.x)**|**Description**||
|:---------------|:----------------||
|**Virtual machine configuration** | Configuration information is stored in a binary file format that uses the .vmcx extension. ||
|**Virtual machine Runtime State** | Runtime state data is stored in a binary file format that uses the .vmrs extension.  ||
|**Virtual machine virtual hard disk**|The virtual hard disk files for the virtual machine. They use .vhd or .vhdx file extensions.   ||
|**Automatic  virtual hard disk files**| The differencing disk files used for virtual machine checkpoints. They use the .avhdx file extensions. ||
|**Checkpoint Files** |Checkpoints are stored in multiple checkpoint files. Each checkpoint creates a configuration file and runtime state file. Checkpoint files use the .vmrs and .vmcx file extensions. These new file formats are also used for production checkpoints and standard checkpoints. ||

After you upgrade the virtual machine configuration version to version 6.x, it is not possible to downgrade from version 6.x to version 5. 

The virtual machine must be turned off to upgrade the virtual machine configuration.

The following table lists the default file locations for new or upgraded virtual machines.

|   **Virtual Machine Files (Version 6.x)** | **Description** ||
|:-----|:-----||
|**Virtual machine configuration file**| C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines ||
|**Virtual machine runtime state file**| C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines ||
|**Checkpoint Files (.vmrs, .vmcx)**| C:\ProgramData\Microsoft\Windows\Snapshots ||
|**Virtual hard disk file (.vhd/.vhdx)**| C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks ||
|**Automatic virtual hard disk files (.avhdx)**| C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks ||




