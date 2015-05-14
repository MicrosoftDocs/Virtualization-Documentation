ms.ContentId:2d4f848e-6800-4f68-bfa9-c83544a69d20
title:Connect to a VM with PowerShell

# Connect to a Virtual Machine with PowerShell #
PowerShell is an amazing tool for scripting and automation.  As such, there is often a need to connect to a virtual machines using PowerShell.

## PowerShell Direct ##
It is a new way of running PowerShell commands inside a virtual machine from the host operating system easily and reliably.
There are no network/firewall requirements or configurations.
It works regardless of Remote Management configuration.

    Enter-PSSession -VMName VMName
    Invoke-Command -VMName VMName -ScriptBlock { commands }

*Note: PowerShell Direct only works from Windows 10/Windows Server Technical Preview Hosts to Windows 10/Windows Server Technical Preview guests.*
Please let me know what guest/host operating system combinations you’d like to see and why.

Today, Hyper-V administrators rely on two categories of tools for connecting to a virtual machine on their Hyper-V host:\
*  Remote management tools such as PowerShell or Remote Desktop
*  Hyper-V Virtual Machine Connection (VM Connect)

Both of these technologies work reasonably well but have tradeoffs as a Hyper-V deployment grows.  VMConnect is reliable but hard to automate while remote PowerShell is a brilliant automation tool but can be difficult to maintain/setup.  I often hear customers lament domain security policies, firewall configurations, or a complete lack of shared network preventing virtual machines from communicating with the Hyper-V host it is running.  I’m also sure we’ve all had that moment when we’re using PowerShell to modify a network setting and accidently made it so you can no longer connect to the virtual machine in the process…

PowerShell Direct provides the scripting and automation experience available with PowerShell but with the zero configuration experience you get through VMConnect.  Because PowerShell Direct runs between the host and virtual machine, there is no need for a network connection and no need to enable remote management.  Like VMConnect, you do need guest credentials to log in to the virtual machine.

With that said, there are some PowerShell remote management tools not available yet in PowerShell direct.  We’re working on it, this is the first step.  If you expected something to work and it didn’t, leave a comment.

### Requirements ###
You must be connected to a Windows 10/Windows Server Technical Preview Host with Windows 10/Windows Server Technical Preview virtual machines.
You need to be running as Hyper-V Administrator.
You need user credentials in the virtual machine.
The virtual machine you want to connect to must be running and booted.
I use get-VM as a sanity check.

### Supported Commands ###

    Enter-PSSession -VMName VMName
    Invoke-Command -VMName VMName -ScriptBlock { commands }