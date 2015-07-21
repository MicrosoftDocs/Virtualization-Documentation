ms.ContentId: C2593EA1-B182-4C71-8504-49691F619158
title: Step 1: Make sure your machine is compatible

# Make sure your machine is compatible

Hyper-V requires a computer with a supported 64-bit processor that has Second Level Address Translation (SLAT). 

4 GB of RAM is required, but you might need more if you want to run multiple virtual machines at the same time.

Only the Profession and Enterprise versions of Windows 10 support Hyper-V.

## Verify Second Level Address Translation (SLAT) compatibility

To verify SLAT compatibility, follow these steps:

1. Open a Windows command prompt and enter **systeminfo.exe**.
2. Towards the end of the output the Hyper-V requirements will be detailed including SLAT compatibility.

![](media\systeminfo.png)

# Next Step: 
[Step 2: Install Hyper-V](walkthrough_install.md)