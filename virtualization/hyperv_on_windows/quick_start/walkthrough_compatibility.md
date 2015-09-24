ms.ContentId: C2593EA1-B182-4C71-8504-49691F619158
title: Step 1: Make sure your machine is compatible

## Operating System Compatibility

The Hyper-V role can only be installed on the Pro, Enterprise and Education editions of Windows 10. If you are using the Home, Mobile or Mobile Enterprise edition of Windows 10, the Hyper-V role cannot be used.
Windows 10 Home edition can be upgraded to Windows 10 Professional. To do so open up settings > Update and Security > Activation. Here you can visit the store and purchase an upgrade.

## Hardware Compatibility

While this document will not provide a complete list of Hyper-V compatible hardware the following items are necessary:
	
- 64-bit Processor with Second Level Address Translation (SLAT).
- VM Monitor Mode Extension must be present.
- Minimum of 4 GB memory, however because virtual machines will share this memory with the Hyper-V host, you will want to provide enough memory to handle the expected virtual workload.

The following items will need to be enabled in the system bios:
- Virtualization 
- Data Execution Prevention

## Verify Hardware Compatibility

To verify compatibly, open up PowerShell or a command prompt (cmd.exe) and type `systeminfo.exe`. This will return information about Hyper-V compatibility.
If all listed item have a value of ‘Yes’ your system can run the Hyper-V role. If any item returns ‘No’, check the requirements listed in this document and make adjustments where possible.

![](media/SystemInfo_upd.png)

## Existing Hyper-V Host

If you run systeminfo.exe on an existing Hyper-V host, the Hyper-V Requirements section will read:

```Hyper-V Requirements: A hypervisor has been detected. Features required for Hyper-V will not be displayed.```
 
## Next Step: 
[Step 2: Install Hyper-V](walkthrough_install.md)