# CleanupContainerHostNetworking

This script can be run with two options to either:
 1) only collect HNS evt files for debugging
 2) collect HNV evt files and force a host networking cleanup

## How to run it

### Log Collection 

First, run `CleanupContainerHostNetworking.ps1` with no options. 

This will copy:
 * Microsoft-Windows-Host-Network-Service-Admin.evtx
 * System.evtx
 * HNS data configuration file
 * Details about:
   * IP configurations
   * vm switches
   * WinNAT (Get-NetNat) configurations
 * HNS registry settings

to a temporary log directory. The default location of this log directory is under the current working directory from which the command was run. Alternatively, you can use the -LogPath parameter to specify where these log files are saved

### Force Networking Cleanup

If you run `CleanupContainerHostNetworking.ps1` with the -ForceCleanup parameter, this will perform log collection as stated above but also:
 * start HNS event tracing
 * **delete** all containers and endpoints
 * clean-up all container host networking items including,
   * Container Networking VM Switches
   * **All** NAT Static port mappings
   * **All** WinNAT (NetNat)
   * Stale Host Networking Service (HNS) registry keys
 * Restart services

