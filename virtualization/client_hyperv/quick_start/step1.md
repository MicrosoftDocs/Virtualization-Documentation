ms.ContentId: 1290AB3E-3CC7-4743-8CEC-4599021D475F
title: Step 1: Make sure you can use your machine with Client Hyper-V

# Make sure your machine is compatible #

Client Hyper-V requires a computer with a supported 64-bit processor that has Second Level Address Translation (SLAT). 

4 GB of RAM is required, but you might need more if you want to run multiple virtual machines at the same time.

Only the Profession and Enterprise versions of Windows 10 support Client Hyper-V

## Verify Second Level Address Translation compatibility ##

To verify SLAT compatibility for Client Hyper-V follow these steps:

1. Open a Windows command prompt and enter **systeminfo.exe**.
2. Towards the end of the output the Hyper-V requirements will be detailed including SLAT compatibility.

![](media\coreinfo.png)

# Next Step: #
[Step 2: Install Client Hyper-V](step2.md)