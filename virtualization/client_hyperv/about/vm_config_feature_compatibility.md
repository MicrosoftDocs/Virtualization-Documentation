ms.ContentId: 41BEE93C-AD69-4503-98EE-FDD8597CB1EB
title: Minimum VM configuration version for new Hyper-V features

# Minimum VM configuration version for new Hyper-V features #

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

## Next Steps ##


