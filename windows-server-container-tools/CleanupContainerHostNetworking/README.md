# CleanupContainerHostNetworking.ps1 - README

## Basic Logs: Capture container host state for troubleshooting
To capture basic logs\* to assist with container network troubleshooting, run this script without any arguments. 
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1
```

## Tracing: Capture logs for reproducible behavior
To capture logs for a specific, reproducible behavior/issue, run this script with the `-CaptureTraces` argument:
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -CaptureTraces
```
> When the script is run with this option, it will give you the following prompt: `Please reproduce issues for troubleshooting now. After completing repro steps, press any key to continue...`. **When this prompt appears, reproduce the behavior/issue that you would like to capture**. Then, after reproducing the issue, **press any key to continue/end the script.**

## Host Cleanup: Remove/reset container networking components on your host
This script can be used to refresh the container-related network components on your host. To perform a host network cleanup, run this script with the `Cleanup` option:
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -Cleanup
```
> *When run with this option, the script will:*
> - Stop/Remove all containers on the host, regardless of their state (you can view all containers on your host using `docker ps -a`)
> - Remove all container networks on the host

TODO In addition to the basic `-Cleanup` option, there is also the `-ForceDeleteAllSwitches` option. This option can be used to unbind...

### \*Info/logs collected for capturing container host state
*Whether it is run without arguments, or with any of the arguments above, as part of its basic logging functionality this script captures:*
- The Host Network Service (HNS) event log (`c:\Windows\System32\winevt\Logs\Microsoft-Windows-Host-Network-Service-Admin.evtx`)
- The System event log (`c:\Windows\System32\winevt\Logs\System.evtx`)
- The HNS.data file (`c:\ProgramData\Microsoft\Windows\HNS\HNS.data`)
- Information on the [Virtual Filtering Platform (VFP)](https://www.microsoft.com/en-us/research/project/azure-virtual-filtering-platform/), virtual switch extension which is running as a service on the host (`PS C:\> Get-Service vfpext`)
- VFP policy information for all virtual switches 
- Docker version (`C:\> docker -v`)
- Docker info (`C:\> docker info`)
- Information on current TCP/IP, DHCP and DNS network configuration values on the host (`C:\> ipconfig /allcompartments /all`)
- The virtual switches on this host (`PS C:\> Get-VMSwitch`)
- The NAT objects on this host (`PS C:\> Get-NetNat`)
- The static mappings configured on the host's NAT instances (`PS C:\> Get-NetNatStaticMapping`)
- The network adapters on this host (`PS C:\> Get-NetAdapter -IncludeHidden`)
- The bindings for the network adapters on this host (`PS C:\> Get-NetAdapterBinding -IncludeHidden`)
- The status of the Windows NAT driver (`PS C:\> Get-Service winnat`)
- The status of the Windows Firewall Service (`PS C:\> Get-Service mpssvc`)
- The HNS registry settings (`PS C:\> Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns`)
- The Hyper-V registry settings (`PS C:\> Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp`)


TODO WARNING: *Currently, this script is not compatible with overlay networking. To avoid system configuration issues, all overlay networks should be removed before `CleanupContainerHostNetworking.ps1` is run.*

