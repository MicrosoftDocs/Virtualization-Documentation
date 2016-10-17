Demo Environment Script: Dive into Shielded VMs with Windows Server 2016 Hyper-V
================================================================================

This script can be used to create a demo environment for a [guarded fabric](https://technet.microsoft.com/windows-server-docs/security/guarded-fabric-shielded-vm/guarded-fabric-and-shielded-vms) including System Center Virtual Machine Manager 2016.

Please note that this script was not built to check for anything that might go wrong - if you have feedback, please comment. Use at your own risk.

Requirements
------------

The demo environment can be set up on a system running Windows 10, version 1607 or Windows Server 2016.
The host has to have at least the following:
- 32 GB RAM
- 80 GB free disk space

Prerequisites
-------------

Download the sources and add them to the following directories:

| Source | Directory | Download |
| ------ | --------- | ------------------ |
| Windows Server 2016 media | C:\IgniteSource\WindowsServer2016 | [evaluation media](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016) |
| System Center Virtual Machine Manager 2016 media | C:\IgniteSource\VMMWAPDependencies\VMM | [evaluation version](https://www.microsoft.com/en-us/evalcenter/evaluate-system-center-2016) |
| SQL Server 2014 SP2 media | C:\IgniteSource\VMMWAPDependencies\SQL | [evaluation version](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2014-sp2/) |
| Windows ADK for Windows 10, version 1607 | | [download](https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit) |

On the host, Hyper-V and the Hyper-V PowerShell management module have to be installed.

***Notes***
- You can also use the non-evaluation media from MSDN as a source (e.g. System Center VMM)
- For the ADK, run adksetup.exe and choose the option to download the ADK for offline use

Running the script
------------------
In order to successfully run the script and set up the environment, you'll need to update at least two lines in the variables section of the script.
```PowerShell
# The following value needs to be set to /IACCEPTSQLSERVERLICENSETERMS
$IAcceptSqlLicenseTerms = ""

# The following value needs to be set to /iacceptsceula
$IAcceptSCEULA = "" 
```
