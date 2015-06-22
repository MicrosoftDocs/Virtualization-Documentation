ms.ContentId:2d4f848e-6800-4f68-bfa9-c83544a69d20
title:Connect to a VM with PowerShell

# Connect to a Virtual Machine with Windows PowerShell Direct#

There is a now an easy and reliable way of running PowerShell commands inside a virtual machine from the host operating system. There are no network or firewall requirements or special configuration. It works regardless of your Remote Management configuration.

    Enter-PSSession -VMName VMName
    Invoke-Command -VMName VMName -ScriptBlock { commands }

*Note: PowerShell Direct only works from Windows 10 and Windows Server Technical Preview Hosts to Windows 10 and Windows Server Technical Preview guests.*


Today, Hyper-V administrators rely on two categories of tools for connecting to a virtual machine on their Hyper-V host:\
*  Remote management tools such as PowerShell or Remote Desktop
*  Hyper-V Virtual Machine Connection (VM Connect)

Both of these technologies work well, but each have trade-offs as your Hyper-V deployment grows. VMConnect is reliable, but it can be hard to automate. Remote PowerShell is powerful, but can be difficult to setup and maintain. 

Windows PowerShell Direct provides a powerful scripting and automation experience with the simplicity of VMConnect. Because Windows PowerShell Direct runs between the host and virtual machine, there is no need for a network connection or to enable remote management. Like VMConnect, you do need guest credentials to log in to the virtual machine.

### Requirements ###
You must be connected to a Windows 10 or Windows Server Technical Preview host with  virtual machines running Windows 10 or Windows Server Technical Preview as guests.
You need to be the tool with Hyper-V Administrator credentials on the host.
You need User credentials for the virtual machine.
The virtual machine you want to connect to must be running and booted.


### Supported Commands ###

    Enter-PSSession -VMName VMName
    Invoke-Command -VMName VMName -ScriptBlock { commands }