ms.ContentId:2d4f848e-6800-4f68-bfa9-c83544a69d20
title:Connect to a VM with PowerShell

# Connect to a Virtual Machine with PowerShell #
PowerShell is an amazing tool for scripting and automation .  As dsuch, there is often a need to connect to a virtual machine using PowerShell.  Right now, there are two ways to connect to a vcirtual machine.

## PowerShell Direct ##
In order to use a custom service integrated with Hyper-V, the new service must be registered with the Hyper-V Host's registry.

By registering the service in the registry, you get:
*  WMI management for enable, disable, and listing available services
*  Onto the list of services allowed to communicate with virtual machines directly.

