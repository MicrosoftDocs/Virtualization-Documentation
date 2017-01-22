# Memory scripts

## clear-MemoryReserve-regkey.ps1
Clears the (now deprecated) MemoryReserve registry key if it is set.

This key controls how much memory Hyper-V sets aside for the host.  By default, Hyper-V root reserve is:  
384MB + 30MB per 1GB of physical memory on the host machine.