# Host Compute System


>**Note: This API will be released in a future Windows build.**

## What is the HCS?
The Host Compute System API provides the functionality to start and control VMs and containers. 

 A compute system represents a VM or container that was created through the API. Operations are performed on handles to a compute system (internally these handles are implemented using RPC context handles). 
Compute systems are ephemeral, meaning that once a VM or container stopped (e.g., a VM was shut down), the compute system is cleaned up and no further operations can be executed on existing handles to the compute system (the only exception is the ability to query the exit status of the compute system). It is the application’s responsibility to create a new compute system to start the VM or container again. 

The operations supported on compute systems include creating, starting and stopping a VM or container. For VMs, additional operations such pause, resume,save and restore are supported. 

For both VMs and containers, the API provides the ability to start and interact with process in the compute system. For containers, this functionality is the primary way that applications create and interact with the workload in the container. 