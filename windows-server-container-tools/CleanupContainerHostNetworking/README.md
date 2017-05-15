# CleanupContainerHostNetworking.ps1 - README

## Basic Logs: Capture container host state for troubleshooting
To capture basic logs to assist with container network troubleshooting, run this script without any arguments. 
```
PS C:\> WindowsContainerNetworking-LoggingAndCleanupAide.ps1
```
*This is the script's default behavior. Whether it is run without arguments, or with any of the arguments below, as part of its basic logging functionality the script captures:*
- The Host Network Service (HNS) event log (`c:\Windows\System32\winevt\Logs\Microsoft-Windows-Host-Network-Service-Admin.evtx`)
- The System event log (`c:\Windows\System32\winevt\Logs\System.evtx`)
- The HNS.data file (`c:\ProgramData\Microsoft\Windows\HNS\HNS.data`)
- Policy information for all virtual switches 
- Information on the [Virtual Filtering Platform (VFP)](https://www.microsoft.com/en-us/research/project/azure-virtual-filtering-platform/), virtual switch extension which is running as a service on the host (`PS C:\> Get-Service vfpext`)
- Docker version (`docker -v`
- Docker info: `docker info`
- Information on current TCP/IP, DHCP and DNS network configuration values on the host (`C:\> ipconfig /allcompartments /all`)
- A list of virtual switches on this host (`PS C:\> Get-VMSwitch`)
- `Get-NetNat`
- `Get-NetNatStaticMapping`
- `Get-Service winnat`
- `Get-Service mpssvc`
- `Get-NetAdapter -IncludeHidden`
- `Get-NetAdapterBinding -IncludeHidden`
- `Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\hns`
- `Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp`

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


