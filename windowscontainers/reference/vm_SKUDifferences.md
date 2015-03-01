Hyper-V has different features depending on the version of Windows in the host and guest environments.

# Host Feature Differences #

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

### Features that are dependant on other Windows Server only features ###

- Hyper-V Clustering
- Shared VHDX (VHDX file must reside on a Windows Server Scale Out File Server Cluster)
- Support for VSS based host backup

### Windows Server Specific Default Settings ###

Enhanced Mode VM Connections are disabled by default on Windows Server hosts
Intercept and VMBus throttling are enabled by default on Windows Server hosts

## Windows Client ##

### Features that are limited to a subset of Windows Client Hosts ###

Hyper-V is only available on Enteprise and Profesional versions of Windows client.

### Windows Client Specific Default Settings ###

Enhanced Mode VM Connections are enabled by default on Windows Client hosts
Intercept and VMBus throttling are disabled by default on Windows Client hosts