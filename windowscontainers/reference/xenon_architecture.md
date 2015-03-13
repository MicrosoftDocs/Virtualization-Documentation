ms.ContentId:  
title: Xenon Architecture
 
# Xenon Architecture Overview #

**Updated  3/5/2015**

This is an internal only reference for Xenon's architecture.


## Architecture ##
A Xenon container is an Argon container wrapped in a leightweight VM.  Xenon will be managed in the same way as Argons but it has improved multi-tenant security and isolation.

### Utility VM ###
The utility VM is the light weight virtual machine wrapped around an Argon.  It uses high density memory management (What does this mean?), boots SMB over VMBus, and runs with a very minimal set of services.  It provides multitenant resource isolation (What does this imply -- Argon does multi tenant, yes?).

All Argons with the same base image have identical utility VMs.  There is no "legacy" specialization`





