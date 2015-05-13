ms.ContentId:2d4f848e-6800-4f68-bfa9-c83544a69d20
title:Connect to a VM with PowerShell

# Connect to a Virtual Machine with PowerShell #
PowerShell is an amazing tool for scripting and automation.  As such, there is often a need to connect to a virtual machines using PowerShell.

## PowerShell Direct ##
PowerShell direct is a new, zero setup, way of connecting to a virtual machine from the host operating system using PowerShell.

If you're fmiliar with the in-box Hyper-V tools, PowerShell direct is the PowerShell version of VMConnect -- it allows you to connect to a virtual machine with no setup on either the guest or the host, no network, no domain requirments, etc.  So long as you're connecting from the host operating system to a virtual machine located on that physical host and can provide valid guest credentials.

### Requirements ###
### Supported Commands ###