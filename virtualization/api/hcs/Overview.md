# Host Compute System Overview

>**Note: This API will be released in a future Windows build.**

## What is the HCS?
The Host Compute System API provides the functionality to start and control VMs and containers. 

A compute system represents a VM or container that was created through the API. Operations are performed on handles to a compute system. 
Compute systems are ephemeral, meaning that once a VM or container stopped (e.g., a VM was shut down), the compute system is cleaned up and no further operations can be executed on existing handles to the compute system (the only exception is the ability to query the exit status of the compute system). It is the application’s responsibility to create a new compute system to start the VM or container again. 

The operations supported on compute systems include creating, starting and stopping a VM or container. For VMs, additional operations such pause, resume,save and restore are supported. 

For both VMs and containers, the API provides the ability to start and interact with process in the compute system. For containers, this functionality is the primary way that applications create and interact with the workload in the container. 

## Life Cycle Management
A client must configure the necessary resources in the host environment prior to calling the HCS APIs to create and configure the virtual machine. The HCS will not provide functionality to setup resources when creating the virtual machine.  

The three main components include creating the virtual hard disk file (VHD) to act as the VM's disk, [configuring the networking](https://docs.microsoft.com/en-us/windows-server/networking/technologies/hcn/hcn-top), and creating any Hyper-V sockets.  The application configurations and properties will be stored in a JSON file which will then be passed through the HCS APIs to create the compute system. The following sections describes the necessary components and workflow. 

## API References

For a list of the HCS functions, please see [API Reference](./Reference/APIOverview.md)

## JSON Schema References

For a list of JSON Schema References, please see [Schema References](./SchemaReference.md)

## Samples References

Sample codes(./Reference/Tutorial.md) lists the simple workflow by using HCS API to create and manage the virtual machine, as well as samples to use specific functions.

The sample code of how HCS APIs use asynchronous model shows in [Asynchronous Model](./Reference/AsyncModelSample.md)

HCS APIs can be easily used in other languages with Schema-based configuration, which can be generated from JSON Schema file, please see [Generate Schema](./Reference/GenerateSchema.md) 

