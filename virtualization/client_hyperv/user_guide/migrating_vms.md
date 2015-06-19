ms.ContentId: 34D5925A-D724-4552-9403-C2703A973234 
title: Migrating and upgrading virtual machines

# Migrating and upgrading virtual machines 

If you upgrade a computer that has existing virtual machines to Windows 10, no changes are made to the virtual machine configuration settings or the virtual machine checkpoint files. This allows you to move virtual machines to computers that are running different versions of Windows and Hyper-V. 

In Windows 10, you can upgrade your virtual machines to support the latest virtual machine configuration version. This introduces changes to the compatibility, structure, and location of your virtual machine's configuration and checkpoint files. 

## Upgrade the virtual machine configuration version
To upgrade to the latest virtual machine configuration version, open an elevated Windows PowerShell command prompt, and run one of the following commands:

**Update-VMVersion** *vmname*   

Substitute the name of your virtual machine for vmname.



**Note** When you use a Windows PowerShell command to upgrade the configuration version of the virtual machine, you will be notified that any saved states associated with your virtual machine will be removed. This includes saved states associated with checkpoints. 

## How do I check the configuration version of the virtual machines running on Hyper-V? 

To find the configuration version, open an elevated Windows PowerShell command prompt, and run the following command:

**Get-VM * | Format-Table Name, Version**

The PowerShell command produces the following sample output:

    Name		State		CPUUsage(%)		MemoryAssigned(M)		Uptime			Status				Version
    
    Atlantis	Running			0			1024			 	00:04:20.5910000	Operating normally		5.0
    
    SGC VM		Running			0			538 	 			00:02:44.8350000	Operating normally		6.2


## What is the configuration version of a virtual machine?

The configuration version defines the configuration, saved state, and checkpoint compatibility of the virtual machine. Virtual machines with configuration version 5 are compatible with Windows 10 and previous releases of Windows and Hyper-V. Virtual machines with configuration version 6.x are only compatible with Windows 10, and they will not run on earlier versions of Windows and Hyper-V. 

It is not necessary to upgrade all of your virtual machines simultaneously. You can choose to upgrade specific virtual machines when required. However, you will not have access to new virtual machine features until you manually update the configuration version for each virtual machine.  

## What happens if I do not upgrade the configuration version?

Administrators may choose to not upgrade a virtual machines configuration version because they plan to migrate virtual machines to computers that are using different versions of Windows. If you don’t upgrade the configuration version of your virtual machine, you will continue using the same virtual machine file formats for configuration and checkpoint files. You can also import virtual machines to computers running Windows 10, and they will continue to use the original file formats until they are upgraded. 

The following table describes the configuration and checkpoint files that are used for a configuration version 5 virtual machine.

|**Virtual machine configuration and checkpoint files (version 5)** | **Description** 
|:---------|:-----|
|**Virtual machine configuration file (.xml)**| Contains the virtual machine configuration details. There is a configuration file for each virtual machine and for each checkpoint of a virtual machine.  They are always named with the GUID that is used to internally identify the virtual machine or checkpoint. 
|**Virtual machine memory file (.bin)** | Contains the memory of a virtual machine or checkpoint that is in a saved state. 
|**Virtual machine saved state (.vsv)**| Contains the saved state from the devices associated with the virtual machine. 
|**Virtual hard disk File (.vhd/.vhdx)**| These are the virtual hard disk files for the virtual machine. 
|**Automatic  virtual hard disk files (.avhd)** | These are the differencing disk files used for virtual machine checkpoints (formerly known as snapshots).|

## What happens when I upgrade the version of a virtual machine?
When you manually upgrade the configuration version of a virtual machine to version 6.x, you will change the file structure that is used for storing the virtual machines configuration and checkpoint files. 

Upgraded virtual machines use a new configuration file format, which is designed to increase the efficiency of reading and writing virtual machine configuration data. The upgrade also reduces the potential for data corruption in the event of a storage failure. 

The following table lists the binary file locations and extension information for an upgraded virtual machine.  

|**Virtual machine configuration and checkpoint files (version 6.x)**|**Description**|
|:---------------|:----------------|
|**Virtual machine configuration** | Configuration information is stored in a binary file format that uses the .vmcx extension. 
|**Virtual machine Runtime State** | Runtime state data is stored in a binary file format that uses the .vmrs extension.  
|**Virtual machine virtual hard disk**|The virtual hard disk files for the virtual machine. They use .vhd or .vhdx file extensions.   
|**Automatic  virtual hard disk files**| The differencing disk files used for virtual machine checkpoints. They use the .avhdx file extensions. 
|**Checkpoint Files** |Checkpoints are stored in multiple checkpoint files. Each checkpoint creates a configuration file and runtime state file. Checkpoint files use the .vmrs and .vmcx file extensions. These new file formats are also used for production checkpoints and standard checkpoints.

After you upgrade the virtual machine configuration version to version 6.x, it is not possible to downgrade from version 6.x to version 5. 

The virtual machine must be turned off to upgrade the virtual machine configuration.

The following table lists the default file locations for new or upgraded virtual machines.

|   **Virtual Machine Files (Version 6.x)** | **Description** 
|:-----|:-----|
|**Virtual machine configuration file**| C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines 
|**Virtual machine runtime state file**| C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines
|**Checkpoint Files (.vmrs, .vmcx)**| C:\ProgramData\Microsoft\Windows\Snapshots 
|**Virtual hard disk file (.vhd/.vhdx)**| C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks
|**Automatic virtual hard disk files (.avhdx)**| C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks




