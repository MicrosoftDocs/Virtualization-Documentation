ms.ContentId: 300B0F58-26DE-4F49-809D-8C1828AB071F 
title: Host SKU Differences

Hyper-V has different features depending on the version of Windows in the host and guest environments.

# Host Feature Differences #

<table>
<tr><th>Feature</th><th>Server</th><th>Client</th><th>Notes</th></tr>
<tr><td>Enhanced Session Mode</td><td>√ </td><td>√</td><td>Defaults: Server = off and Client = on</td></tr>
<tr><td>Live Migration</td><td>√</td><td></td><td></td></tr>
</table>


## Windows Server ##

### Features only in Windows Server Hosts ###

The following features are only present on Windows Server hosts:

- RemoteFX
- Live Migration
- Hyper-V Replica
- Virtual Fibre Channel
- SR-IOV

### Features that are limited to a subset of Windows Server Hosts ###

Automatic VM Activation is only available on Windows Server Datacenter hosts.

### Features that are dependent on other Windows Server only features ###

- Hyper-V Clustering
- Shared VHDX (VHDX file must reside on a Windows Server Scale Out File Server Cluster)
- Support for VSS based host backup

### Windows Server Specific Default Settings ###

Enhanced Mode VM Connections are disabled by default on Windows Server hosts
Intercept and VMBus throttling are enabled by default on Windows Server hosts <!--mebersol asks, is this true?  Investigating...-->

## Windows Client ##

### Features that are limited to a subset of Windows Client Hosts ###

Hyper-V is only available on Enterprise and Professional versions of Windows Client.

### Windows Client Specific Default Settings ###

Enhanced Session Mode is enabled by default on Windows Client hosts.

Intercept and VMBus throttling are disabled by default on Windows Client hosts

# Guest Feature Differences #

RemoteFX is only supported when running the Enterprise version of Windows Client inside the virtual machine.