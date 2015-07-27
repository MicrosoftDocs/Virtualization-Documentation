ms.ContentId: C2593EA1-B182-4C71-8504-49691F619158
title: Step 1: Make sure your machine is compatible

# Make sure your machine is compatible

Only the Profession and Enterprise editions of Windows 10 support Hyper-V. 

Hyper-V requires at least 4 GB of RAM but you might need more if you want to run multiple virtual machines at the same time.

Starting in Windows 10, Hyper-V requires a 64-bit processor with Second Level Address Translation (SLAT).

## Verify compatability

To verify compatability, open PowerShell or a Windows command prompt (cmd.exe) and type: `systeminfo.exe`.  This will give you information about your computer.

All of the items under **Hyper-V Requirements** must have the value if **Yes**.

![](media\systeminfo.png)

	
If Hyper-V is already enabled, the Hyper-V Requirements section will read:  
```
Hyper-V Requirements:      A hypervisor has been detected. Features required for Hyper-V will not be displayed.
```

## Next Step: 
[Step 2: Install Hyper-V](walkthrough_install.md)