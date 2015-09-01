ms.ContentId: C2593EA1-B182-4C71-8504-49691F619158
title: Step 1: Make sure your machine is compatible

# Step 1: Make sure your machine can run Hyper-V
- Only the Pro, Enterprise and Education editions of Windows 10 can host Hyper-V virtual machines. Hyper-V is not available in Windows 10 Mobile / Windows 10 Mobile Enterprise

> Tip: If you're running Windows 10 Home, you can upgrade to Win 10 Pro by right-clicking the **Start** button and then clicking **Settings > Update and Security > Activation**.  **Click on The Go to store** link will take you to a page for [urchasing an upgrade.

- Hyper-V requires at least 4 GB of RAM but you might need more if you want to run multiple virtual machines at the same time.

- Starting in Windows 10, Hyper-V requires a 64-bit processor with Second Level Address Translation (SLAT).

## Verify hardware compatability

To verify compatability, open PowerShell or a Windows command prompt (cmd.exe) and type: `systeminfo.exe`.  This will give you information about your computer.

All of the items under **Hyper-V Requirements** must have the value if **Yes**.

![](media\systeminfo.png)

Relevant sections:
*  `OS Name` -- Must be Windows 8 or higher and either Profession or Enterprise.
*  `Hyper-V Requirements` -- all of these must be true (value of "Yes") but some can be configured in BIOS.
	*  `VM Monitor Mode Extensions` -- Property of the hardware.  Hyper-V can not run on this machine.
	*  `Virtualization Enabled in Firmware` -- Can be enabled in BIOS
	*  `Second Level Address Translation` -- Property of the hardware.  Hyper-V can not run on this machine.
	*  `Data Execution Prevention Available` -- Can be enabled in BIOS
	
If Hyper-V is already enabled, the Hyper-V Requirements section will read:  
```
Hyper-V Requirements: A hypervisor has been detected. Features required for Hyper-V will not be displayed.
```

## Next Step: 
[Step 2: Install Hyper-V](walkthrough_install.md)