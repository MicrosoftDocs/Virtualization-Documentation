ms.ContentId: C2593EA1-B182-4C71-8504-49691F619158
title: Step 1 - Operating System and Hardware Compatibility

# Windows 10 Hyper-V System Requirements

Hyper-V on Windows 10 only works under a specific set of Hardware and Operating System configurations. This document briefly discuss the software and hardware requirements of Hyper-V and shows you how to check your system for compatibility with Hyper-V. While this document does not detail every system configuration compatible with Hyper-V, use the guidance here to help you quickly figure out if your current system can host Hyper-V virtual machines.”

## Operating System Requirements

The Hyper-V role can be enabled on these versions of Windows 10:

- Windows 10 Enterprise
- Windows 10 Professional
- Windows 10 Education

The Hyper-V role cannot be installed on:

- Windows 10 Home
- Windows 10 Mobile
- Windows 10 Mobile Enterprise

>Windows 10 Home edition can be upgraded to Windows 10 Professional. To do so open up **Settings** > **Update and Security** > **Activation**. Here you can visit the store and purchase an upgrade.

## Hardware Requirements

While this document does not provide a complete list of Hyper-V compatible hardware, the following items are necessary:
	
- 64-bit Processor with Second Level Address Translation (SLAT).
- CPU support for VM Monitor Mode Extension (VT-c on Intel CPU's).
- Minimum of 4 GB memory, however because virtual machines share memory with the Hyper-V host, you need to provide enough memory to handle the expected virtual workload.

The following items will need to be enabled in the system bios:
- Virtualization Technology - may have a different label depending on motherboard manufacturer.
- Hardware Enforced Data Execution Prevention.

## Verify Hardware Compatibility

To verify compatibly, open up PowerShell or a command prompt (cmd.exe) and type **systeminfo.exe**. This returns information about Hyper-V compatibility.
If all listed Hyper-V requirements have a value of **Yes**, your system can run the Hyper-V role. If any item returns **No**, check the requirements listed in this document and make adjustments where possible.

![](media/SystemInfo_upd.png)

If you run **systeminfo.exe** on an existing Hyper-V host, the Hyper-V Requirements section reads:

```
Hyper-V Requirements: A hypervisor has been detected. Features required for Hyper-V are not be displayed.
```

## Next Step - Install Hyper-V
[Next Step - Install Hyper-V](walkthrough_install.md)
