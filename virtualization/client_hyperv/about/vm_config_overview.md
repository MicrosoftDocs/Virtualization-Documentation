ms.ContentId: 459CAC2E-5D03-4923-ADD6-1C4690A207FE 
title: Virtual Machine Configuration File Format Overview

# Virtual Machine Configuration File Format Overview

This topic explains the new virtual machine configuration file format used in Client Hyper-V running on Windows 10®.

Virtual machines now have a new configuration file format which is designed to increase the efficiency of reading and writing virtual machine configuration data. It is also designed to reduce the potential for data corruption in the event of a storage failure. 

**Note:**  The new virtual machine configuration file format only applies new virtual machines created on Windows 10 or to virtual machines running on Windows 10 that have been upgraded to virtual machine configuration version 6. 

## Minimum VM configuration version for new Hyper-V features ##

If you have virtual machines that you created with an earlier version of Client Hyper-V, some features may not work with those virtual machines until your update the VM version.

This topic shows a list of features introduced with Windows 10 and the minimum VM configuration version that is required to use them.

| Feature Name                           | Minimum VM version |
| :------------------------------------- | -----------------: |
| Hot Add/Remove Memory                  |                6.0 |
| Hot Add/Remove Network Adapters        |                5.0 |
| Secure Boot for Linux VMs              |                6.0 |
| Production Checkpoints                 |                    |
| Virtual Trusted Platform Module (vTPM) |                6.2 |
| Virtual Machine Grouping               |                6.2 |

## Upgrade the virtual machine configuration version
To upgrade to the latest virtual machine configuration version, open an elevated Windows PowerShell command prompt and ype the following:

**Update-VMVersion** *vmname*   

Substitute the name of your virtual machine for vmname.

## What has changed? ##
The new configuration files store virtual machine data in two binary files.

 - Virtual machine settings are stored in a configuration file using a **.vmcx** extension. The virtual machine configuration file replaces the .xml configuration file. 

- Runtime data and save state data is stored in a runtime state file using a **.vmrs** extension. 

These new files types replace: 

- .xml contained the virtual machine configuration details. 
- .bin contained the memory of a virtual machine or snapshot that is in a saved state. 
- .vsv contained the saved state from the devices associated with a virtual machine. 

## Do these new configuration files affect Hyper-V checkpoints? 
Unlike previous versions of Hyper-V, the new virtual machine configuration and runtime state files store standard and production checkpoint information. Each time you create a standard or production checkpoint, a new configuration and runtime state file is created. 

## Can I edit the configuration and runtime state files?  
No, you cannot edit Hyper-V virtual machine configuration files. The files are in binary format, directly editing the .vmcx or .vmrs file is not supported.

## Where are the .VMCX and .VMRS files located? 
The configuration files are stored in the **C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines** folder. This folder contains a configuration file (.vmcx), a runtime state file (.vmrs) and a virtual machine folder for each virtual machine. The configuration, runtime state file and virtual machine folder are identified by a virtual machine’s GUID. 

## Which GUID applied to a virtual machine? 
To retrieve a GUID for a matching virtual machine, you can run the following PowerShell script: 

gwmi msvm_virtualsystemsettingdata -namespace root\virtualization\v2 -Filter "VirtualSystemType='Microsoft:Hyper-V:System:Realized'" | %{ write-host "Virtual machine name: $($_.ElementName)"; write-host "Virtual machine ID: $($_.VirtualSystemIdentifier)"; write-host "Configuration file: $($_.ConfigurationDataRoot)\$($_.ConfigurationFile)"; write-host}


This script will produce an output similar to the sample below:

**Virtual machine name**: GateRoomVirtualMachine

**Virtual machine ID:** 3F6E9976-5746-4C54-8825-C32F3BB018D8

**Configuration file:** E:\VirtFS\Gateroom4\ GateRoomVirtualMachine \Virtual Machines\3F6E9976-5746-4C54-8825-C32F3BB018D8.xml


