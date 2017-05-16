# CleanupContainerHostNetworking.ps1 - README

## Basic Logs: Capture container host state for troubleshooting
To capture basic logs\* to assist with container network troubleshooting, run this script without any arguments. 
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1
```
\* More info below on exactly which logs are captured.

## Tracing: Capture logs for reproducible behavior
To capture logs for a specific, reproducible behavior/issue, run this script with the `-CaptureTraces` argument:
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -CaptureTraces
```
When the script is run with this option, it will first capture the container host state (by collecting "Basic Logging" info described above), then it will give you the following prompt: `Please reproduce issues for troubleshooting now. After completing repro steps, press any key to continue...`. **When this prompt appears, reproduce the behavior/issue that you would like to capture**. Then, after reproducing the issue, **press any key to continue/end the script.**

## Host Cleanup: Remove/reset container networking components on your host
This script can be used to refresh the container-related network components on your host. To perform a host network cleanup, run this script with the `Cleanup` option:
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1 -Cleanup
```
*When run with this option, the script will:*
- Stop/Remove all containers on the host, regardless of their state (you can view all containers on your host using `docker ps -a`)
- Remove all container networks on the host

## Specific logs captured
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


, delete/remove/reset the container networking components on your host.

This script can be run with no options or with the -ForceCleanup option:
* Run script with **no options** to collect HNS evt files for debugging
* Run script with the **-ForceCleanup** option to collect HNS evt files for debugging *and force a host networking cleanup*

WARNING: *Currently, this script is not compatible with overlay networking. To avoid system configuration issues, all overlay networks should be removed before `CleanupContainerHostNetworking.ps1` is run.*

## Option 1: Run `CleanupContainerHostNetworking.ps1` with no options

```none
PS C:\> .\CleanupContainerHostNetworking.ps1
```

This will copy:
 * Microsoft-Windows-Host-Network-Service-Admin.evtx
 * System.evtx
 * HNS data configuration file
 * Details about:
   * IP configurations
   * vm switches
   * WinNAT (Get-NetNat) configurations
 * HNS registry settings

to a temporary log directory. The default location of this log directory is under the current working directory from which the command was run. Alternatively, you can use the **-LogPath** parameter to specify where these log files are saved

## Option 2: Run `CleanupContainerHostNetworking.ps1` with Force Networking Cleanup option

```none
PS C:\> .\CleanupContainerHostNetworking.ps1 -ForceCleanup
```

If you run `CleanupContainerHostNetworking.ps1` with the **-ForceCleanup** parameter, the log collection described above will take place, along with the following cleanup steps:
 * start HNS event tracing
 * **delete** all containers and endpoints
 * clean-up all container host networking items including,
   * Container Networking VM Switches
   * **All** NAT Static port mappings
   * **All** WinNAT (NetNat)
   * Stale Host Networking Service (HNS) registry keys
 * Restart services


