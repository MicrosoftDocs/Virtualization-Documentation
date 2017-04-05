# CleanupContainerHostNetworking.ps1 - README

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


