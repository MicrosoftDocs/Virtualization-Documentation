---
title: Waiting for VMs to restart in a complex configuration script with PowerShell Direct
description: Blog post that discusses the process and what to learn from writing a PowerShell script that builds a demo environment from scratch.
author: scooley
ms.author: scooley
date: 2016-10-11 19:52:55
ms.date: 03/20/2019
categories: hyper-v
---

# Waiting for VMs to restart in a complex configuration script with PowerShell Direct

Have you ever tried to automate the setup of a complex environment including the base OS, AD, SQL, Hyper-V and other components? For my demo at Ignite 2016 I did just that. I would like to share a few things I learned while writing a single PowerShell script that builds the demo environment from scratch. The script heavily uses [PowerShell Direct](https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/vmsession) and just requires the installation sources put into specific folders. In this blog post I’d like to provide solutions for two challenges that I came across: 

* Determining when a virtual machine is ready for customization using PowerShell Direct, and – as a variation of that theme –
* Determining when Active Directory is fully up and running in a fully virtualized PoC/demo environment.



## Solution #1 Determining when a virtual machine is ready for customization using PowerShell Direct

Some guest OS operations require multiple restarts. If you’re using a simple approach to automate everything from a single script and check for the guest OS to be ready, things might go wrong. For example, with a naïve PowerShell Direct call using Invoke-Command, the script might resume while the virtual machine is restarting multiple times to finish up role installation. This can lead to unpredictable behavior and break scripts. One solution is using a wrapper function like this:  This wrapper function first makes sure that the virtual machine is running, if not, the VM is started. If the heartbeat integration component is enabled for the VM, it will also wait for a proper heartbeat status – this resolves the multiple-reboot issue mentioned above. Afterwards, it waits for a proper PowerShell Direct connection. Both wait operations have time-outs to make sure script execution is not blocked perpetually. Finally, the provided script block is run passing through arguments. 

## Solution #2 Determining when Active Directory is fully up and running

Whenever a Domain Controller is restarted, it takes some time until the full AD functionality is available. If you use a VMConnect session to look at the machine during this time, you will see the status message “Applying Computer Settings”. Even with the Invoke-CommandWithPSDirect wrapper function above, I noticed some calls, like creating a new user or group, will fail during this time. In my script, I am therefore waiting for AD to be ready before continuing:  This function leverages the Invoke-CommandWithPSDirect function to ensure the VM is up and running. To make sure that Active Directory works properly, it then requests the local computer’s AD object until this call succeeds. Using these two functions has saved me quite some headache. For additional tips, you can also take a look at [Ben’s tips around variables and functions](https://blogs.msdn.microsoft.com/virtual_pc_guy/2016/09/16/scaling-out-powershell-with-powershell-direct/). Cheers, Lars PS: The full script for building the guarded fabric demo environment for Ignite 2016’s session BRK3124: Dive into Shielded VMs with Windows Server 2016 Hyper-V will be shared through our [Virtualization Documentation GitHub](https://github.com/Microsoft/Virtualization-Documentation/tree/master/demos).
