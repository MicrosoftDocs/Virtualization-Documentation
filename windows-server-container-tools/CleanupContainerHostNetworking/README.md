# WindowsContainerNetworking-LoggingAndCleanupAide.ps1 - README
## Basic Logs: Capture container host state for troubleshooting
To capture basic logs\* to assist with container network troubleshooting, run this script *without any arguments*: 
```
PS C:\> .\WindowsContainerNetworking-LoggingAndCleanupAide.ps1
```

## Tracing: Capture logs for reproducible behavior
To capture logs for a specific, reproducible behavior/issue, run this script with the `-CaptureTraces` argument:
```
PS C:\> .\WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -CaptureTraces
```
When the script is run with this option, it will prompt you to reproduce the behavior/issue that you would like to capture. After capturing the behavior, press any key to continue/end the script.

## Host Cleanup: Remove/reset container networking components on your host
This script can be used to refresh the container-related network components on your host. To perform a host network cleanup, run this script with the `-Cleanup` option:
```
PS C:\> .\WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -Cleanup
```
*When run with this option, the script will:*
- Stop/remove all containers on the host, regardless of their state (i.e. runs `docker rm -f <CONTAINER ID>` for all containers)
- Remove all container networks on the host (i.e. runs `docker network rm -f <NETWORK ID>` for all user-defined networks)

In addition to the basic `-Cleanup` option, there is also the `-ForceDeleteAllSwitches` option. *Use these options together to force an extended host cleanup*, in which Switch/NIC registry keys are removed from your host, network adapters are unbound and the host default NAT network is removed, and the HNS.data file is deleted to remove all current HNS configurations.
```
PS C:\> .\WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -Cleanup -ForceDeleteAllSwitches
```
## Assumptions/System Requirements - *READ BEFORE RUNNING SCRIPT*

**WARNING:** This script requires that the host machine is not running in swarm mode. The script will make sure the host is in an inactive swarm state. If the host is in swarm mode, the script will provide an option to leave swarm mode.

This script assumes the following about your system. Ensure these requirements are met before running this script on your system:
- Docker Engine is installed *and running* 
- Microsoft Hyper-V role is enabled 
- The Windows Containers feature is installed

## \*Info/logs collected for capturing container host state
*Whether it is run without arguments, or with any of the arguments above, as part of its basic logging functionality this script captures:*
- The Host Network Service (HNS) event log (`c:\Windows\System32\winevt\Logs\Microsoft-Windows-Host-Network-Service-Admin.evtx`)
- The System event log (`c:\Windows\System32\winevt\Logs\System.evtx`)
- The HNS.data file (`c:\ProgramData\Microsoft\Windows\HNS\HNS.data`)
- Information on the [Virtual Filtering Platform (VFP)](https://www.microsoft.com/en-us/research/project/azure-virtual-filtering-platform/), virtual switch extension which is running as a service on the host (`Get-Service vfpext`)
- VFP policy information for all virtual switches 
- Docker version (`docker -v`)
- Docker info (`docker info`)
- Information on current TCP/IP, DHCP and DNS network configuration values on the host (`ipconfig /allcompartments /all`)
- The virtual switches on this host (`Get-VMSwitch`)
- The NAT objects on this host (`Get-NetNat`)
- The static mappings configured on the host's NAT instances (`Get-NetNatStaticMapping`)
- The network adapters on this host (`Get-NetAdapter -IncludeHidden`)
- The bindings for the network adapters on this host (`Get-NetAdapterBinding -IncludeHidden`)
- The status of the Windows NAT driver (`Get-Service winnat`)
- The status of the Windows Firewall Service (`Get-Service mpssvc`)
- The HNS registry settings (`Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns`)
- The Hyper-V registry settings (`Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp`)



